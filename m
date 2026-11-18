Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016181;
	b=vtiTK8+PtDrLqPX0va6CkZBFCYu3orEf+XbEzjdamc/vJ0nVQbkq2YwBuylETYaEHQ5A
	 hyYmWm6A5ijMwXFJNn/V7/U/8NTwWC+RjzE6tUTCIiPJi6AzAhm/BMr+pzrP0XunHh6c6
	 xKNCX8hd63c88bDwCOxngST8Vnouu6J6myODVrsKCmNrKZ8OH9MBAferrsSoj7MVcqCJt
	 7m7EvRtIEgTsXrcSXkzYMkN1eJ25PyU82LNROH6fs9TdKeEwitdzKZNVMNTq8qwSQiTMx
	 zZTwNw66wboplgc3NGyaV1ehycU9jSHPenOSW9auzdSKqP/o5IKz44lcGdEkFLTbBsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016181;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yHAFGtGGlt7jsczLJl6J6iTVU8uNfkagt2M4GZFF9Hw=;
	b=ojNJxBJX0WxSElH96WvP71Jr36gZKZ+WkOboqgTQHuwNv+8mjyAFU5PlQv5Jmz/g7pC3
	 O1W8bYx3SdkgfXB+DM2OROSSlhfdKd+h00O2N1NpdwGxIM+FR4AeZX9EpbrcvWgtHlIH/
	 43xmo+zR26tDpBnp4a8tdq/SgU1Zl4OJLyn0o7nG8lOKYfa4dCsr3GdP3gzgg4I6mpwkE
	 B9uXz/vP65V3q0D2pLMstLCkEE6imLbL9IgLcxi7VyO17a66Bh81WXgziqhfwBBwlXHKA
	 480Vs8HpzCVoKBaD9qorA2y3a8I1WAdQaVCM35PSRl3yHaf/Df1O9jZlnOB3BKPh+2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=II2Mr1e5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576F6606A325;
	Wed, 18 Nov 2026 15:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=II2Mr1e5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB471F000C4;
	Wed, 18 Nov 2026 15:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016181;
	bh=yHAFGtGGlt7jsczLJl6J6iTVU8uNfkagt2M4GZFF9Hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=II2Mr1e5SfqP213ZYCZnba/yAKL5DimQ4LLVIUbAyWch0RR7J2vYgy5aFh4uaHbVJ
	 FLDoi1Mx05rWZJQVmOH9qFgxWYfsnvhgCjSKyau1NsBEEq/f6oGhjudDAA/5wLNxK8
	 lvWUh8ggJkpu1DTAjp6zFb1yFAOnHOEyitVAqpUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Armin Wolf <W_Armin@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0439/2651] ACPI: fan: Fix memory leak due to leftover devm_kcalloc() argument
Date: Wed, 18 Nov 2026 15:27:59 +0100
Message-ID: <20261118150303.628033220@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 624d0736b581c..a31d7beca5d0a 100644
--- a/drivers/acpi/fan_core.c
+++ b/drivers/acpi/fan_core.c
@@ -284,7 +284,7 @@ static int acpi_fan_speed_cmp(const void *a, const void *b)
 	return fps1->speed - fps2->speed;
 }
 
-static int acpi_fan_get_fps(struct acpi_device *device)
+static int acpi_fan_get_fps(struct device *dev, struct acpi_device *device)
 {
 	struct acpi_fan *fan = acpi_driver_data(device);
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
@@ -304,11 +304,8 @@ static int acpi_fan_get_fps(struct acpi_device *device)
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
@@ -522,7 +519,7 @@ static int acpi_fan_probe(struct platform_device *pdev)
 		if (result)
 			return result;
 
-		result = acpi_fan_get_fps(device);
+		result = acpi_fan_get_fps(&pdev->dev, device);
 		if (result)
 			return result;
 	}
-- 
2.53.0



