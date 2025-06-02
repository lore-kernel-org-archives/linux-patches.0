Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F4F1ACEAF;
	Mon,  2 Jun 2025 14:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874040; cv=none; b=dGHuh9I8bhi82jmS8RrJ+zjF584ewwAgt4O69/59l0yl7PH7GS655Q7B4MXu2HHJcWuCB9Tj/NE+QaFqEy25i6oiMVBgjdBn8kOK0s/RZhsGOdKzkm/bSIJsqmRvyBjm8I1S56cKzl74ZNB2S+O0f2bZouSnZCYH/XwxnMR8vcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874040; c=relaxed/simple;
	bh=D+IlwVwPeozDg76rCC7Oz7BDDUsfzllc9Gg1S+uBb1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/PsgQ+axcMkmVzDCBdJIjYcOj7xfQdANMFkCcRiBZXNYQI6ec11Lg1P4JFitLzCFxjZUbXZI1vursE9N2JE1T5Sc96/lluYGexSmJX8m+8g/ljc2MnbwAAo2e19IR/ZbchIzgkrKinwypw+2SVRs6TekVSUntnjNQqQLhrCQZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U84FPuC+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U84FPuC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30E7C4CEEB;
	Mon,  2 Jun 2025 14:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874040;
	bh=D+IlwVwPeozDg76rCC7Oz7BDDUsfzllc9Gg1S+uBb1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U84FPuC+nMlNj/77JXN3UJuPHsmumrlb2u4RMG8P8w7GgXpj5gx1IyUU34jBhhrht
	 DsR9OlqCJ0+rEv8fOgg+zbiPpamddFmHYAIxSoKftGZz/Gv+Lqh9ZiHx3QtunUpeFz
	 XsDazwAXODv4fpvAEF+0YoN+2GCO080o0+KvNnYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 308/444] drm: bridge: adv7511: fill stream capabilities
Date: Mon,  2 Jun 2025 15:46:12 +0200
Message-ID: <20250602134353.433267397@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olivier Moysan <olivier.moysan@foss.st.com>

[ Upstream commit c852646f12d4cd5b4f19eeec2976c5d98c0382f8 ]

Set no_i2s_capture and no_spdif_capture flags in hdmi_codec_pdata structure
to report that the ADV7511 HDMI bridge does not support i2s or spdif audio
capture.

Signed-off-by: Olivier Moysan <olivier.moysan@foss.st.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20250108170356.413063-2-olivier.moysan@foss.st.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/adv7511/adv7511_audio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c b/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c
index 8f786592143b6..24e1e11acf697 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c
@@ -244,7 +244,9 @@ static const struct hdmi_codec_pdata codec_data = {
 	.ops = &adv7511_codec_ops,
 	.max_i2s_channels = 2,
 	.i2s = 1,
+	.no_i2s_capture = 1,
 	.spdif = 1,
+	.no_spdif_capture = 1,
 };
 
 int adv7511_audio_init(struct device *dev, struct adv7511 *adv7511)
-- 
2.39.5



