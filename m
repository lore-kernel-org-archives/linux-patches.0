Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80807DDC5;
	Thu, 28 May 2026 20:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000077; cv=none; b=gNfz6PYP0+rQAEvNiR4AlV3SWlGYMJcCA7RS59ET2mQ+FTbTS4d9wrYpB/1fEIT8FphGeOnxRZYbVhOsS+FTzWj8T/XE2jnENxd7CdjNSXPj9dnDxwkLVR8vM2P0FkCcGFV3dZqOvExXpid8lulCC8KQxVhDfy/906QS90CIsjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000077; c=relaxed/simple;
	bh=TmG0ydsMWcnj+CsIFHPBApSYpI0Ve5L240OfC4J8SBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KfaetNpDgn9Bl1fxw9AaPJIZA3/8ogD9nLftOrVtEGNXpqXCPXfz7Rx6GJMdgPoqwf9qtO9scjjRDrX48uAgy17T0QnrmrA/E0D/0+cza2md5kZ1+b1OOms296H72/s3e3sXUi+lB8vvTXbhHm6pKcISgkl2xAtQl7Y0E6AubKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vMyRVMtm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vMyRVMtm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88F91F000E9;
	Thu, 28 May 2026 20:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000076;
	bh=fkByEGDvgo+x8iRCy1ohjmkrGvloKaYf4gunMVcAaaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vMyRVMtmy73Qd8cQPk26FQM9IgcLwLNK75dZzLK0tPee9p9c3UbUFqn77bILCZWH9
	 iClt5TcK1C5p9u5xs3KtjKgyLJF3RQUKYisOz90lMB8vUaFsjNc5O0AHcO1cud9UVV
	 wfiZgARu1Dx9sgrNEVK02lritvAgfOl6A/VGVXoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robertus Diawan Chris <robertusdchris@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 294/377] ALSA: scarlett2: Add missing error check when initialise Autogain Status
Date: Thu, 28 May 2026 21:48:52 +0200
Message-ID: <20260528194646.860303935@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robertus Diawan Chris <robertusdchris@gmail.com>

[ Upstream commit c0e4fffc0f474b7ed10adee4ab2bc1a66d36fc72 ]

When initialise new control with scarlett2_add_new_ctl() function for
Autogain Status, scarlett2_add_new_ctl() might throw an error. So, add
error check after initialise new control for Autogain Status.

This is reported by Coverity Scan with CID 1598781 as UNUSED_VALUE.

Fixes: 0a995e38dc44 ("ALSA: scarlett2: Add support for software-controllable input gain")
Signed-off-by: Robertus Diawan Chris <robertusdchris@gmail.com>
Link: https://patch.msgid.link/20260508033914.111596-1-robertusdchris@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_scarlett2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/mixer_scarlett2.c b/sound/usb/mixer_scarlett2.c
index d0cad1d1efa35..da3c2741ef575 100644
--- a/sound/usb/mixer_scarlett2.c
+++ b/sound/usb/mixer_scarlett2.c
@@ -6707,6 +6707,8 @@ static int scarlett2_add_line_in_ctls(struct usb_mixer_interface *mixer)
 		err = scarlett2_add_new_ctl(
 			mixer, &scarlett2_autogain_status_ctl,
 			i, 1, s, &private->autogain_status_ctls[i]);
+		if (err < 0)
+			return err;
 	}
 
 	/* Add autogain target controls */
-- 
2.53.0



