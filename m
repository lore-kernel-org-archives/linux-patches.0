Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA1328C849;
	Mon, 18 Aug 2025 13:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522462; cv=none; b=fOObVj3F60bY9lbu9tM5cZtbE1Rq8ySNc3+Dhf3AAKPlWKvbYeAtJn9/ttE+zjQtbonuvtYLtU0PmA8/08m5rLRnP8g1k8miba+wjnsZb+1tU4LluTQtyYjGowjcvSv/ivXKg2GeFCzaJ/xKv39A2A/a0FCtf8gibKjqOCq9eGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522462; c=relaxed/simple;
	bh=qB5lIvAgY9Rv/UY/WNouE03KzILJmpItghat6sjzLBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h/oJJOLEVPeq3kPpABUWvLXnDbYwRAR8x02YxbJTwOvcvHcJTVAgjI02NFg+OjKoQtOFgOpbj4uitQct12pTdKdpnyfyFaYsQ/HhrG43zcwD975xxLM8vLfVs4FzQO0wMt3zfuN21JXutNMlo4nGNh+ZXd2ApvrGYqkGcpxOoJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iZOFgOPG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iZOFgOPG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC93C4CEF1;
	Mon, 18 Aug 2025 13:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522461;
	bh=qB5lIvAgY9Rv/UY/WNouE03KzILJmpItghat6sjzLBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iZOFgOPGCv2omhgFQbzjA+8B/cOJQdSe9XDUshpxc9in01wYEQUazFNORrWpDfDKu
	 0Ie7ajgiOi9sCaGCmLmCbLi0Lh40RyxuFqhufcZGYp0+Lj+FpBSfclEArbxNWuofjo
	 MUyJtneW4hsiDGj2mmEJWQ4TUut/YKAK37/GKlJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 322/444] crypto: ccp - Add missing bootloader info reg for pspv6
Date: Mon, 18 Aug 2025 14:45:48 +0200
Message-ID: <20250818124501.016378904@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit aaeff14688d0254b39731d9bb303c79bfd610f7d ]

The bootloader info reg for pspv6 is the same as pspv4 and pspv5.

Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sp-pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index 2ebc878da160..224edaaa737b 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -451,6 +451,7 @@ static const struct psp_vdata pspv6 = {
 	.cmdresp_reg		= 0x10944,	/* C2PMSG_17 */
 	.cmdbuff_addr_lo_reg	= 0x10948,	/* C2PMSG_18 */
 	.cmdbuff_addr_hi_reg	= 0x1094c,	/* C2PMSG_19 */
+	.bootloader_info_reg	= 0x109ec,	/* C2PMSG_59 */
 	.feature_reg            = 0x109fc,	/* C2PMSG_63 */
 	.inten_reg              = 0x10510,	/* P2CMSG_INTEN */
 	.intsts_reg             = 0x10514,	/* P2CMSG_INTSTS */
-- 
2.39.5



