Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064611;
	b=tUmltQAveZdfZArKe3uicsO2O5+qaI3NAW817sl+5rR2TfeHgaAE7FcMXMbb/mFyNicW
	 AhLrrm+vbHcTEodWeKkY7FYJlg6j1IoeMPTz02EAgQhSJog1QZeBe1qlMpV+M12pP+sx3
	 0hg1axikKTslnXnIxP2ax+66WQqUK+dP3JSsSChixpYNF3UOKfZ3IMDrf6objmbqkBlGS
	 NoJBllTtr7bQUi2HOIgJ5I2bInZoiirUdoTEWCgvZfqHwVMRK9b7W6WEGuH9cZza1TtxD
	 Io4tez8bn6gV0zOUGbcrMuo5qu29Z0yxREmhrsotqm2eA/KgYO0XYxJDnNOXlbBFTkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064611;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QOabKzNsJfA8mVcOdcb7DcIJ2s3OwfTYgcyEFkQZqo4=;
	b=jPvyI/enzgehySTKpm+SXYeT9h5v/ZUSQSkXbjrVa7c4gzTPjfeXtLFEnjPraPhRoj4P
	 fnn9lMyEB66tEHdF5s3yHIzGm6qOo1W9YE4uNqiWJuvKPcnlz3Piyd9UhfghnvfmsmTsm
	 nk+LNRURNgEsFUlnJzXpwm/aPZunoeEkV+V2DpteGCKmPIat/DIjBseIqmDN3IuhuRKMX
	 ObR22zO4hJHpgsbkMHg1yo0WbeZfPeTcyK7HROSWicosTnI8kAJX18K+nTFIivG8MPIvU
	 Pg4xc5+pykWsf12OmrbYyvcCThwQm9+fjjFFZOz/vBRVvtlDTqOohmmckOb1TOTiG5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rgKey0jf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BB6606EE88;
	Sat,  7 Nov 2026 15:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rgKey0jf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C553E1F0089F;
	Sat,  7 Nov 2026 15:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064611;
	bh=QOabKzNsJfA8mVcOdcb7DcIJ2s3OwfTYgcyEFkQZqo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rgKey0jfWcYk/CEmZku4vlc4W52QuyCZYV1AR6DMstttRGPB2x3hdV9Q1MCLvmvzc
	 S+21s762aZPDsXPnlPBmGW1b9qaLnifllS9eQCpeSjeNkoLNkA8MZ0f/7jrhpcqYGc
	 12LX6ZQ1U5+Y+cXxolC9FXCA8OuqVEUy8DkXIplw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Johan Hovold <johan@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0621/1257] usb: core: dont set drvdata to NULL in usb_unbind_interface()
Date: Sat,  7 Nov 2026 08:48:37 -0500
Message-ID: <20261107134956.451712343@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit 8f0d16174102863936d583c90258ea02bf06205c ]

usb_unbind_interface() serves as the remove() callback of struct
usb_driver and calls usb_set_intfdata(intf, NULL) to clear the bus
device private data pointer.

However, the driver core code already sets the bus device private data
pointer to NULL in device_unbind_cleanup() *after* devres_release_all(),
which makes the call redundant.

In addition, it can create unexpected NULL pointer dereference scenarios
when drivers use managed APIs.

	int probe(struct usb_interface *intf,
		  const struct usb_device_id *id)
	{
		struct data *data;
		int ret;

		data = devm_kzalloc(&intf->dev, sizeof(*data), GFP_KERNEL);
		if (!data)
			return -ENOMEM;

		ret = devm_device_add_group(&intf->dev, &foo_attr_group);
		if (ret)
			return ret;

		...
	}

	ssize_t foo_value_show(struct device *dev, struct device_attribute *attr,
			       char *buf)
	{
		struct usb_interface *intf = to_usb_interface(dev);
		struct data *data = usb_get_intfdata(intf);

		/* Potential NULL pointer dereference */
		return sysfs_emit(buf, "%u\n", data->value);
	}

Nothing prevents usb_unbind_interface() to race with foo_value_show()
and set usb_set_intfdata(intf, NULL).

The same applies to the unwind path of usb_probe_interface(), which also
calls usb_set_intfdata(intf, NULL).

Besides that, the Rust driver core code manages a driver's bus device
private data and destroys it in device_unbind_cleanup().

If usb_unbind_interface() sets the pointer to NULL prematurely, the Rust
driver core code sees NULL, and hence skips the destructor of the bus
device private data, which leaks all its resources.

Thus, drop usb_set_intfdata(intf, NULL) from usb_probe_interface() and
usb_unbind_interface(), and move it to usb_driver_release_interface(),
which manually calls the remove() callback of struct usb_driver and
hence can't rely on the driver core.

Cc: stable@kernel.org
Fixes: a995fe1a3aa7 ("rust: driver: drop device private data post unbind")
Reviewed-by: Johan Hovold <johan@kernel.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patch.msgid.link/20261010135131.286498-1-dakr@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/driver.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index bf660b15a0f60..9af0184276c10 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -410,7 +410,6 @@ static int usb_probe_interface(struct device *dev)
 	return error;
 
  err:
-	usb_set_intfdata(intf, NULL);
 	intf->needs_remote_wakeup = 0;
 	intf->condition = USB_INTERFACE_UNBOUND;
 
@@ -497,7 +496,6 @@ static int usb_unbind_interface(struct device *dev)
 	} else {
 		intf->needs_altsetting0 = 1;
 	}
-	usb_set_intfdata(intf, NULL);
 
 	intf->condition = USB_INTERFACE_UNBOUND;
 	intf->needs_remote_wakeup = 0;
@@ -644,6 +642,7 @@ void usb_driver_release_interface(struct usb_driver *driver,
 	} else {
 		device_lock(dev);
 		usb_unbind_interface(dev);
+		dev_set_drvdata(dev, NULL);
 		dev->driver = NULL;
 		device_unlock(dev);
 	}
-- 
2.53.0



