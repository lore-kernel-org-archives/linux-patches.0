Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062743;
	b=GaP3LTCkd+03Tvr0Id99Pg5vCyPoeOUTz3f5ffS7Ur9r1QQR1GTZjLJxjisGC/bZ4CZ0
	 ar4Shgv61CnQahGanzmnSXzWpb0ssEbQuWAjUpXMds6WlzaoWJEtllizGz9h+cI662BW0
	 kW6SfbqEjiGQI/8r23p6t+zSV3D5IUSnCYbosqj39z2JNQt6ySYCN/mRCt4soRucuP6YD
	 EFardzsUFds76jf61p4tSjucN5HhKz7hrj6qGf4i8KuGj8Knw23s/2ZBXJvVajOUaeiQS
	 VL7/gkk/XUYjvCcXZnLl5sJYR3GmHDeDd9blSldOtZeLBlVOupKTwHbm0zaAN1Ue4fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062743;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=dOYZrOlRUWixii3/olGHr16KS6PJGLgsxlPACRyCG5o=;
	b=Fi6LKXx3lHC14I1gVLjYKl0QBdLb3CkVQztBPdSu9H9fMB0DUw5EYFz3zCKbcLUpVigD
	 Uh58wIM9kBhP5Z/Sg/kG5cMlme6jzlb/vIx60b/T0IcQeEF/NjH3J2arpAOQLKb0LfmNF
	 wBZEhmBKAFtEAKFKPAC1pnvGlEkfSydO1Y/iB8roBcukPdenK+X22DutD/X4BR1OAImHD
	 DhltFWJf1sNTd1mXvh4E0XOLuUxRPxWeDIjZl4i+M4RpXwvuogqEPSGhVWhqEkOQ2p06y
	 cyfcr75uytPGBVCsvJEttDhNUsK5A4Q52hKSu22U1Hf7Ls4mXCrFs97LRS/tc1GJ0ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QaRBrjPR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB19606A32D;
	Sat,  7 Nov 2026 14:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QaRBrjPR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060CC1F0089F;
	Sat,  7 Nov 2026 14:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062743;
	bh=dOYZrOlRUWixii3/olGHr16KS6PJGLgsxlPACRyCG5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QaRBrjPRuFeyZtJ6BTD1DRSe8jOt5ylTHL7+4uFgUCTiMxl7xnp9JQwytPiuP5hKH
	 hAZESD3JKb2QH5O0dW01sCDl6Nsiqas9hYZ+2PqXxBy1LFh8lNW1vQKuZQoaCeXfoW
	 InkhAQ3osyFTtjPfE72r9DQBHtnUFqPctBbz8//8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Daniel Scally <dan.scally@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 059/869] platform/x86: int3472: Fix uninitialised variable warning
Date: Sat,  7 Nov 2026 08:45:41 -0500
Message-ID: <20261107134854.141286830@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/int3472/discrete.c | 25 +++++++++++--------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/platform/x86/intel/int3472/discrete.c b/drivers/platform/x86/intel/int3472/discrete.c
index 1505fc3ef7a85..96c33ba80002f 100644
--- a/drivers/platform/x86/intel/int3472/discrete.c
+++ b/drivers/platform/x86/intel/int3472/discrete.c
@@ -280,7 +280,6 @@ static int skl_int3472_handle_gpio_resources(struct acpi_resource *ares,
 	unsigned long gpio_flags;
 	union acpi_object *obj;
 	struct gpio_desc *gpio;
-	const char *err_msg;
 	const char *con_id;
 	int ret;
 
@@ -326,7 +325,8 @@ static int skl_int3472_handle_gpio_resources(struct acpi_resource *ares,
 	case INT3472_GPIO_TYPE_HOTPLUG_DETECT:
 		ret = skl_int3472_map_gpio_to_sensor(int3472, agpio, con_id, gpio_flags);
 		if (ret)
-			err_msg = "Failed to map GPIO pin to sensor\n";
+			dev_err_probe(int3472->dev, ret,
+				      "Failed to map GPIO pin to sensor\n");
 
 		break;
 	case INT3472_GPIO_TYPE_CLK_ENABLE:
@@ -336,7 +336,7 @@ static int skl_int3472_handle_gpio_resources(struct acpi_resource *ares,
 		gpio = skl_int3472_gpiod_get_from_temp_lookup(int3472, agpio, con_id, gpio_flags);
 		if (IS_ERR(gpio)) {
 			ret = PTR_ERR(gpio);
-			err_msg = "Failed to get GPIO\n";
+			dev_err_probe(int3472->dev, ret, "Failed to get GPIO\n");
 			break;
 		}
 
@@ -344,13 +344,15 @@ static int skl_int3472_handle_gpio_resources(struct acpi_resource *ares,
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
@@ -360,7 +362,8 @@ static int skl_int3472_handle_gpio_resources(struct acpi_resource *ares,
 			ret = skl_int3472_register_regulator(int3472, gpio, enable_time_us,
 							     con_id, second_sensor);
 			if (ret)
-				err_msg = "Failed to register regulator\n";
+				dev_err_probe(int3472->dev, ret,
+					      "Failed to register regulator\n");
 
 			break;
 		default: /* Never reached */
@@ -383,11 +386,11 @@ static int skl_int3472_handle_gpio_resources(struct acpi_resource *ares,
 	int3472->ngpios++;
 	ACPI_FREE(obj);
 
-	if (ret < 0)
-		return dev_err_probe(int3472->dev, ret, err_msg);
-
-	/* Tell acpi_dev_get_resources() to not make a copy of the resource */
-	return 1;
+	/*
+	 * Either return an error or tell acpi_dev_get_resources() to not make a
+	 * copy of the resource.
+	 */
+	return ret < 0 ? ret : 1;
 }
 
 int int3472_discrete_parse_crs(struct int3472_discrete_device *int3472)
-- 
2.53.0



