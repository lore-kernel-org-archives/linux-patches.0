Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E88E34A31E;
	Tue, 26 Aug 2025 11:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207913; cv=none; b=IomX7ke3g9Pf8u0Qhp5fvpQaqJr8ozC+rchjO7dDxbmNoOvm2cwfjGYLMw2R4Qgtl9m9nYxAkzBWhz88cr9366lFQojZvsAKBN1x3bN4HS+15R+g9SIBPt8KkkT8KQSkkZMWmt7/NPO2HFlyVJfIPyzNuyarQcZLIZWCkfNAoz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207913; c=relaxed/simple;
	bh=Ph8Or5Z8DpExZcHLdFQXeBHAohoBxTnqcUXNV4Lq8+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uq9xWUAIMNudCXvQwaXZg5IxdanjqH+E6d91/irJ+eNIPmzeM5jnm4O1APlkvSzmg5fUnwnW4SMF/K/+R+Ej9vLZdzRB/fSdNWr3/gr6jWXwXXIua2Ls7MCYBkId+5e5+MoxprIJNOSeJWjCb55k5FpYADDmWADAdOdg6R1dAis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QQyogsrA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QQyogsrA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2946C4CEF1;
	Tue, 26 Aug 2025 11:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207913;
	bh=Ph8Or5Z8DpExZcHLdFQXeBHAohoBxTnqcUXNV4Lq8+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QQyogsrA9uSpI+4MvrMclGhlh5X04ZJOQQZ4LYWJHzTs0i1vxcfWm31M+3QXvxd6i
	 pRDeJSXMMcpuDaCq5KnoJSxnXSOq53I2a5wqrE2tk3LHUOufmM236y+cbLwdSnyQMy
	 J9jYZkIeSrtNniInGrbsZEamitmWionUXh3WA4eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 348/457] drm/tests: Fix endian warning
Date: Tue, 26 Aug 2025 13:10:32 +0200
Message-ID: <20250826110945.927165586@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 35cd3405d045..2a3d80b27cae 100644
--- a/drivers/gpu/drm/tests/drm_format_helper_test.c
+++ b/drivers/gpu/drm/tests/drm_format_helper_test.c
@@ -1071,7 +1071,7 @@ static void drm_test_fb_xrgb8888_to_xrgb2101010(struct kunit *test)
 		NULL : &result->dst_pitch;
 
 	drm_fb_xrgb8888_to_xrgb2101010(&dst, dst_pitch, &src, &fb, &params->clip, &fmtcnv_state);
-	buf = le32buf_to_cpu(test, buf, dst_size / sizeof(u32));
+	buf = le32buf_to_cpu(test, (__force const __le32 *)buf, dst_size / sizeof(u32));
 	KUNIT_EXPECT_MEMEQ(test, buf, result->expected, dst_size);
 
 	buf = dst.vaddr; /* restore original value of buf */
-- 
2.50.1



