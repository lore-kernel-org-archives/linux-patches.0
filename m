Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212484;
	b=opkyqHXgMDIIUPThNjN3BLinMdAngd0cbWbqjNTK6Gx0L/cug9WOnxGqNnZ0Nhwj8WAs
	 VJbLgCsGQ24cbwAixpLBffq4JmjCO8th8lGeP5wOhEiQoCWtj6FKoFFXUhQXB5H5k0cuX
	 bmo2T8ND7SsF5IFF1jK6Ztqf4XJ+JgqT8+6vsCLX5+X/qb+j2Q+VPWc8Om6BZ6PFHU5rL
	 jbNlUIpIzEQxURsAG0lM8Jk1vSM8/d/Fuzj6+SRl6XS3jKXvdTe9hw9Z6uM+AL2R1GSE0
	 qqqNS+i2vt/pQYizbsBJwcAv6mFj61t7JGtQ3qr9xlRLI0jKjRZzFI+rP2byr1+Trag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212484;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gSuWkxpqZ386BZdJqqT1xy+e+YGtxcMvPzL0M26UbiI=;
	b=EHl/7QDQItqTbIufm+Emr9EBnhAzt0O77hMO7zZQ9I3oQAfJdmZhwGOKBar1RYIZ4xLn
	 DGQJcCuMpUHd5GVdYADALxLI5HvQfYNAh7ZMh5L222zqwd5aiN9y0gEN5hnP86el/6E4y
	 YBWZFPFo+lk8xOiYTknrWH4nxlXOBttom95NFsbCrzs+Ktxmk9VoAh0Kjx2ujSwLC+zVi
	 xqgWf9h1JU7hiTm+UF42F78BJGQdjgElrz3OLyurde2oUWChU5Llf3RqNLLS5m46qThcR
	 ikpwCD3Y8ceI2DPdy8+x91+GiiG3eB0HStT7E5J8jqLiA9B2qe1HwomvKdtC6NEB6Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OUACvoCb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF70606A31A;
	Wed, 28 Oct 2026 18:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OUACvoCb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC49F1F01825;
	Wed, 28 Oct 2026 18:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212484;
	bh=gSuWkxpqZ386BZdJqqT1xy+e+YGtxcMvPzL0M26UbiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OUACvoCbTQdh/rIJvpWlZPdo7bzYiccCLGCufUUHEZIoi18PqC0EQE8RpcD8dY2Qg
	 Wt8tBaLx/wcMlexcVJJ29wKQVGuzJYzZaqrXfQp9TIIhBJI0TPdckj8shzrpMAMakG
	 IJ9U8lmD4eic5hnt2LJ1qkEj7NvMySJJUnbEW74g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	Faaris Ansari <faarisansari@googlemail.com>
Subject: [PATCH 6.1 0171/1887] ALSA: usb-audio: Apply IGNORE_CTL_ERROR quirk to all Audient devices
Date: Wed, 28 Oct 2026 17:37:47 +0100
Message-ID: <20261028170503.129929197@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit a154f7b9f197b3d5e41fa3ad62083f5aa93b1fe8 ]

Faaris reported a problem with Audient EVO4 device and it turned out
to be a regression by the recent fix commit 87a6f2fa6e6c ("ALSA:
usb-audio: Propagate write errors in generic mixer put callbacks").
It exhibited that the hardware gives errors at accessing the mixer
unit 10 on certain channels, and the change above made it a fatal
error.

We had already a quirk for Audient iD14 to work around such errors
from the mixer controls, and we can simply apply the same for EVO4.
OTOH, it's highly possible that other Audient devices suffer from the
same issue; they must be using similar firmware, after all.

So, in this patch, we apply the quirk generically to all devices with
the vendor ID Audient (2708), instead.  Ignoring the control error
isn't usually less critical than overreaction to the firmware
misbehavior.

Fixes: 87a6f2fa6e6c ("ALSA: usb-audio: Propagate write errors in generic mixer put callbacks")
Reported-and-tested-by: Faaris Ansari <faarisansari@googlemail.com>
Closes: https://lore.kernel.org/CANBVYRCL=8QdLxGg4S6qrahrFtwJxhv-aSGpW7-1S=+iOe4ZGA@mail.gmail.com
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260929144132.1521617-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 22e69a6528dff..e2f37a09a8a80 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2263,8 +2263,6 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_SET_IFACE_FIRST),
 	DEVICE_FLG(0x262a, 0x9302, /* ddHiFi TC44C */
 		   QUIRK_FLAG_DSD_RAW),
-	DEVICE_FLG(0x2708, 0x0002, /* Audient iD14 */
-		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x2772, 0x0502, /* Musical Fidelity M6s DAC */
 		   0), /* for avoiding QUIRK_FLAG_DSD_RAW with vendor match */
 	DEVICE_FLG(0x2912, 0x30c8, /* Audioengine D1 */
@@ -2330,6 +2328,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x2622, /* IAG Limited devices */
 		   QUIRK_FLAG_DSD_RAW),
+	VENDOR_FLG(0x2708, /* Audient devices */
+		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	VENDOR_FLG(0x278b, /* Rotel? */
 		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x292b, /* Gustard/Ess based devices */
-- 
2.53.0



