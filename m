Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72FEE3914ED;
	Thu, 30 Jul 2026 14:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422684; cv=none; b=I90F1PZYJsXTpgOWharLWCo1IJKFFeYcBmrkTq9ePn7m5NGP8se0RlETPcHWCjH9EpondJVasqtQhIHh9SM0aUvyqABAAX6uAZDLLYxmR6AFaN24GyS9FO1sTsDT+YGMcXes8zSdF6g/4BgoP4tbdymks3NBAHqBOQLptBaBImA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422684; c=relaxed/simple;
	bh=6Bbq0aA6Y0K0R+EzAFhmLeXILCFeWmbY5JfQpV3wSfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OYg2dPNA18wIWoJu1do2T7K77IKhCg2+/LGbRS67v4MgHt0rn688KTTy3CXdrGE0vjg/A53hUqVOmNYpGi/xGIUrf23URs876yBVDtwE45i9dAMmkV795e2g9l4XUPq2e02CB+pcBqfF8r+psEV0nMGy8f7SRK6jE2zGWpOPIzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q0gozerp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q0gozerp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869D01F000E9;
	Thu, 30 Jul 2026 14:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422683;
	bh=CRWHzgoVZdRDc+ZLgfsNTqFO3yOpLQgBQ18HfoiJ3kY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q0gozerp9bUQbdhzT5Z0b8F3yq6ifm8CcqdJv2aKrzVwi4NdGKYRogiE/voxPRisR
	 56O6AkQIT1Rr1i0o3ChMqRZncxTsvsApbRAjHTfKFl9haiXTt7UrNQQW1yCs69sQ0t
	 peUpee+UiE2SWe/kFkXjNOgCSCj9Mw/6ZgT+10FU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 523/744] media: ti: vpe: Fix the error code of devm_request_irq()
Date: Thu, 30 Jul 2026 16:13:16 +0200
Message-ID: <20260730141455.390574437@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

commit 5e78a431a3f74c632351791d7902c60199d1ce83 upstream.

Return the actual error code from devm_request_irq() instead of
incorrectly returning -ENOMEM.

Fixes: fc2873aa4a21 ("media: ti: vpe: Add the VIP driver")
Cc: stable@vger.kernel.org
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/ti/vpe/vip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/ti/vpe/vip.c b/drivers/media/platform/ti/vpe/vip.c
index a3c5e966f64c..bd34c982b427 100644
--- a/drivers/media/platform/ti/vpe/vip.c
+++ b/drivers/media/platform/ti/vpe/vip.c
@@ -3472,7 +3472,7 @@ static int vip_probe_slice(struct platform_device *pdev, int slice)
 	ret = devm_request_irq(&pdev->dev, dev->irq, vip_irq,
 			       0, VIP_MODULE_NAME, dev);
 	if (ret < 0)
-		return -ENOMEM;
+		return ret;
 
 	spin_lock_init(&dev->slock);
 	mutex_init(&dev->mutex);
-- 
2.55.0



