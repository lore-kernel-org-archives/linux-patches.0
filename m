Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0806C1C07C2;
	Tue, 15 Oct 2024 12:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997006; cv=none; b=CNtJN+RJi8E6YOnrGa0pfHJSHHCiKMpsMTxNcmWGyGtEaDDdxwk5pllGQIwiGs+cUKq6saRf7wGcKEGc6IGigRm6WhHT81r/OxbK3CiStV28miNoG3x8ws64P0Tlj4sKy8Edep3TwkR+/n8uxHXuANyFDslNhJquJqBOmTOmXuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997006; c=relaxed/simple;
	bh=4bGlVJ0ttJ3/W71y9gkpP2OSAQNN1/BR5LV5shIzpPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u//JvNB29YDYokkM2UhCz1jy4ncVNz45Su7Sw3eJXwoC58Sz4rFGpwXljgwWQP6a7jjUhzOIBX+77dj05sRvg8H2mkvh58Jb+Ab60IVVwglu8b+JNrjd8ubjSkFG3BIueBMusg1hIoDE9qxKwzQEJbvGFdg7ns91tlU+t/NWs88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0+sarZdA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0+sarZdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 829CDC4CEC6;
	Tue, 15 Oct 2024 12:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997005;
	bh=4bGlVJ0ttJ3/W71y9gkpP2OSAQNN1/BR5LV5shIzpPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0+sarZdAhHXKjYToY6Pac30Bl/tfyDR2vZ+oCQTymUI3hxCTk2KLWcGfUMnUvIf0y
	 rBKp98vu/NaA+OSKiyqIaAcV8uInYJddX5u0dSNvwDBB3x2WalfrPHaG49QxVJo7H5
	 gyIpG0LMAbv3PcgzoN7w6mr3/57nc6aqQ80Kg6Ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 060/518] ACPI: PMIC: Remove unneeded check in tps68470_pmic_opregion_probe()
Date: Tue, 15 Oct 2024 14:39:24 +0200
Message-ID: <20241015123919.325594366@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit 07442c46abad1d50ac82af5e0f9c5de2732c4592 ]

In tps68470_pmic_opregion_probe() pointer 'dev' is compared to NULL which
is useless.

Fix this issue by removing unneeded check.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: e13452ac3790 ("ACPI / PMIC: Add TI PMIC TPS68470 operation region driver")
Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://patch.msgid.link/20240730225339.13165-1-amishin@t-argos.ru
[ rjw: Subject edit ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/pmic/tps68470_pmic.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/pmic/tps68470_pmic.c b/drivers/acpi/pmic/tps68470_pmic.c
index ebd03e4729555..0d1a82eeb4b0b 100644
--- a/drivers/acpi/pmic/tps68470_pmic.c
+++ b/drivers/acpi/pmic/tps68470_pmic.c
@@ -376,10 +376,8 @@ static int tps68470_pmic_opregion_probe(struct platform_device *pdev)
 	struct tps68470_pmic_opregion *opregion;
 	acpi_status status;
 
-	if (!dev || !tps68470_regmap) {
-		dev_warn(dev, "dev or regmap is NULL\n");
-		return -EINVAL;
-	}
+	if (!tps68470_regmap)
+		return dev_err_probe(dev, -EINVAL, "regmap is missing\n");
 
 	if (!handle) {
 		dev_warn(dev, "acpi handle is NULL\n");
-- 
2.43.0



