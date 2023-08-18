Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB25360
	for <patches@lists.linux.dev>; Fri, 18 Aug 2023 00:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692318401; x=1723854401;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ctCzlIT+5k3T1YALRzvioprufv0wKEBR63rBIHtioCM=;
  b=Stx0iuvUjdtw23SC7tLKuVELGbPwH00y8oFIM7ulHP5+CFR/KpzelCqX
   a/I/eiibbqSL6XvdUo48AKtnUXRLMdVw68f8eUvFytAGJqzrEI1zSvPCf
   kU39v7SRvx34RzUPFUiIhVevvVfsIMBiiFb/Y9ti1n1p4Ln/JOpPL959w
   X15m9BCZe3ApngPR7vAKlo1abSUV2P4CjiaKrKCFvF34S1zxlPtUHnq6i
   jVB0KKYAEn9aA78oNEFFYYy9S+hTbvJBZsRVG5wgHuLsMsflaPAJkQNjX
   SwIj5f3zk+Jteq33OLY7oIttNlLB6Rh2NYLLile1ZXGCNhzC3pKepraLY
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="403951557"
X-IronPort-AV: E=Sophos;i="6.01,181,1684825200"; 
   d="scan'208";a="403951557"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2023 17:26:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="1065518469"
X-IronPort-AV: E=Sophos;i="6.01,181,1684825200"; 
   d="scan'208";a="1065518469"
Received: from lacoffin-mobl.amr.corp.intel.com (HELO [10.212.196.192]) ([10.212.196.192])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2023 17:26:20 -0700
Message-ID: <51095880-da66-5041-e47c-6572f199f6db@intel.com>
Date: Thu, 17 Aug 2023 17:26:21 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 03/15] mshyperv: Introduce
 numa_node_to_proximity_domain_info
Content-Language: en-US
To: Nuno Das Neves <nunodasneves@linux.microsoft.com>,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org
Cc: patches@lists.linux.dev, mikelley@microsoft.com, kys@microsoft.com,
 wei.liu@kernel.org, haiyangz@microsoft.com, decui@microsoft.com,
 apais@linux.microsoft.com, Tianyu.Lan@microsoft.com,
 ssengar@linux.microsoft.com, mukeshrathor@microsoft.com,
 stanislav.kinsburskiy@gmail.com, jinankjain@linux.microsoft.com,
 vkuznets@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, will@kernel.org,
 catalin.marinas@arm.com
References: <1692309711-5573-1-git-send-email-nunodasneves@linux.microsoft.com>
 <1692309711-5573-4-git-send-email-nunodasneves@linux.microsoft.com>
 <3b1ca61c-fa3f-a802-6705-a8c1f37ad58f@intel.com>
 <8161aa90-5535-4ef9-ad30-1655746a1053@linux.microsoft.com>
From: Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <8161aa90-5535-4ef9-ad30-1655746a1053@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/17/23 17:17, Nuno Das Neves wrote:
>>> +	if (node != NUMA_NO_NODE) {
>>> +		proximity_domain_info.domain_id = node_to_pxm(node);
>>> +		proximity_domain_info.flags.reserved = 0;
>>> +		proximity_domain_info.flags.proximity_info_valid = 1;
>>> +		proximity_domain_info.flags.proximity_preferred = 1;
>>> +	} else {
>>> +		proximity_domain_info.as_uint64 = 0;
>>> +	}
>>> +
>>> +	return proximity_domain_info;
>>> +}
>> Pop quiz: What are the rules for the 30 bits of uninitialized data of
>> proximity_domain_info.flags in the (node != NUMA_NO_NODE) case?
>>
>> I actually don't know off the top of my head.  I generally avoid
>> bitfields, but if they were normal stack-allocated variable space,
>> they'd be garbage.
> I'm not sure what you are getting at here - all the fields are
> initialized.

Whoops, I somehow missed the reserved field initialization.  But, yeah,
a struct would be nice instead of the union here.

