Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671E51F76A4;
	Tue,  3 Dec 2024 15:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238494; cv=none; b=qYM/8BS2EvYJSYyfeoMdop6YUwpjhy12p0A4mg5N2WVEhesbAiIYfhSq2D2zWAdJByppaZzVsAhjijaw367cFaMKNNu66uWqwQ9eTrxnlYoUdAMbYRhLTnNgALMmXtJk4LiOigl0PSt5m7oUaEeT21JO4JREy5LePg2XP9Z50b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238494; c=relaxed/simple;
	bh=+AKKajc7EaBjjao3KlU2Tczq8rb91XhKCaHEYRIRSCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WaCL0xIW5Y8ZlJC2GqYTxZgwWTqtUMCTEMBirAxHetABFGjMiL4Ab7rFLl3eW8ShbGLUjuRlpxhpcqfl6JfcfNndqKNu+6ROceO1fUQ/Jlm6E1rR8FHJSEV6s6m6QCKEPBxV1jh5xwWxMqDWiQPnNXbdmeCV52v0Mympg+EC76I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XTCUih2t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XTCUih2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5635C4CECF;
	Tue,  3 Dec 2024 15:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238494;
	bh=+AKKajc7EaBjjao3KlU2Tczq8rb91XhKCaHEYRIRSCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XTCUih2tR3J5wXGVAVHQs3PDcnuvvxsERjNUbUpJfdQr7VpL/yfLsxGMsO7j5IMka
	 2VOqP87arJx7PsXaUEnXEkfGHESgtYWUs/J+jYnVlBnqOUQtZaMrvhxs45nG6tXfcS
	 tRA4B+xVoqy1rEGiVMzupZe0D5L2AGZ2f8uieHH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 296/817] drm/msm/adreno: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Tue,  3 Dec 2024 15:37:48 +0100
Message-ID: <20241203144007.373065402@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 394679f322649d06fea3c646ba65f5a0887f52c3 ]

disable_irq() after request_irq() still has a time gap in which
interrupts can come. request_irq() with IRQF_NO_AUTOEN flag will
disable IRQ auto-enable when request IRQ.

Fixes: 4b565ca5a2cb ("drm/msm: Add A6XX device support")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Patchwork: https://patchwork.freedesktop.org/patch/614075/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
index cb538a262d1c1..db36c81d0f123 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -1505,15 +1505,13 @@ static int a6xx_gmu_get_irq(struct a6xx_gmu *gmu, struct platform_device *pdev,
 
 	irq = platform_get_irq_byname(pdev, name);
 
-	ret = request_irq(irq, handler, IRQF_TRIGGER_HIGH, name, gmu);
+	ret = request_irq(irq, handler, IRQF_TRIGGER_HIGH | IRQF_NO_AUTOEN, name, gmu);
 	if (ret) {
 		DRM_DEV_ERROR(&pdev->dev, "Unable to get interrupt %s %d\n",
 			      name, ret);
 		return ret;
 	}
 
-	disable_irq(irq);
-
 	return irq;
 }
 
-- 
2.43.0



