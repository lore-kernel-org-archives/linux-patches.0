Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1807B389DEF;
	Tue, 10 Mar 2026 11:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141643; cv=none; b=NPI+jPdHF9g4q8MUx3QHoPnIySMV06+UhTVi/H1OiEhfCs32nJzcnU3i/qC2zAWrKKmGAwHk3drcp6Su8cW760O4Pad6sUk9BOmwWE5eV0VWzHB48+CwyYyaOEw5Z4DjdwiGTIynIklurVv+JIZ4wcyHg83WkC95S3860j34J2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141643; c=relaxed/simple;
	bh=ipBtywZ7HIHGRpmn2N1ZpWu3QCgyHKVKSqQn00Rfv1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A8YAWu5j/9IGTGFmlz3Z01+Ggd0qG4cB/fxpgOXqxMCmOuP2frGBtuZLWWCL1lg8B2pEegzbhVDDR4qobQFParGuKkDFXf+iLsS2H/jaGsLXPattYTtUe11bE+8si6KAbRRbfpP+plu5jTNEOHf6zIAyP1gTdoPWYIa+mrzDYn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZRzjN6qs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZRzjN6qs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41744C2BCB3;
	Tue, 10 Mar 2026 11:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141643;
	bh=ipBtywZ7HIHGRpmn2N1ZpWu3QCgyHKVKSqQn00Rfv1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZRzjN6qsT9SjxGN2Y5GMBfswSnNz72G28aTfsMyodxEFumX2+Dl/Vp8K8sEbzErzG
	 9GkCQGgcIPqG8h2eudVzoXs/rfg0rEmCyuX9BfyrHA8hwciQzImVQhLZv8xOozysWx
	 b4zwp0OCzXZJXzQr4bCoRDdj9qQJSP1vBOEalLpl/L1Mju8r4hA1p/cmaacybudmWi
	 sbgwhS8NbKNni2ndZYcbWji9ZB6/3zQm/cWAaWJGO4bASuKZswJuJm+ZxTlJ22dtrs
	 P97FNbfsvnfDx+VyjsT8DGv6tTpiCzuAWNTqFnxVv/qTWt/WkKWtl2ApexNZ8bPmVh
	 84vXBrWE5tHnA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Simon Ser <contact@emersion.fr>,
	Daniel Stone <daniels@collabora.com>,
	Robert Mader <robert.mader@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 008/314] drm/fourcc: fix plane order for 10/12/16-bit YCbCr formats
Date: Tue, 10 Mar 2026 07:14:27 -0400
Message-ID: <9fe012e3a37988e39914f7edab06a292add5c04d.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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

