Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B10A624;
	Thu, 11 Apr 2024 10:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832452; cv=none; b=brsXIiUzD2KX78NF/rD1t76JPmX9zoIosV30Rqsj8Q/vdInngW1CvOYq2Tq+TDJ8No47ILRBwGb1C/nVGzH1qsXSccL1QKhNZ5WLN8vmouWdhvu33cvOBfSL+WmDy4KOcb2GcTFUWzWhceG9W0rlSVrP4+yM0APJu1kHRV/2eE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832452; c=relaxed/simple;
	bh=zdIQXm+GYKSXha/LeIw2PEdBLFrw3YS93hMl7SV9Dz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iNim44V1vdfgq23+FH3OIa8iECAooqTL9AGppztNi+I3/IJ+lJ3dUPZnbeU83mz1cTo4hZAFgcz+C6IUnvTgMYlRVNm8VE226d5v/2+2hj9wdTHfTz599rWhWEDljwLdusEnwoz0CRDY3O8GEti01Tn+X0oqpM3cFlixfgKsjjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WVrwpgTS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WVrwpgTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89948C433F1;
	Thu, 11 Apr 2024 10:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832451;
	bh=zdIQXm+GYKSXha/LeIw2PEdBLFrw3YS93hMl7SV9Dz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WVrwpgTSM29QXcPee+of/8RAm2OWs59GBUqXHGurJaqLlB1HMyKcUjAzbmlQazHne
	 InS03QSjDediSqBD0I8X2QDlLz/DfaVyrqM3bQii5AQDyVc4Z0IS9tZBrZEKnQJBq2
	 xlYuWJp1L5XUAWqHpxYsLw5YPxYni2UzcJyJ91u8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alban=20Boy=C3=A9?= <alban.boye@protonmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 53/83] platform/x86: touchscreen_dmi: Add an extra entry for a variant of the Chuwi Vi8 tablet
Date: Thu, 11 Apr 2024 11:57:25 +0200
Message-ID: <20240411095414.280185464@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 11d72a3533552..399b97b54dd0f 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -1177,6 +1177,15 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
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



