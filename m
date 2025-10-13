Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4199221F20;
	Mon, 13 Oct 2025 15:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368640; cv=none; b=PecZk4vnd1BFWtNdT910EHTuZQr/OxXoEtzPiq2IW7OabI7YK742WpicZu3Xa6DkCuNlKK6lIvbv0Wpwyji2jSHe5EIja1QPYPPi25S7m/4DX7x8nCKR+ewMmH1mBCRnvIzkjwZzt4VBeYRmJHnOQEbYTMlaJqNiCnfKsbtSPAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368640; c=relaxed/simple;
	bh=CLrgn/UB2VfqB9xMRz3ZT1Yov0Ad5srV/pixfath5rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UfiGXgYzE+NsWDERK3Otz/vYkU/4yiXnYvj9sGMCY9odAEa/DIlczirMIv7lZuHfytLtIinq/DNi0xpCQ/NArKlJ2CJv7d82+DKTQELxUTXixKtGieAPjveJvn6WQuNsyaNSJ+993utEV4cepymSxAhLyQ9shRfUqggKF1GSCFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qw0a3gS9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qw0a3gS9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5096DC4CEE7;
	Mon, 13 Oct 2025 15:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368640;
	bh=CLrgn/UB2VfqB9xMRz3ZT1Yov0Ad5srV/pixfath5rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qw0a3gS9JukQQ/0A5I6BGPch52dUFDV0j2ePcr/5PCkM0qXBsO7HMza2A1BbcGlLY
	 B3DyAixb/6Fzb391mlQQZnkPZGA8cW9O1QSaZE1OtOiVe34WKh5KV06cGpzOdJ5QML
	 3e7s4gq6hZ6uaOht9VDGNvFtGRKdZmsyNN8LNVys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 231/262] ASoC: codecs: wcd937x: make stub functions inline
Date: Mon, 13 Oct 2025 16:46:13 +0200
Message-ID: <20251013144334.559927875@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

commit c4bb62eb594418a6bd05ff03bb9072ee1fef29c2 upstream.

For some reason we ended up with stub functions that are not inline,
this can result in build error if its included multiple places, as we will
be redefining the same function

Fixes: c99a515ff153 ("ASoC: codecs: wcd937x-sdw: add SoundWire driver")
Cc: Stable@vger.kernel.org
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20250909121954.225833-3-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wcd937x.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/soc/codecs/wcd937x.h
+++ b/sound/soc/codecs/wcd937x.h
@@ -548,21 +548,21 @@ int wcd937x_sdw_hw_params(struct wcd937x
 struct device *wcd937x_sdw_device_get(struct device_node *np);
 
 #else
-int wcd937x_sdw_free(struct wcd937x_sdw_priv *wcd,
+static inline int wcd937x_sdw_free(struct wcd937x_sdw_priv *wcd,
 		     struct snd_pcm_substream *substream,
 		     struct snd_soc_dai *dai)
 {
 	return -EOPNOTSUPP;
 }
 
-int wcd937x_sdw_set_sdw_stream(struct wcd937x_sdw_priv *wcd,
+static inline int wcd937x_sdw_set_sdw_stream(struct wcd937x_sdw_priv *wcd,
 			       struct snd_soc_dai *dai,
 			       void *stream, int direction)
 {
 	return -EOPNOTSUPP;
 }
 
-int wcd937x_sdw_hw_params(struct wcd937x_sdw_priv *wcd,
+static inline int wcd937x_sdw_hw_params(struct wcd937x_sdw_priv *wcd,
 			  struct snd_pcm_substream *substream,
 			  struct snd_pcm_hw_params *params,
 			  struct snd_soc_dai *dai)


