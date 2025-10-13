Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996BC308F03;
	Mon, 13 Oct 2025 15:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370188; cv=none; b=DcPDY91vYBzsYapJVVjaSvBzXlZMgPzPBctEk7kXlwP4jN13DNdqxiKaTDxTl70jAbT6TjMbIBXNBFzPVIK4r0ta7ss5ZQxhVcsLSjeHNpx3FCKWTSxCpe6TCjEonGgiUbBZoO4LB0ayt/UkOJYDN4b1oTdAT3FJsu6+V1BxZ08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370188; c=relaxed/simple;
	bh=9KPHXDd1zaIoGoRTiJGE8XYjtcuM0T5uviYrQ7EPTrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cvIRcIvmzAWWGaZk3YiULq/k6xjBuX655bGHnZgCvrj9Ck9EGcLH9Cjht7laiz167/n1wp8tKZJuOKyzWCmwdi/XNSGu843N0vcYM4xM1yK5UEwulYyeG4KLO2i78V9mbfITNkt1mCf4cqSYWPYgm3YpfN7cdGE1y/dW5TK/Pbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OM1eFuft; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OM1eFuft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23988C4CEE7;
	Mon, 13 Oct 2025 15:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370188;
	bh=9KPHXDd1zaIoGoRTiJGE8XYjtcuM0T5uviYrQ7EPTrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OM1eFuftYBgfA0kLd8fEbpi+ZidMPjAvdJJ9wooei3tFcRAEZ9kppuubk3iV5qJjm
	 WxLi0Ftw7xjTIcJfHbmRWK7JzRBuTpg9ohEAn5YNeL13F7S3K6pQxzhQRszjtjriQU
	 KdUsR99hw49FmbtZ/Mu9HLNWNGd+2NUB4CEW9Mts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.17 509/563] mfd: rz-mtu3: Fix MTU5 NFCR register offset
Date: Mon, 13 Oct 2025 16:46:10 +0200
Message-ID: <20251013144429.747109519@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>

commit da32b0e82c523b76265ba1ad25d7ea74f0ece402 upstream.

The NFCR register for MTU5 is at 0x1a95 offset according to Datasheet
Page 725, Table 16.4. The address of all registers is offset by 0x1200,
making the proper address of MTU5 NFCR register be 0x895.

Cc: stable@vger.kernel.org
Fixes: 654c293e1687 ("mfd: Add Renesas RZ/G2L MTU3a core driver")
Signed-off-by: Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/r/20250910175914.12956-1-cosmin-gabriel.tanislav.xa@renesas.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/rz-mtu3.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mfd/rz-mtu3.c
+++ b/drivers/mfd/rz-mtu3.c
@@ -32,7 +32,7 @@ static const unsigned long rz_mtu3_8bit_
 	[RZ_MTU3_CHAN_2] = MTU_8BIT_CH_1_2(0x204, 0x092, 0x205, 0x200, 0x20c, 0x201, 0x202),
 	[RZ_MTU3_CHAN_3] = MTU_8BIT_CH_3_4_6_7(0x008, 0x093, 0x02c, 0x000, 0x04c, 0x002, 0x004, 0x005, 0x038),
 	[RZ_MTU3_CHAN_4] = MTU_8BIT_CH_3_4_6_7(0x009, 0x094, 0x02d, 0x001, 0x04d, 0x003, 0x006, 0x007, 0x039),
-	[RZ_MTU3_CHAN_5] = MTU_8BIT_CH_5(0xab2, 0x1eb, 0xab4, 0xab6, 0xa84, 0xa85, 0xa86, 0xa94, 0xa95, 0xa96, 0xaa4, 0xaa5, 0xaa6),
+	[RZ_MTU3_CHAN_5] = MTU_8BIT_CH_5(0xab2, 0x895, 0xab4, 0xab6, 0xa84, 0xa85, 0xa86, 0xa94, 0xa95, 0xa96, 0xaa4, 0xaa5, 0xaa6),
 	[RZ_MTU3_CHAN_6] = MTU_8BIT_CH_3_4_6_7(0x808, 0x893, 0x82c, 0x800, 0x84c, 0x802, 0x804, 0x805, 0x838),
 	[RZ_MTU3_CHAN_7] = MTU_8BIT_CH_3_4_6_7(0x809, 0x894, 0x82d, 0x801, 0x84d, 0x803, 0x806, 0x807, 0x839),
 	[RZ_MTU3_CHAN_8] = MTU_8BIT_CH_8(0x404, 0x098, 0x400, 0x406, 0x401, 0x402, 0x403)


