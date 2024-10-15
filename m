Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB7E1C07ED;
	Tue, 15 Oct 2024 13:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997800; cv=none; b=N3TV4ZgqUjlY0HVt1JeYaBhIGoLXGCW+o6wprKF48zByRyWSSelQNaj6TYmgeRGcbLuGSPGp7W+MHKDpjBdChVObs2Ow9GB/TrR406cCsJUyTRTepn4nkCHMJcKWxHiw6BsLx6btstK7jX7ZJzj5+pWg0lexs7FEJe5MgKpNx5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997800; c=relaxed/simple;
	bh=9Q4brchjOsrmMluSR0JmVu5vOATT1JGNM1LMvRULdkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rs7bt4qt10NxxLFgeirXXoKey1rKIZ03ETR50WAJh3hY3ThCbbwvrNaN6OTPwdeVrTC5nx/KPdAVYfc5IxljE0pvy83gzjQP/XpwQ6sy5JOX5nb9j6+LMjsc6zTAuV+HrzWud9v2qAuMhReVAel9NjGQesPIgpJ065W7T16Ig7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uWigHkfq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uWigHkfq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA36C4CEC6;
	Tue, 15 Oct 2024 13:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997800;
	bh=9Q4brchjOsrmMluSR0JmVu5vOATT1JGNM1LMvRULdkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uWigHkfqZutw4oo4mRiyXCbdQrA4JzNa8dQkSrBkOxRQS1rxCDGLYZIBqk7oXS9VS
	 kMrFfOgiQLE4nV1y6K/vZyyTv+z4XofYRjyWVACPgTP2DAQs94+ShWHBB8xFNv0mnS
	 d+OqKUVHYfqT5As6nxnux0qW1UooYvF5tE7Kpv1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oder Chiou <oder_chiou@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 290/518] ALSA: hda/realtek: Fix the push button function for the ALC257
Date: Tue, 15 Oct 2024 14:43:14 +0200
Message-ID: <20241015123928.181858316@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oder Chiou <oder_chiou@realtek.com>

[ Upstream commit 05df9732a0894846c46d0062d4af535c5002799d ]

The headset push button cannot work properly in case of the ALC257.
This patch reverted the previous commit to correct the side effect.

Fixes: ef9718b3d54e ("ALSA: hda/realtek: Fix noise from speakers on Lenovo IdeaPad 3 15IAU7")
Signed-off-by: Oder Chiou <oder_chiou@realtek.com>
Link: https://patch.msgid.link/20240930105039.3473266-1-oder_chiou@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index d6ebde90f0825..de2a7eb55ae35 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -578,6 +578,7 @@ static void alc_shutup_pins(struct hda_codec *codec)
 	switch (codec->core.vendor_id) {
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x10ec0257:
 	case 0x19e58326:
 	case 0x10ec0283:
 	case 0x10ec0285:
-- 
2.43.0



