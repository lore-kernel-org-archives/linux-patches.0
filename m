Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B819D1714A8;
	Thu, 15 Aug 2024 13:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729143; cv=none; b=Fexrtoecfa4TtqDbb4kwqsruYg5ud8me7JTnh+Az4NWpKOx8hnMFfNtKVHh9a+tkk++TRu8/DPg2gAFqFnDl+5pHspalnvpZQgSvitwL6ZlbAcWlFtLnlhlFTssHEZSR1nszaaRyfkrvrBiz2Sfi5eXSQNzvrhU1MGjoMii5Q6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729143; c=relaxed/simple;
	bh=+G6SbJk5FIAEB4UvJvD0/c0XjyRR/HlyXbQTJS0bWyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zoio8oWBcu8J3unjCe9NlqKdGzxvrgMZ3AQo74+wmW0oc7RTTetGFsC364v9DRTvugorkvFYwAG7g98xEcLN8TmjUwOvoxAYj9yXI8QN6PxwJc/y2jnKDHY8WFXelRTbGS38xoW8XUkarjjVAorKxqobhZXUZKj0w9kqzcvddUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oc6886g/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oc6886g/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD53C32786;
	Thu, 15 Aug 2024 13:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729143;
	bh=+G6SbJk5FIAEB4UvJvD0/c0XjyRR/HlyXbQTJS0bWyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oc6886g/2ywQRkjXr6RfLjFYbPlTEzJl4XQVfAOoR4OId0T1VyMjJQb2F99Wjpgkp
	 pVTc6vxJsHA150KF1R0uOwG7ARYp0VXgVxAkUpKCGvg+CLPKf2EdI0B6pKFw9hMsTE
	 ND/skCk4C4eI6vOW3uvMfvu4GAVxukIcz55cv9NI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Richard Fitzgerald <rf@opensource.cirrus.com>
Subject: [PATCH 6.10 07/22] ASoC: cs35l56: Patch CS35L56_IRQ1_MASK_18 to the default value
Date: Thu, 15 Aug 2024 15:25:15 +0200
Message-ID: <20240815131831.546833993@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131831.265729493@linuxfoundation.org>
References: <20240815131831.265729493@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Trimmer <simont@opensource.cirrus.com>

commit 72776774b55bb59b7b1b09117e915a5030110304 upstream.

Device tuning files made with early revision tooling may contain
configuration that can unmask IRQ signals that are owned by the host.

Adding a safe default to the regmap patch ensures that the hardware
matches the driver expectations.

Signed-off-by: Simon Trimmer <simont@opensource.cirrus.com>
Link: https://patch.msgid.link/20240807142648.46932-1-simont@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/cs35l56-shared.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/codecs/cs35l56-shared.c
+++ b/sound/soc/codecs/cs35l56-shared.c
@@ -36,6 +36,7 @@ static const struct reg_sequence cs35l56
 	{ CS35L56_SWIRE_DP3_CH2_INPUT,		0x00000019 },
 	{ CS35L56_SWIRE_DP3_CH3_INPUT,		0x00000029 },
 	{ CS35L56_SWIRE_DP3_CH4_INPUT,		0x00000028 },
+	{ CS35L56_IRQ1_MASK_18,			0x1f7df0ff },
 
 	/* These are not reset by a soft-reset, so patch to defaults. */
 	{ CS35L56_MAIN_RENDER_USER_MUTE,	0x00000000 },


