Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB132D9ECD;
	Tue,  8 Jul 2025 16:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992426; cv=none; b=PpyKCnXXh5pMj7z3BFUh6s/f6BJll10ocUEz/LZI9w8AanfmMG3PsF7zqagPww+K+Z1u8pqgnTUsP4mvsoCIgMmR1u++aS3HwSwDQE/IVAKH8J6qlrmRyR3NdZNQUMItUMwZoJ9Dh7VakOPGEFNKAqJgapQ2dt01giFwdfsy8cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992426; c=relaxed/simple;
	bh=rFli3NmAN5Xl4YaiZvMPVr8xPwhPPdJxLW0fHv7icJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PYCYNaiETghT7v1iOr0Mzn98+KBafe/T2ahFOkCBpf/afY43IIE8p+mG3JPtahJddkOWl0FcjTHTbpHwW+GXhmC0PFp8GaLbGhsBx6uuLhCKt1PSPBKqcMw+02Jv5jTc9KoVj4/nbNGtGTKzvMDrGgDtFmIJcdjyPBks51Q4zRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vKbn8FVN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vKbn8FVN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA2F8C4CEED;
	Tue,  8 Jul 2025 16:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992426;
	bh=rFli3NmAN5Xl4YaiZvMPVr8xPwhPPdJxLW0fHv7icJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vKbn8FVNRvZMpQf6o90munQ8zNZgHqxK/xD0S29cR4r6+auac4lM3EJH72REHtzUy
	 KMHaxBIcUMiaHxX3TX0W9jaMb8lADfHmpgARmebsf6NqiKUkcSHZnSnydrCPAj5Ubj
	 PhRQ4rcAJYsvD4X/alqKe3gdgPbITtrKD/R4K5eQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Santese <santesegabriel@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 088/132] ASoC: amd: yc: Add quirk for MSI Bravo 17 D7VF internal mic
Date: Tue,  8 Jul 2025 18:23:19 +0200
Message-ID: <20250708162233.202504733@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Santese <santesegabriel@gmail.com>

[ Upstream commit ba06528ad5a31923efc24324706116ccd17e12d8 ]

MSI Bravo 17 (D7VF), like other laptops from the family,
has broken ACPI tables and needs a quirk for internal mic
to work properly.

Signed-off-by: Gabriel Santese <santesegabriel@gmail.com>
Link: https://patch.msgid.link/20250530005444.23398-1-santesegabriel@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 40e2b5a87916a..1547cf8b46b13 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -451,6 +451,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Bravo 17 D7VEK"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Micro-Star International Co., Ltd."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Bravo 17 D7VF"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.39.5



