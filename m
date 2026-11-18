Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059772;
	b=BsFIQOm9YbsGs892n5ZW3aSvpRZiACanKO/1atTNMgAeEdu51nNlsUPq+ud7n/aWoAlf
	 wzDQ8/SP9QLjT0FXs9hmeFGzbKM/GQtmW6ipq9TNTpADKM3012XkcJMqcE2XG5WWl2EyD
	 952iihQMA0YJwWUSZAXB+/RNaRwGf7lSnNnadWl3Kfk9H+0IJyO+4kAnfdK0Ii6cjj0n/
	 cItHwRzGmk9nFTOgBvIMM3lKVI74nF9aNxTFhVuuALthJURSAOHC85SVAi8wcM9V2ZhDv
	 d2MsFnzYSddVFvSSs83LJIqaBITSGyH+AG9hYyZOi/v/BNWTpRFl/ARq6WIUPprAQZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059772;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y4jLdnVu+lzEhHOTTQfR716SkNTh62KF1UqX7STBlQU=;
	b=Zex4xs0R5+QB2s25gIdbogTjCdfGO4806ra+kfQXsk7e3Zl27EPQRoyC9ywhK1G3nufH
	 LFiuV9CepQgll89znYs4QJLv5MpQJZr+gpkxUolWY/qSOzDxWRF6KIdL9Oa74G05nmkAC
	 v/ts1ih+IqKrpF5oxbhP9B4XBxQbBzRsIvn6/6784b6NH0XlO2yPKfZv7qqMZN5/QxG6U
	 g1KACbQARHtL3P1kjWG1pygQhQhXFy4Kix0QFGf9+1+K0TjvU1LKjIIvWV2YfBv6UExxp
	 xbbHZ337ZTfNkQJ1eY7Ft3/EDnd4su+GZyLAworbnD5ilRAKhAcRKtDa4pc1xDUHnbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z6X5pvR7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1561F606A320;
	Thu, 19 Nov 2026 03:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z6X5pvR7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 333561F000C4;
	Thu, 19 Nov 2026 03:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059771;
	bh=Y4jLdnVu+lzEhHOTTQfR716SkNTh62KF1UqX7STBlQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z6X5pvR7l4cQ2x0HSAEg24cAjEou1dPKJH9eCWo9gDlqTEsROFoFtyvirRPg5twme
	 TEQcMiWYDbqh8Nw+TiKHZyosM9VI/XA6UYULdLr20epOHiH6b73ZpVAK1BuHdO6tLs
	 EN3rWel0U4YG4AJS2/c/yQqQsCC065xGWJm/Lx+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0960/1848] fbdev: udlfb: check for fb_deferred_io_init() error
Date: Wed, 18 Nov 2026 15:49:58 +0100
Message-ID: <20261118145957.180008912@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Omitted fb_deferred_io_init() error handling because the older API returns void and cannot fail. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/udlfb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/fbdev/udlfb.c b/drivers/video/fbdev/udlfb.c
index 23097d190e0b1..d3e7c8f6ae7eb 100644
--- a/drivers/video/fbdev/udlfb.c
+++ b/drivers/video/fbdev/udlfb.c
@@ -1006,10 +1006,10 @@ static int dlfb_ops_open(struct fb_info *info, int user)
 		if (fbdefio) {
 			fbdefio->delay = DL_DEFIO_WRITE_DELAY;
 			fbdefio->deferred_io = dlfb_dpy_deferred_io;
-		}
 
-		info->fbdefio = fbdefio;
-		fb_deferred_io_init(info);
+			info->fbdefio = fbdefio;
+			fb_deferred_io_init(info);
+		}
 	}
 
 	dev_dbg(info->dev, "open, user=%d fb_info=%p count=%d\n",
-- 
2.53.0



