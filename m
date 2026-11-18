Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024224;
	b=Qgm3rvmX1WdGToO8yw1x/8HRxzQxtso3NFQ563Jn4e2c/PM8B7yzfZ4NVDwcty2TbNJW
	 BVN/aQMqRydrY2dvFlkfnyTa09Ha0xo3iV5s47FnIoFLe0W1qwuZGb6YXANx2UF+EycAM
	 zXmnohup4BG+Y40MPblGTxT0/dkaTicDVyxXKoqB6N+zw0eXzA/rq8g7TJtOxg7+aYjak
	 LIi07sJdQ339FxGizYQguCQlqKgg07WO0pij48UsQgpVLqAfZfpVR1xK3sFCyjzBSXBWY
	 XD0EPHk64PdeJgeEdRcxrBUhnQKSLteLqonb/2OSc+A4MPVzfvG0LXEAH/kCIN0DW0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B4P37iyHa68qGh/btM9ycQelTzGKC/a/LZBpA8i2RxA=;
	b=oybyALgQiVi/E57mSbCIjvHH1oCLnC1PTJBnkx94uOQbDje3dXpYaHpIWMA1OZ6QHO+3
	 wncULGJWtGCRk+sznpoGL/U65PYro5HQ2mWFupXe/Y1LMnm6gqqtxmFOymZ0h4ZU4BHK+
	 yrnNpn8HGOpWWHnoGnIQ60tGpi/LNmPoV65/ihOr11tP5WyklWEYwDJUxrP+gilLiie5C
	 WpNDWd/AtzYQhJMUtSmqC6W9MPcS5EaZMneKkOaBgs3xmy2OIPoBqO4AMwAjpcLmqCGGO
	 t/lMFOc8V615woJuAdUnIs0DggBCZUNR/nDK+GixPI91HYDKR/7H4FO72/Pl3q/N6Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1p+2YVW7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36658606A325;
	Wed, 18 Nov 2026 17:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1p+2YVW7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F0CA1F000C5;
	Wed, 18 Nov 2026 17:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024224;
	bh=B4P37iyHa68qGh/btM9ycQelTzGKC/a/LZBpA8i2RxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1p+2YVW76Gpn+oLmB2LqsFw6t/UTQGW040T1JGAJml4IAoSEk7HtEAGoGiC7yx9at
	 mPEhXx59ChrJs8HhoZOtCn9sEhdjQ/4Y84OsDdGsAmvI7gd9TivObTRFyxoweqNca1
	 WfcVVf3kxRuSGB60XCEeSowq2RCenWA3ZPYvnvPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0608/2151] ASoC: amd: acp3x-es83xx: Switch to use acpi_bus_get_primary_device()
Date: Wed, 18 Nov 2026 15:39:03 +0100
Message-ID: <20261118150144.083880908@linuxfoundation.org>
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
index b18a8971aec94..7197c1d21d955 100644
--- a/sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c
+++ b/sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c
@@ -425,7 +425,7 @@ static int acp3x_es83xx_probe(struct snd_soc_card *card)
 			return -ENXIO;
 		}
 
-		codec_dev = acpi_get_first_physical_node(adev);
+		codec_dev = acpi_bus_get_primary_device(adev);
 		acpi_dev_put(adev);
 		if (!codec_dev) {
 			dev_warn(dev, "Error cannot find codec device, will defer probe\n");
-- 
2.53.0



