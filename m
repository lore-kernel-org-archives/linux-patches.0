Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2D02DA77B
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 16:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993540; cv=none; b=HlQab7lqA3obZ4HzwmRGnXWrvzBG5p7k5nK9B452n1Q7I2CC0rE+CH+Z5lBzKycbwLk1tRLGVcaV3xOKcGsgYZ4pY1h+r1vbgXQmwXtq1Wyk6GtwIZ3DCUOfs5Bz/YI6YYM75bSY6gRlPhEkD/J8/bGVafRQeQuh3cXtt/NgUPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993540; c=relaxed/simple;
	bh=0y2SzpV9ZZ4AB8wWTYS+5TQPsKKR5IeGIiAMviDsDM8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BYFnJK1IWrGWoDTtzVhu7W65dZHF9d48j0ddyrBhZeL9jN4spVJ0xahoXaUi11M8Q0QZEXyeAX6Akoha+dFNOsEAKeCeEJliqQrKT/L/gXPtQko415DP60Uzdn8sNPqgsNfzolrf64WOlkg/E+My8OXOS0fML20epBPDFoKzJ1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=cloud.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=PY6E4TjP; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="PY6E4TjP"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-60780d74c85so6421141a12.2
        for <patches@lists.linux.dev>; Tue, 08 Jul 2025 09:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=citrix.com; s=google; t=1751993537; x=1752598337; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Fof+LtMbXRJO+mq5g9N1sIuuGlf0356xjyxB9Yuv19c=;
        b=PY6E4TjPvj7WvkFmta1AGwHyy8okwOtTEc8npWKcfYZ9rnlKWqBX54JE++WLjpZtZ4
         1SkwDc0NtwK66alAwV7ajcAYqlwHkjksj49t7XKBA2THA/thNOE925B0KBqRJAsW+Phe
         3/LeKRR+t5DAmLi6LD5Vav2KLLKUNWTyBt0V0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751993537; x=1752598337;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fof+LtMbXRJO+mq5g9N1sIuuGlf0356xjyxB9Yuv19c=;
        b=RrpnDtoNSTdo2uWutfdltoJfWXyPg9W/yN4NAH0OtB8FUkhCaMWJ+VdhF4LNtFW8Jm
         7FCo1Z67yijrebo6Yth068+Nr26rKZdWjoXzEUuZ22djsprPUwBZMc1ZviRE9xR/g2DS
         8n4um9LPP6eIuoP3qRv6MQasIiljZudOco1fzCimYVW65f0hy1GdCLrv6keDrI8JAsme
         WhVUdvNZws1hrvTNTGc2jt+rgV37l06lCv5MkR7BEPU3eqfU6YQETmVajZw25ewGIoo6
         DZqInqf9p7GD6IuFAZFfP/La7YisgFfRpYfWTv157KD55ngzSF5UHGmacWU7wTV1ffk+
         voyg==
X-Forwarded-Encrypted: i=1; AJvYcCUR+F9QuyStNthIkfAJbd1Zore9+zrk9hDmukJwJ0C+bmJAZyphCX2XiSQJjug+PjNcXGxYqDZr@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+CshSdi2WqpJoT/63lUaUvLhToG82XJXzUZgLBzDnRP/D0AFZ
	SvcXbiQ9xWmlmfO4T++TN23uirU0J8IZkMlFw/d2MAYLinnLNge/lX7LH4RYNUZ9vrw=
X-Gm-Gg: ASbGncuboIlyUJYLZUw8ta/QbBp6OLX2GJ/kmOfijRPNhoInU0sjG/3hWdhW86M5x8S
	+WCvYpeOKJuT4TGtxcudB8+/K5LZclWj6RjkYsO5FHaDFhmkboN1acbkxUGvwlPj8wfvssJ3K21
	z0L45+jbB+XubmbUSZHaxHiB0MD2W+VM5pmTq7jeC+SAwKCKKzd03PZKMnq+GezBqEVLT1BQTtS
	UglwrcgtHyfPOFi3eKOKqLOxaqK2vJ74w0+tpNwaR2m2PVoJK9eWToRj+Jj9krmP8LEekZ7Uosk
	wz5uicdes56gOHW7uOG9EZFtaySrqcnd9wfj59bTfJc5Gbv3vTpN1XIEiDeEP0yA/3p4VG2RJvf
	QnhFT4psSqA==
X-Google-Smtp-Source: AGHT+IGBbdnsVMzibyyBNykYfrW31UICaTv73vlrRkn2aZDL14fy4r+qTln8TrfxKizNSnSE0MuLuA==
X-Received: by 2002:a05:6402:17c7:b0:60c:44d6:2817 with SMTP id 4fb4d7f45d1cf-61091c60871mr178513a12.20.1751993536753;
        Tue, 08 Jul 2025 09:52:16 -0700 (PDT)
Received: from [192.168.50.23] ([188.89.134.172])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-60fcb0c856fsm7561507a12.39.2025.07.08.09.52.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jul 2025 09:52:16 -0700 (PDT)
Message-ID: <449e2598-73ad-4c0e-b319-795c42f8ad15@citrix.com>
Date: Tue, 8 Jul 2025 17:52:15 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 81/81] x86/process: Move the buffer clearing before
 MONITOR
To: Borislav Petkov <bp@alien8.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev
References: <20250708162224.795155912@linuxfoundation.org>
 <20250708162227.496631045@linuxfoundation.org>
 <46161d11-2560-4044-8ed5-bb50206f9da2@citrix.com>
 <20250708164949.GDaG1MLS-tyK1MYism@fat_crate.local>
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
Autocrypt: addr=andrew.cooper3@citrix.com; keydata=
 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
 6+ahAA==
In-Reply-To: <20250708164949.GDaG1MLS-tyK1MYism@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 08/07/2025 5:49 pm, Borislav Petkov wrote:
> On Tue, Jul 08, 2025 at 05:35:04PM +0100, Andrew Cooper wrote:
>> On 08/07/2025 5:24 pm, Greg Kroah-Hartman wrote:
>>> @@ -895,13 +900,17 @@ static __cpuidle void mwait_idle(void)
>>>  		}
>>>  
>>>  		__monitor((void *)&current_thread_info()->flags, 0, 0);
>>> -		if (!need_resched())
>>> -			__sti_mwait(0, 0);
>>> -		else
>>> +		if (need_resched()) {
>>>  			raw_local_irq_enable();
>>> +			goto out;
>>> +		}
>>> +
>>> +		__sti_mwait(0, 0);
>> Erm, this doesn't look correct.
>>
>> The raw_local_irq_enable() needs to remain after __sti_mwait().
> We solved it offlist: 6.1 doesn't have
>
> https://lore.kernel.org/r/20230112195540.618076436@infradead.org
>
> so the transformation here is a bit different and thus ok.

Yes, sorry for the noise.

~Andrew
