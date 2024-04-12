Received: from msa.smtpout.orange.fr (msa-218.smtpout.orange.fr [193.252.23.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7140B14A091
	for <patches@lists.linux.dev>; Fri, 12 Apr 2024 20:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.252.23.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712952929; cv=none; b=Dwu8l4H/V0s+KGj7u89dbvKkT3LMVkGjf0OwtgRIzsZD2a1ThMRrZ73OPt9xaPfh58s/arUJiy+KHfC+Eig+zSlhY1FyMAN6qJucxJlVQBppiDsSIBdBfLrzry5WyVeqAnR/aFd9/mif0UBV7o/ivRrTnbqdxA5rCSlbl+41DqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712952929; c=relaxed/simple;
	bh=6OFA7cWcEyUeumLiWhHnXohN0adeqOCPkM0RvDd/r8U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mVL5esFY8Z/fL6E1R7F2VIUZ/udxoKILQE8daBmUW++zqK9/xJ5ngaFcAMPEZegSYP4mbhgZGuKsYD+Le28ZOZQ9+/2JjvTdzGEJ3u0hcaJFLB/BHDb0fOUf2ek5aS2ZlS7A8twPO7ZnKI07aWxQmG9HnL4bmxFV4F4hQqRSER0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=Y/HjXqXR; arc=none smtp.client-ip=193.252.23.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="Y/HjXqXR"
Received: from [192.168.1.18] ([86.243.17.157])
	by smtp.orange.fr with ESMTPA
	id vNIorQIXBdtohvNIprHg9H; Fri, 12 Apr 2024 22:15:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1712952919;
	bh=4sRdJoptdfoPL7zAVvsibhZop6qjPpz+hJEcj3lsn3w=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=Y/HjXqXR7FoLagZHkZ10qYS+LtNZegzA+lFjY/H173NA5M9EXomTX/mAd95f5Jjxv
	 yZbKZiyJYKaMSIEHZTEiaeKHM19PWMmVhVUyn4isBSJtb83Y2fW2oP6d0rm7tLdp7Z
	 9u5QIRNdj14tY15TSTpHilC0y05AlRh8do8eeonDrq0UYff/pwcddixtnITkNCqJxU
	 84VJsB4TxC+4odWceNRtnSle2ZkuBsTD82DPOWVxjBpWS68gZ6ozS0dowCSEJr7zoP
	 zbdXB+AGFkn9CHpcUDfWVTGivt43RJoL9pa3COoD3Nv+y7vErFyoGO4Vl+fmoMFsyb
	 Ckv+OKAEpf0+g==
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 12 Apr 2024 22:15:19 +0200
X-ME-IP: 86.243.17.157
Message-ID: <4a85997b-77a1-4c19-81d6-0e6cb59e7c5c@wanadoo.fr>
Date: Fri, 12 Apr 2024 22:15:14 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: *** SPAM *** Re: [PATCH 4.19 000/175] 4.19.312-rc1 review
To: Pavel Machek <pavel@denx.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 maco@android.com, tglx@linutronix.de, sean.anderson@linux.dev
References: <20240411095419.532012976@linuxfoundation.org>
 <ZhmPpo+EI9Ce3bI1@duo.ucw.cz>
Content-Language: en-MW
From: Marion & Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <ZhmPpo+EI9Ce3bI1@duo.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


Le 12/04/2024 à 21:46, Pavel Machek a écrit :
>> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>>      slimbus: core: Remove usage of the deprecated ida_simple_xx() API
> AFAICT this is just a cleanup. We should not need this.
>
Not exactly.

As stated in the commit: "this change allows one more device. Previously 
address 0xFE was never used."

I don't use slimbus, so I'll let people with more knowledge than me 
about this driver decide if it should be backported or not, but from my 
point of view, it is a valid fix.

But, unless s.o. complained that this extra device address was needed in 
a RL scenario, I would say that the patch should not be backported, 
because: "better safe than sorry".

CJ


