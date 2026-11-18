Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025630;
	b=Ut4svLXIjUbZqzD7bJx93d/F1CfzshTv10U0kYNPSe8RfZfECBVTruczEAH7FH0dfLsn
	 XfZmkJ1xo+CClz7vy+DWOuoCVRLbqnZJad5WLXfv5XiiWaWhwAir8QOcuxBToR7uhweX0
	 Lv1hbdu0xdqkhsoMk1SACnaSTq4UoEMyrj8GKTUsSJJsHiwum8WA+IdNx43R6fn6TuD1m
	 EtCOu3wpXoguJ+8TVoLWW4FvW14qX6QSf+BQeCV5dI64rlRApcA0/km8stJsoBh5IdpnI
	 Bx9lU+W7XOuNrnLIOshA5uw1FqnMf8GbOlsjHSYCmeS52D2bu+/Fcb4U4RkWo6Zrpow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025630;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qpj4Zz4fN/j5YbWZW8FcAJXB2Txd43fVXgzIXihXmJI=;
	b=g3IwyLSiGoTKM7zdEijqHRS7zB6fbFMDVonjntPK4d5MKEzuJV+wE6dc+1/QSDC9y73Q
	 5ogxCWTKTzRnwgjzBq0b78dRLNXlGz0AiW/i9mcIK0FGoPgymuqtPT70XuQyO+o7F9rmH
	 V9Diw+w5CInXRXIg4lfqJPhqGNQfa8V27hNn7QRdxBJUsW5ShltkGuppYjxRKclC7uR7f
	 M0jvMme92RA7heVyJYTQzD8h07CbyQ1xylhHrH3Doug4CDXwKmxmZGRnjSZP62v1nWnVy
	 Zy7odsOFFyDnjH+WqCYI6dnQJAxrMUitRUwjPKjaR5k5zaHGOenq9bBKocunwQWM1Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rHoFU0bY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BCE606A31C;
	Wed, 18 Nov 2026 18:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rHoFU0bY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7019B1F000C7;
	Wed, 18 Nov 2026 18:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025630;
	bh=Qpj4Zz4fN/j5YbWZW8FcAJXB2Txd43fVXgzIXihXmJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rHoFU0bYiHf4sbpAs+Ws6WNxz+kDXr1aFX6PAApUMu4rEt+m5+qEINSEMXVprAGiV
	 gRxk7NwptpAaeMW8Ux5/hj7j6b424MKEX1RU5eD4fM7q6nGQ59ubmjcy1M1Y2wFdhl
	 JWX5jAqFEZ+lvHIv+JAg9fsU1qAe8y+3j3ftlUq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Demidov <roman.demidov.nn@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1110/2151] drm/msm/a6xx: fix use-after-free of OPP in a6xx_pm_resume
Date: Wed, 18 Nov 2026 15:47:25 +0100
Message-ID: <20261118150202.673111485@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f56ac2e0adbe1..62fa7252d7724 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -2225,10 +2225,10 @@ static int a6xx_pm_resume(struct msm_gpu *gpu)
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



