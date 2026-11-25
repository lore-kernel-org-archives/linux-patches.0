Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626254;
	b=RQNfnOIJgNBRn0thwNhE0OVx4UEh1RF3nyamaN54MGlxtgHrisOtiTA7aDGWxQFSCe7v
	 XZQ9FoqMm9UycvcQuD2vk+vZhStsG+3G/pJiZo9ZfTBeeVyQDrrg8bBcFKM9jOQlhwfOt
	 b+4TtZZKZZvp/QWr/I/zxszu6rrzjswKua4kmVuuLHA0bREPLd1MFHx3IzPO8Jj1Bekvv
	 q5tvijULzorb1A9EkzLUDJBV7ksHwwlmExBEbha52UZ8ljffqf8Sy4VfR8eG2CLdnpAqr
	 CjzLRuQmBgl4/MR8mCpOBIrbfiEDEf3nk07eAwsKMsu9Ar80dfhc5wHwhprRDlT7luQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626254;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wjQDkZDRY+nB6RU7pj9tiRbRDBSFfWbciQbLF451xpA=;
	b=Sby7a6PivQ+zOc3/j+iygRKbRh5EhyCi+Owt2xYvM5uzSvJa3SHbkQtFRiV/jZlb2t3R
	 2PezXUdHMNWHUruvCfIZagvTWsqldxak0VMKvSVL9KectAFjwrjF+WjwFJjiethjoDVSF
	 bBBGpajzsw6MWXlLAyWO+NQLlI3pCjdqCitKctSxvMpkGfUkLgvdKU9I9zntp5VD7R2Un
	 sDjs6lemngymlMoSM34t5S33dJ14hgFpWfAVCuIZM9YscPg8+wagesSTrR2s0G3I01W6u
	 Oo0P4DL9y8/FYIc8+Y48o9r8WaNNV0eEoYpb4Qj3klaXnPF+/ltV4hDzkT5rz04+k1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZYYzqj28;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C85606A31E;
	Wed, 25 Nov 2026 17:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZYYzqj28
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6041F000D1;
	Wed, 25 Nov 2026 17:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626254;
	bh=wjQDkZDRY+nB6RU7pj9tiRbRDBSFfWbciQbLF451xpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZYYzqj28fc+yC/Ms6Bu7nRCXkzrJQG7NnvF8f7TpPM2pTpKwN1VZsE8SpmIV0XibV
	 qJSZbloKj/GPKZDw8F4GQHOgz4jvUtxEtVaGr5S32cVDNkQtN2uZ96BgjzF19Q/f0T
	 cS5ShkWcHqVbfyVxUtk76XOwmUIaZkEEOc9PvPCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu-Hsiang Tseng <asas1asas200@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 782/816] iio: acpi: Accept comma separated values in ROTM strings
Date: Wed, 25 Nov 2026 15:38:50 +0100
Message-ID: <20261125143907.273470491@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
@@ -5,6 +5,7 @@
 #include <linux/dev_printk.h>
 #include <linux/iio/iio.h>
 #include <linux/sprintf.h>
+#include <linux/string.h>
 
 /**
  * iio_read_acpi_mount_matrix() - Read accelerometer mount matrix info from ACPI
@@ -58,6 +59,14 @@ bool iio_read_acpi_mount_matrix(struct d
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


