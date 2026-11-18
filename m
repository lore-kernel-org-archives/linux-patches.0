Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052619;
	b=qNIEpoXWWJ5JNgi69h6ItjD5VGAe9/LdBPV8e+tI+A97Lz55OJwicg2rB8Y68z8l7KKd
	 abOpmR1WXW5hKSkhhfTlDXaLKGg4wjfpWPDXc4iZfdlKzbCyWNtIjvWBbVFVH23Vporf0
	 O83Qi2YZXV+AgmronKtUvWbbzYqhe23NtIk5Cn5UXfoJMxB8/SYY+dqVJwy9lCWpiNk7N
	 3zanDFawrNzXh0rD3g+otJAsvRQlyJPB/IRDQw+5uNfIrE4sicXe5eOlND1x5HMOx58iC
	 7j9of/u7PdFBlvMhigZ1ekAi2MP+DG8R6QiwETydqlZR6cUw/hkTYX+6xMUHFblYwgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052619;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ClxqJQiaCwyYiHQvsftiekF2yl9nN+pmfaDQJ742tlU=;
	b=vPVWSA+m78SXnunQ3A5ihtx2R4C0vH854shqPWf0uxroaGIr5C6gye2C6+bhFwjqWgNB
	 ugUrmJkpBekBJc6eQkNJrC26Lus1ET34wLzREppaIQeKit7vl4OK7oHAop0pegEL6RoQB
	 dBIwsQUH5DCzLjVOPVBGsYPwIj5gxAou8QMCfLwyh9DDwobdZoiRVQO+SduwsFikL02FC
	 e2Gd1gvxg7u/KKi3IBy4RfVCM/HJk4HB+cCwmz/WZLEzHmn6EndqYfPcmMJy7inKsbKpY
	 gX4pJcjPrBOImPAWABWg4/BbNJjUnVoZk5DmulkahKmC9QsbaXEfBsYE4XCz3bzsSQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W3nEtByw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E8F606A31C;
	Thu, 19 Nov 2026 01:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W3nEtByw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420E71F000C4;
	Thu, 19 Nov 2026 01:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052618;
	bh=ClxqJQiaCwyYiHQvsftiekF2yl9nN+pmfaDQJ742tlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W3nEtBywAgZyvBfB+F2/xTAp01xFgbLqXBp+RrNx5bdkBOTJeWcBlMGsqprwUDU7+
	 pFnNRlNiW/wWbfQ6AhqBg2XrGnJ5521odbHYtshSwrKHNqCC6iRUTZ3oxlYKog45l7
	 L0ePsY7ls6hqR9zX/xhTGnfBAFHXTMarFlNmHuFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0625/2214] fbdev: smscufx: check for fb_deferred_io_init() error
Date: Wed, 18 Nov 2026 15:38:21 +0100
Message-ID: <20261118150036.374967774@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 071448eba2465..5f12862c45fae 100644
--- a/drivers/video/fbdev/smscufx.c
+++ b/drivers/video/fbdev/smscufx.c
@@ -1095,10 +1095,13 @@ static int ufx_ops_open(struct fb_info *info, int user)
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



