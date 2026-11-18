Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059597;
	b=FaTM/AOWopz/p8wogndVnVcYfE7099Fclwu26F0mjOjZAJ6/lON4yuH7dvs3kxJn6ADE
	 0dp01/pgKg45vH3P3gW++vwVkufeuo2pQMg+qJ57nGA0qfrfmD8sKhEbZKN/JupaJ82yh
	 C0+r6gctKxEv1aCIeyytGIvU0LinxMx0MhtfWpT8LjjOiM21HaFyhLH43BFJ/NpzWY1ZL
	 25AdgGqMyBWL1rTuxJlYfKdTt9jW0ASQOJUC/6vRnH3JTJYd/yEgD/ZS5edZ3LB+t6vBn
	 PB4x/A1iwYyRpxYfI3H2JiCLEHeGV+ux8HvT/7KlEKGN1AI5+AFteC9CTlGBo9mQ6iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059597;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rma5d9gaGSunZycJz4WzF1FA70sF1bC9U0SR/KsNyZw=;
	b=Hht3Ula1B0AyZDuU9Yy+qYKcPsNC+D4xnCpJrAWR1qFpAwztp9VAT6zdg6LUjhoN12rp
	 hIDNnAxK1Ko0GLxXZdGxoLsIytPO48CZGMidMFbXx9ROO4PFgRJmLOqDucyl08R/d+caf
	 mxo07Vsgk49P6hGtudfwxenLP55F55zskRWzCkkRQtSstXw7fbOULkCQZGoV0I7PmHvEP
	 7Tp3lzNJP0xORCPkC+M2RdbCgHQ1o3Q9BSpygYXHmdILAw+pP9RVhT4Y+ADWcdKkhm4wP
	 VEZxIyyRGOjYDhXvHC8A+6nKbeStw8gFQil1Shpt8QIsruHGAwGC96iYEIdPHukze8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=as0a5bZB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBA860A260F;
	Thu, 19 Nov 2026 03:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=as0a5bZB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A681F000C6;
	Thu, 19 Nov 2026 03:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059597;
	bh=rma5d9gaGSunZycJz4WzF1FA70sF1bC9U0SR/KsNyZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=as0a5bZBqr57DmUDAk/dO2A9LmGYul4w2pEJScgIhe+bKl7yAVYrlzjX8L7umvCUn
	 DncyvdcOLJXkN8kIHEtNSNFA+XGZFnLAPGAvaK3JMY+BkzJrsjPCJNdmTHvhfyJ8ZT
	 1NrV+aaujhxAkmWD28c5MaR7AFfMOgJnB0H3fEXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0899/1848] fbdev: smscufx: check for fb_deferred_io_init() error
Date: Wed, 18 Nov 2026 15:48:57 +0100
Message-ID: <20261118145954.418986485@linuxfoundation.org>
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

[ Upstream commit 8ea6c6e77ccf887f3e68c64f4c261071a345da1e ]

fb_deferred_io_init() allocates deferred I/O state, populating
info->fbdefio_state, or leaving it NULL if an error occurs.

Currently ufx_ops_open() ignores its return value.

Therefore if an error arises in fb_deferred_io_init() (for instance, due to
an allocation failure) info->fbdefio_state is left NULL.

fb_open() will then dereference a NULL pointer (calling
fb_deferred_io_open()) as soon as ufx_ops_open() returns.

Additionally, if the allocation of info->fbdefio itself fails,
ufx_ops_open() sets info->fbdefio to NULL and invokes
fb_deferred_io_init() regardless, hitting BUG_ON(!fbdefio).

Fix this by only invoking fb_deferred_io_init() if the allocation
succeeded, and checking for the error.

The driver already supports operating without deferred I/O, so in either
case fall back to that by setting info->fbdefio to NULL.

The ignored return value was introduced in commit 56c134f7f1b5 ("fbdev:
Track deferred-I/O pages in pageref struct").

However, the BUG_ON() issue originates from the earlier
commit 3c8a63e22a08 ("Add support for SMSC UFX6000/7000 USB display
adapters"), so target that for the fix.

Fixes: 3c8a63e22a08 ("Add support for SMSC UFX6000/7000 USB display adapters")
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Helge Deller <deller@gmx.de>
[ sashal: Omitted the fb_deferred_io_init() return-value check because the function returns void. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/smscufx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/fbdev/smscufx.c b/drivers/video/fbdev/smscufx.c
index 08a4ce3dfb1d8..6d9121570f343 100644
--- a/drivers/video/fbdev/smscufx.c
+++ b/drivers/video/fbdev/smscufx.c
@@ -1096,10 +1096,10 @@ static int ufx_ops_open(struct fb_info *info, int user)
 		if (fbdefio) {
 			fbdefio->delay = UFX_DEFIO_WRITE_DELAY;
 			fbdefio->deferred_io = ufx_dpy_deferred_io;
-		}
 
-		info->fbdefio = fbdefio;
-		fb_deferred_io_init(info);
+			info->fbdefio = fbdefio;
+			fb_deferred_io_init(info);
+		}
 	}
 
 	pr_debug("open /dev/fb%d user=%d fb_info=%p count=%d",
-- 
2.53.0



