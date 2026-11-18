Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027789;
	b=N1WF6OT1ADqPG0isLB4Bp2J3athQsaeBM3D5brYArPSeAecijB5HwlOGSWe60ShYpeXJ
	 XvKF+wXJtaThIUwQBeP+j76powXGimsv5gswjDnCYred+mGG0ZnmYfiRbLRjmchVhvF1S
	 jVNkHyYMYzKZzQ6ZyoehqV/wUKRzJUFL3Q2vMl/Zyz/8ysPXea8GC1TFKg+D2mUr+nz7K
	 2ck2IUE6wUVz6kGoeBY2nz5W5FUUuQklV8/6fA5GKEq00KoPU2nWcJhE28a6LKjm1V1Rm
	 yI6l4/mvukZcEFaDq8sokLID0FOr7sBQKBi2+GCeMIGIMZHZ4SfBoa7S+GOJol1SzYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027789;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rm4G8+EMvXBOf+V/bph2xC+OZgx/l70fV9OqzE6RGyY=;
	b=DhFUgZojO9c+oUE1rlu11aU79sR3sC7k4WmQAqBzr+4ds4iVKVPr1R+4FWVCxhgUUA7k
	 6VGsK4cMlmRxc5XvBJnpWKwOAWR03117mgfknKTEMMsjvpT66d76P+a9AqEYYoJwfMdoS
	 IxvEtjL12diK3dR3g5iwochg5MJIlYZ0hssbYw9EWYcDq3eBeQEyVYEDozFAy4iom9QGo
	 4kW3DYIj9nPyx+WVVdiCc4IBaz74AsjWcHgIkrFKKd5aj+Gy9I4OPRp9UBQwxV6fKQtod
	 wZZj+QYZVHMH4Da1TUWim33IOskOZ+Xbf1UKRB+wS2BBd9w8fGNwFlLr0uUNtbqRp2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hxDYK2bF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D7C606A320;
	Wed, 18 Nov 2026 18:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hxDYK2bF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E451F000CD;
	Wed, 18 Nov 2026 18:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027789;
	bh=Rm4G8+EMvXBOf+V/bph2xC+OZgx/l70fV9OqzE6RGyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hxDYK2bFQH4zYfIoRqGvRT4wjzqS/iAhki77L6dQ+aMBSb7Y92MXa+FWLRRsI+GNX
	 AxhZCQ1HJJajFpmdDbwlU5r/MdwiITM1huYaYWcWGvHjbgDlorapJA3GLgWWQAcHfO
	 aILaReuf8xBJgo0JQ469WcHS01Ybhgs3fQGY4X7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1873/2151] selftests: ALSA: pcmtest: Compare all captured bytes in ni_capture
Date: Wed, 18 Nov 2026 16:00:08 +0100
Message-ID: <20261118150230.023407936@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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



