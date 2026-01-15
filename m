Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4702D6E72;
	Thu, 15 Jan 2026 17:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497750; cv=none; b=AcloM00TIle0Ft5D8zDA2RtKa9qGidkwA2UYCRKZJuPqu7OpofqUfLjDZLHTNbfpxd/PIGZj1jtj9GgMRlhKriWsK/VYKpQe2h1ezRw0mKIRPCoVdzEesYlw0KJuLwDdFbGIw3YpZbhcy3e3+l1y9tMcufVpK+LL6FdLa0sIgyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497750; c=relaxed/simple;
	bh=8542yIQ7SYGCwGc3+EmWz8Cjf0Xiq08ZC0yBWTLjGAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iSce+mtHXClIWbTC2jS5pnYtee9s57PFgfqoI+8jR58Ljp77vls60UaZ+JO6ZLAe6KqaEMZKONNBE0C2DOopu1/gknMWQr9Fzkf7f2rVZuE9rqOi99USk/v/hb2AmoMRpOECwThANoNzdoddm6ImOP9ypVqdDQHkzWHYQYbRT/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0M134WJi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0M134WJi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 189CFC116D0;
	Thu, 15 Jan 2026 17:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497750;
	bh=8542yIQ7SYGCwGc3+EmWz8Cjf0Xiq08ZC0yBWTLjGAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0M134WJiqQUJx/gqhRiOii93ZsedTSaKsUTU3YaEQcxLQbs+7HPhdafcvceqLHZFq
	 BodrsDmQRltKLls0271rme4Dr+rkaQWc92WP3VXRVm5Agsp/p+8iDLoYUFYfUfJKUT
	 ZaiO4PZCLJbX4SCgyXyhhKZvorVfs4u2prXJT1Nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andres J Rosa <andyrosa@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 190/554] ALSA: uapi: Fix typo in asound.h comment
Date: Thu, 15 Jan 2026 17:44:16 +0100
Message-ID: <20260115164253.137168196@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 93e40f91bd49a..6b9d4e0befa9d 100644
--- a/include/uapi/sound/asound.h
+++ b/include/uapi/sound/asound.h
@@ -76,7 +76,7 @@ struct snd_cea_861_aud_if {
 	unsigned char db2_sf_ss; /* sample frequency and size */
 	unsigned char db3; /* not used, all zeros */
 	unsigned char db4_ca; /* channel allocation code */
-	unsigned char db5_dminh_lsv; /* downmix inhibit & level-shit values */
+	unsigned char db5_dminh_lsv; /* downmix inhibit & level-shift values */
 };
 
 /****************************************************************************
-- 
2.51.0



