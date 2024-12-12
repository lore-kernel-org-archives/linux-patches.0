Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C832185A0;
	Thu, 12 Dec 2024 15:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018149; cv=none; b=p1pkqBmHsTOx1rzkXlWfa8qTYis5ODPRCb2I4JG8PynZfiZnmO+0ISSKgW5a9ERgHG2uaJGqzhbHQAt0BV7yz7/yECTbVvKVaGOJ4urSsnN18S/V02ssKvchpdV+mTFx4NwiJt2c+xysW6XKyAHbq5jzFEoLospYdivG3BeFXAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018149; c=relaxed/simple;
	bh=cCbHH3W3g7TU33sAcOU5DJ5sCsoy6LL1Qt3kbVA9gNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCGsTcTap8u+gUAlMjnGEnC/kKE2kPTAxAxneEQvkcCCaEb+J+2BIKN6j3oUsse+k/y2MXaOQFb7gyHg4RrLsOD8E9fjgRtJgOWdSbuH+bvXiEl9Ke0TJIwGyohO7Fg6EgxMVdM5+4pQMZStODHh2sjSytNZcHAuGcfDMe8AH54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JdJdJ4X/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JdJdJ4X/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9CBC4CECE;
	Thu, 12 Dec 2024 15:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018149;
	bh=cCbHH3W3g7TU33sAcOU5DJ5sCsoy6LL1Qt3kbVA9gNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JdJdJ4X/JPzGVTkeMMZNQXAsi9FW+/5a5EzajCP3c8/Gtdz8ZYHPYaEafgISX+Ps/
	 m6OhejfiTVFdah6n6m5+KTexJGRgzcnsKmfy2toOgUyFlpwnz0QlIbKFmBaJpK7SJY
	 //Z7IUsyy6Qqc/hYTzRa0rx7kkSLj5NqgDp1EKhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 211/356] drm/bridge: it6505: Enable module autoloading
Date: Thu, 12 Dec 2024 15:58:50 +0100
Message-ID: <20241212144252.951620296@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Liao Chen <liaochen4@huawei.com>

[ Upstream commit 1e2ab24cd708b1c864ff983ee1504c0a409d2f8e ]

Add MODULE_DEVICE_TABLE(), so modules could be properly autoloaded based
on the alias from of_device_id table.

Signed-off-by: Liao Chen <liaochen4@huawei.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240902113320.903147-2-liaochen4@huawei.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it6505.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/bridge/ite-it6505.c b/drivers/gpu/drm/bridge/ite-it6505.c
index 2a7c620626a03..26d3b9b843267 100644
--- a/drivers/gpu/drm/bridge/ite-it6505.c
+++ b/drivers/gpu/drm/bridge/ite-it6505.c
@@ -3503,6 +3503,7 @@ static const struct of_device_id it6505_of_match[] = {
 	{ .compatible = "ite,it6505" },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, it6505_of_match);
 
 static struct i2c_driver it6505_i2c_driver = {
 	.driver = {
-- 
2.43.0



