Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC3036D506;
	Sun,  7 Jun 2026 11:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780830021; cv=none; b=eklmvt2L9CjVySkNHkXXhtQSdYX/gTa/vsXePiU4PX8kRGI6Wen3wJqtzBhVhg35WH30nNkPqd+6Ij9ajUxOlMCqEvO1ZftRP/ZJ5laAgJYfLGb/8ZdOqtPqBl6KSq+wqPeFJkxuYL4oSwQGO2xIDHVUJkYbOXWvdKRRgX61dCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780830021; c=relaxed/simple;
	bh=9i9zGR8gqaEih7MWfq3WWqKIJtAJ/ZoD6zDXjSnURdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okNzNXzNqaQ1xgZB7F9zLEzdUoziOWRpX/bdk8BMc6S3KUk/JhuKE7HS1pjiAsnyeCOBMJLCUwjh7kpNJ+pKPq5QEEpUGhwyhAgw2iaWoZjoqHagK6qI28KapgWUN30brdXfmtN9R+qvP4zqVxIAB4vz7siZw56wUP1nGzThVpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WsUqhSG8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WsUqhSG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD771F00898;
	Sun,  7 Jun 2026 11:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780830016;
	bh=1MPD2OJMlQcNLM9pue61Y1lfz0HsRgvz0x5D5auRItU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WsUqhSG8BBvKxNULwOF/9nh4HMWrep1S+k9XwOSNH04FUDCUCoVr4TNGQugDrsNDg
	 wQeQzODbwzF9gWgxT83ZEOSsRi7RoVGORDjIELS0udgDBgis7wz664wOrQflWtIXzx
	 QmK7Q3AwvsEbyG83aDWobW2Dw+qjj79JpcE3xmfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 273/307] ALSA: scarlett2: Return ENOSPC for out-of-bounds flash writes
Date: Sun,  7 Jun 2026 12:01:10 +0200
Message-ID: <20260607095737.742924558@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: "Geoffrey D. Bennett" <g@b4.vu>

[ Upstream commit 74641bfcbf4e698b770b1b62a74e73934843e90e ]

When writing to flash, return ENOSPC instead of EINVAL if the requested
write would exceed the size of the flash segment.

Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/3a4af07b0329bed5ffb6994594e4f7bd202aad0f.1727971672.git.g@b4.vu
Stable-dep-of: a69b677e47a8 ("ALSA: scarlett2: Allow flash writes ending at segment boundary")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_scarlett2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/mixer_scarlett2.c
+++ b/sound/usb/mixer_scarlett2.c
@@ -9550,7 +9550,7 @@ static long scarlett2_hwdep_write(struct
 		     SCARLETT2_FLASH_BLOCK_SIZE;
 
 	if (count < 0 || *offset < 0 || *offset + count >= flash_size)
-		return -EINVAL;
+		return -ENOSPC;
 
 	if (!count)
 		return 0;


