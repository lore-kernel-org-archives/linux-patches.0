Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829760;
	b=bbGyYhW+L7T2DUMFrZjQpsZ3591SJ1PLnGGCF2sg4ymzLmgNMH6qa75ncVBoClHROyik
	 XdRJSxZ+wwwQbJkOKasGwjmwqM7THXk+cgVWOdHNVlQYFaQYSeuYiOqueUy8QUdK3aInx
	 IWTsOiMrbWnaKNyYRo/tS46c+0qiFetJjQDbS5umu6q95AOlxzPpz9x6rSMfXs4QJ7ZY9
	 4vNm/JgffvwgEVLcCsGL6o4UdXquP79YSckfQzzoCWCBaUuQg4ZjHAdc/2Lkf3v1ZENln
	 6CaC8rC8ciIp+ASegoMpX9HaTFgnh+byHmIpwtQnZAWxaIaU7PWFCYVV4MFe4PsHRCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829760;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t1cpzihKbDP9XBt0e5RIRRxsh7rIwWRNI8NU3p+gyAI=;
	b=Bbi8/IOrrfrnM1/HBvKGuw0QfeckVsj9tt4FDvYIgPLzTdZeYLySsDIne+eoGoKLbS+l
	 yBTQ9bqk5oiQgaOZePOLm+QUtg+8PyWbeJAIMa2C3Aqu4so9hZ+JRQTbPjPwhGVmo2xzV
	 YAZwVy8WjHYiJOFQ9HzaULDJsjEj2ulE/0WRex60rg/+cn+tg4G6tTY+d1BtOYiSnNJSs
	 IMzMg/1bsAtG6idfff8Lzpp96+k4f1sMM5Qg7U/phHUu1YQfOYcxM6PwzHAvGrlKgGzwO
	 gppHosnSM3FFJhLYHyPuIVUsP4J7vcv5PoKA7Fa1gBfaO6xODBs1gjbyQZHuIpZ+ISQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WGjN8L1c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9729606C5AD;
	Wed,  4 Nov 2026 22:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WGjN8L1c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF1E1F000C1;
	Wed,  4 Nov 2026 22:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829759;
	bh=t1cpzihKbDP9XBt0e5RIRRxsh7rIwWRNI8NU3p+gyAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WGjN8L1c/LpeGd6+RRWGKeYy8sPsZ1Cwv+Z9yRzO6LU7gev7F3W0mb+mZqvGZmqc9
	 ft9qFcgYHd+oWT/y4T+ferI3Vdwb6PX7meBUflwqxJwTzoqcmcNKTUs9knZdPjEkn3
	 bTIwFmlPT8BhfpJGVj+Cy3OY7nNsxCerzrWoSs2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcos Paulo Medeiros <maarcospm1996@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0325/1005] ACPI: video: force native backlight on Acer Nitro AN515-46
Date: Wed,  4 Nov 2026 16:00:58 -0500
Message-ID: <20261104211053.053912256@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcos Paulo Medeiros <maarcospm1996@gmail.com>

[ Upstream commit 525ba51157ac6e1772b5412eae26b20dd7ef8bda ]

The Acer Nitro AN515-46 is a hybrid graphics laptop whose internal
panel is driven by the AMD GPU (Radeon 680M); the discrete NVIDIA GPU
only drives external outputs. The firmware nevertheless advertises the
NVIDIA WMI EC backlight GUID, so the backlight type resolves to
nvidia_wmi_ec. The nvidia-wmi-ec-backlight driver however fails to
probe ("EC backlight control failed: AE_NOT_FOUND") and, since the
backlight type is still nvidia_wmi_ec, amdgpu skips registering its
own backlight device. The result is no backlight device at all,
leaving the brightness keys and the desktop brightness slider
non-functional.

Booting with acpi_backlight=native makes amdgpu register its backlight
interface and brightness control works. Add a DMI quirk to use the
native backlight on this model by default.

Signed-off-by: Marcos Paulo Medeiros <maarcospm1996@gmail.com>
Link: https://patch.msgid.link/20260727132151.12792-1-maarcospm1996@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 2a562cb425081..2b48b02f8a953 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -917,6 +917,14 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "OMEN by HP Gaming Laptop 16-n0xxx"),
 		},
 	},
+	{
+	 .callback = video_detect_force_native,
+	 /* Acer Nitro AN515-46 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Nitro AN515-46"),
+		},
+	},
 
 	/*
 	 * x86 android tablets which directly control the backlight through
-- 
2.53.0



