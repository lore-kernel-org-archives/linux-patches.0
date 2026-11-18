Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036506;
	b=EF2sHQsaAQfhuiup9+MxLz/tJ3MO0ibJB9LwEMpdMn4ybdf1wmYrxmm2VD6n3SVHv5GO
	 rtVI1/UZVCJMzI1y8pFJCDuCHWgjBeucPBkJYWo+bSeJBQE5GbA7wagX7yZ5hwfAfzc5g
	 kXqKZchPq7fL4eWgpZvT1tryeEmYLZwAw5sYx9XE7T5CsgLGeE0S+Khd8UlIf8CMUc1fO
	 G2eVkb+8mrHylQT1y1GMi2tyajxoBl0DmzpQqOEB2W5U+456Oy/23UQehQbBFGi7gwnGb
	 tCrJT+NT8CCGyEdT95UbF9iT2x3ZMIuUXjIWA63PW+E7tEicsWPlvtspoP2+kHi9V1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036506;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tnKvvxg2iuppivc78bCOEQaGg5dnsvztymp4VDznPqc=;
	b=UZ8d7mi84FW2RlchIVi5SBY0v7VUnS0qgGtlxVF9sglxEVZfppjKPG5JMkNVUEEEuN0n
	 ZlRQUaqOeTDYHas2yTF0mv0Mzl6e3CcZCHEByhjByvwGr9boHx9mSdG75GlsovjcQVKOB
	 0soE98/5lcGMui5xj/ZuhosBk+BSvPUR6bIWgo/Wf97YjugeOXHTDs/0Y3z3Mk+SjKCL9
	 xUq4O/8Jn+PS9tqSoV+U8gGqNverS9fq55i9SvH89J8DCQf2JJ3EUWwzoHfLn0TRWWtaz
	 Cy+ASThRsv3k/mD7mEfafLK3xUFs334B8fgwuWK54KBkSvIelgkWVEbfLI4RIfPbv8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r3C9G7Uu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F323A606A32C;
	Wed, 18 Nov 2026 21:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r3C9G7Uu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 518F51F000C4;
	Wed, 18 Nov 2026 21:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036505;
	bh=tnKvvxg2iuppivc78bCOEQaGg5dnsvztymp4VDznPqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r3C9G7UuJxsnPadl0I7KYdfPA39/29CyCwlLpM5pyr3d95dzsRJU0PSwLyPUKnneF
	 /5TiUTDeITFp4Ntx7vnTwCscLTFJt9Pm2h3v2mfdMO0KH7KDCb7J0gwTn3FFdAaDBt
	 q17oIVKJu/y85gZqyFXzWqE3Ze+CUEK159GwNejc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1084/3318] fbdev: udlfb: check for fb_deferred_io_init() error
Date: Wed, 18 Nov 2026 15:28:26 +0100
Message-ID: <20261118150352.490480404@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index dad4a67f2a120..74eca71f7a650 100644
--- a/drivers/video/fbdev/udlfb.c
+++ b/drivers/video/fbdev/udlfb.c
@@ -1007,10 +1007,13 @@ static int dlfb_ops_open(struct fb_info *info, int user)
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



