Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20A35304B6;
	Thu, 17 Sep 2026 17:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664469; cv=none; b=t7i0K8t5e7PJVFzU+I7TW5joFkhkckSOi60TLWXXb56oFCd/KpRG5I3Pc+S3pN0p+pu0Y9PP7QSNwBjyucB14hrj+fdh8cnl/D7a2GQELSRkdXfudzNeDeF7/Ny5QysvUmmAczG4gR3Jo3PXMcrQnh0Z4oN08BTmGPtfjW9TO+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664469; c=relaxed/simple;
	bh=wmoY5MRMWxqLM6WaDxSNMK8OPJXmxwifjIL6lPdSKMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pxOy1xYeYZLpmUlAd3tq1qYujz+hxA53NlQ38gn6Rq93ZbjkhHm3dGRxwwGOwG+OP4wJq0BLWN3fWwwldOws125KU6MUu71sgHiSZJxFC7yQUuLTA9l0p9/JexPsN4Y/e7OOv5xnXz9BXEolSpEtHZNr14cSOAswVzPn7DQAmKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RQKr/XkL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RQKr/XkL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 254041F000FF;
	Thu, 17 Sep 2026 17:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664467;
	bh=15aRrWgrzQAZ6A/P/SL/jcp1RGWExqKZG9uTeRbBYLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RQKr/XkLMnNeSkP2A0wpaLYpJ0Q8LlOQr59U915k7gPcWpaDzICDP15ys0XJyRBGJ
	 jfFHWhoPredn7hk6/jXWum7nPd0W/NjMqqvUHotRiIZ5O9ziteKxeFANTcab/Bc3Z5
	 SUbHAD2Agc1c87vBS4dsLr3Yr9QBn3BBHDst+N7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Metchev <nikolaymetchev@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0382/1250] platform/x86: intel-hid: Add HP ProBook x360 440 G1 to button_array_table
Date: Thu, 17 Sep 2026 16:02:57 +0100
Message-ID: <20260917151602.401016840@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Nikolay Metchev <nikolaymetchev@gmail.com>

[ Upstream commit c39023ca9a447f09c072080efc84d6874c2275c9 ]

The volume rocker buttons on the HP ProBook x360 440 G1 convertible emit
events 0xc4-0xc7 via the intel-hid ACPI device (INT33D5). These codes are
only present in intel_array_keymap, which is used when the "5 button
array" input device exists. On this machine button_array_present()
returns false because the firmware does not advertise the array through
the HEBC method, so notify_handler() routes the events to a NULL
priv->array and they are dropped as "unknown event 0xc4". As a result
the side volume keys do nothing.

Add the machine to button_array_table so the array device is created and
the volume rocker emits KEY_VOLUMEUP / KEY_VOLUMEDOWN. This is equivalent
to booting with the enable_5_button_array=1 module parameter, which was
used to confirm the fix on the affected hardware.

Signed-off-by: Nikolay Metchev <nikolaymetchev@gmail.com>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Link: https://patch.msgid.link/20260609213309.445019-1-nikolaymetchev@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/hid.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/intel/hid.c b/drivers/platform/x86/intel/hid.c
index 0dcf3a68a3355..f97f7f111319e 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -158,6 +158,13 @@ static const struct dmi_system_id button_array_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Surface Go 4"),
 		},
 	},
+	{
+		.ident = "HP ProBook x360 440 G1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP ProBook x360 440 G1"),
+		},
+	},
 	{ }
 };
 
-- 
2.53.0



