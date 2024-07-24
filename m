Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B4213E020
	for <patches@lists.linux.dev>; Wed, 24 Jul 2024 13:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721829047; cv=none; b=SAq/052l4HMYBvsQsFrhYf27bnVt1XOA8q7VWN238CBr34xabpRClwWBB1xLQ2uH2HKllyFWTT1hOoXrS6E+MaVZicQlQNJyoPUlP+Ict/N+wDms8/7hxFu1ki8gWpkr1b/xrBLh5EeclDvjeqmFkph9+Xfxn/1tKreR7+3iNZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721829047; c=relaxed/simple;
	bh=5tYaunI9mHj7AJQXknuwa1odhAFPbxz97YpU4VGHqo8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eQwiwDyy8P+csZdsOCE5EYDyMDkX5QPuDyZBcChQDYegpsjFG4kFRxkOeMaSQUxBkkMKoYw9/WLpHFbuEgVVQnQFhTViDn1ApmcVpATCpdXCRnd18Iy3Q9AABL12fC7ESZ+DMvaRXFAYWtcP1bpA8HeqTAn7cFtLpFShVYBa9x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=DnBYxoLb; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="DnBYxoLb"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-58f9874aeb4so5748516a12.0
        for <patches@lists.linux.dev>; Wed, 24 Jul 2024 06:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1721829044; x=1722433844; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1tb/0vlo04/6oUmqi9MW3/tdDuhFSKMBGaNrhUjbNNQ=;
        b=DnBYxoLb/U/NzJH8mdgak0eoYYtjSY2itfrp5KMn7Ng5fO/I8GjdBkUYTBFmyH1D9n
         LXcU3ixq0e9RWT4l0lMMmrHFzaJjGh6IkCuyluswsP8Yjw6SyvEDu+80SOAAplrKf/F7
         yOLeJocSxlydPv292o+TQ/4SJOg4r++q5l+3laoSP7b6u5RNJQHu3bI9iyfPis+RIDzb
         pM4yY3TegPNLnjsqDRuIUb7gWvuqAYpu5VUin94VLWZw7ry7TJ40fIQgSzs5WzHanFY1
         FeZwjUn38C3wx3Ni1ysvfE90aTGJOQzTzH92SWr2aaFJ/ByexNpV9vv2HWf7nJuqTqMS
         aXfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721829044; x=1722433844;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1tb/0vlo04/6oUmqi9MW3/tdDuhFSKMBGaNrhUjbNNQ=;
        b=UBSbBiyyiJszNG7E7KN0oRR98YEWldCKdqyzvj+z40d2vkW1EeIwdY1wo7dByCLTc9
         woJv2m4ComJrvAkHF4YEZsW3fazlnFPQ1d+04l5KNdexvkaiF2zo/KCz5Xtg7ASCUZiM
         OccvyCfRRioxaRnGuOg//pwXp7jUQAdIzxWrJgJPYE9oZOXBGAiC1jlCXTOe4T3+ZNCN
         BH7zX699GGWz3cw/ow1Ih3ZY4+iKEnaCVRTjSmzsALOQXdj2sjkykCbPqQByK/GosVc/
         Ff6Z0FHyUaPUaWOP1PyxJLYdlfWQ1G8umzCJUA0EsheB1nQXWyxvHwzNvy6vUwE8/Qxj
         8BvQ==
X-Gm-Message-State: AOJu0YxAuKcJZaAVptHsZMV0iYoChciXmlchaouAo9lu+OX/Am3Pp1HP
	9w9EVEdGDh3OvZMY8nhFEanTNzCnAWXmWM4WfCFaahp/jE9c7kw=
X-Google-Smtp-Source: AGHT+IFF1t3XbbSMwoDx6IknkN6dSpsDw3xplReMpBPmOq6tt+lyAKbMk4Fl1g+1mSBg6rxdmMa8CA==
X-Received: by 2002:a17:907:3fa4:b0:a7a:b3ff:7da7 with SMTP id a640c23a62f3a-a7ab3ff9247mr147136266b.26.1721829043889;
        Wed, 24 Jul 2024 06:50:43 -0700 (PDT)
Received: from [192.168.1.3] (p5b057b1e.dip0.t-ipconnect.de. [91.5.123.30])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7a3c95200fsm643476166b.225.2024.07.24.06.50.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jul 2024 06:50:43 -0700 (PDT)
Message-ID: <08c24d4a-eaf3-48d7-ade1-004a97be982c@googlemail.com>
Date: Wed, 24 Jul 2024 15:50:41 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.9 000/163] 6.9.11-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240723180143.461739294@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 23.07.2024 um 20:22 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.9.11 release.
> There are 163 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>

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
