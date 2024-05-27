Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0355D17E90E;
	Mon, 27 May 2024 19:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837043; cv=none; b=u4qkd+2vTwpJHL8wOG03AaQaOWM4vnmzCHkZCqEdfLy3gA2ujAEpOsriH2GG7yhfDCTWlG1tce7u78cOGpQLGzX6TIvCGh30BgVecAfos6dPGQf+b1OSOCty7jlbQY2YPgYMpAg07Q2rbiSdPWTskZ3h372ioWh4SK//lsvL+Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837043; c=relaxed/simple;
	bh=xxyZ79YceEx264L06C+1aNlEV4Ty4mZ8uP3VXvVmmeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kzPlkwRAFTMUFL3yWiACq6mey4ZwFL2mtLCtaDvAojkmrb9bGauI8Ms1uD3BoPmjhjFNyhmbHECdShcz4VLcnah31pw1K8lrX89YJJsAixIeMTwpjp0EZnAgYMr2MxUkajowHSisDtB4wWBksA7YeCKjlFn+bRl5YyZZ8ElUNE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mNdW5ZKG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mNdW5ZKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F93C2BBFC;
	Mon, 27 May 2024 19:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837042;
	bh=xxyZ79YceEx264L06C+1aNlEV4Ty4mZ8uP3VXvVmmeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mNdW5ZKGiwwHccsWNh93K0SfMREzENpZSjwyRIegOx5JxxK/hTWYF0lGRjqP/TNQw
	 HmosZoWIcVudhFA+JUxXQJzQsF5RbXGOqdDV2owDTgVDE/D48ImLt3T1ZB1em4O17Z
	 NV0sDCOEg0x3ex9kqCw0EBHRyHq6/O3x+UtLROc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Korotkov <korotkov.maxim.s@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 289/427] mtd: rawnand: hynix: fixed typo
Date: Mon, 27 May 2024 20:55:36 +0200
Message-ID: <20240527185629.392964291@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxim Korotkov <korotkov.maxim.s@gmail.com>

[ Upstream commit 6819db94e1cd3ce24a432f3616cd563ed0c4eaba ]

The function hynix_nand_rr_init() should probably return an error code.
Judging by the usage, it seems that the return code is passed up
the call stack.
Right now, it always returns 0 and the function hynix_nand_cleanup()
in hynix_nand_init() has never been called.

Found by RASU JSC and Linux Verification Center (linuxtesting.org)

Fixes: 626994e07480 ("mtd: nand: hynix: Add read-retry support for 1x nm MLC NANDs")

Signed-off-by: Maxim Korotkov <korotkov.maxim.s@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20240313102721.1991299-1-korotkov.maxim.s@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/nand_hynix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/nand_hynix.c b/drivers/mtd/nand/raw/nand_hynix.c
index a74e64e0cfa32..c02e50608816a 100644
--- a/drivers/mtd/nand/raw/nand_hynix.c
+++ b/drivers/mtd/nand/raw/nand_hynix.c
@@ -401,7 +401,7 @@ static int hynix_nand_rr_init(struct nand_chip *chip)
 	if (ret)
 		pr_warn("failed to initialize read-retry infrastructure");
 
-	return 0;
+	return ret;
 }
 
 static void hynix_nand_extract_oobsize(struct nand_chip *chip,
-- 
2.43.0



