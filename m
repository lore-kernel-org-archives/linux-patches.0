Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422D3882A
	for <patches@lists.linux.dev>; Wed,  1 Feb 2023 20:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675284565; x=1706820565;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CtnHyRlm9FCMYY900WFdvW+1NpDuurJ2OBLz6uxrVNQ=;
  b=lR/3MmXxK7aLrhfx8wriTaUKvb6p7kY8EHSc2be2FNtOLD2O3HVjDUQI
   8/ixONxvhbPH4u9P2VTsXKK4mgI6pQJpGT9JhKQ+ukceum4MmxogwrZic
   znoHGSxz1s0TApRJI5sdwKKVOl71p/mfcgWpjuv5+a1IhXs98GJCRv4q5
   QPniLwVdkseJpaO66zUQcd+TB2W8zmzg1ZQjiZRyRczOzAh/0wYVe/8Jw
   +e+XyeJEXMJJzdn5YSQAyggvzsCFWcH6Kd3Mpt6zFwHafLjrz8Oz1t+ls
   gUC1HtJKCXvaHMQ1A/deZEUyRSwm6Hk34xI8iay6MZY6Q8HV57RdIkw+B
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="307926735"
X-IronPort-AV: E=Sophos;i="5.97,265,1669104000"; 
   d="scan'208";a="307926735"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 12:49:24 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="695512665"
X-IronPort-AV: E=Sophos;i="5.97,265,1669104000"; 
   d="scan'208";a="695512665"
Received: from sgkhacha-mobl1.amr.corp.intel.com (HELO [10.212.227.86]) ([10.212.227.86])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 12:49:23 -0800
Message-ID: <ee97e1d6-5a21-2c5c-4fdf-05e2700e94cc@intel.com>
Date: Wed, 1 Feb 2023 12:49:22 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 4/5] platform/x86/intel/ifs: Implement Array BIST test
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
 <20230131234302.3997223-5-jithu.joseph@intel.com>
 <6a675f9b-2bbb-9317-2015-0b3362e49fdc@intel.com>
 <c04c1aee-b84c-324c-e7db-c004e778ef4e@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <c04c1aee-b84c-324c-e7db-c004e778ef4e@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/1/23 11:56, Joseph, Jithu wrote:
>> Voila!  Less code, less obfuscation, less duplicated effort.  Or, worst
> Agreed, will modify it as you suggest above to remove the duplicate zero assignments

... and the union ... and the _unnecessary_ bitfields.  You can make an
argument that ->ctrl_result should be a bitfield.  The other
structure members, not so much.  Make them standalone unsigned integers.

But, when it's down to a single bit in an otherwise completely
unpopulated byte-sized field, your arguments for using a bitfield kinda
dry up.  But, heck, if that's the hill you want to die on, who am I to
stop you?
