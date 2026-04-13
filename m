Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F442FE056;
	Mon, 13 Apr 2026 16:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097492; cv=none; b=B3WkxDDL6B2iZWruL2pLwxeIQ5V37qKKgjZ+ZWeGOnGCn5dsFTLjixtLlCIDBPmtYhhcHJITexQan+O7f5HLgd1Ft5TdAAmoRyFB3BSOh4bST933pHkYcagkh2VJgB078SS5LkSpgV/gkVaA0z5prVDoomPndfmE6rug5WU0dO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097492; c=relaxed/simple;
	bh=tGYB8T0ZLn3+BTH2j4pFAFw8KEr7DVKJ7xQyKMcTsDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eCZfcf8ByHdZDwzCqSMNBOdQgP7uQWshyyaOtu6hrOM/ODz/OAMw83k6HU1I7VcuCzq5qzVQjrlJyxayzfj7uaapCb10ulQRV65ifYEU/MPDscr8sHb3N4BBepqRR4KEr/dPjlA2kxf1z513Kn9EMAt+2/dxpFUbdEybtC7bFms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V4gFPMfF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V4gFPMfF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB37C2BCAF;
	Mon, 13 Apr 2026 16:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097491;
	bh=tGYB8T0ZLn3+BTH2j4pFAFw8KEr7DVKJ7xQyKMcTsDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V4gFPMfFdqVUNogCYqt44SIZK3MouvzDZzq7l/pNOQi3WDKBL9767S3Ev2AsgNJR9
	 dF2Xc2ISGuwmYRx5BF/tIyWy8VxXLc/0fHHNFoWCkF8pIGHPVpUkANvOrIr0VimlWU
	 zKalicFE7t00YECAAQV/BFQeNlD27XdzTeZKYlpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 124/570] ACPI: OSL: fix __iomem type on return from acpi_os_map_generic_address()
Date: Mon, 13 Apr 2026 17:54:15 +0200
Message-ID: <20260413155835.088680212@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Dooks <ben.dooks@codethink.co.uk>

[ Upstream commit 393815f57651101f1590632092986d1d5a3a41bd ]

The pointer returned from acpi_os_map_generic_address() is
tagged with __iomem, so make the rv it is returned to also
of void __iomem * type.

Fixes the following sparse warning:

drivers/acpi/osl.c:1686:20: warning: incorrect type in assignment (different address spaces)
drivers/acpi/osl.c:1686:20:    expected void *rv
drivers/acpi/osl.c:1686:20:    got void [noderef] __iomem *

Fixes: 6915564dc5a8 ("ACPI: OSL: Change the type of acpi_os_map_generic_address() return value")
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
[ rjw: Subject tweak, added Fixes tag ]
Link: https://patch.msgid.link/20260311105835.463030-1-ben.dooks@codethink.co.uk
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/osl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 45c5c0e45e332..ee9123d553c83 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -1739,7 +1739,7 @@ acpi_status __init acpi_os_initialize(void)
 		 * Use acpi_os_map_generic_address to pre-map the reset
 		 * register if it's in system memory.
 		 */
-		void *rv;
+		void __iomem *rv;
 
 		rv = acpi_os_map_generic_address(&acpi_gbl_FADT.reset_register);
 		pr_debug("%s: Reset register mapping %s\n", __func__,
-- 
2.51.0



