Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028827;
	b=5gbObx9GOVxUu0pY6EAIme+VCKmet8GYjY/mmvZNQjemVz3DbTIvV+i976b9xTY4Bk40
	 5EGSmK9lpLnFdirNxpdyDH6gWwLFLmLDuRBgyS5wA21GsQxALMlHd30CedDYbeYFq18NC
	 PZp4JHoomzmcog6V30Cy/WuPa2eWhLZHGkK88T/UXdahK8h3/A0vAV4pTxBZPC64lt/Mu
	 3bMg68PScMZM5V/9iteKtRpUSfqgj5WdKWO9txSWw+fmP2AbaW07V51GTuUtLUDVS61lL
	 cECwCX16rBAOQf5ft+P88WBFq9inmSOxvltX9v5CBUa9plnLkmXLsLP+wabS4YdaVKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028827;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Gqja/NVxkrDy4nR3G9ujlczu9/atFHYe2rnpPnoCOQo=;
	b=j2kal3FFho2xZIiWzCuMzk9UqoFMvW77vtV/iZbw7vgoODB+sfJD2fZVI+IeSrxjYB9O
	 f52zTcHd3zIZR4VcbDkZ0QR1C+wpox3GZWcbDnqthpZperqWykqu2+Bj3DB2VqhUoI4LG
	 f7XasXnBWaelT7xQO92N9XvhD0p7I22J9cbUgyF5dsQIJuY77HCAbqgqTkLTlKaVqbWFN
	 bYfPAHOTS7l+XCAjzt98j4rVIMoLGpX8SRMXVR3/jcHC2BSQeXE6sufI8kF8u4NhsiAH+
	 p/mEOfwvNXTmssOHdSBNN2HpYVu04oYraFDh7jXSedonkY0NLPyvVqRHUJasqoe6Uvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="iIzn/kVO";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6391960A2600;
	Wed, 18 Nov 2026 19:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iIzn/kVO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80E81F000C6;
	Wed, 18 Nov 2026 19:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028827;
	bh=Gqja/NVxkrDy4nR3G9ujlczu9/atFHYe2rnpPnoCOQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iIzn/kVOPn9BxbtD3EMHSwmtmskavv13ZpUH3lgvXz0cisXg4rV0ixJXTa8eyHouH
	 FzbEyuOH33esRN4M/kASHwLHET4xJ0DSzGFIhH18jtXal24ZDyYASegNAAimOZnVHh
	 S0xc0p6sTraIJ1y2YMh/7i3Y/EVhfOXlHJ35Jg+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claude <noreply@anthropic.com>,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0133/1756] drm/panfrost: Prevent division by 0
Date: Wed, 18 Nov 2026 15:37:40 +0100
Message-ID: <20261118150013.476581317@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrián Larumbe <adrian.larumbe@collabora.com>

[ Upstream commit fd4227f03546c323b5b21568f727233e9792d298 ]

When updating and debug-printing devfreq stats, in the very unlikely
off-chance that total device time is less than 100 ns, division by 0
would happen. Fix the divisor when relevant and rearrange operands.

Reported-by: Claude <noreply@anthropic.com>
Closes: https://gitlab.freedesktop.org/panfrost/linux/-/work_items/88
Fixes: f3ba91228e8e ("drm/panfrost: Add initial panfrost driver")
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patch.msgid.link/20260820-b4-panfrost-fixes-v1-2-1b2c2376f4bc@collabora.com
Signed-off-by: Adrián Larumbe <adrian.larumbe@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_devfreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_devfreq.c b/drivers/gpu/drm/panfrost/panfrost_devfreq.c
index 5d0dce10336ba..9ab4fb3deb145 100644
--- a/drivers/gpu/drm/panfrost/panfrost_devfreq.c
+++ b/drivers/gpu/drm/panfrost/panfrost_devfreq.c
@@ -76,7 +76,7 @@ static int panfrost_devfreq_get_dev_status(struct device *dev,
 
 	dev_dbg(pfdev->dev, "busy %lu total %lu %lu %% freq %lu MHz\n",
 		status->busy_time, status->total_time,
-		status->busy_time / (status->total_time / 100),
+		status->busy_time * 100 / MAX(status->total_time, 1),
 		status->current_frequency / 1000 / 1000);
 
 	return 0;
-- 
2.53.0



