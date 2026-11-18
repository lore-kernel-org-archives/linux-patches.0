Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047298;
	b=jlYZxr1kfDXVl4xTqyqOZpz24Zyw6t2tBGJcT47d7PxPs7MpvHU5nldxbPelbht8JVAq
	 EHStdx3dDP8g8Xx4uLdT1WZPJymqevzSF/19ZCGcxPnG9ogBnzqkZNIaRubYMIQGKL5lw
	 b4lwr0eIJKKwk7tN/mG/WoBTu6NR4EChAdMC+EMvkUXC0cHCW0Dj5k0Mp+twfioy4hnAL
	 7cm40RpKcdLvH+YPT4vOAVPRU919Pv/G/uGWxLl7dPfRPaujRtFc91szBmVdw3xFUwPTF
	 gdHVVfWdtqPlEBvttoFKo5+Xcrbz168c/jNNNH5bAugD0vcJgbpEV8FboQQwxlFWlWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047298;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J4xznDTjvY7G/XdkpYzZuMPo9Oe/35TIhF2qX7DvXpw=;
	b=ZFMMQTlq/eYxUgsFh5GT0godgfIWXDbv5B62B2Q791qIF+Slkwu5SJHsU+aQKKr+5GKa
	 RBQRHU4JAJKQfEQuru5oj0z7i+KTPEP+k0SDLrJXiWMoJhBZIkjRpn9V5tBc+OpIMWFiU
	 DJnSXfFwN17Wfl/00KctBxxJ4p5rEluHuNdCf7qYlXKYGk7RJe77STRS7RtNLIgOuqBGk
	 VO9N2X+QkCi+Uo90lxgVWSwqZPJDFGlix1Q17YVY4ZMSoEl3h2K0q+l8TiD/CoHAgHI9N
	 MFL3J6DaKRcZZGFdSaVJ3e2KAAruCuogXw2OCLtYGBMnZzrTKKVapvc4ORj9ED3kMAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oZCnmMBz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032F4606A31C;
	Thu, 19 Nov 2026 00:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oZCnmMBz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584831F000C4;
	Thu, 19 Nov 2026 00:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047297;
	bh=J4xznDTjvY7G/XdkpYzZuMPo9Oe/35TIhF2qX7DvXpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oZCnmMBz+0yhlVtKzJ5/UHGxrDzTWGxR2mDHroT0YTY2z+8MDMkB1YzZ7ofXmTkKL
	 SoKvwdsO8/8pdHPLriRga97YhtVdYP/iiC5Q83kOs69dafv987OeY6mG0bpt6nWPwC
	 nKTfjhtGxch37dblaA6XbUUQIUfl3Mnf9HISTofg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1588/2857] fbdev: nvidia: Release write-combining handle on probe failure
Date: Wed, 18 Nov 2026 15:43:42 +0100
Message-ID: <20261118150258.550768142@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 8710af6a35201a6d01b5af8f7e4bad29cc40467f ]

Failures in nvidia_set_fbinfo() or register_framebuffer() leave the handle
from arch_phys_wc_add() allocated. Release it in the shared error path,
as nvidiafb_remove() already does on normal removal.

The missing cleanup was already present in the initial Git import,
when the driver used mtrr_add() directly.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
[ sashal: adjusted error-path context to place arch_phys_wc_del() before the existing iounmap() call ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/nvidia/nvidia.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/nvidia/nvidia.c b/drivers/video/fbdev/nvidia/nvidia.c
index 5fa6a43b58dc6..2df25bf2f2601 100644
--- a/drivers/video/fbdev/nvidia/nvidia.c
+++ b/drivers/video/fbdev/nvidia/nvidia.c
@@ -1417,6 +1417,7 @@ static int nvidiafb_probe(struct pci_dev *pd, const struct pci_device_id *ent)
 	return 0;
 
 err_out_iounmap_fb:
+	arch_phys_wc_del(par->wc_cookie);
 	iounmap(info->screen_base);
 	fb_destroy_modelist(&info->modelist);
 err_out_free_base1:
-- 
2.53.0



