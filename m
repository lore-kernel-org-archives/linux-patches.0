Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046830;
	b=rxnCX1hcj/luklBgBRAmDAKONsWXh6dcSa1pNH0N8SniEFZ6p7SpHP62yY7HJ+IJ3Xsy
	 ykZXGrOHn6EQvamcK2ywiIsomi9PxVwPCbU9yvGDRyLV7n31v+fTLmxi8KPsQwydhqOEP
	 Y06KvXI/7/DzliYO0aHyTsqebHq0wCAtsi9UrfzMieu55tKvsMkDxBzMq+8BwY8ieGMxR
	 pIPS3Wfu/+yZ9W0nLWauELJ1RJQGGByphFs972uWHSZxGQ53Rav+I9J0f2ebsaLKIsukv
	 67fc96P6NMEJUZ/uJ8Q2ix1/SN/3If0fN3TfHgKm1XEuIsYpFKvy0ZaSKwmi4DHcwOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046830;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=uKYMU1BXaNLQaYoz0Yq20CP5fQdQoaFtwUBOWAXna9A=;
	b=i2BhE+PbZwRc64d52w1FDCUvJyjEWpStg1DQmN9IY6mubSJsKctfq/FhiRss6Wms0AWX
	 BqOBTitK78Qj+rxrT23vaK8pDPnEk0fwCZfDg+eoRHtoy3ipwDEYFuS/VORmzwwfZKL4o
	 YrrNvYRxYRyP1kzQvjBdDVgoC1tfAwqUqKl5QF0GZsJAzf6X0CJrmqeD+MWefyBuAy3lU
	 oi9S8JzXt+PK74GoikfQc6jCibK6v0qVUPOqH6Ts7fe7HMzrehM/S9JTGx9sxxv1O/oZe
	 SrE4AVz/bN0rgqJ7ZKg65qo6uJnwhavIl/Fyd323c9SVusr9YEuL1CN8APBL/eMQbDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fVbXDfV9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28BC7606A331;
	Thu, 19 Nov 2026 00:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fVbXDfV9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B55C1F000C7;
	Thu, 19 Nov 2026 00:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046830;
	bh=uKYMU1BXaNLQaYoz0Yq20CP5fQdQoaFtwUBOWAXna9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fVbXDfV9+NrmQy15weEZnou0fRxfZHwMb4YJqqi/VzYIY+BJODIvDsS9q/yNmkxEX
	 aygNjRGRj8UC84rdx+BtemCi43qXUcWdIoCrt3k0LaBUKfZo8QmlznkixhGeT8gljt
	 sqNFltNuRAiqtKCEp5HEIgik7kgk6W7SdE5HM3UM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Daniel Scally <dan.scally@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1381/2857] platform/x86: int3472: Fix uninitialised variable warning
Date: Wed, 18 Nov 2026 15:40:15 +0100
Message-ID: <20261118150251.097540459@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 70e6384fe0f4cf9768944f81924f6c1478b0ce43 ]

Fix a compiler warning about an uninitialised err_msg variable by printing
the error where it is handled:

drivers/platform/x86/intel/int3472/discrete.c:440:24: warning: ‘err_msg’ may be used uninitialized [-Wmaybe-uninitialized]
  440 |                 return dev_err_probe(int3472->dev, ret, err_msg);

Fixes: 5de691bffe57 ("platform/x86: Add intel_skl_int3472 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Ricardo Ribalda <ribalda@chromium.org>
Acked-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Reviewed-by: Daniel Scally <dan.scally@ideasonboard.com>
[ sashal: adapted error reporting to the older GPIO handling and helper APIs while preserving the callback's existing return convention. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/int3472/discrete.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/platform/x86/intel/int3472/discrete.c b/drivers/platform/x86/intel/int3472/discrete.c
index 0f16436e5804b..57ae1afe951af 100644
--- a/drivers/platform/x86/intel/int3472/discrete.c
+++ b/drivers/platform/x86/intel/int3472/discrete.c
@@ -226,7 +226,6 @@ static int skl_int3472_handle_gpio_resources(struct acpi_resource *ares,
 	struct int3472_discrete_device *int3472 = data;
 	struct acpi_resource_gpio *agpio;
 	union acpi_object *obj;
-	const char *err_msg;
 	int ret;
 	u8 type;
 
@@ -255,27 +254,31 @@ static int skl_int3472_handle_gpio_resources(struct acpi_resource *ares,
 		ret = skl_int3472_map_gpio_to_sensor(int3472, agpio, "reset",
 						     GPIO_ACTIVE_LOW);
 		if (ret)
-			err_msg = "Failed to map reset pin to sensor\n";
+			dev_err_probe(int3472->dev, ret,
+				      "Failed to map reset pin to sensor\n");
 
 		break;
 	case INT3472_GPIO_TYPE_POWERDOWN:
 		ret = skl_int3472_map_gpio_to_sensor(int3472, agpio, "powerdown",
 						     GPIO_ACTIVE_LOW);
 		if (ret)
-			err_msg = "Failed to map powerdown pin to sensor\n";
+			dev_err_probe(int3472->dev, ret,
+				      "Failed to map powerdown pin to sensor\n");
 
 		break;
 	case INT3472_GPIO_TYPE_CLK_ENABLE:
 	case INT3472_GPIO_TYPE_PRIVACY_LED:
 		ret = skl_int3472_map_gpio_to_clk(int3472, agpio, type);
 		if (ret)
-			err_msg = "Failed to map GPIO to clock\n";
+			dev_err_probe(int3472->dev, ret,
+				      "Failed to map GPIO to clock\n");
 
 		break;
 	case INT3472_GPIO_TYPE_POWER_ENABLE:
 		ret = skl_int3472_register_regulator(int3472, agpio);
 		if (ret)
-			err_msg = "Failed to map regulator to sensor\n";
+			dev_err_probe(int3472->dev, ret,
+				      "Failed to map regulator to sensor\n");
 
 		break;
 	default:
@@ -289,9 +292,6 @@ static int skl_int3472_handle_gpio_resources(struct acpi_resource *ares,
 	int3472->ngpios++;
 	ACPI_FREE(obj);
 
-	if (ret < 0)
-		return dev_err_probe(int3472->dev, ret, err_msg);
-
 	return ret;
 }
 
-- 
2.53.0



