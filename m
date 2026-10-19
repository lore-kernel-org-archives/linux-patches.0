Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792437053;
	b=TJ8PgwRYXv4KaqQfceOjFfHK7UdLZ8WkClFBzuwezvYAm8TRNtX95DSTe3+cXhuybKGt
	 nLDhFw4vRUkonMw1kUDzwtPJ24nP/kdbeN4TZDmtYwxVkGBs2CZMARL3AEP5+JS4ISoAM
	 ZolowUcYAo5qssHwM7xEjpiMY+OO0UgoddR8RN82gxITz6RznG8vc7hhe6XIf3EmQqDHq
	 HBS+xRPnLhTQsF8UjfFalMOfFHMkkgeO5b/ttd6VBsT+W3/jcsZ1LO9Ztq5SlCRNv92uG
	 /ESSD6vYQvbrD87ezI54Ej3WfGnzIYf8hK3EBZjjbRgE/2WTXrQoBsSYzPPi7skWdkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792437053;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=sJxESkmKTsLQ7pnSvDLN4hJFLb0j+Zil8xbu1xibV5w=;
	b=0R+GGgx0N/VHk9CsvrHNkHHOBlljt8Ekzal+6B/YJix37X0i09w959rMsy/6Htpx509+
	 QhXq0mUujMqQg4Y1zO/kRjW66ZX2ZIxLhZgxoDG2mdmPER5iYHFQS0ou2qRRfoUR3OW3N
	 EzK/7KEWUy8nTa2D8JkIvbj7TUoDONKr+GQDHkGtTxmpXiA3rxZNG+aqe+Zz5RRe80lI/
	 kp9V7wpb9ehw5g1KUmdr/qnQZVJz/DR+J6h6r3UrBAkKOhfsWyRTwrxGOzUjhFzJ0XMdt
	 SPPQnjB7TRuk6uIJpDRZy0Ngnd4lS8L5ht/8kEYzGrb/WMY35lGkv2UteANBWaUBTJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20251104 header.b=UPkYU6a+;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B32606A31C
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 19:10:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51B32606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20251104 header.b=UPkYU6a+
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a018792ab3so18771135e9.0
        for <patches@lists.linux.dev>; Mon, 19 Oct 2026 12:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1792437052; x=1793041852; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sJxESkmKTsLQ7pnSvDLN4hJFLb0j+Zil8xbu1xibV5w=;
        b=UPkYU6a+L6rcesQuWRbpe/+xx6Aa/rh6VOvhvqhcPTjcYRAZN8I9LMt2AzZpx07COr
         H9dxFaEXqza9iXTKlRC/oKr88B7kU/F1lwyo9sNU9ZDtYL/BpgbRXsmUeMsD9NDOkJ3t
         Y2eq3GHDRUXwQn05tMPIMyIN/AUL6MR5mbH0tW9eHG7gX9fgF6lRDW96e8fnkVh2eaGZ
         hzx265shsF7uVqBp0Kmkm8/rb8tZ9ziIOBlf3q2qDiDyxXWG5HawImb4UQ23oaJHIZnq
         YBf4xDN7IHgfGMJrQ4aoZXMafOpK5Z9trfGEVW+YsZ/FDND9+63NDrRX0ZRyzT9L69YX
         9VQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792437052; x=1793041852;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sJxESkmKTsLQ7pnSvDLN4hJFLb0j+Zil8xbu1xibV5w=;
        b=JudQY6rUAAs/eunr5l694qjG+nRKnnFhEu8oID/szi5mejAQ5OXGldx3qgqmPhAxKZ
         5AHynQDGFXSHGeLCvpQ1A5O8DJIXuHMNGDqyd9mFI8ZMuuEgi7wR19eIR8ElYXUwQtR/
         ay3+OHrkqF8JJnivMkzCgpVrMVJKcl/c/tiIw5r/vycClzf16aedoIrErxwMqKbkLNK8
         1WEKj0cDg9HgY386FXoZp3aosu09m5aDxPGBE8v/vitcIYLwmlDzsPbG8+/TtQjqiQhV
         HMelMqrHDNKEI87e4isP+ZTf3Rvb9PoyJVZhCft+yVGZN/nsAEyP/j+HdIx0yrTNwolE
         xZPg==
X-Forwarded-Encrypted: i=1; AKwUvBx4hpGNGSeGowWTwNss3K/Wo2m+9F5sDHzXo8cyuNem+LlQnyeM6Uh7Smu9XvgCBIn2es1MCfjE@lists.linux.dev
X-Gm-Message-State: AFq9FYIiLKC7a73LRVG1oPfur/d3HtPYBg33AIMN3w4+2ibZTe2fG4+G
	7eqsahBwYgscWrwRHiHrP57+Xveu8DNZ+iMfjrcOkKLbFMNmuQc7ucg=
X-Gm-Gg: AYBFou2KN7lF997jRQX03Dxlcm/MzJ0gyNaLXn8MAXkHXaxJKcg+m5tYHE+oXVW30QY
	6lVsHmoqDjSYFfvrw/IySYrv5C50f2BnVdgOa/5hgSYYcXIbyKE22AJwv3mpW7mUrXggS1F8x7g
	W2Dpw7zwqx6eiGBUeSN7K0xRfbIjN1P8l/wfSHwXV/K3mxtWjZFeisu6W6V/BZzbcjDp7LJEYIb
	0nBWQGgKRV5xY2zO8e6UsgBbGhdPrF0wpRkpVyCxvaSx7N78eI/vechfomPEFyrbMxY+g/qjIA1
	TI/TChuUA58CfhnZGekYhluO7Pb/jKLVGlyY119WawQnehTWK2AbLpKGvX0gfwE4gnyRaw9iKGQ
	Etw8kn5IGxdU3i9VUd2HY1r5+88j4r4PtWwUjQD2ZkgRF4gxfDMG8shU1zq17yPiBG3/wB9SnMC
	sjhOXQ1/JYCwBMsSszz9CRnhkYgn+hnFZTjs3TxBfS4xVhdJE4NSnqrNHos7JydK20eCYZLAUsI
	w3Vtpybr3LqEleIB1AzuohzwkzjbSlqsxo898WmTVhfn5gaHg==
X-Received: by 2002:a05:600c:8709:b0:4a1:ac85:9696 with SMTP id 5b1f17b1804b1-4a1d75f926cmr159050985e9.17.1792437051530;
        Mon, 19 Oct 2026 12:10:51 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac02b.dip0.t-ipconnect.de. [91.42.192.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1f2ce2b8bsm13688775e9.15.2026.10.19.12.10.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2026 12:10:51 -0700 (PDT)
Message-ID: <892078c7-7fa1-4e32-a00f-1ac907c0ebcc@googlemail.com>
Date: Mon, 19 Oct 2026 21:10:50 +0200
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 0000/1674] 6.6.160-rc1 review
To: Sasha Levin <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261017160431.119607952@linuxfoundation.org>
 <827e9f8d-5654-4964-a999-5ce94bd98fd4@googlemail.com>
 <7201018c-20e8-4187-832a-aeb0e5db98ca@googlemail.com>
 <rc-reply-0001-6f27dc9abcab@kernel.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <rc-reply-0001-6f27dc9abcab@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 19.10.2026 um 18:54 schrieb Sasha Levin:
> On Mon, Oct 19, 2026 at 06:02:37AM +0200, Peter Schneider wrote:
>> # first bad commit: [7c1e132b0967210526de05e7af6f1c26ad0c1516] sysfs: Introduce a mechanism to hide static attribute_groups
> 
> Thanks for bisecting this.
> 
>> I think the problem is, that if you take this patch for stable, you need to also take the patch which is upstream [
>> cd69fedf58f8ab1ab511f7c6ac1969cebf1c935f] sysfs: Fix crash on empty group attributes array. It addresses the exact crash
>> that I've run into.
> 
> Rather than adding cd69fedf58f8, I dropped d87c295f599c ("sysfs: Introduce a
> mechanism to hide static attribute_groups") and its dependent c7fbb8218b4a
> ("sysfs: check visibility before changing group attribute ownership") from the
> 6.6 and 6.1 queues.
> 

Yeah, that seems to be the cleaner approach. I just tested this, and this works fine, too.

Will there be an -rc2?

Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
