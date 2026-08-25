Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0E8417BF9;
	Tue, 25 Aug 2026 13:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665667; cv=none; b=NmNNNncK2OX0DK+0yJZufokZIBYDRpxTPXCmE+9zzCbpEP2zfN8/goWOeEMHrQtd85nIA6lC83JBsxXJBtxuFvwy6sat8O7qRYRKaaBDEX6nnRi4DqV89BSl1D1pCiTFkNNv5S/8xIO2AkNFECi8s33TNPURIYN0kCfbJREZQ6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665667; c=relaxed/simple;
	bh=CUN3riRMxS3Jd/CK+BXd+1vAy71uw9SdK+VIRJbhJ9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DbNO7KuPvAcX9ACHzQsxUQVw4trZgn68qsRSfV9+KBU0etJfQJEq9t2/hXXAIz2m5m27prdB8L57KCAgPy4olRLX/BU0c6xwZnsElFAv6sJ25zmbUnrbjkVQWTqHI/8YReCmrxn0IDksldhs8SFuE/eFpsxcKpgsfilT/R56CH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o45CTQfc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o45CTQfc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777A01F000E9;
	Tue, 25 Aug 2026 13:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665666;
	bh=kl4rTbep0B8iRu82quW0VEtBu2JjcAFflqjT8e0oaFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o45CTQfcAVndUOJiE5uqBp2qrd5aHbmTCbBMchTvIHMX5IMooEtuvawdj7EGxcJSA
	 E7BC1vpCa5zdVDGqFHQaR4+0wBWTmm12Sq7md5I7Zrli/igIf7jDsgs0P+qCcQgqma
	 eKtcHKpd4I+9F1XHrsmed+EYtFl/axeTwvHmCMds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lech Perczak <lech.perczak@camlingroup.com>,
	Andy Shevchenko <andy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 09/87] serial: sc16is7xx: fix copy-paste errors in EFR_SWFLOWx_BIT constants
Date: Tue, 25 Aug 2026 15:25:32 +0200
Message-ID: <20260825132542.186488177@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
References: <20260825132541.813800447@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lech Perczak <lech.perczak@camlingroup.com>

[ Upstream commit eccdb0fd1c340155666533f5c60c5229d370baab ]

Comments attached to bits 0 and 1 incorrectly referenced bits 2 and 3,
which don't match the datasheet - fix them.
At the same time remove comments for individual constants, as they add
nothing to the definitions themselves.

Signed-off-by: Lech Perczak <lech.perczak@camlingroup.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Link: https://lore.kernel.org/r/2986a485-935d-4ab2-9a16-4a85288aa15a@camlingroup.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 246ac114f485 ("serial: sc16is7xx: enable THRI before filling TX FIFO")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -263,9 +263,9 @@
 						  * and writing to IER[7:4],
 						  * FCR[5:4], MCR[7:5]
 						  */
-#define SC16IS7XX_EFR_SWFLOW3_BIT	(1 << 3) /* SWFLOW bit 3 */
-#define SC16IS7XX_EFR_SWFLOW2_BIT	(1 << 2) /* SWFLOW bit 2
-						  *
+#define SC16IS7XX_EFR_SWFLOW3_BIT	(1 << 3)
+#define SC16IS7XX_EFR_SWFLOW2_BIT	(1 << 2)
+						 /*
 						  * SWFLOW bits 3 & 2 table:
 						  * 00 -> no transmitter flow
 						  *       control
@@ -277,10 +277,10 @@
 						  *       XON1, XON2, XOFF1 and
 						  *       XOFF2
 						  */
-#define SC16IS7XX_EFR_SWFLOW1_BIT	(1 << 1) /* SWFLOW bit 2 */
-#define SC16IS7XX_EFR_SWFLOW0_BIT	(1 << 0) /* SWFLOW bit 3
-						  *
-						  * SWFLOW bits 3 & 2 table:
+#define SC16IS7XX_EFR_SWFLOW1_BIT	(1 << 1)
+#define SC16IS7XX_EFR_SWFLOW0_BIT	(1 << 0)
+						 /*
+						  * SWFLOW bits 1 & 0 table:
 						  * 00 -> no received flow
 						  *       control
 						  * 01 -> receiver compares


