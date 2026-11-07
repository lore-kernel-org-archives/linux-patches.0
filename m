Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063932;
	b=ZmBLGwwQdW+9VD3/+/xhq+gqHifGjfzgUzIFVlsV8ugpr1PMh7Ywa7JFua9jpJEfLDhU
	 xTZulL6CYpVxqw1lX1Po2BFu08Y3ZXyWWK6zGXdCUS7rHJ9z5NVWlHxzv5CXShbVPGnNI
	 YpFgzZDbowpVkGPJPl4bh2ecG71IQG3/G2wWq58SOw9JJE1i1msSRc9GK3dsZlE6qFiNd
	 X/fGtB7cirOcoBVUqUrx9ccwjoyVWvyt9MVEzvJpCwxPQx/p9g1jNzfm7LUdX47/oSjDC
	 RlA/slX3Jx2IJ+Ln+jdATRYwlwxauzN0AOAtRGUe9PWiKVIQ/HUflSWIjMzd+Lo6nOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063932;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kB1ggAnC6lPPKxV+wQGBU5BhpJGbSmGkxImnPSHD2gU=;
	b=zC1eAlnJRJChEk1OSkddWuMPRUdQEb5ofLUxMdY23Fv8aAfrbS2oEbUM28Hsfit5Kq0s
	 PphodblQx+IsZ2egD+ERz1qySD/tccEZsaq0mMlxWT/L+vs2phBvI8uYOeXB0Zj//dd9j
	 zOKLl8xQQtDERghQlktHCedkNHNoUB+J7+/YlFBC0Gyg2nvvHnDisqwypVFtMoW09a/xj
	 9R0yRa4kw12AKV32yKEVmwCq/FKPylCiSVK+P57CQIySqqzCwEB4BrED5Jntp1zX9VE0b
	 7Xu+3inUmySMCxUfD8oT85N15AkA2GSUqK8f3I8txwy2pRGIVsMNXhp2Km9/OzQg3QA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IpvJ29kw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4F0606D802;
	Sat,  7 Nov 2026 15:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IpvJ29kw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBB21F0089F;
	Sat,  7 Nov 2026 15:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063932;
	bh=kB1ggAnC6lPPKxV+wQGBU5BhpJGbSmGkxImnPSHD2gU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IpvJ29kw1cOsLOZ1y1P2bX1vfPuvXJaQkz2jrXzqXPZ0C4/tcdE58hB/p5AJ4qwK/
	 kmvIJpCLo6nfp7+bLNP/r5jx+2huVLwMffX2OGXCZy4rxFvd36g1wZtk7ArGZkhjJX
	 A13L8etN/Of1slmMQmM9QwMK91BAVP1XTzrCMWVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Tharit Tangkijwanichakul <tharitt97@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0124/1257] media: v4l2-ctrls: default HEVC SPS chroma format to 4:2:0
Date: Sat,  7 Nov 2026 08:40:20 -0500
Message-ID: <20261107134942.752428916@linuxfoundation.org>
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

From: Tharit Tangkijwanichakul <tharitt97@gmail.com>

[ Upstream commit 4f4b6a9220f0401ae84bd2644aabd7221930c1c5 ]

The default value of a compound control is zero initialized when no
explicit default is provided. For V4L2_CTRL_TYPE_HEVC_SPS this results
in chroma_format_idc being set to 0, which represents monochrome video.

Most stateless HEVC decoders do not support monochrome video. In
particular, the VDPU38x variant of rkvdec fails v4l2-compliance in two
tests related to V4L2_CID_STATELESS_HEVC_SPS.  The Control ioctls test
reads the control with GET_EXT_CTRLS and writes the same value
back; TRY_EXT_CTRLS then returns -EINVAL because the VDPU38x
rkvdec_hevc_validate_sps() rejects sps->chroma_format_idc == 0.

    v4l2-compliance 1.33.0-5491, 64 bits, 64-bit time_t
    v4l2-compliance SHA: b32589c51481 2026-07-16 08:51:38
    Control ioctls:
        fail: v4l2-test-controls.cpp(942):
	try_ext_ctrls returned an error (22)
      test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL
    Buffer ioctls:
        fail: v4l2-test-buffers.cpp(3102): node->streamon(q.g_type())
        fail: v4l2-test-buffers.cpp(3157): testBlockingDQBuf(node, m2m_q)
      test blocking wait: FAIL

Set the common HEVC SPS compound control default to
chroma_format_idc = 1, corresponding to 4:2:0.

Fixes: c9a59dc2acc7 ("media: rkvdec: Add HEVC support for the VDPU381 variant")
Cc: stable@kernel.org
Signed-off-by: Tharit Tangkijwanichakul <tharitt97@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-ctrls-core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls-core.c b/drivers/media/v4l2-core/v4l2-ctrls-core.c
index 648b88c868bc6..47fb60b1f0c07 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls-core.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls-core.c
@@ -115,6 +115,7 @@ static void std_init_compound(const struct v4l2_ctrl *ctrl, u32 idx,
 	struct v4l2_ctrl_fwht_params *p_fwht_params;
 	struct v4l2_ctrl_h264_scaling_matrix *p_h264_scaling_matrix;
 	struct v4l2_ctrl_av1_sequence *p_av1_sequence;
+	struct v4l2_ctrl_hevc_sps *p_hevc_sps;
 	void *p = ptr.p + idx * ctrl->elem_size;
 
 	if (ctrl->p_def.p_const)
@@ -188,6 +189,12 @@ static void std_init_compound(const struct v4l2_ctrl *ctrl, u32 idx,
 		 */
 		memset(p_h264_scaling_matrix, 16, sizeof(*p_h264_scaling_matrix));
 		break;
+	case V4L2_CTRL_TYPE_HEVC_SPS:
+		p_hevc_sps = p;
+
+		/* 4:2:0 */
+		p_hevc_sps->chroma_format_idc = 1;
+		break;
 	}
 }
 
-- 
2.53.0



