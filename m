Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049452;
	b=NIBlHt7auK4Lo+OL1qbmsH0pXj/xqTJPHQILL0yHBrNbalTCrG7GInleGwbPQLRGLk8E
	 yuBmVw4ftSluIUcO7x79u/mz/8GIDTNslIN6u7k1dEwSQna4UkvveUUSouutWoZV5od3o
	 RP/4wa7GaRq5a8GBV6YWv1cTIuJSIG/4f/j6+SaYAz9mDxHIqHAX/qvpJVMzubz0fl1Pw
	 1NkvArkfbkt7AFLpq//sl9oPMR1YrPIT6+fi1FpFycLNYPuRZYiaegcKoy4FaLUSTcnS8
	 dmmwxFMi56+hWCANU7PMjdtbCtJn+GGLlDtlbLXaBmPD5eMn83pM8xR/rPuZuFE0kcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049452;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=LnbGjYiZmLklqHYqeur3xm81jebXDEHWxY4wd8p7Ejs=;
	b=AAjUVx5jwhaVaXCz2koDkN+U6a5ieW9N/FaTco4sUdeP9nNCVKFNJjqiVFX6/srdDiRM
	 VAgmt/vIEop5pqcCKxUnkdVtFnVJujD/4BJ8iEHIYkMMlHNyDLuIGprJATexS+B9PKLTT
	 qSUsgZbuwyDIO69lYpexIiEuWCGL+cWl5n3Epfbf5+erPFOPSmUcuMnaojFfLip6e7Ft6
	 Kbd+1vYRhtF93x6kimQ0ftmKUS8Zk45/KWMdgiC19bffrt+X9mfXv/2fYNMPu+PNfJqzW
	 RXXDk/1t8CCNDEqcNFyZgioNbc/+CpS87UCAvowEAutvnby04Pli2/gPi0zWu1fKq0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MKA3P9C7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15CFC606A32C;
	Thu, 19 Nov 2026 00:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MKA3P9C7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D56F1F000C4;
	Thu, 19 Nov 2026 00:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049451;
	bh=LnbGjYiZmLklqHYqeur3xm81jebXDEHWxY4wd8p7Ejs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MKA3P9C7uA4vPJsv3EMOrhtLdGCHfVdyNhjBqsdDIeZc/5j3jx3vzy1xiuHBG/odA
	 5pHytBonNG6XNFdDtKLmZo7RjF5OfDnNhXjrdKM7zIRqMBvdqz5bgef/Ze8YKirtnk
	 /mmedzSzaNDER5V8yI/CGw9EO4pLYVDbThjdyxkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2319/2857] PCI/sysfs: Handle a malformed _DSM result in acpi_attr_is_visible()
Date: Wed, 18 Nov 2026 15:55:53 +0100
Message-ID: <20261118150325.031834893@linuxfoundation.org>
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

[ Upstream commit 1832dc1579aa7cc7cd41843770767e7a3ffa8364 ]

Currently, the "label" and "acpi_index" attributes are created whenever the
_DSM function 0 bitmap advertises the Device Name function, without
evaluating that function.  The documented ABI states that each attribute is
created only if the firmware has given a name or an instance number to the
PCI device.

The bitmap says nothing about the object the function returns.  Firmware
that advertises the function but returns an object that cannot be parsed
therefore produces attributes that exist and fail every read, as in the
report below.

Evaluate the Device Name _DSM when deciding attribute visibility and create
each attribute only when the element it exports has a type the read path
accepts, mirroring the checks performed at read time.  The SMBIOS attribute
group already follows this pattern by performing the DMI lookup in its
is_visible() callback.  The read side checks remain in place since the two
evaluations happen at different times.

This restores the behaviour from before commit 2fc59fe2ecdc ("PCI /
pci-label: treat PCI label with index 0 as valid label"), which switched
visibility from evaluating the function to checking only the function 0
bitmap.  The check is now made for each attribute, not once for both.

Fixes: 2fc59fe2ecdc ("PCI / pci-label: treat PCI label with index 0 as valid label")
Closes: https://github.com/pciutils/pciutils/issues/175
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260814070522.2327975-4-kwilczynski@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-bus-pci | 14 ++++++++---
 drivers/pci/pci-label.c                 | 33 ++++++++++++++++++++++++-
 2 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index 6c5ca95a94105..905be699be1c6 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -244,10 +244,16 @@ Contact:	Narendra K <narendra_k@dell.com>, linux-bugs@dell.com
 Description:
 		Reading this attribute will provide the firmware
 		given name (SMBIOS type 41 string or ACPI _DSM string) of
-		the PCI device.	The attribute will be created only
-		if the firmware	has given a name to the PCI device.
-		ACPI _DSM string name will be given priority if the
-		system firmware provides SMBIOS type 41 string also.
+		the PCI device. The attribute will be created only if the
+		firmware naming mechanism is implemented for the device:
+		a SMBIOS type 41 record with a non-empty reference
+		designation, or a Device Name _DSM that returns the name
+		as a string or a buffer. The value read is empty when the
+		firmware implements the _DSM but gives the device no name,
+		which per PCI Firmware r3.3, sec 4.6.7 the firmware reports
+		as a NULL string. ACPI _DSM string name will be given
+		priority if the system firmware provides SMBIOS type 41
+		string also.
 Users:
 		Userspace applications interested in knowing the
 		firmware assigned name of the PCI device.
diff --git a/drivers/pci/pci-label.c b/drivers/pci/pci-label.c
index 17f1bc0cf458e..f81248a11a18e 100644
--- a/drivers/pci/pci-label.c
+++ b/drivers/pci/pci-label.c
@@ -217,11 +217,42 @@ static umode_t acpi_attr_is_visible(struct kobject *kobj, struct attribute *a,
 				    int n)
 {
 	struct device *dev = kobj_to_dev(kobj);
+	union acpi_object *obj, *tmp;
+	umode_t mode = 0;
 
 	if (!device_has_acpi_name(dev))
 		return 0;
 
-	return a->mode;
+	/*
+	 * The bitmap from _DSM function 0 only advertises function 7,
+	 * and whether the returned object can be parsed is a separate
+	 * question. Evaluate it and expose each attribute only if the
+	 * element it exports has one of the types the read path
+	 * accepts, mirroring the checks in dsm_get_label().
+	 */
+	obj = acpi_evaluate_dsm(ACPI_HANDLE(dev), &pci_acpi_dsm_guid, 0x2,
+				DSM_PCI_DEVICE_NAME, NULL);
+	if (!obj)
+		return 0;
+
+	if (obj->type != ACPI_TYPE_PACKAGE || obj->package.count != 2)
+		goto out;
+
+	tmp = obj->package.elements;
+	if (tmp[0].type != ACPI_TYPE_INTEGER)
+		goto out;
+
+	if (a == &dev_attr_acpi_index.attr)
+		mode = a->mode;
+	else if (a == &dev_attr_label.attr &&
+		 (tmp[1].type == ACPI_TYPE_STRING ||
+		  tmp[1].type == ACPI_TYPE_BUFFER))
+		mode = a->mode;
+
+out:
+	ACPI_FREE(obj);
+
+	return mode;
 }
 
 const struct attribute_group pci_dev_acpi_attr_group = {
-- 
2.53.0



