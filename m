Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB9D34CDD
	for <patches@lists.linux.dev>; Fri,  9 Aug 2024 05:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723182418; cv=none; b=LjQ1iGVj8672Yg4vejmtdN982bA30phZ/aRftYwj8gnDywE0QCD4vh7XOHhblR2kvEUuGP5atBodiClDROUVBUG4u2q8STOvdZzf9egY8Y0t+jyr1s6GRyqShAR3ivwXat7/N9MqzjSbpUA47/zGYw371lMWP5ZFGOsDJh+Gmxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723182418; c=relaxed/simple;
	bh=0E0LWRTGx2617hGp31o7gUJtB2TmoGqYJk5qN3qe7ik=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HEmYM2HlWrgXQ3Ze/cRRnTDYax60sq9mIh8zgAvH/ixzHGQExPi1qXCXMf5kCf01sdCb2DJY1RjvA064j8XGqX9f8q4PRN5x3TpzSRJxM9eBDcbZfAbITgUZcid10ZIzmHrPn2liDs+BiRTYz98ohsyyHvCOQ1GnyBWsBz8rvNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Hvju6qp+; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Hvju6qp+"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5ba482282d3so2110286a12.2
        for <patches@lists.linux.dev>; Thu, 08 Aug 2024 22:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1723182415; x=1723787215; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c/lpeCLNhSG0sHQuHLswm/MdyizAAuRsLhhJ2tP51MM=;
        b=Hvju6qp+i8SxQqdyi3jEH24VkAhusq0WZiSNWjlD1OvVS7pR9gSbtvMo1yVqZltqL5
         YJEXmTYUhkQ6PjFvFNZjY6DpL5adgS9Yt/6UGXc+CCeeWVkSkD21KUurNFtUFXJcHlqY
         pwoObIuvOqRCB9G+CPu3EFUSENGGFLvwi7ydXMsefrFCEv7O3mu71dHVO6tdZir7wbyW
         IytbDT1eHPO4U3FCSTt+A3pEFDLwJsen/XHJ4MpWn3yx0mTFyaTjw9CV2XvC4x4J5qLm
         L359Rshx8ES9g0b8jWGKuwGrtg3o4zXoR5qT8cCcJY5MTCvyZnuX4uNwwyO1gbu059o5
         K0pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723182415; x=1723787215;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c/lpeCLNhSG0sHQuHLswm/MdyizAAuRsLhhJ2tP51MM=;
        b=cvTUdbWN2eExOluHB4UidRnUn3/4gBUDLDOs1yi6twR1tExKIREGTVG0EUiswlHIUD
         U/vO87bVl3jWv7ogNkm4XujIT5LI4gsYCV79fqeudpS33rClBUb1lJ0EynQd6FyBgEUN
         F9FXQB/d7sby5PGihElafMPBdQA99LwH5yenOCn+lftRGspjXMKQ93/qSj4nxaSILjMe
         RzFOJPIVMMZLACsNwP0EaooG5aAxhPcaAMs8oYwVpUihGPZVk8u9ZC2OgfejV9QMcHW+
         lK4WM1Eo1jYt/Y4HXJKxOge+cWxxhBBpA8FJv6uTF1umFQDYZofCB1mQOV8ZZrV48fOg
         YJYA==
X-Gm-Message-State: AOJu0YzVq++TwbQNLpTeop8xvx7o1DTfpSH7M3gRhsFNysEoSeWdHAFT
	x5zIupyUAJEEokWhXostXoNcy0siD0arbDfK5plF5qZ7cX8aQvg=
X-Google-Smtp-Source: AGHT+IEQDUWeO9IyesyvpxutFL1b+2BTg1/F6pcdSzEJWMH8VCDcqZq/Eap5yurEGbPb3qaOPrNPFQ==
X-Received: by 2002:a17:907:c7ea:b0:a7a:bece:6223 with SMTP id a640c23a62f3a-a80aa556854mr38555166b.6.1723182414749;
        Thu, 08 Aug 2024 22:46:54 -0700 (PDT)
Received: from [192.168.1.3] (p5b05740f.dip0.t-ipconnect.de. [91.5.116.15])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7dc9bcaf7esm824725966b.12.2024.08.08.22.46.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 22:46:54 -0700 (PDT)
Message-ID: <3bb19eed-0ad8-48d2-ac57-9663e932e6c2@googlemail.com>
Date: Fri, 9 Aug 2024 07:46:52 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 00/86] 6.1.104-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240808091131.014292134@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240808091131.014292134@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 08.08.2024 um 11:11 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.104 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


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
