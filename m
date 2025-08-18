Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2551031E115;
	Mon, 18 Aug 2025 14:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526073; cv=none; b=nqzTT1Hp0rUQbefrbs6e9Pc8sNfPY3I5w3jlTnqRQ6Z2KvsM1AGAtURey70dTUWBZqLEx2cqzvBH4siTHARBtzm49JsLUEzSe2i+kUk8YoRQTHMTXUUg1vnkC0Bp9BxDjZYfvEtlr+5/lchLvQHrhUf/4l3La1B0Umo9ockObGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526073; c=relaxed/simple;
	bh=t0+H45UstwZlYFBSJ0+xHnWZjSw9ocq/8s+3lAbnV/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ucxM+FjAKlfZ1I591sEoFdNrTZHzmtSH6LsBNgWx9Oqo0izLxpHu99TvEqFIcg7WNFKx5lBwVJwQ2PE1f+lZneIprixee3BAVn2srgGKk2q4wPegodVdsDvPe0lrxdvR+6KBrXBIJjfhk3NJzEtI83CLTBrnhqWtbaYsCMndWhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CIbtm4EQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CIbtm4EQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882B6C116D0;
	Mon, 18 Aug 2025 14:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526073;
	bh=t0+H45UstwZlYFBSJ0+xHnWZjSw9ocq/8s+3lAbnV/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CIbtm4EQ62JlEDsCHf4pffEdtaWlaLEesW0yee9431i1AsFg/PEhXKzmaZBXzD+AY
	 znfm8BEQhXM3sestRCyhmMfZQhNlluyyqxPjj/PhzJvWD525NgBf+ncoCb3/WRFMCf
	 zYfpdC1jqn+VsxXGpaSAbtxT/qgFvdNP9iRh3jnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 418/570] crypto: ccp - Add missing bootloader info reg for pspv6
Date: Mon, 18 Aug 2025 14:46:45 +0200
Message-ID: <20250818124521.946576664@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index e1be2072d680..e7bb803912a6 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -453,6 +453,7 @@ static const struct psp_vdata pspv6 = {
 	.cmdresp_reg		= 0x10944,	/* C2PMSG_17 */
 	.cmdbuff_addr_lo_reg	= 0x10948,	/* C2PMSG_18 */
 	.cmdbuff_addr_hi_reg	= 0x1094c,	/* C2PMSG_19 */
+	.bootloader_info_reg	= 0x109ec,	/* C2PMSG_59 */
 	.feature_reg            = 0x109fc,	/* C2PMSG_63 */
 	.inten_reg              = 0x10510,	/* P2CMSG_INTEN */
 	.intsts_reg             = 0x10514,	/* P2CMSG_INTSTS */
-- 
2.39.5



