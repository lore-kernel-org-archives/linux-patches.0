Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792804908;
	b=xW/orOqbMS/ZdPrxSHDA24Puz/XAR0FOi6OSWVZfwC3Z5YHY08/XZCfKfcDmnQQ+ye3e
	 Y5cpXYJwxJcuuvx5CSjal5x06WybzjuToyP6S4H79OrN8B/t2dZZsCt+VAG6pzhg2lii7
	 gZyp8uOwiS8LD/YTolk48terzBcCBh9VWZ3fnGkm/gLwj3psNGmS6yCy3j8BEtx7uZ87g
	 JnvcuJnpYpa4n1nRIrsFiLQx/0FxHUsV5V/fn+rwgX8Wk2TgoXX91w7tUSS5N0TLOrcUG
	 NwM7L4VetuXFFf6BRTcMOhR77GDOtrvkFR2mkZLucViIx0070OM0e8L3O/BD+LxG3qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792804908;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=+1pFIlfxPdgrE17LxWPeou9jlG9PtRn+Bk4wjcL2E4U=;
	b=o+wY1tX+N88f46Zpf6RUZopXdthUEZHfX6eY7EuoVZFhp06Ydui3TkXS6TM4gMysfDc4
	 u1e9b8LMDr6D+NdQCgjRWuK9vMMpU470/i8MQDWyAuKp1fEnvKWEIZufBur9etfNcA4y0
	 vvmXcePuhLb6h+7/idKCp60sgjZojSe2TpLTCV+pL/oftS3uMblxvL6fYKrNgLpfMd57S
	 MJN9CJEkpO4XvFmrMWg1B0THKGQdDMH7t3KaChJ46dSCHghi16y/4t1hIQxC96osBcuSM
	 tGyi+zHfDEapGgb1o2+jLW80b0UO0f35Wyi1gjPU5jL3mQU56F9U686f5BH402o8piw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20251104 header.b=cxYxhHLb;
	arc=none smtp.remote-ip=209.85.221.43
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAE7606A31D
	for <patches@lists.linux.dev>; Sat, 24 Oct 2026 01:21:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7DAE7606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20251104 header.b=cxYxhHLb
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-48e20ed3b9dso1161671f8f.2
        for <patches@lists.linux.dev>; Fri, 23 Oct 2026 18:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1792804907; x=1793409707; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+1pFIlfxPdgrE17LxWPeou9jlG9PtRn+Bk4wjcL2E4U=;
        b=cxYxhHLbL/pZaLgq5XRL/HWQQ7kUDnIq+c0j93RJWdoiZl8fq1ZPPaVhoIF0r3aNMz
         xdpQ2XRI8ah6iDzEKZXBQ3UZFlhO1emJV6Ov641bsa0jgoCpoEJJc/kYBYdN0QUdMwtd
         d5SETgksupECXAAwHtoZKObbp7YYEIyzXLlL/a0nwuc4BV4S00gweKlFChC5z2uOe6Fl
         BGnFP6X/C6DAC1gvFBUT3pZqu0/eN7wB1BHsCzwTiSJh35r/3kC/fYXI6cJyMisCuHin
         697Y9uOYdkBgtF94HiIimZ/sywR5kJ3nDSAkkUuekOnI+O35wgfTdIlCjyRA5TEC3HXV
         NbfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792804907; x=1793409707;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+1pFIlfxPdgrE17LxWPeou9jlG9PtRn+Bk4wjcL2E4U=;
        b=ySxP3jt3fVhKK25YJRGjDKuDd/OPcnRQfwyrnNrlrMoVa3usECnk7OBxREA1tkhKv0
         xNZAMnGNZ+EIn9K1nE7ti5jo3Y7LDCRXhm3LvYfLMjIzAQz43OLAPhf6DABleL0ZRo5H
         fNAOcDCMh2Ut1FSbtibZItqnC3IqfZ6W3wkFCePNwFRHNLZLXVJdAPfmxb7zs2XWfY6O
         atNwyVGlLlX7JfG946bmDXGRpe6RF72oysgw4A+/rpI1foKa1ZcMsdi6yNG8dHbW7hyg
         ksu1XaQhTRq9nxtlfXyHlikp5hllcRJeaAzac02GBlhcebeSImiLkh6IPUSUH4nyFWpA
         Ikcg==
X-Gm-Message-State: AFq9FYI0wZGwMcH9WjUsvcdmnbLmnUQx+sDqj6kujTBuy+NA7Ku8+5xu
	aFc7/aTObWLEfZxwMbAJvtBw82vN2brGWjlc2fvGHh1dKSmc+9IzhtU=
X-Gm-Gg: AYBFou2k5HCPBY/X4vu+HhrhnIQ2MheF/ubR8ugbd5cjH3NyFw7m4xEgP3Thfd7Kq9/
	/wVShz8bnnnRd/SbqBVKIeWa3Lkwsue6K0E3unkeMMFV+tV6nsPZn6A1DBuZs3GbX0Us8dKJgmK
	icc0D/uLgGfTWZep/0kRs3+/xH8uxIalwhK8ug35JkWIOpYoDZHggXDiBYmFrnoAEjf1GPF7pEn
	DQKF28VONoyiFku4oYgB1xRmpC9yX0+l7CGFlbkTvMnCuDOHIHrq/z06WP2DgmygC4K9s0QrB62
	RbOTPqaJmSl6aQkCBfd7QSkzz039quYPtkkN6sTuxFueViud36eYCHsyGd8l2Fpa2QFHtKZ2+DW
	U1U85cwV+u2Dcs5jXmfOgYuYcgC3bo01VCVa7lHAA2h2qXTxerNfnzciT8PfuUblr1DvJoByrB4
	wIiF/6FhQeRQP28Z9FZ1rYJkdPYdfNst1pd8Z0MOyY7HRamgZ6qIunyE8Qbfw1Zz2KmUA+9F0OG
	hd3gHLphJixUTeMwYEipsFJBxo5jHoTLyxXCZuv9rV3wstR9EsJWhxTFdSK99rz4eESnVF6v8iv
	6X5ft/EqFV7dSaInnoNedrpXGg9fwS/1
X-Received: by 2002:a05:6000:2990:20b0:48e:2bf4:e7f1 with SMTP id ffacd0b85a97d-48e3eb924c5mr625887f8f.39.1792804906661;
        Fri, 23 Oct 2026 18:21:46 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac6b7.dip0.t-ipconnect.de. [91.42.198.183])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebd4d8dsm1343707f8f.36.2026.10.23.18.21.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2026 18:21:46 -0700 (PDT)
Message-ID: <bd58565b-d6b8-4736-a745-bcac9ac89e0e@googlemail.com>
Date: Sat, 24 Oct 2026 03:21:37 +0200
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
Subject: Re: [PATCH 7.2 000/242] 7.2.13-rc1 review
To: "Barry K. Nathan" <barryn@pobox.com>,
 Florian Fainelli <f.fainelli@gmail.com>,
 Salvatore Bonaccorso <carnil@debian.org>, Pavel Machek <pavel@nabladev.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "stable # v4 . 9+" <stable@vger.kernel.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261023163713.816071858@linuxfoundation.org>
 <atvHKoRHHjKV4l8A@duo.ucw.cz> <atvS68GhCvmAphrQ@eldamar.lan>
 <7540e723-054e-43a2-859d-616010fc7bea@gmail.com>
 <d2810142-fd45-485d-b325-f6d494690747@pobox.com>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <d2810142-fd45-485d-b325-f6d494690747@pobox.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 24.10.2026 um 01:42 schrieb Barry K. Nathan:
> On 10/23/26 3:44 PM, Florian Fainelli wrote:
>> Same here as well, bisected down to: a0c935bd1f76 ("fs: add umh argument to struct kernel_clone_args"), it looks like 
>> we need to cherry-pick 14adbd5341aa ("fs: stop sharing fs_struct between init_task and pid 1"), with that I can boot a 
>> kernel.
> 
> I'm experiencing the same problem as everyone else on 7.2.13-rc1, and
> I can confirm that cherry-picking 14adbd5341aa fixes booting for me too
> (tested on both amd64 and arm64).

I see the same boot failure on my 2-socket Ivy Bridge Xeon E5-2697v2 server, and I confirm that applying 14adbd5341aa 
("fs: stop sharing fs_struct between init_task and pid 1") on top of 7.2.13-rc1 fixes the issue for me, too.

The kernel then boots and everything seems to work normal.

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
