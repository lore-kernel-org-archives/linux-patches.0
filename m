Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034485;
	b=xm3ykRjlfAffJ3EOHqgHqo4113IevonJMrtedugRjoKzfozILp0IKTRcw/gxaZWcXn1f
	 AGk1XteAjvosraBmluph+IqEGtb7ROBaAwsAL7RlChk1lAcHy0Xw7uax1UYlAUv3AT6z4
	 vh2+VftsyY9uEo+2fjJD/FRR9a43JQom/upoEVlqXh8fwO3WuB2YWVRj62GVhYpuywIvj
	 Rul2ZM4ppy/Yt5KfktEXwG5KFVkk9R5Z6kdjPYxCCetZAX7r+hMlPXAfigF/volsutpkF
	 /nqJbfiMhs2QITsuU7ldO2fYmFwuBVmo7MR2XIvylx5HwND3MXvx6ox4FNZs1NLnV0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034485;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=WPUAiBs9m1bcPZPXQJVYVFeaBEiMqb8JegqMh+Uww0s=;
	b=r3biKnO64TlZxaO4OagOPtJGma32DNaYx6Lw+9KJgaNia+Ag9JslGE8VWtQFXsHKX9R9
	 vT/8EtjzGUI+VWaB3zB0eJOSQzxVG2LMBKL51wl260MED0p80/3eiG9p/TkoFoJzwZQQn
	 cThhQa0HMZHxa7doG52SqDSjOPs35rCamfXKz0TF5loeUfxxzZhDbwOhRiQIMuURndc+8
	 zPkZCwDihoTZRtQqxT73iq7L+gCr/MZbiz6tM03wMyxcABxss7pPwE2mBnePRL6eK2nRk
	 41ysZB4zjMj7IKtS1UAAs2DbjLM6OM0niWqHy3S5nQ6Q5mj2uwbCcYXE9VLvpLxNxkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zQvs0qRw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B8A606A31C;
	Wed, 18 Nov 2026 20:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zQvs0qRw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9001F000C4;
	Wed, 18 Nov 2026 20:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034484;
	bh=WPUAiBs9m1bcPZPXQJVYVFeaBEiMqb8JegqMh+Uww0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zQvs0qRw5uBTZIQfmRNci2b1TFUjpmNLdlIPhBHiO8aSHF7eAwIy5Hn3Umh2D/cSG
	 HgWOk4QbsFf6iLlQjxwLh61Oh7XpgIpk0j8bok/6DPwPIGrHVA+DErV8j8MswvEgN6
	 iWGBu8wI1lwCaKgYSpzylDyzRcCruPGExMg6VlJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Haarmann <julian.haarmann@student.kit.edu>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0379/3318] platform/x86: lenovo/ymc: Only match lower byte in WMI lid switch query response
Date: Wed, 18 Nov 2026 15:16:41 +0100
Message-ID: <20261118150327.623005915@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Haarmann <julian.haarmann@student.kit.edu>

[ Upstream commit bbc497b5231829d32c3a53b6e66be1add76c0064 ]

On newer Lenovo Yoga devices like the "Yoga 9 2-in-1 14IPH11 - Type 83SE",
the hinge switch WMI query returns extra data in the upper bits
(e.g. 0x50001 laptop mode, 0x50002 tablet mode, ect.).

The driver previously checked for exact matches (0x01 laptop, 0x02 tablet,
ect.) causing newer switches to not work.

Mask the WMI query result to only match the lower byte and ignore upper
bits.

Signed-off-by: Julian Haarmann <julian.haarmann@student.kit.edu>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260614203235.235724-1-julian.haarmann@student.kit.edu
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/lenovo-ymc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/lenovo-ymc.c b/drivers/platform/x86/lenovo-ymc.c
index bd9f95404c7cb..4e3f7d4424610 100644
--- a/drivers/platform/x86/lenovo-ymc.c
+++ b/drivers/platform/x86/lenovo-ymc.c
@@ -8,6 +8,8 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/acpi.h>
+#include <linux/bitfield.h>
+#include <linux/bits.h>
 #include <linux/dmi.h>
 #include <linux/input.h>
 #include <linux/input/sparse-keymap.h>
@@ -20,6 +22,8 @@
 #define LENOVO_YMC_QUERY_INSTANCE 0
 #define LENOVO_YMC_QUERY_METHOD 0x01
 
+#define LENOVO_YMC_STATE_MASK GENMASK(7, 0)
+
 static bool force;
 module_param(force, bool, 0444);
 MODULE_PARM_DESC(force, "Force loading on boards without a convertible DMI chassis-type");
@@ -85,7 +89,9 @@ static void lenovo_ymc_notify(struct wmi_device *wdev, union acpi_object *data)
 			"WMI event data is not an integer\n");
 		goto free_obj;
 	}
-	code = obj->integer.value;
+
+	/* strip upper bits (e.g. 0x50000) on newer devices */
+	code = FIELD_GET(LENOVO_YMC_STATE_MASK, obj->integer.value);
 
 	if (!sparse_keymap_report_event(priv->input_dev, code, 1, true))
 		dev_warn(&wdev->dev, "Unknown key %d pressed\n", code);
-- 
2.53.0



