Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F5719CD1B;
	Sun, 11 May 2025 20:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746996378; cv=none; b=NjINNUwRk4QvYgCeABTfE2Jqu2+hwozsmm/IO150Tcb+Wv3J4nH8UWxq/DxD7scv4DrPbS+ZArYJ2+HFO4fIrBpb3y1co75VHFL6sCKnzbSKFjbCDE9QFlRVMUYS61911c2JPuEC5r6iE3bG1xy0FityojZes6e5VkWMeavYuk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746996378; c=relaxed/simple;
	bh=iCjSfWpDxAtoOc8GvSfo01HZ5iHt42za8DP5zxzA8qg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=o8b4KdMMwLO0cg3ersPxJwReFpNwqD5WmGCmwWg5wXHOluqDX14nwSlp7jSJUqwgjaAt6Qfg9LLoSbpYnsgveH5sBdGfhN4NYVklXbOloLrMKxmwy0FL2VXUP2J2icVKReoRzWSaepk87FRWfW3YBReSOsWKtSVNM5/9jU1gK/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kFBA19ZS; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kFBA19ZS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746996376; x=1778532376;
  h=from:to:cc:in-reply-to:references:subject:message-id:
   date:mime-version:content-transfer-encoding;
  bh=iCjSfWpDxAtoOc8GvSfo01HZ5iHt42za8DP5zxzA8qg=;
  b=kFBA19ZSG4lRsWkhjcBqB5jFvOz3rtI51eIt+tbzfMn8PGhFX4fj+TgF
   YVUnyRW4VUCHg5C0IQbsoKeweeim22ZjIvnKDCqexXGWbsC0pPn9zIbYe
   91i7Rav/yBCpqPSvfJN2DfS/lxDrSdXpj1jN1ClYTidk0iDV1GePBPgEY
   MPeA3yWF4It/9u8nl8VNVIqbMuhQEdIa88u0X+k9QktFvyrvSKCFISCtU
   ZSpC+TXldsO1Bo9VVJvpu/jOVYqTmlytYRdsySw6tLoH8u20gO616bM83
   D9PViq3cnqJNxRYhl64jqH2We0LVNcplzGfcTSiQfRA11ohWJAf3Obvjk
   g==;
X-CSE-ConnectionGUID: wRsUCxs0SxO/NGlA5/JX2A==
X-CSE-MsgGUID: vs9m8y87SV+wnUOct+Fc+w==
X-IronPort-AV: E=McAfee;i="6700,10204,11430"; a="59444736"
X-IronPort-AV: E=Sophos;i="6.15,281,1739865600"; 
   d="scan'208";a="59444736"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2025 13:46:15 -0700
X-CSE-ConnectionGUID: 1HQNhrMITiKnD6hSLyyWiQ==
X-CSE-MsgGUID: 6RyRpZqGQLK+ROoUeFnN3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,281,1739865600"; 
   d="scan'208";a="137189074"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.117])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2025 13:46:13 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
To: Hans de Goede <hdegoede@redhat.com>, 
 Vadim Pasternak <vadimp@nvidia.com>, Nathan Chancellor <nathan@kernel.org>
Cc: Michael Shych <michaelsh@nvidia.com>, 
 platform-driver-x86@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev
In-Reply-To: <20250509-nvsw-sn2200-fix-items-busbar-hotplug-v1-1-8844fff38dc8@kernel.org>
References: <20250509-nvsw-sn2200-fix-items-busbar-hotplug-v1-1-8844fff38dc8@kernel.org>
Subject: Re: [PATCH] platform: mellanox: nvsw-sn2200: Fix .items in
 nvsw_sn2201_busbar_hotplug
Message-Id: <174699636829.1989.8868622516931156810.b4-ty@linux.intel.com>
Date: Sun, 11 May 2025 23:46:08 +0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13.0

On Fri, 09 May 2025 11:58:01 +0100, Nathan Chancellor wrote:

> Clang warns (or errors with CONFIG_WERROR=y):
> 
>   drivers/platform/mellanox/nvsw-sn2201.c:531:32: error: variable 'nvsw_sn2201_busbar_items' is not needed and will not be emitted [-Werror,-Wunneeded-internal-declaration]
>     531 | static struct mlxreg_core_item nvsw_sn2201_busbar_items[] = {
>         |                                ^~~~~~~~~~~~~~~~~~~~~~~~
> 
> nvsw_sn2201_busbar_items is only used in ARRAY_SIZE(), which uses
> sizeof(), so this variable is only used at compile time. It appears that
> this may be a copy and paste issue, so use nvsw_sn2201_busbar_items as
> the .items member in nvsw_sn2201_busbar_hotplug, clearing up the
> warning.
> 
> [...]


Thank you for your contribution, it has been applied to my local
review-ilpo-next branch. Note it will show up in the public
platform-drivers-x86/review-ilpo-next branch only once I've pushed my
local branch there, which might take a while.

The list of commits applied:
[1/1] platform: mellanox: nvsw-sn2200: Fix .items in nvsw_sn2201_busbar_hotplug
      commit: 8e725ff0419ad74dc79abfbdcd4cfba936a5d167

--
 i.

