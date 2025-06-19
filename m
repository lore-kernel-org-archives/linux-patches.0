Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FFA27EC9C
	for <patches@lists.linux.dev>; Thu, 19 Jun 2025 14:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750342146; cv=none; b=vCBC8xY3HM6xTpGp0z8ZqTbzkLzJZXgkuGecENmknZvZIr2RU+uOUL3yr25Th8xE4ZjTcphxGq3nXhSm48DiPnmgiw3rjfkBJO/IQnnSfPjNyVZATMq01r4JvI3Lwl5oE03TqHQm+iE23HfyL7G+XyhdYsOK6PNimxTssNzlWGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750342146; c=relaxed/simple;
	bh=Z3mp+pLnY7BGoYlVnxo7q7p0R3vDpjboJWoVW0jlMFg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=coqxFJ1MaBwhcnBg0a9PXpk+9XMEgNli/zDkbjAmgHaUq4Y44XNgi0O8HrgYRYR4UgmVyoD4wjRGmIM3vkUtjWkJq9MvSg0dVqMc0umNGd7ilefmvjY7oP2GTMriwx7uNedBloKkcM2qL2AIgTdDZeIIKxPknDoNW0Az4kK9xo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Yic68iyc; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Yic68iyc"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3a522224582so413968f8f.3
        for <patches@lists.linux.dev>; Thu, 19 Jun 2025 07:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750342143; x=1750946943; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uL1csz/rxe6tsI50qrJ0Y8JbGtRsq5liGnT1Pc42Q7Q=;
        b=Yic68iycjQF0UqbdVBnrsXYlCucGU5b4mP5RTrZi5sbvQa0VyR11cxG4y4ny0rZeCy
         S+kFhhTA6zVyXqhXImMIgS9ei9dHfmWAQd1GK8TaksLBKEQGSAV1mTEpEVms0ZUiPIeF
         VZrwhFXAa9ohUGUyvjTsGWZL/H9EqxyTKRuWU0biqVDZKMs8NJrBjEV9jvyS+KGmAueD
         uqYqgjw3o7FDODRilw6s6QQScTqGDcn/jTZUQcy3aR1wtoWtkeHK61RNni9+WfV8w7ic
         xyJjbLOuyWq8hHD6hY6g0CCRQCQ0004BoCoS6MLEv06cy5Gsg9jZBRlmf4iStOJ/exXH
         tk2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750342143; x=1750946943;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uL1csz/rxe6tsI50qrJ0Y8JbGtRsq5liGnT1Pc42Q7Q=;
        b=i4RVmdvdeLJZig6Ly7g7uhSDOfhd18s8hJd/ccjZCFwPOZJLjL9KyfcPdkcBQbpCbi
         MewBK4oNC/uXIWsh0MWyIZHvWIMH722T/Uk6MC+5dqG0j8DFGf5fV+iaPlr8RtHwBy6t
         UJjodotM7YexJ5g+qwJWf6+MfFog4d+HoKH23tie736QPgsQtzMF1WdmUI9AR0gtPiwd
         qzuJj02xkbPr7c0VMZECnB12OcE0b9SNcXsuq1S+35ns5Be3J+d5pCOoVx11OfXUst4z
         Al1EKDPS3GlsO6DuFAdH67sadaOhGfgL/C2ixyrlrxLDUzk5ZZBGUunmVr1552D8lMMQ
         /DYA==
X-Forwarded-Encrypted: i=1; AJvYcCXreWsiN3xhBGF1p2CwZX3dIZMZ/I4siU7CEvk6v5qSTuhzp3yltoQIWCEpCVFJFEvQchtVAL0C@lists.linux.dev
X-Gm-Message-State: AOJu0YxzsBwnrsGiiCqShOWdat5qqBdhxuP2vzTheQC5B6lZvwG0BnYH
	1cGz+2ZbUPPYYTMTsU+4NOR9u7tJT7YGFAytJqMRe/dZQjQBUE2wk7s2xBqAcbY8S4aNY+dGZHM
	5PC32
X-Gm-Gg: ASbGncut4NyHTo4XvTQT27iy2TV7W/XFa7BzDgRiIqkSKc6c2MWcEJS1KZVLi5xGrUM
	5+ghsWZNpeSRH3urAIybuqNW5eMVPSnypnlcFtTdy/zS+otojiAUSBmK9wqOor4Um+Ypu2Sjp9w
	IT7L8TTfnNxaPfMS6KCjxFZe7nPOlEj2lokdAG/Gn1muC59j0jyDiD8Vvila+4iZxoJA5LiWqqx
	NjJhuXvZ3Hqt7J2hCsYmHoaLZ2zoTVrdKimsHv0HSfgBhGWUPVETJYDMIUnBhi+HnzBOOzB1P7q
	7ownYiRh/jI/3ZmYd5esEegnBhq9VYESrElJQGeO1YnOGBaecwomZmbW4bCSmITfoR734G4k4Eq
	BsK797XDwWyN4RZjG0uer8TPfREPL7YuuLPk=
X-Google-Smtp-Source: AGHT+IFIIExG46UX/MB/ru/b4nPulXf/JBYWMq9osJ7zPuzS2h623U5wdO9+t5qfSWtZvXnXzhnU9Q==
X-Received: by 2002:a05:6000:2dc4:b0:3a3:7077:ab99 with SMTP id ffacd0b85a97d-3a5723af862mr16973684f8f.45.1750342142737;
        Thu, 19 Jun 2025 07:09:02 -0700 (PDT)
Received: from ?IPV6:2a0e:c5c1:0:100:b058:b8f5:b561:423c? ([2a0e:c5c1:0:100:b058:b8f5:b561:423c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568a734b5sm20002737f8f.33.2025.06.19.07.09.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jun 2025 07:09:01 -0700 (PDT)
Message-ID: <2ac47529-d72b-4de0-873e-247cce7c3c1c@linaro.org>
Date: Thu, 19 Jun 2025 16:09:00 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 296/356] ath10k: snoc: fix unbalanced IRQ enable in
 crash recovery
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Caleb Connolly <caleb.connolly@linaro.org>,
 Loic Poulain <loic.poulain@oss.qualcomm.com>,
 Jeff Johnson <jeff.johnson@oss.qualcomm.com>, Sasha Levin <sashal@kernel.org>
References: <20250617152338.212798615@linuxfoundation.org>
 <20250617152350.087643471@linuxfoundation.org>
 <a91ca229-0603-4385-9f9e-01f3c3ede855@linaro.org>
 <2025061953-alarm-oxidize-1967@gregkh>
Content-Language: en-US
From: Casey Connolly <casey.connolly@linaro.org>
In-Reply-To: <2025061953-alarm-oxidize-1967@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/19/25 06:21, Greg Kroah-Hartman wrote:
> On Wed, Jun 18, 2025 at 08:06:45PM +0200, Casey Connolly wrote:
>>
>>
>> On 6/17/25 17:26, Greg Kroah-Hartman wrote:
>>> 6.6-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: Caleb Connolly <caleb.connolly@linaro.org>
>>>
>>> [ Upstream commit 1650d32b92b01db03a1a95d69ee74fcbc34d4b00 ]
>>>
>>> In ath10k_snoc_hif_stop() we skip disabling the IRQs in the crash
>>> recovery flow, but we still unconditionally call enable again in
>>> ath10k_snoc_hif_start().
>>>
>>> We can't check the ATH10K_FLAG_CRASH_FLUSH bit since it is cleared
>>> before hif_start() is called, so instead check the
>>> ATH10K_SNOC_FLAG_RECOVERY flag and skip enabling the IRQs during crash
>>> recovery.
>>>
>>> This fixes unbalanced IRQ enable splats that happen after recovering from
>>> a crash.
>>>
>>> Fixes: 0e622f67e041 ("ath10k: add support for WCN3990 firmware crash recovery")
>>> Signed-off-by: Caleb Connolly <caleb.connolly@linaro.org>
>>
>> If fixing my name is acceptable, that would be appreciated...
> 
> I can, to what?  This was a cherry-pick from what is in Linus's tree
> right now, and what was sent to the mailing list, was that incorrect?

s/Caleb/Casey/ I sent this patch before updating my name.

Kind regards,

> 
> thanks,
> 
> greg k-h
-- 
Casey (she/they)

