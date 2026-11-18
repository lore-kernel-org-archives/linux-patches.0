Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052616;
	b=FgaJiwjKW2ZWLqlUk3yVUiQ13BrrXoyUCzL5muFMrzrqtjrpYVMz7Yx7k2A+u++hCvA/
	 IIx4F7b7VSsfcVyfFI222NUsocQQv3v2UwalZpn0OUw7/cVhlZ9tSFnXJI/PVwWdyZXgg
	 ACze6tudRzWsI0zVDrfag4U7qT8EgJjruvhNg2UE2FGrdfx8xpp9x79tARGRu4KmYSkkS
	 el3ygV6H5/CInMpysBnsHWGWmZFZ7h+AR4IzsHzscs8rmaHgXnKip3ELJ3f5u0YI5U6bm
	 zYGi1Y9npkJg+gBVtBAZA28okAIrSI3LlWHpX2Z74V8uqHVrT9VBPw8PwMaBp7Vm6pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052616;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DnFHMZFFFA0VqbcNb658BoyrXC1En9h8rn7WY+SmxU0=;
	b=y/EnqAkvCUt+0ievWOR6SnLmM7bjHh1lhDFHRUaisFUFfQWKGQZ8f8ooHg1y2BHzm6lL
	 x5zW77EBWQ6MiisAHybBoUnnYWivinch9L9x0wLaMP2IRDkPpXQEPyrzXJur9JxucT99M
	 NFhODIKB7sU2IpVDKRxFs3F+jFoHzuqbsra5QFIfl3Vp/dzx5Hrr6p82kiwzMQGl2fbfs
	 GsH87hd16tBrPLGQRZvdsWwG3pGC/40WorcJgNCCrC/mzrRGZzWiFzDvrWdBAUWW/yuBg
	 KL7BCO7RF2y5/IZORqMWCTMnfmygdv74jtAqQR0SIH025bQ7gzeujXTiQ/73QpdehyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nLULf2Qz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C5C606A32A;
	Thu, 19 Nov 2026 01:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nLULf2Qz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6E31F000C4;
	Thu, 19 Nov 2026 01:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052616;
	bh=DnFHMZFFFA0VqbcNb658BoyrXC1En9h8rn7WY+SmxU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nLULf2Qzw16TUE6Oma2ZCGOBhT4XNn04JO4og0acVw0yLSIHt+G4TxJb9Ln+bMb/7
	 SiwY83Ovc/4aCpK56rkN4P/xaBmezSGvZPeGfW4gPcv8DBg7ydKFWeATYQb6p5Wbv4
	 D0qZvNJ8On5qKL/dWxHyt5g/5Gvsvdx5RBTb+8PI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0624/2214] fbdev: udlfb: check for fb_deferred_io_init() error
Date: Wed, 18 Nov 2026 15:38:20 +0100
Message-ID: <20261118150036.340366310@linuxfoundation.org>
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
index a9b3175016496..fe53b18697ef0 100644
--- a/drivers/video/fbdev/udlfb.c
+++ b/drivers/video/fbdev/udlfb.c
@@ -1006,10 +1006,13 @@ static int dlfb_ops_open(struct fb_info *info, int user)
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



