Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062560;
	b=LM3iiueCrWV7owxLc5Os8/1Nj2EuJkpgdlQyVrD5dXcB4XPN0nVVRNTlEPmvuJ3c8/vz
	 biej+d+IjWZlAEyoDNdCQMgkVGwsOeC7YkGRe8bWf8aIJTjYdctAklmUKNr4NfcqvYTI4
	 +i2nZw91bsZ59ecfnFhOxETQ4hBaQ5FGTQecqzc5qQkIPYpWdItqesgHzbQQN7gWdazIz
	 8poeL5Xx0mnZfUySGOA4cVreGvzBxtXu94LxlfdY6NqoStbQFFdOnsSRlWzhjGvOUZtag
	 ZCem7veRvLF6MhPkcXJ58apBlUpWBikTRIgt+Vjf9jkwjGyEo3rWZpQmGEKnsPNLNvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062560;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5gHr/VMr5D40rp+7dnt4QqbC8x0qsA184t7mWU/nU+g=;
	b=X59cG7jt+q6v/1zKlmEDJH9wfBqveXHEw9UmFtQePv2SxdJ9Xp5DZ9VkdVifSBgash9r
	 vqxJlm7QONEv/n4CeyKOgMeeoO3QgRDSufKuc1LJIx0/74W6Q1bAw8Y66UE4gNKbxxQEr
	 3WABRXaqs42hu8nOZmLNRVDBB3ZzZtolbkRKckybmUxsBXGGRti//PeHYwpxR7RyK/5Cp
	 pnbkFi8hjb5Sa5SD0n5G7NKRUEx+CzZonDxVARpXYerNQ9ptEMC4I9AEppp70HoZcW70u
	 wt8Y7rzhr/yHl2zOGOT7dc/GZ3oMF3bDYifE8IvjgLiu0/9Ed7Y5nduJMD3NFuD+O5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ab6BkF7u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20380606A642;
	Sat,  7 Nov 2026 14:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ab6BkF7u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4541F008AB;
	Sat,  7 Nov 2026 14:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062560;
	bh=5gHr/VMr5D40rp+7dnt4QqbC8x0qsA184t7mWU/nU+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ab6BkF7uqLtrX+8ODn5itFyV9vb6meRYmuTQ1odCnPQRbVs4sJx4j99AWx/bj2f0M
	 fFdyQK3lTUDs4UC+WVEK/4btBA5Ftkp+rin3onUvFEp9TeeInyz+Bc+FT68r7ykuy0
	 liTluantZXZ/4AQMF35aksR+KFgW7hY0GDxfKlVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrik Enquist <henrik.enquist@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1406/1536] ALSA: aloop: Update the PCM Slave controls for a matching playback
Date: Sat,  7 Nov 2026 08:57:02 -0500
Message-ID: <20261107135037.315502139@linuxfoundation.org>
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

From: Henrik Enquist <henrik.enquist@gmail.com>

[ Upstream commit c3bde2beacbcb40790f0e3c3f909f9e16bbced9c ]

The "PCM Slave" format, rate, channels and access controls report the
parameters of the playback side of a cable. loopback_check_format()
updates them when a playback starts, but returns early when a capture
is open and its parameters match. The controls then keep the module
defaults, or the parameters of an earlier stream.

A playback that joins an open capture with the same parameters is the
normal case without notify, where it is constrained to the capture's
parameters, and also with notify whenever the player happens to use
them. An application that reads the controls to find the playback's
parameters, for example to reopen the capture side at the right rate
after a restart, then gets the wrong values.

Only skip the capture stop when the parameters match, and update the
controls in every case. A value event is still sent only for a control
whose value changes.

Reproducer:
  arecord -D hw:Loopback,1,0 -r 44100 -f S16_LE -c 2 /dev/null &
  aplay -D hw:Loopback,0,0 -t raw -r 44100 -f S16_LE -c 2 /dev/zero &
  amixer -c Loopback cget "iface=PCM,name='PCM Slave Rate',device=1"
Before: the control reports 48000, the module default.
After: it reports 44100.

Fixes: 597603d615d2 ("ALSA: introduce the snd-aloop module for the PCM loopback")
Cc: stable@vger.kernel.org
Signed-off-by: Henrik Enquist <henrik.enquist@gmail.com>
Link: https://patch.msgid.link/20261021-aloop-slave-controls-v1-1-62297727177f@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/aloop.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/sound/drivers/aloop.c b/sound/drivers/aloop.c
index bb75051be5ee1..50b8e7b3d8179 100644
--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -364,11 +364,14 @@ static int loopback_check_format(struct loopback_cable *cable, int stream)
 			runtime->channels != cruntime->channels ||
 			is_access_interleaved(runtime->access) !=
 			is_access_interleaved(cruntime->access);
-			if (!check)
-				return 0;
-			if (stream == SNDRV_PCM_STREAM_CAPTURE)
+			/*
+			 * Matching params also go on to the update below, so that
+			 * the setup controls follow a playback that joins an open
+			 * capture.
+			 */
+			if (check && stream == SNDRV_PCM_STREAM_CAPTURE)
 				return -EIO;
-			else if (cruntime->state == SNDRV_PCM_STATE_RUNNING) {
+			else if (check && cruntime->state == SNDRV_PCM_STATE_RUNNING) {
 				/* close must not free the peer runtime below */
 				atomic_inc(&cable->stop_count);
 				stop_capture = true;
-- 
2.53.0



