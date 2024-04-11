Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82824145B1E;
	Thu, 11 Apr 2024 10:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830422; cv=none; b=CYLbkhyAcqg4BhvPJdp+zZ0u1lY4Ug1tuVjzGO9Pk+NHQz8y5RZ+Myh9xV2UXwooTV5adcWHHNJjoLJBqAFzDQri94IcduDfz08pOXoVdCzKV3E/ysLPBk7t6b1QjNT7o18jc4DZPT0/ffxFXYPPOgOMWf2+8dd7VPXPEQoy6O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830422; c=relaxed/simple;
	bh=5lTFt4ZZmUw+IZ3tsp6V3ungTALnwSYUyTYkPHkvm1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sisSFaXX2RGDyQltfCzLOxl+gy8DSBLRBbx79Y0fMeS1FaO+7jW63iRuI1/0LhPJtkFDJEKcMZaoGwO6kh/dPXi/mbWJc87Em+Bj9Ap5vQYeqpQs5hjH3Q9N7nmA2xtPPo0n0Z7aya1tDJQM0nJ8Ov821iAue0wyKQKIa/1vFNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q2xI3CkM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q2xI3CkM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A753CC433C7;
	Thu, 11 Apr 2024 10:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830422;
	bh=5lTFt4ZZmUw+IZ3tsp6V3ungTALnwSYUyTYkPHkvm1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q2xI3CkMERWIiV9AD8+GK+lB5D8/1uUiO4pZ7vThA/5Htd2DINAbcQRS76CIJrIfZ
	 0T9hLUAHiVZAJ/o5dpFpG9UJlUQdDTuZlQry9TgPI/y+6mnWAX82B+p+CL13IJlMDI
	 UHKKofLCZkb5t0EmdcuKi4bgpVTSLanlf6SG8G1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alban=20Boy=C3=A9?= <alban.boye@protonmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 102/143] platform/x86: touchscreen_dmi: Add an extra entry for a variant of the Chuwi Vi8 tablet
Date: Thu, 11 Apr 2024 11:56:10 +0200
Message-ID: <20240411095423.978466532@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 975cf24ae359a..c6a10ec2c83f6 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -1217,6 +1217,15 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
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



