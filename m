Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055926;
	b=rFJVlleI2mchSpTyGoAjNKbOBqqCh5QNwTWt687OxLHkUQLgi/rSlpmJNbsbb3Lr6BMT
	 1RwwjIQ+yZ72K+zqJZTC9dIz3XXKtgnz8W6vgLPB8r3cuMiNjO2Kr5ncWFYacLfHDLkY9
	 IEEXljzkH/vW6PkocEFlHYh3dCKhMm+f9MURYrXbuFwipRZPZ2EMuGogja6ZJ8rQcRrGz
	 Wl3GGFBnaXm7B91Jr36HG36I0KjZ3ENae8G/SQqV0iER+3IHgh2X5J2wVaEJVrPOkLOf2
	 eJs9kS0xbewlYxrNrQiVFIY60ajUNUchFEh77X/wOtPGiczBBJtpmT7Bh5JUkUPoLNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055926;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Y4TCAMnuqHEltfI7WuaZaeZslxXxbbzBjO8HW2H56t8=;
	b=jlukPh5U/vz5En9o50SibdsZwiB0En5qWLko9RpsFH0GkM2SvZxIaeavuc3X0zHFCHQ6
	 JoqtArgurOIBpSIBvgRY5jEwQLF0i6Znp4Yr+JDlfnblpGzVAThLZ6J39cQVKcZE3YxFE
	 I4mwbl3gTvqstvoEiQhM1pZDesHlHvsV3bqXHdKLUBZ5mGFk3Xkb6unGEUMwdGKXIulKk
	 V7odO/nb3vTCpfigw1z1V/saSqzbk8hhrBKFlna7BON/ooJdqy1Z7/MiRo1HBdppPgC0X
	 Gjp8IWUfrfhgdYH17Wi6bGMx84hJYPCAoIBF1EJrhw+X2TKi7bFW6OnYPO37BK5+THQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ywL1mYkY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0476A606A31C;
	Thu, 19 Nov 2026 02:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ywL1mYkY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596E61F000C4;
	Thu, 19 Nov 2026 02:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055925;
	bh=Y4TCAMnuqHEltfI7WuaZaeZslxXxbbzBjO8HW2H56t8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ywL1mYkY+Z4Btk1Z0UyggCWqpX0dAqMApySWDCsahFXqRXy+zF5wvhx0XFUcYzV6D
	 JK6BV7by6p4FRZiTp5AkFRKsU6FUfckiQZtgV8px0Gl4ytclSo8CoChocTQG7x7VNY
	 7DToB5DRPSe/228qWV+pjQ3oQXSGQLuaC4Ov1fz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1804/2214] PCI/sysfs: Handle a malformed _DSM result in acpi_attr_is_visible()
Date: Wed, 18 Nov 2026 15:58:00 +0100
Message-ID: <20261118150123.665608718@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 41a60df789e34..01e5651c96269 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -211,10 +211,16 @@ Contact:	Narendra K <narendra_k@dell.com>, linux-bugs@dell.com
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



