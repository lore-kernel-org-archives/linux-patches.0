Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72992253938;
	Mon, 23 Jun 2025 13:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685979; cv=none; b=MteiW/qJ0TiUKX2za5LTSt0Mw9cfpmH5gAch/GMyk93sqyNA3M/CZNKSbnj9SW9Kf0gW82DaUOTnMWVIegtseMw6cgegWi95cAvR+u5jbDqLp5/yWgBu2jsJesmisooYV7neUOhRLh3+YQwBtCdup95NZcx25ywGSfJf5zBsvzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685979; c=relaxed/simple;
	bh=q8c4mXyK39IawK3/jAn9yrYAByHYieASkSMpEuw4wmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rNY5UTZuykVYByeROEPodz8vTBtgmXIyYekNlcJ0jA4LvoGtHXiLW5kSiKt5Lq2F9GWFoCh1xfT3TMGF2iqvcGr2Xo9YJt+X33Ks+uutCneki4juw3lh3DxlS5dYIqfzlBRs9c/zdvdsyplRzDmWAmtzpybjMb0C1M+BNMSQSXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EbPSAauL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EbPSAauL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943E5C4CEEA;
	Mon, 23 Jun 2025 13:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685978;
	bh=q8c4mXyK39IawK3/jAn9yrYAByHYieASkSMpEuw4wmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EbPSAauLZOg6WriMsL0aG03kiZay3ONUCYJbxVX+9zG/LZxp+lK/UozyY0yJNZVrB
	 JuKhlC8rmMDktVmweaCYG1UXWUyjQRVah7ktoX6rTLB9pNdELrn7BML+zn8VU3xYgS
	 wq4DHu8UikxvwVM8KsBLVVKukYZhBiE9juKggF6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/508] drm/bridge: lt9611uxc: Fix an error handling path in lt9611uxc_probe()
Date: Mon, 23 Jun 2025 15:01:26 +0200
Message-ID: <20250623130646.256330370@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index cb75da940b890..e9162125382f5 100644
--- a/drivers/gpu/drm/bridge/lontium-lt9611uxc.c
+++ b/drivers/gpu/drm/bridge/lontium-lt9611uxc.c
@@ -961,7 +961,11 @@ static int lt9611uxc_probe(struct i2c_client *client,
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



