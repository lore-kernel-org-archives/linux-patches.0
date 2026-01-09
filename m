Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CAB33CE9A;
	Fri,  9 Jan 2026 12:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960090; cv=none; b=kKR1G4wykqivHNKIcryhx3dZIjDLfe3GkU+xPg6HUIdbJ+iTKqaNLweKmSER4hRqUq4Em02xoW/jUbSKxUiBConHth+lS1rJwhjqj6qZSB2C2TSicfhosuflWoAbyEOM/weq6nU/3oAoMOU+ABt9y/zPgLKe5FO44mmLnasnqIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960090; c=relaxed/simple;
	bh=0omRgO/lcvHjEb37dq1t70BP85/yV+JgzII4ZBFE8vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HMBCe7ElXM3HCoztmIx4dcwHTrndcmyL7kEhnRZyFvRkGYbPa5PgI1jiMnZxso/XVDlm5Yzoe/nVOeGSKRrQgSTCN1k7wQYioo9sbg+RQJgxjBmR3cZ6YtTStK29wMRsDjL8wmexUNY1/0bYFTwT61EB2Pw4ew6cneez0KmdzC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z1xeYYU+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z1xeYYU+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95CC2C4CEF1;
	Fri,  9 Jan 2026 12:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960090;
	bh=0omRgO/lcvHjEb37dq1t70BP85/yV+JgzII4ZBFE8vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z1xeYYU+qunH5Odf6V9OZrh9j2EDLgiqXmyWJ9wIEvKaQQ/IjrnxuY4Qrq0KM0SHo
	 naIB/vOnUZ57/E2vuS1rZYG3h19b6x5S58BEs7JDc9ir0MLoUOlQDFM9YSOiBDv0AM
	 Za50X4lXWAt9TFYEREJHRbGXJTtuU3fQyHGw3duo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andres J Rosa <andyrosa@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 280/737] ALSA: uapi: Fix typo in asound.h comment
Date: Fri,  9 Jan 2026 12:36:59 +0100
Message-ID: <20260109112144.544232527@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f9939da411227..10966a9250cd9 100644
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



