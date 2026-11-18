Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029875;
	b=Ooiwd7FZ8RrrmlW222Eap93gJ7cWX0seINf4bxXxEwLtgHbwFZLsrt+Q4scwKgR04ozI
	 53VS1xbgYRf0IiLSeYqjCTEkjKSnZUXxh5IPgV2IkbmGrb4TSnB4lWHRH9sLgSz63rK6Y
	 SXKbBlnAqm4ltssrrpMM3g1A1hAtyx9M1Vbe24mKQAwalzzthu/AlOvGBERrLVjwu3Fyk
	 E1nDo5ip/vGPJftgCsNFqVJUaW0v2uBZeLV2t2r51p+GjRW9JLMHXMFE+etMa7YX7VpWh
	 nX88Fc4zattYXAOBk/AvkjvskdNFfACY4rPMRWjxYS4oFhAg6ycczSdFeHuNEAcMEsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029875;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rd5Pykze9tQJFxy6X1mUBM9P1heh5N0F/l7SFOcOR1w=;
	b=4OlddVuhHBSNKYjFAhlzfaeIZ5IKiF8lCOVX7HxPpXGhsfywn4ZgjCrkSTuH3aA52e/T
	 SIbdIm/3jEdeiro9f7AGmAztqRsbr/ky+lHs4zXMSv4Z+cX5Dq/nSHQqXu+jRfXyU5ciN
	 RJWed+j3asTgVt7nVTsY3xCGTyF2aP0FKcWgHDyz+FiZIXEONcALroS0ULyqSx2ckOS1k
	 XLF3Uw+3du7iiLc8GxAI6LobBKTn8BGlHS7SEye9h7MZi9+zlCBJCW3TsDCyS4g6NRDnY
	 iBNF2HK1PVI8A7lNYDs/t5OVC4+u+/9Fve3IiCX6v5T+Em+exnE9Ncjb4ZEN0ktjM1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YXNmBCts;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46375606A31C;
	Wed, 18 Nov 2026 19:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YXNmBCts
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7DB1F000C4;
	Wed, 18 Nov 2026 19:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029875;
	bh=rd5Pykze9tQJFxy6X1mUBM9P1heh5N0F/l7SFOcOR1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YXNmBCtsYEJXsPeilW3UK3xErs3qi5yJs9iGrE58Bch0y7+Db6fJ0hgRAv3p4CsIU
	 g7DQQxCVqyUptl0qWtMdHeKaR2e2leo7xRzuNgDAxp8speQUnniCTEIMm5FbGuMgh2
	 fa2aIR9S+HuiDnySABZNnyMKBTDrD0nccvWFYWag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0504/1756] ASoC: amd: acp3x-es83xx: Switch to use acpi_bus_get_primary_device()
Date: Wed, 18 Nov 2026 15:43:51 +0100
Message-ID: <20261118150029.131713883@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3dc41dae158cb..ca62761ea247d 100644
--- a/sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c
+++ b/sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c
@@ -424,7 +424,7 @@ static int acp3x_es83xx_probe(struct snd_soc_card *card)
 			return -ENXIO;
 		}
 
-		codec_dev = acpi_get_first_physical_node(adev);
+		codec_dev = acpi_bus_get_primary_device(adev);
 		acpi_dev_put(adev);
 		if (!codec_dev) {
 			dev_warn(dev, "Error cannot find codec device, will defer probe\n");
-- 
2.53.0



