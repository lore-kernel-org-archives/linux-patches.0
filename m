Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3529547A0C4;
	Sat, 12 Sep 2026 16:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229188; cv=none; b=o+m7FcAeGWVLLFQ8AbKiL/X8dj4R2KnlwQuFCW3L14z6wkNSxDG0iB+vPaKsRp+Gnm3cp+2Arru8bLKJhhP2W+elc3U13Avi1pmI8oSiw+BC2p39PrPNKQJCHSKG1jyAFb12EKCt420AG3O9pctdyskUlaMyAk950AKehCAfNaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229188; c=relaxed/simple;
	bh=xlnd/nQXaXCodS5X8kfrXK1Fu+R6rhw8nCVTRxTfUS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q7A+u5n2ixxY5yoDUxM8jrSaNbOy33vJ4yvXnGIxuZhjkKEXQu5mTrcn9WNaCmYynx8kwfHCPZzfVj8U43ytYdZAXfB9GsJ6zvoCSd/i6xzgoOFODCpPUCrOQLOcqGo367v5fDnqcdywaOAXxFYcJGsGWxAgLlNAYMGo+lXZPmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vEEtqJJk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vEEtqJJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1541F000FF;
	Sat, 12 Sep 2026 16:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229181;
	bh=gSAPsNjJPcdrgLj4Xf9BDq3Z97/86rYk0XEkWanbEjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vEEtqJJkZKF7dlUrzWrrUVpFBr67c/rxqwoUslPdT/hXioEJjzxbf5erjGpomUAt2
	 JxvERnLeplRZ/7buMbvSMJJ+G8UEwTXCXRaqJMCvQya2YE01hbDx30BgKvBdHlheQe
	 MGDQGUNCpTrRVVTLtWWpsSrnO0RSA8v6XULGMM0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0537/1191] staging: fbtft: Use sysfs_emit_at() to print to sysfs file
Date: Sat, 12 Sep 2026 08:54:25 +0200
Message-ID: <20260912065600.311383433@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 221192a784c25e28b489a7e75fabf59be4f63d57 ]

This scnprintf() uses the wrong limit.  It should be "PAGE_SIZE - len"
instead of just PAGE_SIZE.  We're not going to hit the limit in real
life since we are printing at most FBTFT_GAMMA_MAX_VALUES_TOTAL (128)
u32 values, however, it's still worth fixing.

Use sysfs_emit_at() to fix this since this is a sysfs file.

Fixes: c296d5f9957c ("staging: fbtft: core support")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Link: https://patch.msgid.link/ah_Y_Y2RtqeGxchF@stanley.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/fbtft/fbtft-sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/fbtft/fbtft-sysfs.c b/drivers/staging/fbtft/fbtft-sysfs.c
index 39e8d28066cbe..809bf350af253 100644
--- a/drivers/staging/fbtft/fbtft-sysfs.c
+++ b/drivers/staging/fbtft/fbtft-sysfs.c
@@ -102,7 +102,7 @@ sprintf_gamma(struct fbtft_par *par, u32 *curves, char *buf)
 	mutex_lock(&par->gamma.lock);
 	for (i = 0; i < par->gamma.num_curves; i++) {
 		for (j = 0; j < par->gamma.num_values; j++)
-			len += scnprintf(&buf[len], PAGE_SIZE,
+			len += sysfs_emit_at(buf, len,
 			     "%04x ", curves[i * par->gamma.num_values + j]);
 		buf[len - 1] = '\n';
 	}
-- 
2.53.0



