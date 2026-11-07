Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064694;
	b=DHWvoIrFWHYVXsAH8CtxnG/uyXHKex2hk3wwJfSRO08gHnuPhGEjk4gHrBHl0BN29ijm
	 SLrdBvWF6A4kqiOHNlm1r/ROabe+2XqU+RiJhw0wlJJVtnYALz0QpKQINJ7y/q0mvgW1N
	 IwT5nFHJzDF2WjZE2dtBh5UfnphbEfq/M4YHlHOkElRZb1LZy7+kIfxVk+5S+q9m7AcE3
	 VC1LZO8BxWya/c2Sf0ZrqfYYfViDg8ksf/EVpcO92znBaDePKuZ1gTVuNHSsdtqaanQqS
	 Wa7ScIh9ZI4tsIiMi4cvGRzxZhGXw07aqdTGWsxdMyebNtvpvLduuNkVS0mFhHPjxHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064694;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=STxoKsjZXlHbwm2geVMbsP5hp4J2ABGib/ZaLv72eeY=;
	b=M1XTzs+RSKj8FMXITV/6GVySbjiPC4Pqi5PSlVTQwPAH1C0wm38/dpIhhe4zNmxGiR3/
	 1YpJUrAZp4QtpzhFqgQkfJYQ1IXv1orjhrXpFM1r8EQeAXhcwFs3HLgQMyYcF6oAyapSx
	 xmmG/o/FMxYawkYJBIAdIp2SwmMuA2Yi9q756I5gbwZvny4fFeBrh9HyW0jB7uiJiagYH
	 5zF67CCcl8yoRieBWoqmTtgDs3uAyUhbL7qTMSV9iOcWI+u0zIL47O5eR75/jwnZCHVph
	 VK1Ui1nNStY1Qq8jLhs525g2H0l7FZP6wrZCRyLWsTvdGzfViZfbt1NylYgifON8jiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZkiPNRP2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4067B606B8B9;
	Sat,  7 Nov 2026 15:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZkiPNRP2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB431F0089F;
	Sat,  7 Nov 2026 15:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064694;
	bh=STxoKsjZXlHbwm2geVMbsP5hp4J2ABGib/ZaLv72eeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZkiPNRP2F0eiPGvdqhKrY0IrO2GNOxDsA3BbwSSQt1qXRpzetCK6P3WtTs4SGy36l
	 QYOeYEJRvLMsFEXSCgsMeqc2k/GoQ5OUtYvPNX/AvbBfRfz+yELPpzIpRRx8nfmp7L
	 LqNFv8KZjmW+KOj6fa3Ug2++tQ1QifbiioOlzzgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0685/1257] fbdev: udlfb: check for fb_deferred_io_init() error
Date: Sat,  7 Nov 2026 08:49:41 -0500
Message-ID: <20261107134958.188103990@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 92b352bc7e969..8b7b4bdac4fbf 100644
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



