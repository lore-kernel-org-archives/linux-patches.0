Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B050EEA8;
	Sat, 30 May 2026 17:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161158; cv=none; b=DtOs+Lzb7XjK+Kw13vNh0kwPhyNhdcyIzadGs7ImYnHQCpHGzkAHlITRqNf44JhxwZei97noE7GTW5qYLrNBpiO2gQ7RgDdCbpW6muvAyUXi0Ji1ofnkQt91iveT7NkovkCCReztLESrErFgLWkBJc17MpJQoL6OpKdhUFNTpaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161158; c=relaxed/simple;
	bh=6cVMnhbCWjn546JgwTbPQiN9RCSiY73cI3ocQpU+eYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFiB5BF3m8dTXxq/9I8NYNDCVhpxmcewlv+t6BQwPFMT8J3qeCAvZ3/Em8doMjnhihrmzO4zNHQAAqoZaagbBaDRgoIQAV4cxzpsWJC3zVyqk5oLY+snyygo+Os7uPVszveBa7es6pCUr/nPQnMhbXlJPiuBeO+Zqxx3y91LDEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pDzAei3w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pDzAei3w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4851F00893;
	Sat, 30 May 2026 17:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161157;
	bh=Uh9MENT3NKUf8Dy8xMYawaFhwRHaimwbssP2ZrKrPqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pDzAei3wpbC1ZxBfAX6z6qpIbrN8nA9zccnI2x1hI6jFl+k0knMGcMRJVTZYG+OKJ
	 IhRP39JaljxybX8j0TKJR0IYGrTn0iPpwbIXP1/y/6BlHnritX4qYAQpyzcWnzcKbh
	 GtYdWKX24S+vG2mqpjK2mJ2ckY4H5MJpe8qxbXSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 543/969] ALSA: scarlett2: Add missing sentinel initializer field
Date: Sat, 30 May 2026 18:01:07 +0200
Message-ID: <20260530160315.365739909@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com>

[ Upstream commit 2428cd6e8b6fa80c36db4652702ca0acd2ce3f08 ]

A "-Wmissing-field-initializers" warning was emitted when compiling the
module using the W=2 option. There is a sentinel initializer field
missing in the end of scarlett2_devices[]. Tested using a
Scarlett Solo 4th gen.

Fixes: d98cc489029d ("ALSA: scarlett2: Move USB IDs out from device_info struct")
Signed-off-by: Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com>
Link: https://patch.msgid.link/20260405222548.8903-1-npetrakopoulos2003@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_scarlett2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/mixer_scarlett2.c b/sound/usb/mixer_scarlett2.c
index 0366f4b386eb5..6c3a032d64adb 100644
--- a/sound/usb/mixer_scarlett2.c
+++ b/sound/usb/mixer_scarlett2.c
@@ -1011,7 +1011,7 @@ static const struct scarlett2_device_entry scarlett2_devices[] = {
 	{ USB_ID(0x1235, 0x820c), &clarett_8pre_info, "Clarett+" },
 
 	/* End of list */
-	{ 0, NULL },
+	{ 0, NULL, NULL },
 };
 
 /* get the starting port index number for a given port type/direction */
-- 
2.53.0



