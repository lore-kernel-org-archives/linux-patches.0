Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC2C79C2;
	Sat, 30 Dec 2023 12:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kSf6ayK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378B2C433C8;
	Sat, 30 Dec 2023 12:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938087;
	bh=bsL6zdOSV6W80LL9kzzMI6BpBHSU1GDQjBiTfs440N4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kSf6ayK3TmKLFVQ1J5GYmb5HeGcHMTpK05onWxTvn2dwS8gCboGlaSpW8/tBheXUu
	 0bHuh7h9V+0bLV9y94EnrvNilJsmXdXIDFW3viVMh7Qce12p2t2nfsFg/SM6iPhJbQ
	 OmPCBme0gQZ58tFhKL4xQ6QYiIsfKZrsNjKS7xkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 003/112] HID: i2c-hid: acpi: Unify ACPI ID tables format
Date: Sat, 30 Dec 2023 11:58:36 +0000
Message-ID: <20231230115806.842131016@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115806.714618407@linuxfoundation.org>
References: <20231230115806.714618407@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 4122abfed2193e752485282370abf5c419f05cad ]

Unify ACPI ID tables format by:
- surrounding HID by spaces
- dropping unnecessary driver_data assignment to 0
- dropping comma at the terminator entry

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Stable-dep-of: a9f68ffe1170 ("HID: i2c-hid: Add IDEA5002 to i2c_hid_acpi_blacklist[]")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/i2c-hid/i2c-hid-acpi.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid-acpi.c b/drivers/hid/i2c-hid/i2c-hid-acpi.c
index b96ae15e0ad91..171332fef6d14 100644
--- a/drivers/hid/i2c-hid/i2c-hid-acpi.c
+++ b/drivers/hid/i2c-hid/i2c-hid-acpi.c
@@ -39,8 +39,8 @@ static const struct acpi_device_id i2c_hid_acpi_blacklist[] = {
 	 * The CHPN0001 ACPI device, which is used to describe the Chipone
 	 * ICN8505 controller, has a _CID of PNP0C50 but is not HID compatible.
 	 */
-	{"CHPN0001", 0 },
-	{ },
+	{ "CHPN0001" },
+	{ }
 };
 
 /* HID I²C Device: 3cdff6f7-4267-4555-ad05-b30a3d8938de */
@@ -115,9 +115,9 @@ static int i2c_hid_acpi_probe(struct i2c_client *client)
 }
 
 static const struct acpi_device_id i2c_hid_acpi_match[] = {
-	{"ACPI0C50", 0 },
-	{"PNP0C50", 0 },
-	{ },
+	{ "ACPI0C50" },
+	{ "PNP0C50" },
+	{ }
 };
 MODULE_DEVICE_TABLE(acpi, i2c_hid_acpi_match);
 
-- 
2.43.0



