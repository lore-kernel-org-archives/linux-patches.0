Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7494D18BBB0;
	Mon, 28 Oct 2024 04:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730089690; cv=none; b=d3BUfaKm0hwYUAy3ReowdDRQJWQ6Sbwzouk4QTnbslRLuesF88dvp+mA0F9ogRAc7xP2f+/v7wO7R4mh9/pn6SvfIEVhjYD60ck7j0lID7qOc1JdNeIGFBCMcNKPNcuMNkI4qrURz+UgmbYLPhRdwkv0mDxZDi1qAYxgbdOL3nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730089690; c=relaxed/simple;
	bh=mDuCAI6LSQDh4SG5bqEDz4VLNvrKLfvacIM86++9sRo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R97uerEZR1YyeiX8dYJ97WhxGXLVe+W09CReDylEYBToMRCrUYVyLq+cycdyCpF6UncQ5xdwCWAW+kAK93o688M4S1CcqHF4QE8ZgbMmxJxO54SC9OcWuXREm0uicLPrHq5rR8xRugKYuwhavXFryjtft9/0m67hAUz1RSdRAPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WUPgRR8U; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WUPgRR8U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=8qxi9dDg0WBqbF2V//P0hAMZo/mIu3S+yaHiB5RbDgg=; b=WUPgRR8Uzd4pw52yJOdsIrrEKi
	BXBPxwqIzeREW7g7tCClwWlpwTzZGq6AvO4e/pQ+ZVUvo5L2XHQdLlwgoASsvK0WFyHwG8Ow2aF2m
	BB120cJGDaSCqUqJbzsVpVNlct8pkrAum3DpC8F4R7IBBlZqFntwyjuZ8psUYLgWe7mUpmjWqMH1Z
	iXvTZ5vjF+ZWqkOjZLyyaRD9tpQEsBn6gL1Chq9xXfZYYpX6ihoa9q2SOPs3a3WbRFamKxrD9pWGB
	RQWTWi28eOZheW80t2O+jUOviiyPVRGMjLekaAqcU3ztUUbUCwg7xJf4zoXL/7J96cv+CLJhpSPDr
	4+4a2o2g==;
Received: from [50.53.2.24] (helo=[192.168.254.17])
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t5HMB-00000009YD7-2aqK;
	Mon, 28 Oct 2024 04:28:01 +0000
Message-ID: <8b13719b-522d-48ec-92fe-6c98d651f947@infradead.org>
Date: Sun, 27 Oct 2024 21:27:50 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Documentation: admin: reorganize kernel-parameters intro
To: Bagas Sanjaya <bagasdotme@gmail.com>, linux-doc@vger.kernel.org
Cc: patches@lists.linux.dev, Jonathan Corbet <corbet@lwn.net>
References: <20241028005356.214369-1-rdunlap@infradead.org>
 <Zx8ML4Q6GyGPw-sy@archie.me>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <Zx8ML4Q6GyGPw-sy@archie.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/27/24 8:59 PM, Bagas Sanjaya wrote:
> On Sun, Oct 27, 2024 at 05:53:56PM -0700, Randy Dunlap wrote:
>> +This document may not be entirely up to date and comprehensive. The command
>> +"modinfo -p ${modulename}" shows a current list of all parameters of a loadable
>> +module. Loadable modules, after being loaded into the running kernel, also
>> +reveal their parameters in /sys/module/${modulename}/parameters/. Some of these
>> +parameters may be changed at runtime by the command
>> +``echo -n ${value} > /sys/module/${modulename}/parameters/${parm}``.
> 
> How can users get support for parameters not documented here? Post to LKML
> (and hoping that they also Cc: relevant maintainers and mailing list)?

That's probably the best option currently.

>> +KMG suffixes
>> +~~~~~~~~~~~~
>> +
>> +The [KMG] suffix is commonly described after a number of kernel
>> +parameter values. These 'K', 'M', and 'G' letters represent the _binary_
>> +multipliers 'Kilo', 'Mega', and 'Giga', equaling 2^10, 2^20, and 2^30
>> +bytes respectively. Such letter suffixes can also be entirely omitted.
>> +
> 
> Metric suffixes?

Hm, it looks like memparse() supports all of these suffixes: K, M, G, T, P, E.

So the heading could be Metric suffixes along with some changed text.

thanks.

[waiting for more comments]

-- 
~Randy

