Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064906;
	b=iTC5s1ceRzTU4J2zSRPRS969ATBW9hBM4S0gcmZovC7ayfBj/p6CEBvk0uWkT/jGnYWx
	 T/43XIw0ZvceUWGs1tGbm0k4PeG2taGIH40nnBsDmvCOPe1o70WnakTypoBTAzPjTFCU/
	 zDkz9nNsbuspz4/4T8gmZzyp5REs4Tduo3UWhVCkr4SwV+wnCaXhjRcYOyO9aIX8jLGWy
	 pi17L6r/S8Yfs8Ox0jtDnJS8akkCrFUEU0Fqt82CzRLhY6QkaF9CH0lJHhQn5gd3auk5J
	 oYTUcZ03EkSfXE91x1BIHZ7Xb0Wp65Zj/exqcXUhsfbazSUzwTN7cGcpMtnTCCtb32g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064906;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aA/FUHFMSVCv5FHPA+/dIYcLET56TSGzXlvTFY4jwr4=;
	b=av0xlTzP3Ept8aL1805H1T13dbce5ILG4Or9hhuNuCv54q72rOmM4iv/BsdyCnR3bQ2N
	 wllFIlXxbobMnUz7a1cHwxTK/aAB9btjwyGa0psajg0cVFqkq+vjTNQ8SKw+BrDkg/ojz
	 8yECy0eg7oxUunw8NJgQnh2H7BYekS4FpCP/edTerYnJ4rPUnGVQ1CYURlYT+6tiP7OXC
	 xWdjS6+bvaeUy6kFt1dUd+k0rmwoIhVtFw+I9tzQz7oXRVz80l7V+t7liJm+1K7FpfKWA
	 hXMZedx2uZoUsiZiu3VKf+8/mwKU4tzlAi5eQQ4M+zs8YxCtpE+mkMGgWKzcwulL7YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mT57U7EG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D219606A9CA;
	Sat,  7 Nov 2026 15:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mT57U7EG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 075301F0089F;
	Sat,  7 Nov 2026 15:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064906;
	bh=aA/FUHFMSVCv5FHPA+/dIYcLET56TSGzXlvTFY4jwr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mT57U7EGFn5PA+wLDysapvvgVwMAueKC20fc9nON4URrb3+y2Z/vELFxtMxLWAj6n
	 O4Ry2yVPrvVxhLdjrRYJnxSTM/5RSF8zM8ypW1kmC4Qc4k00YqScfk8FGjlX1+cijK
	 yQTsYT4KIWfs2qgW/txbo3dXv+tMqncB/GaLeTQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0791/1257] irqchip/jcore-aic: Fix lost IPIs on SMP
Date: Sat,  7 Nov 2026 08:51:27 -0500
Message-ID: <20261107135001.172250970@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit f556f008f704a8777c73fb3a4177dc57c0dbe769 ]

Since commit bdf4e2ac295fe ("genirq: Allow per-cpu interrupt sharing for
non-overlapping affinities"), handle_percpu_devid_irq() only runs an
action whose affinity mask contains the current CPU. Only actions set up
through the percpu_devid request functions have such a mask.

handle_jcore_irq() passes every per-CPU interrupt to
handle_percpu_devid_irq(). The J2 IPI is not a percpu_devid interrupt.
j2_prepare_cpus() requests it with request_irq() and IRQF_PERCPU, so its
action has no affinity mask and cpumask_test_cpu() reads through a NULL
pointer. J2 has no MMU to catch this. The read returns whatever is at
address 0, the action is not found, and IPIs are dropped as spurious
("Spurious percpu IRQ20 on CPU1", printed once).

Pass only percpu_devid interrupts (the PIT) to handle_percpu_devid_irq()
and the other per-CPU interrupts to handle_percpu_irq() again, as before
commit d7e3fd658248f ("irqchip/jcore-aic, clocksource/drivers/jcore: Fix
jcore-pit interrupt request").

Found with a two-CPU J2 model simulated from the J-Core RTL. Without
this change the boot stalls with both CPUs idle shortly after
"smp: Brought up 1 node, 2 CPUs". With it, the boot reaches userspace.

Fixes: bdf4e2ac295fe ("genirq: Allow per-cpu interrupt sharing for non-overlapping affinities")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Assisted-by: LLM
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260928035408.25871-1-kmehltretter@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-jcore-aic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-jcore-aic.c b/drivers/irqchip/irq-jcore-aic.c
index 94c05cf974be8..b4fee02997eee 100644
--- a/drivers/irqchip/irq-jcore-aic.c
+++ b/drivers/irqchip/irq-jcore-aic.c
@@ -37,8 +37,10 @@ static struct irq_chip jcore_aic;
 
 static void handle_jcore_irq(struct irq_desc *desc)
 {
-	if (irqd_is_per_cpu(irq_desc_get_irq_data(desc)))
+	if (irq_is_percpu_devid(irq_desc_get_irq(desc)))
 		handle_percpu_devid_irq(desc);
+	else if (irqd_is_per_cpu(irq_desc_get_irq_data(desc)))
+		handle_percpu_irq(desc);
 	else
 		handle_simple_irq(desc);
 }
-- 
2.53.0



