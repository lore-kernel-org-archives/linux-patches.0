Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8002823F439;
	Thu, 27 Nov 2025 15:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255624; cv=none; b=UmzLz4sMGrVNnELnaLmaMt0aHV8DXN1SVnO5QlfEvP6cxwfAvwTOchhoi0ZxFQ4frnEJje6UYfMZbQHrGjckAMfn7VaA+6oGrweIBeUrFsMa4rAeqyM3CjPTxVFtnxjB6or4BQZL7zwxHNx+GYyiu+Bu9BepLbRVrq1ePGbGXsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255624; c=relaxed/simple;
	bh=FoC/uO0ocJ8q1H/h+86ChrVDhQWjJ4RPMItqcD//d7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cInQ4ER8y3WEgc+oQrhHkFr5ddGuOnO7dIluq2uQfrP/eWCqOB3047XARO/DxpB5CHtjCDj9auv5uvOBvE22h8+nkxdKvWr9s/qJdynAhnIlLL2fkw3tkJV1TPVIYcuTnp+iXR+nt4+rFRxF0UDsWmvcT0KPqDiVB0xJ+KCVBtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kSRKFmbX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kSRKFmbX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05260C4CEF8;
	Thu, 27 Nov 2025 15:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255624;
	bh=FoC/uO0ocJ8q1H/h+86ChrVDhQWjJ4RPMItqcD//d7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kSRKFmbX3r4IPopqDHllbkc4/Ik3UjuiVkkiiz59zKuqgqr8VrIudqSrHUBqYIEE0
	 vxR8JgRk+m0Sm+ncK17ZyvkaCaegCDKuw8C0z26kPhlTjBZ3TZENItMaVH4nqyldtN
	 2znx9wVrV/F5cmRM9ejFe70r17gVpeKWNeFOTcK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kurt Borja <kuurtb@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.17 056/175] platform/x86: alienware-wmi-wmax: Add support for the whole "G" family
Date: Thu, 27 Nov 2025 15:45:09 +0100
Message-ID: <20251127144045.011353270@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kurt Borja <kuurtb@gmail.com>

commit a6003d90f02863898babbcb3f55b1cd33f7867c2 upstream.

Add support for the whole "Dell G" laptop family.

Cc: stable@vger.kernel.org
Signed-off-by: Kurt Borja <kuurtb@gmail.com>
Link: https://patch.msgid.link/20251103-family-supp-v1-5-a241075d1787@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/dell/alienware-wmi-wmax.c |   56 +++----------------------
 1 file changed, 8 insertions(+), 48 deletions(-)

--- a/drivers/platform/x86/dell/alienware-wmi-wmax.c
+++ b/drivers/platform/x86/dell/alienware-wmi-wmax.c
@@ -170,74 +170,34 @@ static const struct dmi_system_id awcc_d
 		.driver_data = &generic_quirks,
 	},
 	{
-		.ident = "Dell Inc. G15 5510",
+		.ident = "Dell Inc. G15",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Dell G15 5510"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Dell G15"),
 		},
 		.driver_data = &g_series_quirks,
 	},
 	{
-		.ident = "Dell Inc. G15 5511",
+		.ident = "Dell Inc. G16",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Dell G15 5511"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Dell G16"),
 		},
 		.driver_data = &g_series_quirks,
 	},
 	{
-		.ident = "Dell Inc. G15 5515",
+		.ident = "Dell Inc. G3",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Dell G15 5515"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "G3"),
 		},
 		.driver_data = &g_series_quirks,
 	},
 	{
-		.ident = "Dell Inc. G15 5530",
+		.ident = "Dell Inc. G5",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Dell G15 5530"),
-		},
-		.driver_data = &g_series_quirks,
-	},
-	{
-		.ident = "Dell Inc. G16 7630",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Dell G16 7630"),
-		},
-		.driver_data = &g_series_quirks,
-	},
-	{
-		.ident = "Dell Inc. G3 3500",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "G3 3500"),
-		},
-		.driver_data = &g_series_quirks,
-	},
-	{
-		.ident = "Dell Inc. G3 3590",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "G3 3590"),
-		},
-		.driver_data = &g_series_quirks,
-	},
-	{
-		.ident = "Dell Inc. G5 5500",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "G5 5500"),
-		},
-		.driver_data = &g_series_quirks,
-	},
-	{
-		.ident = "Dell Inc. G5 5505",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "G5 5505"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "G5"),
 		},
 		.driver_data = &g_series_quirks,
 	},


