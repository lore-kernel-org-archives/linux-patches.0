Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032676;
	b=qJXI7vgHqM067iK0leF+sZ/+fgibZ+u/Fij9qJX2Wv85tzudL1s9Zh5eCp3AuZvbEjZz
	 VawfAdhwlDEpBdLsB/kO4MJhEsIyXSQ7RfG+UfLwU3o1ttOIA3ntB4x2mh9dR4tKIG6ck
	 i8WipcGdnmwyVeHZs6H1OFrQmbBfBSawYRwB7K4VBqx9eVphKLlbdhl/d57nVVKtT+mCm
	 yUaYl1UTCYcRVa3hDzZLmQuoFNxxA80UEuRWvzBAuliwgdf2Ux96CPDuBDcEPd+UWA4O1
	 3Y8KZQa/++bdRODCozmg+r/9iMBAJcsiOBybdfodSXx3l0K6/PNw7tRS2MsDy6qNt4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032676;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r22kdfBZLw2dHDND3H5O2Fvv6XaK8SWruAIIgcRsKAA=;
	b=TNMer9CxOjHrkXPegoj9gjvXEroNYFW6dJUCBF2IkozjrEUPWNfp8rtn7q8vVXSBuYpG
	 VfjKLvu9l7/K1tEJtJKeQkTOWQKPT7T3onRaaMAafPEwgvfW9hSzvU7ZTaU7DGV3ebVyh
	 5U6ttugtiGr6NhQoe3GKKI6pxqIhaQsZu4QJlELXoH5wc8DWhN4qCdBPSnNjqtN0920tR
	 G4PkpAWikLh+/Jpt9LTo1b7qUyjNdCaibeGthHAygy6V68ztRiB56K/4IQl1HBMDTfI+d
	 GYUQ8O0pEy5BnaABThRLagJAa+2w/iziWnEtliCHpFHXsLfMPnGJNb81d+scCyydhXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OTeRt+5S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0299F606A31C;
	Wed, 18 Nov 2026 20:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OTeRt+5S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CD41F000C4;
	Wed, 18 Nov 2026 20:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032675;
	bh=r22kdfBZLw2dHDND3H5O2Fvv6XaK8SWruAIIgcRsKAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OTeRt+5SFLSvlvZhV5DsJCtV5Zdrt8IF2M6feF+mE3touJ5Jq+wfREAvd4/imUUk9
	 OVhC1fxt+VC1koGwLZr3GWGwO8hbzg5K8LAe1w11BfAwseXllNtsviV+lvUMnYgM6F
	 6/WgDkOYmgb65RukeOmyJ4wQUXeeLgN1gc7SDlMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1495/1756] selftests: ALSA: pcmtest: Compare all captured bytes in ni_capture
Date: Wed, 18 Nov 2026 16:00:22 +0100
Message-ID: <20261118150108.476203085@linuxfoundation.org>
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
index 82ddedaab9054..c2ad42b66b9b1 100644
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



