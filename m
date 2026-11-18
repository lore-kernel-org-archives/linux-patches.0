Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015817;
	b=CwuMeZu95S21heQjcqnbFWMHBfga0UhwmRKCVGptnaiyiqkel412oUVQG0Z6ODKCUpVT
	 3yizuAbWyLvbamknwQDLpYcWLIG56+zVbD7QmmBsloks4PPIjYTY5uFrIR28LdRBZRcdz
	 +PgWTrfpDh5ntlq8+VPwbz32fz983Hlci/MhUr2WwNtBVvQSfLn00vytb1pkPwg1ni6Ny
	 XaWcLMacggRgjZ8tvFuqKY4moB3btBKqO6EG67WWOxbzfsGQy4gDCeG5ely++JPQpHSDP
	 se29HV9CSvF6bsGokRn0TME6xaSt2QT7We6a1+CPRfiKuFtReyRcitkECCRrNj3aPLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015817;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/E9zeBlH9wyMyEWUNmZe6/QhzfOvJURI5EKTwQQyfKs=;
	b=hCvICxA23TfvVJHjIB2r1spQgAn+Mh/u7aHwFbcP6EhJrjNqKOPmsnO9Ee3xduLZSP9a
	 fxI9T+5IBhaLyusvJy3l3uYz9Vq/w+dAiAuC2++6lwHG0vbqFVOymLm5VJW5mtd8qEMdN
	 c9TUfoU0GfuHlR8JUo9UEsOw38hIRijTEHCMaNh2ttkBoh6Nn/Y7+5DFUUFCWTPxdAAzM
	 MXutnsDt364JA5oGPfyAqkzMHI9Q7VBQsz5LDljvHO2KYqhC6LtxXYMFhDLJqUVIHn2HF
	 Wm9/Acr8yYTvClIeqrxRyF6dG6LJcDlfOvg/I6OyAzEd/4GWIzfUOUWLOD94eape9iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cosEDWSt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC4A606A32A;
	Wed, 18 Nov 2026 15:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cosEDWSt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB821F000C7;
	Wed, 18 Nov 2026 15:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015817;
	bh=/E9zeBlH9wyMyEWUNmZe6/QhzfOvJURI5EKTwQQyfKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cosEDWStKf0s5yAmQRmZkb5Z1hGrPcLZeGAyUeAGnG9bFHxmgHQd8Dnn9h8TIP/iR
	 sGuzxFzjJsdGLhdPi9GrgT6wbFso0inIl2RTpbSa4YYTzVJ+bEl1OymEvg94BRKzGC
	 UnbtyEiHr/UnsKn/TcIdx/EC5qP2noLTrJtoMySY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0309/2651] ACPI: glue: Reduce debug noise from acpi_device_notify()
Date: Wed, 18 Nov 2026 15:25:49 +0100
Message-ID: <20261118150259.017143055@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 5bc1e72f80da4c20ce8b57851be4fad67e855ebd ]

When debug is enabled in the ACPI glue code that handles binding
devices to ACPI companions, acpi_device_notify() produces a lot of
message noise related to devices that have no ACPI companions.

Reduce that noise by checking the most obvious case, ACPI device
objects, directly and returning from acpi_device_notify() in that
case without printing any debug messages.  Also avoid printing a
debug message when there is no matching ACPI bus type definition for
the given device, which is the case for the vast majority of devices.

Additionally, make the debug messages that get printed more informative.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/6325978.lOV4Wx5bFT@rafael.j.wysocki
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: aef7792cddca ("ACPI: glue: Rework the success message in acpi_device_notify()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/glue.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
index b1776809279dd..a2a394c226b3f 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -354,22 +354,27 @@ void acpi_device_notify(struct device *dev)
 	struct acpi_device *adev;
 	int ret;
 
+	/* ACPI devices have no ACPI companions. */
+	if (dev->bus == &acpi_bus_type)
+		return;
+
 	ret = acpi_bind_one(dev, NULL);
 	if (ret) {
 		struct acpi_bus_type *type = acpi_get_bus_type(dev);
 
 		if (!type)
-			goto err;
+			return;
 
 		adev = type->find_companion(dev);
 		if (!adev) {
 			dev_dbg(dev, "ACPI companion not found\n");
-			goto err;
+			return;
 		}
 		ret = acpi_bind_one(dev, adev);
-		if (ret)
-			goto err;
-
+		if (ret) {
+			dev_dbg(dev, "Binding to ACPI companion failed\n");
+			return;
+		}
 		if (type->setup) {
 			type->setup(dev);
 			goto done;
@@ -391,11 +396,6 @@ void acpi_device_notify(struct device *dev)
 done:
 	acpi_handle_debug(ACPI_HANDLE(dev), "Bound to device %s\n",
 			  dev_name(dev));
-
-	return;
-
-err:
-	dev_dbg(dev, "No ACPI support\n");
 }
 
 void acpi_device_notify_remove(struct device *dev)
-- 
2.53.0



