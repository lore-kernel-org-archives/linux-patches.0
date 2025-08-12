Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9B529BDB7;
	Tue, 12 Aug 2025 19:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025802; cv=none; b=I9V+7l53sKSNtXenODYJndX1rjGNELauaq2QbP6hjaZIYWOEzXEM2D/vtdqbxlqQ5fIzFo15d9dY9sAud7gAqoIMr0KptnNVTmiJsXm+1OHu5enZpVtWaWAfMy+0Ub74vD5XPuL1ovKPXybGo8auXiYG2isOFUyvT2jHyRsTZhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025802; c=relaxed/simple;
	bh=sqGhzEXL4Ey4PNCS3bIqSoSD2fxcim1KSE4h5FHdeMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n/mIKOEv/W8A+4vca09Q5Yk0o3kuKy568WUmvrbOimoHfY3BwdDyTJWeVQZUw5HgT0segpojKL6vC++/xQZP1DzRYsmwhi+DP7WynqL45r6gnFHjfRqre2kCAjNpZkK1RnPdZYgLtQVnFG3I+SL4b+ZYB9CbdAAzaFgpnir7os4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ABvv9H/h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ABvv9H/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD7DC4CEF0;
	Tue, 12 Aug 2025 19:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025802;
	bh=sqGhzEXL4Ey4PNCS3bIqSoSD2fxcim1KSE4h5FHdeMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ABvv9H/h7rXuBZiYkwefbRKNpwhBvMYLhrTYP6SigDPWVMhjZIzIyUXA6KbFTIhGu
	 0q+mUTJONusLUZTvckzUuKQARgFjKvtXYSAdorOCDXKowzHu4BSfHZBUDT+ICscdIm
	 ta1toz0kLoJhucH4FBe61PDUngBPgkp+Fgx0U/Fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shixiong Ou <oushixiong@kylinos.cn>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 147/480] fbcon: Fix outdated registered_fb reference in comment
Date: Tue, 12 Aug 2025 19:45:55 +0200
Message-ID: <20250812174403.573346811@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2df48037688d..2b2d36c021ba 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -952,13 +952,13 @@ static const char *fbcon_startup(void)
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



