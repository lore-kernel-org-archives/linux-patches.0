Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C2229BD98;
	Tue, 26 Aug 2025 11:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208814; cv=none; b=iYGz+Pn86xf5Ev2mPtSR+sm+J3at6PKsxQH65V+RTbzVtnqtS/QqwEj0tlaVJr6nXtfauNlaXqZ2jy4ll6bvnQ/k+RMsodWaOwZI2lFkeebBieLxtCKwucaI1ngUx40wg97TASuVXW0fWPBajLWbXbhByfIqHEPOM/X65Iy2SHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208814; c=relaxed/simple;
	bh=YrMBqVTdDMrJEl5KV+/03cVAll1tQ00Qj5oYLNI7evs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Clsws2RvN3lIYRpchHi5eaTet9T1t5zwb1zAga7fj+4Gh/8aPtj7kmXLYeLfY1wgKFhcDogV+LVsALaQhWMz8MbUCwKwMR0jEz92TmTNOK8zSu/5m9sSRp8fsEfxI+85xbEhi5hY6W+W8eYgFGX/AnF7JSpF8fOUVKKVOmp+fAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LdS8s6g6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LdS8s6g6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FAAC4CEF1;
	Tue, 26 Aug 2025 11:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208814;
	bh=YrMBqVTdDMrJEl5KV+/03cVAll1tQ00Qj5oYLNI7evs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LdS8s6g6gUgdw3WbfQqAg29EnMCKZnhkZtYDhzsmmFQw2p/r/Fy/0Clm49X/fa5qW
	 YSe0oNEgrHF5op/zOOtd1vv5YJJXL/eeDLPo3ndhVoBjISjvWdwyo7lB5Eos2pnyb5
	 I+7wOiPxsgXkJpGEK9+JlY3Uxl4KDI2VGrNZvbuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 256/322] drm/tests: Fix endian warning
Date: Tue, 26 Aug 2025 13:11:11 +0200
Message-ID: <20250826110922.257577526@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit d28b9d2925b4f773adb21b1fc20260ddc370fb13 ]

When compiling with sparse enabled, this warning is thrown:

  warning: incorrect type in argument 2 (different base types)
     expected restricted __le32 const [usertype] *buf
     got unsigned int [usertype] *[assigned] buf

Add a cast to fix it.

Fixes: 453114319699 ("drm/format-helper: Add KUnit tests for drm_fb_xrgb8888_to_xrgb2101010()")
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://lore.kernel.org/r/20250630090054.353246-1-jose.exposito89@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tests/drm_format_helper_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tests/drm_format_helper_test.c b/drivers/gpu/drm/tests/drm_format_helper_test.c
index 08992636ec05..b4d62fb1d909 100644
--- a/drivers/gpu/drm/tests/drm_format_helper_test.c
+++ b/drivers/gpu/drm/tests/drm_format_helper_test.c
@@ -991,7 +991,7 @@ static void drm_test_fb_xrgb8888_to_xrgb2101010(struct kunit *test)
 		NULL : &result->dst_pitch;
 
 	drm_fb_xrgb8888_to_xrgb2101010(&dst, dst_pitch, &src, &fb, &params->clip, &fmtcnv_state);
-	buf = le32buf_to_cpu(test, buf, dst_size / sizeof(u32));
+	buf = le32buf_to_cpu(test, (__force const __le32 *)buf, dst_size / sizeof(u32));
 	KUNIT_EXPECT_MEMEQ(test, buf, result->expected, dst_size);
 
 	buf = dst.vaddr; /* restore original value of buf */
-- 
2.50.1



