Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A8335A95C;
	Fri,  9 Jan 2026 12:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962070; cv=none; b=i4HcNqKOGiISYUV0awPBHStBODkR9pT75V8lxJy71jf/I9z5IQtRc26Lh2RNz72ALL1qJc7ctmE6SxOjDAX7kbcW0TiJW2P4cBmdbV+WPAbq0gOc8PLUwV5RN/6LIAZFqz/ucXx9HfHVIKB4TkGovq1zacCwUQGXQblZPnKPim4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962070; c=relaxed/simple;
	bh=zhPVLryAJw9Wt0LJGFGxc0BKDrIBgHr2nptmnVwCQK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ci4CHZzWqdKIM4k+eEmvmxe5B3qSdjb3uJ4pBzVbKXW9HuD9mR3vKso596EwmQyQ3f5t5GLJ5DypFlkwLI+q4Hb2dzUTKhUAfC9t5nziMLfAguJ1Ad7q78CBafkp+DZs+If3S9gbP3SGwQ+kht0k+gA34ytZ8opBuHuJxUgcPqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r3kp12ev; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r3kp12ev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30BFEC4CEF1;
	Fri,  9 Jan 2026 12:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962069;
	bh=zhPVLryAJw9Wt0LJGFGxc0BKDrIBgHr2nptmnVwCQK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r3kp12ev+7QuZX48XazVJUG4hb5BJGS3h6tU7v0Y04Ff6LkF0ypUV6aBLBvN1iLqI
	 IaIwMNsP25REjHlovlpdzwxsn6mNA5zAryBC/G5WjD0rUKg9/dY/DbhrQKtDFI+brs
	 Zdx+uuYpkwuduH90IY3HQQHuGzKJYU+aComw+wUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andres J Rosa <andyrosa@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 208/634] ALSA: uapi: Fix typo in asound.h comment
Date: Fri,  9 Jan 2026 12:38:06 +0100
Message-ID: <20260109112125.265090963@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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
index de6810e94abed..02b6f8eb0e29a 100644
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



