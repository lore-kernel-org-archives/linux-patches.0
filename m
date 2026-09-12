Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC0D41F5D8;
	Sat, 12 Sep 2026 09:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206582; cv=none; b=DSPK1fiUv1mVzk3YUEZl2VU56yyI9Ezo0jN3ra+Cp3UmZckWSvwt/suIDK23hOjA7mVZ6qndzofeTxoLrVdMjie1bLeRvqILWctKLQdLWEDHflLSjtHtkyElIqN6EGd0e9Q/eXm+KcqXGqRRWhSyZ/4ow6J4FtBifnfSCaOIv3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206582; c=relaxed/simple;
	bh=uflfe/HVh05Euvnhz/9kvUxPbXxhT/moaNoPo1vfFs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+9AgRdclhaAEWu365REKgWS3iFbqHOJ5ILFv9Np4pJvybRPCOvX1A3+4YEBaSD0qAQKuTYU2LrzfLPZlzl3/pChiMJ4nHjSHL8o4PYt9ScsjJeqBReHXzwu/9/0bWOOivWAu4aQ8WglK5cExYn9ZHNA/Pdm93j9r6HqHj48OvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uChaXBv+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uChaXBv+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA88B1F00893;
	Sat, 12 Sep 2026 09:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206577;
	bh=a0txVipW+UfK3U/BpMKlQ6fe4H0nfqTHI57GZJEZ+lA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uChaXBv+corvQOBpcBvm5by/aFKJrqHPfUB/m2G8JtX0KxSZm0TYrairjWYP01cz5
	 +gAnGvnuJuAYC3qz4Pt2krbN2cI4y1H8kd+u68MZsc+TwrVvsPK8YpE5c0teIlJAOR
	 BYKPLNQebrQSbiZ6g9+Xx+ODCDhwrbUAPY172eGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0229/1518] staging: fbtft: Use sysfs_emit_at() to print to sysfs file
Date: Sat, 12 Sep 2026 08:39:58 +0200
Message-ID: <20260912065628.668541213@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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



