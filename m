Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591FA3546E5;
	Fri, 21 Nov 2025 13:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733409; cv=none; b=XdR90T0jFzMgnckv8PBP2iFRr6VOGzvJXeND1URDR4ZF/UeUv94fupabQQpbOiuPK6XKXy14sMsjRgFbWPSukOV4ybE5QtHa8bV5eNvZrGiCKapnzH+7Gid0qbYVr9apVBloqfLTN+4t2jNE0sKMgXJmB8BFhJ4hP9lRPoi07tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733409; c=relaxed/simple;
	bh=KVC4LRNo1Zd7rB0I2Ix4yEKc/Nzu8yZga32a6RW3eEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYS0Q5rPY4pXesMm7Yq0UXi3+6hl6NwJT5XkgjdaDVePsliiaZA8b5jftJjy89UMWtRN7gqOyHuCurDRt68nKSZyX2R0Ny35drFP3Dq1o7uEyJo4psrIsQqUu6WQW8Zk1JuQMtE2EXgx5HckzDQP+zheW4n+Xz2ZaR2rBh4iIlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2PtLu8ry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2PtLu8ry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F34C16AAE;
	Fri, 21 Nov 2025 13:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733406;
	bh=KVC4LRNo1Zd7rB0I2Ix4yEKc/Nzu8yZga32a6RW3eEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2PtLu8ryzjEU/4slL19k0IY3h6n+BsNBs3eOGDcRpKMGVIirbwCn+R124J6hN5aA1
	 PEvp/jklvHV+TGsfAq+8k6xvik79VfxmRC65ncqG+XbjhQBHu+DSVwYKnQJEGlVGi8
	 EXcmwSys9X4E6RdV0e3Ebj6lJDZv0fzgRG0bLw6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wu Zongyong <wuzongyong@linux.alibaba.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 424/529] acpi,srat: Fix incorrect device handle check for Generic Initiator
Date: Fri, 21 Nov 2025 14:12:03 +0100
Message-ID: <20251121130246.102297961@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Shuai Xue <xueshuai@linux.alibaba.com>

[ Upstream commit 7c3643f204edf1c5edb12b36b34838683ee5f8dc ]

The Generic Initiator Affinity Structure in SRAT table uses device
handle type field to indicate the device type. According to ACPI
specification, the device handle type value of 1 represents PCI device,
not 0.

Fixes: 894c26a1c274 ("ACPI: Support Generic Initiator only domains")
Reported-by: Wu Zongyong <wuzongyong@linux.alibaba.com>
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Link: https://patch.msgid.link/20250913023224.39281-1-xueshuai@linux.alibaba.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/numa/srat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/numa/srat.c b/drivers/acpi/numa/srat.c
index a44c0761fd1c0..848942bf883cb 100644
--- a/drivers/acpi/numa/srat.c
+++ b/drivers/acpi/numa/srat.c
@@ -140,7 +140,7 @@ acpi_table_print_srat_entry(struct acpi_subtable_header *header)
 		struct acpi_srat_generic_affinity *p =
 			(struct acpi_srat_generic_affinity *)header;
 
-		if (p->device_handle_type == 0) {
+		if (p->device_handle_type == 1) {
 			/*
 			 * For pci devices this may be the only place they
 			 * are assigned a proximity domain
-- 
2.51.0



