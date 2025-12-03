Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2276B35B148;
	Wed,  3 Dec 2025 16:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778930; cv=none; b=o0Tlj0WRu8/DQtTXkpGTand8X6mHhd0kQVTaX+wQx6qwC/bUL08PJFi5XBKyxcAdNGywc5v7KWr2In6l6wf8gKrJL8ooO1zqXPm86EkLAmmMcMCNN0YxwQVgSBbgD9zTK+Tr51vENVMad2LT7SFjvKD6+2hyJy/GQzoBiwcOB8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778930; c=relaxed/simple;
	bh=FGfrvbshCidwMCeZOUHk3n1qUbrMbS/pOa9y+V9/x78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GBKrp6jBPn/3mZY8motskWfSLrthkMgHdPzwsjwJAVNXrLPdRRCm0X6CmCVUS+4Y5P9MDcIxrl8SETIWLOECug/KrqM+4IdAwiQlBVA72FVEAsFhtEbAxeUf+uqvrNWKEskUGzy9NImoEtEd1gPpv8skskUeFuCXMdgD084SWbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s+3MpbMC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s+3MpbMC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A19DC4CEF5;
	Wed,  3 Dec 2025 16:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778930;
	bh=FGfrvbshCidwMCeZOUHk3n1qUbrMbS/pOa9y+V9/x78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s+3MpbMC1Y6dKvnhj38BKNtblhiimeCoZjNNys/8JzHhCLZA5c+oLt+VAK9xVJmP8
	 ucGM6IzOcPtw9AAr9KNVxHQQ9yf6MwHdY1sWgWV4+Zwct5LzQamdcPaMPGwBdQzD+C
	 L7OF275t76SZ9+O1uZHMQdI7GIL+UjJ0ereaO6s0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Pierre Gondois <pierre.gondois@arm.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Wen Yang <wen.yang@linux.dev>
Subject: [PATCH 6.1 071/568] cacheinfo: Initialize variables in fetch_cache_info()
Date: Wed,  3 Dec 2025 16:21:13 +0100
Message-ID: <20251203152443.309201219@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre Gondois <pierre.gondois@arm.com>

[ Upstream commit ecaef469920fd6d2c7687f19081946f47684a423 ]

Set potentially uninitialized variables to 0. This is particularly
relevant when CONFIG_ACPI_PPTT is not set.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/all/202301052307.JYt1GWaJ-lkp@intel.com/
Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/all/Y86iruJPuwNN7rZw@kili/
Fixes: 5944ce092b97 ("arch_topology: Build cacheinfo from primary CPU")
Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20230124154053.355376-2-pierre.gondois@arm.com
Signed-off-by: Wen Yang <wen.yang@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/cacheinfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/cacheinfo.c
+++ b/drivers/base/cacheinfo.c
@@ -440,7 +440,7 @@ int allocate_cache_info(int cpu)
 int fetch_cache_info(unsigned int cpu)
 {
 	struct cpu_cacheinfo *this_cpu_ci;
-	unsigned int levels, split_levels;
+	unsigned int levels = 0, split_levels = 0;
 	int ret;
 
 	if (acpi_disabled) {


