Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051070;
	b=sqhGANtSjedkq/w0vcmbiAvYsPXCvnr2VvR7v4wibf1kK3Xkd5Gjm6tTUIg63pVYc+92
	 Q7Q0xH9UjcuUOnITmkpcdk4wIQpY8UjbQCvJeFF/SR8tWYxyMZMNsbjBiRi4un4ZkgQbU
	 f5k179VsPWSM8cM2zjyfyWEQHivBsmiUQ01OPaGnv28gYCVU3wr4g8q8Pzq7o0OkTjS/H
	 NmqQY1p4p+dnd5nypY+QTm7WOSJRnjieCx4I6ACkqiOAyan/bgzImLr718bZJLASFk14o
	 ZWS1uY4ok9mMX6I7WeNj60C6EDFiXsnD6UTKGwN/l/W5Zjhk6pxMjEw9k/YpfwlBtZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051070;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D7e9SziXhIQ0k0dNtYG4NOXkdF1sNBCJoMqPMUgr6AA=;
	b=XAri0G3bSlxT328AWk2We0j3PXFGuyuPbPew84On1D+whwiwsaohBV146hpX9gq7CSvS
	 QSWeJsx3a5QHNs2BClStZ9EI7nsZn7RvbBnzYgT7x2GbCMzmTwrW57FPn8a7fjg2ZXlwO
	 tzHV9YX23lihorqPVpO69W1y2WwLIsoFCGXhVhP49QJRnttxEwZWSu67qgqTbRgzAYKej
	 Z1l7AzQ/UCOp6VFtFltIsKypw580IGymtjrdLeNRWwGYL9W7o92GkKc3CxOrXbwSKg7Kl
	 nOb+EO5en7dK+kkyt8hf/wQ1CyQiwbrRuD0Q87zd3+eI58nd2zyio3WfYSafPEuCErg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ICl7T1eZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5404B606A325;
	Thu, 19 Nov 2026 01:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ICl7T1eZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E4D1F000C4;
	Thu, 19 Nov 2026 01:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051070;
	bh=D7e9SziXhIQ0k0dNtYG4NOXkdF1sNBCJoMqPMUgr6AA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ICl7T1eZLjaSHMD8/76nctNBGUlKduPib/U3kYbXJN753dJ/nIwdo912ThuVQQ63A
	 PSRLBrTed0K2L5Pwj+HXE3Yp5Vf0toqusiQXB2hv6YSRjnmPrWTAe7gfmWhDECObk9
	 Ss/wIJNv6Lr8xqSsg6e2bq2CSP0AiPF6quXbPqC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jurison Murati <eng.juri@gmail.com>,
	Daniel Scally <dan.scally@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0077/2214] media: i2c: ov8865: Drop the runtime PM usage count on stream failure
Date: Wed, 18 Nov 2026 15:29:13 +0100
Message-ID: <20261118150013.054877943@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jurison Murati <eng.juri@gmail.com>

[ Upstream commit 3fe797a12bfa9a49aa998ee722e5f25c957b9b15 ]

ov8865_s_stream() takes a runtime PM reference when enabling the
stream, but returns without releasing it if ov8865_sw_standby()
fails, leaving the reference unbalanced and the sensor powered
indefinitely. The same applies to a failure while disabling the
stream, in which case the reference acquired at stream start is
never dropped.

Drop the reference in a single place, both when disabling the
stream and on failure, and only update the streaming state on
success.

Signed-off-by: Jurison Murati <eng.juri@gmail.com>
Reviewed-by: Daniel Scally <dan.scally@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov8865.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/ov8865.c b/drivers/media/i2c/ov8865.c
index 92f6c3a940cfb..c587b14c91e93 100644
--- a/drivers/media/i2c/ov8865.c
+++ b/drivers/media/i2c/ov8865.c
@@ -2508,15 +2508,13 @@ static int ov8865_s_stream(struct v4l2_subdev *subdev, int enable)
 	ret = ov8865_sw_standby(sensor, !enable);
 	mutex_unlock(&sensor->mutex);
 
-	if (ret)
-		return ret;
-
-	state->streaming = !!enable;
-
-	if (!enable)
+	if (ret || !enable)
 		pm_runtime_put(sensor->dev);
 
-	return 0;
+	if (!ret)
+		state->streaming = enable;
+
+	return ret;
 }
 
 static int ov8865_g_frame_interval(struct v4l2_subdev *subdev,
-- 
2.53.0



