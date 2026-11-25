Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623711;
	b=Vhg3SNc6IpVV0PvvOepRbW+VEq6j6AlZ45CWrjvNg921eyo1FTDLok+NeucQJwgYoeH5
	 D0qNudyxm0Sa8q50CQ68PbdCX1nOfaJclJY+ZnElt8M9hKNkwvE7s00AUZJG3LKamU+qK
	 vwISz1W4hzfKcH8szZ2T4Mnpn/jkyC9q+bOYq2LPTpAAnAwcmW2Aqfntle2q3/HMs2o8J
	 g4dUqphowJWaXDs4urN0415SeaB4/tlyAehI+RxVOLRNyBZ3U6G7Np/ibWXwrC5ow9/m6
	 NqgF1xJaQK0oRRMRnx6uEOFyOeH7fjKGiAJtM4VFjPQpeXX1Tf1PbiX1y3LVtucZN2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623711;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vxdpqpDHMOPJ/wFxEONnHCCd70WrMPUJbirFkGGZr9Q=;
	b=2TaNv8bpA6T2Agn0WmWjD33C9yUTSs8SU9N0rpaM1PkoXMuhfA+vkiO35SBWrmph/ZW+
	 y7JRqSyPSNokfDJmmxef05IjZ6PiHtnOJEhUKds5w+LeffTKyY7HkO7Ai+7tuWcKFeUQ9
	 04vSLso4fWkKXbrvLFgFPSQznuc+3qyKjqcL+MoXD5fbBeu2BfNZEAEFPLvHiOPDJHkzM
	 bp/Hy5DEeyus7/gcmpTceVRT9CkVNjrWaVNioiEYFWdggJad4KnbSbdXWhEVGA9uA0IDD
	 UqKOJrTb6Ybfjf9OWdQcRbXeDR98q3cZ3v+xOyBooJyEEysvNZn7N0C1Qv3hYXmdCuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2VzskBKT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64313606A321;
	Wed, 25 Nov 2026 16:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2VzskBKT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350191F000C0;
	Wed, 25 Nov 2026 16:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623710;
	bh=vxdpqpDHMOPJ/wFxEONnHCCd70WrMPUJbirFkGGZr9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2VzskBKTTXLbVGEtLSFw6/8cbRqyrw71zTEX8z0eP2IxlRYXeW7+pTsCLEjIB1cfd
	 xFF32lnOETu7JVx/SJJx7y/YymbqzBcp4VUQY66wrdhMCmlPas9cPo13iAh7O02xlx
	 poIzRAocE0JMv/1z0yczT4pCTX4SfnZT5fHTBBw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu-Hsiang Tseng <asas1asas200@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 946/990] iio: acpi: Accept comma separated values in ROTM strings
Date: Wed, 25 Nov 2026 15:38:33 +0100
Message-ID: <20261125143844.149908538@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Yu-Hsiang Tseng <asas1asas200@gmail.com>

commit dd53f1841ecfa2da152cbc31038a5f125b2b9e57 upstream.

The ROTM method of the MXC6655 accelerometer on the Higole F9B, an
Alder Lake-N handheld (AMI BIOS F9D_16G_P800217, DMI strings are all
"Default string"), separates the values with a comma and a space:

	Method (ROTM, 0, NotSerialized)
	{
	    Name (SBUF, Package (0x03)
	    {
	        "-1, 0, 0",
	        "0, 1, 0",
	        "0, 0, 1"
	    })
	    Return (SBUF)
	}

iio_read_acpi_mount_matrix() only accepts the space separated form used
in Microsoft's example ("0 1 0"). It rejects this matrix and mxc4005
falls back to the identity matrix:

	mxc4005 i2c-MXC6655:00: Incorrect ACPI mount matrix string format
	mxc4005 i2c-MXC6655:00: mounting matrix not found: using identity...

With the X axis not inverted, iio-sensor-proxy reports left-up when the
device is held right-up and vice versa, so the desktop turns the
picture upside down whenever the handheld is held in landscape.

It is not the only BIOS written this way. The BOSC0200 on the AYANEO
Air Plus uses commas in its ROMS method as well, with a space before
one of them, and its ROMK method has "1, 0,0":

	Method (ROMS, 0, NotSerialized)
	{
	    Name (SBUF, Package (0x03)
	    {
	        "-1, 0, 0",
	        "0, -1 , 0",
	        "0, 0, -1"
	    })
	    Return (SBUF)
	}

The kernel's sscanf() does not support '%*[', so there is no clean way
to take both separators in a single format string. That leaves either
a second sscanf() call with a comma format, or normalizing the
separator first. Do the latter: turn the commas into spaces before
parsing, so the existing "%d %d %d" format, which already takes any
amount of white space around the values, keeps working unchanged. The
strings live in the buffer acpi_evaluate_object() allocated for us, so
they can be modified in place.

With this change in_accel_mount_matrix on the Higole F9B reads
"-1, 0, 0; 0, 1, 0; 0, 0, 1" and, with no udev hwdb override, the
desktop rotates correctly in all four orientations. The AYANEO Air
Plus was not tested; systemd's hwdb has an entry for it, which
iio-sensor-proxy prefers over the kernel's matrix.

Link: https://github.com/hhd-dev/hwinfo/blob/d9508123bee46ae3a59dc24826030ef51ea95058/devices/ayaneo_airplus/acpi/decoded/dsdt.dsl
Cc: stable@vger.kernel.org # 6.10.x
Signed-off-by: Yu-Hsiang Tseng <asas1asas200@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-acpi.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/iio/industrialio-acpi.c
+++ b/drivers/iio/industrialio-acpi.c
@@ -6,6 +6,7 @@
 #include <linux/export.h>
 #include <linux/iio/iio.h>
 #include <linux/sprintf.h>
+#include <linux/string.h>
 
 /**
  * iio_read_acpi_mount_matrix() - Read accelerometer mount matrix info from ACPI
@@ -63,6 +64,14 @@ bool iio_read_acpi_mount_matrix(struct d
 		}
 
 		str = elements[i].string.pointer;
+		/*
+		 * Microsoft's example separates the values with spaces, "0 1 0".
+		 * Some BIOSes use commas instead, with or without spaces around
+		 * them: "0, 1, 0", "0, -1 , 0", "1, 0,0". The string lives in
+		 * the buffer allocated for us above, so turn the commas into
+		 * spaces in place before parsing.
+		 */
+		strreplace(str, ',', ' ');
 		if (sscanf(str, "%d %d %d", &val[0], &val[1], &val[2]) != 3) {
 			dev_err(dev, "Incorrect ACPI mount matrix string format\n");
 			goto out_free_buffer;


