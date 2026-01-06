Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97832DF719;
	Tue,  6 Jan 2026 17:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720836; cv=none; b=ebfDpKubNOCvz9rYGtKqvCc1HEXWJfSpkf+Z/u3LCn2So2vii+hGw3RSrQIuDS9y7S+dj56+8xpqCbcGQT4/f8aCjeubIJA/mO+7MtO2+WK762cEqQ+4cepWZqDqXPPGIr0qxPd3DsRVRe23YP/TDkJWOeZTRuBIHcF4zoi4q+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720836; c=relaxed/simple;
	bh=+opZzcdkGsAMQ74+Ns/QaOMQz7J8o4lhfGlTpI6Dric=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jtOMf0CtBh0QnQB7+Y5BywtiJ4sWAl/K3C0aeZ86Xf5sQYyJO6QvPXU69vMbMCaRN5aK0msSIIhy1yA31/rxtoWGR+gxaKZhILIIGhJDVm7vU8x3kC9ccwJRtcSfvqE5vtOokw8zhT664Eh41tBFvBqhyjfai79SjGWTAKACVHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FOm4IlmP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FOm4IlmP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124D0C116C6;
	Tue,  6 Jan 2026 17:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720836;
	bh=+opZzcdkGsAMQ74+Ns/QaOMQz7J8o4lhfGlTpI6Dric=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FOm4IlmPeewx/eCdBeeVdkJuknQh2yD6dP+sxGdTta7WjowMGzuJq+Fk4OUHKmOd1
	 6O0fzOP2S++UiWaRjeM1xP+twIk7AWr5LFyrUsNS5t/1xSG24ztcEx/0Gpjx5rmgPb
	 AUhtlSmZljU4twjt2hJGAGyNWf4Y9WB9et46mvjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 349/567] ASoC: codecs: lpass-tx-macro: fix SM6115 support
Date: Tue,  6 Jan 2026 18:02:11 +0100
Message-ID: <20260106170504.240333376@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

commit 7c63b5a8ed972a2c8c03d984f6a43349007cea93 upstream.

SM6115 does have soundwire controller in tx. For some reason
we ended up with this incorrect patch.

Fix this by adding the flag to reflect this in SoC data.

Fixes: 510c46884299 ("ASoC: codecs: lpass-tx-macro: Add SM6115 support")
Cc: Stable@vger.kernel.org
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20251031120703.590201-2-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/lpass-tx-macro.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/soc/codecs/lpass-tx-macro.c
+++ b/sound/soc/codecs/lpass-tx-macro.c
@@ -2474,7 +2474,8 @@ static const struct tx_macro_data lpass_
 };
 
 static const struct tx_macro_data lpass_ver_10_sm6115 = {
-	.flags			= LPASS_MACRO_FLAG_HAS_NPL_CLOCK,
+	.flags			= LPASS_MACRO_FLAG_HAS_NPL_CLOCK |
+				  LPASS_MACRO_FLAG_RESET_SWR,
 	.ver			= LPASS_VER_10_0_0,
 	.extra_widgets		= tx_macro_dapm_widgets_v9_2,
 	.extra_widgets_num	= ARRAY_SIZE(tx_macro_dapm_widgets_v9_2),


