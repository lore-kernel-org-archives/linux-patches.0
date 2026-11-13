Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591362;
	b=BWPoVhGBdHnSSvW3ieUsTDNSeyIRcuhrZkYBhET/+UlVdHwL3c+t5bgvpC7Amxz+22Fv
	 KhdNyz3TQQsOzogFX9vMz6JMr7i2cx3+mKoKok2UrDXtnzZpRyUo117KzY+QdUGjIqIYZ
	 r0RMhV9+8L0wgpGpIbP0cOx/4kl2MGnQwRJfwmEnZ5GYQYt5gVMVl7vPLrK0OW9swXt1y
	 HgbLT8fNwz+ioU7vla965jNAgZdOoTvTDqhSE8bEsIe0EgMkH4P0RBRXjmAhEhhfhN38y
	 tWljH8kxi6vLl+K7NP7W387BuXkcPXI5hf2hYcS8KLDIAa8fu5AlQsYYMLWpkjSpl/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591362;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=hvfSEX+bree0qF4acFll7iHw+6zyZRJE9pA65aa4N4I=;
	b=N3x6dWgt0CSmOlSE6zyl3heinA3r/xJwquqtmAsQBCEzOxeZTVwn3helAiS//iPiPzNG
	 VOiBqQIb02pwHhyzX0DtRN0pTbD297IJri3u1YWyd9CiG/IVk2esw05N8usYqy6IyUeu4
	 fisU+6YLGSTRG4GJE4MKByPZAXsOErXpOsZHzguYG2XYf/OLTr35JVph/8hV9f2kPgaPC
	 7PautOSaKTSrXJ+wm2MpNQ9/trp3lY0UhNlZApARJbf0mhXfTewfLqabuyQ+wpRVeGm/6
	 liyZki4iHBJ/XLmIxodg4H+AbkuTtzqdgDkPW8/azyEQlDySOxSfTaE8CkZxBrgpHUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2uXHJUhR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2658606B22B;
	Fri, 13 Nov 2026 17:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2uXHJUhR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CFF41F000C4;
	Fri, 13 Nov 2026 17:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591362;
	bh=hvfSEX+bree0qF4acFll7iHw+6zyZRJE9pA65aa4N4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2uXHJUhR0PadL8o7vRhHipwqxLwjhcJ64GfAdBdGwYwP4PiZH80XMousy21j9bM6U
	 T9qgR0GAw2r00DiTW/+Mf/gIS4Mvu40xcMD3Y6G3Zoyljc5+m2uostqrc1NTlvHLXo
	 huQVz0xk3ow0ueFudsLMU+lAtwI1c6lUHpl1kqUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Daniel Scally <dan.scally@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 465/670] platform/x86: int3472: Fix uninitialised variable warning
Date: Fri, 13 Nov 2026 10:50:29 -0500
Message-ID: <20261113153827.709138205@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: retained return ret instead of upstream’s return 1 to preserve existing callback success behavior ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/int3472/discrete.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/platform/x86/intel/int3472/discrete.c b/drivers/platform/x86/intel/int3472/discrete.c
index 9e69ac9cfb92c..06191446e38b1 100644
--- a/drivers/platform/x86/intel/int3472/discrete.c
+++ b/drivers/platform/x86/intel/int3472/discrete.c
@@ -237,7 +237,6 @@ static int skl_int3472_handle_gpio_resources(struct acpi_resource *ares,
 	u8 active_value, pin, type;
 	union acpi_object *obj;
 	struct gpio_desc *gpio;
-	const char *err_msg;
 	const char *func;
 	unsigned long gpio_flags;
 	int ret;
@@ -283,7 +282,8 @@ static int skl_int3472_handle_gpio_resources(struct acpi_resource *ares,
 	case INT3472_GPIO_TYPE_POWERDOWN:
 		ret = skl_int3472_map_gpio_to_sensor(int3472, agpio, func, gpio_flags);
 		if (ret)
-			err_msg = "Failed to map GPIO pin to sensor\n";
+			dev_err_probe(int3472->dev, ret,
+				      "Failed to map GPIO pin to sensor\n");
 
 		break;
 	case INT3472_GPIO_TYPE_CLK_ENABLE:
@@ -292,7 +292,7 @@ static int skl_int3472_handle_gpio_resources(struct acpi_resource *ares,
 		gpio = skl_int3472_gpiod_get_from_temp_lookup(int3472, agpio, func, gpio_flags);
 		if (IS_ERR(gpio)) {
 			ret = PTR_ERR(gpio);
-			err_msg = "Failed to get GPIO\n";
+			dev_err_probe(int3472->dev, ret, "Failed to get GPIO\n");
 			break;
 		}
 
@@ -300,19 +300,22 @@ static int skl_int3472_handle_gpio_resources(struct acpi_resource *ares,
 		case INT3472_GPIO_TYPE_CLK_ENABLE:
 			ret = skl_int3472_register_gpio_clock(int3472, gpio);
 			if (ret)
-				err_msg = "Failed to register clock\n";
+				dev_err_probe(int3472->dev, ret,
+					      "Failed to register clock\n");
 
 			break;
 		case INT3472_GPIO_TYPE_PRIVACY_LED:
 			ret = skl_int3472_register_pled(int3472, gpio);
 			if (ret)
-				err_msg = "Failed to register LED\n";
+				dev_err_probe(int3472->dev, ret,
+					      "Failed to register LED\n");
 
 			break;
 		case INT3472_GPIO_TYPE_POWER_ENABLE:
 			ret = skl_int3472_register_regulator(int3472, gpio);
 			if (ret)
-				err_msg = "Failed to map regulator to sensor\n";
+				dev_err_probe(int3472->dev, ret,
+					      "Failed to map regulator to sensor\n");
 
 			break;
 		default: /* Never reached */
@@ -331,9 +334,6 @@ static int skl_int3472_handle_gpio_resources(struct acpi_resource *ares,
 	int3472->ngpios++;
 	ACPI_FREE(obj);
 
-	if (ret < 0)
-		return dev_err_probe(int3472->dev, ret, err_msg);
-
 	return ret;
 }
 
-- 
2.53.0



