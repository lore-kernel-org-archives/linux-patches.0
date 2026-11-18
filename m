Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036508;
	b=IUplDJhd16fUxCsonNns46rJLmmhb/iSzBY8wfMjbJVSWyh8J9R0VYZ5Bgz8R3tFGa5l
	 fBuleA4dup/QGKTh5lnO9TIt56SmMf2c9QBC6M3vcaZuRd/e6SVWHGB6dWJZyE+WYlujD
	 QFjJ5WVxmJiaoW/alxOVc5I2ggwIChc/l4ovN5wGXkXLGytGvBsEUJ9spYz2DxUV+zmkD
	 kgU0plspOCO7A7II/ihsxp+wBWIiQ/15rNzN6LvEg8kbzFti/DJTe2tne8BAcY+0bBd6+
	 OvFwn2PS80o6BYKjVBASaq34isM8pviXm2xgPAfoZvKftGc9ENnTTGc7CoCXLKV7iwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036508;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HVDveiGHsFOVjfScjgFJTkKeRtymhUgMTQLcCwdgrlw=;
	b=y1+TR051X1NMVfKU7fb2S6iEnlJjRgq23Dk91nbhLL5KSTqeL2KKDR7XvL4V3vYOCMhR
	 wieajfRV5Z3C2AMUXW/8nKqpaVIrUk8RI7X5Ocpx0upmrGpEcv+4hKF2CPp6O83gPepWt
	 sBueECVEHcgiaFDPF4CdxY1zxquMT6d5x7hnoX28bpn/ES+/6WDFPIPDqogm2mWI0WtcK
	 AoHIPTDs/Fk7e51yiHQK7dLaxFq3E+B8vKarm4kfb9wPyqSz1PQXt4mRygyZogqaZS8vq
	 LMwr7ar1RlNl3E2g3gTtiexiE4kduNj3mgoXSTrXyljTd4sv1ujvyekvRGjY1MqG9AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NeG7D8WW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31F3606A330;
	Wed, 18 Nov 2026 21:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NeG7D8WW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080121F000C4;
	Wed, 18 Nov 2026 21:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036508;
	bh=HVDveiGHsFOVjfScjgFJTkKeRtymhUgMTQLcCwdgrlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NeG7D8WWkhPSRLY1RwKju6uihtlQTzd+tWbcyWcMoXY8ZBLCIhg30BWwogO/xPZ2s
	 FXi48meBtlJ2WIV3FmiTQGARdVF3gk3IgdSxxkXdNg0sV8mXRpZGZrdIBbY6+L8Fn2
	 ETLuteU4Gj/qY9lflGg2GJBIeadacNrSK7PXPUnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1085/3318] fbdev: smscufx: check for fb_deferred_io_init() error
Date: Wed, 18 Nov 2026 15:28:27 +0100
Message-ID: <20261118150352.524529728@linuxfoundation.org>
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
index b590763b01089..064d95013700b 100644
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



