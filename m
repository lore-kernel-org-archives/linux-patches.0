Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A295C1A3BAC;
	Thu,  6 Jun 2024 14:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683234; cv=none; b=At/Pos3Uzuc14omoWJn9GS5lCdaMneVrQQtuEkgdpD08EeMo5qG5KLzLfjl0C0mFzcxjTtV7n+p9BS/673UQzQI/XJ/KCPkDvDFW1lk19jEpkseqL0WCKRVbgPlKY2l3RGFpygAZlOzf9rBIoeyPsO+yH0AUGLruqSRzzCjM9H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683234; c=relaxed/simple;
	bh=7f7BclwGjDRQp2ucrTkGsUX2vlL4Swxkj0oclSt3ICw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PI3Jixu1/CsCj88RDSCWr1iUGm0GrT5ehU/dekjhkQ4boVR/jz4M2KbsMx4sU1xH+lDug7Gtau0FtXU92uXZbgSKWj2/ViDs8Y1vcCJP4Iv76eC0pXgfHq7+XMMLqxgJwAbCZnQn7ALnlxiCyE7BVsBHHzfP1npvZQlFPuirU6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l3NaTXSw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l3NaTXSw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81693C2BD10;
	Thu,  6 Jun 2024 14:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683234;
	bh=7f7BclwGjDRQp2ucrTkGsUX2vlL4Swxkj0oclSt3ICw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l3NaTXSwJd8c6JmzjDKH2OtQSqIc7w6NRj/j3w8/AMApd9JJ987qvaBxGGCgvS/c6
	 Xy7JxNI3h8K7DrTOAfqh2C8Tk77/9eYN9cIYvjxf8HUhHwmkJ1MLc2dnWZLCLNjek/
	 1gK7LhGdLR9dOvRJNXHrvDKvv1aqO8udK82QCUPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 112/473] ACPI: LPSS: Advertise number of chip selects via property
Date: Thu,  6 Jun 2024 16:00:41 +0200
Message-ID: <20240606131703.630985620@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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
index 8b44743945c8b..52af775ac1f16 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -319,6 +319,7 @@ static const struct lpss_device_desc bsw_i2c_dev_desc = {
 
 static const struct property_entry bsw_spi_properties[] = {
 	PROPERTY_ENTRY_U32("intel,spi-pxa2xx-type", LPSS_BSW_SSP),
+	PROPERTY_ENTRY_U32("num-cs", 2),
 	{ }
 };
 
-- 
2.43.0



