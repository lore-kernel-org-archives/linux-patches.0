Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A697A332EA0;
	Thu, 27 Nov 2025 15:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255618; cv=none; b=WLr5Y3w4m8zvk4no0gYqpAbVfcjwtMF+XUAsRnHpyCE+S2NKoZofFev9o+t9fiYpVM1ZsEZ6FouKkE7gBs21FNwGj3dVLl7TxJLz9MdFrKEtEc/ZvvDovFCnOTHUJw8QBiIZUaLUF0PD2tHYUsUkcyPh1+U/vMaRcnL1/pgy4BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255618; c=relaxed/simple;
	bh=HAnmJjy3CBZNtiApNbPcDGRKw7WiCGEg0j3ig2o50pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I3iuDQRUz6viBqSIzN/gswlqiTXm+g7/X1MubmacF58Rv7M9nC5+8UnjBuH3TZS8um4dbInRUh8gCkyVOB4qhVZcUVUGbMmZir5GCN+lhIFtu4GR471y1b7emRK1BwWp26alQ2UhH3HJi/9rk882Bug4sHnSAZTf2z9swtXHlf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Au739uWs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Au739uWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317B6C4CEF8;
	Thu, 27 Nov 2025 15:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255618;
	bh=HAnmJjy3CBZNtiApNbPcDGRKw7WiCGEg0j3ig2o50pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Au739uWs8ZiY7NfwdaXeRWp+bXIppV8ivpqREONytyaIlxKa+nifFsLGkREypT4k6
	 6vRhLr6T/ny6A+f35XQPDQfJRNR8ACf2PTAa1k8bl5clp8twGbRJspRvzGDIomZB1t
	 hAFXbMMyFqkDZK9IAbHhX4BJhrqCD5n/rpZXsRpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kurt Borja <kuurtb@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.17 054/175] platform/x86: alienware-wmi-wmax: Add support for the whole "M" family
Date: Thu, 27 Nov 2025 15:45:07 +0100
Message-ID: <20251127144044.938427463@linuxfoundation.org>
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

commit e8c3c875e1017c04c594f0e6127ba82095b1cb87 upstream.

Add support for the whole "Alienware M" laptop family.

Cc: stable@vger.kernel.org
Signed-off-by: Kurt Borja <kuurtb@gmail.com>
Link: https://patch.msgid.link/20251103-family-supp-v1-3-a241075d1787@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/dell/alienware-wmi-wmax.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

--- a/drivers/platform/x86/dell/alienware-wmi-wmax.c
+++ b/drivers/platform/x86/dell/alienware-wmi-wmax.c
@@ -106,18 +106,10 @@ static const struct dmi_system_id awcc_d
 		.driver_data = &generic_quirks,
 	},
 	{
-		.ident = "Alienware m15 R5",
+		.ident = "Alienware m15",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m15 R5"),
-		},
-		.driver_data = &generic_quirks,
-	},
-	{
-		.ident = "Alienware m15 R7",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m15 R7"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m15"),
 		},
 		.driver_data = &generic_quirks,
 	},
@@ -146,18 +138,18 @@ static const struct dmi_system_id awcc_d
 		.driver_data = &generic_quirks,
 	},
 	{
-		.ident = "Alienware m17 R5",
+		.ident = "Alienware m17",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m17 R5 AMD"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m17"),
 		},
 		.driver_data = &generic_quirks,
 	},
 	{
-		.ident = "Alienware m18 R2",
+		.ident = "Alienware m18",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m18 R2"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m18"),
 		},
 		.driver_data = &generic_quirks,
 	},


