Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0B17482;
	Thu, 30 Jan 2025 14:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247469; cv=none; b=llwGgVv72CJ3MQ7a0jFWHQ+vg1rlT2BjOEAy7UkYZLGqcJNzF08kBoUBh5XWK3bdppFd/6HnrhLyjJqAU/ISEhD/ldKR79Ah1X2FAjDEO/G6VzKhcmNDfBlUWbgR0AkRkvGbIzvfpkvqSonVknK9UfNGNNZMx5p5YHwX+jZtfbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247469; c=relaxed/simple;
	bh=kFHxwBeD/gUN03BBMNysgpYvslun7ThVR+gX/OZTguM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lkl9gGiQjh+RmdNMW9Rpt3sSFHtI1kmnUSPevZ9lnlykvdfcxZN9LcNIDGUSizRadE23gW3THouHH6w/7nzGO7C8xiKkfAxF0ntGxVOkLXPPdMdnTRf0ZZAt9PGHN75A5UePZzJScVJycA2tPYRHbP4qcpoSLGsGcfVVxlP+r7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUeQXFlk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUeQXFlk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12FA8C4CED2;
	Thu, 30 Jan 2025 14:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247469;
	bh=kFHxwBeD/gUN03BBMNysgpYvslun7ThVR+gX/OZTguM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BUeQXFlkWbxZTmbvgpPEKPU3IZwjD1tuhhxKYbCx2+a83CEjU66A1pPG1jxOMyHf4
	 6sYIBz+unwCxQoTIIx/ojGh2i8s00+W6BddpR3qRjNZaWOiAgc8oT2HpSBKbm+kEax
	 Zuk7hvCYG2ge8t1AELZaOLyQUpPLg9oKytIiNs0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 49/49] ASoC: samsung: midas_wm1811: Fix Headphone Switch control creation
Date: Thu, 30 Jan 2025 15:02:25 +0100
Message-ID: <20250130140135.791584413@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.825446496@linuxfoundation.org>
References: <20250130140133.825446496@linuxfoundation.org>
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

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit 48c6253fefa38556e0c5c2942edd9181529407e4 upstream.

'Headphone Switch' control is already registered from
sound/soc/codecs/wm_hubs.c:479, so duplicating it in midas_wm1811
causes following probe failure:

midas-audio sound: control 2:0:0:Headphone Switch:0 is already present
midas-audio sound: ASoC: Failed to add Headphone Switch: -16
midas-audio sound: Failed to register card: -16
midas-audio: probe of sound failed with error -16

Fix this by dropping duplicated control.

Fixes: d27224a45e54 ("ASoC: samsung: midas_wm1811: Map missing jack kcontrols")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20230809100446.2105825-1-m.szyprowski@samsung.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/samsung/midas_wm1811.c |    1 -
 1 file changed, 1 deletion(-)

--- a/sound/soc/samsung/midas_wm1811.c
+++ b/sound/soc/samsung/midas_wm1811.c
@@ -257,7 +257,6 @@ static const struct snd_kcontrol_new mid
 	SOC_DAPM_PIN_SWITCH("Main Mic"),
 	SOC_DAPM_PIN_SWITCH("Sub Mic"),
 	SOC_DAPM_PIN_SWITCH("Headset Mic"),
-	SOC_DAPM_PIN_SWITCH("Headphone"),
 
 	SOC_DAPM_PIN_SWITCH("FM In"),
 };


