Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD9C3BF2F6;
	Thu, 15 Jan 2026 17:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499189; cv=none; b=Bm195nbYO0FHDgBbJF5eMpwt5lC0T/pa/9w8hHHlFsVVGov2tHvJQels02xRsHl3jbj8pZvqfSUHeVjgY/flEESOLEySxHidBkoHABxntFufC+0eJmIEslFU2BSaax55AY9Z4+2taaOPAp/ulPyn1Gm+dtUKvnCMhO3/1osyMj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499189; c=relaxed/simple;
	bh=qUjg97SMDnLXKwaHzCYNiDv1kvtXUwR0ya08bQYrFhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uk0Bg616mdMtAb+FiW1JYKPMvrb9hmaFN/LxiGZ6EapM+EKJjVxp61M7PFTnXZSRzpBI1T17bRgXa6s187s9yZcxhq97Syo98YILMiJM13GXmQpYfuJ2WyXd9KWeTyILx8J7590nBy2HskWaqmXyIQOIEef7gmgLGDAkL87q6sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wYa19H/q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wYa19H/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152B7C19422;
	Thu, 15 Jan 2026 17:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499189;
	bh=qUjg97SMDnLXKwaHzCYNiDv1kvtXUwR0ya08bQYrFhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wYa19H/qXiUpGnmKtZ478SoPHbXG3/U64HuzpbtLPq35Mwlr01oyA+9JousqVCGfU
	 r6fBeOVBaacFL5R8WkDrcL+VfiPOsSa6tyvQIadhVHUKP7SMrrulHnEk4ayWg2OgVQ
	 T6MtRfPgi8qheP4aTGKbE3GTSz2nUNX1+u52EzAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andres J Rosa <andyrosa@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 140/451] ALSA: uapi: Fix typo in asound.h comment
Date: Thu, 15 Jan 2026 17:45:41 +0100
Message-ID: <20260115164235.982377271@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 535a7229e1d94..eef23c761ae82 100644
--- a/include/uapi/sound/asound.h
+++ b/include/uapi/sound/asound.h
@@ -74,7 +74,7 @@ struct snd_cea_861_aud_if {
 	unsigned char db2_sf_ss; /* sample frequency and size */
 	unsigned char db3; /* not used, all zeros */
 	unsigned char db4_ca; /* channel allocation code */
-	unsigned char db5_dminh_lsv; /* downmix inhibit & level-shit values */
+	unsigned char db5_dminh_lsv; /* downmix inhibit & level-shift values */
 };
 
 /****************************************************************************
-- 
2.51.0



