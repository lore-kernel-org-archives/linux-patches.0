Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2E9168C4;
	Mon, 27 May 2024 19:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837940; cv=none; b=UOcpsBl5SslwODXVC+rKA1pPfUuQO74xYFG9Uazt8TU9ylB+LIgfyD1K3p9aZMmXhDErqybOHmhqo1Z44w67BqDgQqUQFcNS89827G9lawd/Eb/6gnaSsaAuuMGRFQ3RjwoVaU4pBVCeOCFBrImvX56/pKLxB84UojpU4rEIJWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837940; c=relaxed/simple;
	bh=PQ/gG/bcpZcBZNOfdyeQWtWJLIkTUoaSFBlUHQ5tftc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gs0LcgWoumDpmCK38ywAjre8fnZyDFz6jZxvBHbYFHTeO20mvL/a5SO8MibilVYuemkrmJlsRXNkxk6HWTVMzo7Ls7kHCGpSAd5LHEGPXmB9h3AKY3DNGIrpISCzdte+YZg/QI5NKs0LZtDKJHWSO5yeNL/gplWRnVqwPrIEasg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1SbhBsb8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1SbhBsb8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80FD0C2BBFC;
	Mon, 27 May 2024 19:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837939;
	bh=PQ/gG/bcpZcBZNOfdyeQWtWJLIkTUoaSFBlUHQ5tftc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1SbhBsb8Deq9BedCEJ7mmD7MD/j0NAolHEc0aqKcZTADw9iVAx/dtY19etZe6m263
	 LckheXGLhrsrg9uV30ZzQGgiKE3SzzOMDH3A7LqS9fC11Wv9n7UnGuSCir7ukOxIhT
	 lS/kyKnTqSq9guV+eLCRh7z25VX/nx1GDLIk9RK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 203/493] ACPI: LPSS: Advertise number of chip selects via property
Date: Mon, 27 May 2024 20:53:25 +0200
Message-ID: <20240527185636.962797094@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 07b73ee599428b41d0240f2f7b31b524eba07dd0 ]

Advertise number of chip selects via property for Intel Braswell.

Fixes: 620c803f42de ("ACPI: LPSS: Provide an SSP type to the driver")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_lpss.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
index 04e273167e92a..8e01792228d1e 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -325,6 +325,7 @@ static const struct lpss_device_desc bsw_i2c_dev_desc = {
 
 static const struct property_entry bsw_spi_properties[] = {
 	PROPERTY_ENTRY_U32("intel,spi-pxa2xx-type", LPSS_BSW_SSP),
+	PROPERTY_ENTRY_U32("num-cs", 2),
 	{ }
 };
 
-- 
2.43.0



