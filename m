Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618473;
	b=gmy6K8JPCif1MvK3+7OZo1A1dmKNRg/Xiek+etKm4AYaGqMamC9XtaNNfR7UxJtUMpQy
	 4vI38xF/22byS5Y0l186ZKYGzmDasOc5EMCKohB0kwEvzQqcQZbP4yVNwiryFuoz2u8Rz
	 n1ShuXyu90x6KNNuaZAPuitUo4+xCiJVa53V9sZmWr2yciJ/tN7W4vUCqrhJ6G012R467
	 ct2xfrKnfNwLn6AJRh/g9FmfdlJ9Tz5wut43estdTxmtPAxU+iMJBd7KujM0ZCnb7SAov
	 Ch0Ro/0LnCrGJX/gJSCkgo2IMYQtGtPPqa9CD6gEc1KFeL8NP2rRdYjlC9KLQael1qQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618473;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wo7ZamULx7v/aXW70PQ5E+u0lW60VH5N3l3yl8KetOQ=;
	b=VhE96Hg9aR4MbynnsLTyzktUFZS+ZHjj5LU+zmUuKTMY/jI2QuE3AJnH4nZM5xiNCLem
	 pQeJGK1xjsu1mVSM3230/Jz2d4o5MZ1XXwmdQqwFxH7At2XuTBRTcDLJDNUaAXoK4ITWy
	 StH12qAUgW8L9RPIvL0BRE3UFXvNjkwg1SZ+duYptejDYZ8swYrqt/xN5orMGAyTzF4XU
	 yd6B4dpGVkC2GJf426vKJIYB4XyN3qdubybqAXgFUpFopF9ZanaEOWTIKFMNqLH3Q3/wg
	 SpyMKEx+LcNA/YgkkdUTO4TPDrDvvS1nbLZaBr4lacrSRpdRjHLLH88528ieo1ATNwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kdVVaOjQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BC8606A32E;
	Wed, 25 Nov 2026 14:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kdVVaOjQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66611F000C4;
	Wed, 25 Nov 2026 14:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618473;
	bh=Wo7ZamULx7v/aXW70PQ5E+u0lW60VH5N3l3yl8KetOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kdVVaOjQsGL8eZwnhvx1lE5B4A+jXgbrGu8aT27N28d25jMeL5V0/Q9kn04mwhYJi
	 9Mbkpe+atUhyYg4Q9YIdCuIA0u88duo+Aj2Rd/c3udnKEdH9iCfjFEOY3rRfLk7iz+
	 pGpTZhdmDGbi5soCRBRXx/Llx+Xc8v7+PxKryVno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0290/1005] ASoC: wm_adsp: Prevent negative string length in wm_adsp_control_add()
Date: Wed, 25 Nov 2026 15:27:08 +0100
Message-ID: <20261125143828.531551100@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 4d07af76ca41cc1a03240cd3b5f44dc428856214 ]

Check that avail does not become < 1 in wm_adsp_control_add(). This
prevents overflows during subsequent operations.

The main aim is to trap a negative value in avail, but a zero length
would mean that the control ends up without a name, so 1 is the smallest
valid value.

Fixes: b7ede5af62ab6 ("ASoC: wm_adsp: Take prefix into account in control name length")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20261104133322.1085061-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm_adsp.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index b8f3035af3ba1..7740a9c8ced32 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -46,6 +46,9 @@
 #define adsp_dbg(_dsp, fmt, ...) \
 	dev_dbg(_dsp->cs_dsp.dev, "%s: " fmt, _dsp->cs_dsp.name, ##__VA_ARGS__)
 
+#define adsp_warn_once(_dsp, fmt, ...) \
+	dev_warn_once(_dsp->cs_dsp.dev, "%s: " fmt, _dsp->cs_dsp.name, ##__VA_ARGS__)
+
 #define compr_err(_obj, fmt, ...) \
 	adsp_err(_obj->dsp, "%s: " fmt, _obj->name ? _obj->name : "legacy", \
 		 ##__VA_ARGS__)
@@ -625,6 +628,13 @@ int wm_adsp_control_add(struct cs_dsp_coeff_ctl *cs_ctl)
 		if (dsp->component->name_prefix)
 			avail -= strlen(dsp->component->name_prefix) + 1;
 
+		if (avail < 1) {
+			adsp_warn_once(dsp,
+				       "%.*s: ALSA prefix too long: control not created\n",
+				       cs_ctl->subname_len, cs_ctl->subname);
+			return -EINVAL;
+		}
+
 		/* Truncate the subname from the start if it is too long */
 		if (cs_ctl->subname_len > avail)
 			skip = cs_ctl->subname_len - avail;
-- 
2.53.0



