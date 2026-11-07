Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060839;
	b=umBTHP/qYfQfdfGGQoxJgH9fNI/yZk3iY3An70G4pQ7WxwVZkvDme+c9Aye6oNoosy/u
	 Yj/c8fnAL/hFptmwHKpc2RezNyQbYo3Vg+ek29AZ2dQDvvlKuoNVthaVpM9UIfFj2pzI3
	 YIHJxGBJbS2A6QpzGwV45Wz+lHAHW65Tn5QAW+uP7YNd7sgeMX9AXRI3/CzwBOkaSb9AX
	 yN2pTmRn7rx68yb9j8BidPJms5DrvOHlV69M6V7mWhNKxE1yd4dic+osj1cu2mKHB4b3/
	 ZZeKGeZHWanDasQvjx0VJFhvlVIuhWQM6M/32D2/xi1NquxFvcI3dXh568iToPWcNeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060839;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MjnzwKivf6ilasJnRHFONTS5Vtz0NiOeKAdaNvizpcE=;
	b=ZpyaZR1btwR7E74zM7+RnjXYR1cMzXjqRgXifswr+IGzYDvwS2wDxoYrMBgfzSP1hj0o
	 YNGlzviOlwqTjvlGXzbAVBu1TKXOL0f2SL66m81V9McOGwD/Ibv68QdC3BISSrK2YKtUJ
	 thJIM+YbWEHeuZKb9PNHqzE/ttFt4qH7rP5TavKzzlfiC90l/Q8cNBu4wiyZ8cozsKWPe
	 eqwJK8zIwklsPtKgoCc2QnhDVQl1D9po2owilpLhuh00uJkTka2E+Wj0iHoAf6iOlt4ya
	 MTTGx2EuJwtwwXIDBtJPnC6Rj/FIM7UwYLVVusEIBn1GlfK+t67wHazlL1lEInSEwFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2wRFWRjt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA3E606A336;
	Sat,  7 Nov 2026 14:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2wRFWRjt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC131F008A1;
	Sat,  7 Nov 2026 14:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060839;
	bh=MjnzwKivf6ilasJnRHFONTS5Vtz0NiOeKAdaNvizpcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2wRFWRjtVOr/PqvlnJHK6kaUqUPgKHbvKbhexxLs9KxB7uK+k2oNsFlhYO3zaVtoL
	 hcLwRBmcvrlTGWjZvUPggA2OovSVs0KmW4oGRk8cC1zSL7gp5sV8n1+tvg7qHFiRxP
	 GqPogHN73oUbqx2oQOuW/klBB7t5rDId2oUzhKyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0229/1536] ALSA: hda/conexant: Add NULL check for dc_mode_path
Date: Sat,  7 Nov 2026 08:37:25 -0500
Message-ID: <20261107135004.103368004@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: wangdicheng <wangdicheng@kylinos.cn>

[ Upstream commit 273806f38ce95c95c288a03d3de1e423cd3e5543 ]

snd_hda_add_new_path() returns NULL when no path exists between the
given NIDs, but olpc_xo_update_mic_pins() passes dc_mode_path
straight to snd_hda_activate_path() which dereferences it without
checking. Add the missing NULL guards, same as the local path
variable already has in the same function.

Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>
Link: https://patch.msgid.link/20260729070935.548050-2-wangdich9700@163.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_conexant.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index e521e20402d62..03ac96476c3c2 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -463,7 +463,8 @@ static void olpc_xo_update_mic_pins(struct hda_codec *codec)
 	if (!spec->dc_enable) {
 		/* disable DC bias path and pin for port F */
 		update_mic_pin(codec, 0x1e, 0);
-		snd_hda_activate_path(codec, spec->dc_mode_path, false, false);
+		if (spec->dc_mode_path)
+			snd_hda_activate_path(codec, spec->dc_mode_path, false, false);
 
 		/* update port B (ext mic) and C (int mic) */
 		/* OLPC defers mic widget control until when capture is
@@ -499,7 +500,8 @@ static void olpc_xo_update_mic_pins(struct hda_codec *codec)
 		update_mic_pin(codec, 0x1b, 0);
 		/* enable DC bias path and pin */
 		update_mic_pin(codec, 0x1e, spec->recording ? PIN_IN : 0);
-		snd_hda_activate_path(codec, spec->dc_mode_path, true, false);
+		if (spec->dc_mode_path)
+			snd_hda_activate_path(codec, spec->dc_mode_path, true, false);
 	}
 }
 
-- 
2.53.0



