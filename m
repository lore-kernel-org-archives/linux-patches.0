Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813374DF4BC;
	Mon, 31 Aug 2026 13:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183574; cv=none; b=nm3gprpluFYYu5rYQ8+nGfT4YSamO6Hf6jwvPJeRKg+ErhlUjUROXl3nIGI+bZZzvGeV37KrZe2pbSPOxVrYD2eVInuZrmTREXYxKgBfCIWxKh8HJYchar/roepTAGCUGzOfpg5JUCXNUx8Bawq24sr2vUOhSFi5v8Tb3zFk2OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183574; c=relaxed/simple;
	bh=KNZ8JYa6REPkCMxVsDmesVZB0HG84Z/y/vYB2KKojDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=So9fD4kb2bc/cQ59ZSotAb7D+eGaANkosxTphBsQvgKZenDHIR/SnGEkDwGSrL79ZtIzQ4aeGvAfCwq9qTAH3D3cqwQUsjTW6ht57fl1/t2RUESWIuMSh6X9TM7AHaH4xFsrefUqAZVykCKlBxRImB6J3+UHr2L1fUs2gTLWrB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nNrNvZOA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nNrNvZOA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418851F000E9;
	Mon, 31 Aug 2026 13:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183572;
	bh=35rz6y9ZLLDwMrShi+YGpJKjh8xiv/yE7rM/kMksMNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nNrNvZOAWgN+F7daCPiywJXKrQK70rV7TYTGkp4cZqrVbIdPHTaRvQ9jnxNnWpoAO
	 BIhGGPXJzGWLXLu7rPFxa+hnMfOQqWJYLAjyyeOGFy+27QYdL9FjKeC6R1ya1bBvmq
	 YhhmHzfYxr6PgDiK/KhwZvr0OqZY9YHYSyQE2cN3N0PuQOco2s8wOdMYyUK52JW2N1
	 OTNxyhxe+ztlbUNZ9wHbuvJb/exUL6eVLkhZKZ64e9OOdCfWV+8uqFhoo0r76/9CRt
	 rKvW4hxDBfoxdIFGb/1G8RkXOQCaQOCrr6B6wSAfY93g0Xs4985ojYNdJMWV7GsQz5
	 9dIgyF9OnupOA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Johny Lin <johnylin@google.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ALSA: hda: cs35l41: imply SERIAL_MULTI_INSTANTIATE
Date: Mon, 31 Aug 2026 09:23:24 -0400
Message-ID: <20260831133314.4125787-176-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johny Lin <johnylin@google.com>

[ Upstream commit 72d8bf668954678bfae8f7296b4b1c01990bcdc2 ]

Use a weak reverse selection to suggest the config
SERIAL_MULTI_INSTANTIATE just like cs35l56 did.

Signed-off-by: Johny Lin <johnylin@google.com>
Link: https://patch.msgid.link/20260527023350.3067547-1-johnylin@google.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background history searches finished and match the earlier analysis:

- **No prior CS35L41 + SERIAL_MULTI commit** exists in this tree — the
  `imply` addition would be new.
- **`imply SERIAL_MULTI_INSTANTIATE` for CS35L56** came in
  `17563b4a19d18` (Jun 2024) and was preserved through the HDA codec
  move (`6014e9021b28e`); CS35L41 never got the same treatment.
- **Johny Lin** has no other commits in this 6.18.44 checkout.

That reinforces the conclusion: this is a small Kconfig dependency fix
aligning CS35L41 with CS35L56 for laptops that need `serial-multi-
instantiate`. Verdict remains **YES** for 6.18.y.

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

