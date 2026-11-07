Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063412;
	b=NuXZyBW6P/zKlJNNEzorPs9vC7RRy/pjSxqolFFeadRqDtRREtnLQl0SUuf35cqEbNPN
	 fFwx87wQGzp8lFJqdFYKf9YdEt7SfPFJFxKvRWWHRuW5NU49itzA85+8+y1wg0qekz04N
	 5AGlYj4hNzWIunZeeUICbK0xNVb0CLhbwTinK7uEMa+ZpDxTwbwqMrePz9qWeo1za4vS6
	 1dNHLUPyRp0tI7i6abH5Ex9yOWPLxS8e6h3bl8otK7965brYLHjO0HT674SBYBprQhWni
	 iW1Y4u1RoA4b9y5jV3ikOMsWhvmKB+PsVWPG9Lpxkq7Bvc3kcM5zEALIhYTnotoKSUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063412;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UP4ROJ/aquwA2lmf4ZokEfyA/kQFQb3lkv2w8kYAAcA=;
	b=rVgmx2zanjrpwKmvt9naaQS9J71nPqpdnjEmlnHaynYo6rZ86cAbiVVXcekGYiwzZBW5
	 TVVtx7ZNDWWoPy8mIFvrQtR1QK5S6DIYHtSAsHsfCwLPKHAQnzNgwSZrdxgBDAj0AWyKZ
	 LdId62iQ7t+TDNb9iJt/Ivp0/FeTkw54UlUjSWrWUamj/HrlvMG1IX0kyV9yINR8MEGiB
	 Qt16h3BkqcCOFNHAgeB1EnrjI45sQn61yqoKCy/qTib1mGScGjhGhNSabFsgRiB2ds0Ev
	 Vc7HcVVrKZWIOvTzLU2xOWJQ6B0HHCPQIbn+684yJO1KKkRJeBcnqRyjmQwlaY2MvSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=etAO6XtQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC0D606A33B;
	Sat,  7 Nov 2026 14:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=etAO6XtQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B36B1F0089F;
	Sat,  7 Nov 2026 14:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063411;
	bh=UP4ROJ/aquwA2lmf4ZokEfyA/kQFQb3lkv2w8kYAAcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=etAO6XtQfe7KMCJnptDwJz5Dp1yF6QBFGWIksbLDB+sqiJ14zfTKkrM0Xhpt1CUmQ
	 3vuq4SoDky37rk+oxW8pWnbwBiuXnkixqEz4bbGc0bfZXsflaMca0dxc9dzBqmea4W
	 0VkPcS9vTt6tJGRjOOmz7mMu2yO6ZXbq4BTCFhQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 580/869] ALSA: ump: Correct return size of fill_rpn()
Date: Sat,  7 Nov 2026 08:54:22 -0500
Message-ID: <20261107134912.850929132@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



