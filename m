Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059808;
	b=hKuBJAWDHlq8VPicRVb/yVO9t+U+WkVbPVsdiQeusvz8hq3cGS1VJ2F152EAjiUcyjrS
	 tn0WPOisaWOtJ99L7hcxIOZzv42qudTJy8DFtJLQGRmhAaWRjJRsNCSY9+1agVeOv/yNP
	 ZfRny7uZExGTtLH/ykeCOBY+jxbXP5wjHI1pTxQOfBfrF4GHWv/SbA2eQqBeNk8Qosa7Y
	 n2bSabPXC5yEyznEuAH79nz2GFffaoyDPJLonzErIUlT2UDEI5pKnDPt0JGIUUsnJEygB
	 RrJcSX7e3z4UQLQUDM2pe4H+H+wRfKqPMpw633Ilx72jofVNn5JuxB53PJT3OjT18QA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059808;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U2D8K7SqNLClqd1qgRdr1RgJn61ADR8rUHhqpIEI2eQ=;
	b=VlndR0vxLc+H5zgaNbhHaZTnnsysjA58mxeQ6Hbnw6RAOpDbStVnw7qZRRotG4/n+TSo
	 iEcwHAPDg6LfE1gTOiNZig4VBgeqYfNBUEMck62iKhVav79ORhNSaJpJCZJh4yJzfLKV3
	 YMZCeWqp7Xwa9orRjIqYC9QBpUWmICNthEUZo/gnErWCdusynGl5EZGO8ZGKpGbaAOJwU
	 0UwKCtuFOQzIXPCgSlKgZm0CqT5MKRlzFALhelDMPoEKpeDW2FyTRWTz8FMH0zq3yk4dZ
	 nwLwUFBERpjUEfuD50KAMCfLgvFPE/S+xInn27dbGuTlfTBqF5BAzfjatyM6mB1leNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="dTU/JZIo";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBA8606A320;
	Thu, 19 Nov 2026 03:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dTU/JZIo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7314A1F000C4;
	Thu, 19 Nov 2026 03:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059808;
	bh=U2D8K7SqNLClqd1qgRdr1RgJn61ADR8rUHhqpIEI2eQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dTU/JZIoXiL87pW4dsNXMxPxLs5HsFoXljcPO0m2Rh07B2LPiIMth3T+t3JirtWhg
	 6MbjnlpDBc8aWW7/MZdfDuPwh9g7POVRuLTA+wzKYwe3JdOvIuIrDjJseI+pzeW+IR
	 OueKT/R6zwiYqWpddbkATxTj+o7fBNFkHZTXhTc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Stephen Boyd <swboyd@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0972/1848] drm/msm/hdmi: fill the pwr_regs bulk regulators
Date: Wed, 18 Nov 2026 15:50:10 +0100
Message-ID: <20261118145957.645133640@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit a18a44e9262d5c7f7fbccbc9458df64d69185d41 ]

Conversion to use bulk regulator API omitted filling the pwr_regs with
proper regulator IDs. This was left unnoticed, since none of my testing
platforms has used the pwr_regs. Fix this by propagating regulator ids
properly.

Fixes: 31b3b1f5e352 ("drm/msm/hdmi: use bulk regulator API")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Patchwork: https://patchwork.freedesktop.org/patch/488847/
Link: https://lore.kernel.org/r/20220609113148.3149194-1-dmitry.baryshkov@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/hdmi/hdmi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.c b/drivers/gpu/drm/msm/hdmi/hdmi.c
index 6cfd9bbd5b104..0c0911325415a 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
@@ -183,6 +183,9 @@ static struct hdmi *msm_hdmi_init(struct platform_device *pdev)
 		goto fail;
 	}
 
+	for (i = 0; i < config->pwr_reg_cnt; i++)
+		hdmi->pwr_regs[i].supply = config->pwr_reg_names[i];
+
 	ret = devm_regulator_bulk_get(&pdev->dev, config->pwr_reg_cnt, hdmi->pwr_regs);
 	if (ret) {
 		DRM_DEV_ERROR(&pdev->dev, "failed to get pwr regulator: %d\n", ret);
-- 
2.53.0



