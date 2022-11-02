Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6A47E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:35:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D045C433D7;
	Wed,  2 Nov 2022 02:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667356525;
	bh=AUG4Jc/fBwhpISipewrG4GRUDTJmiSvptbbl5WMwHso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JSJPw/4EDM302Qy780oSxLP/DEbXOW0lsA+I/MIPTNeSGi/hT3aZuUaWludTZpzqZ
	 JKWaNH7WzKk0A6cC64TWtubdv+AGs4q97saPcLNLyHBVpRz04cbEut/nKwduZIZOcz
	 +fecb01srZB8HnCw1J7EOR0BICojT8Gj/hiLDdw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.0 015/240] ALSA: ca0106: Use snd_ctl_rename() to rename a control
Date: Wed,  2 Nov 2022 03:29:50 +0100
Message-Id: <20221102022111.752967029@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

commit 957ccc434c398a88a332ae92d70790c186a18a1c upstream.

With the recent addition of hashed controls lookup it's not enough to just
update the control name field, the hash entries for the modified control
have to be updated too.

snd_ctl_rename() takes care of that, so use it instead of directly
modifying the control name.

Fixes: c27e1efb61c5 ("ALSA: control: Use xarray for faster lookups")
Cc: stable@vger.kernel.org
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Link: https://lore.kernel.org/r/bffee980a420f9b0eee5681d2f48d34a70cec0ce.1666296963.git.maciej.szmigiero@oracle.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/ca0106/ca0106_mixer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/ca0106/ca0106_mixer.c b/sound/pci/ca0106/ca0106_mixer.c
index 05f56015ddd8..f6381c098d4f 100644
--- a/sound/pci/ca0106/ca0106_mixer.c
+++ b/sound/pci/ca0106/ca0106_mixer.c
@@ -720,7 +720,7 @@ static int rename_ctl(struct snd_card *card, const char *src, const char *dst)
 {
 	struct snd_kcontrol *kctl = ctl_find(card, src);
 	if (kctl) {
-		strcpy(kctl->id.name, dst);
+		snd_ctl_rename(card, kctl, dst);
 		return 0;
 	}
 	return -ENOENT;
-- 
2.38.1



