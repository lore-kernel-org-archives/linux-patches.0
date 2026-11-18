Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050800;
	b=GEOpdAS1bUThTLM7as+YYHtkJfURbCIKHsai7yMaZti2p0OlPh6Czo6LYon7hVRyofds
	 3AgSoLGhblLjK2L+cuAdkhDgE9ZOYF/Qa4exCICz5ZPvK1zZgv32n8EKCGb2TVpEne6Oh
	 Uc9HphSRhIO6R8xAC2oxlNp54w+mNn7zCxMNAplPUm4e74+8JqOAsmd4xNKocp1+qCW3F
	 HK9lncDj22DhyDrBHM9tT3ay/ARZj8jT86JadtRbH6pbh0i38awKqosq881r9M6Izies0
	 R3WojNKMaqB/Uncla4kGb01GGQpCFKsPOdpdiVRHFOG+B9c9Qa7r/sVK4M6tIRs2Bcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050800;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Cw0oJnLh+0QX/ySyYR5n7FKF4HHdJQc0L/HrzcOHxBs=;
	b=ePVsvZLQ3tZ9Yyblk4fp/JMAotzh2WUyNX+kSTMyb3Snftsv2uJci7usZ1gPWT4XkbVM
	 siOZIu7gKaz0ISiHqQH16uT4uu5OCaho5wX5NtiGMhKEB1ReUxMQ2IG3VC6LpOFROVjXh
	 hK8NYCZpbZ9yGNjhuKGF750BXplKlbsznwV/+FbYDVMdHmvIcoOKBFtOGV7tVuqZCVeIx
	 yj/5L3XECcjbbTloOXUf/KNoxlVgzmyJZswN9n7BDlMh5YxtEv74gWPagfklvdC4G+oIh
	 q5CgwsvlApZu4Ylpzs4LRwPhB3xNl7iiy6khD1F/M4qGNoq2iLMnAJ8nD1RzQYFxqsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nTSDwUek;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7828F606A31C;
	Thu, 19 Nov 2026 01:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nTSDwUek
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3E71F000C4;
	Thu, 19 Nov 2026 01:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050800;
	bh=Cw0oJnLh+0QX/ySyYR5n7FKF4HHdJQc0L/HrzcOHxBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nTSDwUekLG3M4u5ziJaz5lwE7RIOsvRxESjTDTVtp+KNPWhd3C11abtmeC5gojPvI
	 cHIYn03H667FZy8HnR1nvOyMbzP9MeHzchOcM2+2peaLz/R1lehzSe+XhjvxbUhGyR
	 ddwD19K3RZyCHig9a65SJtn4+NVwV2x1yIwdGcsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2836/2857] PCI/sysfs: Decouple acpi_index from the optional device name element
Date: Wed, 18 Nov 2026 16:04:30 +0100
Message-ID: <20261118150343.688937094@linuxfoundation.org>
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



