Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063315;
	b=EYXypLvy5u3xvDfuNcMeRs8LztEXPB5qML/O0iIVlblY0wcsX47rFzlMGl+z3EN6DypM
	 UkmY5Ud3DkniAZjtzS3J0YrEZxxIJzYcBgja6y5145LNvUdHAANXN+qQN8DCHnmMe6uVX
	 bQ1SroYQIsgwJplxMVMoTZfnSA4Y5GXZeknhWLmy9WzJ/fiYeb6JDeIv5/OZqWiTgmV97
	 0ysNkPNAGWetLrsCosTHxWlvQ/+WNoJFD6MQau3/SjoAsjZZsx7/s6mbcZ6LPC5SRBCkP
	 QtbrFjDU77xTPIXu/mi9XqrkFUEizL7tE3Fp/ifZgx+aNW6xx917X7IpsxZX667Oj0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063315;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6uHKlC/q8J8fuulcZaDzwTuqx+Yhv6ldCkMyGrf0Ssw=;
	b=MrHxAophbfkW09AKn1keLeTyUZDHS+l/Amavp2ecZ0Rs9+0wJ+LIowqWGN/4OEmyZuzY
	 N8PuWTLzEvjPBfqNqHiG0FekjghTj2HR58DLXHozw3BD5umpM8w7/ZYux/V7NBGyR4Jn/
	 Q3NvLT1EympJPUrw3oGvA8nUHDUj+iq1ZEf1bh+P1i9CtokkKZcojUXfzkvXpqlVbC+R0
	 1UFLHkbw8l8EHOgKNyRrcIoXE9+zvbvQUHAfestYv0aRWbZTRwjkNii3RiyIWZyjVMMBD
	 lrAqzwAzE9n4+irPpezSDJWboBHZODj0PzBjHRRyz7LGVAduVJjHKIexdDgnEnOn3mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wk9jR2nV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076FD606A32C;
	Sat,  7 Nov 2026 14:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wk9jR2nV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A824C1F0089F;
	Sat,  7 Nov 2026 14:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063314;
	bh=6uHKlC/q8J8fuulcZaDzwTuqx+Yhv6ldCkMyGrf0Ssw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wk9jR2nVE9eOJsG4T5W36nKkhaG4AlD+/aYFzCvrDAIgNDTNfj7Kmf9SZ8vYf1l2e
	 TRVDAdcDStsDBAjkCAZNi2wMS9LQ6kQR0ExQ80HiaUzppzXwtyRW2wS8QBiHIDoqG9
	 zTqYpYi6CKSPQhZcYdMPNqg1AROOF/RUr30yWU5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 502/869] fbdev: udlfb: check for fb_deferred_io_init() error
Date: Sat,  7 Nov 2026 08:53:04 -0500
Message-ID: <20261107134910.639081213@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f6da680c29eac..abaac2ed22a98 100644
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



