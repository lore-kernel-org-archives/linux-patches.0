Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3E235A281;
	Tue, 26 Aug 2025 14:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218869; cv=none; b=VSFyuV8rK/CjKw/rHKt/G1SRCXC6Ux9W8Z7D0F3fSjIyTtJucrvqO0OzkH9GwHqyrvxDWSrnQ7YmlZwfe8/1InUi4ovOueLcaWBsgVYiBAfHplLG6GZR6WkIOmu4Zd/P84NQsO5sVEsiBvv7Nh4IF+qCG5iicMpgbkJ0oOQBiQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218869; c=relaxed/simple;
	bh=jk4UjswWnEytUM626PQH5n8mAkUvloxGP7ygpWnAYH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jAgUH0PDq+r3VE3gEhV9SOsM/RGEqP6k57RPs5tAI/8l3E8uX7XPrQp/n+1HdbLCR2Kp+wPmIegdI9sfqAlp6M6PhKmjtO/Hqn7FU/qB/XgB6v7Amhm/fDhfPxUaijKn/ARc6BVyc9wPyJAyugqdWIstbI4ai1ZWxkl10VEZ/78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=deRFo8nA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="deRFo8nA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76682C4CEF1;
	Tue, 26 Aug 2025 14:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218868;
	bh=jk4UjswWnEytUM626PQH5n8mAkUvloxGP7ygpWnAYH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=deRFo8nAKjINHM20JgBHj7MI5azJcvCdFxg2r5ivZwqk0iVhK5GLkYiG1+IU/6nY+
	 XqWSGnNUSgGH1x/FHJzr9b2Szjp4tToQQAuxijDs//e2dWl2WVOBGS4vUuu5rmvumt
	 Fl2sZbVX5eMnFFYYnk75kSU2zFGn/61h13W0Xldw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yevhen Kondrashyn <e.kondrashyn@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 165/403] Documentation: ACPI: Fix parent device references
Date: Tue, 26 Aug 2025 13:08:11 +0200
Message-ID: <20250826110911.448568370@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


