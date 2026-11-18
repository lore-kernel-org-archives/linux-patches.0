Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031956;
	b=jNi2JtA/J/LINt/zcdwALtEmhNLnqyVAa+wfHm+1OwP4kpEUBG2pYGa4dSl1SmmsRiAs
	 MePDBCTneYy62sI50WCgeDRuLkVN49kNaBVbRLY1tWVIx0drbjdDuN15gVlH+HuztqbTP
	 ympvra1l9XRC4OfDrb8Fe6H+CxrJrv3VKaC/3EOjAdFHzLu7JiJ/+XQojiUSHVpYcGkwh
	 1eUV03Iv/ZHoEkbcox4RgZUZNm9woaorjmdO8cIiU9IFPwvmzMWqGHprJ2eSjDqd+pgWQ
	 iZZYv3DIJojTXQwVGWpY6L4ljFuKWaYP/ffuBEYvUFcHk72CAW5R5d4kZnw2Da/rhCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031956;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=EvNm36ee6QMlzT0gTHiv5nNg/UkjSVqUWtytJ7TE48o=;
	b=ugeZmUsLvChHN+xealQSeLWtZ6ewoOu8CssNCE/Z3ENEMO1HgSvXQ/OsiXvJOIQOhbC5
	 MwtH0pPzvuT4fGNlwdR81RdtgDvQzOnarJ1bWWGJOk/TBlHgstqVkRfUD7iQzLCTF21fw
	 ebR8wqd751bTFlB1PMYKux/B/PC1Rk6Q/Mg08ko3sZ0GjtFQLOXN2yYKU7B0K+hma/ayb
	 ecK+aHV0IDXzUSeLe4A2Iqi5to9J7x5oMY1cCoAFpq+Y3pkn34IqXNVxcC9x7dgnXfCjH
	 g9Y9tF6ZpYlLvPCioZduZez0kPje6VG93OnY7qIt0Uf/dmcfC7mHOxLhh6u8V57Rf9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zJr2Xget;
	arc=none smtp.remote-ip=74.125.82.180
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80817606A31C
	for <patches@lists.linux.dev>; Wed, 18 Nov 2026 19:59:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 80817606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zJr2Xget
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-3712b6d9843so1627562eec.1
        for <patches@lists.linux.dev>; Wed, 18 Nov 2026 11:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795031956; x=1795636756; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EvNm36ee6QMlzT0gTHiv5nNg/UkjSVqUWtytJ7TE48o=;
        b=zJr2Xgeto0KpZE6KOCuIRd8ryuyAVx+5Gxqhyyx0PrgPWSG1QWkk1Kj3GLHwuibl+z
         3c43V85kyRVasL2TyxuOWrzm661eY1E0L1CbFpKOo03BGyLq29CiJn8+xQhgZxIMXVmO
         9yOHfpl39Kozn00Dq/vTyqDTz0dvKjKWnlyt1Z7UeTJ/r6v5H6SZBjVi5wJLzjnqnbLX
         d3ghKTxhxsEI4gRG2SPK2odmyC4Xtmu/scgb6KX6/5ImUW0BC1L74uSKyBArOPJC/g3l
         xmyYoXpewczEzvCdFmxPuqA4X08z5knXsN40683uchnxStAmjcTSz5M1Oi/pMyk4noAD
         WP7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795031956; x=1795636756;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EvNm36ee6QMlzT0gTHiv5nNg/UkjSVqUWtytJ7TE48o=;
        b=WcpxDK33bIRZboWoXHqyHQtWFSHEGPa8EnVvZoivDf83r3MQ/FSf1jHGVOyN79IV9A
         xZl3kqB1JUb0Fo3VPzQMqexMhFfva92hzQIR6fz1ovq9qbUFU9cI01dF55bkW1smF8Ou
         eoXbpU9ICCYC6drdmyLx/PbPVhWvw9aH43Dz/fbWq3bmS8EOQ0nfWhqY0GbcGg4Vm+J8
         ChwxGbrn9G7oTGxG3N0Fxk7tL9UmlnAkXyKxkTrShDBTozktMjara5sLbnhCArblT5k4
         Q55mCHoehNdy+SeA8YVlYS3GVSgldK44UQy9t1G2x40yzFQAi8tCCWdBg8APBcl6DshE
         23zg==
X-Gm-Message-State: APuU4Z8c62Ig7zDpkR5PC8waAumTU3UXpTsHFsuRmmQGnfIkTMQ9gfNB
	cmpkjcLPp1qjlRpnvo/oZ5PYCoU0BQ97NGcxhBPsGWEq4wUN6rCPFDWM
X-Gm-Gg: AZFdTZdwOvNarweqUzjn3uPbo1Kv40Wkmm8Icjyy/nE7SvfGdyqGroID2AWLI/yDefY
	PwEPLCeLzSC3pfjcWaa6uypxZw7VuAaaTGSBb+kFfdjqwzOCsZMqsZi5JqUH01BM3HU07e9D2gl
	7qi3qA53bUQTl6BwdsOQfvBll9vsSnmf3MjJq9TqZm44ZobnT3V7KXmzeV57MhLX4VcOQNV5AFi
	aaq1EJ4QW10xEZLEMp6Nqdh+nUOOUdG82ExiAh2FVcxjQZXj/ANq7eniXQFM992uwZuTWRmHSjs
	zYtlGKAlLlZe6n72Rth2lOopDe0W5hR/8JCEHEDNhV7t/M7+0Sioxnaj5B41QdhNz4izy2YlihU
	928isETrHeIDWK3rdGLJOpOGv26XjTIkNhozu8kjDpof0ZOy4XIvGMg+V5q3EGk68P5M9edJAUh
	PmPhtG9w9ZjuGOfDHmVw1jAg5nZtVaFlqGWUfiux9u3pH+G+Tj+CGiMb7Bf4/Qu1KTBewj6s7zn
	vzNtlRyROtR0v88Elr//uS5py0yjJcNKso5b+KX1kWrILA/fkKvtrFLE5oJ9P1ByuT8ax/x60KL
	5lklWLkCLJwIAfarNcM0p7305wvWKNTZUfeT0TTzBVUHTBKJoZDjvy4dTXGCzSnhrYBByQiSksB
	e+A==
X-Received: by 2002:a05:693c:885a:b0:376:37a2:87f3 with SMTP id 5a478bee46e88-3828161ae29mr3343574eec.31.1795031955504;
        Wed, 18 Nov 2026 11:59:15 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-382a6800366sm9938909eec.12.2026.11.18.11.59.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 11:59:14 -0800 (PST)
Message-ID: <835e4c45-4b46-4d1b-a2d2-de1147666842@gmail.com>
Date: Wed, 18 Nov 2026 11:59:13 -0800
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.3 0000/2651] 7.3.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261118150247.972732815@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/26 06:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.3.6 release.
> There are 2651 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 20 Nov 2026 14:55:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

perf fails to build with:

util/annotate-data.c: In function 'global_var__collect':
util/annotate-data.c:785:30: warning: implicit declaration of function 
'die_get_type_die'; did you mean 'die_get_typename'? 
[-Wimplicit-function-declaration]
   785 |                         if (!die_get_type_die(dwarf, 
pos->die_off, pos->die_tag,
       |                              ^~~~~~~~~~~~~~~~
       |                              die_get_typename
util/annotate-data.c:785:71: error: 'struct die_var_type' has no member 
named 'die_tag'
   785 |                         if (!die_get_type_die(dwarf, 
pos->die_off, pos->die_tag,
       | 
       ^~
util/annotate-data.c:786:50: error: 'struct die_var_type' has no member 
named 'from_alt'
   786 |                                               pos->from_alt, 
&type_die))
       |                                                  ^~
util/annotate-data.c:792:44: error: 'struct die_var_type' has no member 
named 'from_alt'
   792 |                                         pos->from_alt);
       |                                            ^~
util/annotate-data.c: In function 'get_global_var_type':
util/annotate-data.c:849:26: warning: implicit declaration of function 
'die_same_file' [-Wimplicit-function-declaration]
   849 |                         !die_same_file(cu_die, type_die));
       |                          ^~~~~~~~~~~~~
util/annotate-data.c: In function 'update_var_state':
util/annotate-data.c:905:42: error: 'struct die_var_type' has no member 
named 'die_tag'
   905 |                                       var->die_tag, 
var->from_alt, &mem_die))
       |                                          ^~
util/annotate-data.c:905:56: error: 'struct die_var_type' has no member 
named 'from_alt'
   905 |                                       var->die_tag, 
var->from_alt, &mem_die))
       |                                                        ^~

-- 
Florian
