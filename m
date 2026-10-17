Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBB4385D7B;
	Sat, 17 Oct 2026 16:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255657; cv=none; b=JhVV3GYd3VYlJVSEsUGQOmDUQeBzJLqupHrQ/2UhUIyvqX6ienWifcY6Uop0Tl1JsZRQheocwgbTohI4zuhuvHy9kNSqLIFS0ZVCfK8y85v12s3XC/LklV4o+NSLVrKUEB/ka6PRuK0Pi77hUBJk5/yebwyilhxk2QcFvCHZkFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255657; c=relaxed/simple;
	bh=XblhLUTytYD/oUhn4SUspFg9IJN0V3Vs+hkVdVwOXr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XGNAEXfhfuXpzJpyWF9t1WMqBH6pO9nTf7ZnFhYm+ex+PnX367Xbv04XiQFjqiU27MPLe/FPtVvkNxRTT2R2QH4lp5hFOsv2pqi+NH9ExwfEQXqGvOFS9d85jRtTYl92EvCC9WZVom85fmmsURjgXkPbFFTJfK0sslFiwO1a0g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fZNSnesO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fZNSnesO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81A11F000C4;
	Sat, 17 Oct 2026 16:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255656;
	bh=Y+frANdwXg4+i+LgSvURWZH8t9ZKZDMvxc+f1YICSF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fZNSnesO9vP0b1r3YvJ6gbKLPJ6/mtSfh8A1Db/TfNplnLbZ2KeaPzeiSQBkcUdze
	 UyIuGKFq3EqL3MAP/2uVf7YST3SXkm9UrDpuL36qaH1TvJMDvMyvcjuQaZnGry4MYF
	 sj67hHf/xT4WxnxJufTXMG7AEuUweZ654fH0lK0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramses <ramses@well-founded.dev>,
	John <therealgraysky@proton.me>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 849/869] EDAC/igen6: Fix the flood of invalid error reports
Date: Sat, 17 Oct 2026 18:01:30 +0200
Message-ID: <20261017160058.633148827@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit 267e5b1d267539d9a927dc04aab6f15aca57da92 ]

The ECC_ERROR_LOG register of certain SoCs may contain the invalid value
~0, which results in a flood of invalid error reports in polling mode.

Fix the flood of invalid error reports by skipping the invalid ECC error
log value ~0.

Fixes: e14232afa944 ("EDAC/igen6: Add polling support")
Reported-by: Ramses <ramses@well-founded.dev>
Closes: https://lore.kernel.org/all/OISL8Rv--F-9@well-founded.dev/
Tested-by: Ramses <ramses@well-founded.dev>
Reported-by: John <therealgraysky@proton.me>
Closes: https://lore.kernel.org/all/p5YcxOE6M3Ncxpn2-Ia_wCt61EM4LwIiN3LroQvT_-G2jMrFDSOW5k2A9D8UUzD2toGpQBN1eI0sL5dSKnkO8iteZegLoQEj-DwQaMhGx4A=@proton.me/
Tested-by: John <therealgraysky@proton.me>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/r/20250212083354.31919-1-qiuxu.zhuo@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/igen6_edac.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/edac/igen6_edac.c b/drivers/edac/igen6_edac.c
index 3a28b3d6242da..0cf7f8bde6cac 100644
--- a/drivers/edac/igen6_edac.c
+++ b/drivers/edac/igen6_edac.c
@@ -785,13 +785,22 @@ static u64 ecclog_read_and_clear(struct igen6_imc *imc)
 {
 	u64 ecclog = readq(imc->window + ECC_ERROR_LOG_OFFSET);
 
-	if (ecclog & (ECC_ERROR_LOG_CE | ECC_ERROR_LOG_UE)) {
-		/* Clear CE/UE bits by writing 1s */
-		writeq(ecclog, imc->window + ECC_ERROR_LOG_OFFSET);
-		return ecclog;
-	}
+	/*
+	 * Quirk: The ECC_ERROR_LOG register of certain SoCs may contain
+	 *        the invalid value ~0. This will result in a flood of invalid
+	 *        error reports in polling mode. Skip it.
+	 */
+	if (ecclog == ~0)
+		return 0;
 
-	return 0;
+	/* Neither a CE nor a UE. Skip it.*/
+	if (!(ecclog & (ECC_ERROR_LOG_CE | ECC_ERROR_LOG_UE)))
+		return 0;
+
+	/* Clear CE/UE bits by writing 1s */
+	writeq(ecclog, imc->window + ECC_ERROR_LOG_OFFSET);
+
+	return ecclog;
 }
 
 static void errsts_clear(struct igen6_imc *imc)
-- 
2.53.0



