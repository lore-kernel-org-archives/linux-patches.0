Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043901;
	b=khF3DTdrKCMRa1Zrurj2SS+Thd9V3KvyD/JuNl4Nceh+xSPehiF4kylOK483IoPd1W0U
	 lEryz8j/9r0FKJ4NyrgTZYcYv6Z1jq7m9k1s2pIuAeW5f/ppTenKws41bVehLtpYS260O
	 VKzG6pxlcIdYOyy1WARUlnpCxcgDHeZNKoe6qUZTgH2ZGxyxBEo+PMRQDjC6Iqp4nx3cR
	 1eM0Uk2ukoqFPvPkNajh2PYtdmTIXvG1wPCiyiZDxjTm2ebdOl+mIGXtWe3SuAFhmWXha
	 DytpAcI2wnl7vtcDgW8ed7+8Tr1S7PT8RjBrwdIP1DPlFG0othrW8ceqkS63qLgwpIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043901;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=WtYyZoEq1oVP9U9opNudJlUa4/o2K4CoSaVVtgzkIHI=;
	b=HaB7q7/lse9iHMrTrgYxeGLzUEkKvQtM7gGybeXNoq0CvwvkHgECC+prUsokxsTqFyoR
	 J04tKTxvSRuReAPQ/k3oXWQ2hbT1WUUdp6Z5twDaQ3FdJhN55lywn3d54htaLro98WEAi
	 CZbfpJv0ZqOtjSl5VJQlGxUIs8vApXO7Bi9rKGWBDEjfbtgeNc7N005WNQ2C/cSENojkL
	 TTbrdPQupI2s/uEwHWZx4Rtenm9hPxLdf3vPhCtxliLpm3TMjMF/U+CntPqt1Q2il6bqE
	 M7QfEaOWfWB+eOx6WYcqni3VVluwaa6ggee2CODnHIR0tf0R613+XchnMifbsJ9iLdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tR2iRncO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEDE606A31C;
	Wed, 18 Nov 2026 23:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tR2iRncO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7026D1F000C4;
	Wed, 18 Nov 2026 23:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043901;
	bh=WtYyZoEq1oVP9U9opNudJlUa4/o2K4CoSaVVtgzkIHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tR2iRncON1qs+aKDrzW5fjsOhuPcr4VYHe+WL1RHhhumfscS5xirsVMUTXfxhN/F6
	 pNZkRRkOj8Kncgl1ZtpcHNDUstKLNJwZK/08LVx3IFQGw5Ahfuzmc6lflDNLgHxpFw
	 GqezFs7issnwtgQKncH3LD4/aNPbxa6yz9d9JlnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0377/2857] iio: core: Add iio_read_acpi_mount_matrix() helper function
Date: Wed, 18 Nov 2026 15:23:31 +0100
Message-ID: <20261118150214.983025278@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 02eae0bb9538dc7dcb5a6bc2c3066bd6ca682969 ]

The ACPI "ROTM" rotation matrix parsing code atm is already duplicated
between bmc150-accel-core.c and kxcjk-1013.c and a third user of this
is coming.

Add an iio_read_acpi_mount_matrix() helper function for this.
The 2 existing copies of the code are identical, except that
the kxcjk-1013.c has slightly better error logging.

To new helper is a 1:1 copy of the kxcjk-1013.c version, the only change
is the addition of a "char *acpi_method" parameter since some bmc150
dual-accel setups (360° hinges with 1 accel in kbd/base + 1 in display)
declare both accels in a single ACPI device with 2 different method names
for the 2 matrices. This new acpi_method parameter is not "const char *"
because the pathname parameter to acpi_evaluate_object() is not const.

The 2 existing copies of this function will be removed in further patches
in this series.

Acked-by: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240425125754.76010-2-hdegoede@redhat.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: f0ea4824deeb ("iio: health: max30102: fix NULL dereference in interrupt handler")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/Makefile            |  1 +
 drivers/iio/industrialio-acpi.c | 85 +++++++++++++++++++++++++++++++++
 include/linux/iio/iio.h         | 13 +++++
 3 files changed, 99 insertions(+)
 create mode 100644 drivers/iio/industrialio-acpi.c

diff --git a/drivers/iio/Makefile b/drivers/iio/Makefile
index 3be08cdadd7e5..cbbedb01a30c2 100644
--- a/drivers/iio/Makefile
+++ b/drivers/iio/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_IIO) += industrialio.o
 industrialio-y := industrialio-core.o industrialio-event.o inkern.o
 industrialio-$(CONFIG_IIO_BUFFER) += industrialio-buffer.o
 industrialio-$(CONFIG_IIO_TRIGGER) += industrialio-trigger.o
+industrialio-$(CONFIG_ACPI) += industrialio-acpi.o
 
 obj-$(CONFIG_IIO_CONFIGFS) += industrialio-configfs.o
 obj-$(CONFIG_IIO_SW_DEVICE) += industrialio-sw-device.o
diff --git a/drivers/iio/industrialio-acpi.c b/drivers/iio/industrialio-acpi.c
new file mode 100644
index 0000000000000..981b75d407802
--- /dev/null
+++ b/drivers/iio/industrialio-acpi.c
@@ -0,0 +1,85 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* IIO ACPI helper functions */
+
+#include <linux/acpi.h>
+#include <linux/dev_printk.h>
+#include <linux/iio/iio.h>
+#include <linux/sprintf.h>
+
+/**
+ * iio_read_acpi_mount_matrix() - Read accelerometer mount matrix info from ACPI
+ * @dev:		Device structure
+ * @orientation:	iio_mount_matrix struct to fill
+ * @acpi_method:	ACPI method name to read the matrix from, usually "ROTM"
+ *
+ * Try to read the mount-matrix by calling the specified method on the device's
+ * ACPI firmware-node. If the device has no ACPI firmware-node; or the method
+ * does not exist then this will fail silently. This expects the method to
+ * return data in the ACPI "ROTM" format defined by Microsoft:
+ * https://learn.microsoft.com/en-us/windows-hardware/drivers/sensors/sensors-acpi-entries
+ * This is a Microsoft extension and not part of the official ACPI spec.
+ * The method name is configurable because some dual-accel setups define 2 mount
+ * matrices in a single ACPI device using separate "ROMK" and "ROMS" methods.
+ *
+ * Returns: true if the matrix was successfully, false otherwise.
+ */
+bool iio_read_acpi_mount_matrix(struct device *dev,
+				struct iio_mount_matrix *orientation,
+				char *acpi_method)
+{
+	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
+	struct acpi_device *adev = ACPI_COMPANION(dev);
+	char *str;
+	union acpi_object *obj, *elements;
+	acpi_status status;
+	int i, j, val[3];
+	bool ret = false;
+
+	if (!adev || !acpi_has_method(adev->handle, acpi_method))
+		return false;
+
+	status = acpi_evaluate_object(adev->handle, acpi_method, NULL, &buffer);
+	if (ACPI_FAILURE(status)) {
+		dev_err(dev, "Failed to get ACPI mount matrix: %d\n", status);
+		return false;
+	}
+
+	obj = buffer.pointer;
+	if (obj->type != ACPI_TYPE_PACKAGE || obj->package.count != 3) {
+		dev_err(dev, "Unknown ACPI mount matrix package format\n");
+		goto out_free_buffer;
+	}
+
+	elements = obj->package.elements;
+	for (i = 0; i < 3; i++) {
+		if (elements[i].type != ACPI_TYPE_STRING) {
+			dev_err(dev, "Unknown ACPI mount matrix element format\n");
+			goto out_free_buffer;
+		}
+
+		str = elements[i].string.pointer;
+		if (sscanf(str, "%d %d %d", &val[0], &val[1], &val[2]) != 3) {
+			dev_err(dev, "Incorrect ACPI mount matrix string format\n");
+			goto out_free_buffer;
+		}
+
+		for (j = 0; j < 3; j++) {
+			switch (val[j]) {
+			case -1: str = "-1"; break;
+			case 0:  str = "0";  break;
+			case 1:  str = "1";  break;
+			default:
+				dev_err(dev, "Invalid value in ACPI mount matrix: %d\n", val[j]);
+				goto out_free_buffer;
+			}
+			orientation->rotation[i * 3 + j] = str;
+		}
+	}
+
+	ret = true;
+
+out_free_buffer:
+	kfree(buffer.pointer);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iio_read_acpi_mount_matrix);
diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
index 9d3bd6379eb87..3f3602770b864 100644
--- a/include/linux/iio/iio.h
+++ b/include/linux/iio/iio.h
@@ -751,6 +751,19 @@ static inline struct dentry *iio_get_debugfs_dentry(struct iio_dev *indio_dev)
 }
 #endif
 
+#ifdef CONFIG_ACPI
+bool iio_read_acpi_mount_matrix(struct device *dev,
+				struct iio_mount_matrix *orientation,
+				char *acpi_method);
+#else
+static inline bool iio_read_acpi_mount_matrix(struct device *dev,
+					      struct iio_mount_matrix *orientation,
+					      char *acpi_method)
+{
+	return false;
+}
+#endif
+
 ssize_t iio_format_value(char *buf, unsigned int type, int size, int *vals);
 
 int iio_str_to_fixpoint(const char *str, int fract_mult, int *integer,
-- 
2.53.0



