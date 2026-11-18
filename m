Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029872;
	b=fDvfySEqejMwim1+iujxBDhSviMb9sW6FzfqyjkxSSWformxnejNkHwKI+0MwWXpi8i6
	 USVSjBouwyy6uvALh6LJGTDee+LV5TvPavZZJ7n+giPcCp+3M3h9Q+PZLziJrGAXzJe3u
	 xXM0KixsybrveqL0zA0Ld2AO8OawotgZFNgNokmjij4XrGcUEvHGAacJYR6E3DxxPpT7s
	 nHBKYYPQ1aUJJa8UXz0EYYEWbyqJxAwP/TqfAFou9lTRDapFXXVf+jhjv7G71UZokpo5j
	 I47At0SALY6Z39DLfflpXy7xe2JyzFuZ15duiLNb2tNcaylw8ljDJY9/pILhatWCumw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029872;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S4WH3H0lf+OSijx4fGTJNnNzv6F9z31chMRUdzIpNv0=;
	b=M6pD+9aiyxqD5a7uVvFSx98PiHEEGzBNs8Y3zfFO7ytidGx0tnvyNJPxmh9CpQvCkNOW
	 3/L1jwVItFYrsBFVG86PJs2vCHYAMYvmYbGSPhzoO6RLPfmkHeGvvaQS/PUBaQqXMDxZs
	 rvqbZwMheLg73HNZsM9W7NLcQUGExcLXHS05yPYTv4Uf6ynt1YBmlfO7EVx0X2dpyjuCz
	 DdPx19gpr3wIEdYcIe09Im7o0A49yTpHQz4rDmpXjzR4xbjVdhoTxj65/Xe0BWYeLFvtQ
	 jX38vTMbaUrncWwgcMORicmZa/Ntg32max6zl58A3hk2ooIwYOu1hO2j/NW/7/40Spg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i5IukpYS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D85E606A31C;
	Wed, 18 Nov 2026 19:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i5IukpYS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF301F000C4;
	Wed, 18 Nov 2026 19:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029872;
	bh=S4WH3H0lf+OSijx4fGTJNnNzv6F9z31chMRUdzIpNv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i5IukpYST/Yo04rqODdLyGNIJi76Q17W9brBJCvtYBHBeAY5jQw2NMYfjXnz+UcTN
	 sy+H7+ZhyEqfBdicnwEwjYv7fgIxMerN+IruOCV0fC5pMNyEwuXdMbl1fzJntdnnN8
	 Zmm2PD30XW2eaiViQgCYjsPlagTTRBQlVCQp58iU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Mark Brown <broonie@kerenl.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0503/1756] ASoC: amd: acp-es8336: Switch to use acpi_bus_get_primary_device()
Date: Wed, 18 Nov 2026 15:43:50 +0100
Message-ID: <20261118150029.088246184@linuxfoundation.org>
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

[ Upstream commit 6f50ab7ab1f93e874fa75d18bf98bbca4ce0204f ]

Replace acpi_get_first_physical_node() that is slated for removal
with acpi_bus_get_primary_device() that takes a reference to the
device it is about to return.

This addresses a potential use-after-free that may occur if the
device returned by acpi_get_first_physical_node() is removed right
after dropping its ACPI companion's physical_node_lock in that
function.

It also fixes a device reference counting issue that may lead to
a premature device release if gpiod_get_optional() fails in
st_es8336_late_probe().

Fixes: 02527c3f2300 ("ASoC: amd: add Machine driver for Jadeite platform")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Mark Brown <broonie@kerenl.org>
Link: https://patch.msgid.link/2063881.yKVeVyVuyW@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp-es8336.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/acp-es8336.c b/sound/soc/amd/acp-es8336.c
index 3756b8bef17bc..6ccaf87a080db 100644
--- a/sound/soc/amd/acp-es8336.c
+++ b/sound/soc/amd/acp-es8336.c
@@ -201,7 +201,7 @@ static int st_es8336_late_probe(struct snd_soc_card *card)
 	if (!adev)
 		return -ENODEV;
 
-	codec_dev = acpi_get_first_physical_node(adev);
+	codec_dev = acpi_bus_get_primary_device(adev);
 	acpi_dev_put(adev);
 	if (!codec_dev) {
 		dev_err(card->dev, "can not find codec dev\n");
-- 
2.53.0



