Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC41E199381;
	Thu,  6 Jun 2024 14:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683215; cv=none; b=q50Ub6oTRca84WxamRSCuo4Z0BGc5+t0FmVbsscw3lNuOKSfclnM3FriThU6GFgJtDrRaf5iA9UKmVJM8WpMd1I8xf17pqnOeHVX2EoACmnTIQnfP9Rjlj87DrTDU7xaDc7tDTIr6kzngV4ub+NfCDO9d0/EYCGx8BF1qHOwsdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683215; c=relaxed/simple;
	bh=vftM7ZTC1Ml7VjIuB+PER6S09CIX/FaF6WI5cgSyV8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ocpqC4b4osFwsiMF9KWKkA9nnK6aUpH9Nat4l2+LlCCHsqAxkOS0D9L69LofhhDR5CQdDvrBaKplF646/ApamkHH+0OGtK3er+CuN5ZBHDsoDWjgUX+K15r3QJKhBzyHVDH+ZWPUHOJQrBuBfXONlaZW7D5SDdeYfrpY07ISpdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oQHEG3AS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oQHEG3AS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0CCAC2BD10;
	Thu,  6 Jun 2024 14:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683215;
	bh=vftM7ZTC1Ml7VjIuB+PER6S09CIX/FaF6WI5cgSyV8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oQHEG3ASjmc8PHYWCpbMwLHZpdEewNho54luSCAykP5HqWq5nndbjb2mTnEY/oicS
	 nbIcWe3G+XfA7ZlOYfZjtddKIqEOz/DxmVkuPbU+fU1iEqK91eiV9b8+8+u3f+CCPv
	 tK3zLq7meclQEJfNedm5BDBYbGo8wI+zzAYjzHwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 158/744] ACPI: LPSS: Advertise number of chip selects via property
Date: Thu,  6 Jun 2024 15:57:10 +0200
Message-ID: <20240606131737.498385251@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
index a052e0ab19e4c..98a2ab3b68442 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -333,6 +333,7 @@ static const struct lpss_device_desc bsw_i2c_dev_desc = {
 
 static const struct property_entry bsw_spi_properties[] = {
 	PROPERTY_ENTRY_U32("intel,spi-pxa2xx-type", LPSS_BSW_SSP),
+	PROPERTY_ENTRY_U32("num-cs", 2),
 	{ }
 };
 
-- 
2.43.0



