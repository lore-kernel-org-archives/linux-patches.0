Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410B023CC
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 12:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670243164; x=1701779164;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=neMU4Ok0awO5Rq5skIsVHn5TxIHDupVu3e9O7MCpojQ=;
  b=hMfntHHE39q47dIwpiJk50pj39ITlR+dNjmUwYZNAmPfjjO+IfGlztt7
   cmaDKUPOcAq+dccSsCZrXIO69IiOHBm7FjWaZVUzvDRPgHJZMlHYq9CR5
   2VhNsjYKNCuBEstG84mqu2dtw034VVbUIEevuro1F58B+0kiMPTdEwX37
   iDDKsZmuXJV0MWQj/NubRPmk22JhNr3xvKsVqz1yE4zKHMLNOXfrvph4i
   9jw3g5arV5vkDA8nQIS+FBapie7le9LDqxM883Q0dTT90ZJEYIqlcI5Mv
   Gq8U6JlB0vxQnfOmt+IFZfMPr+f6MEp0eSVv5M4+X/gYxv9RdEjS69PWe
   A==;
X-IronPort-AV: E=Sophos;i="5.96,219,1665417600"; 
   d="scan'208";a="217912150"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 05 Dec 2022 20:25:56 +0800
IronPort-SDR: Siltj2yPHRE2u74GpQq0iY+0c5g/rTnmUbj9W7YJ0wR6sQqtvZk1bxbHNZWt9c53hBClsi6M6v
 3On5ldswjFXCJn/fkLnbl+ymgqcqcfeudWve0Q6DyoY96R+eQ/7V2RIVucU4RRx9AWch4DTiII
 fbWI4pCio9J8dclBqpKGStpG3d9DNfbtdzv0Xmv31d7n3cMzrDJsV34fAoAxFNM6657rDrD2fu
 g2W+/K0rS5cPE8GHWrUq9X0tnCV7gIDptCPc6pC+QkVlDgyfC5kkOmB+KRdXjjcH5oiqlo5fvP
 ntE=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Dec 2022 03:44:29 -0800
IronPort-SDR: 4cfLXYeYQsFz26BnnsOjDyAQec378r5jhGaSoL4z2qRiSW3MaiSgYMzS1Aopik1M+rP+W5AV8T
 XQ7N5fDGaR6DioPYhrEDKMe2FDALcgFEBOoGB3jfZAQ/vyKEXruYFuzIzHKjI03JiTFceMhoIN
 9/O8abcM0iH4GvhJPdG+8BJD1JqoiLtf+AHDb2zV7a1UoZ5Q7RVyNsDXevkaEKnnnK/Q0bq6CD
 DPgulKZoZyAlqG4z1ZqcUDXqnl0eVayGYA+b9ZUSV5Gz92Vnxqz5l3GcyPFqqEDlD56gESi2yo
 GPE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Dec 2022 04:25:56 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4NQjSh0Gwwz1RwvT
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 04:25:55 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
	reason="pass (just generated, assumed good)"
	header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
	opensource.wdc.com; h=content-transfer-encoding:content-type
	:in-reply-to:organization:from:content-language:references:to
	:subject:user-agent:mime-version:date:message-id; s=dkim; t=
	1670243155; x=1672835156; bh=neMU4Ok0awO5Rq5skIsVHn5TxIHDupVu3e9
	O7MCpojQ=; b=m5Xu/NbJsIXygi3sCcFIelEPO3pede61WJoH573KWRRl4EogESD
	xc3CsA+bqrrX6hqe3jWFJivN4VrpZInTKWjR4hdsUXEBTWvzKSiaTNcm7kYI8dF+
	7xqVxueMn8XIsp6gB9p5LfQab2gY1LysmUUU7a2dJNpmMLfGWB2CtrufURSrhsjZ
	DzfEAGYAgqwzFMRo3VfAkEhFQ/4YL4a5xfYs0i4s6tiZ1ksw3ASQs7ctB/+JLriQ
	huu/vG71ah9V4eEblcg+q9X0Z2qOF2dPnzCjPU9FMeGwIiVnCfU0pEThD5p2ixGC
	E58QGCdOQomWN0Gdtc6OhaN6VV5Y5KG1MaA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
	by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 8vQaJA7kiB26 for <patches@lists.linux.dev>;
	Mon,  5 Dec 2022 04:25:55 -0800 (PST)
Received: from [10.225.163.74] (unknown [10.225.163.74])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4NQjSW6BW3z1RvLy;
	Mon,  5 Dec 2022 04:25:47 -0800 (PST)
Message-ID: <e62bc865-3b6f-2790-3dbf-6485cb233c4e@opensource.wdc.com>
Date: Mon, 5 Dec 2022 21:25:45 +0900
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 12/12] mm, slob: rename CONFIG_SLOB to
 CONFIG_SLOB_DEPRECATED
To: Palmer Dabbelt <palmer@dabbelt.com>, vbabka@suse.cz
Cc: cl@linux.com, rientjes@google.com, iamjoonsoo.kim@lge.com,
 penberg@kernel.org, 42.hyeyoo@gmail.com, roman.gushchin@linux.dev,
 akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>,
 willy@infradead.org, patches@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux@armlinux.org.uk, aaro.koskinen@iki.fi,
 jmkrzyszt@gmail.com, tony@atomide.com, jonas@southpole.se,
 stefan.kristiansson@saunalahti.fi, shorne@gmail.com,
 ysato@users.sourceforge.jp, dalias@libc.org, Arnd Bergmann <arnd@arndb.de>,
 josh@joshtriplett.org, Conor Dooley <conor@kernel.org>,
 christophe.leroy@csgroup.eu, geert@linux-m68k.org,
 linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
 openrisc@lists.librecores.org, linux-riscv@lists.infradead.org,
 linux-sh@vger.kernel.org
References: <mhng-b0214281-7ee5-4698-a158-980427a97472@palmer-ri-x1c9a>
Content-Language: en-US
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <mhng-b0214281-7ee5-4698-a158-980427a97472@palmer-ri-x1c9a>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/3/22 02:59, Palmer Dabbelt wrote:
[...]
>> diff --git a/arch/riscv/configs/nommu_virt_defconfig b/arch/riscv/configs/nommu_virt_defconfig
>> index 1a56eda5ce46..4cf0f297091e 100644
>> --- a/arch/riscv/configs/nommu_virt_defconfig
>> +++ b/arch/riscv/configs/nommu_virt_defconfig
>> @@ -22,7 +22,8 @@ CONFIG_EXPERT=y
>>  # CONFIG_KALLSYMS is not set
>>  # CONFIG_VM_EVENT_COUNTERS is not set
>>  # CONFIG_COMPAT_BRK is not set
>> -CONFIG_SLOB=y
>> +CONFIG_SLUB=y
>> +CONFIG_SLUB_TINY=y
>>  # CONFIG_MMU is not set
>>  CONFIG_SOC_VIRT=y
>>  CONFIG_NONPORTABLE=y
> 
> Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
> 
> Though I don't have a K210 to test against, maybe Damien still does?

I did test and it is OK.

-- 
Damien Le Moal
Western Digital Research

