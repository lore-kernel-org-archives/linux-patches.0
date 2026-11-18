Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029537;
	b=pME5MfFA7sxtQSuvtw6XAvX1vC0HRrSQz7tLi5PqT/K2NvFrYb+LpuRIFoGfvBnClz9G
	 Mv7jPH5jP9EyvMEhzCAylR0X/wYy1xPz6/I0LloeHByPWpDzFZoezbbUt16/jctBTFobC
	 0ux/Hk+4qT08E0UGvpQnsadAIs4ZiivuC/eZwmIFAF7nPJRSFR6F0i/6ZGz3al/3cE4fC
	 iLBVkvyaV67e+6uBJMru7vyVg3rhKFXN78MNRetJ4bwNbQfqP0cIIYXorrhu8gJ/MJsmX
	 IPMRaZ2Sdx+IuSJE5OmBwOir97ck7FYRsdpy8e/gyRjgjo0O8HMH0eI7sh8KLzCperg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029537;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kE0UYrKj8vfJB0GgWqBpS9Cx+tChdXpFF4RRHQlzz3g=;
	b=NUFuZXa24PczodtoloO7G/V+0FfzGFVEPfuwxa7cQ25e9YSLEEkVXNIixTfgPofyokgd
	 gnZ/PAhQux6C7K2YHIyukKZOmM64HsApXbVYR6y6J67o0anKnTzFT8WB/KybktCbQDfYt
	 x/nGBM6/RjfaKoITMrmcLt2iiIuj0nSkj9pNWwZ0Xa5dWyEqg+9+YKzp/xHPwPMBy00DU
	 lZEtaYPZ26F2xP2Z2jhvKZ1q0APbfOHkG8RaIJO7l0//QnB1mrAqtLRh40ML6WOHecTgo
	 66eXGD1DAOl6MPapCPLlI8h3yWvQvYSZF+s6rx4HHaYwDd/0agaDLS8zujw4Uuj65TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VN94kPPm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388F0606A31C;
	Wed, 18 Nov 2026 19:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VN94kPPm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 408D11F000C4;
	Wed, 18 Nov 2026 19:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029536;
	bh=kE0UYrKj8vfJB0GgWqBpS9Cx+tChdXpFF4RRHQlzz3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VN94kPPmlM4h6/VDpInqD2nVNJ4ZIqH9Lmet2mVb2RZTnug4fMwRCBX7Ms4/71/hY
	 uGT2B6XYlvurXeJEGVgGYPKB8mnpwlsabrgJZDVMdgYHdwqKSSO4qk2BXguiMhknwj
	 NsQbJaZnCzXfUb5R8pixLzMMwXvwwBLuvG6qUwCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Armin Wolf <W_Armin@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0386/1756] ACPI: fan: Fix memory leak due to leftover devm_kcalloc() argument
Date: Wed, 18 Nov 2026 15:41:53 +0100
Message-ID: <20261118150023.969059284@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 3d85bec8c3d1f..ec9f2503d9152 100644
--- a/drivers/acpi/fan_core.c
+++ b/drivers/acpi/fan_core.c
@@ -271,7 +271,7 @@ static int acpi_fan_speed_cmp(const void *a, const void *b)
 	return fps1->speed - fps2->speed;
 }
 
-static int acpi_fan_get_fps(struct acpi_device *device)
+static int acpi_fan_get_fps(struct device *dev, struct acpi_device *device)
 {
 	struct acpi_fan *fan = acpi_driver_data(device);
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
@@ -291,11 +291,8 @@ static int acpi_fan_get_fps(struct acpi_device *device)
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
@@ -351,7 +348,7 @@ static int acpi_fan_probe(struct platform_device *pdev)
 		if (result)
 			return result;
 
-		result = acpi_fan_get_fps(device);
+		result = acpi_fan_get_fps(&pdev->dev, device);
 		if (result)
 			return result;
 	}
-- 
2.53.0



