Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A262CA5
	for <patches@lists.linux.dev>; Mon, 31 Jan 2022 16:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=5P/8qAQi0CkcpUb0wYDcIYhP6fIRrOOA+xId1zNjvmg=; b=HKcZmO8XPHEAteCGlTz/PE2BSm
	1/R/72edtJWLgqJNnzaoKaHnIBJWmayqBw27CCyyrQrByK7WUkJSa30oZ7Leu1c0NDwXCDmfbQdUE
	whaNX/ee4ThAKANUaWaFVZVRM1rb42orpE6s2/DYthvgofAkePGK0e6O9HUeQGkenXK59ySgYNycs
	3yg6sVt/ESPYCOtXVh5MktBbiVSzzQWF9eDaWKZvUXsIMG69PAK9N1cMd9A8qO8O1CV41blO/Vpsk
	bPT8aCLXOT9L0ksCW8mFnFZVb1eZyWpQ4Rg9z0FTw420puNvp8mTRih38g3ECuyPPwVrQvyaKSzTt
	/35KlZJg==;
Received: from [2601:1c0:6280:3f0::aa0b]
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nEZCC-00A6L2-Dq; Mon, 31 Jan 2022 16:06:25 +0000
Message-ID: <19727394-7d76-d07c-c564-91952a4257da@infradead.org>
Date: Mon, 31 Jan 2022 08:06:20 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] xen: xenbus_dev.h: delete incorrect file name
Content-Language: en-US
To: Juergen Gross <jgross@suse.com>, patches@lists.linux.dev
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>, xen-devel@lists.xenproject.org
References: <20220130191705.24971-1-rdunlap@infradead.org>
 <3359061b-656e-24f0-7b81-0905943afc78@suse.com>
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <3359061b-656e-24f0-7b81-0905943afc78@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 1/30/22 22:46, Juergen Gross wrote:
> On 30.01.22 20:17, Randy Dunlap wrote:
>> It is better/preferred not to include file names in source files
>> because (a) they are not needed and (b) they can be incorrect,
>> so just delete this incorrect file name.
>>
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>> Cc: Juergen Gross <jgross@suse.com>
>> Cc: Stefano Stabellini <sstabellini@kernel.org>
>> Cc: xen-devel@lists.xenproject.org
>> ---
>>   include/xen/xenbus_dev.h |    1 -
>>   1 file changed, 1 deletion(-)
>>
>> --- linux-next-20220128.orig/include/xen/xenbus_dev.h
>> +++ linux-next-20220128/include/xen/xenbus_dev.h
>> @@ -1,5 +1,4 @@
>>   /******************************************************************************
>> - * evtchn.h
> 
> I think the following line should be deleted, too (can be done while
> committing).
> 

Sounds good. Thanks.

>>    *
>>    * Interface to /dev/xen/xenbus_backend.
>>    *
>>
> 
> Reviewed-by: Juergen Gross <jgross@suse.com>
> 
> 
> Juergen

-- 
~Randy
