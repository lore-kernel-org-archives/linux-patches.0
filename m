Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81062EA146;
	Tue, 17 Jun 2025 15:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175707; cv=none; b=ZGXk9s8tvBCg/dn88bmCi9tmi2EDAjxinT/Lngh+PfnkskcRLlSrDD4KaGExNQoa7nllso6NQVQUQ9I6ongcbaNGqlGlNv+lGqsX6ZoTzhJuU02pR+fRqtzw8H0zQlwePmcMrvK7zbpXWAr/hXFa3xCbpEET2jn+JeV4TmA2nEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175707; c=relaxed/simple;
	bh=/d3OTnVGVTlTSelsHPSBMj2JEPOjA0Ou4tHc90Dp9sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJRZlJx+HrRIXIjN0XnruZFF9xOKtYWYBsOiF2SwBkKOEchzkg+2MGw0X4VSDZn8cekaWlljXhTF2eP562CCUmOtaxy0N/hH/38fqxqUOIPp71l8SjUz+7LAbilPgbKk1TX8MzCwBrkWpoHy2odMAlp8krc9w6i0DW4UXCkY4+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FypsggSI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FypsggSI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDCAC4CEE3;
	Tue, 17 Jun 2025 15:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175707;
	bh=/d3OTnVGVTlTSelsHPSBMj2JEPOjA0Ou4tHc90Dp9sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FypsggSIV8IBHAdg7RY9SZCnjXgbjTKPlbmxd4G6EXpsNsK/GVwRz6NLLf5pHwNUp
	 g3D6bZl6Ib4RUNqgAuWqCKlONg+fBRRKTlHFdAOdcTVSSjKoIQX1SVb7IHNaNI60Jm
	 LW1fTvv1X7NAo+TtrTnT51pUAxaIW7YG9SiHgBz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 115/780] drm/bridge: lt9611uxc: Fix an error handling path in lt9611uxc_probe()
Date: Tue, 17 Jun 2025 17:17:03 +0200
Message-ID: <20250617152456.187402400@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index f4c3ff1fdc692..f6e714feeea54 100644
--- a/drivers/gpu/drm/bridge/lontium-lt9611uxc.c
+++ b/drivers/gpu/drm/bridge/lontium-lt9611uxc.c
@@ -880,7 +880,11 @@ static int lt9611uxc_probe(struct i2c_client *client)
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



