Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54F737C0F1;
	Tue,  6 Jan 2026 18:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722422; cv=none; b=eXYf/+iJkKJSQQoXM1Sg+yrIp4ALsoxVUBMOyKv49xbYPi9spJVTkvxBLQrShV7GSsVbDAVCHkE55eeIXc2u1bvpasGtDUvEagCHZp5OYp0eg0YrdVrndxrznE5BHiTfOdK7qG9GhRNo4N0/VZpZDLtYo6YKMKEmLta7ING62VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722422; c=relaxed/simple;
	bh=4gjwQtybU/qSbUy4oTDHBnYSZp0oxOh0/xsarn58ITA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lSDaMXknnihAMsuJorrTWKovKVeLsioihloDM+EcIjWHNnMr65nhJ6MZt9dcBnAGI9+VpM+4VVHXbPWIHPUlGj7+E8Z0FAmqEZDS3DPhfvnQAL7Tvbn+oifxiONXgqTR1su4vmcHbDnf1PT3qjs1FlUhDMPiHe9HVIkp+IjYjgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eqar1War; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eqar1War"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B861CC116C6;
	Tue,  6 Jan 2026 18:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722422;
	bh=4gjwQtybU/qSbUy4oTDHBnYSZp0oxOh0/xsarn58ITA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eqar1WarR7I541c2QHtdYwtT+/XBmS2MS/9EB6sxdYzQz1jc123wKWwVcJgfcMO6b
	 JNhM2flvRteFffp91UgkHtVnbDA6DXoFp3frFZjIlE30jDfLFBqQJKFk0Er9auTJG0
	 0FqAastwgaG6uC6oP0VajcqfnUaEvlKYR927xJGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kurt Borja <kuurtb@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 259/312] platform/x86: alienware-wmi-wmax: Add support for new Area-51 laptops
Date: Tue,  6 Jan 2026 18:05:33 +0100
Message-ID: <20260106170557.217769497@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Kurt Borja <kuurtb@gmail.com>

commit 433f7744cb302ac22800dc0cd50494319ce64ba0 upstream.

Add AWCC support for new Alienware Area-51 laptops.

Cc: stable@vger.kernel.org
Signed-off-by: Kurt Borja <kuurtb@gmail.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://patch.msgid.link/20251205-area-51-v1-1-d2cb13530851@gmail.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/dell/alienware-wmi-wmax.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/platform/x86/dell/alienware-wmi-wmax.c
+++ b/drivers/platform/x86/dell/alienware-wmi-wmax.c
@@ -90,6 +90,22 @@ static struct awcc_quirks empty_quirks;
 
 static const struct dmi_system_id awcc_dmi_table[] __initconst = {
 	{
+		.ident = "Alienware 16 Area-51",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware 16 Area-51"),
+		},
+		.driver_data = &g_series_quirks,
+	},
+	{
+		.ident = "Alienware 18 Area-51",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware 18 Area-51"),
+		},
+		.driver_data = &g_series_quirks,
+	},
+	{
 		.ident = "Alienware 16 Aurora",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),


