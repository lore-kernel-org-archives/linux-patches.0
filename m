Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751286BB29;
	Thu, 11 Apr 2024 10:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832304; cv=none; b=m8ofdc4oXeU4/WI1vigatHCKRC8oVZFhSnRtqCQcQw8hpWX3L6oc05yzkasRFpMiHix+cWZsCf9/NTbh63Tm+BglI0/aBUwAkVTfA2TkJIzGbRUz5xj5c+tROPvDVaEhlPj3HBpKWOWqyZS+iMrox9Bp1suzw+e8960rn/vEYkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832304; c=relaxed/simple;
	bh=bWg23MT/w572YrFMjwDLFX3fMJl3mhOiahdo9xJCq94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NyfYYETCHrn5g5VupJ5yRnmct5zC7oDdYNAp6ZpJ+Qm66E2ApoIABGEnj5WioHSw/ViEsmZBfSRzV+Mb9fSDSSxT24h0aaZBSJOoTQweYmr+50NItZmBa5q2QxhvSRZZ+lyMiUO8DMLhCaxspKURi2yIfs9Xme4g50vEFoM+StE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YhL+H73A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YhL+H73A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5774C43390;
	Thu, 11 Apr 2024 10:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832304;
	bh=bWg23MT/w572YrFMjwDLFX3fMJl3mhOiahdo9xJCq94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YhL+H73APez/eTAPjE6m0kR7LVYE6h69fP3XHs7lzDy4HZXPOBTvgWMkgmz6hhlGH
	 01h1fH9Kbx2xhvw4F6peX7wgcmBQ/a0NQSz1M8WDLAzgEDiEVgzP1hlPOPXcETge2u
	 pBb1LhhWqwnXmap+0ivDOJzrVNom1UZIDZ1M3ie4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alban=20Boy=C3=A9?= <alban.boye@protonmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 273/294] platform/x86: touchscreen_dmi: Add an extra entry for a variant of the Chuwi Vi8 tablet
Date: Thu, 11 Apr 2024 11:57:16 +0200
Message-ID: <20240411095443.766242071@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ebe959db1eeb9..fbaa618594628 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -1084,6 +1084,15 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
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



