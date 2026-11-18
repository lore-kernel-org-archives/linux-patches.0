Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026860;
	b=XVYYmrwn2OEW3/ewJPFFJLLtedr4wU6MWeMclDWEyMokPYegk1/05n2iha+MWNN/73Jx
	 ZG6RePpynONsXJBvubozpqEPgyy+21EY/Qcm0tL1RDZrZHZKLnp6+iIqexYd0GI9Ki2Kd
	 tadLB2hQsNMdAzK8Ih2PUqHp9KiggD8p4syl7kIPFc+aaiXzwoQ4/r589SaFP3YtWJVJR
	 bhSRnwTs55CXtKw3leTNr1SJYTiYHv+A5upQlPNO1ouiOmsME53ry+o4PxxueU103zomk
	 rbYsWEgHjeA8sg4LiroEG92ODMvaX4KPVY3MzwdqY+rDrI/5hLom5SfZABuO5v/JIAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026860;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ShsQTXtEAk5/RNxDBo2voWynMg6Vi6VHsDh+QV3oHmk=;
	b=mAPEiGh1QqqE2yBcvXcgqn091Ax7fHiVpdORBd0MTitUucJMKvw372cIFcB2Ktt8YfXo
	 Xay2tv2vv5aOyScQbTUhSvQ7jgwID7np0D6tqLMmjXeIypDzBlTQ4zHR2PtFAo5mbJJQB
	 xUWdaa9F5KGHInTgA90C679U6uCl9UG+dIq53WgAz+UWk6ueEgfYBmPuTUYhepsuB3oe3
	 FZndQbhqpvCIQj/Yk+k4upH8dfluSTDQORio3QX9srmI0XDEzxwrISe8PsRw6ZnQGg4eW
	 9J2QIVW0oO8sJok0ip5bxwEcC9SjvKEzNNfrh8CC87aKlJnBLETQmvyJARiMVBro7Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YgvU0Fbw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867EB606A31C;
	Wed, 18 Nov 2026 18:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YgvU0Fbw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51E91F000C4;
	Wed, 18 Nov 2026 18:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026860;
	bh=ShsQTXtEAk5/RNxDBo2voWynMg6Vi6VHsDh+QV3oHmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YgvU0FbwoM1GfP98AkaIo1DkCoVkXQYTMhvkBXfSSyYT3oNTUmQH7U62XruU43Krx
	 3y/FxLxiDVaDpJ/VOItDgCw3e2cY+NmTy3kBMs8+v3btNevYE9tyD9nyLSXyKKKAMm
	 8y1frzpSSTcYubu4g4rKrS6i9xxZDxnoPMUxWvhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1584/2151] irqchip/riscv-imsic: Reject overlapping group index fields
Date: Wed, 18 Nov 2026 15:55:19 +0100
Message-ID: <20261118150219.585715908@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit 8caa8fcec8db5358437b9b7ca456bc3093d2a4d0 ]

The IMSIC address layout places the group index above the page offset,
guest index and HART index. imsic_parse_fwnode() checks the individual
field widths and the upper end of the group field, but does not check
that its lower end is above the other fields.

Reject a nonzero group field whose shift overlaps the lower fields.
Otherwise a firmware-supplied layout can assign the same address bit to
different indices when MSI target addresses are constructed.

Keep the existing upper-bound check unchanged. The new lower-bound
check applies only when group index bits are present.

The issue was found by our static-analysis tool.

Fixes: 21a8f8a0eb35 ("irqchip: Add RISC-V incoming MSI controller early driver")
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Assisted-by: gpt 5
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://patch.msgid.link/caplitmus-rv.v2.imsic.f2c0e5bdc627451c83deb0cf7eb8834a@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-riscv-imsic-state.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/irqchip/irq-riscv-imsic-state.c b/drivers/irqchip/irq-riscv-imsic-state.c
index e42be461ae670..120cbde971ab7 100644
--- a/drivers/irqchip/irq-riscv-imsic-state.c
+++ b/drivers/irqchip/irq-riscv-imsic-state.c
@@ -750,6 +750,14 @@ static int __init imsic_parse_fwnode(struct fwnode_handle *fwnode,
 		return -EINVAL;
 	}
 
+	/* Group index bits must not overlap guest and HART index bits. */
+	i = IMSIC_MMIO_PAGE_SHIFT + global->guest_index_bits +
+	    global->hart_index_bits;
+	if (global->group_index_bits && global->group_index_shift < i) {
+		pr_err("%pfwP: group index shift too small\n", fwnode);
+		return -EINVAL;
+	}
+
 	/* Sanity check group index shift */
 	i = global->group_index_bits + global->group_index_shift - 1;
 	if (i >= BITS_PER_LONG) {
-- 
2.53.0



