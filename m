Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045475;
	b=1tcHemu3XK3JnkPzeGcTVGsplV8C9QRaT1ovV1jT3Et2E9EAmjQ91BaANPyuDvZ5W1ys
	 3i0udkTfScIs5uGeQJahwSNGhdG19u91HEJo0u8XX7Cbrl4FtZ5UUySQMqZ6TMiyG5Qgr
	 htiS4D5+4If0BYYe2pJDScntNDf2YaWPrKAb6EtSU8ZMIFWmXC9U4dlxN/XRPpZRswF7E
	 Ur64DMnQEGTeDWMK5w0t6Y0OiqgD0RFloKVUrEJyr44v6T3KjgqxvrOREjKdu57GzpgWT
	 AQHt1mrio3CUMNnIfAgWeqFDtFpKArSCmgzWg+hiAl/4C4HZHjmVDUQq44Ox+V+PR8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045475;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g1Oj/IvY3CqGf8nLB0SioQ8/sh+hedY8c6zmGeQIOqo=;
	b=4v4VX7xlGpSTxHAXwatRiahZn9HeJJLL7fJu8R8l0xVnc09vIuZD890uAGEawHVBgore
	 w2+eM7RG2cZwipyIeTvnoorar3kEstowoZLqSQ0kB3zPO6M93B2J/qq/1UL8Rddlnffen
	 Aa/A4/LihNUr0cRUzVM3En6aesJSOrtPY2kVNLLjilKu9zTfOtR+PcRjq0TbneiGOH9q4
	 NcXCLM04w/24HlwTthYAnaFBiVX67OLM2N/+aJ4iQ1WA0CgVqnBlzP2OcJAKwN7SplAxm
	 cL5seVrsD1/gomMH2OGDndKfhL/KRJMC0A/M8b88+kS3J/H0E/6KMM6hQ/Jp9NOvLKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=te5gnlE7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D345606A325;
	Wed, 18 Nov 2026 23:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=te5gnlE7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82EC11F000C5;
	Wed, 18 Nov 2026 23:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045475;
	bh=g1Oj/IvY3CqGf8nLB0SioQ8/sh+hedY8c6zmGeQIOqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=te5gnlE7oMPnBJsbw3vMI8mLe0NcIH66L15/d5NID/hlD1TOmMJYncOdZG7vO0prv
	 kSvEyynMKtsCJjcEi0bfdIpNtlNLoLbiKVJi+e1WBKoQcaD/T17pQx5MS9e+OClDcq
	 S10dGBAcETJ5WDOM5xhwdeDp8kGxmCWhImIei4zY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0934/2857] fbdev: smscufx: check for fb_deferred_io_init() error
Date: Wed, 18 Nov 2026 15:32:48 +0100
Message-ID: <20261118150235.230699754@linuxfoundation.org>
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
index 1bbffec21b727..3d4f12c0fa146 100644
--- a/drivers/video/fbdev/smscufx.c
+++ b/drivers/video/fbdev/smscufx.c
@@ -1097,10 +1097,13 @@ static int ufx_ops_open(struct fb_info *info, int user)
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



