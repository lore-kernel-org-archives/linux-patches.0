Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABACF25EF8F;
	Sun,  1 Jun 2025 23:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748820549; cv=none; b=CSZ9+4pFi5hE7VInxMyRnsDGXQDWxeHV6JnyJ1gqkrnY988IaKCxplAzoBrbT+mSpk75SHr3Tg//ZkeXAio4VK3XXWBaM3rcsiV0mUstbvS4qC0DARtvdIWar+W7XepS+ZnNRXK68d3UXRt5HYcvUoZVqDXuuFquoces0+3iqF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748820549; c=relaxed/simple;
	bh=UoMqPF0JODIkz2Nbh672KEMJcLMwggCN1tSMDfpD35E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=c/e8d4Z6zlmN7673J1YZ4LA1yQI8JqHERJpVaL0i2Rgq6D97gjArPYDLjSKmyTmz+JuWgaDLLionv3Lxu/l30Ay4LDk9HxrkBtL+HIW73zlTaAaixkYaEkoFgkJxt1h//IpImWHWcpv+0qh4rNazSVJpFk9VHIaqobIYOGSALyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nFL67hmZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nFL67hmZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3152C4CEE7;
	Sun,  1 Jun 2025 23:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748820549;
	bh=UoMqPF0JODIkz2Nbh672KEMJcLMwggCN1tSMDfpD35E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nFL67hmZ7S5dAJv9kTO/Yz669TLfH0zghMwLElZaLZDeFttcl0Q5plDU5pbnB6r7u
	 vkxV92GwGMII2GCokI4AGgpm9CuG2qxX54jFJGIVs/Gq9/dA8DupmWFyDiZgSmacbR
	 5amqXv1sDvMa9J0/PGIDDBcl8XVB//QIZtGAWf0Hg9NxHBpiBn9WrOPE5Gj16+0X9B
	 x+SLHsgBaAGUDRaCzXxnw1elDcQCQHvqdLmbpEAbPb/7LNDbw+Qt5e0naGAEqmj7+L
	 xzP6HYUUaDKxX1ZaXto/I76UBS0YnPqhkVR8gG6sapRTbCJeRIQEG9QR2vxmuWFm0o
	 eJqSKCMKHvHFA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: I Hsin Cheng <richard120310@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	yung-chuan.liao@linux.intel.com,
	pierre-louis.bossart@linux.dev,
	Vijendar.Mukunda@amd.com,
	gregkh@linuxfoundation.org,
	peterz@infradead.org,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.15 096/110] ASoC: intel/sdw_utils: Assign initial value in asoc_sdw_rt_amp_spk_rtd_init()
Date: Sun,  1 Jun 2025 19:24:18 -0400
Message-Id: <20250601232435.3507697-96-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601232435.3507697-1-sashal@kernel.org>
References: <20250601232435.3507697-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15
Content-Transfer-Encoding: 8bit

From: I Hsin Cheng <richard120310@gmail.com>

[ Upstream commit 5fb3878216aece471af030b33a9fbef3babd8617 ]

Initialize "ret" with "-EINVAL" to handle cases where "strstr()" for
"codec_dai->component->name_prefix" doesn't find "-1" nor "-2". In that
case "name_prefix" is invalid because for current implementation it's
expected to have either "-1" or "-2" in it. (Maybe "-3", "-4" and so on
in the future.)

Link: https://scan5.scan.coverity.com/#/project-view/36179/10063?selectedIssue=1627120
Signed-off-by: I Hsin Cheng <richard120310@gmail.com>
Link: https://patch.msgid.link/20250505185423.680608-1-richard120310@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my comprehensive analysis of this commit, I can now provide my
backport recommendation: **YES** This commit should be backported to
stable kernel trees. Here's my extensive analysis: ## Bug Description
and Analysis The commit fixes a critical bug in the
`asoc_sdw_rt_amp_spk_rtd_init()` function in
`sound/soc/sdw_utils/soc_sdw_rt_amp.c`. The issue is that the `ret`
variable is declared but never initialized, and in certain execution
paths, it may be returned uninitialized. ### Specific Problem Details 1.
**Uninitialized Variable Issue**: The `ret` variable is declared on line
193 but never given an initial value. 2. **Problematic Code Path**: In
the `for_each_rtd_codec_dais()` loop (lines 204-209), `ret` is only
assigned a value if `strstr()` finds either "-1" or "-2" in the
`codec_dai->component->name_prefix`. However, if neither condition is
met, `ret` remains uninitialized. 3. **Return of Garbage Value**: When
the function reaches `return ret;` on line 211, if neither condition in
the loop was satisfied, the function returns an uninitialized value,
which could be any random memory content. ### Why This Is a Serious Bug
1. **Unpredictable Behavior**: The function may return success (0) or
failure (non-zero) randomly depending on stack contents, leading to
inconsistent system behavior. 2. **Audio Subsystem Impact**: The
function is used as an `rtd_init` callback for multiple Realtek audio
amplifier codecs (rt1308, rt1316, rt1318, rt1320) as evidenced by the
codec info list in `soc_sdw_utils.c`. 3. **Error Propagation**: The
return value is checked in `asoc_sdw_rtd_init()` and propagated upward -
a garbage positive value would cause audio initialization to fail
unexpectedly. ### Evidence from Code Analysis The function is called via
the `rtd_init` callback mechanism: ```c if
(codec_info->dais[dai_index].rtd_init) { ret =
codec_info->dais[dai_index].rtd_init(rtd, dai); if (ret) return ret; //
Failure propagated upward } ``` The fix correctly initializes `ret =
-EINVAL` to handle the case where the `name_prefix` doesn't contain the
expected "-1" or "-2" suffixes, which indicates an invalid configuration
that should properly return an error. ### Characteristics Supporting
Backport 1. **Clear Bug Fix**: This is a straightforward bug fix with no
new features or architectural changes. 2. **Minimal Risk**: The change
is one line adding initialization - extremely low risk of introducing
regressions. 3. **Wide Hardware Impact**: Affects multiple Realtek audio
amplifier codecs used in Intel SoundWire configurations. 4. **Stable
Tree Compatible**: Bug was introduced in v6.10 (commit 84e0a19adb73d),
making it applicable to stable kernels from v6.10 onward. 5. **Static
Analysis Found**: The bug was found by Coverity static analysis,
indicating it's a real issue that could manifest in practice. 6. **User
Impact**: Audio hardware initialization failures can significantly
impact user experience, especially on laptops and embedded systems using
these codecs. This commit perfectly fits the stable kernel criteria: it
fixes an important bug, has minimal risk, is contained to a specific
subsystem, and addresses undefined behavior that could cause random
failures in audio hardware initialization.

 sound/soc/sdw_utils/soc_sdw_rt_amp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sdw_utils/soc_sdw_rt_amp.c b/sound/soc/sdw_utils/soc_sdw_rt_amp.c
index 0538c252ba69b..83c2368170cb5 100644
--- a/sound/soc/sdw_utils/soc_sdw_rt_amp.c
+++ b/sound/soc/sdw_utils/soc_sdw_rt_amp.c
@@ -190,7 +190,7 @@ int asoc_sdw_rt_amp_spk_rtd_init(struct snd_soc_pcm_runtime *rtd, struct snd_soc
 	const struct snd_soc_dapm_route *rt_amp_map;
 	char codec_name[CODEC_NAME_SIZE];
 	struct snd_soc_dai *codec_dai;
-	int ret;
+	int ret = -EINVAL;
 	int i;
 
 	rt_amp_map = get_codec_name_and_route(dai, codec_name);
-- 
2.39.5

