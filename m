Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620587;
	b=k8MbHffPyqp7OI3Op6V6TLcchb81vRKYlTTfmZEz+t4WIoa4ZoaJP0SVyGZr/kjKni52
	 jlglZTUhygHOA0012M9Gsbo2AXnmXzBip/p1DqjHT+D/suXWgjYYoPTpTBjiGJZc8KUtS
	 hUmx9G2Dg+y/yacsL9jbaRLo1WWpk81sSgp56M0r0P/d9D6+tTlCV2KKQxr5lNQWPYoLZ
	 evLrJVNA6hFiyb4BCu3+LQ0nqW1HhB/bFv6sJMhnkguWpzSXm52CzZkT6SBk/tzpP4LU+
	 TKyGVnsHXx9dVhWSm5uv1XzuGJG9Be5Qdx8QsYCC8YIsOo7dGeE55WCRkYyW02cvm2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620587;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BOp9rCdMeZ+IOByDNQOEi/foSpwCOs3bqye3jl66VKI=;
	b=MF/kGlCrLV+JooTxoh/BCOOAmD/A94tkfL9mGP7TVab1BBWZLfL/U2e4Yxj6aZ8tMOvw
	 IOQlEX/SA34jVNkJI/kWsuk+nixdrenKwgD8mdebW3pMq6wzPE6Wi5G3dpxqweKI/8sBq
	 r9tHYxb8O7tAq8v0X9EEeEISDPbcUvFDrRYrDT8kChgiXE5HdXbtndtn/gkPWf4JloHc7
	 /AqO5z8Eszq1hB/dqfBr4d8CyyKU1HWcwxA0efTJWGLOGhyn9daEx4EcrauMJ504lyg1J
	 EA4tv5RdESFfKlEJ8kaEjnomMFwZ6ZSoDNRMJoC7k2+VufWkNz6QRY3SiVlvSPwKSAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1dKW9NMM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F95A606A31E;
	Wed, 25 Nov 2026 15:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1dKW9NMM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7BAD1F000C6;
	Wed, 25 Nov 2026 15:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620587;
	bh=BOp9rCdMeZ+IOByDNQOEi/foSpwCOs3bqye3jl66VKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1dKW9NMMn2PVLTtGpIcO5ptzHfKZwO6I20zNzj+N3AkoR34WPqjWRpyti0F4oNraA
	 woyCl79WzpOX2SnbjWljOnh02oj+TEwf9ZSPblB94J9fREe83OzitkyRlAWZqFnf2J
	 nyi3hGjEZYqQoW3dKQ19AUmGrfdcPa1kEB4niv5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu-Hsiang Tseng <asas1asas200@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.3 0966/1005] iio: acpi: Accept comma separated values in ROTM strings
Date: Wed, 25 Nov 2026 15:38:24 +0100
Message-ID: <20261125143844.295301764@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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


