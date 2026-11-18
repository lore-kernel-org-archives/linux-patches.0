Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032021;
	b=dpD5/hz12ZO61qqxnUEo9QUDVch0PPV2cd9Lh6+e7ZvMoCVya3hzGDVYP64K19Rhvwl8
	 YaIEzr7OyaYFI3yzy+YMA7fMhfdmIclif2GRDRHUpT4wgbhkKRw2akbZwbDc0sIhFJThv
	 C9Vt00uC3uiituVq97js0zyBqYfwto5rGTFAUQsjxARwGU1gsvhbbhXt8TuYOS1gpAHZu
	 fcqeDNpXJGFsCSj3P3rsW5E7ygmHdsTTxYfi82vChFmEFcY7pJKN47XamCRaGn5JPBoOS
	 MPn6KQHRLARcNlkupHy3Ibcr2wigmqm1nRZtONWoAAiB3mZKntUssXo1iTWUfgVFO2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032021;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1WbbIFH3pPhzhBr9UIvupOURk2Gym3IWUd6AHRud+SQ=;
	b=WGrNLzqpCCv2fUq0kNfSAu30pIwA6El6xKRMPJKbsIqqGEeSDJzAS1f5F3LyiDVYvuom
	 6Vg7aU1YYROaTgCNlsOA4VaDC683bRcX7/DMtNOTbxUMtceLhHI2ZWQgs/XB1Mr7sEsGL
	 9vZX+0+z+oci+1YNXZ2Q5Yfwskl0rWP3ofGSe8bzjKQv3FVe2Cchm733MgG+SObqEuR6M
	 a7tDBjDGHuZRhMG7WSjrvV58f/8pngH2plt9IXC+I2NWviYzP5aX6hHuixDNXlepGi1Fr
	 V0ecBka0f3v08Ai5c6VF3QzTqGgQ+fbzNs9vHobFsMjTHdOV629BRYVpwxmxLY6yD+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="p3j/oloT";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E64606A320;
	Wed, 18 Nov 2026 20:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p3j/oloT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8FF21F000C4;
	Wed, 18 Nov 2026 20:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032021;
	bh=1WbbIFH3pPhzhBr9UIvupOURk2Gym3IWUd6AHRud+SQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p3j/oloT0m4fqhAFM7vCZK4iygfBLKS3dEeALcvbPthUm6RD7uYP5pT5KqH8PhYPk
	 tM6BPdRPosnf0rBhPY8CkVzoBBKolpWqrWO6L2YkPkrT012KRSCma8xOer+qzx5BD5
	 TgaUmvrkbPZ67Kehx4cAeg9HQz0hQUDGaa9CqIRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1264/1756] irqchip/riscv-imsic: Reject overlapping group index fields
Date: Wed, 18 Nov 2026 15:56:31 +0100
Message-ID: <20261118150059.981224565@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 61e30372a67df..36378b1488c32 100644
--- a/drivers/irqchip/irq-riscv-imsic-state.c
+++ b/drivers/irqchip/irq-riscv-imsic-state.c
@@ -710,6 +710,14 @@ static int __init imsic_parse_fwnode(struct fwnode_handle *fwnode,
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



