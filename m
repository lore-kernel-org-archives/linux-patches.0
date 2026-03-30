Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1DA2D060D
	for <patches@lists.linux.dev>; Mon, 30 Mar 2026 08:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774859547; cv=none; b=f6EHvqdbGBkJuqou7XwAVNDcSQF+/+D6MhT396pPeu9NBbDw2JNX4i4lPoltNOP/JIAK5eSG0BM96UExADD6UCWumvp6RYoL3nmDpLqVsWJT1zmjSPe7u/GFxgdkSa+aV4USaXslWPPVBqn0fIofpw4MGT7l3YjNit+x317J+mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774859547; c=relaxed/simple;
	bh=o0Dli9KWVqZ+T4nHyOqVZ5qeJndFFU0aZl2QR66aKNU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=De9b/HXUeGoa0d1Ana6wAMZiKfm5BRNehKIdBl3BPQqzRjXQxAyWP5/KR3fqJgst/XqGNZ0S3SNK8for/QNNumU3UzvXL6RVMynDE1CnVGFSMUWdxaHUgclkObq5Pv9AGlseJ0VOCjYeMa2qX+JUexPD5g9w11yK9AHLojIN/xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rIjEWuQs; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rIjEWuQs"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2addb31945aso32715145ad.1
        for <patches@lists.linux.dev>; Mon, 30 Mar 2026 01:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774859545; x=1775464345; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=oJ2tUbY4pzEgUU7tzK8uvwt9Alws0pUs2dmmBbqRX00=;
        b=rIjEWuQsIGVzRAY2BzCtRxtgJqlD0yEKdbYYHHoemEGgDTcOmIS2p9wPXFC6kwZOMs
         X/M6XY6bM3UlUIKUacNG++sO4tkIjV6AtBEtabPY/UHy4ryMzctMnvTRNbpfuz2nKboM
         dGhAFjJyXnpuuDnoJdEVDpdmAmUo+aFr0SVvj0CbYu58VeITUFcvjfN2v6hSJ63gpz8q
         tXZkaUUwo2SkXOgZLtFWy9MGT1uKyXzaZtbQeR+IhLJQht6J30nq3uvSEyQNR3Kfhu6H
         R5hDH/lW6Rsy60zrhLJ5hWypLZ7QbZVYGvq2yN4lj1zBF5uhxuiXF7EkVCJF+FuONz2r
         4lSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774859545; x=1775464345;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oJ2tUbY4pzEgUU7tzK8uvwt9Alws0pUs2dmmBbqRX00=;
        b=oz2WRr57sSCi+zWHCP+UH8xjCKWwterQ44jluQQhD0PdUsTWwbfkLCmrmZEkjf+uB8
         w7elDiTk+C1QkO8BhBy29GS3Q2vhJnLvfzUBzmmPjXcI+4mIA11aghWd0KkNumnnHlLd
         uL5QODY04gNJmns8IouxSdsvLm+BMeaJGdm4vPPoAY1yWDbhPLgicZ9VenVJ7Bcjwow8
         1zrm4OTcIlUl+LTe0ZKXyYHvYYzdkKBApBi2GNe4pgwZ1zHqmpHQXcnH9NqErss3Dm83
         64fhdNombWIUfDQk9yt3AS0htKiWWVn3weaoPzmEHFkwow83CMFdVd8neeaP24QGIfVO
         HeYQ==
X-Gm-Message-State: AOJu0YwdZgsZVLKz3BSC/PZ7HeT2eJZ6ByWeGUrNzTEUj1+SjhPxbl0Y
	gSauopL6MsIVyaiufJD3Ttr4zxKeP6omOq0117cKW3uL7Fx/PQ1OFQ0D
X-Gm-Gg: ATEYQzz/ZvPXjSJX/NK7/zOvYW6dfcRMli7Dfp2cWC32rywkGf+9AVdJNSyTgKpNxiH
	7tnl5SK7zsi7cO02c34WRpQoqBVFp+oRsVuZqhe8t53ylXk+uxoaBBZmhSUP8z2CW/PFyidp7gg
	S4OS4kAweH9cTIrtaijiZPfOGOE7OPBzGphvjI3ZNhl1mcmP1hXle+4+lhCFJ8OkxNA3r/h23CP
	4+/vTxzqbqU6dYtIllEW2bzxYsESTw/aFfT570KgycOx6bRkFDgdWQqgV+ygw+nA/nEoRw1ytyQ
	X0vVz+VSNsJs7VEpqpMTgu1U1InkCHeLNdJB5vZ7IT3ef69I4iyjYBKUoWO5bwvG4+FsYTJPIC7
	A4P0LSkAdTzDiYaOoe6TDssQ4orErcYLyAjAgo8f2gkjFJq9lNyq6A9TPY5fTQqD/eNQa5e8CnS
	fMgfOvgij9Q3M0m3pb4nanowNuYlk6dqmbNGMTKhcz0n13hcw2wmVobDADYpMHWAPHqJR7AXb0
X-Received: by 2002:a17:902:da86:b0:2ae:b9cd:d2ce with SMTP id d9443c01a7336-2b0cdcaa68amr132168035ad.27.1774859545498;
        Mon, 30 Mar 2026 01:32:25 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b242677d3dsm79102305ad.29.2026.03.30.01.32.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2026 01:32:24 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <5f4b8e66-db6c-4477-9569-8bb097b1cf83@roeck-us.net>
Date: Mon, 30 Mar 2026 01:32:23 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/481] 6.1.167-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260323134525.256603107@linuxfoundation.org>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 3/23/26 06:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.167 release.
> There are 481 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.
> 
loongarch images have failed to build in 6.1.y since v6.1.163 or mid February.

Is it correct to assume that there is no interest in supporting this
architecture in 6.1.y ?

Thanks,
Guenter

