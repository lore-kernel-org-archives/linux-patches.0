Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043958;
	b=K12r+rOCDo+152IJmKSr6iJkDpZ57vdMOxF4gL4oeyDEzYOu2LmxEUNpU0cxfmOkVO1Y
	 KUeJYgKk2ykoQWwrL6x+oOaz9HxMeKHwDUPm5Vz3YoNBkIg/sFKkQw4QQVownYSRDZ3J2
	 kjx2jzpbizqWXhyl/nvymTTg0AKl6PAwnUX1fWtwsWd8U4RawA4CZiw33CkQ0jOqb71mz
	 F2C0u3LJakDCK46inlAalZ+mwd4CE1LrLSIIYHWcaCPC4nJ4Yn1rgAER4PxfpFLn/ibWK
	 CgOJug4KAV2zNCmlQdTzx5oLq7ucOfrq++cHjcxNQ4zYRtahTT0P5Zwmkx+nP4Lgnew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043958;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C1aARtGPiqG1ZUtVq9IPR5lAbf+27dNQa4bYjl1RUE8=;
	b=ZA3J4mJlOpKQcWtbQ7pw4cSm9NqEaG5/chMugZR2h7G7/5MV6xnvVhWKiaIZswlDuOya
	 CthjTne+JXHUT6znHgvVg7Tr47oiva2/aMLqHT5Uwmt9BIleFUK6YIUZ0PFptUkhxpsJL
	 qI9H+gkS0wm4/sN8iSVwQa+S7fQbXiOZH27CNZn/03jqNTqB2raMwOFmiTVwR5rfE+Guh
	 mrJzwoxXYkigB3DlZ0Q7cAhc/I2kq+EEo4L2Azosf7Yts1KQDVCHmFLNYLaQbB5dMdNGC
	 7nxlGaNyWaQqnmD82QeyhoAMjRN/7Q0CQ58AwR/EWBE4U97ZRYXyec8IhWNqIQjFyqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZDN068u7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F12C606A330;
	Wed, 18 Nov 2026 23:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZDN068u7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C046C1F000C4;
	Wed, 18 Nov 2026 23:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043958;
	bh=C1aARtGPiqG1ZUtVq9IPR5lAbf+27dNQa4bYjl1RUE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZDN068u7KI/w80m+D07lJZmjVAvUd91x5wwiXwC8UEVXMEeyLL16tmCpC9/R2zZn4
	 Ybze+oFfQZ76VamqJNxlL0jhyEyYw6rKYz0zjJaRIKL+gQkixOIooNYQyeQA2K2Kza
	 7WZeanFq1RrZzZSuO4R9AHmqk0aAeRBw2K0DFATg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0395/2857] ALSA: rawmidi: Return the error from snd_rawmidi_input_params()
Date: Wed, 18 Nov 2026 15:23:49 +0100
Message-ID: <20261118150215.616300033@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit f4a23e17d84fd2a152d9e12369761934e1af0ee8 ]

The snd_rawmidi_input_params() computes err for the three invalid mode
combinations and for resize_runtime_buffer(), applies the new framing
and clock type only when err is zero, and then returns 0 anyway.  A
caller that asked for parameters the kernel rejected is told the change
succeeded, and the substream keeps its old buffer.

The open_mutex conversion turned the early returns into assignments.
It handled the output sibling correctly, which still returns err, and
left this one behind.

Fixes: 94b98194b62e ("ALSA: rawmidi: Take open_mutex around parameter changes")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20260902125058.19499-1-sammiee5311@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ sashal: adjusted context because this tree has a mutex_unlock() between the if (!err) block and the final return, so return 0 became return err after the unlock. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/rawmidi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/rawmidi.c b/sound/core/rawmidi.c
index d8edb60550724..a1c4e280e7894 100644
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -793,7 +793,7 @@ int snd_rawmidi_input_params(struct snd_rawmidi_substream *substream,
 		substream->clock_type = clock_type;
 	}
 	mutex_unlock(&substream->rmidi->open_mutex);
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL(snd_rawmidi_input_params);
 
-- 
2.53.0



