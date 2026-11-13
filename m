Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591234;
	b=etP24lJjNhdK5B/3yX/AHCMyiQLZ61girO02lK3t0GiXlzqbJo9047WaqLcssVMXoedR
	 bPhcKhgk3eD8bcpbduCjgs/v0AOcXDv437+KdGR7MRz4JOh/PsPGmEMPlO6kSJDWhZamL
	 1IsxT5YZkdzEKI6rRxgI6Rn8RehkbQmzc24IBys3wkuccDKU3DaQqpxuvI+fCEqznJAXo
	 crAPqK5aPlLnTXam7sPyPzXo5Qk/Iysj0+sph1iCdnky0AHzIZqnooC2Oe515DkB4YVei
	 iUJAA3+fKlxqvuL/3VAe9bk7UBxTyhP0n4wbmZ80GRxD8+TZnCjmaJBxF0LIEp6jwfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591234;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5ZdjWwGWmjcqQq0U3AB5qpCumc+VQR7m+ekbmK7+Dkw=;
	b=kKWE+lYjx+Q0Tp3l68mB65B173fJBqGL2nOwD13gPfYV6r7voQOSLNfwQwVAuoTqAJ0n
	 Si4cowUfJpIhMNVCcg2lvVcK9vH6rYXBDw3rTu/lcBx8vcGTXdnx7+fgqzDeSD4e1tF6i
	 BAmWRUpQFh7/glYSNs6lp1yWJfmU8e1XHPEuT4dRO9K3ssQutpictRxUuUJzlZUS1gG1B
	 epW+l4vD7RNyNXnLeFc5MU8tfl2fz815RWgH0Z4/0h3QChxFsdJNgyipI8bCrHUeZHKpf
	 RZ3OZHFplKJElNG+zcirAXUlrEhXCpydejru0ZDMcgtfakrqdsF0KPLIbjkvgcQUVtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xLnBBEZj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A685D60A2603;
	Fri, 13 Nov 2026 17:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xLnBBEZj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 516291F000C5;
	Fri, 13 Nov 2026 17:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591234;
	bh=5ZdjWwGWmjcqQq0U3AB5qpCumc+VQR7m+ekbmK7+Dkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xLnBBEZjboQGcy1e9vAon1nHEB/KwlhVC3y4GDWq7dElM5kYf+pNevQ0GOG7TeI+S
	 C1WJmbOHw4VPQSZ2RQAG688YGWPuYxXmHSq76i0eNx/53EpkgSZKoDX0PMvmJmk0Yh
	 x8SuF2lgHAoZ8fP8OWBFeP+Y4idxH5x7yRfjcBP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 363/670] ALSA: ump: Fix dropped data bytes at UMP System message conversion
Date: Fri, 13 Nov 2026 10:48:47 -0500
Message-ID: <20261113153824.110926902@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit ac1cac4c1f1b143650f7261ae78f64a3e22fa4d6 ]

The cvt_ump_system_to_legacy() function switches on
ump_message_status_code(), which returns only the upper 4 bits of the
status. The case labels are the full 0xf1, 0xf2 and 0xf3 values, so they
never match. MIDI Time Code, Song Position and Song Select are converted
to the status byte alone, and their data bytes are lost.

Switch on the full status byte in buf[0] instead.

Both callers of snd_ump_convert_from_ump() pass the result on as is: the
legacy rawmidi input of a UMP endpoint, and the MIDI 1.0 path of the
f_midi2 USB gadget.

Fixes: 0b5288f5fe63 ("ALSA: ump: Add legacy raw MIDI support")
Cc: stable@vger.kernel.org
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20261029130538.1985867-1-sammiee5311@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/ump_convert.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/ump_convert.c b/sound/core/ump_convert.c
index 0a7972d91ec52..ecbd894f4c83a 100644
--- a/sound/core/ump_convert.c
+++ b/sound/core/ump_convert.c
@@ -69,7 +69,7 @@ static u32 upscale_14_to_32bit(u16 src)
 static int cvt_ump_system_to_legacy(u32 data, unsigned char *buf)
 {
 	buf[0] = ump_message_status_channel(data);
-	switch (ump_message_status_code(data)) {
+	switch (buf[0]) {
 	case UMP_SYSTEM_STATUS_MIDI_TIME_CODE:
 	case UMP_SYSTEM_STATUS_SONG_SELECT:
 		buf[1] = (data >> 8) & 0x7f;
-- 
2.53.0



