Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17396134
	for <patches@lists.linux.dev>; Sat, 12 Mar 2022 19:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=3XXTMtVvGEv+7xBm6OY7Wf9VONP9c1jCPJtLoFLBduQ=; b=PeAcr7i0SujIwY3dj6mQe1EzrM
	g+icHQ8klr0GzhtrDujl06fr4TavIIYoLMg6yjf7ib0I8Oo8Baxp1UpkvlNobbbKx4doW0AFpRIZE
	buPXoXTjf5grPjjlZF47EYoM2debriEzEW0TkA+YAIoq+tc4NcPlUiEJWk9FS0VB2EwHK2nNujdlY
	IkJO2adUTFxTRRSJWIm7sq2jWFpsIFBJPzWUuwnT43UyhARfvsl5SNYg0SUp31T5bL5cE8DhjLeiA
	kWe+XZJdWvBjS+eT954Z2N0u4DSJYPkyntsez1HZ/abAl/t9rqoCrASctcvsW5rkn8jTShhUDSxvf
	KcbyprFw==;
Received: from [2601:1c0:6280:3f0::aa0b]
	by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nT7LA-000G6H-8K; Sat, 12 Mar 2022 19:23:48 +0000
Message-ID: <760e1916-09cf-11ec-122f-d30e339dca0d@infradead.org>
Date: Sat, 12 Mar 2022 11:23:42 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] clocksource: acpi_pm: fix return value of __setup handler
Content-Language: en-US
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 John Stultz <john.stultz@linaro.org>,
 Daniel Lezcano <daniel.lezcano@linaro.org>,
 Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rafael@kernel.org>
References: <20220309040301.25087-1-rdunlap@infradead.org>
 <20220312070941.GP3315@kadam>
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220312070941.GP3315@kadam>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/11/22 23:09, Dan Carpenter wrote:
> On Tue, Mar 08, 2022 at 08:03:01PM -0800, Randy Dunlap wrote:
>> __setup() handlers should return 1 to obsolete_checksetup() in
>> init/main.c to indicate that the boot option has been handled.
>> A return of 0 causes the boot option/value to be listed as an Unknown
>> kernel parameter and added to init's (limited) environment strings.
>>
>> The __setup() handler interface isn't meant to handle negative return
>> values -- they are non-zero, so they mean "handled" (like a return
>> value of 1 does), but that's just a quirk. So return 1 from
>> parse_pmtmr(). Also print a warning message if kstrtouint() returns
>> an error.
>>
>> Fixes: 60e3bf14d4e2 ("clocksource: clean up parse_pmtmr()")
> 
> I was wondering why I was CC'd on this.
> 
> This fixes tag is wrong...  My patch just cleaned up the function.
> The original code returned negative error codes already.

OK, thanks for the info.

-- 
~Randy
