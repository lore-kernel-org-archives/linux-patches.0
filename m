Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5B5258CE8;
	Thu, 17 Apr 2025 18:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914608; cv=none; b=FibaO8lNHOpEF86SJH913PkAH03Bia1mEMcOuEwyOtR+hs7jM1mVj/wdWoEHGc9jeP1O+eXuHuQnDJ4/9Aaw3eGle6chETssUsH+xB0At+1Q8zO+KjPZIDkLIxH2WwOJyDF0P/zcOQxMQ+7CN4OsSzv83MY+1STeE5key/3jrUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914608; c=relaxed/simple;
	bh=PXq2a3zl5Zp1Ej7yYXwpgWNLoXoWh4F0VMh6UT+U8jA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qaLSEhZPCUEvpJ1M5YIbVfXlYBqzEizO8wN1yz/dpllrlj0QQ5+8YkYlJBhOCBMbdpEGpubYWO9g6Afc0Ru1sWTQkXgYqUwpSQhLBdGzMAMDPL1A/FHJCR0KmyYpAZ0VcZV0DxW8CO0zK5wZopQO3wj4mLSEOS7Pe9onHwYjIe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2SD2Ku3t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2SD2Ku3t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1C0C4CEE4;
	Thu, 17 Apr 2025 18:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914608;
	bh=PXq2a3zl5Zp1Ej7yYXwpgWNLoXoWh4F0VMh6UT+U8jA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2SD2Ku3tlAYB1O2xaJcqe1DnUFxjHniL+4Xw1KYjYbUd1sjK9afMn4aks9k9aNRKy
	 vZtyF0S1iKRq/PfS1tCypQYMXlVUNR3tt4evy/YB+FH/1EzmENeCbK9m83x3iNBAu/
	 VnY9+Br2AFKgrLuFQGSn9Z26rB9oGun3IDL5UP6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jackson.lee" <jackson.lee@chipsnmedia.com>,
	Nas Chung <nas.chung@chipsnmedia.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.13 244/414] media: chips-media: wave5: Fix timeout while testing 10bit hevc fluster
Date: Thu, 17 Apr 2025 19:50:02 +0200
Message-ID: <20250417175121.236560875@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jackson.lee <jackson.lee@chipsnmedia.com>

commit 035371c9e5098018b8512efc6a8812912469480c upstream.

The Wave5 521C variant does not support 10 bit decoding. When 10 bit
decoding support was added for the 515 variant, a section of the code
was removed which returned an error. This removal causes a timeout for
the 521 variant, which was discovered during HEVC 10-bit decoding tests.

Fixes: 143e7ab4d9a0 ("media: chips-media: wave5: support decoding HEVC Main10 profile")
Cc: stable@vger.kernel.org
Signed-off-by: Jackson.lee <jackson.lee@chipsnmedia.com>
Signed-off-by: Nas Chung <nas.chung@chipsnmedia.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Sebastian Fricke <sebastian.fricke@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
@@ -1345,10 +1345,24 @@ static int wave5_vpu_dec_start_streaming
 		if (ret)
 			goto free_bitstream_vbuf;
 	} else if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		struct dec_initial_info *initial_info =
+			&inst->codec_info->dec_info.initial_info;
+
 		if (inst->state == VPU_INST_STATE_STOP)
 			ret = switch_state(inst, VPU_INST_STATE_INIT_SEQ);
 		if (ret)
 			goto return_buffers;
+
+		if (inst->state == VPU_INST_STATE_INIT_SEQ &&
+		    inst->dev->product_code == WAVE521C_CODE) {
+			if (initial_info->luma_bitdepth != 8) {
+				dev_info(inst->dev->dev, "%s: no support for %d bit depth",
+					 __func__, initial_info->luma_bitdepth);
+				ret = -EINVAL;
+				goto return_buffers;
+			}
+		}
+
 	}
 	pm_runtime_mark_last_busy(inst->dev->dev);
 	pm_runtime_put_autosuspend(inst->dev->dev);


