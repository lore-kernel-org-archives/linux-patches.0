Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0033FDC06;
	Tue, 21 Jul 2026 16:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649770; cv=none; b=XXDhZ7yDV+uAbaNo370qsRVNIxO8D86anAB7q1FwXi4Yo3NXpXPgt45JA19VfBuXBS9Py445fhggYaJBLHdRaG15xfY3/gR/rOMtlq3VxTG99HOW0Wo7M7dqeU3GZE2bjbFNhcjS8gX5ojkVbiH3JwCO1Ygs1zpzIF9o/skhlb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649770; c=relaxed/simple;
	bh=0rQWCSPJNwwdzaUj3Tdb0zuyFBe3NR9j1+gME78bOrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iHfQJJDp58ypsCJR9HFxnvl6W47NiB5SKbodIbuwFcjoGjlnVpJBWtiw//Unn3AA2y2U3h6iATHlvAQUc5dm35J6eccC8zo5NMN1ahM/uif6qlxQ1XZa6wyg/T0mn0UZfedg39WTBZd1dQU6Lr1sJWR35HoDCqhN6XlYUD24uUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Z3nDlvX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Z3nDlvX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38E11F000E9;
	Tue, 21 Jul 2026 16:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649769;
	bh=bdh3PisF4xKHO+KuOFx+waJCD2IHNOt1lBtUgoMmay0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Z3nDlvXZ3B2CY6fVEQKvAAbPQ+E5Ho98DPcggZRPhSwUYvnU3JdxmvB7MZ9sZ3Wo
	 jdbWvNsg53L8/LYxCnTqAaYaJVdt1tXZFvwLWF+NlpUxb6jMc+/8okJEXEYcx+2MF9
	 wET3saWQUKFU46+Jj5Jhm4Ih68oRY2GvgwNPqNnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Julian Braha <julianbraha@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0701/2077] ASoC: SOF: Intel: select SND_SOC_SDW_UTILS=y from SND_SOC_SOF_HDA_GENERIC=y
Date: Tue, 21 Jul 2026 17:06:14 +0200
Message-ID: <20260721152609.328382694@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 67805f57e5b1a8589f89bd48936c65cbbaeec300 ]

When SND_SOC_SOF_HDA_GENERIC=y but SND_SOC_SOF_INTEL_SOUNDWIRE=m, the
SND_SOC_SDW_UTILS is also set to =m even though there is a direct link
dependency from the hda.c:

aarch64-linux-ld: sound/soc/sof/intel/hda.o: in function `hda_machine_select':
hda.c:(.text+0x21ac): undefined reference to `codec_info_list'
hda.c:(.text+0x241c): undefined reference to `asoc_sdw_get_dai_type'
hda.c:(.text+0x25b4): undefined reference to `asoc_sdw_get_codec_info_list_count'
hda.c:(.text+0x25d8): undefined reference to `asoc_sdw_get_codec_info_list_count'

Change this the same way as the other related 'select' statements
to allow linking against it.

Fixes: 2b4d53eb5cf3 ("ASoC: SOF: Intel: select SND_SOC_SDW_UTILS in SND_SOC_SOF_HDA_GENERIC")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Tested-by: Julian Braha <julianbraha@gmail.com>
Link: https://patch.msgid.link/20260611132310.137688-1-arnd@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/intel/Kconfig b/sound/soc/sof/intel/Kconfig
index e31f4c4061d80e..9ddf14e7946aab 100644
--- a/sound/soc/sof/intel/Kconfig
+++ b/sound/soc/sof/intel/Kconfig
@@ -329,7 +329,7 @@ config SND_SOC_SOF_HDA_GENERIC
 	select SND_INTEL_DSP_CONFIG
 	select SND_SOC_SOF_HDA_LINK_BASELINE
 	select SND_SOC_SOF_HDA_PROBES
-	select SND_SOC_SDW_UTILS if SND_SOC_SOF_INTEL_SOUNDWIRE
+	select SND_SOC_SDW_UTILS if SND_SOC_SOF_INTEL_SOUNDWIRE !=n
 	select SND_SOC_SOF_HDA_MLINK if SND_SOC_SOF_HDA_LINK
 	help
 	  This option is not user-selectable but automagically handled by
-- 
2.53.0



