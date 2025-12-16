Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96833570B0;
	Tue, 16 Dec 2025 12:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886562; cv=none; b=swgKbeJUCwJ7nMhCLud87mC7Os7/7/Gqeifzg1Z787GOyUwQO0Hr5tLJD8y4ogdDth1VbXkBxDI4IZPvk+mO3NLkgAabz+UzLR/JrNJWo6ospsLTVGZ/1gmQqbbo0Hbthj+KbUv3blrWUyXme+zoQFvmyzW1ViGl43TA7oYKxPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886562; c=relaxed/simple;
	bh=8apr2QRA4KMLgCzaeNftMTmzlNoxFlR47lqVVUIVxc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KG61JUINMqvUuz40+lDs+8RGDat0Kz950KMwbZTh9Yj17PWEzzYowU+XjJvgiKcZiCtG6K9XwIpQRkt351Jih1H4avYm9jLTt2EBlVr1j73nIqxXJ/S0f5nlHfipqj9ZOezBZaptSzXtX1KIrAL8YoQQoHt/tfuNDFpEtiIzc5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eJzKCZNB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eJzKCZNB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA762C4CEF1;
	Tue, 16 Dec 2025 12:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886562;
	bh=8apr2QRA4KMLgCzaeNftMTmzlNoxFlR47lqVVUIVxc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eJzKCZNBS13bOzQVIMhmeRvQ5rRi/5enmdudGrUMdziUi6Y9/m/yWhd9FP5XOQBKz
	 InEoDbO6vdjbIXrmLTF3xIG46NcWrUkjM6ZeQ00jCChQSi/UoZDgUtT4IRp2FdQCUH
	 7vlVZQ7+MXixWQx4ota7fm1El7DvPFRem5/GOGrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andres J Rosa <andyrosa@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 474/507] ALSA: uapi: Fix typo in asound.h comment
Date: Tue, 16 Dec 2025 12:15:15 +0100
Message-ID: <20251216111402.615670469@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andres J Rosa <andyrosa@gmail.com>

[ Upstream commit 9a97857db0c5655b8932f86b5d18bb959079b0ee ]

Fix 'level-shit' to 'level-shift' in struct snd_cea_861_aud_if comment.

Fixes: 7ba1c40b536e ("ALSA: Add definitions for CEA-861 Audio InfoFrames")
Signed-off-by: Andres J Rosa <andyrosa@gmail.com>
Link: https://patch.msgid.link/20251203162509.1822-1-andyrosa@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/sound/asound.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/sound/asound.h b/include/uapi/sound/asound.h
index 5a049eeaeccea..d3ce75ba938a8 100644
--- a/include/uapi/sound/asound.h
+++ b/include/uapi/sound/asound.h
@@ -60,7 +60,7 @@ struct snd_cea_861_aud_if {
 	unsigned char db2_sf_ss; /* sample frequency and size */
 	unsigned char db3; /* not used, all zeros */
 	unsigned char db4_ca; /* channel allocation code */
-	unsigned char db5_dminh_lsv; /* downmix inhibit & level-shit values */
+	unsigned char db5_dminh_lsv; /* downmix inhibit & level-shift values */
 };
 
 /****************************************************************************
-- 
2.51.0



