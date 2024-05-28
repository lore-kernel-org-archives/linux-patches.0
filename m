Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1E82E639
	for <patches@lists.linux.dev>; Tue, 28 May 2024 17:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716917677; cv=none; b=BlhsNLDrjPoeink9/JLC6XoiEB5TfA2Z981OZQmo0bPkfg5sGVohV4ec8f7rv3v8T0hy7ZjbITWKbflIIl8c9UK60QqjVnp2MH1BMET03R1xfsU3SXpmSvlvUHkRoyfsGSwC+hsBfxTNoQNuCe6FDfoLukN+W4cqjcKPbWH1e9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716917677; c=relaxed/simple;
	bh=oNf7hRVWlT7QmXyu7aUdL8U1XDNCrdBSmqJn/7FvJps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y1uFpUKEx2/xM8I93APyZ1NDTWhKVlgYsq4IM8UiW/jta8OtC9+dX8rLqp29hxvKyTD9LTzREbfFHON0ICiLf3JEKUJdbtM4tijcDOHxDdFtLNBr71zzPPHVt9rAoE/W3WEkjocXvfbSf6+xWcavZ4aUdK6l3W3Noi0HTU49AYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OF7PnOuG; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OF7PnOuG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716917676; x=1748453676;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oNf7hRVWlT7QmXyu7aUdL8U1XDNCrdBSmqJn/7FvJps=;
  b=OF7PnOuG7qJFT5a9m4mGN5kDzwE8bpYiJc3S54G3x9y3PrWoAg+ewsXi
   jyY7y6+wxSy8nTaq8khevP3caR8ZaISuChxYOmlc29OWrunBbUb6NwqY3
   1Jh71/LDrz04uvROp6UbL2CZI+K0eUtHMcn3sKd85oQ0KJZM19743nWPA
   U3L4d4MtS8N7ZUs+EWPPF202UGqY8hHTdD4bUDscf5WOlx+7hRSKSD1H2
   slX4Zs8Kum9Vsb97T4L14y3lmo18DJZhHfKa1ACi3iNv6ihjMD1pxzl6Q
   4zn3dzvsheQ3DogSiNfK2+xLiMNbm0MuOdANhgno2cwaoeiEWoxi5JJhV
   w==;
X-CSE-ConnectionGUID: HZqUm0HBQ6yLmKU1PkDLwg==
X-CSE-MsgGUID: FZvrd/3rTh2+qEX2+fMgdw==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="24697855"
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="24697855"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 10:34:35 -0700
X-CSE-ConnectionGUID: tNUwdgtNSTGHbue3FBAK3g==
X-CSE-MsgGUID: MOZTW1PcQEmEfwBrDomp6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="39649932"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 10:34:35 -0700
Date: Tue, 28 May 2024 10:34:33 -0700
From: Tony Luck <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Uros Bizjak <ubizjak@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Arnd Bergmann <arnd@arndb.de>, Mateusz Guzik <mjguzik@gmail.com>,
	Thomas Renninger <trenn@suse.de>, Andi Kleen <ak@linux.intel.com>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v6 00/49] New Intel CPUID families
Message-ID: <ZlYVqSlx8GLwTJEr@agluck-desk3.sc.intel.com>
References: <20240520224620.9480-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240520224620.9480-1-tony.luck@intel.com>

x86 maintainers,

Thanks for taking thr first couple dozen patches and getting them
into v6.10-rc1.

I'm poking other subsysystem maintainers to pick up patches that
belong in their trees.

There seem to be around eight patches that still belong to x86
(at least that appears to be what scripts/get_maintainer.pl tells me).

Patch#	File
16	arch/x86/platform/intel-mid/intel-mid.c
28	arch/x86/kernel/cpu/intel.c
29	arch/x86/pci/intel_mid_pci.c
30	arch/x86/virt/vmx/tdx/tdx.c
31	x86/events/intel/core.c
33	arch/x86/include/asm/cpu_device_id.h
34	arch/x86/boot/cpucheck.c
43	arch/x86/events/rapl.c

-Tony
