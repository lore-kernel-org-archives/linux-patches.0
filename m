Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621702;
	b=sBvZ3jWs+qH9UP92h5vt4ruGPg7pY8DFCH+GmAJTPXAUQz3BgvXyxw/jG2V76F4oKiUR
	 msLlxNT3qIbWcmCr+rkgqAHEehB4rOwu8zF1PStLGFadvE6geGEAN6uEPz7JqnfmYHAye
	 fYhjRgvzCAiMif0RO3PW8c1eR78/CpS4sIgYvUqRX9ZCaqB4K/rp1DD8rxZ9j3i4XUoQa
	 IObA0KFXASXMolvHY52PH8kEqCn/mw7gE72l1nqHMhjc/X9YRZ9c8tbA+TKDrRzEWa51M
	 QqLVzFKCf/BdkVw2aTpQwxH5pUd1EIUkDc51mMy2gV1BNSKpYp6KpHrKx2VYyvHvVqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621702;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AXhk7X2+MgpUzAFHKFvPhjKlgQlEBkc86eSQWLzoN+I=;
	b=nVTv+sk+A1Z85NCFxltkkXUDRFstYumJiMiv6EZXrh+S+lXmgYKBxz6z3vZd0l5UDwIQ
	 UlLdp1kG8GXZwtxiE9V+ClNvL4Z4ardGel4gY/1KdowYSVa/+rKpoqA6rFwoNjEiLK1r2
	 hfOJIlIZ9P98t/2/1Im8eqoymSOY4lq2fkwfnwECo88lZyZszrCw6FpW6Hff+1M6QN0Py
	 lEkQ55qSOaq2IqziF3khwu+Dq1wI0jfjfWQ2uVmbcJmDMVndk3sSrZHGnixkCEDHaKDc9
	 I+33Cdb8hnvG1TuR2QZ+3VuStr/NH9z0rmXEdyTqq2XdK7ryVGBAi6MwNxjz3713Ekg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=alZ6wIxK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1791E606A32C;
	Wed, 25 Nov 2026 15:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=alZ6wIxK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6887A1F000C4;
	Wed, 25 Nov 2026 15:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621701;
	bh=AXhk7X2+MgpUzAFHKFvPhjKlgQlEBkc86eSQWLzoN+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=alZ6wIxK9mwfmpDzw2DL+1JDlm+EhuYyDChytbInkfQudMFdLNzRXJ+fxkVMwrnIM
	 m+G5kWpkSnmvjCWKQTl5byUC4fLQCsSY3sU53UmLauS4o5K/XumIF1WqPQ9EZxAOKF
	 HeRG4npQibJCl2w66xk17PQboUakIIR8SeNXhKrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 264/990] ASoC: wm_adsp: Prevent negative string length in wm_adsp_control_add()
Date: Wed, 25 Nov 2026 15:27:11 +0100
Message-ID: <20261125143828.277830546@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index 751a3c25e4f0b..7c1c2ba7a0f6f 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -44,6 +44,9 @@
 #define adsp_dbg(_dsp, fmt, ...) \
 	dev_dbg(_dsp->cs_dsp.dev, "%s: " fmt, _dsp->cs_dsp.name, ##__VA_ARGS__)
 
+#define adsp_warn_once(_dsp, fmt, ...) \
+	dev_warn_once(_dsp->cs_dsp.dev, "%s: " fmt, _dsp->cs_dsp.name, ##__VA_ARGS__)
+
 #define compr_err(_obj, fmt, ...) \
 	adsp_err(_obj->dsp, "%s: " fmt, _obj->name ? _obj->name : "legacy", \
 		 ##__VA_ARGS__)
@@ -619,6 +622,13 @@ int wm_adsp_control_add(struct cs_dsp_coeff_ctl *cs_ctl)
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



