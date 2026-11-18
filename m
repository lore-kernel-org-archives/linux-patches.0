Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045472;
	b=sUmAfjn4h/M9JNUvkKc57gTX49VuJYNZiH4A7r78rSk8RHwpFL3hRDjXuLh5kLQv69N4
	 w/5/aW82gcW5fJMY4O6ZVbifK13lYWg0khcwuzqWG/gMfEDDCoWYfM51K78sJ/4oduaDu
	 VM+qXKvlcqPPhy4GDaNvSS3lqpTDBmVaqv3j2JjQrH2i9gZkBRSMQvii3oTZNUV2uJXor
	 oScQCd7RVEhf7cQA+Zzqr52gYGZKQSbMv6o36MN3RBWLXz0AekEFmU9pJfy+BwM4R+IAN
	 MTuOjtgxWxwdbDDdv6FXF4e0cIRSyXOD15F6bI3Dsq5lXRK/rK+Ai3mf7E3CNrYBBIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045472;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S/Xv+wcwUl1lrvH/aKb1Xd+fUYtzIOMi8cpVSkxpM6w=;
	b=rISI7P4KqwJ6uxIJgySNXWHuyQKkQrOjLGYHvMAYBYMe/OoUx54XCc7prJ9IqBd36edo
	 CuT7NkCVTPTPzsQAZCcFXItv/t7wD2BuCWVEH9aJds65XNzmgxsBLdYxuY9Xj46CI6/b/
	 si6Ndzfj+kVchduTkTfXN5Iw4BUxks+LH+wuI/50KJ32FP8iOOqss7AJWulGvZUFhEDLa
	 DcPzLDk+w9scLENvGdI41hI+x+ry4NqOlxhDclhou0cGZVTNMvjT77o/JafNnPoFzzBD8
	 YZ8/Oryi0y4wro10y8eS3dQcCId9D+0eA5xLlVtnYR07BgLPIh8DcWVTYc9hU0ESXFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xS4vZdOU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768F1606A325;
	Wed, 18 Nov 2026 23:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xS4vZdOU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DC91F000C4;
	Wed, 18 Nov 2026 23:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045472;
	bh=S/Xv+wcwUl1lrvH/aKb1Xd+fUYtzIOMi8cpVSkxpM6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xS4vZdOU2/NKmDBaY26anGCK25AuZDSlXW91n/H0+Tl7tDdWKhXgiBXk81CGrdAmx
	 /01lNdIjkByEADj4fpXzbG59EBcqBD9EIuILTfEa8q05O0T/urE5oETHXb/bqwIVNs
	 dEb7MpmgJngD+EAtkSYxpkdcv/Ja9D8QN63cPGcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0933/2857] fbdev: udlfb: check for fb_deferred_io_init() error
Date: Wed, 18 Nov 2026 15:32:47 +0100
Message-ID: <20261118150235.181280876@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4faa90416c670..0c0e8f56be7e3 100644
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



