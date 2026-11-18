Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045303;
	b=OYrwT9jnYxDlf4UfKDCgUdBZ10Y+1qsqvkAKK5qH3S0gip8sT1VWLUTMCihARQEtSLhN
	 gj7uINcxubPKbxwpfKgjfuashqIShqVhMIvo4FM45ixJDBdVyXaTd2mkI1VhLZYUwoQ/1
	 zOuJVSlwH7h5roxVvP8fxpHW9hmmkW20zTE79FwqvqCECsBr7cr71EE8xlAHpawEq2sb3
	 GZ9dydDknGz+OgUcTougJMNRpVVSVG8FG7PG7AFr86uYZjzpguGKliOY87JH1/qIrj6w1
	 5iSjStAscjAwZI6Vyahiv/Get3RrUB/r/Yk63OA5d7DTQjBNvVDHDYZgle1rcPm23bA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045303;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GYukcRV5YDAClbVgSbJPmd0haxk1mwiR1OA3HudcR0Q=;
	b=LeuiyeWCE/3Wadghx8aoZ4F8Fb2OEnFVsmWGFZx3K2SGcHH8bXm0LVsbIhV3DpRYhWIp
	 7Om3xgRXdR54Qw4DqUOVoWsD6qdNDb3+exkrBMQDAyPehCz9q+1LIW0Pmne7pFoNPqXsP
	 yqM8Mf+au84/BdMrR70PXO5J8pYCLMaAhXf5sumFXgU9WFNkKT13MsH9I2rN3GOjbe7ka
	 58vmhGh7KEQBHfA3w06YtALtuDj2C69cA1WbWwsKo+tUMxM2e4CbQ6qxQsH3mfOLAmWfQ
	 5OIdl5INiYqpbGLty8YqhTWD3wANygLIKXW43LpRrJJc7LCjjmS45nqFWGurkQdshww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=axBht7LE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69158606A31C;
	Wed, 18 Nov 2026 23:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=axBht7LE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6AF1F000C5;
	Wed, 18 Nov 2026 23:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045303;
	bh=GYukcRV5YDAClbVgSbJPmd0haxk1mwiR1OA3HudcR0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=axBht7LEnHPluaA+FrZrHC0mY+bKG6Bk+Y4EiTgIttLVF4UAnS/WbbsjnOYjI8rvf
	 rTOoBkR9tGps11KUGxHY5JSvhbNhDeCL23hYNwUIUB1pu9ROybuhE0lfLmD/pZQ6u3
	 Tr6YXHNmywIs/PImFwpOzh9tN3iCoUSyOp9y9iCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Liu <1298662399@qq.com>,
	Ming Qian <ming.qian@nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0874/2857] media: amphion: fix runtime PM imbalance on probe failure
Date: Wed, 18 Nov 2026 15:31:48 +0100
Message-ID: <20261118150233.032021498@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Liu <1298662399@qq.com>

[ Upstream commit 0cabf27cf1e6f7ee5f3c5893c0f1930814d949af ]

vpu_core_probe() enables runtime PM before calling
pm_runtime_resume_and_get().

If pm_runtime_resume_and_get() fails, it has already dropped the runtime PM
usage counter that it acquired before trying to resume the device.  Calling
pm_runtime_put_noidle() again on this error path drops the counter one
extra time.

Remove the extra put and keep the existing cleanup that marks the device
suspended before disabling runtime PM.

Fixes: 9f599f351e86ac ("media: amphion: add vpu core driver")
Cc: stable@vger.kernel.org
Signed-off-by: Jiawen Liu <1298662399@qq.com>
Reviewed-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vpu_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/amphion/vpu_core.c b/drivers/media/platform/amphion/vpu_core.c
index c054fde2b754e..8251738dbbcea 100644
--- a/drivers/media/platform/amphion/vpu_core.c
+++ b/drivers/media/platform/amphion/vpu_core.c
@@ -689,7 +689,6 @@ static int vpu_core_probe(struct platform_device *pdev)
 	pm_runtime_enable(dev);
 	ret = pm_runtime_resume_and_get(dev);
 	if (ret) {
-		pm_runtime_put_noidle(dev);
 		pm_runtime_set_suspended(dev);
 		goto err_runtime_disable;
 	}
-- 
2.53.0



