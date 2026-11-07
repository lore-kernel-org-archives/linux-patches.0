Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062324;
	b=YJSerZZ7/a4qjNCeC8zDoxzx744UjG4IWYqG3TCf1IBxeiBq+ynkGH3jy5K2uFxI+JTC
	 7JOeu4XrBn8w1a4+qwJ93Gy2MWgkUx7qpAAgDGdnsPDrk50/PFjc7XWcqLc30ebnFdncn
	 Ux3ndrcif/RfLpRybmmJRrj99atzLHA0eVmbapnimf8nyonBH0uC0eOPq1z98dloo3rPu
	 ezqV7JCsk2NUKpo/uBxYwDcLSVQz+PxMoWHlRT/t2DTOSyRmT5/W07PyT+WUGf7a8blTL
	 gfIeyWsnafW8zV4RldmyzaxnEy1aNnBUPAtu+ITjKR/ANeV28GuiP6vGYluNMAhSXhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062324;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8e15NLPrIus+kYtXp0R/mKfSJn55Zk8O5p6G8knW/bQ=;
	b=CC20trIvlAU2TVS7G0x0joP5bvb2P9nFJRveGo/6fwiLU59UCBbYFRTSQ+OffQJPdmHt
	 pPas6tlahQLwBgF5YBKLBe+tgmBQvbmidCdNcyTUbtceTsPDjXodSknNIr31rx22A5YY1
	 wYQvOeKHqM3+3DMGZPenyaickaZHwefb4alesCfJbNzAVl7wWAtk2cL74Hkt6yXubG0uW
	 j+yzuiUeLoTRSPWzv+s88j9I6uZmyZYAodl7eq/sz91w33BF49ZiJ54o4F0N3H2lgbu1/
	 5LS+7uezN/IFzRZajt/HEZbBfjeQIIVFQbf1FaC8iJbqdmuPP335ePLmVk437ztr6PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R3TCthbN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1FD606A660;
	Sat,  7 Nov 2026 14:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R3TCthbN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB041F0089F;
	Sat,  7 Nov 2026 14:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062324;
	bh=8e15NLPrIus+kYtXp0R/mKfSJn55Zk8O5p6G8knW/bQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R3TCthbN++Dxpefc3cQeGbop9Vi742vpMAkKQViqRnfizhql58JZLKzwkv2aCOWAE
	 TjA1riJ3NtVBzL4z27vbujH/TSNm0UNvax5kqVlxhWoJQyb+ogH6Pdz67LqDpbA/cv
	 Zskv97gMfoVB8se7DNvzH6sd/i2ioaaUKgMivkzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1256/1536] fbdev: udlfb: check for fb_deferred_io_init() error
Date: Sat,  7 Nov 2026 08:54:32 -0500
Message-ID: <20261107135033.049601660@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

[ Upstream commit eae055f33e41e1d3e1a7e905bdcb1e9f196ed31d ]

fb_deferred_io_init() allocates deferred I/O state, populating
info->fbdefio_state, or leaving it NULL if an error occurs.

Currently dlfb_ops_open() ignores its return value.

Therefore if an error arises in fb_deferred_io_init() (for instance, due to
an allocation failure) info->fbdefio_state is left NULL.

fb_open() will then dereference a NULL pointer (calling
fb_deferred_io_open()) as soon as dlfb_ops_open() returns.

Additionally, if the allocation of info->fbdefio itself fails,
dlfb_ops_open() sets info->fbdefio to NULL and invokes
fb_deferred_io_init() regardless, hitting BUG_ON(!fbdefio).

Fix this by only invoking fb_deferred_io_init() if the allocation
succeeded, and checking for the error.

The driver already supports operating without deferred I/O, so in either
case fall back to that by setting info->fbdefio to NULL.

The ignored return value was introduced in commit 56c134f7f1b5 ("fbdev:
Track deferred-I/O pages in pageref struct").

However, the BUG_ON() issue originates from the earlier
commit 5bea1fbf9423 ("staging: udlfb: fix incorrect fb_defio
implementation for multiple framebuffers"), so target that for the fix.

Fixes: 5bea1fbf9423 ("staging: udlfb: fix incorrect fb_defio implementation for multiple framebuffers")
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/udlfb.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/video/fbdev/udlfb.c b/drivers/video/fbdev/udlfb.c
index 1c3933c21e35b..2fffe5a2d66cf 100644
--- a/drivers/video/fbdev/udlfb.c
+++ b/drivers/video/fbdev/udlfb.c
@@ -947,10 +947,13 @@ static int dlfb_ops_open(struct fb_info *info, int user)
 			fbdefio->delay = DL_DEFIO_WRITE_DELAY;
 			fbdefio->sort_pagereflist = true;
 			fbdefio->deferred_io = dlfb_dpy_deferred_io;
-		}
 
-		info->fbdefio = fbdefio;
-		fb_deferred_io_init(info);
+			info->fbdefio = fbdefio;
+			if (fb_deferred_io_init(info)) {
+				kfree(fbdefio);
+				info->fbdefio = NULL;
+			}
+		}
 	}
 
 	dev_dbg(info->dev, "open, user=%d fb_info=%p count=%d\n",
-- 
2.53.0



