Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403961C3D
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 10:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EQaTSzMh"
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696503099; x=1728039099;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=BFr4H6MozJ7QEfc0QO/jO0A3h1tNpq51OwhnmLN17pY=;
  b=EQaTSzMh/isgoz/ey5KsJ+12OOP7fgotmpBrQqM0dezJyFSLKvwGNl7t
   YpK492R+YHqg8NugXJ1mZBfoprjqC1JZ1jiKMRCawXPN4Y2sET1bS/xlr
   X4/3/GeANpVOTDbOjc4JEoj3nIKL70GVKgagm5vxwk5lsrwPy8xUMy4xS
   l52rmWEOtUq0QefBXp4smgeMuYo4FMQxWshEXw/PaDrdMYdnFcEHK3mqI
   jz0sIAIDFRjrlDp57REWz/R3FCPC+/CN1AWqh2J7eQz2V5L/8EiRU0lPU
   uG2af0TR0RC9F2DKTFPqyjtkdbioIbff7shNFxYtKhtvac+Lu2NvkwZxb
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10853"; a="368538981"
X-IronPort-AV: E=Sophos;i="6.03,202,1694761200"; 
   d="scan'208";a="368538981"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2023 03:51:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10853"; a="781204465"
X-IronPort-AV: E=Sophos;i="6.03,202,1694761200"; 
   d="scan'208";a="781204465"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO ijarvine-mobl2.mshome.net) ([10.237.66.45])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2023 03:51:31 -0700
Date: Thu, 5 Oct 2023 13:51:29 +0300 (EEST)
From: =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To: "Joseph, Jithu" <jithu.joseph@intel.com>
cc: Hans de Goede <hdegoede@redhat.com>, markgross@kernel.org, 
    tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
    dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
    rostedt@goodmis.org, ashok.raj@intel.com, tony.luck@intel.com, 
    LKML <linux-kernel@vger.kernel.org>, platform-driver-x86@vger.kernel.org, 
    patches@lists.linux.dev, ravi.v.shankar@intel.com, pengfei.xu@intel.com
Subject: Re: [PATCH v3 0/9] IFS support for GNR and SRF
In-Reply-To: <19a7d055-bb19-f3e3-1447-7238d14a2138@intel.com>
Message-ID: <41f82af1-d08d-8f6-e642-93abf8531fc8@linux.intel.com>
References: <20230922232606.1928026-1-jithu.joseph@intel.com> <20230929202436.2850388-1-jithu.joseph@intel.com> <19a7d055-bb19-f3e3-1447-7238d14a2138@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Wed, 4 Oct 2023, Joseph, Jithu wrote:

> 
> 
> On 9/29/2023 1:24 PM, Jithu Joseph wrote:
> > Changes in v3
> >    Ilpo Jarvinen
> >     - Added Reviewed-by tags wherever provided
> >     - In function validate_ifs_metadata() (patch 6)
> >         - Add != 0 to next line for clarity
> >     - In function ifs_load_firmware() (patch 5)
> >         - return -EINVAL instead of -BADFD
> >     - In function ifs_test_core() (patch 4)
> >         - initialize activate.gen0.rsvd = 0
> >         - use if instead of conditional operator
> >     - alignment change in ifs_scan_hashes_status_gen2 (patch 3)
> > 
> 
> Since the suggested changes from v3 are minimal, I am sending just the 3 modified patches
> in this v3 thread itself.
> 
> Hans let me know if you want me to send a v4.

I'm taking care of 6.7 cycle (or begun from -rc3 onwards to be precise), 
not Hans.

Please send a full v4 please because I want to give lkp an opportunity to 
test the whole series (even if I think the patches look okay).


-- 
 i.

