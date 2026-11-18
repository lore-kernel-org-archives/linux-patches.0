Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020416;
	b=C1b29o1mcxvdbWl6QoNw8BQheA1L/sxgr7n2mK86Ym5vUh0CeBYpptJ6i7I315zl2Xq0
	 UlXS1quE97/XJcD8ODe6ZWgoAhd2nv5musaWS8SjASQ80CLR2WTj9PZBqiE7ENx9pw7tb
	 W6QqnpJ7HQdoaQonDSPhAAd0Fccs74xSTcdoS+tDoQbr/gIMZXB3pZw4Tz8b83ZUFNDXv
	 /vNexip67nttNuj84bJ8Loo6qUf280o5hGkmIy5AkRRgS0MQmLs6pUNz4s9QsGaM8iiOj
	 iJHTZlIcRzKsrEY/9XkF6O4pB6BTIO72q+qcM0/AJGVY0ArQOeNg/xzaViaKip+Uizw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020416;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z+LWriMvA1jxad0dkvG6ManL+y3xEC/w4nBBAPlAD6E=;
	b=xpsMIlDPptkGPFnuXHAkxtp6JWAXI1CA9oILS977z2FCqmKnCjOpsQ6xRHjMb9QiCQza
	 l/jgMdS2U4rU2Bgv/+IbdrJLL+WIn34VT/3sB9fxjlS7/JO0CuHBAOyUVqRdBiCqaF7kt
	 qLtHKV+N+lX1Be/xdGFNT/cfREri6UKnF3cvphkAkcYX5IwwVmDZ6fo3yB35ngQAsC0jn
	 SneYwPzqqFjfDk109zhu91MHfiYGojuGiPvrEY/axlt5M24KViK8r1anhx7flJQTm6O0d
	 rso1/xUP2NoqnGDhTCLxIzBMm33beVdizdCHKMjM44dtdXENG946detJTeADAfWtxsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mbUxmq0p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBE3606A32C;
	Wed, 18 Nov 2026 16:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mbUxmq0p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8DED1F000C4;
	Wed, 18 Nov 2026 16:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020416;
	bh=z+LWriMvA1jxad0dkvG6ManL+y3xEC/w4nBBAPlAD6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mbUxmq0pwrdMTCZMtNQNicj73UFJIEumNQ3YVg3NrG4NONjSSNymICDzCIA26Tjps
	 SzPNf5AOd4+tfKxiN9+rGfHTiTH7VNVka6IzfVfKGFm7qCPqc0/AUsIS/HOodFnKtA
	 oY6wKd6aUPpDOZSZWsZMRW+RYMMXZceFb6mOM2Us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1944/2651] irqchip/riscv-imsic: Reject overlapping group index fields
Date: Wed, 18 Nov 2026 15:53:04 +0100
Message-ID: <20261118150356.592308554@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 9505ddbd9eec9..960c71d6295ba 100644
--- a/drivers/irqchip/irq-riscv-imsic-state.c
+++ b/drivers/irqchip/irq-riscv-imsic-state.c
@@ -740,6 +740,14 @@ static int __init imsic_parse_fwnode(struct fwnode_handle *fwnode,
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



