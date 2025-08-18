Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F858321455;
	Mon, 18 Aug 2025 13:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523043; cv=none; b=WabKTkDVnnFbhG8hbLrEXsIUC6dxx2Ziz6p7cUiV4QJeuo3ilPpseJ9gUXf2ADg9Ox+lzzT2OKXJIeOO3y0LgNs1iCf1QJbBnqaQqylVKCwY7Mh9qoxQKCuWLyq+kYKQ2/dbDy9x6gmyjnEnZnLCfc26EhNRbOc9kkwXwoVINB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523043; c=relaxed/simple;
	bh=HNkfyjSAqrHKcGO6EeIpXeuzzgUUXmsbsFmdKvRgpVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QhalMPeOCYcWtnagZIbmYOzM4Mfkjx2ajyUV2HHKg8ucsM4V97pbvVBeS9z7s+Rzo4S2bFoZUBqO8AiaYawwkVeJzJQ08H51wNtVgVAO+bla9ZX9lcBC2lWQXp3Pzxxb6PZGPUjnWE1Dkq9RCv5ov1hFSogYdBfVtRt1IceKmKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kbagNt8M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kbagNt8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007C5C4CEEB;
	Mon, 18 Aug 2025 13:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523043;
	bh=HNkfyjSAqrHKcGO6EeIpXeuzzgUUXmsbsFmdKvRgpVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kbagNt8MJ9gohHNeo88INCoZPLk/wlBLUe89av6QmkqXgj3XyJHeCPnKe60Zy7FzD
	 p8Pe9wLpqItAcmUg+dhY9cR6I1feIPIZiXQhgCbuUI7e2dURTWdVomS0dqCMZLIbc7
	 oYsZfT+RtvzZfwR77RiNtriHazqyY7I9XKjnu2ME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yevhen Kondrashyn <e.kondrashyn@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.15 046/515] Documentation: ACPI: Fix parent device references
Date: Mon, 18 Aug 2025 14:40:32 +0200
Message-ID: <20250818124500.196190621@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit e65cb011349e653ded541dddd6469c2ca813edcf upstream.

The _CRS resources in many cases want to have ResourceSource field
to be a type of ACPI String. This means that to compile properly
we need to enclosure the name path into double quotes. This will
in practice defer the interpretation to a run-time stage, However,
this may be interpreted differently on different OSes and ACPI
interpreter implementations. In particular ACPICA might not correctly
recognize the leading '^' (caret) character and will not resolve
the relative name path properly. On top of that, this piece may be
used in SSDTs which are loaded after the DSDT and on itself may also
not resolve relative name paths outside of their own scopes.
With this all said, fix documentation to use fully-qualified name
paths always to avoid any misinterpretations, which is proven to
work.

Fixes: 8eb5c87a92c0 ("i2c: add ACPI support for I2C mux ports")
Reported-by: Yevhen Kondrashyn <e.kondrashyn@gmail.com>
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20250710170225.961303-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/firmware-guide/acpi/i2c-muxes.rst |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/firmware-guide/acpi/i2c-muxes.rst
+++ b/Documentation/firmware-guide/acpi/i2c-muxes.rst
@@ -14,7 +14,7 @@ Consider this topology::
     |      |   | 0x70 |--CH01--> i2c client B (0x50)
     +------+   +------+
 
-which corresponds to the following ASL::
+which corresponds to the following ASL (in the scope of \_SB)::
 
     Device (SMB1)
     {
@@ -24,7 +24,7 @@ which corresponds to the following ASL::
             Name (_HID, ...)
             Name (_CRS, ResourceTemplate () {
                 I2cSerialBus (0x70, ControllerInitiated, I2C_SPEED,
-                            AddressingMode7Bit, "^SMB1", 0x00,
+                            AddressingMode7Bit, "\\_SB.SMB1", 0x00,
                             ResourceConsumer,,)
             }
 
@@ -37,7 +37,7 @@ which corresponds to the following ASL::
                     Name (_HID, ...)
                     Name (_CRS, ResourceTemplate () {
                         I2cSerialBus (0x50, ControllerInitiated, I2C_SPEED,
-                                    AddressingMode7Bit, "^CH00", 0x00,
+                                    AddressingMode7Bit, "\\_SB.SMB1.CH00", 0x00,
                                     ResourceConsumer,,)
                     }
                 }
@@ -52,7 +52,7 @@ which corresponds to the following ASL::
                     Name (_HID, ...)
                     Name (_CRS, ResourceTemplate () {
                         I2cSerialBus (0x50, ControllerInitiated, I2C_SPEED,
-                                    AddressingMode7Bit, "^CH01", 0x00,
+                                    AddressingMode7Bit, "\\_SB.SMB1.CH01", 0x00,
                                     ResourceConsumer,,)
                     }
                 }


