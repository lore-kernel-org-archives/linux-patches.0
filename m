Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3D922EA1E;
	Thu, 12 Dec 2024 16:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020999; cv=none; b=Tt1pXzYVFrfLp9vvUx+cSVohofh0lFgigFQ4zthwFKJY3kSqqctuYOxr0BGuRpf0NjdtI+r9AiHhbVniQHdGcxOBiVeEf9ONadMfxzOL520xVvsgU+8HTIxqJXJMWMJiiBCyvI4/bCsXExvHq76eSGCdw17HBQFJaH3XEGx4TzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020999; c=relaxed/simple;
	bh=aDzGzcBxK+4Pbjrup725Xyi1bT6IhQ+oAlPFXMFjd2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pK31QymTzPuVk2PTnGmqI8I6fxqOQiwXE8laHF+IItKhLgpHBGlIU8XWOcgz5mrYPoUyyE0Z6/896DqpskjmzEn/yUnLeBhghHmdP6yfzLkKHKKn6CP4fCLHrchDbKrL7pN6uXzQfnwnMaT6b5dq1DEwgfmc6TWVnr14AnAXVG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZAkabsfw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZAkabsfw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51073C4CECE;
	Thu, 12 Dec 2024 16:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020998;
	bh=aDzGzcBxK+4Pbjrup725Xyi1bT6IhQ+oAlPFXMFjd2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZAkabsfwih7kcKyc80Bd8+mOehLg5WK612FThV9+KItREOgDA4ef7fDrMRbidl/EE
	 TwzWkfwQExxy8svDpoexhq/uh5tdBe/oKLpDrebQH/qmPHfbkCElOrjGKONcZ4SA34
	 bokQO7syynFCxxLyEm4T40EOg19bBun2XFCL+15c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Raphael Gallais-Pou <rgallaispou@gmail.com>,
	Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 588/772] drm/sti: Add __iomem for mixer_dbg_mxns parameter
Date: Thu, 12 Dec 2024 15:58:53 +0100
Message-ID: <20241212144414.234714089@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 86e8f94789dd6f3e705bfa821e1e416f97a2f863 ]

Sparse complains about incorrect type in argument 1.
expected void const volatile  __iomem *ptr but got void *.
so modify mixer_dbg_mxn's addr parameter.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202411191809.6V3c826r-lkp@intel.com/
Fixes: a5f81078a56c ("drm/sti: add debugfs entries for MIXER crtc")
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Acked-by: Raphael Gallais-Pou <rgallaispou@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/c28f0dcb6a4526721d83ba1f659bba30564d3d54.1732087094.git.xiaopei01@kylinos.cn
Signed-off-by: Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sti/sti_mixer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/sti/sti_mixer.c b/drivers/gpu/drm/sti/sti_mixer.c
index 7e5f14646625b..06c1b81912f79 100644
--- a/drivers/gpu/drm/sti/sti_mixer.c
+++ b/drivers/gpu/drm/sti/sti_mixer.c
@@ -137,7 +137,7 @@ static void mixer_dbg_crb(struct seq_file *s, int val)
 	}
 }
 
-static void mixer_dbg_mxn(struct seq_file *s, void *addr)
+static void mixer_dbg_mxn(struct seq_file *s, void __iomem *addr)
 {
 	int i;
 
-- 
2.43.0



