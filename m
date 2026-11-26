Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704796;
	b=sCHymh1Iy+vbarp9wdBlBhttrLwGnIjv61mErd5Ob96ijCvNK2Er/u6VXXD/bolPsHzy
	 YgY2gxqNNyCoKJCxIvQi0nm7VUa+t/kzfbcd9ORLEu8TmUNaf7sAWCNnEfuJ+Vp55b+/P
	 o95vGyX0Hx3NXvRSAoh6Bo4sBxzo/b5eqITlSwcfTWx1kxQyNB6WVyqt98ehARLtAo7zE
	 IhUT404sjEzjNtXaY+In4Eip0a05Sfw0Nw0/8J7ptfgITcUYzuqT/ElCHcPO+kaeWfih0
	 vAMtU98GOl+zrtb57Ft2AD/RbGN7mUAlAqcu+6kH77K20o8u9Gk65ba/cCuwVztNXvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704796;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S1vuRAPGUek21W+mL5DWvyF48Qdzh7k5VTOQ0ybhZww=;
	b=HpZ8jFJQU1Jr+MywO437ipe6MxULliFnQEDhxpeTb6KLQ6xFalDD6zqBkbJSqexeU97u
	 ZAeaE5nPGvb7v9bXLVBRXmo1pr0rSKb7/xysHePL5OAHFKzLE+5kztaqQ7vgCM1GVXIy+
	 WS1/L2ciqY1rujgoxmWZ0MFCQZBcH66yvVXzlTFP1dW4x7Frg9ZaGlYZ+Xmt2RCtooyef
	 YUBKq6jgaIecrOOsFfmeinWt2WiRXQlynd8Ik1LRR+cV3L5YGeeOuSwVBUgmsJuCKU0He
	 RY9WfXIoY1L3/SnZ/tV++jhQGAlPEUSKtIB5YJbjyHp6DEdX1fm7PCQG6WYhjBAFI/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uRDmjXlX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826E860A3821;
	Thu, 26 Nov 2026 14:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uRDmjXlX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB77C1F01803;
	Thu, 26 Nov 2026 14:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704796;
	bh=S1vuRAPGUek21W+mL5DWvyF48Qdzh7k5VTOQ0ybhZww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uRDmjXlX3YVVW9CzJ+AYST4yzQ8CXSE+WjiIw7zWYdMvn9YJhFwPq8zvb9Nx+89wF
	 42z+uHpcP0ra0Y/BF1UDJGOVEGpWkj1+wU2IYQqmRDN8gh+01dFJQhFFPkGOpvHx4t
	 dN2SpEpcL08hpXKHfqn3vG3blJZ8Iq9YUrcpC9D8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Czirr <maxx-cz@web.de>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.10 247/265] iio: hid-sensor: Fix scale for magnetic north heading
Date: Thu, 26 Nov 2026 15:39:37 +0100
Message-ID: <20261126143622.528964306@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maximilian Czirr <maxx-cz@web.de>

commit c72dcaeaabd60e164e7324f80ccb037e879eefdd upstream.

hid_sensor_format_scale() applies the HID unit exponent only when
the usage and unit match an entry in unit_conversion[].

Rotation-from-north support uses
HID_USAGE_SENSOR_ORIENT_COMP_MAGN_NORTH, but that usage has no entry in
the conversion table. As a result, the unit exponent is ignored and the
heading can be exposed with a scale of 1 instead of the scale specified
by the HID descriptor.

Add a unitless conversion entry so the HID unit exponent is applied to
the magnetic north heading. A sensor reporting an exponent of -5 then
correctly exposes a scale of 0.00001 instead of 1.

Fixes: abea9c62c32f ("iio: hid-sensor-magn-3d: Add support for rotation from north")
Cc: stable@vger.kernel.org
Signed-off-by: Maximilian Czirr <maxx-cz@web.de>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/common/hid-sensors/hid-sensor-attributes.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/common/hid-sensors/hid-sensor-attributes.c
+++ b/drivers/iio/common/hid-sensors/hid-sensor-attributes.c
@@ -45,6 +45,8 @@ static struct {
 	{HID_USAGE_SENSOR_COMPASS_3D, 0, 0, 1000000},
 	{HID_USAGE_SENSOR_COMPASS_3D, HID_USAGE_SENSOR_UNITS_GAUSS, 1, 0},
 
+	{HID_USAGE_SENSOR_ORIENT_COMP_MAGN_NORTH, 0, 1, 0},
+
 	{HID_USAGE_SENSOR_INCLINOMETER_3D, 0, 0, 17453293},
 	{HID_USAGE_SENSOR_INCLINOMETER_3D,
 		HID_USAGE_SENSOR_UNITS_DEGREES, 0, 17453293},


