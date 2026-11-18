Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028440;
	b=VHfbkuZn66zzMFhWHiJEyD3TXHEi5yAVlLUSBpVKuUQWJM6XxD9BW7T2I9N/fFT1DYFc
	 pnWZjyx6Ic/QlZuWJXz+G8F4MUqr9Bd41m/NPX+YLmi114HFF8fMEKRPz0ktqNUlVv1j0
	 GsykDQCEv38wi8hn28SEfsv+K9cWFt6Vf+0jHX06LsoTtJXUDUaH/ekKW5Iqnn67FL1rV
	 zm5YrpRZS+7rLZg/wE9l5L+mAZiZOAFeRJaa/vxYkyGzMX6Cz7CDVtfXmrcShMrIeZ4pj
	 z9QZCi4hQAsc6pI6RZgBXJShQ2pajWG+Y1rgUyRVE8CivfSaq2k2uFQE+2rm5LV+UOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028440;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xTGlBcL4SnbpX4ViHysTWg01xVtacvJ9eqTeRbg3Vqg=;
	b=wrblwobV1iQrY7Guh5Av9MKdIAU1pK2CLXOyuWdcEs4qCHop5N7T6hQ79TxxCdKWwMd9
	 q7D2SxUmHVvPreDEPa/jOQEcIGZNUIpC9IhPPu338kUFJCqRSpZSWPQvoD77z8ZGLD5dS
	 N2RUVC1qeBh4frF0TXW9/gIloCHu8ta8hoQgrkczAIG18K1J5iBZDX3TdZLTfQNjIbtbB
	 uRQKIYo8NDuK4YfMoUYEswfB6CCk/oKMsZaAx3Yt+s1/c/6OowQ2HwVrNkPIJVn1l79mf
	 FWb6PlnUYMfuZMvP6VEbMv2Qvv5yE7m9txdYrYHpkIKH5HpHWBiCcSS8TSzgPr9quWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UPn1TNzM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9FE606A325;
	Wed, 18 Nov 2026 19:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UPn1TNzM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A99C1F000C4;
	Wed, 18 Nov 2026 19:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028439;
	bh=xTGlBcL4SnbpX4ViHysTWg01xVtacvJ9eqTeRbg3Vqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UPn1TNzMo/TddPEOUIYIeGRei48hHYwjGd1/M2axhs0u4Vtx+e6wCQfHf5TEbEvqX
	 jzHVNWubO9gOE51uJSEYMAylOPSAhkiFPHglBYnuQLFRnUl7zZ3GmJkLQu9mcT5yjP
	 duLpV9vA8GN+WQ9CLprw5pdCtpsg7KcCxJXSPOcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 6.18 2146/2151] serial: 8250_hub6: add missing include for hub6_match_port()
Date: Wed, 18 Nov 2026 16:04:41 +0100
Message-ID: <20261118150239.844959605@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit da7b5fd4e17f8e44c5590f2d603c01d499f056e6 upstream.

Add missing include to fix compile warning:

  drivers/tty/serial/8250/8250_hub6.c:44:6: warning: no previous prototype for
  'hub6_match_port' [-Wmissing-prototypes]

Fixes: 3d406299d882 ("serial: 8250_hub6: add hub6_match_port()")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202607110715.VGT2dVVz-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202607111219.QG9uOW8H-lkp@intel.com/
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://patch.msgid.link/20260714012610.576746-1-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_hub6.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/tty/serial/8250/8250_hub6.c
+++ b/drivers/tty/serial/8250/8250_hub6.c
@@ -7,6 +7,8 @@
 #include <linux/init.h>
 #include <linux/serial_8250.h>
 
+#include "8250.h"
+
 #define HUB6(card, port)						\
 	{								\
 		.iobase		= 0x302,				\


