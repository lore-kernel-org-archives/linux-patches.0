Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B378129D26A;
	Tue, 26 Aug 2025 11:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208832; cv=none; b=IbB9Dbr6zbEYJlazLewN8lqYIVDmxVqb9Lw1uyFWgKlFMhYDb0bxxUmFcUxJiCc0pSCGu1Ww4zFPhx/l6ROFcZykOm74mxbmL9Ygqrhr3r6FtAb3zZoNcoG3RFzm0i+Ebxjl373o04/Neoqo7ECkVhqIwcBtqS0XMf3tVhx3OAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208832; c=relaxed/simple;
	bh=RbdxzciDSmUAx7a3aj8S+jqrZeoWJdXUsuzDoVk6wa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vut1fL2EvLDg3/AzK/dqaWhBTYKN3RDmRuSnbLmspDSetIbZnv03X/HuW9spPtsI4shmUwNbVMp2FKjeUgpVPi3GF5nRrQxpPvclN2ok1BZ5T0KEwq2C2UVf+8IKPhqialzOCpfTbqOqupFq6ofBT8ejFkj8/ZdCxgorFbTPA3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o2NpE9L4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o2NpE9L4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C87C4CEF1;
	Tue, 26 Aug 2025 11:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208832;
	bh=RbdxzciDSmUAx7a3aj8S+jqrZeoWJdXUsuzDoVk6wa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o2NpE9L4XlUM8xXypERFK6nb5KIZdzI458hd0nddAMHpmssy+1CmIa1ulC8r5oDpF
	 /+fikburg2h78KIMCVmy4o22W8XSuFNUXc8/5BFPgfWfNChEmKvr7/yQEU/rygK4qp
	 SsAWP0x9xp5cPiuGpiKYlb+BP3OehV2z3oxAWgKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 262/322] drm/tests: Fix drm_test_fb_xrgb8888_to_xrgb2101010() on big-endian
Date: Tue, 26 Aug 2025 13:11:17 +0200
Message-ID: <20250826110922.403771200@linuxfoundation.org>
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

[ Upstream commit 05663d88fd0b8ee1c54ab2d5fb36f9b6a3ed37f7 ]

Fix failures on big-endian architectures on tests cases
single_pixel_source_buffer, single_pixel_clip_rectangle,
well_known_colors and destination_pitch.

Fixes: 15bda1f8de5d ("drm/tests: Add calls to drm_fb_blit() on supported format conversion tests")
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://lore.kernel.org/r/20250630090054.353246-2-jose.exposito89@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tests/drm_format_helper_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/tests/drm_format_helper_test.c b/drivers/gpu/drm/tests/drm_format_helper_test.c
index 8b62adbd4dfa..e17643c408bf 100644
--- a/drivers/gpu/drm/tests/drm_format_helper_test.c
+++ b/drivers/gpu/drm/tests/drm_format_helper_test.c
@@ -1040,6 +1040,7 @@ static void drm_test_fb_xrgb8888_to_xrgb2101010(struct kunit *test)
 	memset(buf, 0, dst_size);
 
 	drm_fb_xrgb8888_to_xrgb2101010(&dst, dst_pitch, &src, &fb, &params->clip, &fmtcnv_state);
+	buf = le32buf_to_cpu(test, (__force const __le32 *)buf, dst_size / sizeof(u32));
 	KUNIT_EXPECT_MEMEQ(test, buf, result->expected, dst_size);
 }
 
-- 
2.50.1



