Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA89336EF4;
	Tue, 16 Dec 2025 11:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884893; cv=none; b=Dsahh9cK8wlLiIKv5BssDnRBcLhzBiH6Vf5oWkJlFvxtCgz5DZJKHgq152PUmz6n4I1d4CmSZF6GBGF58nGscncd1Vbv2NwNapEm+ezzarDJU83F/EnidyVV7wSjl6FnywcGRKa+kfmrc7x31aRww77g4I1Wr2d/rmsRw6veocE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884893; c=relaxed/simple;
	bh=k1HwSdtL1mFGQw0h9zYUcHoWwkICCdL6pNlGf4lfHwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rdorRu6OFx6jzNn6e4HUvcSlR+QEYL2jduowDvUt5BbgpzLw4SSWNWF9uL4wCL04c06lAOG6x6h+U0KYPvuySvd9o7Wy0voBzR6IU2imNCULLFCz71zpFAxZwXtXzzXMi0Y85aa1Iuh14FDombnlUI7vfvmhum/aghX8jwbMiiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MICYtmXM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MICYtmXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016CDC4CEF1;
	Tue, 16 Dec 2025 11:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884892;
	bh=k1HwSdtL1mFGQw0h9zYUcHoWwkICCdL6pNlGf4lfHwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MICYtmXMOc35tkD8a5fE/2AVPv7cByFdawlByZwCIpRd9g4Fcjz76GYmEsttfAMGu
	 h8PEJUlUwRhvkvCBGTeCnPuyn/mXS+/PTAP+wMOryAXclyQI0tneZjej2X5sdjJ/MM
	 PTkZgFcS/m0Hj7qtYPau01Zg0CqPlKkmm0ZrI2wE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andres J Rosa <andyrosa@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 331/354] ALSA: uapi: Fix typo in asound.h comment
Date: Tue, 16 Dec 2025 12:14:58 +0100
Message-ID: <20251216111332.901887625@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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
index 4cd513215bcd8..f35e5b0561399 100644
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



