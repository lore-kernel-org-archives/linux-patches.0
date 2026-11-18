Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032965;
	b=3tfR36epDoWLSuFrKy1wqOaJeXPjTNnOJH+zAyzPtQVwwGwtF14HMOLQKTJrOSc8OV2C
	 roGQyW5Vzlug050GDMj9HzJPbyMiEy3gMzHqSr1m6bo6S7Ooos8hDn4ISAVVc+6e4Dm+r
	 +I6TB4n5lDhoX6XWt3BCAv+RhH3gcn5675K+//xuMIu1BLQe0MF0V8nOBmqOqpYpYsYhS
	 T76fidzVfGbo68yYtfMcj3ZivdT8hOzq1JOSYcDzBH/C9bYgEn/hvxn1Gvelh4lKXu+Cs
	 NB3TCgy2a+ylIoAVkKLZvK9a8Z4T2DgymMoGq6qQCk9V/CTbkdhgPxnkLLEixLlQqDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032965;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h8mnHc96KxTjaQdTXtUcVK7C2kG5Czgus4zCNmH18oM=;
	b=JyeszjjjOK5PXMuRsIjSu6JYnjyrM89vfhpc4jLApL9TSM/IpfLG1MFRxrFjnHJ2RqyL
	 o0AOkIMMthuBi6fZHUSUW408w3DZAQX2L0vcC585v3YdGfq9rvuXix2pXgs91gprd+BMF
	 9SetUDWg82OEiDfLNKOXTtSTwPfFl57gmib3Kv5ETtsHrIuEzkjn6PQw9rrDfKhoN/Irr
	 cLrQX21foPeUoX+v2XVZVTHSmExF6fbsXnzHTScEmxGBsSnjcnnE3pnmtyWD74a92KIzF
	 QnZWMv0JP/zRwOv+Kj3xWFK0e8recc6Z3SE+Gz5x4IDukZKgbMom3f4xIBMUXjuqR7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YRXDTZnv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40736606A325;
	Wed, 18 Nov 2026 20:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YRXDTZnv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904201F000C4;
	Wed, 18 Nov 2026 20:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032965;
	bh=h8mnHc96KxTjaQdTXtUcVK7C2kG5Czgus4zCNmH18oM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YRXDTZnvIwAmX9xUiAd5g6CEZ6Dp7m2bDCjNrLcDW/UePnV0As4o0BkJEq1bVWbnQ
	 t8g7T4aBUq9bqr4Xptn2ULVS4M/vl4awY+JP3Zg/UBJANJVSagIEHMJd4DWp87n/bC
	 7NHcUpsEPD1IbpLCpKjFbLzQXqd517YS6SeYnpqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1597/1756] ALSA: pcmtest: Honor the enable parameter
Date: Wed, 18 Nov 2026 16:02:04 +0100
Message-ID: <20261118150113.487729296@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit fe3b45a0875a8b0944d2adee3ca62283d876edc0 ]

The enable module parameter is declared and documented as "Enable
pcmtest soundcard.", but nothing reads it. Loading the module with
enable=0 still creates the card.

Return -ENODEV from mod_init() when enable is false, as the pcsp driver
does.

Fixes: 315a3d57c64c ("ALSA: Implement the new Virtual PCM Test Driver")
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20261027012228.3797565-1-sammiee5311@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/pcmtest.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/drivers/pcmtest.c b/sound/drivers/pcmtest.c
index 3c85f90c0cc1e..0376fe17365a8 100644
--- a/sound/drivers/pcmtest.c
+++ b/sound/drivers/pcmtest.c
@@ -762,6 +762,9 @@ static int __init mod_init(void)
 {
 	int err = 0;
 
+	if (!enable)
+		return -ENODEV;
+
 	buf_allocated = setup_patt_bufs();
 	if (!buf_allocated)
 		return -ENOMEM;
-- 
2.53.0



