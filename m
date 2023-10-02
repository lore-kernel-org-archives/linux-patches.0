Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177E9EAD4
	for <patches@lists.linux.dev>; Mon,  2 Oct 2023 11:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696247125; x=1727783125;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=9bwHBLFRV4COs3zXIsaJKBDYTiurCzcYr4Weu9R05qE=;
  b=QfJUA9MYpWtnTUpOzHv+VtElgmQ7aekfOi0AgEaAmAYmvWOVLRkAeKuk
   4jWngzKHk/vniO9kq96JafyRmgl3viRfr/tGaRVCYuZgJSmuMoRyY5lWB
   VOCAoVUdiUx9EQQs4Bg+nQLMsv/nSZtiKBx0ZMgJzV+O3bdCm8Akf4cur
   9LBH2Fk2Mmgnn709Jym21cMFHJpSJqqHJ1eoQaO3qdm55D6/4ikKjYZwu
   B8+KiU5xvcPn5ygjfGVcx1HLNBVQMM1DrqRLBsiosmtiQ8a1wXBNgAQkx
   i98JtenGOSNeeVyr6KWWNDBK9YVkMElA5KbspGxcfRi1+ZDKNhRut7TH9
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10850"; a="381508662"
X-IronPort-AV: E=Sophos;i="6.03,194,1694761200"; 
   d="scan'208";a="381508662"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2023 04:45:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10850"; a="754027255"
X-IronPort-AV: E=Sophos;i="6.03,194,1694761200"; 
   d="scan'208";a="754027255"
Received: from roliveir-mobl1.ger.corp.intel.com ([10.251.222.16])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2023 04:45:19 -0700
Date: Mon, 2 Oct 2023 14:45:16 +0300 (EEST)
From: =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To: Jithu Joseph <jithu.joseph@intel.com>
cc: Hans de Goede <hdegoede@redhat.com>, markgross@kernel.org, 
    tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
    dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
    rostedt@goodmis.org, ashok.raj@intel.com, tony.luck@intel.com, 
    LKML <linux-kernel@vger.kernel.org>, platform-driver-x86@vger.kernel.org, 
    patches@lists.linux.dev, ravi.v.shankar@intel.com, pengfei.xu@intel.com
Subject: Re: [PATCH v3 4/9] platform/x86/intel/ifs: Gen2 Scan test support
In-Reply-To: <20230929202436.2850388-5-jithu.joseph@intel.com>
Message-ID: <36a8ca4-50b5-f177-d1c0-5fddaac5041@linux.intel.com>
References: <20230922232606.1928026-1-jithu.joseph@intel.com> <20230929202436.2850388-1-jithu.joseph@intel.com> <20230929202436.2850388-5-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1504648656-1696247123=:2459"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1504648656-1696247123=:2459
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Fri, 29 Sep 2023, Jithu Joseph wrote:

> Width of chunk related bitfields is ACTIVATE_SCAN and SCAN_STATUS MSRs
> are different in newer IFS generation compared to gen0.
> 
> Make changes to scan test flow such that MSRs are populated
> appropriately based on the generation supported by hardware.
> 
> Account for the 8/16 bit MSR bitfield width differences between gen0 and
> newer generations for the scan test trace event too.
> 
> Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> Tested-by: Pengfei Xu <pengfei.xu@intel.com>

Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>


-- 
 i.

--8323329-1504648656-1696247123=:2459--
