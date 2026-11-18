Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021514;
	b=dwdWezUHdmUjo91RHq5tVmL7EOCKaEss4m+0D7jIIWf5gJOOFFeKyN1JucVlIZ+Jb4va
	 Y2r7G2BIfZEOG/OOR4Dk/s8tPlVDws0vtLKBSJH3bVaeNN7bI1rZP+aOwMIqaIXw8Wyi7
	 K/iiFa5JNtlaJKm40R+M0MX6UrYSUXntDW5j2If9Kgtx4sVre8tf/Vd5WhByUcfbFU2zi
	 JIoK2k+I3he6ChzEJHBPD/aCnqKqscvCFMzcRB1KdZEJKw5ikNlKQJMTxtducGH5atdos
	 hS/cco+VjfhwCu6iPj3FUbGZ3hS50FKF0nL+N8aqgjLNnU13gMyMFFe2vYFJz6kPUYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021514;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rtxJQUE3AIU8UQ4iOsFpn9Fx4GN3VR1IbgJ5YriWeaY=;
	b=Cn9KEye1pELoPF0qkNvy5G8x7dXgTEU/PdkyOQnFU4XcJReRvfBCSqcoFt5Ul8qQ4bS3
	 epNJofr1lEbcYp8oeY5z7CJtCASr8njYlSViYkmv8nq26+n46TBJCKBgLxH7dTme2OzAw
	 pqUiph21vEqEz7Ew8qiMRLMX1zh2gsESVhmqNmghVydU6gBZbM+OQ1XspXs0peWx7phYX
	 +383UvO6kKuvEoUqr7EOrnMnZCm+pzBQCxgHoxQjTblGW99Md9Z8kjj+bB502H7xVZlnh
	 IG3ZikaY5e6Zlu+5YEz13eRFaqam+o/o3cRhfTAFe2ctjNbqBII87lBWZE9gIEdCwSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T3yWhyOe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D3A606A332;
	Wed, 18 Nov 2026 17:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T3yWhyOe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD0A1F000C4;
	Wed, 18 Nov 2026 17:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021514;
	bh=rtxJQUE3AIU8UQ4iOsFpn9Fx4GN3VR1IbgJ5YriWeaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T3yWhyOe6YjUXCWrMcvnpYx1jGA2WuNqq/Y2M0DpOVrePS01Ogzrb4UE4QrUTjcn7
	 D+B0DWz/cTRZi2IhFp8ZW0oOtytbZhTguspKvMPt7AY8Io+SFW1IHAyDHkmnU+3Xnx
	 bZribWrFobcz1usewqQcxokLA24IuwaMBhmNLRKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2317/2651] selftests: ALSA: pcmtest: Compare all captured bytes in ni_capture
Date: Wed, 18 Nov 2026 15:59:17 +0100
Message-ID: <20261118150408.607307341@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit c8c199e1b1b3bb0ef52a2a02d1ec87bee574ce13 ]

The ni_capture test reads rate * time frames into each channel buffer
and then compares rate * time bytes. A frame is sample_size bytes per
channel, so with S16_LE only the first half of each channel is checked.
If the second half is wrong the test still passes.

Compare rate * time * sample_size bytes per channel.

Fixes: 10b98a4db11a ("selftests: ALSA: Add test for the 'pcmtest' driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20261021112554.4037107-1-sammiee5311@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/alsa/test-pcmtest-driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/alsa/test-pcmtest-driver.c b/tools/testing/selftests/alsa/test-pcmtest-driver.c
index e025a7bac26b7..18ee72d5d4c96 100644
--- a/tools/testing/selftests/alsa/test-pcmtest-driver.c
+++ b/tools/testing/selftests/alsa/test-pcmtest-driver.c
@@ -265,7 +265,7 @@ TEST_F(pcmtest, ni_capture) {
 	snd_pcm_close(handle);
 
 	for (i = 0; i < CH_NUM; i++) {
-		for (j = 0; j < params.rate * params.time; j++)
+		for (j = 0; j < params.rate * params.time * params.sample_size; j++)
 			ASSERT_EQ(chan_samples[i][j], patterns[i].buf[j % patterns[i].len]);
 		free(chan_samples[i]);
 	}
-- 
2.53.0



