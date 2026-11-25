Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624698;
	b=RmqCSwJekdPkXEN93jH6Ojs6v/T/C8Tk40DWlRU6uvqxG70xN7cKUfNy7i18y850uXw0
	 bldjEdRc59iUtItgW4pKNDAl6hpNJSsM+I4IAtOL8QX0+Aou+QwORQrtu1dh3PM1aOeWC
	 hP2qx4PbTfGWuuTh9ihMbeCnrSdANkch8b7C3BncSCOOEj/TqpPGquoE/PTg9akHzIpvx
	 jOYIzGSRlWovaJx5uyqDoYdkfGoOvBB9JYrNAp9cyW82S/YOXrbAK64QxbIeoRt8/qnXU
	 HRINsq/2eYQ0m6zdDUSNPZgTMkXp8FFxxJLf08sBAMecQBXLRO1ZTrxSZDDLoX5/XVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624698;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=tEJBTCQ40nMNJO9mBzuipf/4krpMjMy5u5pQEIjuwqM=;
	b=jZFs/whXx52/AOjaP1d/xHX+vZuMxLoDMNvK368xHFdKtMkatA41ziOCUOXL/rnV8hFT
	 sm2aS97etq4mstdzJR1/NeGRjaE+1O/E/MWDofea3wiTu7eUovSzRPFwrP3gw5RhEGry9
	 dS1k1zWbOh23YYDb+FXyStRH4YDgDSmadHALYADaPl6qVFpWIcUXkvN9Bnlyw4tMffybg
	 eyZHqNpuqufnWHDK4LesdbT3q7PF5lVUDM+tBPV/G5pwIJFBvCbAaZAzwFZDD0I/+s57F
	 T7zYm63Fdu5Kf28Kd93cMzafoXl8+fPhEKQFlwjO9/PplxvRmVEp0kh7uNvlSwDC5tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ExPhJlwo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAA7606A321;
	Wed, 25 Nov 2026 16:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ExPhJlwo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7BE71F000C4;
	Wed, 25 Nov 2026 16:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624698;
	bh=tEJBTCQ40nMNJO9mBzuipf/4krpMjMy5u5pQEIjuwqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ExPhJlwozE9s+hjL7ZIGpFSJOhqo6zBTl85ur0D98SDqDzSeyLDxJ7VqM30NmKmsd
	 tNoJD2Lq+rSubss6GZiLngIGBw4czFppHSg68ZSbnRGvoivlc9Fk3+2wBjtukUSEMO
	 iG4MqCzU21DYDRnFSoj1p5PLSds9S3vUoANFzotM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Micha=C5=82=20Kope=C4=87?= <michal.kopec@3mdeb.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 223/816] ALSA: hda/core: Stop capability walk on empty capability header
Date: Wed, 25 Nov 2026 15:29:31 +0100
Message-ID: <20261125143854.367713985@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michał Kopeć <michal.kopec@3mdeb.com>

[ Upstream commit f65c917397c77daeb7e6d0893ebe89107ddd5692 ]

snd_hdac_bus_parse_capabilities() walks the controller's linked
capability list starting at LLCH. On some platforms one of the entries
reads back as all zeros. Such a header does not describe a capability,
but the walk still treats it as one: it falls into the default case and
reports an error, printing the raw register value instead of the
capability ID:

  snd_hda_intel 0000:00:1f.3: Unknown capability 0

The walk then stops anyway, because the next pointer of a zero header
is 0, so the message is only noise.

Treat an all-zero header as the end of the list, the same way a failed
read (-1) is already handled, and log it at debug level only. Also
print the capability ID in hex for a genuinely unknown capability,
instead of the full header value.

Fixes: 0b00a5615dc4 ("ALSA: hdac_ext: add hdac extended controller")
Signed-off-by: Michał Kopeć <michal.kopec@3mdeb.com>
Link: https://patch.msgid.link/20261102114939.2182131-1-michal.kopec@3mdeb.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/hdac_controller.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/sound/hda/hdac_controller.c b/sound/hda/hdac_controller.c
index b5c833b9f8b9c..5ec0cc3c93abb 100644
--- a/sound/hda/hdac_controller.c
+++ b/sound/hda/hdac_controller.c
@@ -438,6 +438,13 @@ int snd_hdac_bus_parse_capabilities(struct hdac_bus *bus)
 			break;
 		}
 
+		/* An all-zero header means no capability is present here */
+		if (!cur_cap) {
+			dev_dbg(bus->dev, "Empty capability header at offset 0x%x\n",
+				offset);
+			break;
+		}
+
 		switch ((cur_cap & AZX_CAP_HDR_ID_MASK) >> AZX_CAP_HDR_ID_OFF) {
 		case AZX_ML_CAP_ID:
 			dev_dbg(bus->dev, "Found ML capability\n");
@@ -468,7 +475,8 @@ int snd_hdac_bus_parse_capabilities(struct hdac_bus *bus)
 			break;
 
 		default:
-			dev_err(bus->dev, "Unknown capability %d\n", cur_cap);
+			dev_err(bus->dev, "Unknown capability ID 0x%x\n",
+				(cur_cap & AZX_CAP_HDR_ID_MASK) >> AZX_CAP_HDR_ID_OFF);
 			cur_cap = 0;
 			break;
 		}
-- 
2.53.0



