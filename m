Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6817A1F5FA;
	Thu, 11 Apr 2024 10:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830137; cv=none; b=tICwDtga/5RpgrDueoeJnGcom4REyHparDJZmeLnnTUVdlVoClWn+qFRk+rix2Q3F3NTTn2yVggOiogMkBYyTyJHMd3shfm3oiZnzm8JdQl/43ikgYccMaNbuWxuCtyDqp1f/Eu3f/HZuDXzGBbeC4VSHj4A2ch4Fd1jx8T2amQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830137; c=relaxed/simple;
	bh=wMthF4Rksx5V0oHIyVOhqj6ZUsLIJQntiKDll4BJTn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GLXMRAqfaRwbl0iCrYJV9EUtLQYLLtF2zPx45NW0eh3SdSH52zwuIvOIn2RYElDlMVWsWb/VrY9U6PAtzYVbSePyeUeUwODV4+pQ+qR8AsLp4RK1qKkfFmdvBiQHI8hAO/Kor6jVeDj1ruoHkuXJr0JjpABaHc4WkHI899ozfoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IvFVrvhH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IvFVrvhH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E91C433C7;
	Thu, 11 Apr 2024 10:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830137;
	bh=wMthF4Rksx5V0oHIyVOhqj6ZUsLIJQntiKDll4BJTn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IvFVrvhHyVgNfMEx5H5iO7BK3RZG9pXJScqrkOodKkThJLHezql9S4tuppzbKtFr9
	 F3UY5OpeEcQWLQXHu/jiqoJeIBuGI3AgqpDsq9Ji7ghK4VNP95FOGkqhm7GBdkvjLU
	 AySX9dZnDNUBmy1VZrqTNNfl7f8uyB9pJkIVkqNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 046/143] wifi: iwlwifi: Add missing MODULE_FIRMWARE() for *.pnvm
Date: Thu, 11 Apr 2024 11:55:14 +0200
Message-ID: <20240411095422.302479529@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 4223675d2b5912060a85e48fd8fee51207e00957 ]

A few models require *.pnvm files while we don't declare them via
MODULE_FIRMWARE().  This resulted in the breakage of WiFi on the
system that relies on the information from modinfo (e.g. openSUSE
installer image).

This patch adds those missing MODULE_FIRMWARE() entries for *.pnvm
files.

type=feature
ticket=none

Link: https://bugzilla.opensuse.org/show_bug.cgi?id=1207553
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://msgid.link/20240228163837.4320-1-tiwai@suse.de
[move to appropriate files]
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/cfg/ax210.c | 6 ++++++
 drivers/net/wireless/intel/iwlwifi/cfg/bz.c    | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/ax210.c b/drivers/net/wireless/intel/iwlwifi/cfg/ax210.c
index 134635c70ce85..73cbb120a49b4 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/ax210.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/ax210.c
@@ -299,3 +299,9 @@ MODULE_FIRMWARE(IWL_MA_B_HR_B_FW_MODULE_FIRMWARE(IWL_AX210_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_MA_B_GF_A_FW_MODULE_FIRMWARE(IWL_AX210_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_MA_B_GF4_A_FW_MODULE_FIRMWARE(IWL_AX210_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_MA_B_MR_A_FW_MODULE_FIRMWARE(IWL_AX210_UCODE_API_MAX));
+
+MODULE_FIRMWARE("iwlwifi-so-a0-gf-a0.pnvm");
+MODULE_FIRMWARE("iwlwifi-so-a0-gf4-a0.pnvm");
+MODULE_FIRMWARE("iwlwifi-ty-a0-gf-a0.pnvm");
+MODULE_FIRMWARE("iwlwifi-ma-b0-gf-a0.pnvm");
+MODULE_FIRMWARE("iwlwifi-ma-b0-gf4-a0.pnvm");
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/bz.c b/drivers/net/wireless/intel/iwlwifi/cfg/bz.c
index 82da957adcf6e..1b6249561cd58 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/bz.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/bz.c
@@ -179,3 +179,5 @@ MODULE_FIRMWARE(IWL_BZ_A_FM_C_MODULE_FIRMWARE(IWL_BZ_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_BZ_A_FM4_B_MODULE_FIRMWARE(IWL_BZ_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_GL_B_FM_B_MODULE_FIRMWARE(IWL_BZ_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_GL_C_FM_C_MODULE_FIRMWARE(IWL_BZ_UCODE_API_MAX));
+
+MODULE_FIRMWARE("iwlwifi-gl-c0-fm-c0.pnvm");
-- 
2.43.0



