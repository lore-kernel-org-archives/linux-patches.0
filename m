Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119AA881D
	for <patches@lists.linux.dev>; Wed,  1 Feb 2023 19:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675281229; x=1706817229;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6HAwN89xCS0t9HJi/h3nmQ7e1/evEaQAYP62NFj2lds=;
  b=c71AkwRniOlFKyKHmaKUx6RGRGW0ifXXI7EPVZJc4fJz/IzZMDCNYOby
   hNviXBsTEkJjfd5kJVUlYB40o1kjuTSPunCzlXYtDgzvDEopLS72FTyzd
   YQfkYGEsP0Ua6fh7pMz8MspWFIV5KC+i2PAidGLTYPIxCM8/yzo5LAAWl
   juItmiet/ho7zekOjMqz37n2V76xXtnh7brHCUyVUgBZhq8mB7Dqz9GoO
   A6/CYzeGOjSIW0/Rzlb/id1ZC3RxXPoGNk0e5ZXyWiLpRsNNiza96PThr
   wxN21TllS0t+7WG/Bjl/DQ3R41m+8r4nnEZyWMGwyTC4LXYPeaK8ztkcp
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="308598526"
X-IronPort-AV: E=Sophos;i="5.97,265,1669104000"; 
   d="scan'208";a="308598526"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 11:53:48 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="807702685"
X-IronPort-AV: E=Sophos;i="5.97,265,1669104000"; 
   d="scan'208";a="807702685"
Received: from sgkhacha-mobl1.amr.corp.intel.com (HELO [10.212.227.86]) ([10.212.227.86])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 11:53:47 -0800
Message-ID: <0097571c-890f-997d-5b6a-0a7b474d8fe9@intel.com>
Date: Wed, 1 Feb 2023 11:53:46 -0800
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
To: "Luck, Tony" <tony.luck@intel.com>, "Joseph, Jithu"
 <jithu.joseph@intel.com>, "hdegoede@redhat.com" <hdegoede@redhat.com>,
 "markgross@kernel.org" <markgross@kernel.org>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
 "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
 "rostedt@goodmis.org" <rostedt@goodmis.org>, "Raj, Ashok"
 <ashok.raj@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>,
 "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
 "Macieira, Thiago" <thiago.macieira@intel.com>,
 "Jimenez Gonzalez, Athenas" <athenas.jimenez.gonzalez@intel.com>,
 "Mehta, Sohil" <sohil.mehta@intel.com>
References: <20230131234302.3997223-1-jithu.joseph@intel.com>
 <20230131234302.3997223-5-jithu.joseph@intel.com>
 <aedc760b-ca4d-031d-6797-4f0a1ab2d5d7@intel.com>
 <SJ1PR11MB6083616D3AA5738944EE37DDFCD19@SJ1PR11MB6083.namprd11.prod.outlook.com>
From: Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <SJ1PR11MB6083616D3AA5738944EE37DDFCD19@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/1/23 11:43, Luck, Tony wrote:
>> Why bother with a bitfield?  Just do:
> How much "bother" is a bitfield?
> 
>> union ifs_array {
>>       u64     data;
>>       struct {
>>               u32     array_bitmask;
>>               u16     array_bank;
>>               u16     flags;
>>       };
>> };
>>
>> Then you only need to mask 'ctrl_result' out of flags.  You don't need
>> any crazy macros.
> "only need" to special case this one field ... but that's extra
> code for humans to read (and humans aren't good at that)
> rather than the computer (compiler) which is really good at
> doing this.

I don't follow.

If you have:

	struct foo {
		u16	rsvd			:15;
		u16	ctrl_result		:1;
	};

versus:

	struct bar {
		u16	flags;
	};

and you do:

	if (foo->ctrl_result)
		something();

versus:

	if (bar->flags & CTRL_RESULT_MASK)
		something();

I think both of those are quite readable.  I'd argue that humans will be
less _surprised_ by 'bar'.  I also like to write portable code even if
it's going to be x86 only.  It helps people who are used to reading
portable generic code read and find bugs in x86 only code.
