Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023592;
	b=fv2I8VYbKZQX0MXipaGM1GaYHmR94T++VWIoLz3EgAM6JSriNU7/0/4wexclJw3caAWZ
	 St4HHL9VfGvgheUPNexbvKNcYoP1lGDCDIkVCWekpoVw8Nw8A1wxivTIqOoTBhghm4Qhs
	 t00JdTmiIxWqlvnCpiWjw9Aawr0ZZVtsgJxwCqkGef0gRw/+iO0aXleIl8F7dilvIZB+U
	 belGkrvItmwBwDCvVA1exK9DUTpW6OLZu/JTgneebEIuiZj1HjE5W/eJGst94f+p13Jq2
	 isVfRv+bdyxSE2u8bSvvaYmPYkMJlK3yyJgPXhzf7RyDPe1q5B/VKCD+7ZHBQN9mThg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023592;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y3MA96MwX7vPvaQFj1Y4wiilzJTwLQbDRzHq9tzXhuQ=;
	b=BWigs9TB3GzsYGrBnKh6MLvDaerP12zoVqiAMvSf19SGrEpFmONx6ZeOD1A0gznVrnsf
	 d7ToXbqIyzvSmI0wNE5L5+achbHHnwHAZ6/aIcEqGZyp7jNc9IAEYbuLTEjk97s8745j6
	 LCdU55hmUSOHe+7naVwVuYkwZkC5VTsl92p00/toF6l9tvUNE+ADuivOBD6FmyDhyMFjA
	 WBIC7Ytt3xfOSmpWlLjzX2f0Kp2EbMUWroluD2BRWBfiKUIO/27k/0M3/BLozF9WmDDum
	 OLNpPkixxZvqcfxkKNJlxV4t9iIRDptdyn6A98zyVitdlk8SaL8lTd9S973klx49+sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ysBSpZjA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE4F606A332;
	Wed, 18 Nov 2026 17:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ysBSpZjA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C301F000C5;
	Wed, 18 Nov 2026 17:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023592;
	bh=Y3MA96MwX7vPvaQFj1Y4wiilzJTwLQbDRzHq9tzXhuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ysBSpZjAxtZpYF7JZNZZhZOZLCwMG8JRXpqmTrMgHKqyUxytQSrlaYOIShD6EThzJ
	 JyGYmYN+ZyIkv3QL4iN0vmgEPGU8zHxNZtRWCqH+y461mGc5pzkYvl5vw1wYnX8R8q
	 XT8DBlzFE54xIP6B999vyg67M4nYWi6vIe++kVBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Armin Wolf <W_Armin@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0422/2151] ACPI: fan: Fix memory leak due to leftover devm_kcalloc() argument
Date: Wed, 18 Nov 2026 15:35:57 +0100
Message-ID: <20261118150137.426725770@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 2cf65d00347005eccf9a24801783377d7f920021 ]

An ACPI device object's dev field in passed as the first argument to
devm_kcalloc() in acpi_fan_get_fps() which is incorrect and leads to
a memory leak on driver probe errors and removal because the driver
is not bound to that ACPI device.

Address this by replacing that pointer with a pointer to the device the
driver is actually bound to.

While at it, drop a redundant error message after a memory allocation
failure (that also gets printed relative to the ACPI device).

Fixes: d91a1d129b63 ("ACPI: fan: Use platform device for devres-related actions")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/14089663.uLZWGnKmhe@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/fan_core.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/fan_core.c b/drivers/acpi/fan_core.c
index 46e7fe7a506d5..6cdbbd4253f6f 100644
--- a/drivers/acpi/fan_core.c
+++ b/drivers/acpi/fan_core.c
@@ -259,7 +259,7 @@ static int acpi_fan_speed_cmp(const void *a, const void *b)
 	return fps1->speed - fps2->speed;
 }
 
-static int acpi_fan_get_fps(struct acpi_device *device)
+static int acpi_fan_get_fps(struct device *dev, struct acpi_device *device)
 {
 	struct acpi_fan *fan = acpi_driver_data(device);
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
@@ -279,11 +279,8 @@ static int acpi_fan_get_fps(struct acpi_device *device)
 	}
 
 	fan->fps_count = obj->package.count - 1; /* minus revision field */
-	fan->fps = devm_kcalloc(&device->dev,
-				fan->fps_count, sizeof(struct acpi_fan_fps),
-				GFP_KERNEL);
+	fan->fps = devm_kcalloc(dev, fan->fps_count, sizeof(*fan->fps), GFP_KERNEL);
 	if (!fan->fps) {
-		dev_err(&device->dev, "Not enough memory\n");
 		status = -ENOMEM;
 		goto err;
 	}
@@ -341,7 +338,7 @@ static int acpi_fan_probe(struct platform_device *pdev)
 		if (result)
 			return result;
 
-		result = acpi_fan_get_fps(device);
+		result = acpi_fan_get_fps(&pdev->dev, device);
 		if (result)
 			return result;
 	}
-- 
2.53.0



