Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060894;
	b=rO1qqpLINwGdGwO9lntmCDeA5Gdt8s6MSiuzd5uGkfwDV4oyea/BbrBlvgVeLuHrN3Ug
	 UFZalanBBQotgJR20dNeUnNHYuCJo5EL9Rrehb+oPDxHP4rYtIHFExq7Hc7g2PsdODGQo
	 240hot2ZwMmhVqhtR0TwnMlxj7bkV/dzFuY+TGrOkQ1jXTaE52z1PwasceewWCOD9Ja+C
	 7ntBboM5xXeiW8iTJauzGa16E1pLmO6wujrUTguCMUiHmpXbReJY5sG4CzOdhUjQUSY7j
	 9vpDIXz86tOonDUuzzgVLjzlKUGdsrUu7bjSWSPewjXX7bK4FCKPGeClLHQdyazbEDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060894;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BNtf0R54clMLcNnuRoZUQC0LNFnWNvco38EK4qK4McQ=;
	b=NDD+z86pxcSrAQMZhIcDkexpTo4/b21rELDqa1qRlIfXu1BH/RAXoL1esIYNoVvwq6x6
	 UeYd4FTeSe9JKkwbbZ6cQ/cKAnntRLSYzyvz8rCTH6RfHCWKPTiVNZ13KuD7re2roQ5SN
	 1aM+zvjPAF5zmGRfCSD10BZQR5MLEowDQUnr9WedD9iOAcVHzkAl9WT9Z7l6c5xVqBmkP
	 6x6LyA+35OSiBCUbLSUVi3YUjToutt5fzHaw7uI1sSTT35nz6TubwIuskP+EjRb70kxqk
	 eFdQQcKHeodHKxZmShKF15ERBbNjJsKmvwZdx84U5lbJSOfi+92+JLl6XtJ+NpHN06g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dBuimt2j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D87606A326;
	Sat,  7 Nov 2026 14:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dBuimt2j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D791F0089F;
	Sat,  7 Nov 2026 14:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060894;
	bh=BNtf0R54clMLcNnuRoZUQC0LNFnWNvco38EK4qK4McQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dBuimt2jJf9Mqp+h3Gf3E/8a5O+XIli0Xd187F52yow5mifE5kt3dbN2hZ/TDobW+
	 0VPg1T5dhb71F61j1b8+Do8h8XGXoxa0rVoFGWwRQpjVG6VSp9Ed5nSwflJBPRYj3p
	 nmF0saWf8227TF1ArgcU62XOe0H7G/m8hJ1zXzuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcos Paulo Medeiros <maarcospm1996@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0269/1536] ACPI: video: force native backlight on Acer Nitro AN515-46
Date: Sat,  7 Nov 2026 08:38:05 -0500
Message-ID: <20261107135005.238474170@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



