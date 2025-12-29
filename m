Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313C523D2B2;
	Mon, 29 Dec 2025 16:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025509; cv=none; b=X52tZZfc/3OIckiTPDjwZuEPwIG8r79n68TB1rEkLgLGJ579jSFbxyVs6Nnw7VOfyMRrI6TsVYAiQp1Va9rqADME5TyTu5rGANPZMRzDVQYXCgOPpMpN56ZRuDlFwwH57O49fasdN9tK4FNZjNBjWkVVnsmvPZkUqNQZjQu9h/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025509; c=relaxed/simple;
	bh=bh6mJEnn6YKqDkaIi8qEqm7PbO8Amm2sbe/aHNB4YZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QVg1yrh3kn1MAkpPFs8nF7fpPNDr8SOpG2Cfh3SJPcoSVWwk9vInxLRDnnoaco3XlrRO8Eouz0sMentvp8jZVgEMgrWwQYN+JrHWOd6r18IM3MWcPn+Cg7FY8GOzgKxulgaz1tjJLGbGGpqDycY4NTpNlGP0KHgvcCl9/DoNiME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UA6Q9r78; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UA6Q9r78"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14F7C4CEF7;
	Mon, 29 Dec 2025 16:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025509;
	bh=bh6mJEnn6YKqDkaIi8qEqm7PbO8Amm2sbe/aHNB4YZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UA6Q9r78Fo+b+ZbcFi8kZGFdhdWYLJ5QcVhV+teyf9PfOECrOAVvrOubF8LAxUAFg
	 JqFhJcYFFNmZ1+Z4kahjP8+tb2ezUxq/2vyZ3vLodI4IL7IV6UbG9NzmwFMrHwxkZ5
	 ynYtgl0urkKzqAOkbcuMlFN0Co9UwKaIhqiQHELE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Derek J. Clark" <derekjohn.clark@gmail.com>,
	Armin Wolf <W_Armin@gmx.de>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 206/430] platform/x86: wmi-gamezone: Add Legion Go 2 Quirks
Date: Mon, 29 Dec 2025 17:10:08 +0100
Message-ID: <20251229160731.935579759@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Derek J. Clark <derekjohn.clark@gmail.com>

[ Upstream commit 55715d7ad5e772d621c3201da3895f250591bce8 ]

Add Legion Go 2 SKU's to the Extreme Mode quirks table.

Signed-off-by: Derek J. Clark <derekjohn.clark@gmail.com>
Reviewed-by: Armin Wolf <W_Armin@gmx.de>
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://patch.msgid.link/20251127151605.1018026-4-derekjohn.clark@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/lenovo/wmi-gamezone.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/lenovo/wmi-gamezone.c b/drivers/platform/x86/lenovo/wmi-gamezone.c
index 0eb7fe8222f4..b26806b37d96 100644
--- a/drivers/platform/x86/lenovo/wmi-gamezone.c
+++ b/drivers/platform/x86/lenovo/wmi-gamezone.c
@@ -274,8 +274,23 @@ static const struct dmi_system_id fwbug_list[] = {
 		},
 		.driver_data = &quirk_no_extreme_bug,
 	},
+	{
+		.ident = "Legion Go 8ASP2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "Legion Go 8ASP2"),
+		},
+		.driver_data = &quirk_no_extreme_bug,
+	},
+	{
+		.ident = "Legion Go 8AHP2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "Legion Go 8AHP2"),
+		},
+		.driver_data = &quirk_no_extreme_bug,
+	},
 	{},
-
 };
 
 /**
-- 
2.51.0



