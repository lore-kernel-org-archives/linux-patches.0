Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE2D7A
	for <patches@lists.linux.dev>; Tue, 19 Apr 2022 07:27:22 +0000 (UTC)
Received: from localhost (mdns.lwn.net [45.79.72.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 17A0A6E2;
	Tue, 19 Apr 2022 07:19:48 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 17A0A6E2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1650352790; bh=ooJki6sjwm1hI0zPo+XkNZ8ui/EchIPHs5t8q6fhubs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=OWMOncQHeK9xJiDfrnfVFrcLV3n6jkMHP9pghDEDIc1xs5f0F3ndY/9ocE8w8W3GP
	 DL3jSRyOHaJJjjAq+Pvvz9a/Vnzv0Poyeud5iykp0aLRRiKZggVNc9iWAIc39vruN4
	 ONfJSq09ygF/pTGEDi6TJaC19tB6wBdxCQASCpKlWC5SUqVVUalHnaGTR4qrhA3Aqc
	 i/mSV6eObXSkEPq/TZFCRKVsA6JqXcj+Qz+PS7ztT0FJvuML9cUdpvVGuk2APpiEMr
	 XqAZNRXs9izBZIrKl5O3ZCSz7tMcEiyFprH2BLWr8upsbQ3ysd+d2RBRfvFA998Riu
	 ok0UUTpqi05gg==
From: Jonathan Corbet <corbet@lwn.net>
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>, Randy Dunlap
 <rdunlap@infradead.org>, linux-doc@vger.kernel.org
Cc: patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>, Jens Axboe
 <axboe@kernel.dk>, linux-ide@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH] Drop Documentation/ide/
In-Reply-To: <7991758d-16b4-c9c4-0425-c2ec41943db8@opensource.wdc.com>
References: <20220419011021.15527-1-rdunlap@infradead.org>
 <7991758d-16b4-c9c4-0425-c2ec41943db8@opensource.wdc.com>
Date: Tue, 19 Apr 2022 01:19:45 -0600
Message-ID: <87ilr5zgj2.fsf@meer.lwn.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Damien Le Moal <damien.lemoal@opensource.wdc.com> writes:

> On 4/19/22 10:10, Randy Dunlap wrote:
>> Drop all Documentation/ide/ since IDE support was deleted by
>> Christoph Hellwig <hch@lst.de>, Jun 16 2021.
>> 
>> Fixes: b7fb14d3ac63 ("ide: remove the legacy ide driver")
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Jens Axboe <axboe@kernel.dk>
>> Cc: linux-ide@vger.kernel.org
>> Cc: linux-block@vger.kernel.org
>
> Acked-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>
> Jonathan,
>
> Are you going to take this patch or do you want me to queue it through the
> libata tree ?

I'll take it, unless you want to carry it for some reason - just let me
know.

Thanks,

jon
