Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025927;
	b=At6wVw3amZ6DkH8tw16AkvCDAs6mfU2Rvsx2NyjzDjyouy0gkV/67DbTyVJRXz/lutBR
	 ifZ0mQmEcSsT0W6MYRPf0IybsI8cjqQwywPeCy/Y6gh8KGWDfjN92hr6M3HNldIKrZR8l
	 LWKswXPrDVCH4gSQW2axPFUYKQfsDmXJQYcHuYz3pQ3Rxl+caOFo8BEFhrxfy4BUspLI0
	 5koMEU54rA0Avbdu/fG/OjtYmezKYkkB6+kARtxM+LTswMBT/XaejH1LxiMDXv+kIYfOB
	 l5F8BBjgMQXAHboVSG3HHtb4ChiWRLEzGSUU0wS5gMjduXPH+jS/3baW5bAizLMp3sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025927;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=4DKtoci6qjjUiOaEpqJSkxMyeZ009MfLR16WnSytqiU=;
	b=FAD301JpwWuLHn3TQWXfJkg3Hzl4DiH0MfLDu73vd+7V6RM5KPTyC3UwpsxqH+8R5lvO
	 KQwL/Hfn17dEs30wzPfG08RG376X98xzWvf0V5eqMKchZ3tz6VWk3RXaTqx11pjB4nIAp
	 FDiKtA7V9/K+T/XTBFwsL+WANUyizpcZQHv3cVIxqFTVB9azaSyqTJ3FT9+XOF0OhcujJ
	 gHgkE8+UuxC8Qu9wYI+0T6A6crdzO+0LWOnjBTkbJV/kyNOpWUzEO4eF5vv6zJd2bImi1
	 oPF02AyL5mUcK1rOUH8iDTtSG3FnMWoJCdVYdzAi6ds/aOtbSjkmLzauXigUqoiiRaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y14L+UzD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D691C606A333;
	Wed, 18 Nov 2026 18:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y14L+UzD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5AA1F000C5;
	Wed, 18 Nov 2026 18:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025927;
	bh=4DKtoci6qjjUiOaEpqJSkxMyeZ009MfLR16WnSytqiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y14L+UzDK+0iGAldglE1WS2MwUtR5DPFEeYgToqYpsSuJKEoGhdc+hdSIozsVA7Ta
	 VnHANcSMnZtgDabACpy9GeYhuUT+pp9TCeGx+CthomOB3PVKX/KDbM0g8np3RRQg9V
	 ph/bQ0zQho4GnMFZ6LNeshN2s+MMHnOD8QRNkCP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1254/2151] PCI/sysfs: Handle a malformed _DSM result in acpi_attr_is_visible()
Date: Wed, 18 Nov 2026 15:49:49 +0100
Message-ID: <20261118150207.842125758@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 92debe879ffbf..68cd7994bc5f5 100644
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



