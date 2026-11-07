Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063894;
	b=eUmZDToor2vaMHxylBg+FGsphSKnmmD1e0OGjOfP5KDQHhA++NQjcZQ9edVrgJ2sHx2Y
	 ZGwcVSybk9ooIDs24tMf9sswc0UJCim8Tz0EibYJbV2SrYkMM5pgp318fCWSmjy1oh9Oj
	 y+7sXUttVdD1s3USJG4g5bzR2uBAVfstg6vQS9/EcWcPxRhv7ILVOb4yBadHVPHi/e535
	 Sg36yO3qnmBODpJ70TK+mlQ1yINTEOX1PbOK5yX9w7zwSvjSWQqMzI3r8MkqDCfB7tBqg
	 6Da6Wk73XVWBLaq3KnaqPGV6K8AkljX9MhfDL9BmUlmeeD8Jh0cygbylbVqlq6MlS8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063894;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+i6diQkpj9/Kn//JaXMDzpPF5iluBtQFpQ11p44usuk=;
	b=jC2P2Y49GJIQVuPl6tTcxqdTxv1Bn8OCz3hX2+uYaaEBYSPKqVdPnfegFx310qz9OILt
	 G+wIZW5N8UjBlcaL4zH4rnG9y0VYUBU3BDQN9wjtSVA5wIGxz/0cJ7a6Bic8wyBAlMftk
	 Qi0dIdttj39+3licSYuTpCT7/5TEF5fRwg7hO0OWxbwBeUkZQM3ubi6PjMwkWUkR54i63
	 8QsElIbCIv9kfVxMW32NeilOo+LmEfIpolSrdgBhhOwWdv6z2MfYgGu8xGya4nquLMrfh
	 GwVrUhJBuJRtU2qv/VprZt0WNWptYrW4xgxXLm1NG4wKBAjJcdA3/Hq7Y/1jXCfYfGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1fR8taZJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07786606B8A6;
	Sat,  7 Nov 2026 15:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1fR8taZJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8FE51F0089F;
	Sat,  7 Nov 2026 15:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063893;
	bh=+i6diQkpj9/Kn//JaXMDzpPF5iluBtQFpQ11p44usuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1fR8taZJtmirXdKVd/YdeHmSB5XGk1p++B7YtC9UPvuJTbLqPsUKxyo3MBCzI9Kao
	 rjWU+3lo7VXZlVB+rFRSugmDB03/2wOHZCgJo+/4Wi5kxuNY3yILCov+wA5ch4c2gd
	 7/5m4UBqTBUwpggRyc2hFsZPUtUQZbC5j6sBAGEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Faizel K B <faizel.kb@gmail.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0096/1257] media: vimc: sensor: fix pixel_rate type to resolve do_div() warning
Date: Sat,  7 Nov 2026 08:39:52 -0500
Message-ID: <20261107134942.010675427@linuxfoundation.org>
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

From: Faizel K B <faizel.kb@gmail.com>

[ Upstream commit bbc952491f5f05f2274c811d34174d5b88632103 ]

vsensor->pixel_rate->val is a plain s32 field. Declaring the local
"pixel_rate" variable as u64 misrepresented its actual range and made
do_div()'s divisor look wider than the 32-bit division it actually
performs, which is exactly what the do_div() coccinelle check warns.
Revert pixel_rate back to its original s32 type to match
vsensor->pixel_rate->val, resolving the warning correctly.

Fixes: ec1e620b2454 ("media: vimc: sensor: Add pixel_rate,vblank and hblank configuration")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202604191731.10nxGZ92-lkp@intel.com/
Link: https://lore.kernel.org/lkml/CANiDSCs9s03DUjKwcPgDtZt2QJ4i0FGwab4zpEP+wCawagSC2Q@mail.gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Faizel K B <faizel.kb@gmail.com>
Reviewed-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vimc/vimc-sensor.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/test-drivers/vimc/vimc-sensor.c b/drivers/media/test-drivers/vimc/vimc-sensor.c
index 83dcc9d61ee05..7cb544fdfddbb 100644
--- a/drivers/media/test-drivers/vimc/vimc-sensor.c
+++ b/drivers/media/test-drivers/vimc/vimc-sensor.c
@@ -97,18 +97,14 @@ static void vimc_sensor_update_frame_timing(struct v4l2_subdev *sd,
 {
 	struct vimc_sensor_device *vsensor =
 		container_of(sd, struct vimc_sensor_device, sd);
-	u64 pixel_rate = vsensor->pixel_rate->val;
+	u32 pixel_rate = vsensor->pixel_rate->val;
 	u32 hts = width + vsensor->hblank->val;
 	u32 vts = height + vsensor->vblank->val;
 	u64 total_pixels = (u64)hts * vts;
 	u64 frame_interval_ns;
 
-	/* Sanity check, pixel rate is fixed and fits in 32 bits. */
-	if (WARN_ON(pixel_rate >= 0x100000000))
-		return;
-
 	frame_interval_ns = total_pixels * NSEC_PER_SEC;
-	do_div(frame_interval_ns, (u32)pixel_rate);
+	do_div(frame_interval_ns, pixel_rate);
 	vsensor->hw.fps_jiffies = nsecs_to_jiffies(frame_interval_ns);
 	if (vsensor->hw.fps_jiffies == 0)
 		vsensor->hw.fps_jiffies = 1;
-- 
2.53.0



