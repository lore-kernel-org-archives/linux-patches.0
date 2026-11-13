Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591441;
	b=ca12/2uq57bL+AhV74CmhZdKmgK7ydWqu57iKf6YKFbS6TlXn6Ri9KwOkeMYV+agl0tb
	 rVr4gXEN6ydl1l/rxSJ5aPpEKfNHhkEO5toaFBuWsk1a9pyWm9JdX6UWrOq+Rb6Up0bMR
	 udUEWAr1Y/3d/uGBWpVwIFKDZz3MZnglwjO/lIFqybFIerAsSBiVloZ0EPio3yU5SI6kU
	 5aIe4udJyxa4daLlY21npRaNG7PV1G1bj3I8SDmwvtp3KGX9nxnwB8ACmWN0i9pNBQ5AX
	 zz490IgonwwNXwJVkNgNLf0z8Yt8WsC2JcIyvjy0tnzKV42QmC6i6iHyHBoSxowWt2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591441;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NE5lSxkipccM/zOAgNVe6b3UgJYfmPqZfmV2FLDeoQo=;
	b=hdBr7iJtAwo/7fk3A5u3gGM8eBGGCb8fQpZCJgG0C+MLb5aueQiMtRvf1aly9NUusSDo
	 C+MZfhCJcvUZAzBtmcxvHqhTkp8eozOFyDcDkFViRziLcnjXprcik418Z21nxJfOms+Sz
	 ZcXXiKzmqh7PnD6QXDkiRx/EwsL/IntUQX/QZdPbKkp6feTPKt5XpXgkg/TJUDYBD9tu7
	 QYY/pD7+Ii14vp1OYvAulSTPFYzaVTTxiYja6RIs0AyoAMlm5caeQkhl6SPTDpbBCqjDV
	 iBoJBTy3aB5pG6fbJLlU4tSqnHFF/fyAW0xANDHP4FQXUH5d17z6SIhLSuQzbQsM1QQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Xztlrrz/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1817606E20C;
	Fri, 13 Nov 2026 17:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xztlrrz/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1F51F000C4;
	Fri, 13 Nov 2026 17:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591440;
	bh=NE5lSxkipccM/zOAgNVe6b3UgJYfmPqZfmV2FLDeoQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xztlrrz/VAqL2oG6k72D4TuUkCr0bU6DBVOvLnWPwP+EBGFDO6dSi4GfI6uq1SQis
	 fH8YO/DBgZups2OV28B6TOXLweXf3hiYLA/acJvJWNKXaW9Qh1C7/I1M3lAWqRqnjt
	 tl8cEmYyFWrkhipzkmW+uxbJak16nXEe/mumfSds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 532/670] ALSA: hda/hdmi: clamp sad_count in ELD proc write handler
Date: Fri, 13 Nov 2026 10:51:36 -0500
Message-ID: <20261113153829.943305949@linuxfoundation.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit b3e7ddd694f8429217ba509b55b910a0e4361dfb ]

snd_hdmi_write_eld_info() parses a "sad_count N" line from the
root-writable ELD proc interface and assigns N directly to
e->sad_count with no upper bound, unlike the per-index "sadN_*" lines
a few lines below which are already bounded to ELD_MAX_SAD.

snd_hdmi_eld_update_pcm_info() later iterates
"for (i = 0; i < e->sad_count; i++)" over the fixed
e->sad[ELD_MAX_SAD] array, so an oversized sad_count read from the
proc file causes it to walk past the array.

Reject sad_count values above ELD_MAX_SAD, matching the existing
per-index guard.

Fixes: acb059938810 ("ALSA: hda - ELD proc interface write updates")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20261008085133.9528-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_eld.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/hda_eld.c b/sound/pci/hda/hda_eld.c
index 3017304323757..2980d0b949f6d 100644
--- a/sound/pci/hda/hda_eld.c
+++ b/sound/pci/hda/hda_eld.c
@@ -525,9 +525,11 @@ void snd_hdmi_write_eld_info(struct hdmi_eld *eld,
 			e->aud_synch_delay = val;
 		else if (!strcmp(name, "speakers"))
 			e->spk_alloc = val;
-		else if (!strcmp(name, "sad_count"))
+		else if (!strcmp(name, "sad_count")) {
+			if (val > ELD_MAX_SAD)
+				continue;
 			e->sad_count = val;
-		else if (!strncmp(name, "sad", 3)) {
+		} else if (!strncmp(name, "sad", 3)) {
 			sname = name + 4;
 			n = name[3] - '0';
 			if (name[4] >= '0' && name[4] <= '9') {
-- 
2.53.0



