Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BF5D2E1
	for <patches@lists.linux.dev>; Wed, 15 Feb 2023 20:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676492805; x=1708028805;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WF3CaZbwQ4TXLGhrjWkUVfdj5s5xigdAxwgewUYHvoA=;
  b=OxTVqxbajfMW3zlneRNat+aLU7u8sfZH9RzkdV0Ajm3GcsQXF44VFZ55
   7t97B3O1Kj5PBxCGiBkTRe2GcosOtc3yxEYG+CpCvIGuvXOVJT7fVnmB0
   PsKTffTcOTkQdyAavXoNw5k6JnvSBEeo9V8fKhh6vq/xvuddZH2dr4pq8
   vEsi72jkUaupf5uR3WXZSpPFVH9P9Xg+7V/6YKBYkPoaaSNE3Au4Vffk4
   u1MCU4AVIlPNH4dh9DsPNA4GwIXxXUJ/N6I5hPq9DqsrQ+0alfzQCbOlf
   0ce9uVdIKKD27gzbmbYl0T/1hekRDN3kSchMeKnBMLnYi+1Wmk01md5Dc
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="396171990"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="396171990"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 12:26:45 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="758614547"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="758614547"
Received: from chakanog-mobl.amr.corp.intel.com (HELO [10.209.64.107]) ([10.209.64.107])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 12:26:44 -0800
Message-ID: <b67d2125-4075-4eac-4cad-8e315b866144@intel.com>
Date: Wed, 15 Feb 2023 12:26:43 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 4/7] platform/x86/intel/ifs: Implement Array BIST test
Content-Language: en-US
To: "Joseph, Jithu" <jithu.joseph@intel.com>, hdegoede@redhat.com,
 markgross@kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 gregkh@linuxfoundation.org, rostedt@goodmis.org, ashok.raj@intel.com,
 tony.luck@intel.com, linux-kernel@vger.kernel.org,
 platform-driver-x86@vger.kernel.org, patches@lists.linux.dev,
 ravi.v.shankar@intel.com, thiago.macieira@intel.com,
 athenas.jimenez.gonzalez@intel.com, sohil.mehta@intel.com
References: <20230131234302.3997223-1-jithu.joseph@intel.com>
 <20230214234426.344960-1-jithu.joseph@intel.com>
 <20230214234426.344960-5-jithu.joseph@intel.com>
 <a24c65f8-978d-8968-7874-6b83e14b01ba@intel.com>
 <d9d18954-8434-4c85-88b8-8e1d99cd6a4b@intel.com>
 <dd501d6a-e7e9-be82-24fb-33b18fb6192b@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <dd501d6a-e7e9-be82-24fb-33b18fb6192b@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/15/23 12:22, Joseph, Jithu wrote:
> 		trace_ifs_array(cpu, *((u64 *)&before), *((u64 *)&command));

Uhh, you control the types in the tracepoint.  Just make them compatible
so you don't need casts.
