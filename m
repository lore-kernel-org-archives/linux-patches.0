Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042414;
	b=YRzx18VpfG4TZcXuBFpu//pF43AH0CCamfeN03bt1Q3McgGHHJFS886IRDoaeraApOnS
	 XU6/RKXgAE6zCS0Ai0StqQ6NB+lwOCzVtC7i9Vh6lv3noIzj8TlYpDtagS/yNA/BQJigc
	 EFaTuUyV+RDIIYuZbvgUC1DPrYXQ8vL1b8zKiAOsPP96/qkIDUGN+XuAQO5TGx/q5pb/9
	 t2hx5hSRD/iHDMeDUJc4WXpZt1MRwYRkxuKMp2H/orVDGRJgVW52fOFtOi2+8DbJRww8K
	 VsZ4FzzrI+bVtyhJswiLIHa/8GCVJaNRTfOZpfcQnUZlnC0++9cLVyfUK18L6/9bfNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042414;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZKpsXhHIfIyt+p0UNXQKt7TzIT4+qtXdGRAqE9hTI0w=;
	b=fsgJ6YQERbGgHNNlpSvpLYV1rJfMh/M+b+JzwdxvV+B7sAOwtA1GZfjaKc36JiXVBtS8
	 O19KKGD3AcX5KpMQcXE4tIOL5YQaJvwTwb0AgRi64k1bkSqdCC2c+NtlkIvy2qF62rt3z
	 8zyojRJKMTWvgKPe/KA5ZCtkaWRIa2c5yFDvHdhQyH9OCAWVz8mwRylr0q2o0F+A9U76y
	 SuQLoTMTLq50YmrFABW1UcG/8seOvO+uXmkNc2/N4/lXKTjR6V983KQsR0YigwzCARIf5
	 oyyEKUJYpUzQjqY4a0DSYhWecbVTpDoinGvgeExYAIfP2epFbJkHjUNaUYbdI8XUL9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1baGVkT4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31F5606A320;
	Wed, 18 Nov 2026 22:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1baGVkT4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB571F000C4;
	Wed, 18 Nov 2026 22:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042414;
	bh=ZKpsXhHIfIyt+p0UNXQKt7TzIT4+qtXdGRAqE9hTI0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1baGVkT4Yl1w2EdjFys4+/bHTnGoq0zF4qFcGGQWwDY96TjzgaAHCVYKj6gmCmLRp
	 7mEh5k1hoYa3LQn4v25t48/FGEL1Qw51qttFtXea6k6JnZ/Py4w5TVlC6RD64ZtleD
	 BvetK3gRGR4RoS5PwmcZZY8wtZCW3OVusMiVYYgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3111/3318] selftests: ALSA: pcmtest: Compare all captured bytes in ni_capture
Date: Wed, 18 Nov 2026 16:02:13 +0100
Message-ID: <20261118150453.298675419@linuxfoundation.org>
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
index 183ad959ac8b4..6076b8078f9e1 100644
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



