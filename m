Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A071651C2D;
	Mon, 11 Dec 2023 18:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N3LTTMro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22301C433C8;
	Mon, 11 Dec 2023 18:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320724;
	bh=4NJYC4At217pyovCsvS9b/0ZLUu0tnrWrAoHM5Nvh0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N3LTTMrohgB+1DeYux0bR10PGQbJW8SH2Fn8h+a3c4beYpu2SnwXfY6lSXbEglqsw
	 AS4+xV66mk1osXfL2CeknoKBAUlTVrwkUx50G2JSrPyVrw5aQ2KLl9vOPNQHDwFh6K
	 9rIABC5RvIERY3gnCGr5+QgZpZ/Qg5W3EO/7Bd8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 167/194] serial: 8250_dw: Add ACPI ID for Granite Rapids-D UART
Date: Mon, 11 Dec 2023 19:22:37 +0100
Message-ID: <20231211182044.097249918@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit e92fad024929c79460403acf946bc9c09ce5c3a9 upstream.

Granite Rapids-D has an additional UART that is enumerated via ACPI.
Add ACPI ID for it.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20231205195524.2705965-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_dw.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -795,6 +795,7 @@ static const struct acpi_device_id dw825
 	{ "INT33C5", (kernel_ulong_t)&dw8250_dw_apb },
 	{ "INT3434", (kernel_ulong_t)&dw8250_dw_apb },
 	{ "INT3435", (kernel_ulong_t)&dw8250_dw_apb },
+	{ "INTC10EE", (kernel_ulong_t)&dw8250_dw_apb },
 	{ },
 };
 MODULE_DEVICE_TABLE(acpi, dw8250_acpi_match);


