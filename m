Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D90263C6D;
	Tue,  8 Apr 2025 11:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110298; cv=none; b=fcDNfVH6Rs8iwtEuMypfELaHcutzGEjCAWwxjtgDaTNiol5xVaJbJ/3RPqmZ+r54AlZGZrcCfqj5Z3uD/D7nUkUlYHgJpDamhCdiAc4uGORlfeoYAC1FJzuqaIk+4JtRRs58msQG0f/9G8VzW0bTBUWJRubZ2D1xUFHCAPETgvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110298; c=relaxed/simple;
	bh=WF78N2roc82uDwPFLIAA+IvBSNV5oLzb28bFZkX8Sfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U9CBzyzZsklTkCtb7lP+qUU6mFceiQeHM4hsmccuT+dQaIH1MZbXaaV/4T8di0fezstloOy1yY4eLa/HhneXvNT8uZAa6snax7rRBJya2iMLb4gho8bgB/j8hzpVlhwVuiuZZr1n/Rc40HYr1VeJuMC9jvQzW9az+OIAHSbKp5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MLXH126e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MLXH126e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15293C4CEE5;
	Tue,  8 Apr 2025 11:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110297;
	bh=WF78N2roc82uDwPFLIAA+IvBSNV5oLzb28bFZkX8Sfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MLXH126e8nTLZeWIrps3o98xBdncI2tP7/1oXUnZyvmxP9n3PDDmfP5JJx5+yBKrW
	 M4BNBlQR9uTOZjsRuL0XefAAnA+MR5GuyVOOM2cDxN6m5FQ9JyycJKDDKrfZxwOPId
	 5FXaFShgME0melMEgxudHwq/JWvcOKbRvn4W5vf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramses <ramses@well-founded.dev>,
	John <therealgraysky@proton.me>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 013/731] EDAC/igen6: Fix the flood of invalid error reports
Date: Tue,  8 Apr 2025 12:38:30 +0200
Message-ID: <20250408104914.568454853@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



