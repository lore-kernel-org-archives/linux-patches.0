Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DD62F83CB;
	Tue, 12 Aug 2025 17:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021152; cv=none; b=iV0lx7OqB3BkcU1wQP+6XvFQJK2WuPkx5L6BPxhvKozwnWYR5WL8A/o9c8MQyA2hMICzpTO/KZtB/3r8LPDYXD6PiATZ3hQSK7LNX2JY9P2TmyWsxdnFq6xmp/U9QZTgoBqyHrRSi9UJTJoBscQwrtuGsP0Bf9CtxldKpjF4umU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021152; c=relaxed/simple;
	bh=b18cr8VyWYMJyvem1IU+abCW2fIZSmDYbQQu/9kaYUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HqsLCC+MB1+0seeaPUJcAO7KTD3PmsGoIyhmq2v9iCNp9g67VmcsLbFHJQobIG98Wmg8Y+vfLWWScoxsYTNl1MubzSahfPxk8iwaWZN1yVeOEPuSUxm/nNm5oknwSsvnUefWxME6YW3vrpg/I9BLVKLqhmeDGkxn8oXxdlL6q4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QGQz0ck8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QGQz0ck8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18355C4CEF0;
	Tue, 12 Aug 2025 17:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021152;
	bh=b18cr8VyWYMJyvem1IU+abCW2fIZSmDYbQQu/9kaYUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QGQz0ck85Z3BxcZI1nFgjdqHlejhCh/uQSyHTqscN2f2iU58/izBPnuOVtHAfHJW0
	 mTESI/BCV2e1DesT07bIh0bYjbYiiTMzUPxBR20TulhvsAgJVPJriB1aJvJXCiFoZm
	 yHiGcrFnxxZfORY4tbPBh2fSVOup9o9kxPRl0CfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shixiong Ou <oushixiong@kylinos.cn>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 070/262] fbcon: Fix outdated registered_fb reference in comment
Date: Tue, 12 Aug 2025 19:27:38 +0200
Message-ID: <20250812172955.998158256@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shixiong Ou <oushixiong@kylinos.cn>

[ Upstream commit 0f168e7be696a17487e83d1d47e5a408a181080f ]

The variable was renamed to fbcon_registered_fb, but this comment was
not updated along with the change. Correct it to avoid confusion.

Signed-off-by: Shixiong Ou <oushixiong@kylinos.cn>
Fixes: efc3acbc105a ("fbcon: Maintain a private array of fb_info")
[sima: Add Fixes: line.]
Signed-off-by: Simona Vetter <simona.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20250709103438.572309-1-oushixiong1025@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbcon.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index 9d095fe03e18..ed68ba89b80b 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -935,13 +935,13 @@ static const char *fbcon_startup(void)
 	int rows, cols;
 
 	/*
-	 *  If num_registered_fb is zero, this is a call for the dummy part.
+	 *  If fbcon_num_registered_fb is zero, this is a call for the dummy part.
 	 *  The frame buffer devices weren't initialized yet.
 	 */
 	if (!fbcon_num_registered_fb || info_idx == -1)
 		return display_desc;
 	/*
-	 * Instead of blindly using registered_fb[0], we use info_idx, set by
+	 * Instead of blindly using fbcon_registered_fb[0], we use info_idx, set by
 	 * fbcon_fb_registered();
 	 */
 	info = fbcon_registered_fb[info_idx];
-- 
2.39.5



