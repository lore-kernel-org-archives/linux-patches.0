Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923283F1AAD;
	Sat, 12 Sep 2026 07:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197925; cv=none; b=bbA44asIS6sbu1aqtvTwveH2ynOjWEreOio8PjwjGmD2/ED1mncn8gNFHozhbLvMjataK5cLOGootsUs9relhAd6YBaMTDrRyT/vaPcRi0ZJfBoESkAP/0nVckv3IBpw0Oi/A1yOneBA8FpWX1xHc4OZKUMgwJwKuByfsjOGrUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197925; c=relaxed/simple;
	bh=jZ6xLbW1qq08rECkgWNu9ZdmEbrVIWStkc1oWZ7JqYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jULZEKEz11/lTswmRLxyIrusq2IrU5MNhQMWxqm+onWouITlLZPMN2wkN8j0xGabXyK2FEutMsvWgBC2wufoLXnRPP4tHr7g1xOD6wd/NS6k9Az5nQdc+2f5f7a25UNEUc9VvrbCfqL1bmDS06rHOYfAEO2kRIlItlRmPXmf30g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HWOKOJf1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HWOKOJf1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8AB21F000FF;
	Sat, 12 Sep 2026 07:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197924;
	bh=iRgssUKkjxTKU0J6JJ1Kc6zVxvLgcJnKZs55cZImuUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HWOKOJf18r87nRWuyHzpuRlpomh3cuqwyvpkFsBe7wZ2TbWe6BUVvOhIBp/o9aNZK
	 +Ua9aSQ3cpCJGjxI2I5VE/HhMUelEz8PUiRM1ZIRmALKyBTIjWusmSwUa+TBLyfOQr
	 LSPxczu7kO3yDiAUKk5qBrtDOf5qpwCUXceiRif8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0232/1815] staging: fbtft: Use sysfs_emit_at() to print to sysfs file
Date: Sat, 12 Sep 2026 08:33:02 +0200
Message-ID: <20260912065654.438749810@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index d05599d80011a..343545e83a377 100644
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



