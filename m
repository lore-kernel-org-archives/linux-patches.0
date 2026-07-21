Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1597F46D093;
	Tue, 21 Jul 2026 17:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655939; cv=none; b=akFzkuoAVnlReoTjHWXjsCFRFtBaoIQ5+4IZ4g0hRK3KuTmuPOKULyzcvqSw8ceaXJ29f04j6O0MDGlLaK6RT0qTFM0Onn/hECbibhjU88/GqxtdBexv8oaTol09vsjfVnN0bXrKecdNGj2q8paNqsS3mfzok2rafkcwkdof48Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655939; c=relaxed/simple;
	bh=SoiA0sYcvBoqYTHkLDM/j9IEwTpDBtJLi+g5hjyO2OU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jFUUuncU1XzsSBhlVrW0pKryMl2dqgk49/RMtPsxvNMd0tgigQzR6G5nrIRr+QJGhQGJZT4y850VQCUH66MpSBZAxMYmJ6CRrwig+zGjKx0QthHveW03+3q2o93wdyKHwbr1Y0JcMA0k5jg12CeD4gBu9O0ax7GDH/yZZzOOg38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fPyY78uV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fPyY78uV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A971F000E9;
	Tue, 21 Jul 2026 17:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655937;
	bh=7uPeNL0gYh9jbVwrCeMvwQo1k0wme2UEWB5xU3EanAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fPyY78uVSO7wmMFBdiK0b15Rwu8saoCVN3lSDR1cGYhJ0VHDOSC7gPjAyfREw5YR6
	 Bzfxi0zqSX0dU+oNaisCIYg5DbfnM1HDLH/MnccYfxdqqvLp5LlN5qd63odI5XKHxW
	 FXSjpmbwQ33yD2FqclucHsF2gFv8EJEVmp//LS6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Larsson <benjamin.larsson@genexis.eu>,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0199/1611] crypto: eip93 - fix reset ring register definition
Date: Tue, 21 Jul 2026 17:05:15 +0200
Message-ID: <20260721152519.430292903@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit 09e6b79b8ce388993aec9ac91b1cb2c181c27bd9 ]

This patch fixes a descriptor ring reset. This causes a hang in the
driver's unload/load sequence.

Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
Suggested-by: Benjamin Larsson <benjamin.larsson@genexis.eu>
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/inside-secure/eip93/eip93-regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-regs.h b/drivers/crypto/inside-secure/eip93/eip93-regs.h
index 116b3fbb6ad791..194436837147cf 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-regs.h
+++ b/drivers/crypto/inside-secure/eip93/eip93-regs.h
@@ -103,7 +103,7 @@
 #define   EIP93_PE_TARGET_COMMAND_NO_RDR_MODE	FIELD_PREP(EIP93_PE_CONFIG_PE_MODE, 0x2)
 #define   EIP93_PE_TARGET_COMMAND_WITH_RDR_MODE	FIELD_PREP(EIP93_PE_CONFIG_PE_MODE, 0x1)
 #define   EIP93_PE_DIRECT_HOST_MODE		FIELD_PREP(EIP93_PE_CONFIG_PE_MODE, 0x0)
-#define   EIP93_PE_CONFIG_RST_RING		BIT(2)
+#define   EIP93_PE_CONFIG_RST_RING		BIT(1)
 #define   EIP93_PE_CONFIG_RST_PE		BIT(0)
 #define EIP93_REG_PE_STATUS			0x104
 #define EIP93_REG_PE_BUF_THRESH			0x10c
-- 
2.53.0



