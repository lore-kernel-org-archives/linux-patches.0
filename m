Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8858E280A3A;
	Wed, 23 Apr 2025 15:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421123; cv=none; b=cJEm43pZQQR0uWEaUDvvtX49+v1UNBiv6i+7ngsSzfaECL8ip09+44+xxKS+asrrILgz2qc9yY1iWZ6HmX/qZ4zFSFgjrc5Opeji4rjef6sovle16Txyo3wzDN2RfjKRLFVQUiOVaPmp4IPKDoN1f/DHfikwHrqA6WyZ5gVSjWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421123; c=relaxed/simple;
	bh=5Piml+A30KTBNVYyDTmCa6Vl/3YEiKnXfihmDbLTWM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fo5O5GbySFfGd0Q3EhJrUlpXAtvVnSAPNJH8hfwifs4CAwREk+2cD9oqlE7ET8vvu083RpZ6gEOClv7HjO8fbjZy5cJfQIqmOYYVTdHXqtlUYgFIvlFUZrwekFSW7Aa2vIh1t/lEVm0SD6vuEfi4Iqfo0g1Ab/yhgIk71pvQD84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HwBY/DSt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HwBY/DSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A38C4CEE3;
	Wed, 23 Apr 2025 15:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421123;
	bh=5Piml+A30KTBNVYyDTmCa6Vl/3YEiKnXfihmDbLTWM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HwBY/DStfPhWzh6izamqOcR2YzLPwlFDbktc4XpLjTu1f1+RV58wMsvvu1/6/zcKQ
	 kupqwCqZVb9WXWR1Vccx5Th4pvm607WIabt+0D3RfmZZUb8xSeo6OStKmqAOBMK3fu
	 fryP/tQ98Cs42ZMPd7G+AC2DdjQxOl7kMOvW8/kY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 110/291] ASoC: qdsp6: q6apm-dai: fix capture pipeline overruns.
Date: Wed, 23 Apr 2025 16:41:39 +0200
Message-ID: <20250423142628.870921750@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

commit 5d01ed9b9939b4c726be74db291a982bc984c584 upstream.

Period sizes less than 6k for capture path triggers overruns in the
dsp capture pipeline.

Change the period size and number of periods to value which DSP is happy with.

Fixes: 9b4fe0f1cd79 ("ASoC: qdsp6: audioreach: add q6apm-dai support")
Cc: stable@vger.kernel.org
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Tested-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://patch.msgid.link/20250314174800.10142-6-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/q6apm-dai.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/qcom/qdsp6/q6apm-dai.c
+++ b/sound/soc/qcom/qdsp6/q6apm-dai.c
@@ -24,8 +24,8 @@
 #define PLAYBACK_MIN_PERIOD_SIZE	128
 #define CAPTURE_MIN_NUM_PERIODS		2
 #define CAPTURE_MAX_NUM_PERIODS		8
-#define CAPTURE_MAX_PERIOD_SIZE		4096
-#define CAPTURE_MIN_PERIOD_SIZE		320
+#define CAPTURE_MAX_PERIOD_SIZE		65536
+#define CAPTURE_MIN_PERIOD_SIZE		6144
 #define BUFFER_BYTES_MAX (PLAYBACK_MAX_NUM_PERIODS * PLAYBACK_MAX_PERIOD_SIZE)
 #define BUFFER_BYTES_MIN (PLAYBACK_MIN_NUM_PERIODS * PLAYBACK_MIN_PERIOD_SIZE)
 #define SID_MASK_DEFAULT	0xF


