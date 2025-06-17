Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2272E9730;
	Tue, 17 Jun 2025 15:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174391; cv=none; b=Vcnr5OLKuv4x/MSKcdYw4UHj3WwIi4QaSvIM0bpLgOymK12OYJQeUh42oVT9knfHBnX+B4ZBFql9qJrL4KbmVWcJS5lHt7q/yrC9M2wS7B5unmw6MnjkD2AJSQHpC+85Eqfjr7TN1xipK+lQ1jyRVlO0r8/DI9VNoa+innpABsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174391; c=relaxed/simple;
	bh=lIKcML2aNUh+e7VHenMtVTyDP0zq5gRypt6g0TxDnQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ANATuw/t1Y+h8zR25mb9yS65etieUX8rbBnnL+aQseXRek2XVnq47EDgKdDsUohfR4HUZCClNEEiuph8cwed/7Q3/XDugc+81doSllqmunw7BTLx2yYxQHce6nZmPsNMBuPHP3nHqAv+SxtFzdWGTymnabjadYNx/+35h/4dS2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zmxYwUN9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zmxYwUN9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF4DC4CEE3;
	Tue, 17 Jun 2025 15:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174391;
	bh=lIKcML2aNUh+e7VHenMtVTyDP0zq5gRypt6g0TxDnQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zmxYwUN9mEWqCBG+airoBlyubFgBRVxKySu9KKNZ4RVQfqhUL0kdbmLgvQbxzNRw7
	 n4VpK/QxYzzfZHWynGKItvHp84Yc8z4a6f5MLC9/LBmNRtjvoBLVLCOmWY3e0GUQcR
	 zgcZm57RIqTWpZVaDBjXKTsPBYJpjHc8Sey/Qhpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/356] drm/bridge: lt9611uxc: Fix an error handling path in lt9611uxc_probe()
Date: Tue, 17 Jun 2025 17:22:57 +0200
Message-ID: <20250617152340.723182684@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit b848cd418aebdb313364b4843f41fae82281a823 ]

If lt9611uxc_audio_init() fails, some resources still need to be released
before returning the error code.

Use the existing error handling path.

Fixes: 0cbbd5b1a012 ("drm: bridge: add support for lontium LT9611UXC bridge")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/f167608e392c6b4d7d7f6e45e3c21878feb60cbd.1744958833.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/lontium-lt9611uxc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/lontium-lt9611uxc.c b/drivers/gpu/drm/bridge/lontium-lt9611uxc.c
index c41ffd0bc0494..d458a4f37ac8f 100644
--- a/drivers/gpu/drm/bridge/lontium-lt9611uxc.c
+++ b/drivers/gpu/drm/bridge/lontium-lt9611uxc.c
@@ -962,7 +962,11 @@ static int lt9611uxc_probe(struct i2c_client *client)
 		}
 	}
 
-	return lt9611uxc_audio_init(dev, lt9611uxc);
+	ret = lt9611uxc_audio_init(dev, lt9611uxc);
+	if (ret)
+		goto err_remove_bridge;
+
+	return 0;
 
 err_remove_bridge:
 	free_irq(client->irq, lt9611uxc);
-- 
2.39.5



