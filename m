Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D275A257435;
	Wed, 30 Sep 2026 18:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794416; cv=none; b=uE35zIQoP0D/dIaHsfy7mpW7h3MxGlRqr8U5S4NSBxEPdVWTkTaFnrducfJxIsFxxT4aUGun8pfNCNJBOLjKzNj+Mv7QGi4JzixbbG88rrXsPQNi2mLnoNUg9pGQFRPoapRrf8Mwmt5YneGlhsVeVIwPTwxAqLzm30IZ1O6qJLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794416; c=relaxed/simple;
	bh=g8s8iSDnEwt/L25BLK0g7km9grG65sYArK3JmTUhekA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cZqqxvrPv3sYo2PnpcBKU0iaRcR/CCr9CkOTquep9vi9z8J6MzK99WV/AgDMqzOVcEJjdv8TMCjpTPsnQC0yTk79v8WMhDU96HJfo/9eArUVoloISo8Bq0wDhUlBi3Bz6HYRXvoPx/Kund0fIXOD9v4dK20oWiBh61Gs8Nckyzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EySDQ3bz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EySDQ3bz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC6F1F000FF;
	Wed, 30 Sep 2026 18:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794415;
	bh=gSAowCGoXcayExjw/SpVEHHMo/6ATRgwl1KQeeMAFRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EySDQ3bzN1odlJROyGaSeuTLRuayKALFxRgKnhzjqSmkWM6Bm8DztcX1P/mJSsx5M
	 8rqOJmcXiYIKFnnsj94Ft1y1ffjpVWbeV2GWb3nazW5TKIJ0FUfYLhBo/UgAkhZgY/
	 MM6jbUz69RP4d7VuZyKtjFQbzhKQIozFpFGJLxsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Metchev <nikolaymetchev@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0204/1193] platform/x86: intel-hid: Add HP ProBook x360 440 G1 to button_array_table
Date: Wed, 30 Sep 2026 17:14:48 +0200
Message-ID: <20260930152438.741151019@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 346fbad34e24a..8ffab37d7f3f6 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -142,6 +142,13 @@ static const struct dmi_system_id button_array_table[] = {
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



