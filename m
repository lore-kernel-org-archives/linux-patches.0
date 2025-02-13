Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8648426B098;
	Thu, 13 Feb 2025 15:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460808; cv=none; b=Lo6rsGynyWolU3E5OS9KTzdEbsMKJ/XZB4xyPQ7IbKnikE3MnJglzoF+6Xp+867GqQVp/E78aVUX8tc45vpIfZIlLCYPV8vI6jHyr+q7RSN7MNleU7TRs9DcejRAU9qRCuCjHA9NWjDZcSf8i8lZsDoB/KxzR2u8dYXMRH0qf/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460808; c=relaxed/simple;
	bh=//FjETKofN1Hzv9rGd4E3YOdLtOQ76OfsxW5sMDJLdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oF7BasYoQ3kHbXmU6yk7wc/cjc4XeNQL1QpV/VT1QLtO+11bOHgR0pcdCoLk3Cpc2N6WmLK2vr+zPalm8Luq0Od/zAF7xE2Jc3T3uMUnTgVoeCN6VyPzuSf1wqdD2IbFibZL/vGOAabNb8OuW/mR4XDCCNBPge8ID9y1GdLGtIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wqtl+85p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wqtl+85p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE14C4CED1;
	Thu, 13 Feb 2025 15:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460808;
	bh=//FjETKofN1Hzv9rGd4E3YOdLtOQ76OfsxW5sMDJLdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wqtl+85p04GTUWsgRS/hRKU7JxNvGp6V9/yCs5q0OpdfUvSVYC/1ebWcMA/qK45th
	 n75lC4q+H9Y04iIlUL8sUT3n8UvsyLSRW7To28oZp9c1I7sLLk3jvaNQD7JRbw+faE
	 TATFtxmHoqwZ/mf7YVQ0gcWZl3pG6k0kZQQF/vmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 219/273] crypto: qce - fix goto jump in error path
Date: Thu, 13 Feb 2025 15:29:51 +0100
Message-ID: <20250213142415.968839189@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

commit 5278275c1758a38199b43530adfc50098f4b41c7 upstream.

If qce_check_version() fails, we should jump to err_dma as we already
called qce_dma_request() a couple lines before.

Cc: stable@vger.kernel.org
Fixes: ec8f5d8f6f76 ("crypto: qce - Qualcomm crypto engine driver")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/qce/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -247,7 +247,7 @@ static int qce_crypto_probe(struct platf
 
 	ret = qce_check_version(qce);
 	if (ret)
-		goto err_clks;
+		goto err_dma;
 
 	spin_lock_init(&qce->lock);
 	tasklet_init(&qce->done_tasklet, qce_tasklet_req_done,


