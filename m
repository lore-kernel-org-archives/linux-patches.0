Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04FC1946C8;
	Fri, 17 Oct 2025 15:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715788; cv=none; b=DJ2x1F5EMg8ivyZy1n0dtnXmqp241yvoVZqQj+Gk4fGzjW0QGQQRGwx/wXHlStCwgZ1KoIR/TXahZbEy9QoveypW09K8UZjs3MT/XEZc9Fb6sUfP6Mc+AY1xl/xm2g5GPjm7hxUJB+dmZg3CLzJAxTOTkHOu6dON8Oh2wutKSCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715788; c=relaxed/simple;
	bh=9caCpVWC195JeU/JiXkCTzTYTPCKSIpS1Nd7veMYX7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hVRUcSvinmOAeWxoFBt8pAg1ZAvHddB4Dbip15xpEQAhe82JrhgZB06SZp+TzK22CDSRUD5ikuJ3vkOquUHfQdjopReNq/u4M9NMwVi2VU0XeJLkIH+58i7A/z4OaqAwxfdyhas1JbPIQ4cfqz3NRfPZxWe9WPCWoe0IWm8Jtso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JS0iSj3X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JS0iSj3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01076C4CEFE;
	Fri, 17 Oct 2025 15:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715788;
	bh=9caCpVWC195JeU/JiXkCTzTYTPCKSIpS1Nd7veMYX7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JS0iSj3XQcfnD+LD5Bc9No4X6bnLYe8fQ8LaptxHsD4UeJxlzuqFq4zVjBeAddOos
	 2Syv6CjokHQlL609v/di82OU/6fWAxaaik2NTVeOnU+kLQ1U8i4+VZOSDvslIp4iGF
	 S6It02NRasSchpvOQafX435PNX/5GUofiPIsYXKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Subject: [PATCH 6.17 336/371] media: iris: Fix format check for CAPTURE plane in try_fmt
Date: Fri, 17 Oct 2025 16:55:11 +0200
Message-ID: <20251017145214.239224787@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dikshita Agarwal <quic_dikshita@quicinc.com>

commit 2dbd2645c07df8de04ee37b24f2395800513391e upstream.

Previously, the format validation relied on an array of supported
formats, which only listed formats for the OUTPUT plane. This caused
failures when validating formats for the CAPTURE plane.
Update the check to validate against the only supported format on the
CAPTURE plane, which is NV12.

Fixes: fde6161d91bb ("media: iris: Add HEVC and VP9 formats for decoder")
Cc: stable@vger.kernel.org
Reviewed-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Tested-by: Vikash Garodia <quic_vgarodia@quicinc.com> # X1E80100
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-HDK
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
Signed-off-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org> # x1e80100-crd
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_vdec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/iris/iris_vdec.c b/drivers/media/platform/qcom/iris/iris_vdec.c
index d670b51c5839..0f5adaac829f 100644
--- a/drivers/media/platform/qcom/iris/iris_vdec.c
+++ b/drivers/media/platform/qcom/iris/iris_vdec.c
@@ -158,7 +158,7 @@ int iris_vdec_try_fmt(struct iris_inst *inst, struct v4l2_format *f)
 		}
 		break;
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
-		if (!fmt) {
+		if (f->fmt.pix_mp.pixelformat != V4L2_PIX_FMT_NV12) {
 			f_inst = inst->fmt_dst;
 			f->fmt.pix_mp.pixelformat = f_inst->fmt.pix_mp.pixelformat;
 			f->fmt.pix_mp.width = f_inst->fmt.pix_mp.width;
-- 
2.51.0



