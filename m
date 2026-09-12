Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E68141A575;
	Sat, 12 Sep 2026 12:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215047; cv=none; b=Ni73gSbX3rXuKdhqCBBR07M8M9/62o3E5BHcwUI7sv3fLmXIwBE6cZAr5E2KLiGkLda284/tvxJ8pXVaG6wJaW6qjEwrCdDRDghLopPkEiPAaZRih5mqrf3KpfJLrG9h9M+JQ7ck477Tyy0EO3qYvFt9yUpLyhO02mYzv5VaeM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215047; c=relaxed/simple;
	bh=pWq0wwddL1YDYJtdSfRqS6kvh8I2yWkqj2dTwYQ4qMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V8uFOycbU6q/kZwSiBkqZiajr34W0VDvuCi9N/NMP5xbTk3jH+9OT50A9T03SJ1ZQrP2ytzxwhGRg9jbnohFVqAEusjZYExbZgn52hBFhEVNF3eiP5KSjr0bJBRtrllfYA9R/ytHv8ERgd7n5/wDu3Ncmj8JC3glxqpRZAd9izA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PCPBoMMp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PCPBoMMp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA121F000FF;
	Sat, 12 Sep 2026 12:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215045;
	bh=EQ0+eGJIpmrzHTn+5EJVC+JsvDNn23dDZjZiUgH8W9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PCPBoMMpxnLRP1k5XTKYDXfLbtvslkKxYKtOzyQvzFSISM9Qz4IFVEH6OjVBdIlAW
	 ZaAdI6tuKf/DINqElpeIzjyLdPN+uhAr2pe8MbDC+36ZW6QGB5xBZKlL4N4TPYzpOt
	 4t3BaXwEeW0/z7JRLGeknEHCaeYFd7cRp2+OduhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0424/1376] staging: fbtft: Use sysfs_emit_at() to print to sysfs file
Date: Sat, 12 Sep 2026 08:47:30 +0200
Message-ID: <20260912065616.985713485@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index e45c90a03a903..7bd6cbf2f1e56 100644
--- a/drivers/staging/fbtft/fbtft-sysfs.c
+++ b/drivers/staging/fbtft/fbtft-sysfs.c
@@ -98,7 +98,7 @@ sprintf_gamma(struct fbtft_par *par, u32 *curves, char *buf)
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



