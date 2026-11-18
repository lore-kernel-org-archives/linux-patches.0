Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042796;
	b=jLioLThLgV9kPOQRhjpSoOLGV+ynX5n8i6JtSfqUjuVmz+HxDL/EpuqCtEp76nPp0EzV
	 gkPtob3vXijcEVpmrF1c9tC/Ka/GD9uyH21fm/u3kQpp6I48Wmk3b3MPMtdNpQ2pkTHY5
	 fmPWGeu+7hZnxoy/AsMoM6B4bTx+mPhAaVQRdRhxyMqJxB/wABfHi0nitH/uehCwDKxxw
	 KZTaoL7KruZ9DopyWXXozFk0c01IgoUNtx8PmtdTjtyYSH07R9cKNRZMmjKYE77oA8Ltq
	 So37+64UD8RtTfCM4Q8uH5AdOiJfFE/Kztz42XBez1B6b7UOTtpP912CHU8jxVtQaNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042796;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=DGfe+X9Hb5YE/WLDyWGuP9d+d2J4xH4TVoggBhFEcnk=;
	b=OBgeR0Co2rYpnPOEjDoMjIWJYC2YzZBe+3encyzWFzcpIWJAVuqEL+SMyw/O2bHW3td7
	 M3+DwEcQMqEbXHKcoHSv+66OiKUO9fIxkEYAH1f9glp1eTbbooxWI4LF+lyfjJWLmvIoW
	 oQyiYW0rdsc+1aM1GCruJBTUQNQQ/q2ekLNdQF+TD85Psd/VG2s5PZs8W7aHRG7k0aFlr
	 UpYpnf35Fne7sXuMr/P4voiepipxR5yBfucu67AQxVRn1oNdUNzXqCpQonhRWMIXPgWvO
	 BeIjRz1oLLx/viCR6j38IgedgYAHl4qOETXdeb4+/2Ro1rU6K0WkJEwTIzYw/7y3ZrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b6oQemQn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAD8606A31C;
	Wed, 18 Nov 2026 22:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b6oQemQn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3691F000C4;
	Wed, 18 Nov 2026 22:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042796;
	bh=DGfe+X9Hb5YE/WLDyWGuP9d+d2J4xH4TVoggBhFEcnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b6oQemQnpNdF14dAl6j829YS7WnCXYE8453jQkQ4JW7ah8l5VtjzkGCdhbCMUK+ER
	 fLX/Nm3u+zFGakot5nFeAFZhNT5dRZAwsuXqbh93AyKPhUti+14m038TSJAVzx37nx
	 udOGdc3HAAbyIch5KPtt25jICTygoRwNhbHf9zdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3299/3318] PCI/sysfs: Decouple acpi_index from the optional device name element
Date: Wed, 18 Nov 2026 16:05:21 +0100
Message-ID: <20261118150458.562872039@linuxfoundation.org>
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

From: Krzysztof Wilczyński <kwilczynski@kernel.org>

[ Upstream commit 337bdf853101a0ee66eadf668f0fef21f8276b52 ]

The "_DSM for Naming a PCI or PCI Express Device Under Operating Systems"
(PCI Firmware r3.3, sec 4.6.7) returns a package of two elements:

  1) Instance number (mandatory Integer)
  2) String name (optional String, null string if not populated)

These are exposed as sysfs 'acpi_index' and 'label'. Previously, if
the name was malformed, reads of 'acpi_index' failed unnecessarily.

Validate each element only for the attribute that exports it.  So
"acpi_index" now depends on the instance number alone, and "label" reads
fail with -EIO when the name element is neither a string nor a buffer.  The
package elements pointer is read only after the object type has been
checked.

On platforms with a valid instance number and a malformed name element the
"acpi_index" attribute starts returning data.  Because udev derives the
onboard interface name from "acpi_index", an interface on such a platform
may be renamed once, on the first boot after this change.  That is the
attribute assuming the value the firmware always provided.

Link: https://github.com/pciutils/pciutils/issues/175
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260814070522.2327975-3-kwilczynski@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-label.c | 53 +++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 20 deletions(-)

diff --git a/drivers/pci/pci-label.c b/drivers/pci/pci-label.c
index f81248a11a18e..08c461f1142d7 100644
--- a/drivers/pci/pci-label.c
+++ b/drivers/pci/pci-label.c
@@ -157,7 +157,7 @@ static int dsm_get_label(struct device *dev, char *buf,
 {
 	acpi_handle handle = ACPI_HANDLE(dev);
 	union acpi_object *obj, *tmp;
-	int len = 0;
+	int len;
 
 	if (!handle)
 		return -ENODEV;
@@ -167,30 +167,43 @@ static int dsm_get_label(struct device *dev, char *buf,
 	if (!obj)
 		return -EIO;
 
+	if (obj->type != ACPI_TYPE_PACKAGE || obj->package.count != 2) {
+		len = -EIO;
+		goto out;
+	}
+
 	tmp = obj->package.elements;
-	if (obj->type == ACPI_TYPE_PACKAGE && obj->package.count == 2 &&
-	    tmp[0].type == ACPI_TYPE_INTEGER &&
-	    (tmp[1].type == ACPI_TYPE_STRING ||
-	     tmp[1].type == ACPI_TYPE_BUFFER)) {
-		/*
-		 * The second string element is optional even when
-		 * this _DSM is implemented; when not implemented,
-		 * this entry must return a null string.
-		 */
-		if (attr == ACPI_ATTR_INDEX_SHOW) {
-			len = sysfs_emit(buf, "%llu\n", tmp->integer.value);
-		} else if (attr == ACPI_ATTR_LABEL_SHOW) {
-			if (tmp[1].type == ACPI_TYPE_STRING)
-				len = sysfs_emit(buf, "%s\n",
-						 tmp[1].string.pointer);
-			else if (tmp[1].type == ACPI_TYPE_BUFFER)
-				len = dsm_label_utf16s_to_utf8s(tmp + 1, buf);
-		}
+	if (tmp[0].type != ACPI_TYPE_INTEGER) {
+		len = -EIO;
+		goto out;
 	}
 
+	if (attr == ACPI_ATTR_INDEX_SHOW) {
+		len = sysfs_emit(buf, "%llu\n", tmp[0].integer.value);
+		goto out;
+	}
+
+	/*
+	 * Per PCI Firmware r3.3, sec 4.6.7, the device name is optional
+	 * even when this _DSM is implemented. When not implemented, this
+	 * entry must return a NULL string.
+	 */
+	switch (tmp[1].type) {
+	case ACPI_TYPE_STRING:
+		len = sysfs_emit(buf, "%s\n", tmp[1].string.pointer);
+		break;
+	case ACPI_TYPE_BUFFER:
+		len = dsm_label_utf16s_to_utf8s(&tmp[1], buf);
+		break;
+	default:
+		len = -EIO;
+		break;
+	}
+
+out:
 	ACPI_FREE(obj);
 
-	return len > 0 ? len : -EIO;
+	return len;
 }
 
 static ssize_t label_show(struct device *dev, struct device_attribute *attr,
-- 
2.53.0



