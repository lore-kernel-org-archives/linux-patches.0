Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C86334363;
	Thu, 27 Nov 2025 15:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255613; cv=none; b=td494LDAQNjg0W8RBoFEax76q225Qkdemvdx3kO/CLMtmwiKcvcrUFEfQ8NmBxtcXRg0ZJ/DXP/1FJBRI/l0j666PhYt1HNhcgrmLf+5c8EX5/gPRn+zncD4x0/P5jeswzqGLqQ4rcbl7lHU3v77cYaUjrnkN7QvKliUwSSVdug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255613; c=relaxed/simple;
	bh=DUl2amK4oQOqo8julhTO32WvYse2KTjTKDnq8PM/oHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q7cTFy0tzJZzM0AI80IwYA/LJGyXhzjWkHS8QT6QWLWv0lugI5kzzMLMguhmAodqgL1wObxyrOzy2I32PzfcUOcclN8KWF3Zg8+BAQL/v74STHX0kZ8kATeSSLJTeuAcuxqJa01WS/HFcD5pTLgUdp7cHi99CR31e3iw5l6Nm1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZwSKe4vF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZwSKe4vF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91BD8C4CEF8;
	Thu, 27 Nov 2025 15:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255612;
	bh=DUl2amK4oQOqo8julhTO32WvYse2KTjTKDnq8PM/oHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZwSKe4vF18t+Kg3oWsFCH3IQpH+oZM32vY6coRMUaVp7QHN5y3BffmMMZyN6mDItR
	 wz/FB79UCZGdUvJgIdHkdcPfxrG4UOcIpoM63QBMCyx6U9Jc5GzVVofBJCmD9ZCR3U
	 MCe4dWmg9Hbu7h1luznVP9HbwG0BWe/E5HWHtpSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cihan Ozakca <cozakca@outlook.com>,
	Kurt Borja <kuurtb@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.17 053/175] platform/x86: alienware-wmi-wmax: Fix "Alienware m16 R1 AMD" quirk order
Date: Thu, 27 Nov 2025 15:45:06 +0100
Message-ID: <20251127144044.901547016@linuxfoundation.org>
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

commit bd4f9f113dda07293ed4002a17d14f62121d324f upstream.

Quirks are matched using dmi_first_match(), therefore move the
"Alienware m16 R1 AMD" entry above other m16 entries.

Reported-by: Cihan Ozakca <cozakca@outlook.com>
Fixes: e2468dc70074 ("Revert "platform/x86: alienware-wmi-wmax: Add G-Mode support to Alienware m16 R1"")
Cc: stable@vger.kernel.org
Signed-off-by: Kurt Borja <kuurtb@gmail.com>
Link: https://patch.msgid.link/20251103-family-supp-v1-1-a241075d1787@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/dell/alienware-wmi-wmax.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/platform/x86/dell/alienware-wmi-wmax.c
+++ b/drivers/platform/x86/dell/alienware-wmi-wmax.c
@@ -122,20 +122,20 @@ static const struct dmi_system_id awcc_d
 		.driver_data = &generic_quirks,
 	},
 	{
-		.ident = "Alienware m16 R1",
+		.ident = "Alienware m16 R1 AMD",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m16 R1"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m16 R1 AMD"),
 		},
-		.driver_data = &g_series_quirks,
+		.driver_data = &generic_quirks,
 	},
 	{
-		.ident = "Alienware m16 R1 AMD",
+		.ident = "Alienware m16 R1",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m16 R1 AMD"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m16 R1"),
 		},
-		.driver_data = &generic_quirks,
+		.driver_data = &g_series_quirks,
 	},
 	{
 		.ident = "Alienware m16 R2",


