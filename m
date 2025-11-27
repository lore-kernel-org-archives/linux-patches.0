Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E12327FD51;
	Thu, 27 Nov 2025 15:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255621; cv=none; b=DVfxNN8pdXDG4K621pr00r/ZXRy79aZgxFSexh/CMS9brTG1t+sFO3526AqfAUrDXgSVIOrxU4opnbn3hUB3LiHQ+EC9ZDigU61w03BmXSBTermxhCoDDrQfNE32VS/TFwldLZcL0TIbIad4EkBPEGSipdfR7osCocw3bx/fVMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255621; c=relaxed/simple;
	bh=77cFdQD+akn+gz0B5y1DtC5bPlvB8mmcH13IY7dT9dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nw+HWc0pbR464L49etEJiz25mPmQ2CSR8ochhW9RfQPAiOs9XSMQzoTS0eiPFfeIhTkzAZysMtSuT3Kqgt/KuuNWrwppaXwavisyo2hSQzU9d1AOecSfkuz9IRAJ/GGJlQLgCDyJcd2ZKVu2tPVJNfLuxXU8rIZhjJ8g0xV32HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z0fxTWN4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z0fxTWN4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044D5C4CEF8;
	Thu, 27 Nov 2025 15:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255621;
	bh=77cFdQD+akn+gz0B5y1DtC5bPlvB8mmcH13IY7dT9dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z0fxTWN4gdDX+Zppk6lrdgbdkLCxjjXjODV6db69iAinHielfUokwCsiVCbYA9AT9
	 xT18jgEg3B9UsTuHkbuOZ/9wYYxb1tGy4hUZJFWvbukY1a7QnwT4bNVXLJr5H0fNqs
	 zDu9Fe7GI+a9ruNy1+j1iIbCVuhu3dNfH5RWY2EA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kurt Borja <kuurtb@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.17 055/175] platform/x86: alienware-wmi-wmax: Add support for the whole "X" family
Date: Thu, 27 Nov 2025 15:45:08 +0100
Message-ID: <20251127144044.974918251@linuxfoundation.org>
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

commit 21ebfff1cf4727bc325c89b94ed93741f870744f upstream.

Add support for the whole "Alienware X" laptop family.

Cc: stable@vger.kernel.org
Signed-off-by: Kurt Borja <kuurtb@gmail.com>
Link: https://patch.msgid.link/20251103-family-supp-v1-4-a241075d1787@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/dell/alienware-wmi-wmax.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

--- a/drivers/platform/x86/dell/alienware-wmi-wmax.c
+++ b/drivers/platform/x86/dell/alienware-wmi-wmax.c
@@ -154,26 +154,18 @@ static const struct dmi_system_id awcc_d
 		.driver_data = &generic_quirks,
 	},
 	{
-		.ident = "Alienware x15 R1",
+		.ident = "Alienware x15",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware x15 R1"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware x15"),
 		},
 		.driver_data = &generic_quirks,
 	},
 	{
-		.ident = "Alienware x15 R2",
+		.ident = "Alienware x17",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware x15 R2"),
-		},
-		.driver_data = &generic_quirks,
-	},
-	{
-		.ident = "Alienware x17 R2",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware x17 R2"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware x17"),
 		},
 		.driver_data = &generic_quirks,
 	},


