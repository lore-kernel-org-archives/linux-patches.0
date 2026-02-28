Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363C0392811
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301003; cv=none; b=bwUe1TyFMs8G3hnoV5dPFnhwOmTZd5cZ8gteLMQrAxQ6cdosKo60GjYeHG9OiswzF19Pgy1uuqNnzRWGmcV77sU7/qEk5/eBRffg6TC8kRNHMuWUwgBLCntqFgQvhBNRREPUIiDfcsO1HD+yiB+MKCkTi0XUaHuH+ZHFkxl9wLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301003; c=relaxed/simple;
	bh=NOzhfqd4DjmFiQKuS+a1GuPqV7fhkO86AfFKKYFbbyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c0lMsEK1jhpoX0Wv9qkg7ngToiMja8H5Ra8lUoCoVMVZ1nmioUEW5ONEvKH5i/lFloZpHBhUm2+1Aj9XWrgJonh9uoEHjZI5o8mWTv3Ufo2KoCLc7SSJiXcekoomtNJ826cVs1OpcCeABL5sPuJnEziDiczPSq5Gk+MhpRmixtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GgjFOud/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GgjFOud/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77366C116D0;
	Sat, 28 Feb 2026 17:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301003;
	bh=NOzhfqd4DjmFiQKuS+a1GuPqV7fhkO86AfFKKYFbbyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GgjFOud/NrXYuBM6yxBT9nlOE3516UIt101KRF9Jv37nsdNDTJ824tZCIXuIL7RXD
	 gLkXFMrSyf97qY/h5fp6k+iv22qqNtyeCCHwBUKPUSdULXJAO8EEzWQoZnS+7kCgjb
	 LrlpIXjZLS6rg4V0vIi2W3OkvzWGyZcRP3vclFK8IajQG1E8eSZWrz6SYn0N4JzrER
	 IBkUw6I8QW7Uwi3Z9vY26YYKWXMpvMxM26b7cYS5a1oHZh02gWoh2JyBBnGEZtvBFz
	 cu32L6Kvy8MvF2UJryV0dJw7vaAiyLhd7WocsHE60jdIEiUIDtosPly7QvHjkpEuEo
	 bFjIprD3IqKYQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 136/752] media: mediatek: vcodec: Don't try to decode 422/444 VP9
Date: Sat, 28 Feb 2026 12:37:27 -0500
Message-ID: <20260228174750.1542406-136-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Nicolas Dufresne <nicolas.dufresne@collabora.com>

[ Upstream commit 3e92d7e4935084ecdbdc88880cc4688618ae1557 ]

This is not supported by the hardware and trying to decode
these leads to LAT timeout errors.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mediatek/vcodec/decoder/mtk_vcodec_dec_stateless.c      | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_stateless.c b/drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_stateless.c
index d873159b9b306..9eef3ff2b1278 100644
--- a/drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_stateless.c
+++ b/drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_stateless.c
@@ -502,6 +502,12 @@ static int mtk_vdec_s_ctrl(struct v4l2_ctrl *ctrl)
 			mtk_v4l2_vdec_err(ctx, "VP9: bit_depth:%d", frame->bit_depth);
 			return -EINVAL;
 		}
+
+		if (!(frame->flags & V4L2_VP9_FRAME_FLAG_X_SUBSAMPLING) ||
+		    !(frame->flags & V4L2_VP9_FRAME_FLAG_Y_SUBSAMPLING)) {
+			mtk_v4l2_vdec_err(ctx, "VP9: only 420 subsampling is supported");
+			return -EINVAL;
+		}
 		break;
 	case V4L2_CID_STATELESS_AV1_SEQUENCE:
 		seq = (struct v4l2_ctrl_av1_sequence *)hdr_ctrl->p_new.p;
-- 
2.51.0

