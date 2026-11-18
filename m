Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026949;
	b=Vs1IdZxvI9hTyv4RloTHiv0RY0gnnRci51esaNgJQ91nuQrxVCz48ccvlxFP5e/BIejE
	 y58sVZIIZ4pkJWBFx4J0UPUNWWDvI5Z71/1T+LYAsOOYayz/fS/bAUOuW19xdMqmYiT2+
	 8wHKG2rLRB9qMKXr71DfoMJ5wuVaMFP3179/K3VmFjJsf2TYDOnCUuVM7UYRjatm67yFi
	 y1D+Ie3p3f0YzModjQQeZSQmSwkg/hs+LymxyNCMHIb/2rtHnZ1szGGIHBUjiBeiruPgV
	 GtwpPTIGiujfrdJpsxVs1Fif3Ii5Wd9iMfsTalp8Ncl6AaJk6gXP7fqSSlgZmaULAqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026949;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EDRRwVudgVTVysxnG30/0mpQv7QNZVCDWj20F4M5cqQ=;
	b=UW3QuL7A/cOgbGMqgcLbZz/CzCRLfwQ18jY4oUnLjXtuyBceZMLVIL/1r+PcU/o3AcFi
	 D3gO9mrd1N7YuePWLvHrYbS/v0rUBOBatftyyNI55+FDdiAPdf+L8zkXmePkaEH5a/zRr
	 qmi7+nILyCVltUetyhUKedY4N6E7U5kmOKuSnfRSxgbDgVlYYLiUQlKTbYg8rCW9deb3X
	 6GSkmIpWXu89UTFR6qB3LnCDwd+sop6gDw/g6JWQPWPgeb4cnivzUVyQ0m4ggLiAPzvS0
	 cbLRha7OkfOzLXHqO80BAWOKxVB/mUSmdEGK3PKZq1WzuAIqoc9wCRJsDlVpCT+7UnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BnvoDU1W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A38606A333;
	Wed, 18 Nov 2026 18:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BnvoDU1W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6588F1F000C4;
	Wed, 18 Nov 2026 18:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026948;
	bh=EDRRwVudgVTVysxnG30/0mpQv7QNZVCDWj20F4M5cqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BnvoDU1W5QOUzRVPuw/drHfeeoRhrrdb6E+HLSV6XRkbmqEFQYWzyRo2VeCsnRy/3
	 5HckyHNJTRdhUBMnvnlDGUrR6NPgB8JMKViftsK31B5mciJl4rlEfkQRFkQwMHOZXR
	 r5UbDsJrtJ//I/oCfKnaJlJgy4I2BJHDdsXSOrJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1617/2151] ASoC: Intel: avs: Prevent module info underflow
Date: Wed, 18 Nov 2026 15:55:52 +0100
Message-ID: <20261118150220.782966801@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 05c2975b4267246219e7aead0467626107e204e9 ]

Typically modules information is first initialized when loading the base
AudioDSP base firmware and then expanded when loadable DSP modules are
requested by platform-components, see avs_component_load_libraries().

While theoretically not possible in a production scenario, there is no
reason to continue the IDAs preparation if an event caused the newly
obtained module information to be smaller or equal than the existing
information.

Fixes: c1a427e8da93 ("ASoC: Intel: avs: Firmware resources management utilities")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20261015190240.729793-4-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/utils.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/avs/utils.c b/sound/soc/intel/avs/utils.c
index 81f9b67d8e293..05d7142a49246 100644
--- a/sound/soc/intel/avs/utils.c
+++ b/sound/soc/intel/avs/utils.c
@@ -118,9 +118,11 @@ avs_module_ida_alloc(struct avs_dev *adev, struct avs_mods_info *newinfo, bool p
 	int i;
 
 	if (!purge && oldinfo) {
-		if (oldinfo->count >= newinfo->count)
-			dev_warn(adev->dev, "refreshing %d modules info with %d\n",
+		if (oldinfo->count >= newinfo->count) {
+			dev_warn(adev->dev, "modules info underflow, old: %d, new: %d\n",
 				 oldinfo->count, newinfo->count);
+			return -EPROTO;
+		}
 		tocopy_count = oldinfo->count;
 	}
 
-- 
2.53.0



