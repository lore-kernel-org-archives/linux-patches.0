Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705149;
	b=ERLpa1P4dvGM6zXfyWBFxaE2MDEqFiadKld3Vx1F+d3YjU+qhFXXGmbYzq705Wpa4lOj
	 5O8AeOjZyg39ZQAZh5RrLU4ho44DLbgAhQI9Cc2VBQY9YU463s56DW2RN3wLf6iPiGPOw
	 RuLeQ/1EKbzL7R7B9pGADVl0tGeVx8xpgi8Cq1U/aroLR3mO4O0GghFv4sK+BuDuef9+Y
	 punJY3gt/sXwL5o2ciiLGsXFwN8Nc0t820Z01QmgK7nG65iOKM50lBkR3JdcbBO29a7tW
	 vC9880IGgMv2ez0eDG58FA4JENnYUG1KXDYCDOHkERzv+4/ERnbBj022WD6sipFB5Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705149;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=x+PtTmj9SCURidflXSjPu4Sc7R1nFDnNqtqHX/FQkSQ=;
	b=AccO0xtRQauJLyDZCrkyzKAEilSAwCG7e5UAzU++bfYlDZKdAUkbA7DV/B0fs7VP8Gfe
	 ewrcEKP0gzGD/DitTVuxz+guKdU39w6IvUALB/1ATJboeJu0ez//zAc65xI13WeeHOO2X
	 8GIEW9VfdA+gEZtaMLAQazX93Dex/6Gnnd7uXYvrDUnMB8DhNAkFaihsC9KeXH+mmSZd4
	 9D59Vb+WkRTtm0q/PMbsicLtuTT4YNXV+GmnCTvFxxLjLtf9lg2fZXCWKQ0cMCzDgVqco
	 Hz/qV05lGUKHVp9DU/w8Ks7YkY0sR3m4r0KMh7PQn/f6K3dzBJxWVsGhcIRHnUgri7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JNhiRzoZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22CB606A321;
	Thu, 26 Nov 2026 14:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JNhiRzoZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC7D1F000C6;
	Thu, 26 Nov 2026 14:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705149;
	bh=x+PtTmj9SCURidflXSjPu4Sc7R1nFDnNqtqHX/FQkSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JNhiRzoZfxZBHF+G0EbWx0V8AOX1jW1RZhSXm81/iIx4Wct737NIeCn9b7sVibHjW
	 g4gHEBJWlw5oPlRkS5QDdupOaf8HkpsekQlY3mya38YUqR/9JK5KPg6X8jcvc4KpZr
	 alLqAsrYQSjNnmYAnC3KKpTVU4J+E0ew1ayetNxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Micha=C5=82=20Kope=C4=87?= <michal.kopec@3mdeb.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/319] ALSA: hda/core: Stop capability walk on empty capability header
Date: Thu, 26 Nov 2026 15:37:48 +0100
Message-ID: <20261126144009.002104126@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f7bd6e2db085b..d5c58cdb8f499 100644
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



