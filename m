Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC192F260C;
	Thu, 28 May 2026 20:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998914; cv=none; b=qyZCMPto7INxXlWEKSP2JmnT3Hxft6tC1tv+FXMeDhzEz7pimgyNXrTDfya3VUUFs6Pr7S9MyT661PU9g3Ox4trE6VdXbTMbYhdA++7Lf7uGgxXEe+6LETKp5wLKt2OmX1Ln26XFAr93oqcXjERfg351yXS7A50/p+0L3M1Isp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998914; c=relaxed/simple;
	bh=dyH2DgcERfof4aABh8R+e+iu3cmrsb5Jm/nSDbuOsRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fclZRu3z3fX37EQBphZN3fDrr0A/5L4c18S02cnkiDm9+74IqBl+wGJDMu0x8oq+UOt1Tptn7GaKtgRPvJfDzvepJEE21xmQ4Jidkfy+8/vh1x664B2mG7lG2tMWOPhvTCL8W2RiD/a6uGKHRzSUv/qcqH/wxY3Ku1UA2vLqVaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ckf0sr8a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ckf0sr8a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0C91F00A3A;
	Thu, 28 May 2026 20:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998913;
	bh=mtb/BGWQTn4LNc7dzD+v6yK06BE3XIVswOlqEe0eQ+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ckf0sr8ahLlELIpfzaGBqXheMqVAUVt4u+zza2S75dbUjHiatDKWWdS++gSS/lLYd
	 HgoaKr2ekQDMATKJjqQ+CFy99vssl2JNPjX6G/IiGCECuTP7aJle2gSNkiC5D0/wzB
	 C7nl02MSl6AKQKvlaFYF4mvmT6T6+zi8LcZZvsu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robertus Diawan Chris <robertusdchris@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 341/461] ALSA: scarlett2: Add missing error check when initialise Autogain Status
Date: Thu, 28 May 2026 21:47:50 +0200
Message-ID: <20260528194657.235865343@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 4ca96fbee3bc0..8e80a7165faf2 100644
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



