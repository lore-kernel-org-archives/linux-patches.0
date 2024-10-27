Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E2879C2
	for <patches@lists.linux.dev>; Sun, 27 Oct 2024 20:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730060438; cv=none; b=JDYbEILQZwh2XC6c+GvspU0Q67icFbrh/5HYLgR+fr78RHk1zdg6DDet0LHg7CvPkk7Fu8Hc4JGXuTWK14R9q64wM3I/xZ9hetXmhgRdjXBtlEgedeGx9inbPZ/C0Ffr1ueoRjDUzWC89Yv4tcmCc1enqExzwFnaz48xtAmmuVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730060438; c=relaxed/simple;
	bh=NDjKwj6KYq8eyzvWnAuMCVUjblMxJAeNZC5/nLC9ZUA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=P0KhCvIffgOY7dAhWbOE61I2RxOSdJS1UcpXJFHBp/SO0rofjPTrIRAKezfIPeKq4kIVG73G01BG09RsI3MybymkM6wptMD5lFhBwTfmA5AiPyV0h9/zbPlFVphQa9Vi/l+UdzkNI8gt1Na1dYGm3lN9zetpJIxtgK8vC77yTBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=apevzner.com; spf=pass smtp.mailfrom=apevzner.com; dkim=pass (2048-bit key) header.d=apevzner.com header.i=@apevzner.com header.b=nhpvCpZ3; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=apevzner.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=apevzner.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=apevzner.com header.i=@apevzner.com header.b="nhpvCpZ3"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-539f72c913aso4538982e87.1
        for <patches@lists.linux.dev>; Sun, 27 Oct 2024 13:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=apevzner.com; s=google; t=1730060433; x=1730665233; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qA/SMxSLqXVatL6zizWumFPrrDcbY7I4o2XKLGYPLFM=;
        b=nhpvCpZ3YlIsfFnKN03q8Md5UC2fnTvhgdMHKBuP9KqoesTwWX2sLn/eA8kLHKkieD
         Fvp67luQbgAyc3iv2ESHnw4vNQg4OdVXaW3t/5urcsq4aQo3daSdeHjQ/6kU2UTKOJEv
         KfP2hpq0+o5RDtpBeEBTa+ojsDDzGL8WuBkxmexmN13jx7D5+R6slYNEssDmlqWI6z/j
         n+vhxLJGQp5fY+WmBHvL+TLlCyepd1H5RdTFEOYoEXAqoSwbqJ0GJgXNvqE2B+djXYsc
         X9PyePxUE/4f2SvIdSYEbrtf55EBeRzzRVR0274eMl/0NGWrQz4o8XJLvmBgAFjsBh0+
         t+Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730060433; x=1730665233;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qA/SMxSLqXVatL6zizWumFPrrDcbY7I4o2XKLGYPLFM=;
        b=e/3R6m5reWa5eVKVi4XytWg7pK5OURwvlxST1Xu2LvsY6GR3C4O3+Pe884Whp8y0PW
         Q0lBbO3kTHUJkK712hTdjjsdKZnkV7BY99CsUoLM5OCwhE3+ub27g24Wv2t4uBNKAZYK
         5IIkWRShsVzm/UivUrwEPccbR8UqJmXPBZUIpASrUk6l8FwZjXbHqxP6w+L2sAt7Ybae
         wYImub2vcwTzSZ9DOrWr8c/8ri8Oh+e4x/0bITVkh8iRCGIRPdlz1VboUavAF5ZJv8FZ
         vkUb8fHEx12nDWdYnTvoyhRnoN8mGwehs7693lrtj/e9gLWDgdk+k/MbBFfvF/QErs4P
         dEuA==
X-Gm-Message-State: AOJu0YxQbJXRlOejqN13SEaJXnWiEjeXLocnUSqTHhEDf/Po3kRcwKWp
	Twov1Rc9ToJyuvpT5Av82UJ2fKyWPxI6HMy5IdV1qiLUzkPgx6YuXDcr6mDdhGLHH2WAYyCv/MH
	o
X-Google-Smtp-Source: AGHT+IErIhzF7Pbcl1dtNSnwSsVR0KjX1OS+Oz3o2xs9b3TCYCjYRRu96N0ZL8qgAQFuLXA9VCLPvw==
X-Received: by 2002:a05:6512:2347:b0:530:c212:4a5a with SMTP id 2adb3069b0e04-53b348d3775mr2266413e87.22.1730060432434;
        Sun, 27 Oct 2024 13:20:32 -0700 (PDT)
Received: from [192.168.0.6] (ppp85-141-194-121.pppoe.mtu-net.ru. [85.141.194.121])
        by smtp.googlemail.com with ESMTPSA id 2adb3069b0e04-53b2e1cbe9dsm873320e87.225.2024.10.27.13.20.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Oct 2024 13:20:31 -0700 (PDT)
Message-ID: <9aa26719-0614-4b83-b638-ac48b69be4e5@apevzner.com>
Date: Sun, 27 Oct 2024 23:20:29 +0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: Remove some entries due to various
 compliance requirements.
To: patches@lists.linux.dev, linux-kernel@vger.kernel.org
References: <2024101835-tiptop-blip-09ed@gregkh>
Content-Language: en-US
From: Alexander Pevzner <pzz@apevzner.com>
In-Reply-To: <2024101835-tiptop-blip-09ed@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi everybody,

My name is Alexander Pevzner, and I live in Russia, Moscow.

I'm probably one of these "Russian trolls", mentioned by Linus in his 
message a couple of days ago.

Regardless of that, I use Linux as my primary OS since 1.2.13 kernel (so 
about 30 years for now) and I've contributed few lines of code (or, most 
likely, few thousand of lines of code) to make driverless printing and 
scanning work on Linux, so if you use one of those modern multifuction 
printers, this is very likely that among other stuff you use one of 
couple of my projects already on our personal computer.

As for me, the free software movement is the important thing. Really 
important. It makes people to cooperate. Not only individuals, but 
people from competing corporations. The free software movement sometimes 
"glues" people stronger, that money interest, which often works to 
separate people.

The whole history of the humanity can be seen as a history of ugly wars 
(the war is always ugly regardless of its reasons, because it always 
kills the human in a person).

 From another side, the whole history of the humanity can be seem as a 
history of cooperation. It was cooperation that allowed us to get out of 
the caves into outer space, to create computers and to write operating 
systems and other software for them.

Any war will some day end and any government will some day become part 
of the history, but the story of human cooperation has a chance to 
outlive the history.

In that sense, free software works in direction just opposite to the 
war. It lets people to cooperate, to see humans in another person's eyes 
(and code). Even when we are separated by the war.

And it puts a lot of responsibility to the free software leaders, 
because they not only manage lines of code, but somehow define edges of 
the future of the entire humanity. At least, in some aspects.

As a professional, I'm trying to cleanly separate software development 
from any kind of politics (probably, the same we all expect from the 
medical doctors). When I receive PR for review or a bug report, I look 
only to proposed code changes or bug description, regardless on who send 
me it.

The Linux Foundation is the community of software professionals. I 
understand that this is US organization and it is sometimes obliged by 
the US laws and regulation.

What would I expect from the professional organization in a case like 
this. The following:
1. The clear public note, that according to some US regulation the 
people from the sanctioned organizations cannot longer act as kernel 
maintainers
2. The personal communication with each of them, with explanation what 
is going on and verification that these persons are under sanctions
3. The clear public note, now with the list of affected persons, 
explaining that they will be removed from the maintainers list and with 
the great thanks for the work that they have done before.
4. Inclusion of these peoples into the kernel's hall of fame (the 
CREDITS list)

Nothing of this has be done, unfortunately. This is very, very pity :(

--
With the best regards, Alexander Pevzner (pzz@apevzner.com)
