Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06ABE224F6;
	Tue,  8 Apr 2025 11:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110717; cv=none; b=GF8ho4tH1g5a75ad+2EfZaS8gBjOPuVzKXFdu+2jaWCVdP8yg17eISXB34M16/diTjc3W61LmbzFQKq0Z5aJop+FnLBTxGdKACkZaLWR1FQGXS1ysAJuz8q7cMusStDksur4/JkS2sRS1NfLKSdrXhS1YblHaXkEvWBU4R4aRpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110717; c=relaxed/simple;
	bh=doy0jDcbY8GXk0aCzNQ38JaXuuAqNAVAzN/IW3k6rrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eN5MowXXL7XAf9rorDTMqtuhJ98AE49cDcZ6MtFFKCz5FAkdN6mKaUhhEjcujrk7kpuPGWFOlRsJSI9SQQheG/p9iWG99A5FZP9e1p0mJFc4sjQrzJs0zVUChmTTXLskuQg+199B0B5LYjeYEDepIlLaFl3o6DXKATaV7mTo1xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RfKcga/m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RfKcga/m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D42C4CEE5;
	Tue,  8 Apr 2025 11:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110716;
	bh=doy0jDcbY8GXk0aCzNQ38JaXuuAqNAVAzN/IW3k6rrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RfKcga/mhqfUhPag1cUzU/HsC4mgo9IysMQ9Co5iT4LaPvlUyJfBcPrfNNaG14jio
	 WQ7a+INNKRm7dU7hY603Yu9Ev+D+4im1EyAvvwhCnrikR8QI9xoJTUg6O+xPQVMBdK
	 8izyL53eV8/ugF0kBy4a7LSATt959N+2aBw0cVBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 165/731] iommu/amd: Fix header file
Date: Tue,  8 Apr 2025 12:41:02 +0200
Message-ID: <20250408104918.113616859@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasant Hegde <vasant.hegde@amd.com>

[ Upstream commit ee4cf9260afe8e4be6b6d64f56fa7493d051d8de ]

Move function declaration inside AMD_IOMMU_H defination.

Fixes: fd5dff9de4be ("iommu/amd: Modify set_dte_entry() to use 256-bit DTE helpers")
Fixes: 457da5764668 ("iommu/amd: Lock DTE before updating the entry with WRITE_ONCE()")
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20250227162320.5805-6-vasant.hegde@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/amd_iommu.h | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index 68debf5ee2d75..e3bf27da1339e 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -176,12 +176,11 @@ void amd_iommu_apply_ivrs_quirks(void);
 #else
 static inline void amd_iommu_apply_ivrs_quirks(void) { }
 #endif
+struct dev_table_entry *amd_iommu_get_ivhd_dte_flags(u16 segid, u16 devid);
 
 void amd_iommu_domain_set_pgtable(struct protection_domain *domain,
 				  u64 *root, int mode);
 struct dev_table_entry *get_dev_table(struct amd_iommu *iommu);
-
-#endif
-
-struct dev_table_entry *amd_iommu_get_ivhd_dte_flags(u16 segid, u16 devid);
 struct iommu_dev_data *search_dev_data(struct amd_iommu *iommu, u16 devid);
+
+#endif /* AMD_IOMMU_H */
-- 
2.39.5



