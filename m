Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053652;
	b=JG1J3LvAGato5BUCALzsMQqeLFy+7qpKmiFrWakKBxvTnc+fYqYoFVolHcEf/v8ppDkV
	 ANOr8Sv079nNYYqgn3QfgjbnrJDKP8VTxkCXQFxPUqj30JxVFpVuh+YOhpP9WMy2CjzBN
	 FWGSAPPs9230imAHUcEJn+mNmLDuXbXuQanYtadIIPxFe3BMwmPA9WSRME06LZHeyOBnP
	 ga58ds2Ft1OeKSId0i9COinDEoy1XLlgymVVxEKPnOhXW6jLxzaGHpcrwo2wQqM/bC04x
	 giUTpU0UbA/sIkrHmTpDRxZ1fzupoG/Yy5EL/FzJSdx6odPfqp7bmZGHoEJKKmGOHtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=txPR61jjmgA+jE4Di7Xc/uFhcceTbehgRijAyOovGzY=;
	b=oZLZUQErfmi80BF0LE9tCEjZwfzW0qkDVipQ1H8FJS851TnKJoNFDEgiOW+290HjPvfO
	 P2bTKjDMMVl6OGFkibUN3gnRLrFBPWWhzAz/teYWxtHfKE74nr+IN5feIPs3TUxWkgwxc
	 1VJHnLT8G+A4/tgBPIUQhxWgjOxHsQ1w3kknv5owiZSeTwvQoyimyv3aUOunCrQDmuSdO
	 A4Ffyg18pZgH1yigMfeHTg/ZVdOSbolMR13LPDEJWJh81YDlm7KFj8jOQJ00OQEn6NJRP
	 bywtZPYcLZSz4Cl6BAu+teAzNvmUM1BPMirOD2aZevpbaLGdFIAlWGgHfgV6ZPZl1eA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZMWZb929;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50DCB606A32C;
	Thu, 19 Nov 2026 02:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZMWZb929
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977461F000C4;
	Thu, 19 Nov 2026 02:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053652;
	bh=txPR61jjmgA+jE4Di7Xc/uFhcceTbehgRijAyOovGzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZMWZb929zLZZt9Q9jGcjgdwYqhwZ7OWr7Ot1JPLjtzI+WKan0seNgRQ1cIO8y3xmY
	 N2JyW3wDQiSvHsFiAVtrgEWKLp0sVU/VG3Z1bp1MPoIjh6QnMiMuJUGovlfXBgECxY
	 tpbTP8nxtfGUonf/ff1l3VFmIAnaLaoryPbmVaLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Daniel Scally <dan.scally@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0996/2214] platform/x86: int3472: Fix uninitialised variable warning
Date: Wed, 18 Nov 2026 15:44:32 +0100
Message-ID: <20261118150052.213046070@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted error reporting to the older per-type GPIO mapping handlers ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/int3472/discrete.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/platform/x86/intel/int3472/discrete.c b/drivers/platform/x86/intel/int3472/discrete.c
index 31494f4247864..517103ea252e5 100644
--- a/drivers/platform/x86/intel/int3472/discrete.c
+++ b/drivers/platform/x86/intel/int3472/discrete.c
@@ -227,7 +227,6 @@ static int skl_int3472_handle_gpio_resources(struct acpi_resource *ares,
 	struct int3472_discrete_device *int3472 = data;
 	struct acpi_resource_gpio *agpio;
 	union acpi_object *obj;
-	const char *err_msg;
 	int ret;
 	u8 type;
 
@@ -256,27 +255,31 @@ static int skl_int3472_handle_gpio_resources(struct acpi_resource *ares,
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
@@ -290,9 +293,6 @@ static int skl_int3472_handle_gpio_resources(struct acpi_resource *ares,
 	int3472->ngpios++;
 	ACPI_FREE(obj);
 
-	if (ret < 0)
-		return dev_err_probe(int3472->dev, ret, err_msg);
-
 	return ret;
 }
 
-- 
2.53.0



