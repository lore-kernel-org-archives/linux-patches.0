Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B9035503D;
	Wed,  3 Dec 2025 16:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778643; cv=none; b=oUBP9c11OXW50c0wlGBIE7x9O46B2AtYN8A/ux51bZRVtvFUMpZoEKQTv9m/eTeKkG97iD0caLQ/d5GKOFHX8pnClQMSldEOR/MsFIwvMC77pkQWtEBVvvu8qas4cY/5PcUjdHCjem9Mse3iTBEhLnjAUgoitqWP0tScqfiNY/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778643; c=relaxed/simple;
	bh=BsI2ASjPMrOfpJXvVyKWIb+28Lntw8AX4chYqkjV4Tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TfBp48nWB3EaEf4B++l0mUNtYxutQF89WulGRkRqtO8mG02dC/uS3hfO5/zzltceDs8Xhshwci6nvXYryOULw3WYGsZ4cp3k/CWbFL+UvAm8LEWgsLmgjjK+UKFURUWvTKg+yUOdsBTcuPr7yPh/sr2BWoHrNzauBeN013931hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XgRDsmRl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XgRDsmRl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C60C19421;
	Wed,  3 Dec 2025 16:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778643;
	bh=BsI2ASjPMrOfpJXvVyKWIb+28Lntw8AX4chYqkjV4Tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XgRDsmRlPkq4TKEU0SvjaJ2T7QcRa20656KgntHB9AgMb5+HTUcYdyfcAuQ27Bg2+
	 P76KrOeA7oUFRllbtg+5XTS47ScsTxob95qjCBLtEWw3DFJBlfEuXcohX1jTkZTaZl
	 ddD6TzWqzxQM6di7pgnbpdghrgrjI2bLdHIV9v2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Jacob <samjaco@google.com>,
	Uday M Bhat <uday.m.bhat@intel.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/568] xhci: dbc: Allow users to modify DbC poll interval via sysfs
Date: Wed,  3 Dec 2025 16:20:18 +0100
Message-ID: <20251203152441.256097957@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uday M Bhat <uday.m.bhat@intel.com>

[ Upstream commit de3edd47a18fe05a560847cc3165871474e08196 ]

xhci DbC driver polls the host controller for DbC events at a reduced
rate when DbC is enabled but there are no active data transfers.

Allow users to modify this reduced poll interval via dbc_poll_interval_ms
sysfs entry. Unit is milliseconds and accepted range is 0 to 5000.
Max interval of 5000 ms is selected as it matches the common 5 second
timeout used in usb stack.
Default value is 64 milliseconds.

A long interval is useful when users know there won't be any activity
on systems connected via DbC for long periods, and want to avoid
battery drainage due to unnecessary CPU usage.

Example being Android Debugger (ADB) usage over DbC on ChromeOS systems
running Android Runtime.

[minor changes and rewording -Mathias]

Co-developed-by: Samuel Jacob <samjaco@google.com>
Signed-off-by: Samuel Jacob <samjaco@google.com>
Signed-off-by: Uday M Bhat <uday.m.bhat@intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20240626124835.1023046-5-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: f3d12ec847b9 ("xhci: dbc: fix bogus 1024 byte prefix if ttyDBC read races with stall event")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/ABI/testing/sysfs-bus-pci-drivers-xhci_hcd |   10 +++
 drivers/usb/host/xhci-dbgcap.c                           |   38 +++++++++++++++
 drivers/usb/host/xhci-dbgcap.h                           |    2 
 3 files changed, 49 insertions(+), 1 deletion(-)

--- a/Documentation/ABI/testing/sysfs-bus-pci-drivers-xhci_hcd
+++ b/Documentation/ABI/testing/sysfs-bus-pci-drivers-xhci_hcd
@@ -75,3 +75,13 @@ Description:
 		The default value is 1  (GNU Remote Debug command).
 		Other permissible value is 0 which is for vendor defined debug
 		target.
+
+What:		/sys/bus/pci/drivers/xhci_hcd/.../dbc_poll_interval_ms
+Date:		February 2024
+Contact:	Mathias Nyman <mathias.nyman@linux.intel.com>
+Description:
+		This attribute adjust the polling interval used to check for
+		DbC events. Unit is milliseconds. Accepted values range from 0
+		up to 5000. The default value is 64 ms.
+		This polling interval is used while DbC is enabled but has no
+		active data transfers.
--- a/drivers/usb/host/xhci-dbgcap.c
+++ b/drivers/usb/host/xhci-dbgcap.c
@@ -1214,11 +1214,48 @@ static ssize_t dbc_bInterfaceProtocol_st
 	return size;
 }
 
+static ssize_t dbc_poll_interval_ms_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct xhci_dbc *dbc;
+	struct xhci_hcd *xhci;
+
+	xhci = hcd_to_xhci(dev_get_drvdata(dev));
+	dbc = xhci->dbc;
+
+	return sysfs_emit(buf, "%u\n", dbc->poll_interval);
+}
+
+static ssize_t dbc_poll_interval_ms_store(struct device *dev,
+					  struct device_attribute *attr,
+					  const char *buf, size_t size)
+{
+	struct xhci_dbc *dbc;
+	struct xhci_hcd *xhci;
+	u32 value;
+	int ret;
+
+	ret = kstrtou32(buf, 0, &value);
+	if (ret || value > DBC_POLL_INTERVAL_MAX)
+		return -EINVAL;
+
+	xhci = hcd_to_xhci(dev_get_drvdata(dev));
+	dbc = xhci->dbc;
+
+	dbc->poll_interval = value;
+
+	mod_delayed_work(system_wq, &dbc->event_work, 0);
+
+	return size;
+}
+
 static DEVICE_ATTR_RW(dbc);
 static DEVICE_ATTR_RW(dbc_idVendor);
 static DEVICE_ATTR_RW(dbc_idProduct);
 static DEVICE_ATTR_RW(dbc_bcdDevice);
 static DEVICE_ATTR_RW(dbc_bInterfaceProtocol);
+static DEVICE_ATTR_RW(dbc_poll_interval_ms);
 
 static struct attribute *dbc_dev_attributes[] = {
 	&dev_attr_dbc.attr,
@@ -1226,6 +1263,7 @@ static struct attribute *dbc_dev_attribu
 	&dev_attr_dbc_idProduct.attr,
 	&dev_attr_dbc_bcdDevice.attr,
 	&dev_attr_dbc_bInterfaceProtocol.attr,
+	&dev_attr_dbc_poll_interval_ms.attr,
 	NULL
 };
 
--- a/drivers/usb/host/xhci-dbgcap.h
+++ b/drivers/usb/host/xhci-dbgcap.h
@@ -94,7 +94,7 @@ struct dbc_ep {
 #define DBC_QUEUE_SIZE			16
 #define DBC_WRITE_BUF_SIZE		8192
 #define DBC_POLL_INTERVAL_DEFAULT	64	/* milliseconds */
-
+#define DBC_POLL_INTERVAL_MAX		5000	/* milliseconds */
 /*
  * Private structure for DbC hardware state:
  */


