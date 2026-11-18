Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027705;
	b=rAI3UYOA/BplMnHoipZDL1ERFmutZLBy1LLghYAKREa89CxjLnX3AjILhLThvq69EiJb
	 IVwApiS9KMJ5n4afDSSMt9UpAcrNU+AN77DXDpFOlznPowjO+51GRbF8yG1C7ZjPU7O0S
	 5zrPn/PCbJEHR6OfHx/NtWpepTGPKKBCmt4EXn2+GiKfesiZLF34ZLMWPwmTOSD1sd9tI
	 6oXoZJaBEHTDR9ygy8vgOMCqlc4hNHo9pcKbY9DJOgpR9B8LotZ42hj68MQuLLd3FiMgO
	 u+Ic70SjF7Ms2VcyQer79cXO4qTGvIOQqZtIOCM/GGG8AYwGeX2hiL7o1PSXKkRUzog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027705;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9ErTWyDqg5OIjuao63GeVCibiEyHlsPb74b5oxPo7Tk=;
	b=ho4AdaXJ9r0mJ60HxdAzs8Wxv7b/myli8zLTaSl2Vywf7sZ1VHXb9LAkbPFEoJZ6U5mj
	 R+UMBorfC3muLLv2ABWsBi2gQpLnGXPgUZONjDlH8CgPRhE61b7vr6arm+efB9NPsOqNc
	 qH7ziDeyt6ojAAAP+xfZiZNvthscFoaKLIDDNDJEc4/Ezo0lJmVCpa2eBzvrHitck9/lW
	 hkebEMISrgtKjMnOs1ArKWjJhGfAt1itKnoFROkezt6ltpdHzfmNai0i6Nhl3JVQceQd1
	 QOekPwVnBYQYQDhDWnKdoLucrh1vVXYUVbMLVW1imcdDCX3guO9NemlYordSIFuApTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=spOd2fPj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B4E606A331;
	Wed, 18 Nov 2026 18:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=spOd2fPj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110191F000C4;
	Wed, 18 Nov 2026 18:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027705;
	bh=9ErTWyDqg5OIjuao63GeVCibiEyHlsPb74b5oxPo7Tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=spOd2fPjtPBPpLSMC4lNPaXKGXqoLK/kAGYXiwyCFAbcBPTmzjuom9vetz22ej0NK
	 qOfpOrHobBpoEjIPnf9p8+N95H38PvV6mf6Ay1Tb7B6qwHojgcM1RHmxPNUmOx+eU5
	 4x2qZ8YcrRR6IRZMCWYbu+5ARMxKLMs5xlmye2Fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1867/2151] selftests: ALSA: pcmtest: Check the frame count of each transfer
Date: Wed, 18 Nov 2026 16:00:02 +0100
Message-ID: <20261118150229.809224798@linuxfoundation.org>
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

[ Upstream commit 317f2ddb6662fca8954e381a1bc632667872c4a3 ]

The tests keep the result of snd_pcm_writei(), snd_pcm_readi() and
their non-interleaved forms in a size_t. A size_t is never negative, so
ASSERT_GE(res, 0) always passes.

The capture tests still catch a failed read when they compare the data.
But the playback tests do not. The driver sets pc_test to 1 when it saw
no corrupted data, and that is also true when it saw no data at all. So
a playback test passes even when every write fails.

Store the result as snd_pcm_sframes_t and check that the whole request
was transferred. The calls block, so a short count means an error.

Fixes: 10b98a4db11a ("selftests: ALSA: Add test for the 'pcmtest' driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/6f16e2a01f18c0ea069164bab31999182ff6d49e.1792390197.git.sammiee5311@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/alsa/test-pcmtest-driver.c      | 21 +++++++++++--------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/alsa/test-pcmtest-driver.c b/tools/testing/selftests/alsa/test-pcmtest-driver.c
index 95065ef3b4410..5bba17434a6bc 100644
--- a/tools/testing/selftests/alsa/test-pcmtest-driver.c
+++ b/tools/testing/selftests/alsa/test-pcmtest-driver.c
@@ -166,7 +166,7 @@ FIXTURE_SETUP(pcmtest) {
 TEST_F(pcmtest, playback) {
 	snd_pcm_t *handle;
 	unsigned char *it;
-	size_t write_res;
+	snd_pcm_sframes_t write_res;
 	int test_results;
 	int i, cur_ch, pos_in_ch;
 	void *samples;
@@ -190,7 +190,7 @@ TEST_F(pcmtest, playback) {
 		it[i] = patterns[cur_ch].buf[pos_in_ch % patterns[cur_ch].len];
 	}
 	write_res = snd_pcm_writei(handle, samples, params->rate * params->time);
-	ASSERT_GE(write_res, 0);
+	ASSERT_EQ(write_res, params->rate * params->time);
 
 	snd_pcm_close(handle);
 	free(samples);
@@ -206,7 +206,7 @@ TEST_F(pcmtest, playback) {
 TEST_F(pcmtest, capture) {
 	snd_pcm_t *handle;
 	unsigned char *it;
-	size_t read_res;
+	snd_pcm_sframes_t read_res;
 	int i, cur_ch, pos_in_ch;
 	void *samples;
 	struct pcmtest_test_params *params = &self->params;
@@ -222,7 +222,7 @@ TEST_F(pcmtest, capture) {
 	snd_pcm_format_set_silence(params->format, samples,
 				   params->rate * params->channels * params->time);
 	read_res = snd_pcm_readi(handle, samples, params->rate * params->time);
-	ASSERT_GE(read_res, 0);
+	ASSERT_EQ(read_res, params->rate * params->time);
 	snd_pcm_close(handle);
 	it = (unsigned char *)samples;
 	for (i = 0; i < self->params.sec_buf_len * self->params.time; i++) {
@@ -239,7 +239,8 @@ TEST_F(pcmtest, ni_capture) {
 	snd_pcm_t *handle;
 	struct pcmtest_test_params params = self->params;
 	char **chan_samples;
-	size_t i, j, read_res;
+	snd_pcm_sframes_t read_res;
+	size_t i, j;
 
 	chan_samples = calloc(CH_NUM, sizeof(*chan_samples));
 	ASSERT_NE(chan_samples, NULL);
@@ -257,7 +258,7 @@ TEST_F(pcmtest, ni_capture) {
 
 	for (i = 0; i < 1; i++) {
 		read_res = snd_pcm_readn(handle, (void **)chan_samples, params.rate * params.time);
-		ASSERT_GE(read_res, 0);
+		ASSERT_EQ(read_res, params.rate * params.time);
 	}
 	snd_pcm_close(handle);
 
@@ -273,7 +274,8 @@ TEST_F(pcmtest, ni_playback) {
 	snd_pcm_t *handle;
 	struct pcmtest_test_params params = self->params;
 	char **chan_samples;
-	size_t i, j, read_res;
+	snd_pcm_sframes_t write_res;
+	size_t i, j;
 	int test_res;
 
 	chan_samples = calloc(CH_NUM, sizeof(*chan_samples));
@@ -294,8 +296,9 @@ TEST_F(pcmtest, ni_playback) {
 	}
 
 	for (i = 0; i < 1; i++) {
-		read_res = snd_pcm_writen(handle, (void **)chan_samples, params.rate * params.time);
-		ASSERT_GE(read_res, 0);
+		write_res = snd_pcm_writen(handle, (void **)chan_samples,
+					   params.rate * params.time);
+		ASSERT_EQ(write_res, params.rate * params.time);
 	}
 
 	snd_pcm_close(handle);
-- 
2.53.0



