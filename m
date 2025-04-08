Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE7B267B89;
	Tue,  8 Apr 2025 12:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114178; cv=none; b=qsdtzUVt7U+XgWTiEV/nEDWCRaqYjoKurvT2JJqzmfzO+Cd4aRBxwGu4h+LWWtnkYeM/VScH0aeA7+3I3eQy9BRTVMbX8df08shIBIaaaPImoieI+85v6rYymSIiUWjea4qndLI1asmBpCEypPcc2v1gKonGu1Uf6SFrCSfSC38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114178; c=relaxed/simple;
	bh=wr5vQgmyAlhDdy6l50Coe9mPaVPoxxvw5lfCeYeATeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kBuXxIB7BSCuNdIsbFgUFIbCuNtuqOhsSSgqtpDtTmhfanQc/jfppcQGSiQkcAZcJnHRQNL95ZIymm+ush3sIXtHG5rx/TmUvXfY90WehL92SvD8Ug/ct90tvNu9XrQ4Foy+yFGYlzGH2UKNBGCWWXpp4HfykhM1MyEKIAiMr7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjK+s3UT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjK+s3UT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FBFDC4CEE5;
	Tue,  8 Apr 2025 12:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114177;
	bh=wr5vQgmyAlhDdy6l50Coe9mPaVPoxxvw5lfCeYeATeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kjK+s3UTsP0fFWjZo0MmEbFgcV09OYoZjeN1G7i1pRoRgLaGe0u5zOcjFSH66xmFC
	 9UfAnhyRYSqUXYKkJ5FzzUYCPQC7euqdA8zDOphLaA2Z2e4NJ5WrGmS/q9BohL+4Nz
	 gi3h6P1HEphCrAv1Mx+xJTKiyTewEFs3Yn6f7mqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramses <ramses@well-founded.dev>,
	John <therealgraysky@proton.me>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 011/499] EDAC/igen6: Fix the flood of invalid error reports
Date: Tue,  8 Apr 2025 12:43:43 +0200
Message-ID: <20250408104851.534345548@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index fdf3a84fe6988..595908af9e5c9 100644
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
2.39.5



