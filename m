Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063041;
	b=Vjdi7f0fNin+qMJF68PlaWoRvx0700rA2tJMAfRdcmNgMD5+07uBJwOR2L8UbtOoB/j1
	 tNVcgxnZLRrOfszFLphZu06H5VzRfuM5k6oZcxNkEevvaWyoV5KDHXpwffNMuCvnvDQaf
	 cthGAWV9JwpZo26hcNbSkX/3kbpOggs9modDHP/YIlhQzvMPNxjxsQCKDAJeN4fA1neO9
	 XPDWknj5TxhhYotrBmZJAD9DxjT8uqiJfAIonh2GQT9Zha8WIXQIgfM6KyN1mIR312dFk
	 m51DEA2U3av/wDfyJnKcULq73SP7f6apaBDF8BcZDYzqfNVIuoRP5FAm/L2YBuotGBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wu5Sf4N2ANt2frUPCaRWXZCVeV0eQcRnA1EUqrhigN0=;
	b=ohEMq/Q5oXBosmADAJqcTtkX4od2M6G7jy9hms3FiWNdyGuqPISUkbQMTGXzFMfFMqof
	 S1hGVcV2060Sn+YIKOc2ocksqtJe+FePd+7i5+lR/LZzZuDLGXkLYr+/PniG8asBIUwRJ
	 1iI46amiDU2PqNghvLh4cz2WIsxp6OE9xxnvSKJK4171tyr3W81cS/NlM3Q/GxFIPzpCh
	 kDUaQqomSlylBlKMpIB/PAoYdHMiORhwmF8llE5Abla8BIup54052ZGyyGz0R6PwNdJkm
	 iiGKYMxZDZyyW6yZ8xpLSTCe3G+dRbXqT3ccJziiDYSeRXNdQEe6qWDoPTv2KYsr4LA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NpGiEsDY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D71C606D81A;
	Sat,  7 Nov 2026 14:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NpGiEsDY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0871F008A1;
	Sat,  7 Nov 2026 14:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063041;
	bh=wu5Sf4N2ANt2frUPCaRWXZCVeV0eQcRnA1EUqrhigN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NpGiEsDYtvOC9+bUKjlPI3pCmkr2+fIpYDj8cQSKj/1spzkf9roBbbOj9uwfy/fL6
	 pWyZRvnEYyCuHp0sgvdOfyg9cFTkwrDCfXRaxa2J8bPDZpzSjbMLmzClEFZQXq/2xD
	 2FE9V1oQ+BihwKVCi0HT0WFCTFYjUiTiNBQbSDiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Vishnu Reddy <busanna.reddy@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 288/869] media: iris: Fix frame interval enumeration for non-divisor framerates
Date: Sat,  7 Nov 2026 08:49:30 -0500
Message-ID: <20261107134901.580385206@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Vishnu Reddy <busanna.reddy@oss.qualcomm.com>

[ Upstream commit 3ad393b701dd99274f09403185f71ec7a93135bd ]

iris_enum_frameintervals() advertised frame intervals using
V4L2_FRMIVAL_TYPE_STEPWISE with step=1/MAXIMUM_FPS where MAXIMUM_FPS
is 480. This caused client to enumerate only framerates of the form
MAXIMUM_FPS/n (where n is a positive integer), restricting support to
exact divisors of MAXIMUM_FPS (e.g., 480, 240, 160, 120, 96, 80, 60,
30, 24, 1).

Framerates that are not exact divisors of MAXIMUM_FPS, such as 29 fps,
25 fps, were excluded from the enumerated list. There is no hardware
restriction to framerates that are exact divisors of MAXIMUM_FPS. This
caused GStreamer caps negotiation to fail with an "internal data
stream error" when encoding content at such framerates.

Fix this by using V4L2_FRMIVAL_TYPE_CONTINUOUS. With CONTINUOUS type,
GStreamer creates a continuous framerate range [1, max_fps], allowing
any integer framerate within the range to pass caps negotiation. The
step field is set to 1/1 as required by the V4L2 specification for
continuous frame intervals.

Fixes: a6882431a138 ("media: iris: Add support for ENUM_FRAMESIZES/FRAMEINTERVALS for encoder")
Cc: stable@vger.kernel.org
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Vishnu Reddy <busanna.reddy@oss.qualcomm.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/iris/iris_vidc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/iris/iris_vidc.c b/drivers/media/platform/qcom/iris/iris_vidc.c
index d6db5ae85990b..b916e8c8a6456 100644
--- a/drivers/media/platform/qcom/iris/iris_vidc.c
+++ b/drivers/media/platform/qcom/iris/iris_vidc.c
@@ -434,14 +434,14 @@ static int iris_enum_frameintervals(struct file *filp, void *fh,
 	mbpf = NUM_MBS_PER_FRAME(fival->height, fival->width);
 	fps = DIV_ROUND_UP(core->iris_platform_data->max_core_mbps, mbpf);
 
-	fival->type = V4L2_FRMIVAL_TYPE_STEPWISE;
+	fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
 	fival->stepwise.min.numerator = 1;
 	fival->stepwise.min.denominator =
 			min_t(u32, fps, MAXIMUM_FPS);
 	fival->stepwise.max.numerator = 1;
 	fival->stepwise.max.denominator = 1;
 	fival->stepwise.step.numerator = 1;
-	fival->stepwise.step.denominator = MAXIMUM_FPS;
+	fival->stepwise.step.denominator = 1;
 
 	return 0;
 }
-- 
2.53.0



