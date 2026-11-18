Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016840;
	b=I7DaEZtKVgAc3vbeCSF3PtdEKatRTF9y5FvfWz6I1ZSOhaB7Lzcmgh4aAZilkl1TAZWu
	 Vlex63pkhaVnJfTVY0lkwJYMgWO+B2Ko9G0hIrzm9bTAYPmdu+PvNeEe8I2ziExsJtLVZ
	 KCJ+k69ym133lTrLRsIsdZAjB1fmopSoDV3kBKTnSpaDMrVXlcZjEFMM+ImyREZYq7P4h
	 WHqqNFTy5RCoKYN8zm8GueHXH5GSgLs/6RHJ6CVBNEnNHb1lcTRazbYtwEffcP8cx6LiQ
	 usy/iyoKpAt+oRz/E1JLbJA88lRvp6pn8RZjWmRvXJUzp/1BkfBec8xXJVzdXIjluhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016840;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=67DHtvsCSi7D5Qqv8LXnydU1eaqPTGihITbNkvVvDVk=;
	b=JLi9vAlkzUbmGpJQPWiqvz6L4d2/R6JPUt7WB3SXOlmTW1+e7OiQH3CgdcibHyJBw4OR
	 hsSiLxuafP3w7B4/QRpoyL2X/PSqqd3xvxjLczF1IyWa5jI15pkCNbID7WQCzFc1B78uz
	 jwkLc65pnviJ+cj0nDLl6gd575XzMnqICllfPg5leP/LFDKaNrCy4Yzg0lpeOyas/jfib
	 /nTD9EdETPZBV0tvti6hAhQOCj5R2T0O3JWO7Y908uYrQcFSQF0A7duhCCXaJqsgzRtMC
	 au1ZxCEa0V9bT0elpIoKF5jZuZBX7kEkiA0CoyMxQpvayHW9v2R3+wWTsmHAHxyp/Nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eNbPJwBo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09E5606A32A;
	Wed, 18 Nov 2026 15:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eNbPJwBo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396C41F000C4;
	Wed, 18 Nov 2026 15:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016839;
	bh=67DHtvsCSi7D5Qqv8LXnydU1eaqPTGihITbNkvVvDVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eNbPJwBoP3AtfJA1jd2M3sg7avF9Dc0oLX8NZjLs2/XFWRJCOWrYADLWMpwxjvfh3
	 EdmzckgQSzy3NcuvJYtPC/tlMWzPZtZuHdYsCrA9jxQWexPqQWcose8CnePhMdOKG4
	 N2EZkMcBDdh/dSLKYvYqq3Ypn1x8qtZ8a+LAlGag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0671/2651] ASoC: amd: acp3x-es83xx: Switch to use acpi_bus_get_primary_device()
Date: Wed, 18 Nov 2026 15:31:51 +0100
Message-ID: <20261118150312.028273023@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit aae5bd00ced5b7e42ef3b3aa46923ad72388c60b ]

Replace acpi_get_first_physical_node() that is slated for removal
with acpi_bus_get_primary_device() that takes a reference to the
device it is about to return.

This addresses a potential use-after-free that may occur if the
device returned by acpi_get_first_physical_node() is removed right
after dropping its ACPI companion's physical_node_lock in that
function.

It also fixes a device reference counting issue that may lead to a
premature device release if devm_kzalloc() fails in acp3x_es83xx_probe().

Fixes: 54fcd9dd44b2 ("ASoC: amd: acp: Add machine driver that enables sound for systems with a ES8336 codec")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Mark Brown <broonie@kernel.org>
Link: https://patch.msgid.link/2310746.NgBsaNRSFp@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c b/sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c
index 3a640e6523142..c522b421e1ec2 100644
--- a/sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c
+++ b/sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c
@@ -428,7 +428,7 @@ static int acp3x_es83xx_probe(struct snd_soc_card *card)
 			return -ENXIO;
 		}
 
-		codec_dev = acpi_get_first_physical_node(adev);
+		codec_dev = acpi_bus_get_primary_device(adev);
 		acpi_dev_put(adev);
 		if (!codec_dev) {
 			dev_warn(dev, "Error cannot find codec device, will defer probe\n");
-- 
2.53.0



