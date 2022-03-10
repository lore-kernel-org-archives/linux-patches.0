Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1084D5A38
	for <patches@lists.linux.dev>; Thu, 10 Mar 2022 21:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646948528; x=1678484528;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Wu9xQh13qOE2SQCUN+y0wm4du69ScDsFeOiJ0FkDQCg=;
  b=MJhRO8ujBWsQHlRJfZUcn9NvX38nhvd7YPXoTRFpG15Wpyi3Wul3ho0D
   aCFv/Obgr883gIlWXRnr4/AZY/hFq1ynGcr+EAab5Dqz9/Ipdknw3Rlay
   wA9NG/UbqrU/srjNB8kchfy2KVdSy/TV38CClTr6fDDoFFuE4E/vF/GKw
   zrGXs2SnxjY9JhtlZZ5sW0Aw1ItVlJUFCwmEMa0m/w0uKTZD0uaZQ/f/i
   mzDLH5CIuw6qR7iY5a9qEOwzNZLLjdOctSNpF9T/W86JptX+8PpDSM/NR
   vCnebaTKfCtcjO8i9ZdBUn816EaGUQYVIIWxJ4TDwc9qtp5wWUU6G7nte
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10282"; a="252952370"
X-IronPort-AV: E=Sophos;i="5.90,171,1643702400"; 
   d="scan'208";a="252952370"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 13:42:05 -0800
X-IronPort-AV: E=Sophos;i="5.90,171,1643702400"; 
   d="scan'208";a="596833491"
Received: from dhrumil1-mobl1.amr.corp.intel.com (HELO [10.209.77.231]) ([10.209.77.231])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 13:42:03 -0800
Message-ID: <4062bb5c-1e9c-5e1f-5b27-2a4a8fb58078@intel.com>
Date: Thu, 10 Mar 2022 13:42:01 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [RFC 07/10] platform/x86/intel/ifs: Create kthreads for online
 cpus for scan test
Content-Language: en-US
To: "Luck, Tony" <tony.luck@intel.com>,
 "Williams, Dan J" <dan.j.williams@intel.com>,
 "Joseph, Jithu" <jithu.joseph@intel.com>
Cc: "hdegoede@redhat.com" <hdegoede@redhat.com>,
 "markgross@kernel.org" <markgross@kernel.org>,
 "corbet@lwn.net" <corbet@lwn.net>, "Raj, Ashok" <ashok.raj@intel.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "mingo@redhat.com" <mingo@redhat.com>,
 "rostedt@goodmis.org" <rostedt@goodmis.org>,
 "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "hpa@zytor.com" <hpa@zytor.com>, "bp@alien8.de" <bp@alien8.de>,
 "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
 "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>
References: <20220301195457.21152-1-jithu.joseph@intel.com>
 <20220301195457.21152-8-jithu.joseph@intel.com>
 <09b5b05018a8600ca8fab896790ab16827c80e4e.camel@intel.com>
 <e282377b-8ee4-99fc-432f-2aa3441b2989@intel.com>
 <CAPcyv4gcfMZu38EAGBq59A-RPUmR3fFiamRiR6QaP=D1gPS+6A@mail.gmail.com>
 <1503c7940a7149679025173a46dd0daf@intel.com>
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
In-Reply-To: <1503c7940a7149679025173a46dd0daf@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 3/7/22 09:46, Luck, Tony wrote:
>>> These are software(driver) defined error codes. Rest of the error codes are supplied by
>>> the hardware. Software defined error codes were kept at the other end to provide ample space
>>> in case (future) hardware decides to provide extend error codes.
>> Why put them in the same number space? Separate software results from
>> the raw hardware results and have a separate mechanism to convey each.
> We wanted to include in the "details" file, which is otherwise a direct copy of
> the SCAN_STATUS MSR. Making sure the software error codes didn't overlap
> with any h/w generated codes seemed like a good idea.
>
> But maybe we should have done this with additional string values in the status
> file:
>
> Current:
>
> pass
> untested
> fail
>
> Add a couple of new options for the s/w cases:
>
> sw_timeout
> sw_retries_exceeded


We've made a userspace implementation for this API already as part of 
opendcdiag that uses it:

https://github.com/opendcdiag/opendcdiag/commit/0cbfcee30e0666b0f79a2e452d7f8167d2a0cb90

What I really like is that with this proposed API, we can unambiguously 
determine whether "the core failed" or "everything is fine, for now" by 
reading a single file. I hate to see this file become unusable because 
its content changes from "pass" to "sw_timeout" or, even worse, it 
changes from "fail" to "sw_timeout". That would render it useless for 
the purpose that I think our users will be looking at it.

So, my preference would be to keep this file functioning as-is in this 
patch series.

I would think that some sort of expandable "statistics" file would be a 
better way to output various metrics:

```

sw_timeout: 0

sw_retries_exceeded: 2

runs: 42

first_run: 1405529347

last_run: 1646948140

<etc..>

```

just as a suggested alternative for more/incompatble output values or a 
complex, dynamic format.

I don't have any use in opendcdiag for these values and data. If someone 
does, they should want to chime in perhaps.


Auke

