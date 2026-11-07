Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064316;
	b=Llktfc1TBNX8IxbGYgHddv/ljvQ5ECjvVRJrx7BqgeLFtvhFULnKZm+Ye17S+gkj4xx4
	 icVRQIjdWsSwcXsj39/zEIel9dn/ZfbYAqNQ3xjJsIfnDR0NvBgDPxawV5kmml1exCOgX
	 6Nuh3jJGmmYi+ToFbofsiYhkYqHmTYTZXlgjo6/IxsVgZsexf/cle7FKO5J7V6UPEnX+b
	 Bfg0hlmw8AL/h0vxY7K0yLW1EHH795UGoeqwT/b4NgtlcLtd0Zz3pMOqxXqkAmdHP57O3
	 arQbOvwFAVbbgLh9SQveYiwFRAniTazv5YNkOgHC/+YPlwj1tx7EGypLPfoHC6UpSlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064316;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tu6epZIJWEQVHfZheNjwm6vS5oKJBooNMHKb90mcDKc=;
	b=DUQH/m+XMw/qGgDexFrUdn6AA/QvKmxUAU+smYaBRvlWwqGAV3yNZMGy46/MBSnIYHuB
	 ajvHz0pJxZOGulkmVCRd9gdcBu+bZZSNWovwH9In+Cn6CKm15idBlE77f5Yp7Q2fZCVTD
	 gBSJ/u5fjMSBrGCO0/HC2PlVbWC6u/K/4X5IG5z1VsW/2DC6tgDVycZJ5ZyFZTmF231xG
	 4yKAe/A77OHb4VD1weQkwuC6SH/0qEowkVhAY7uF/9ZKPpo7k4pvtzs7M5/3dcO3ZRMM8
	 gFPn7SUH9nT4oilWjQ+KOlQcm7E1ZXtv4jLNvrUX2CoWIzpH4yNWxCBnQaER6X3Wv8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZI2UAoNO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC83606A9FF;
	Sat,  7 Nov 2026 15:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZI2UAoNO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EED91F0089F;
	Sat,  7 Nov 2026 15:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064315;
	bh=tu6epZIJWEQVHfZheNjwm6vS5oKJBooNMHKb90mcDKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZI2UAoNOgJE66okR/bYWGU8Nxekl5SXkFeeVviYVlcuLHpb3WPPpIzlveEDaksfuE
	 gMv2/gnaqbxbYzkWs4MWnxW6F9VjDHMjo6WqAojR4NUU8uo10EsfkA9neugUAt+PRy
	 Ves1+u9jro0cSZHSyhcsMJzPYHWmG8Ywu1aWNxBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0405/1257] media: mali-c55: fail power-on when safe stop times out
Date: Sat,  7 Nov 2026 08:45:01 -0500
Message-ID: <20261107134950.713090855@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 73d3d5c97c9c0d71ef9ac6bc72520fb1dc547702 ]

The power-on path requests safe stop to establish a non-streaming state but
ignores the polling result and publishes runtime resume success.

Power the block back off and propagate a safe-stop timeout.

Fixes: d5f281f3dd29 ("media: mali-c55: Add Mali-C55 ISP driver")
Cc: stable@vger.kernel.org
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/arm/mali-c55/mali-c55-core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/arm/mali-c55/mali-c55-core.c b/drivers/media/platform/arm/mali-c55/mali-c55-core.c
index f28e9f4354aca..288fba4831808 100644
--- a/drivers/media/platform/arm/mali-c55/mali-c55-core.c
+++ b/drivers/media/platform/arm/mali-c55/mali-c55-core.c
@@ -730,8 +730,13 @@ static int __mali_c55_power_on(struct mali_c55 *mali_c55)
 	/* Set safe stop to ensure we're in a non-streaming state */
 	mali_c55_write(mali_c55, MALI_C55_REG_INPUT_MODE_REQUEST,
 		       MALI_C55_INPUT_SAFE_STOP);
-	readl_poll_timeout(mali_c55->base + MALI_C55_REG_MODE_STATUS,
-			   val, !val, 10 * USEC_PER_MSEC, 250 * USEC_PER_MSEC);
+	ret = readl_poll_timeout(mali_c55->base + MALI_C55_REG_MODE_STATUS,
+				 val, !val, 10 * USEC_PER_MSEC, 250 * USEC_PER_MSEC);
+	if (ret) {
+		dev_err(mali_c55->dev, "safe stop timed out\n");
+		__mali_c55_power_off(mali_c55);
+		return ret;
+	}
 
 	return 0;
 }
-- 
2.53.0



