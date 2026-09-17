Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D29E50B43C;
	Thu, 17 Sep 2026 16:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664017; cv=none; b=eFovsyl3fwiwRcuDjWsq2lvfSUN+aeKgXKQiHA6oCw+1Wewub5iw5Vh2GUO96/TpiWg4mXSQR0362g4KDvCcuNgf0XN/mMUqtmvccAPkLAIbGsLHyTnabznU70HDC7l9nwAzaDtl9oeLFDqKQUhfyk7GUJRz/4uG3QR0AEZt0mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664017; c=relaxed/simple;
	bh=nqF9kAoijXtmT4QqUpVgO8A0OMOnJPdcUZyRjVbx6+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7LdEm+/oT0GopVdTLRE9JumHv+9ptKbuYK7cWSJRYMqhZd6IlMySjkp/KlWeKUrFqryFfTdpxNaKu1a+aZJhOfEf8JASXm5PYw4eJfk/8kiagY+WiBadufciMFRR+O6zcZG6dUPjcLX5/VEJAM+yTJaLMk2GBTvX0rXrDPhdrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lz1aT4UR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lz1aT4UR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73D01F000FF;
	Thu, 17 Sep 2026 16:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664016;
	bh=m0AJQ760DbH7xBbJ92BdPKa9qPQogBeyWYdllxNqDBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lz1aT4URcPWryU0PEYLkBiBcGXiZGSeIUpd8VCyh4lYXIQ7pHXo1mdOMBrVXo+osK
	 ox8K1I7bVaCSglyzDnUuAg0IyP/cE93Hjbwhi7KLxQSBscBfyxfhpKqqhieU4Lhgrz
	 jSeadg7eTHq/Tyn/3xPUHpLrf1QBAcv2simYLrRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johny Lin <johnylin@google.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0231/1250] ALSA: hda: cs35l41: imply SERIAL_MULTI_INSTANTIATE
Date: Thu, 17 Sep 2026 16:00:26 +0100
Message-ID: <20260917151558.404346263@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johny Lin <johnylin@google.com>

[ Upstream commit 72d8bf668954678bfae8f7296b4b1c01990bcdc2 ]

Use a weak reverse selection to suggest the config
SERIAL_MULTI_INSTANTIATE just like cs35l56 did.

Signed-off-by: Johny Lin <johnylin@google.com>
Link: https://patch.msgid.link/20260527023350.3067547-1-johnylin@google.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/side-codecs/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/hda/codecs/side-codecs/Kconfig b/sound/hda/codecs/side-codecs/Kconfig
index cbf1847896bc9..96c7e39b0715c 100644
--- a/sound/hda/codecs/side-codecs/Kconfig
+++ b/sound/hda/codecs/side-codecs/Kconfig
@@ -27,6 +27,7 @@ config SND_HDA_SCODEC_CS35L41_I2C
 	depends on ACPI
 	depends on EFI
 	depends on SND_SOC
+	imply SERIAL_MULTI_INSTANTIATE
 	select SND_SOC_CS35L41_LIB
 	select SND_HDA_SCODEC_CS35L41
 	select SND_SOC_CS_AMP_LIB
@@ -43,6 +44,7 @@ config SND_HDA_SCODEC_CS35L41_SPI
 	depends on ACPI
 	depends on EFI
 	depends on SND_SOC
+	imply SERIAL_MULTI_INSTANTIATE
 	select SND_SOC_CS35L41_LIB
 	select SND_HDA_SCODEC_CS35L41
 	select SND_SOC_CS_AMP_LIB
-- 
2.53.0



