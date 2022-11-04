Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB4B8498
	for <patches@lists.linux.dev>; Fri,  4 Nov 2022 18:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667587321; x=1699123321;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=v/o8zarpAlq27GAzWPdFSA3sk+v/d/vyRl49BFPdGBw=;
  b=je6yCoD2dQeUOObr4syfa0CswfRKgmZKuOdAqe7HlXr8eeOi+MATttuo
   taeqxIAgUBnaxJ4sWGKme4aBL27lS0Wnj9jpKHiIgJNgArK9VrWfWaKmr
   lWFK5wMQ0y+xlPzxmGAW+OrwEZaw/QrB6UJGJzyd6ev0iFstdHLk+g/En
   Z441itLNDtr0bU30P3f6UNn3re5f+d6vGGM+YkqIwbz8rn7Tlxi/Pf3+0
   jPX4eqKoTDZO2NdM5hOJD1dokcH4fWMxLNd8skUln6zmo2BBJl7AybxLb
   f+e3+oxtAgNlDFv8+MGFwcEfGQUgaZkhAMlKDqdgGpmnSMio8Zsd00hGl
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="307664872"
X-IronPort-AV: E=Sophos;i="5.96,138,1665471600"; 
   d="scan'208";a="307664872"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 11:42:00 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="635188429"
X-IronPort-AV: E=Sophos;i="5.96,138,1665471600"; 
   d="scan'208";a="635188429"
Received: from anantsin-mobl2.amr.corp.intel.com (HELO [10.209.97.57]) ([10.209.97.57])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 11:42:00 -0700
Message-ID: <1897905e-6e37-a13b-acc7-2ab458aadfe0@intel.com>
Date: Fri, 4 Nov 2022 11:42:00 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] x86/cpu: Add several Intel server CPU mode numbers
Content-Language: en-US
To: Tony Luck <tony.luck@intel.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20221103203310.5058-1-tony.luck@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20221103203310.5058-1-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/3/22 13:33, Tony Luck wrote:
> These servers are all on the public versions of the roadmap. The model
> numbers for Grand Ridge, Granite Rapids, and Sierra Forest were included
> in the September 2022 edition of the Instruction Set Extensions document.
...
>  #define INTEL_FAM6_SAPPHIRERAPIDS_X	0x8F	/* Golden Cove */
>  
> +#define INTEL_FAM6_EMERALDRAPIDS_X	0xCF

Were the core names (like Golden Cove) left out intentionally?  Not a
big deal either way, but it's sometimes nice to see for things like the
hybrid parts what it might be "related" to.

Either way:

Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
