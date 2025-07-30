Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9582D2951BA;
	Wed, 30 Jul 2025 09:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868616; cv=none; b=XXwKFtUAMnpUxMIZWbejCT3Ol4poqEM2Et1u19Nep1fBkAgIfYoscmXIkw5Gg3I5Ay0kKLNkKKZ6SCnEM+SDQxysLS6o80caV3Dy7aViwXWls43sJQe8GPWevstefW49S7//pBm6O+BGLSl9Gz9ks8+EK/XgCZGG7K/SGtPFV6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868616; c=relaxed/simple;
	bh=8Rtyj66+EmFtGMsDccJfiAgwC9vy19EY/M4ZtZ4y9sQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=agIeEUwmJHi/VBqdydFchnY138u4HqWxatqq1lkxogJ0XYe6e6bPgpZ+43hCtRWgZfDOyfgZr7b/RhrnX4IIO+Ft05GqvWcG+j5JngqxcHibBlSnea3Z5AD9Apnuco3DGaY/Qhn3uyjZWngGOMLKiLzqLXnfUHoLx6xBGC/Fjgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zedtRpzR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zedtRpzR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79A5C4CEE7;
	Wed, 30 Jul 2025 09:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868615;
	bh=8Rtyj66+EmFtGMsDccJfiAgwC9vy19EY/M4ZtZ4y9sQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zedtRpzRKt0WcKf+7ZUZekPlsZSgtqfP78+wX9zz7Yn9hyqEB3DMe1pvbvww5LsqZ
	 PcyDt6EuW8hzdSsi+OSGhaGfZ7FOFL3JiJaJ7A7FJm1oUnp5IftZmt09ZPhlQZkqAs
	 O9uB3aBTepz5jSqGfwah+7J91ZNLyO0gse5QFvCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Chandra <rahul@chandra.net>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 006/117] platform/x86: asus-nb-wmi: add DMI quirk for ASUS Zenbook Duo UX8406CA
Date: Wed, 30 Jul 2025 11:34:35 +0200
Message-ID: <20250730093233.840322022@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rahul Chandra <rahul@chandra.net>

[ Upstream commit 7dc6b2d3b5503bcafebbeaf9818112bf367107b4 ]

Add a DMI quirk entry for the ASUS Zenbook Duo UX8406CA 2025 model to use
the existing zenbook duo keyboard quirk.

Signed-off-by: Rahul Chandra <rahul@chandra.net>
Link: https://lore.kernel.org/r/20250624073301.602070-1-rahul@chandra.net
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index a5933980ade3d..90ad0045fec5f 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -529,6 +529,15 @@ static const struct dmi_system_id asus_quirks[] = {
 		},
 		.driver_data = &quirk_asus_zenbook_duo_kbd,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "ASUS Zenbook Duo UX8406CA",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "UX8406CA"),
+		},
+		.driver_data = &quirk_asus_zenbook_duo_kbd,
+	},
 	{},
 };
 
-- 
2.39.5



