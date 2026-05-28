Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B671DE4E0;
	Thu, 28 May 2026 20:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000965; cv=none; b=sDShIMdjLafhAZ9DNwc5Kj/BGX/nuuBiX/yqzwo0v+Fph6B8ekG1foC9xrTQl5PCYFu4GMkcSAygo1ao8nzq6D5vD0P5AzzKcwo4zHEMn8i+nG7Oc8s/4B9oelrCNkgA6KvQ88ADP+O2fxrRbuNjBS2SkXwVIZy2mHXNfAFZZ90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000965; c=relaxed/simple;
	bh=IEcyFp+VqDTgZ48YKRoLr4f0IqlAvqAF8vaihudo4kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jkjq44x7vzfnTSLfGn+oXdGoRanXYxpp9Qd9bkh4K+hgNXd8fZgyh8mIHj/BCsOQDk5bYcmmaOvL6nbNYCUrXfW44rkWLTMai7RfK3VmUTLdzkY00/LAfQq6jzSnKb0r1bSzRX0NvgYmxW8ZE4+rTbS1wFI3GAeWt5yNylAiLJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MeX6/ncI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MeX6/ncI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4621F000E9;
	Thu, 28 May 2026 20:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000964;
	bh=0fcqXiki9qQMuBLmolbACJM36A3nK8JRrpC/xTmF/Dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MeX6/ncIt+LJBxt8y6jJODnNjsFJKGzSN9kzFBE7wnj3m9j7+HV7++zP1Sf6vaJji
	 F2+ZGqDtYCJU+4+1JsqKYWdQcjgtIgT1NNS9J8a/bqMpn1Q5P+GM/4ANjL3Al7rJpF
	 o2w7pfXyggcXXWsvfDmFGLiuNZY741eosvyqQJvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robertus Diawan Chris <robertusdchris@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 232/272] ALSA: scarlett2: Add missing error check when initialise Autogain Status
Date: Thu, 28 May 2026 21:50:06 +0200
Message-ID: <20260528194635.665567173@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ef5945aa40e4a..d767a89e452d1 100644
--- a/sound/usb/mixer_scarlett2.c
+++ b/sound/usb/mixer_scarlett2.c
@@ -6956,6 +6956,8 @@ static int scarlett2_add_line_in_ctls(struct usb_mixer_interface *mixer)
 		err = scarlett2_add_new_ctl(
 			mixer, &scarlett2_autogain_status_ctl,
 			i, 1, s, &private->autogain_status_ctls[i]);
+		if (err < 0)
+			return err;
 	}
 
 	/* Add autogain target controls */
-- 
2.53.0



