Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063316;
	b=E2MNFAX2o5QtSpzYIiTODzlvKSOBbU+UQ7SqnwyuNFE6Mup5eYVhDHRwAXmW2K2REYs7
	 BoseH5c+bxNYzY+wDm82xLvDJLEa56OVgmoMSGTikovRIzYXbC1qJaW6R81XMmMvGEYmW
	 1UQxEk/H08xa+MH/XkwKRKQDNVaXU34bNlD//WqpBduwlGe68AiCyHAX1s8+kVXq5pZ8J
	 MHAUvqiJ1S2hkUwjGaXNjgdJbpFQUxS3+YmSaqJLam194WXqN2obzfAonAfysWNoDYexN
	 HivshpZooP44+SJdlUe2vWDupAo2FPWa/O/Zazwe6C4YQrPLLT0TgcW129cetnkIX2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063316;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/H2QtNpJZiXBvTKz0LhZl+vv44/Uy5asG0XaES/8MVU=;
	b=glpJzWJC+Bu4bEFI95Ht8ChVZlnoWUeAROCW+eVX7kB+rRt0ab015vVwv8kDG0NhRs+K
	 Yh9QMNg/c/RSfGAt3N5TNg0/uQaF/116UCCM3gew0d8Wpi4Asaol7w1A1Qxk5yEX++MzT
	 CHZbOHsnMZsa7ZA5GOtoqcc8uy1L1m8r7ZpaEqsZhIPQSVR/myS0RIVXDraFlInGu+KDx
	 rc0Efc2dd0NdtguPgp4ZcF31X2kRwgUfBE1rdqKPwi8Tuu1nh/D9fXqUoVVFDTHo6J45m
	 r1J8BlFopOlvPQluUBACLSf6MoVS+sruOxHQGO3h6x24zb1tp5ZJ4lG1pmZIqbbosYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lGUg7kdc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F95606A32C;
	Sat,  7 Nov 2026 14:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lGUg7kdc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9EDA1F0089F;
	Sat,  7 Nov 2026 14:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063316;
	bh=/H2QtNpJZiXBvTKz0LhZl+vv44/Uy5asG0XaES/8MVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lGUg7kdclqAMYMM3P4/PT3ZUHauTylAuUMQP1QmyWJk9IHzP6gyiOaICK9zMMVVRW
	 lS+7Vl3vnfZRWhCXra7tV6LRN3I3iucs9l+1C8gkUGrdsuxq9wu9BvbplYk2Msl83d
	 1O7bq/zDjhTTdVpp7uzCENdsTdJfgdQf67ACVWSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 503/869] fbdev: smscufx: check for fb_deferred_io_init() error
Date: Sat,  7 Nov 2026 08:53:05 -0500
Message-ID: <20261107134910.666177135@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/smscufx.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/video/fbdev/smscufx.c b/drivers/video/fbdev/smscufx.c
index 891ce7b76d637..30a94d85fc8c1 100644
--- a/drivers/video/fbdev/smscufx.c
+++ b/drivers/video/fbdev/smscufx.c
@@ -1041,10 +1041,13 @@ static int ufx_ops_open(struct fb_info *info, int user)
 		if (fbdefio) {
 			fbdefio->delay = UFX_DEFIO_WRITE_DELAY;
 			fbdefio->deferred_io = ufx_dpy_deferred_io;
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
 
 	pr_debug("open /dev/fb%d user=%d fb_info=%p count=%d",
-- 
2.53.0



