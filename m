Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7AA85226AE;
	Wed, 30 Sep 2026 17:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791086; cv=none; b=lG37Z5HVWDQl40rIc42cy+1c0dtflSkS59fkcYVgy9xtdISNYwSq8UnNPpb8yMK6I3jmS3GF6D7AL0EmnDU9w7r+FJrQMnMFtfIH5pNY8GM07pcOD+42Brs0XjarN7X4VJMm/0nzh80KgZdVLnzE3dYlt70089npr1ydSpLi2As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791086; c=relaxed/simple;
	bh=ib4HWV/TEv0JbzI5kzDHN/oaCplVOtVtwLWYBck2XmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GsQ+TaG+NFaN03gfjZnxZ73jlgCXpoXSYONrDwUXDhJPUN1BNheimNmQzJaedelxc9mBoIkh5DpnJBWK0CZi5WaHQxmRYIgsYKNeyl7F7srQcRWO+iNiP0NdUwwTdIwXNz+qbIdDtgAzKykkL4Abtm3F/XyB7jmE2poCSTgkBsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iKzbtt1a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iKzbtt1a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16381F000FF;
	Wed, 30 Sep 2026 17:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791085;
	bh=aN6zv5f3YizYtz7lD8HAJ9VNudT65dUD9drh+ad7MCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iKzbtt1a4tyDQsk2Huu2uaZouXdI/YkJfmKdqUlBLJDnYp3zUWxVpDXLQzaJrfnMV
	 Bs80SO+VW+rp6qFGgtPmXwukMvzsE9tMk8Uz4cgPdxewicbwSQ420HmlFWYRUjia0w
	 tkPKQo332K0dyG1lVPRtojiQPVzuvSu65mlgXpWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Metchev <nikolaymetchev@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 137/752] platform/x86: intel-hid: Add HP ProBook x360 440 G1 to button_array_table
Date: Wed, 30 Sep 2026 17:20:07 +0200
Message-ID: <20260930152401.142651580@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b19cd6ca4e2f5..5326ea1e3ba5b 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -123,6 +123,13 @@ static const struct dmi_system_id button_array_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Surface Go 3"),
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



