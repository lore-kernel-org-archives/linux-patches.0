Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A93F79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:41:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83AE0C433C1;
	Wed, 30 Nov 2022 18:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833715;
	bh=/uWaWHaPrFtUP5djBJuJfzXOcoabazKHkybuFqIVIus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rsCo8qITjKihb+/Tw88dvv1exBhxagOeBPas4CoxrJhWq1aU/tfNdhbkFA8B0MYsz
	 ogY20NLMEBrlxO0cLEq7vI3/dSBk+EhIbUHmr7Njpnvh9o1kqMgWm5k3ET42panMwP
	 w2qDvoxtClzHYDyaQ5TUgyG/4dr+9hJaxT87e8W8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Luiz Capitulino <luizcap@amazon.com>
Subject: [PATCH 5.15 194/206] irqchip/gic-v3: Always trust the managed affinity provided by the core code
Date: Wed, 30 Nov 2022 19:24:06 +0100
Message-Id: <20221130180537.953218305@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luiz Capitulino <luizcap@amazon.com>

From: Marc Zyngier <maz@kernel.org>

commit 3f893a5962d31c0164efdbf6174ed0784f1d7603 upstream.

Now that the core code has been fixed to always give us an affinity
that only includes online CPUs, directly use this affinity when
computing a target CPU.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20220405185040.206297-4-maz@kernel.org

Signed-off-by: Luiz Capitulino <luizcap@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-gic-v3-its.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -1620,7 +1620,7 @@ static int its_select_cpu(struct irq_dat
 
 		cpu = cpumask_pick_least_loaded(d, tmpmask);
 	} else {
-		cpumask_and(tmpmask, irq_data_get_affinity_mask(d), cpu_online_mask);
+		cpumask_copy(tmpmask, aff_mask);
 
 		/* If we cannot cross sockets, limit the search to that node */
 		if ((its_dev->its->flags & ITS_FLAGS_WORKAROUND_CAVIUM_23144) &&


