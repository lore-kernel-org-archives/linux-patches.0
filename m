Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018026;
	b=Yv9860lQ0oiE0v1VW7R3uLzYv2R5HMWwVM/+SGPmgHaUe1TityEVfkRrbsqdoO2k1lqj
	 q+yOge4aGIbbfA9I68p87zNQRIqMx2KaX7bHptGltpmclYNFGao+u6+JO8Nv3gwLrTkv+
	 Cw9mctVpV80cL+XcqOPXthD6782WPJwoC2rlpgtKQdRk8sIl0sbueWdWdPATEUKthLTTm
	 GsxEyVvTcGYN2TxMIrD7oPJqO8zB8xH1FsKn2oJPMgjD5TMkLXtaOIDR0pXkK3/p331D4
	 GiWWX3Cy5S0sMeyqTk4DCPFhsfPllEVmAKQFqZRJ027dKKWgaZqU2vfIm1x84U+730w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018026;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uDC2A6VvgbS/Arv6/AZcHIJTuFAgKHWKWKQbcF9KUck=;
	b=Fz4bWbzK7Sw1SdWNASFZPU/SHV2A0xa1KLyvVA38L3pMH4jKGnutob6ZhihFsV/mLx8q
	 VWGvVeS46DjcxBvR3rVvK0FDoS6VAIBXM4iSeKTWRi+r+/VME9V9J+UoKdjlQJUtGYOJJ
	 iK+T2g+b24uMiOYZY99XfexJLY1sPaqT5b6GEhlwOkxZgA51arfT052l+Onvqu3sWAH1E
	 /QwM1Ei8jb1FJ3IpLjihYYu83BtsFdNV7fUy11cjidvzI9iJMkm1VJ4WI4Na4Is3y0SfH
	 vHWor+Q0/Tt2fByOEBCv0w4J3cramvUkWfyrQqIqYeaRD3q0SalLUnoCUX9ZwgpYERQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EF9nAEvp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A662606A31C;
	Wed, 18 Nov 2026 16:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EF9nAEvp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08D11F000C5;
	Wed, 18 Nov 2026 16:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018026;
	bh=uDC2A6VvgbS/Arv6/AZcHIJTuFAgKHWKWKQbcF9KUck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EF9nAEvp4HBOqeWRFhwauPRUC7YhToijILRP9uR4kZ5kYO2tlnX0mE9q3x3HsKsEm
	 EOn94X+kxwmH0vzlJ0r1zKKlXRM2CdpwB9O5lb3lGRYG6TR7svGw4vTIjTkjHIUQ6t
	 D5xs9ryT8KILTQS94cqvd8K66BP+t025mQxI28uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xilin Wu <sophon@radxa.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1095/2651] drm/msm/dp: Initialize the debugfs connector pointer
Date: Wed, 18 Nov 2026 15:38:55 +0100
Message-ID: <20261118150327.419756783@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Xilin Wu <sophon@radxa.com>

[ Upstream commit c2f772ec52898a3f6967d17035da7b739465f81c ]

The debugfs cleanup removed the connector assignment from the debug
context, but the video-pattern test files still dereference that pointer
to check connector status. Reading those files can therefore dereference
NULL.

Store the supplied connector before creating the debugfs files.

Fixes: ab8420418c2e ("drm/msm/dp: cleanup debugfs handling")

Assisted-by: LLM
Signed-off-by: Xilin Wu <sophon@radxa.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/757261/
Link: https://lore.kernel.org/r/20260930-msm-dp-hdr10-v1-11-dbbf8b2b42bc@radxa.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/msm/dp/dp_debug.c b/drivers/gpu/drm/msm/dp/dp_debug.c
index cf3838fcd154e..00fb1a7ba40ed 100644
--- a/drivers/gpu/drm/msm/dp/dp_debug.c
+++ b/drivers/gpu/drm/msm/dp/dp_debug.c
@@ -216,6 +216,7 @@ int msm_dp_debug_init(struct device *dev, struct msm_dp_panel *panel,
 
 	debug->link = link;
 	debug->panel = panel;
+	debug->connector = connector;
 
 	debugfs_create_file("dp_debug", 0444, root,
 			debug, &msm_dp_debug_fops);
-- 
2.53.0



