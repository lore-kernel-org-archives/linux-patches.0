Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22937646;
	Wed,  6 Nov 2024 13:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899147; cv=none; b=AL9pvE5aK1gyRpimNOIz9UxnmnQlfVI1WGB0j9P+SqD/hL2BCi+rPWzmJIVrmlJX7Wsa6/5W1yHkQysquhNaAObStf6enp28Rj8Y+oF+Y6dxvj+PUwoa8Dpt2+pzLrHeapl6/euZ+kfRyUpCTLfUoVQ5A08CeRbjK9eja37j4QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899147; c=relaxed/simple;
	bh=qNdO55ow33wwP//Vff6YvUCFA0US1ZpZJlPX6UCmlDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dcXp9dU0nd/4bvDLIp/2OclhPEaqYQ2pgwXIoHTl+kCkzzcasS291QH8Hem4onLOWnMyl9NM09MPBA+VxfzE8MNSl05l+Lb4lXzdhj+EnVCf3iXlNW97bOYPnLTHbpAfCTUYUtrGHxvmc/wdF1dXexXawBS5pUWNC5nb12om9Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VVe5HVuo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VVe5HVuo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9432DC4CECD;
	Wed,  6 Nov 2024 13:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899147;
	bh=qNdO55ow33wwP//Vff6YvUCFA0US1ZpZJlPX6UCmlDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VVe5HVuo3AyY6/ubnjT2bJd2kk1anIFITQ9Ed1QkX/aizED2CcVu02a9F1kD8f+py
	 s8v7XFI0htkpSh4FhTgKHMgg55kGlZWEScgMnMgc82z7s348y7d3vuTPiAoiUFulpt
	 +xEUDQgsKSq6c8RSHd4qvJU948rjkYJC/EyleYFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aubrey Li <aubrey.li@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 03/73] ACPI: PRM: Remove unnecessary blank lines
Date: Wed,  6 Nov 2024 13:05:07 +0100
Message-ID: <20241106120300.061745108@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aubrey Li <aubrey.li@intel.com>

[ Upstream commit caa2bd07f5c5f09acf62072906daeaa667e2b645 ]

Just remove unnecessary blank lines, no other code changes

Signed-off-by: Aubrey Li <aubrey.li@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 088984c8d54c ("ACPI: PRM: Find EFI_MEMORY_RUNTIME block for PRM handler and context")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/prmt.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/acpi/prmt.c b/drivers/acpi/prmt.c
index 09c0af8a46f0a..8d876bdb08f68 100644
--- a/drivers/acpi/prmt.c
+++ b/drivers/acpi/prmt.c
@@ -49,7 +49,6 @@ struct prm_context_buffer {
 };
 #pragma pack()
 
-
 static LIST_HEAD(prm_module_list);
 
 struct prm_handler_info {
@@ -73,7 +72,6 @@ struct prm_module_info {
 	struct prm_handler_info handlers[];
 };
 
-
 static u64 efi_pa_va_lookup(u64 pa)
 {
 	efi_memory_desc_t *md;
@@ -88,7 +86,6 @@ static u64 efi_pa_va_lookup(u64 pa)
 	return 0;
 }
 
-
 #define get_first_handler(a) ((struct acpi_prmt_handler_info *) ((char *) (a) + a->handler_info_offset))
 #define get_next_handler(a) ((struct acpi_prmt_handler_info *) (sizeof(struct acpi_prmt_handler_info) + (char *) a))
 
@@ -171,7 +168,6 @@ static void *find_guid_info(const guid_t *guid, u8 mode)
 	return NULL;
 }
 
-
 static struct prm_module_info *find_prm_module(const guid_t *guid)
 {
 	return (struct prm_module_info *)find_guid_info(guid, GET_MODULE);
-- 
2.43.0



