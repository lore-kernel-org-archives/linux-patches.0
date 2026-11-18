Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048448;
	b=YAqg9H+8eQsi7vQ+AXdlO2e7bP3VTFCGaaQaE4MFo6GWQGeyYiZyzKQOJqsq0eNZd2SJ
	 vFB5lzcaL5hbVClHyLPgTcsl4SBTjmXRLAtDd9X6l43q6rxcbZluIVmot44EeW2v8g4MC
	 nueYPhEMAzszT8qi/AkpsPx9BTqzLJcZfChpcZZsUB1qyLcdFqXeZCiAW5Jw8gkCkFcRi
	 NMJ6j+vazxAV48S50ETFtePvw+qQSA7/dRfl1Cj44KPee+riqmMP6QfVNNr5YFiGe/cdm
	 dCwl9cj+7X8AjAbBXYQHsOH4fbwE+st0Y2hYTSDt+M9Pi0jK1DJ7fVInhvLYEIU09ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048448;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4rvvFYPDF3gQ6InPgA9R+TdavpEyz7YVQZJob1qraoI=;
	b=JOEl8BrgZEsKXsgIyqm/JiFIND7aHhYruUF9BhDKAiAY3wy9ASKcWR2AzyAFsGU44s7y
	 Np5mUIj+FHdjt7Jf5h2Yfl4Jbqf0KrfQHbI03jr/4s8EJMjOPGKbZJme/iEYm+NnaTCYa
	 L/WJSVFtTV3HLxm+eyry47JOxiseG4AaecK4sXAFYeoM+ROzSAHVG0R5xRmGEoRjRnFcZ
	 BfIolDSeHI8OakwAA3sShEiIUDSOYJba0QcrRh2T2YZVHdEKoTVOaqwFWfH4T8U420lgc
	 gqYn8T8r5VZIVtfcsf5mbaGHOYTlYpQy0C5KplYloKrt+VuLUypuBcsH2URuHoqw6aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uFEWfkkn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CFB606A334;
	Thu, 19 Nov 2026 00:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uFEWfkkn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A691F000C4;
	Thu, 19 Nov 2026 00:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048448;
	bh=4rvvFYPDF3gQ6InPgA9R+TdavpEyz7YVQZJob1qraoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uFEWfkknusRYqAm1+XzVrVtkqm8Fp4v4JOcyyb/jYl7X7q5mcf1/2i2lRoDpvAMon
	 c3UTI4fazcgpt5/w5hW20GFvOZCAjNT3gPWt4phnwly2r0bIxQjDoldv9T2mjl8vL3
	 oW/ANLkTpOB9YXTF1pjisdEiNv+ln5SZSIVZSnuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Mark Brown <broonie@kerenl.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1999/2857] ASoC: amd: acp-es8336: Switch to use acpi_bus_get_primary_device()
Date: Wed, 18 Nov 2026 15:50:33 +0100
Message-ID: <20261118150313.343966904@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f91a3c13ac235..0b4a6e84e3bea 100644
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



