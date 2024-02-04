Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418EB225A8;
	Sun,  4 Feb 2024 13:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707054501; cv=none; b=stZhgkugR7ZSkSHVy4vixI44gq1UxshT2/BW52FXJcvamymXypk5sOK7ADUXdkWULuAXL4u4YS/qAQitOPdpwAHxmLjkdeUkMxCKJsG/F8ll6oEjYP345o19stNbqreLL2ROWFdqyWzbfxU7CicFLTK7vH0zjq1r3EyBVfI/9qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707054501; c=relaxed/simple;
	bh=dommXLpkhW5rWBJGGIywT82Ro1CkiMhNVTxvfzq4Bzc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s429ASvc1AsgiqdCWja3OC9+x9x0V8Pe2DOAy6Ow1dkGp0s0UXOH9X8FpZbsm1CfyKpi1Hz2R9ZOhNP1h7lCYsOKcetr99u8waol6CsXM6Pdt8j6Pe6wkmwAcKITwVoZSwPviLV8UJourdLn4XropLic3xqZMpGZAFtKGV0D+8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=USvJ1FzP; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="USvJ1FzP"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6e0432f1a17so50514b3a.0;
        Sun, 04 Feb 2024 05:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707054499; x=1707659299; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YBqZEhMQayOVKwBOR8eZbUcOV1plLyIzz/XGKnc3OzU=;
        b=USvJ1FzPyEuLCHqgKLNCNRMqWUXoAZrLmrYAfz0R5wVVMF3VYbYnfqhclo6Dg5dUFE
         JzoOqrPxDYNG3rOpwnbaM4Zu7ZrdcQJEYT7U8jzuf12yksWfYt5H6Ohq3I5ed4l9fqX8
         f7GIn2Kb++L+FuPOzsKkMgXV4I/hob6UMlqbz5zd1C4jkXf9j2w2sxt2GnlvDmCpsTHK
         juUVFYS+klLwqTYPfZaRi25iytJ0W+CxoBBtEjVcugCPDKVcVsrQVNjhaaV8b32koHnC
         +pE0a2+AZ6qJhVDXVxciQFHQfd9yXBAxw3ZYralBEJB27rDxdu5hAzzAxyqXA0naXXlK
         oZrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707054499; x=1707659299;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YBqZEhMQayOVKwBOR8eZbUcOV1plLyIzz/XGKnc3OzU=;
        b=ctdRFEuP9arL6A/fb0StmIvNJ+bur8Cqz8hFoRFFE86Eb+dGNfjWdB+oi/maGrJ5Uj
         JiCobIFj2LD5F+54+EyEz819DXp8iaypOOZaePn49BE60c4UUudHlj4Xs5e59BQtv7aC
         S74u4pect1hbzs2vd94F3scc6mfiyPppDsubAWJ7B21HO9wN7Gqo6VIAUAhkjLOlAI2j
         7PWfrLMqtK48pefEmKCWVmAF2MBUEWeVjlw6p9QMTyb1Us9mheqaYszBhpS/VtyTBKDn
         RB82u7AvN0HNokxeooXu2tIatup2pa9v0UIRFifWeXWPgIz+/EGpgpz+J0cneU5lTe8e
         tmOg==
X-Gm-Message-State: AOJu0YxovRn7vSmYVx/apsb6USPSkNXtVFsc0gJj1LZmQYcPld9fQScw
	ew3zo2aMfrCsiuIgeqRtoRr7Oder0iDTbdRrL1lSOg+hRFwUrpCd
X-Google-Smtp-Source: AGHT+IFTCFMJch9TPz7Alp9rH6qAqDDW6cjpUQrxMx2kzs6jj3hAx+mfiIAE9XxwF4J+dhwSlbwl3A==
X-Received: by 2002:a05:6a00:812:b0:6e0:3d87:813e with SMTP id m18-20020a056a00081200b006e03d87813emr1610387pfk.25.1707054499623;
        Sun, 04 Feb 2024 05:48:19 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCV/I8YSEZUfabADaGdBAyr5bzh5da3zh8r0xhfgipYrtEnqHDU1WQ8sLK9jcu4HompjrH6/0Lg6GVS1GcUaSAnjWpd1rkRZA05AiIUFQ+a6H2pyhEluOV2c1qZBXaSXagfcyzIkODBediKwzPGEC4LYG3WRreQjVZGprndSFdR93sC4b8ohib7zlpach68aBihtVdMviXi7JIt24hR8hUU62LwTyU02z6Eu5tn/6z3ICI0zprZIPqbPgDmPMgR3hoaxHvbd0GLRt/7xC2u/vTIhUWaCZhul5hNfNbEviagjtOEz8z4=
Received: from [192.168.0.106] ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id d9-20020a056a0010c900b006ddb77d443asm4780453pfu.209.2024.02.04.05.48.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Feb 2024 05:48:19 -0800 (PST)
Message-ID: <741fdb22-4570-4432-bc9b-8ac7221aa0fd@gmail.com>
Date: Sun, 4 Feb 2024 20:48:12 +0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 295/322] netfilter: ipset: fix performance regression
 in swap operation
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Ale Crismani <ale.crismani@automattic.com>, David Wang <00107082@163.com>,
 Jozsef Kadlecsik <kadlec@netfilter.org>,
 Pablo Neira Ayuso <pablo@netfilter.org>, Sasha Levin <sashal@kernel.org>,
 =?UTF-8?B?0KHRgtCw0YEg0J3QuNGH0LjQv9C+0YDQvtCy0LjRhw==?=
 <stasn77@gmail.com>, Linux Regressions <regressions@lists.linux.dev>
References: <20240203035359.041730947@linuxfoundation.org>
 <20240203035408.592513874@linuxfoundation.org> <Zb81_PFP54xFYQSd@archie.me>
 <2024020441-grumpily-crumb-03c3@gregkh>
From: Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <2024020441-grumpily-crumb-03c3@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2/4/24 19:48, Greg Kroah-Hartman wrote:
> On Sun, Feb 04, 2024 at 02:00:12PM +0700, Bagas Sanjaya wrote:
>> Hi,
>>
>> Стас Ничипорович <stasn77@gmail.com> reported ipset kernel panic with this
>> patch [1]. He noted that reverting it fixed the regression.
>>
>> Thanks.
>>
>> [1]: https://lore.kernel.org/stable/CAH37n11s_8qjBaDrao3PKct4FriCWNXHWBBHe-ddMYHSw4wK0Q@mail.gmail.com/
> 
> Is this also an issue in Linus's tree?
> 

Hi Greg,

The reporter had confirmed [1] the issue on mainline.

Thanks.

[1]: https://lore.kernel.org/stable/CAH37n11rbpaxzmt03FXQpC0Ue=_J4W4eG12PxvF3ung+uLv8Qg@mail.gmail.com/

-- 
An old man doll... just what I always wanted! - Clara

