Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838E1146A82;
	Thu, 11 Apr 2024 10:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831310; cv=none; b=QVDVCuzrDItsQg2lS02hobL5wAdiwJ0RpKgGCzStYZ/TeQW9p6J204ZDfO8ZLFizRgLWINy2zEogUabJRWDx4q3Zhkmh5O2TjyL/g3Q+7TJoEH/jXBfNQPWBvp2NbgzccReqCwZXMvOjRRvgtSy/J0JO5gUVE8nN91fo+f27UXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831310; c=relaxed/simple;
	bh=CUkSKDcYIpkxoFrF7fJiSCobBbngAWLUyDDOdXJKTh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=me8Dl8wzj3ar21DDKHparcsCdHhaLu51g1rsMt2j5qg4yUQ/BWHvcF3R57W5XtJpcywsd/bAel3afbWWGzgHI/1lDudlu9oSo5lRdKYzEmErhlsGFVlEZPQ2w7R2pj88KXiyySnIfP+9FhE4oX8j9I2jYthZDj2bZDkwIg4MJ+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1QM2wZeb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1QM2wZeb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D996C433F1;
	Thu, 11 Apr 2024 10:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831310;
	bh=CUkSKDcYIpkxoFrF7fJiSCobBbngAWLUyDDOdXJKTh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1QM2wZeb3J3uNYJtFLLJY86p5+/f2WuJ4TBDCU6FfcB1w2QpDTfVYKEgsnQujAC6+
	 2x8VDsa9gZcyWuxTXjaxCRpvu6l8y4KB790A8/Pd1XiX1YEglfeTGNJUSnyCaGQUSc
	 X/IkaEi5OLnf7e0+Q0k/YZWST/wjHRKlGX+LeOts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alban=20Boy=C3=A9?= <alban.boye@protonmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 080/114] platform/x86: touchscreen_dmi: Add an extra entry for a variant of the Chuwi Vi8 tablet
Date: Thu, 11 Apr 2024 11:56:47 +0200
Message-ID: <20240411095419.303392502@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alban Boyé <alban.boye@protonmail.com>

[ Upstream commit 1266e2efb7512dbf20eac820ca2ed34de6b1c3e7 ]

Signed-off-by: Alban Boyé <alban.boye@protonmail.com>
Link: https://lore.kernel.org/r/20240227223919.11587-1-alban.boye@protonmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/touchscreen_dmi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index 969477c83e56e..630ed0515b1e9 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -1222,6 +1222,15 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_MATCH(DMI_BIOS_VERSION, "CHUWI.D86JLBNR"),
 		},
 	},
+	{
+		/* Chuwi Vi8 dual-boot (CWI506) */
+		.driver_data = (void *)&chuwi_vi8_data,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Insyde"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "i86"),
+			DMI_MATCH(DMI_BIOS_VERSION, "CHUWI2.D86JHBNR02"),
+		},
+	},
 	{
 		/* Chuwi Vi8 Plus (CWI519) */
 		.driver_data = (void *)&chuwi_vi8_plus_data,
-- 
2.43.0



