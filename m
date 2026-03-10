Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7D6382F29;
	Tue, 10 Mar 2026 11:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773140775; cv=none; b=GRHt4ZkYr7XLZ/XHPZV3s880hQqia6Z7F40kj9m1IzCaD7lA6ecm0DpQROkJ62VHiFtyMYAWfnxvVT2E/oQrth2v2FLnldmHf+X44iJq+GfzKUq7GPICa+Gu492xEpYSAeg5yNSJcIsqrewvFxMSY8vR2VVmsqlXhA+xTaSIkRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773140775; c=relaxed/simple;
	bh=ipBtywZ7HIHGRpmn2N1ZpWu3QCgyHKVKSqQn00Rfv1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LoDIhrcUXD6lwnxcQooAsE7i/9aJm9tsPaybxOnBEp6caUq28I03iUGZlyGFmRlUMZ9nDk0xRIvvueiStAvM7IwqCMpDAaTjif4CvMDJbmP0fc4EuBv6qE6o0Rlw5quWS/1VWxx30pMx3CHVy+HcOsnYLiqrBWWxE7MvWDnaLZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AOWVaB8Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AOWVaB8Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45038C19423;
	Tue, 10 Mar 2026 11:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773140774;
	bh=ipBtywZ7HIHGRpmn2N1ZpWu3QCgyHKVKSqQn00Rfv1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AOWVaB8QTmZ74gYhjqwZ/ujg4k+jzuteXikonq3qr500PUD44+vq4tbEwkYogv4RB
	 DG/LTIUZG4kS0KkwEDTMUdPOY+DS1N3H7XZfsUGBQx4A4vBFHmOVKD+sP7DmVOI8Ka
	 IsYzfOfh1j6bNRN+0cijhFTXeUUV5dfKSZaUApkbWi061oslkTw5lSrzH0tcRmCIp3
	 +bpCjZvt2ISyRhdTNqTp/+EDuQImr+Bkm3+e0NeynUARwkhJLNsg27jdG22FvbLDoS
	 +rB5Pe6f1++hxwgvKiiUidGnvk9tfLY9x7jdKDm/R3+JT6bWhRO8llLRDujxbu7IQw
	 IqC9MnnN01q4g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Simon Ser <contact@emersion.fr>,
	Daniel Stone <daniels@collabora.com>,
	Robert Mader <robert.mader@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 008/311] drm/fourcc: fix plane order for 10/12/16-bit YCbCr formats
Date: Tue, 10 Mar 2026 07:00:55 -0400
Message-ID: <6420c7d2793cc42dca1e27aa9cc468cc1e88b545.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Simon Ser <contact@emersion.fr>

[ Upstream commit e9e0b48cd15b46dcb2bbc165f6b0fee698b855d6 ]

The short comments had the correct order, but the long comments
had the planes reversed.

Fixes: 2271e0a20ef7 ("drm: drm_fourcc: add 10/12/16bit software decoder YCbCr formats")
Signed-off-by: Simon Ser <contact@emersion.fr>
Reviewed-by: Daniel Stone <daniels@collabora.com>
Reviewed-by: Robert Mader <robert.mader@collabora.com>
Link: https://patch.msgid.link/20260208224718.57199-1-contact@emersion.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/drm/drm_fourcc.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/uapi/drm/drm_fourcc.h b/include/uapi/drm/drm_fourcc.h
index e527b24bd824b..c89aede3cb120 100644
--- a/include/uapi/drm/drm_fourcc.h
+++ b/include/uapi/drm/drm_fourcc.h
@@ -401,8 +401,8 @@ extern "C" {
  * implementation can multiply the values by 2^6=64. For that reason the padding
  * must only contain zeros.
  * index 0 = Y plane, [15:0] z:Y [6:10] little endian
- * index 1 = Cr plane, [15:0] z:Cr [6:10] little endian
- * index 2 = Cb plane, [15:0] z:Cb [6:10] little endian
+ * index 1 = Cb plane, [15:0] z:Cb [6:10] little endian
+ * index 2 = Cr plane, [15:0] z:Cr [6:10] little endian
  */
 #define DRM_FORMAT_S010	fourcc_code('S', '0', '1', '0') /* 2x2 subsampled Cb (1) and Cr (2) planes 10 bits per channel */
 #define DRM_FORMAT_S210	fourcc_code('S', '2', '1', '0') /* 2x1 subsampled Cb (1) and Cr (2) planes 10 bits per channel */
@@ -414,8 +414,8 @@ extern "C" {
  * implementation can multiply the values by 2^4=16. For that reason the padding
  * must only contain zeros.
  * index 0 = Y plane, [15:0] z:Y [4:12] little endian
- * index 1 = Cr plane, [15:0] z:Cr [4:12] little endian
- * index 2 = Cb plane, [15:0] z:Cb [4:12] little endian
+ * index 1 = Cb plane, [15:0] z:Cb [4:12] little endian
+ * index 2 = Cr plane, [15:0] z:Cr [4:12] little endian
  */
 #define DRM_FORMAT_S012	fourcc_code('S', '0', '1', '2') /* 2x2 subsampled Cb (1) and Cr (2) planes 12 bits per channel */
 #define DRM_FORMAT_S212	fourcc_code('S', '2', '1', '2') /* 2x1 subsampled Cb (1) and Cr (2) planes 12 bits per channel */
@@ -424,8 +424,8 @@ extern "C" {
 /*
  * 3 plane YCbCr
  * index 0 = Y plane, [15:0] Y little endian
- * index 1 = Cr plane, [15:0] Cr little endian
- * index 2 = Cb plane, [15:0] Cb little endian
+ * index 1 = Cb plane, [15:0] Cb little endian
+ * index 2 = Cr plane, [15:0] Cr little endian
  */
 #define DRM_FORMAT_S016	fourcc_code('S', '0', '1', '6') /* 2x2 subsampled Cb (1) and Cr (2) planes 16 bits per channel */
 #define DRM_FORMAT_S216	fourcc_code('S', '2', '1', '6') /* 2x1 subsampled Cb (1) and Cr (2) planes 16 bits per channel */
-- 
2.51.0

