Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E99319EEBB;
	Thu,  6 Jun 2024 14:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683121; cv=none; b=jsS0W6EAMgsQuf+b78NUihYVvUwzbAKclyszTqqR0grQuGUe+qi3Urr9Kwjhe+BfSJvh31s1xplw7vMtFW8ggrJaP1GlEKj7L4HDnQNYHZuckINgf/86WCQQ5Uc2ReZaA3Zx+x5UV+hkT239oSfWNvUMRAqxBo5DKIx5mVPBQTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683121; c=relaxed/simple;
	bh=kOi8VcK9kAYGwQWG1WbJkEAzsPYbp4pmM/ae8hm8eLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pVyMyrCcqvNDutNvMrts/ppK2PdhhAc4ZfSHFikK7TAvoU+bSIn7bo0zIpmYfkZ4mN/JknOsVsJZ4vnFXfuXKvOuKvkP2shICg3juSWDe3VT2V1YpJnxyGa11mUuPYnBOxsw4gHtnwM+7ikjrmcJajaBcHLLVnNhtr4gm3BkpCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TKvSKy50; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TKvSKy50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E140C32781;
	Thu,  6 Jun 2024 14:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683121;
	bh=kOi8VcK9kAYGwQWG1WbJkEAzsPYbp4pmM/ae8hm8eLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TKvSKy50CVYYelmcmYT+mhcEqPq9EaHuN8UOFQdt9nJkoIzDZ+n2dFPpDx3obDNci
	 b5lC1OMiTTY6udBMOHLOHv2BwOFnAhTlZhIGReVDQoA+U86ERRhKmUGj6cU9K2JWvW
	 8cEAZ6+0ddYZUJix4R+OLIi6SXnXd4iA7HH73f78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Yu <jack.yu@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/744] ASoC: rt722-sdca: modify channel number to support 4 channels
Date: Thu,  6 Jun 2024 15:55:32 +0200
Message-ID: <20240606131734.345193755@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Yu <jack.yu@realtek.com>

[ Upstream commit cb9946971d7cb717b726710e1a9fa4ded00b9135 ]

Channel numbers of dmic supports 4 channels, modify channels_max
regarding to this issue.

Signed-off-by: Jack Yu <jack.yu@realtek.com>
Link: https://msgid.link/r/6a9b1d1fb2ea4f04b2157799f04053b1@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt722-sdca.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt722-sdca.c b/sound/soc/codecs/rt722-sdca.c
index 0e1c65a20392a..4338cdb3a7917 100644
--- a/sound/soc/codecs/rt722-sdca.c
+++ b/sound/soc/codecs/rt722-sdca.c
@@ -1329,7 +1329,7 @@ static struct snd_soc_dai_driver rt722_sdca_dai[] = {
 		.capture = {
 			.stream_name = "DP6 DMic Capture",
 			.channels_min = 1,
-			.channels_max = 2,
+			.channels_max = 4,
 			.rates = RT722_STEREO_RATES,
 			.formats = RT722_FORMATS,
 		},
-- 
2.43.0



