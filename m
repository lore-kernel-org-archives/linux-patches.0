Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460B052F8A;
	Mon, 11 Dec 2023 18:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c/SDh+3Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81060C433C9;
	Mon, 11 Dec 2023 18:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319725;
	bh=v97y6UFmnBO/2W8j9WUufniuOLMPTCwCGitg1Ux+jXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c/SDh+3Z72UJ1SaOsK2ZKhr8ESf+QeFf97ydPlodmTrAnDT3HMghzlLj6+DX1Pl2X
	 sr3Jp3YAlUHN5OrDqZlWeMX+DpDGrMXB6wFjo+cRAi7FHleMpamveNLranO0dOTO7+
	 7syJkp/c/hpJmSutlPcJfDhrPlI7NZZndVRjH93c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 212/244] serial: 8250_dw: Add ACPI ID for Granite Rapids-D UART
Date: Mon, 11 Dec 2023 19:21:45 +0100
Message-ID: <20231211182055.471917483@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -798,6 +798,7 @@ static const struct acpi_device_id dw825
 	{ "INT33C5", (kernel_ulong_t)&dw8250_dw_apb },
 	{ "INT3434", (kernel_ulong_t)&dw8250_dw_apb },
 	{ "INT3435", (kernel_ulong_t)&dw8250_dw_apb },
+	{ "INTC10EE", (kernel_ulong_t)&dw8250_dw_apb },
 	{ },
 };
 MODULE_DEVICE_TABLE(acpi, dw8250_acpi_match);


