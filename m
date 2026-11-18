Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030947;
	b=uLqpsrU7St45e3vkSDxCnqwkD8utaTOADLgpsADx0A4MgeUS+Gmf6Nyf2Ba7FOvdinis
	 RLKdb4eXvW8UaxfGNSCYHNdT5bBKAdwrGMfndVzpSyR0elZbIoDr39zFbbOdbdNeV4ARU
	 RsS9KcVpo+dNRisi77Xb1pvOhcUWgOu3BdpTtHAiFOhErvgdhaGX0duEWNQStifaR4uB2
	 Wu28PelWEy/kf7YN9zcMWyJO7ejM3mU3pDMvFSVBp4e/uwFO5Zu//QsrH73qnsZHeP/Qk
	 nscP0OjpOBgPyDnRdJSryXvBFZqLnBJhRWkjUBXNNog0zpNrcMRkEWw97t6LMUOapcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030947;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Nk8mAYyRifN2Y4ljjTsARAcMeEggMbX9fHUhk5yxI4k=;
	b=bwDpeO1g5kg9h37MDKovb9Xu2WTakfjmgAQJgRJhK8yDkP2YrjW/ZAQcBV5eHXt4sfU2
	 TzSqM4v4Y7YZxez4Wp/uiq683Z95d1O8+aHTVD0VdBsbFwwMF6wOGKJvXvXMIRWyY/7yP
	 Bf7iHOKNGfi2CcjJnUIATZHqJHtZjbuePeTqku7JXXIFopFYcN33J1RRZx2Fnl+ZgGFDO
	 f6V+SeArofSXbH10asredBEq8BiZKGkv6m3yezZhr7iYU73Au723zNKKcHO/y1kedCYPJ
	 QHgpwGCiwLx+jnHoFT9NjFgDQ/R64Wbni4g50EYbP7bcbRj/xe7CvpIQcolZsv4dfgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QeG1YAKY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C9C606A325;
	Wed, 18 Nov 2026 19:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QeG1YAKY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3321F000C6;
	Wed, 18 Nov 2026 19:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030947;
	bh=Nk8mAYyRifN2Y4ljjTsARAcMeEggMbX9fHUhk5yxI4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QeG1YAKYcTxQSHptZBI1x7q8mi8P2zuraWLr3wxvAHiVkI95r/9TrLrQURkefBueX
	 cuycnfUnKjcOv/fogi6FpLSqV0r/gQJT++Y4QlD8fscOie4w7UyLMIp766hyqz2XZ6
	 0a7KOaDZh2auZffF4saQPoKnBubbNLjA572OFogY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Demidov <roman.demidov.nn@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0877/1756] drm/msm/a6xx: fix use-after-free of OPP in a6xx_pm_resume
Date: Wed, 18 Nov 2026 15:50:04 +0100
Message-ID: <20261118150044.309872666@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Demidov <roman.demidov.nn@gmail.com>

[ Upstream commit 8128ae7af6b4dc95e486c5c0a80839a069df578e ]

The OPP reference obtained via dev_pm_opp_find_freq_ceil() is dropped
with dev_pm_opp_put() before being passed to dev_pm_opp_set_opp(). If
the reference count reaches zero, the OPP object may be freed, leading
to a use-after-free when dev_pm_opp_set_opp() dereferences it.

Fix the order of calls: first use the OPP to set the required
performance state, then release the reference.

Fixes: 5a903a44a984 ("drm/msm/a6xx: Introduce GMU wrapper support")
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/757104/
Message-ID: <20260929142103.81854-1-roman.demidov.nn@gmail.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 4bae3813d90b5..4dc095f74c32b 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1879,10 +1879,10 @@ static int a6xx_pm_resume(struct msm_gpu *gpu)
 		ret = PTR_ERR(opp);
 		goto err_set_opp;
 	}
-	dev_pm_opp_put(opp);
 
 	/* Set the core clock and bus bw, having VDD scaling in mind */
 	dev_pm_opp_set_opp(&gpu->pdev->dev, opp);
+	dev_pm_opp_put(opp);
 
 	pm_runtime_resume_and_get(gmu->dev);
 	pm_runtime_resume_and_get(gmu->gxpd);
-- 
2.53.0



