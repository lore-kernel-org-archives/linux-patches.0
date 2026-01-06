Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A2A366DAD;
	Tue,  6 Jan 2026 18:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722432; cv=none; b=uaMdooPJV7QjkmaV0j1vaZcOiEvem2oF7CpYFxoMoO75NaSDtlpWC8OInqm2FIaSf0YVp6HzEXeYT1Zt/iyheTTmK5kzTnDjCmCaVWeV6W3qBCSJshNaiV057/OmYbon08macRlMC1nLJJZLYYxYOnJpj6i5WfJ//0/jq86tM0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722432; c=relaxed/simple;
	bh=lmC9NzhcubmIv21PWjFKmAnkCS4EWDspppww/FmGW28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wf2aVCNDk1dd85R0mgUDW7h3c24vJ9w8irx7gty0ytQYMk8hlR72IbDKV66BQrI7et5WW/gtYJud2an2aipTXuGmPpR5N6pGn89nZv+F8CdyjfltaNTVUlpfOSbLKtFv4ZMndq5R19A5TEO2gn+40l4T1sSuy2fDVLK2+hOLMaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GO0/eRGn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GO0/eRGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F42C116C6;
	Tue,  6 Jan 2026 18:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722432;
	bh=lmC9NzhcubmIv21PWjFKmAnkCS4EWDspppww/FmGW28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GO0/eRGn1J2fZ4g3viPd7m84Nd8OhqlVWq3ZPGXpWfk66tE/IZfWw14BeMJGfM59o
	 2/jidrA7U96L+7BMzV17XNCLfnruNF3EbCy4MlN6oYca2BkfKLiKTSOjXs+DGzA2rf
	 JbTuO/rRBqvmCLpQMchpJxl4tYvLeQUtM0jOIeqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kurt Borja <kuurtb@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 261/312] platform/x86: alienware-wmi-wmax: Add support for Alienware 16X Aurora
Date: Tue,  6 Jan 2026 18:05:35 +0100
Message-ID: <20260106170557.289625351@linuxfoundation.org>
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

commit 7f3c2499da24551968640528fee9aed3bb4f0c3f upstream.

Add AWCC support for Alienware 16X Aurora laptops.

Cc: stable@vger.kernel.org
Signed-off-by: Kurt Borja <kuurtb@gmail.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://patch.msgid.link/20251205-area-51-v1-3-d2cb13530851@gmail.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/dell/alienware-wmi-wmax.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/platform/x86/dell/alienware-wmi-wmax.c
+++ b/drivers/platform/x86/dell/alienware-wmi-wmax.c
@@ -98,6 +98,14 @@ static const struct dmi_system_id awcc_d
 		.driver_data = &g_series_quirks,
 	},
 	{
+		.ident = "Alienware 16X Aurora",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware 16X Aurora"),
+		},
+		.driver_data = &g_series_quirks,
+	},
+	{
 		.ident = "Alienware 18 Area-51",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),


