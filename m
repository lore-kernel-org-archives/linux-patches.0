Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4482E3B15;
	Tue, 15 Jul 2025 13:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586971; cv=none; b=rmlrGNNJ04WxnaiLO5gKHPfgwrQFNcbuVicaYQDlBv6lmd2lwRiYREL0q3g2MTIi4FlzA8+4OBiZeP/nmlTXw4ldyTQUzVqDYL+5O7L/W7AFUttITaR1c/lW8zT9TU4X1lwxBEHFQ0QF24Qo0o8WcCaSWkStvyRZvBbnMzybYhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586971; c=relaxed/simple;
	bh=a2Xty2b/4V1PyQijERpuK9J90ZEn/o+rN4WlXWPn/oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYTeq/+OkOsl9UMRPxG4M7hSpjcBfU0+xisrYx/PwGWwB8tc3oENvyTqw7bG94JJH1WxZqN7REOvh1a/AicXTI32CO5yhMbDyQ4kdQDKkfmA0oi+hFsfjhoBoXwxB2HMIO5k5m4dg994kYssutuBDiL+uV6h/MdG4o1qn6ztPEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=saKHlHC8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="saKHlHC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927B5C4CEE3;
	Tue, 15 Jul 2025 13:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586970;
	bh=a2Xty2b/4V1PyQijERpuK9J90ZEn/o+rN4WlXWPn/oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=saKHlHC8tgHmMXCLucB1vgg6ijQRDNslCqr2bRlW09PISzDJs13peWE6i3iZT59nD
	 iZisMZ1LC2mrGOu83T12FA4nMczBpY+voXfxINGjYppE9DCqfdlYQdgyZlLvwWUIAl
	 OuQ8m0Z5ZxbB/lXUjmWf7Ao8YqCISRitza5CtOFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.15 090/192] Revert "drm/xe/xe2: Enable Indirect Ring State support for Xe2"
Date: Tue, 15 Jul 2025 15:13:05 +0200
Message-ID: <20250715130818.520611756@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

From: Matthew Brost <matthew.brost@intel.com>

commit daa099fed50a39256feb37d3fac146bf0d74152f upstream.

This reverts commit fe0154cf8222d9e38c60ccc124adb2f9b5272371.

Seeing some unexplained random failures during LRC context switches with
indirect ring state enabled. The failures were always there, but the
repro rate increased with the addition of WA BB as a separate BO.
Commit 3a1edef8f4b5 ("drm/xe: Make WA BB part of LRC BO") helped to
reduce the issues in the context switches, but didn't eliminate them
completely.

Indirect ring state is not required for any current features, so disable
for now until failures can be root caused.

Cc: stable@vger.kernel.org
Fixes: fe0154cf8222 ("drm/xe/xe2: Enable Indirect Ring State support for Xe2")
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://lore.kernel.org/r/20250702035846.3178344-1-matthew.brost@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 03d85ab36bcbcbe9dc962fccd3f8e54d7bb93b35)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_pci.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_pci.c
+++ b/drivers/gpu/drm/xe/xe_pci.c
@@ -137,7 +137,6 @@ static const struct xe_graphics_desc gra
 	.has_asid = 1, \
 	.has_atomic_enable_pte_bit = 1, \
 	.has_flat_ccs = 1, \
-	.has_indirect_ring_state = 1, \
 	.has_range_tlb_invalidation = 1, \
 	.has_usm = 1, \
 	.has_64bit_timestamp = 1, \


