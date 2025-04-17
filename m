Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25E919ABC6;
	Thu, 17 Apr 2025 18:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915739; cv=none; b=aKlIBYsDrQ9jjQivvCmQSB+zLArByKy1xrLMQd59G7UBE23G3uwFwL4eKD5yElkoTVXUlX+37GBN4yz14WJ6hBBPuH/HxuXpWTb+PtUq1xsk6Be9OkOY2qtTLO07iVZYpBgka8aI396fir7UzwUY7mdK86WPza5s/iA5D9GSzDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915739; c=relaxed/simple;
	bh=pK981CXH4fJafBIEhCviBEPt9AOIxvBIBxMFHAmVbKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rrUidQ05hL9u1R1v1k+ya8Cmy32Ob2HvJM5y77yCC8fDLpxXMBwHeHqsimM8xiXA8iT4j64hcpaypCcAmIf/CF8nFgq5Px72LZbuaTapHACCsNs66LqpSxIJKzXU9TVqqKlId0V1lo30MeVlz34Nw8KEw/Zidp8IfJbWUuhMGH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bHVlR1Iy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bHVlR1Iy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD3FC4CEE4;
	Thu, 17 Apr 2025 18:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915739;
	bh=pK981CXH4fJafBIEhCviBEPt9AOIxvBIBxMFHAmVbKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bHVlR1IyEfCEk+cVfH36FF2TddNWz2/8Fb2ukiyDHeC7feumUPZ2dDtKs3sKb8x8L
	 mpc/HIeY+DFa/DX9l9gk6wOTZHu41Ol7uxIdGyGjhcd2wfiaCRCbyBzpQoCv49ex/W
	 slE7BAMWVFDMx/uKJcgfKNA8r6VBFpgiCRRD6mhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Martin=20T=C5=AFma?= <martin.tuma@digiteqautomotive.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 194/393] media: mgb4: Fix switched CMT frequency range "magic values" sets
Date: Thu, 17 Apr 2025 19:50:03 +0200
Message-ID: <20250417175115.392694992@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Tůma <martin.tuma@digiteqautomotive.com>

commit 450acf0840232eaf6eb7a80da11cf492e57498e8 upstream.

The reason why this passed unnoticed is that most infotainment systems
use frequencies near enough the middle (50MHz) where both sets work.

Fixes: 0ab13674a9bd ("media: pci: mgb4: Added Digiteq Automotive MGB4 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Martin Tůma <martin.tuma@digiteqautomotive.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/mgb4/mgb4_cmt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/pci/mgb4/mgb4_cmt.c
+++ b/drivers/media/pci/mgb4/mgb4_cmt.c
@@ -135,8 +135,8 @@ static const u16 cmt_vals_out[][15] = {
 };
 
 static const u16 cmt_vals_in[][13] = {
-	{0x1082, 0x0000, 0x5104, 0x0000, 0x11C7, 0x0000, 0x1041, 0x02BC, 0x7C01, 0xFFE9, 0x9900, 0x9908, 0x8100},
 	{0x1104, 0x0000, 0x9208, 0x0000, 0x138E, 0x0000, 0x1041, 0x015E, 0x7C01, 0xFFE9, 0x0100, 0x0908, 0x1000},
+	{0x1082, 0x0000, 0x5104, 0x0000, 0x11C7, 0x0000, 0x1041, 0x02BC, 0x7C01, 0xFFE9, 0x9900, 0x9908, 0x8100},
 };
 
 static const u32 cmt_addrs_out[][15] = {


