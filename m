Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3225367B69;
	Wed, 20 May 2026 16:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294988; cv=none; b=bc/d5xyhr4A/S0hZa2xpkItJbfpxELOxjLLBMlscVqPtHgPss6zwkVae6TS/JPo6sQ0B5TACyWEepOkisksN3bcRZnAd0Q/PcIq5+8JbAzwl7Ri/vscZmnJ5AZgmO3LkQuuPoF8lRpe2ULMK97xnRSGIPxwi00n/TX5nysQRtE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294988; c=relaxed/simple;
	bh=6xsvm2vFBD744Y2Qm8OIzO5fnK9zymWlJpeGQXa4XgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BRJ22nw3ggE7foCyUWjHunFuCI6ZzmZ9esgLBvnRy6D/ahyIiOQQlu7jaDzh6lBn8zmTfZ2aZD/moj+PlXys2RLj7chaSuCB/SQKWojbBiEUuPbSyjdILf11mBVHHo93YsIzUw+9z73S4DLLIpGQafJ74B8bMGGCt+Apr/t4oQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=guKycRWZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="guKycRWZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95371F000E9;
	Wed, 20 May 2026 16:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294987;
	bh=EJSZ7usTHN99ZKDdoMm0FwouEqux8va+DahDneF5xx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=guKycRWZ8guILw2uvCa65cM4VEqC4RBNm7KzWWZzgs64m74PWYFf2joz0yWNJ3RQd
	 DboNsL0L9jDNJ47lrXCi7YpjRrEto1FopM3nH2a+5MAK9ZzQbNFxFbCAN6MQtdClPk
	 atGQ7WMJ5ohYt4N0GG40tJr1lOEXbkGzQmF6L7KM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0247/1146] crypto: inside-secure/eip93 - fix register definition
Date: Wed, 20 May 2026 18:08:17 +0200
Message-ID: <20260520162153.826727648@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit b7abbc8c7acaeb60c114b038f1fa91bbedb3d16a ]

Checked the register definitions with the documentation[1]. Turns out
that the PKTE_INBUF_CNT register has a bad offset. It's used in Direct
Host Mode (DHM). The driver uses Autonomous Ring Mode (ARM), so it
causes no harm.

1. ADSP-SC58x/ADSP-2158x SHARC+ Processor Hardware Reference
Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/inside-secure/eip93/eip93-regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-regs.h b/drivers/crypto/inside-secure/eip93/eip93-regs.h
index 0490b8d151311..116b3fbb6ad79 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-regs.h
+++ b/drivers/crypto/inside-secure/eip93/eip93-regs.h
@@ -109,7 +109,7 @@
 #define EIP93_REG_PE_BUF_THRESH			0x10c
 #define   EIP93_PE_OUTBUF_THRESH		GENMASK(23, 16)
 #define   EIP93_PE_INBUF_THRESH			GENMASK(7, 0)
-#define EIP93_REG_PE_INBUF_COUNT		0x100
+#define EIP93_REG_PE_INBUF_COUNT		0x110
 #define EIP93_REG_PE_OUTBUF_COUNT		0x114
 #define EIP93_REG_PE_BUF_RW_PNTR		0x118 /* BUF_PNTR */
 
-- 
2.53.0



