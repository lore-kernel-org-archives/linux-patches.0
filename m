Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038141;
	b=fmFPBo5hWmP1ACn7qE9ecYwIhQXQh3PSxeURr743XBTKLEP2g1muN6agdss4MTe9gUkJ
	 V56TR2d7N98j885VEul5KDreZCG82OgcGtxm2Oqk9WZKqDsfl/mOmmidk5EOgT59x4SIg
	 ebZjcl6ANpimwAmqMMZG1aQ/zJwOEWsdLyrLRh+gtT4YM3DrOAYj2LI6gLucyOmqo9wve
	 Kl71drm9BJPZNhFNjQ+0vpEwhS2z5CLqOgWKPP4F2ajecaRttmYqDmZtd68AwCSbVEWm0
	 qzPeyiVjbWoUc6VQ67STrYYeMUqQMe4cR2PS6O86yh44XS26FTExvhL7NaeWmYfimDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038141;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=+XVDHpSrG8F/Wb+I8HXGDLqFiccJrWeliIe9z+pK10s=;
	b=pBOgSoZvtaduCANI3VvNiXvHQ+/QH2tkex22g3J8YPJLmN3xxwbAeU5HDI90uzIx9BDM
	 YlptaRuCB5u7nRMBcaTgp8WdgpQCVya1aYfYue4NQn3qpvMHTe4XxYv7Kyzc6CGH+/riN
	 ECvaiN5aLAX2DHySDiApI+dYxjfWLpDG1KoCSBZXswpKt0QiPrBY8cIqqf8a0fWFuvysB
	 AqismnfFxAqLh/IHhJQkr7Eqkv/GLJfFAGDcWGt011LS5hFHFb/o2gzyLs70yd4d2y90L
	 hLnlASqW40S3deiCyB0e8lc3R72tz/JNH5T8nJXP3ZuXi4Y5EA9TdkC2YLLDr814Tnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hwUufoj+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91410606A320;
	Wed, 18 Nov 2026 21:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hwUufoj+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F651F000C5;
	Wed, 18 Nov 2026 21:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038141;
	bh=+XVDHpSrG8F/Wb+I8HXGDLqFiccJrWeliIe9z+pK10s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hwUufoj+YE1+BAr3ibreVhPM6yEeWR+DcmZ1Sf4lPkXKbIUipjjORxS/75v1FIy4N
	 q7gIW3JOpx0kO4NU0UUSGAMSnmkwz+khCzUnNqUQQYxvLeId0G+ivF8jYR5jyv1+3+
	 4rMXjUolo1MSlACi90sjm+8O4jrwU79ZyEm/j45g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Daniel Scally <dan.scally@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1639/3318] platform/x86: int3472: Fix uninitialised variable warning
Date: Wed, 18 Nov 2026 15:37:41 +0100
Message-ID: <20261118150410.929073904@linuxfoundation.org>
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
[ sashal: Adapted error reporting to the four direct GPIO helper paths while preserving the existing return ret behavior. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/int3472/discrete.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/platform/x86/intel/int3472/discrete.c b/drivers/platform/x86/intel/int3472/discrete.c
index d56f79043f5e2..d18678b06616c 100644
--- a/drivers/platform/x86/intel/int3472/discrete.c
+++ b/drivers/platform/x86/intel/int3472/discrete.c
@@ -156,7 +156,6 @@ static int skl_int3472_handle_gpio_resources(struct acpi_resource *ares,
 	struct acpi_resource_gpio *agpio;
 	u8 active_value, pin, type;
 	union acpi_object *obj;
-	const char *err_msg;
 	const char *func;
 	u32 polarity;
 	int ret;
@@ -202,25 +201,29 @@ static int skl_int3472_handle_gpio_resources(struct acpi_resource *ares,
 	case INT3472_GPIO_TYPE_POWERDOWN:
 		ret = skl_int3472_map_gpio_to_sensor(int3472, agpio, func, polarity);
 		if (ret)
-			err_msg = "Failed to map GPIO pin to sensor\n";
+			dev_err_probe(int3472->dev, ret,
+				      "Failed to map GPIO pin to sensor\n");
 
 		break;
 	case INT3472_GPIO_TYPE_CLK_ENABLE:
 		ret = skl_int3472_register_gpio_clock(int3472, agpio, polarity);
 		if (ret)
-			err_msg = "Failed to register clock\n";
+			dev_err_probe(int3472->dev, ret,
+				      "Failed to register clock\n");
 
 		break;
 	case INT3472_GPIO_TYPE_PRIVACY_LED:
 		ret = skl_int3472_register_pled(int3472, agpio, polarity);
 		if (ret)
-			err_msg = "Failed to register LED\n";
+			dev_err_probe(int3472->dev, ret,
+				      "Failed to register LED\n");
 
 		break;
 	case INT3472_GPIO_TYPE_POWER_ENABLE:
 		ret = skl_int3472_register_regulator(int3472, agpio);
 		if (ret)
-			err_msg = "Failed to map regulator to sensor\n";
+			dev_err_probe(int3472->dev, ret,
+				      "Failed to map regulator to sensor\n");
 
 		break;
 	default:
@@ -234,9 +237,6 @@ static int skl_int3472_handle_gpio_resources(struct acpi_resource *ares,
 	int3472->ngpios++;
 	ACPI_FREE(obj);
 
-	if (ret < 0)
-		return dev_err_probe(int3472->dev, ret, err_msg);
-
 	return ret;
 }
 
-- 
2.53.0



