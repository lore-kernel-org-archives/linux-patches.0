Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A560383B0
	for <patches@lists.linux.dev>; Mon,  3 Jun 2024 06:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717397480; cv=none; b=lBtuEMFNJoXFg7TWmz7pTYXzzY2w86DtQvRtO7RkePEmU8kknX9Oam5vxYB6YZR01WTLlUIUZfEuszuC2jOH4tPSzDH+KW2AcLL6d2JKb7/q/TjfWIC13ddr+xDYAX4dUuEaQqmXt9nx4XihXg2ysLn+rkwWxgaC9qOsJicobp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717397480; c=relaxed/simple;
	bh=9nY8Zj3mcfH4cslV1UOEl0jFhRwdGpet7DG1rhJjVk0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=dWLiMDVMnE7BS+Fi5DhfmfRZq6gnvgri6c11FNaFxEtP5+7CIjtUVMeGEFua6zsXgTY24g9FCoQFAQskMY/ncGSGwbZ5fJKl60JxdP+4+/5Ejz+FF96s0w5ZaS41hs0/f1sjqNTO73ioisqIrvyQmD2bPON+2wN6OCQyZRABcME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F8e5OijO; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F8e5OijO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717397478; x=1748933478;
  h=from:to:cc:in-reply-to:references:subject:message-id:
   date:mime-version:content-transfer-encoding;
  bh=9nY8Zj3mcfH4cslV1UOEl0jFhRwdGpet7DG1rhJjVk0=;
  b=F8e5OijOmekvrXixlDFUwOAOf5JnW4ycebxab/mL7LFIgbuX+moLlWxV
   Q2Umtc7BEpedNahXYNv4DpRWE6EfOF4fsvQn+SKk2oSpVowmabyDE1MMy
   H2mzND7P68m4nvZS/WNZ1ess55cdv9n88xaUf8bc9CxCsZWFVF8bjL7et
   cSd/ssBiaVaZqsNHFFoQzmOiKOLTkszZ1FFMqDVEaNOFkQEXIcR0u1JEq
   92ZWJtU9p/iTA/Fm0jW1f46TaPmMc93ZtWKrctb8bh17XRj60Ei5nHn1k
   Rn2gKd+zNG0j3l4eZMLXnA1TcAR0eyuSz+YxfDWDuFmZxKMU/UwYffNcr
   w==;
X-CSE-ConnectionGUID: S92wpDHjTyesVJGOeOmP7g==
X-CSE-MsgGUID: ZsFoTShUTCCVtSs56rxFlw==
X-IronPort-AV: E=McAfee;i="6600,9927,11091"; a="25280586"
X-IronPort-AV: E=Sophos;i="6.08,210,1712646000"; 
   d="scan'208";a="25280586"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2024 23:51:17 -0700
X-CSE-ConnectionGUID: VbJ77d1bRLSfnDxj5WfB9Q==
X-CSE-MsgGUID: /I5RyRRnQM6SHEmFEazmOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,210,1712646000"; 
   d="scan'208";a="67951579"
Received: from ijarvine-desk1.ger.corp.intel.com (HELO localhost) ([10.245.247.161])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2024 23:51:15 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
To: Hans de Goede <hdegoede@redhat.com>, Tony Luck <tony.luck@intel.com>
Cc: platform-driver-x86@vger.kernel.org, x86@kernel.org, 
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
In-Reply-To: <20240531203706.233365-1-tony.luck@intel.com>
References: <20240531203706.233365-1-tony.luck@intel.com>
Subject: Re: [PATCH 00/11] New Intel CPU model defines for x86/platform
Message-Id: <171739747091.1954.13124707407721308581.b4-ty@linux.intel.com>
Date: Mon, 03 Jun 2024 09:51:10 +0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13.0

On Fri, 31 May 2024 13:36:56 -0700, Tony Luck wrote:

> These patches were part of the v6 patch bomb converting everything.
> Link: https://lore.kernel.org/all/20240520224620.9480-1-tony.luck@intel.com/
> 
> This reposting as requested by maintainer to make it easier to
> pick up and apply.
> 
> Changes since that post:
> 
> [...]


Thank you for your contribution, it has been applied to my local
review-ilpo branch. Note it will show up in the public
platform-drivers-x86/review-ilpo branch only once I've pushed my
local branch there, which might take a while.

The list of commits applied:
[01/11] platform/x86/intel/pmc: Switch to new Intel CPU model defines
        commit: 33af65ad67495e61e5008beb1f7fbede22f85318
[02/11] platform/x86: intel_telemetry: Switch to new Intel CPU model defines
        commit: 0ff9c76fda20fbd5af079f38581db64b55832929
[03/11] x86/platform/atom: Switch to new Intel CPU model defines
        commit: 5b3eaf10e2e0a3df5c8dfd6aabc6aec435383ba0
[04/11] platform/x86: p2sb: Switch to new Intel CPU model defines
        commit: fad21268dc3141bbe63a8556fe5f771af4e11ecc
[05/11] platform/x86: intel_turbo_max_3: Switch to new Intel CPU model defines
        commit: 70a4fa3f4fc14599aae7af22d649420ab0ac7d23
[06/11] platform/x86: intel_ips: Switch to new Intel CPU model defines
        commit: 12929ac3ef8d24f8931020135786e0b8a773e7c9
[07/11] platform/x86: intel-uncore-freq: Switch to new Intel CPU model defines
        commit: 568e639a617f0a571bf7ee75488637a10d3d02af
[08/11] platform/x86: intel_speed_select_if: Switch to new Intel CPU model defines
        commit: a42f41466f986d0f607fa727242b6e0f871993ca
[09/11] platform/x86: intel_scu_wdt: Switch to new Intel CPU model defines
        commit: d30f57b7413fc02d9899effd4084512603c134a7

--
 i.

