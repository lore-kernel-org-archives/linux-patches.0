Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7796F9EB;
	Sat,  3 Feb 2024 04:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933611; cv=none; b=lgxkg3hOtHCy0EsgxJgsdi6AzxnKY5SvxHFbatpFBCnXeM0g6ifjs7BWnpQfYjuuDgsvuPYiMjO4mhWITInRT0JVhLANAtCaP5pfZxiFQZBb1crkjldRpI+UmFHmwqavQyU1Jue3oIlMcoZLScyJe9UyLLkv+sQ5m8e12oM8NnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933611; c=relaxed/simple;
	bh=Oa6oNOu5A1rSgHFSO0us7FdsDM54qcR3U/3uyeKEf8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=INIbMCyrahSaHl8ThG7VMbNMpaniAZgs2uz6jYOLyhQp7d6UCZ1eYzlRqSlQHVLstc7hsSTcRIxG6+Pvskw/0V1DWiNijRHKKGaMtc7eOv4sRJlKFehnvWEUynrxPmGs7iqV/wSe+LCLqvwTvQKJuzvrbmj3eh+juC65t19yV1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rDFWFaF/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rDFWFaF/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB52C43394;
	Sat,  3 Feb 2024 04:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933611;
	bh=Oa6oNOu5A1rSgHFSO0us7FdsDM54qcR3U/3uyeKEf8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rDFWFaF/X1k5u5Ame8mQCdi94ReUp5v7xs5a5rXczxvvVN+89/+g6CTqu0b0qB/fy
	 luKS+5m65xq1PrmrcqmPH1AGRqB5Zait7UlvBpMxT0i4r8AsDCB7dBqcOd7DiCqtUA
	 0AUngAGR/f1ooJoh4Xzf/BEZ/ocMnCyYzzTN28hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 159/322] ASoC: doc: Fix undefined SND_SOC_DAPM_NOPM argument
Date: Fri,  2 Feb 2024 20:04:16 -0800
Message-ID: <20240203035404.360244078@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 67c7666fe808c3a7af3cc6f9d0a3dd3acfd26115 ]

The virtual widget example makes use of an undefined SND_SOC_DAPM_NOPM
argument passed to SND_SOC_DAPM_MIXER().  Replace with the correct
SND_SOC_NOPM definition.

Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://lore.kernel.org/r/20231121120751.77355-1-cristian.ciocaltea@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/sound/soc/dapm.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/sound/soc/dapm.rst b/Documentation/sound/soc/dapm.rst
index 8e44107933ab..c3154ce6e1b2 100644
--- a/Documentation/sound/soc/dapm.rst
+++ b/Documentation/sound/soc/dapm.rst
@@ -234,7 +234,7 @@ corresponding soft power control. In this case it is necessary to create
 a virtual widget - a widget with no control bits e.g.
 ::
 
-  SND_SOC_DAPM_MIXER("AC97 Mixer", SND_SOC_DAPM_NOPM, 0, 0, NULL, 0),
+  SND_SOC_DAPM_MIXER("AC97 Mixer", SND_SOC_NOPM, 0, 0, NULL, 0),
 
 This can be used to merge to signal paths together in software.
 
-- 
2.43.0



