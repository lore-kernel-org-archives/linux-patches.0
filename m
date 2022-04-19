Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8D47A
	for <patches@lists.linux.dev>; Tue, 19 Apr 2022 07:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1650353009; x=1681889009;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5q6ejJsAwDqGhvfNrIoUldza8bq8vgRsQq3ufZ74D4Q=;
  b=FBTeR/raTxM04/gnAHLtfLazAKW4v6puznkLRxTELJrEixEAZamj4HWt
   D2FMQwHr/SxClp6LcZZMgTKKwY21Qu0BtDGUoFvCaOqOtcQIFRfq5GMCH
   62CtsXHe1eRuvX9XuuCvIzZZZPhqR+KrgVDn6jvbqAxz0/IBMA1gpeGya
   Dkz0MSXWP4VCf5hASWrvfcXLrwkxNiivnX/w6jNKKXjyTWfdSoIUm+Ao2
   b1IawjohdddpahXRBkZ6d1U3ys7xrPsBQYt9N8whWpfq4Aslimlxu6HeB
   rW2gZFBzLLhvx6V+upKqOxpxRyokdph1GJi3mjgS36um7L+DD3DohKVQz
   w==;
X-IronPort-AV: E=Sophos;i="5.90,272,1643644800"; 
   d="scan'208";a="310210779"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 Apr 2022 15:23:28 +0800
IronPort-SDR: Rv7G8XTJXSZQsTb3C1RUJNwrgd7Jl89840vwOVz5PZvnp7W/DVyhQDg3w6UjjzRusOH/G/th57
 gfO3xlTr170EHoIbQTzUzgftYSqmJnuMC0bnZkuZ3MIOw0KluSBp6E4V3fC+dr33TbRVle8Bjn
 OmyxyJRdcpJmti7YsNcM95PVmnb+my/+S4qZhoizvdFiHqWJZWwYmPzc+vFwURiaSdJdtzX/M0
 XP1o2bS5f1oVi7NKzOjpiH2IFYsheuOQR9O6LXaOCv98vfmpE8MOiTdQgzUCz0NHAMNtnGO0PD
 Z3UOYVHZFlZRpsSBeR5e+iPw
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Apr 2022 23:53:48 -0700
IronPort-SDR: uu2d08LsIa15PBkixnzbKD4cHw08fP3Yk4pWu90uTxARs+yejApXMalKlqw/cV8gAkJcsX9xE3
 vC5b016g3R1BO8/VZjJmv3MkmATBtj2RaP8wc/Y6GmqnZV/3kjUEbINtetIyVzuy0fqkKjgZ+t
 wqjYefQgG+AaUZO4eNJaXjk8qZ2gYofFP7Q1QQISLYwGgHodZt5vUreZZV6d+JW7vxI5TVmofR
 4VBwUzD05r5Mg2HJ7524DfkNyW6UCsCNoFtJJU7obwZsGc0b7GymWx78fnOu+BA0NNfPyI/CC6
 GlA=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Apr 2022 00:23:28 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KjFdr2ZNFz1SVp2
	for <patches@lists.linux.dev>; Tue, 19 Apr 2022 00:23:28 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
	reason="pass (just generated, assumed good)"
	header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
	opensource.wdc.com; h=content-transfer-encoding:content-type
	:in-reply-to:organization:from:references:to:content-language
	:subject:user-agent:mime-version:date:message-id; s=dkim; t=
	1650353007; x=1652945008; bh=5q6ejJsAwDqGhvfNrIoUldza8bq8vgRsQq3
	ufZ74D4Q=; b=l/mPfd0dHdA8ebEy6wxXFlLGfDugyEpGaNTe+BbuR/j8LO7tpmd
	fzQNS0BFAygkGlYOHxCqzxpm7IbR+PkEyiRCaso9o6KjVLAVS7xiqTzHy63jxOPF
	Gx4EQ4pgQnyosSTrkcMCIIQVMorWGoAn6mwibIRXisHT4YBLMEjm/NkwWDYHDp8Y
	lUvB8ICJM2qk5v53NPT8sEFaUpflEcSotr43hfdSMCUZlSYFJfu+JLxgSc/lP9Sm
	4WB2iD6udT0dmCGQUEvTBeyWv9rFUhFFrGTt89GwsLkYsvlCk+KsbZgcpnxtK3A7
	zs5o6WRmWh0FEZdvwIF+SdHJjyLJRFQ5B2Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
	by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 1se-q23_ftMs for <patches@lists.linux.dev>;
	Tue, 19 Apr 2022 00:23:27 -0700 (PDT)
Received: from [10.225.163.14] (unknown [10.225.163.14])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KjFdn5gGKz1Rvlx;
	Tue, 19 Apr 2022 00:23:25 -0700 (PDT)
Message-ID: <851c5e50-920e-579a-717d-10284abd4d0a@opensource.wdc.com>
Date: Tue, 19 Apr 2022 16:23:24 +0900
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] Drop Documentation/ide/
Content-Language: en-US
To: Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>,
 linux-doc@vger.kernel.org
Cc: patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
 Jens Axboe <axboe@kernel.dk>, linux-ide@vger.kernel.org,
 linux-block@vger.kernel.org
References: <20220419011021.15527-1-rdunlap@infradead.org>
 <7991758d-16b4-c9c4-0425-c2ec41943db8@opensource.wdc.com>
 <87ilr5zgj2.fsf@meer.lwn.net>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <87ilr5zgj2.fsf@meer.lwn.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/19/22 16:19, Jonathan Corbet wrote:
> Damien Le Moal <damien.lemoal@opensource.wdc.com> writes:
> 
>> On 4/19/22 10:10, Randy Dunlap wrote:
>>> Drop all Documentation/ide/ since IDE support was deleted by
>>> Christoph Hellwig <hch@lst.de>, Jun 16 2021.
>>>
>>> Fixes: b7fb14d3ac63 ("ide: remove the legacy ide driver")
>>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>>> Cc: Christoph Hellwig <hch@lst.de>
>>> Cc: Jens Axboe <axboe@kernel.dk>
>>> Cc: linux-ide@vger.kernel.org
>>> Cc: linux-block@vger.kernel.org
>>
>> Acked-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>>
>> Jonathan,
>>
>> Are you going to take this patch or do you want me to queue it through the
>> libata tree ?
> 
> I'll take it, unless you want to carry it for some reason - just let me
> know.

No particular reason for me to take it. Just checking :)
Please take it.

Thanks !

> 
> Thanks,
> 
> jon


-- 
Damien Le Moal
Western Digital Research
