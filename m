Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036610;
	b=rSfVjqv/YbhQgZquKq75uaWXYvrDON9Ly3QXTUI/9bxdJF5vdBDlSUCpbKCygLK5E8aL
	 Jq+U7E82v4OienLwkpLbBeIFAAi6zvWavzDdogFAI9Ft06cjOlvx+khqBc+qeEWz4WQrD
	 qrcnuQFJP65EjyPIVLSanNN55MId1OMMbSoYg2EUpjk4voVAmeb5lOkIRuuEGWKrlm7ZF
	 ggGx3jLyX7C8qpXY9X8DGhOR5kyyXEHvtNgIbd2FFC9EiF8dHr29NKLp3mi1jq80HBJRC
	 h0h54jXCdy4Clh8vB3UGKEx6UUmVPTgOo1q59MNW+QpUD4sOTuW6qes3/dV6YBPs3Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036610;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KPGXITxVfj+6y50RyLS8v+oe55v8AxjBcZDOOg//ZZk=;
	b=L9HkwUVonLHezrm8AjJjmXp94o5b9VXz3Ai3YOjzPVWj1hROZ6MtPjfc2vOccEqPXFCZ
	 ED3+He9ktojnIkYnX/T4O7UQyDiIt8SQDPLaWQXYnC0Q/RQ2FoF6++0cxhKu38Ilen3Am
	 ir+IRl7YwuWdnR96zlxb7cOv5I7dSs5276zzGgQIUcnMbL7bN6KXZOVy8J6KWuLf8nRVk
	 FrnzobnAHvraCxL4XH3s15EPlRYX1zBZQn2Jsm2odnX8vZXDMUcW3F17T3loyZM6rz3P+
	 MeGDP1LTqCQRHjois/u4QveMbY7wMzjCMyKwpqgs7rrLLXF+HoGMTVM/6D0s5q9rJog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p1kFCdvK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84085606A31C;
	Wed, 18 Nov 2026 21:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p1kFCdvK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F971F000C4;
	Wed, 18 Nov 2026 21:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036610;
	bh=KPGXITxVfj+6y50RyLS8v+oe55v8AxjBcZDOOg//ZZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p1kFCdvKHo75ms//Uq/iXuzvNpUrZdc2AgXnLNlY1/ywVmKRWthZi872jkuj/Jrp3
	 0k7UHSk9++Awe79XqmiqurlrAe8jFuntrgWfURAuoZlGF9BZuisMWy0gAJy1n1yrL9
	 ijXvhV/SW7vZeNNSCpUeOFpLe2RFyeDBbnzSJkYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1122/3318] ALSA: ump: Correct return size of fill_rpn()
Date: Wed, 18 Nov 2026 15:29:04 +0100
Message-ID: <20261118150353.691405127@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 85e8c5f933ee3dbc9d061e121237797e9fa05315 ]

The RPN/NRPN conversion in fill_rpn() is supposed to return the number
of bytes of the resultant UMP packet, but it returns boolean values.
This would result in the incorrect ump_bytes in the converter, which
will confuse stream processing.  Correct to the right value 8 as a MIDI
2.0 UMP packet.

Fixes: e6ce8a28c768 ("ALSA: ump: Transmit RPN/NRPN message at each MSB/LSB data reception")
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20261015075439.50088-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/ump_convert.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/ump_convert.c b/sound/core/ump_convert.c
index 85cc67de63306..0a7972d91ec52 100644
--- a/sound/core/ump_convert.c
+++ b/sound/core/ump_convert.c
@@ -323,7 +323,7 @@ static int fill_rpn(struct ump_cvt_to_ump_bank *cc,
 					      cc->cc_data_lsb);
 
 	reset_rpn(cc);
-	return 1;
+	return 8;
 }
 
 /* convert to a MIDI 1.0 Channel Voice message */
-- 
2.53.0



