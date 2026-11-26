Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704330;
	b=qqMamj538TPID/G7yIruSq3OdFDMrV8FGqrvYWZE5Dez7zzbMzqpUJEqTR6Ov91MTCUD
	 AXK9bDOox5pRLkBYv5K9jsm0SVUmHa8w7XysKgwWB/5vOGauAbuEGIXejsC/VQr+Hhu0X
	 ds9VbZVMgwcIg9X4IRprKeCpTQhwRsh+1ohHWcGoJJo23yfO1vUMstUxs9bkroqy8den4
	 Njta9LrTvVxxDc5235p2w7bcolXtBDCOFPywXefLow5p1n7X8VLhyvheagYaj9U4qfeyh
	 zph3NQLofSYsS/v6JmJMBVaF9GlJS2F53bc63XAa/4bAMfKZ0r/NlgWSbmFnqrvj9yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704330;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=7ZJJDeOGF8BJtaGdngzeWWAUdPuQm8FMeNEiSPdgro0=;
	b=lraJMGdvFzKLis4leCvcIHUk2Gvk0FWkyp4ji2lHXpK5vmhyrii4SJIpBuo5hVN9kz/j
	 YFAWefi6y63AD2eJGmQwXSKTkBeKIVGKL2ByR80eF5g04uYcywaSJrGq9AnnN068+oL7y
	 I5h+45pGErKLXIkRpfrfRB/aSlnka634dRH8fvbawvMH50UpfBdsuK2o4TFqMDL2pfiad
	 cGLQhySqgNJFVwWMokijlOZzgjuQGzc4wdTEHxQFrDFSoXwtFh8ujXbYzcLAz+mWxZQrU
	 Z06gui0nABi+VJ8eBY+Sljz/xhSDrB5JPh/Ll848KVxBw3s9smRZ5cf9heK+uTtWyuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xEERE6eP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CDE606A31C;
	Thu, 26 Nov 2026 14:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xEERE6eP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB891F000C6;
	Thu, 26 Nov 2026 14:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704329;
	bh=7ZJJDeOGF8BJtaGdngzeWWAUdPuQm8FMeNEiSPdgro0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xEERE6ePmmbkrayA2diAgyT1P3eH85rueuBjRhuFggN+gcZ6xzpCCZ54M9+Ss08WU
	 tLbTF4qio9PaYe7l+PnKAZcrWxJFHtiWtpWvMX6Ej8L9hhAh8Vpv38OuA7N5PVUx/r
	 1rDxNcgk6+F6Oi+QtIiCpSiPlUw74XH/c6fg7ntw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Micha=C5=82=20Kope=C4=87?= <michal.kopec@3mdeb.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 084/265] ALSA: hda/core: Stop capability walk on empty capability header
Date: Thu, 26 Nov 2026 15:36:54 +0100
Message-ID: <20261126143610.899149400@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 522d1897659cb..d1d2dd7e77ff4 100644
--- a/sound/hda/hdac_controller.c
+++ b/sound/hda/hdac_controller.c
@@ -322,6 +322,13 @@ int snd_hdac_bus_parse_capabilities(struct hdac_bus *bus)
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
@@ -352,7 +359,8 @@ int snd_hdac_bus_parse_capabilities(struct hdac_bus *bus)
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



