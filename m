Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADD06828A
	for <patches@lists.linux.dev>; Wed, 13 Dec 2023 20:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OgwP+vTq"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7b724fa9d09so213695639f.0
        for <patches@lists.linux.dev>; Wed, 13 Dec 2023 12:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702497814; x=1703102614; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Qb0Chor65PZwcWQrckJnWHpUdZLfS48jXZAf3E2TW4A=;
        b=OgwP+vTqW+XTj6FVDzuzZmSYqQlQJpZQ2BhK1f7LyWOuPF0Qvv3OCy0gDADenSsx1Z
         4UX7DdXxJAN0Icac1zQi+j+WWA5JiaUGkglbQJGaJs/iwhiUAR5S8xCRxP9MrGMOFjKP
         DEtwxFOR4ZzyyLS/0HCZ5bjikGqKpgR1LAA2F/8rvVG9d5WuCUPz+IOuTf119gdSt/d+
         G6XLS7RrQsMTBmKyB0ySkDjHBRzm+n92KlXCz10DOmRCjf5JVQjA79IgcnSWzxNUl/p4
         DcV9GtkOr1Or7U41WzhulquUTKLAjT9r46enDPvnXufdzREaNkREt8PjGJ2QIEYRrjV4
         frkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702497814; x=1703102614;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qb0Chor65PZwcWQrckJnWHpUdZLfS48jXZAf3E2TW4A=;
        b=Mdt2pbnAZoCAOxE0IUnXTsp+C4LeqwOx4usR/A8lcXPo7aJom4jpBl7e942Jf/wsw5
         /QpZBXxxOJaU1cKxm9ptMBJVgEUiQQywJJiFicpyzVoHWlXv0LwwH9fk/pPWSp7m/s2x
         x5VEqWqhk4aJV8AcuQxtFJhRTOsre8Ou6JPML6RxyYQ7X1/BzbyypMx1zP438PCQGP2o
         XTrsY+R+1Hb9RvN503zZ+gFSTmvp9h/0vE6bm9Hx5vGhA+aX9P6KbYXgFXZ42KEhtMCO
         TZKcJQ5LSozXXphoOvWDO8u8wfz5kygS6THES44h121y+cW4b8jFFNmc1VlKSHlrFo05
         oudg==
X-Gm-Message-State: AOJu0Yz7hqffN1wSlWQ+W21BtGm/ztqg971iNuq7Ibv6SwDcj2MqDCd4
	iOxwjEt/7eO7jDLxr3UA2mg=
X-Google-Smtp-Source: AGHT+IFV/vrZBJsnC90uYksGEy6IktKmTZJpQ4bUjLwE2JNNQ4jAgOyDSOJMfeRgZgTnkpY+LF+gxA==
X-Received: by 2002:a05:6602:80b:b0:791:1b1c:b758 with SMTP id z11-20020a056602080b00b007911b1cb758mr8380586iow.19.1702497813983;
        Wed, 13 Dec 2023 12:03:33 -0800 (PST)
Received: from ?IPV6:2001:470:42c4:101:b11e:59d6:a73:7922? ([2001:470:42c4:101:b11e:59d6:a73:7922])
        by smtp.gmail.com with ESMTPSA id g14-20020a02cd0e000000b0046455c93317sm3089544jaq.92.2023.12.13.12.03.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Dec 2023 12:03:33 -0800 (PST)
Message-ID: <97abd266-3848-165e-001c-b5d3e0504323@gmail.com>
Date: Wed, 13 Dec 2023 13:03:32 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 6.6 126/244] arm64: dts: rockchip: Fix eMMC Data Strobe PD
 on rk3588
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Heiko Stuebner <heiko@sntech.de>, Sasha Levin <sashal@kernel.org>
References: <20231211182045.784881756@linuxfoundation.org>
 <20231211182051.468710881@linuxfoundation.org>
 <0584789e-2337-2d94-608c-81c09ca0d6d9@gmail.com>
 <2023121244-distrust-draw-d67b@gregkh>
From: Sam Edwards <cfsworks@gmail.com>
In-Reply-To: <2023121244-distrust-draw-d67b@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/23 03:36, Greg Kroah-Hartman wrote:
> On Mon, Dec 11, 2023 at 03:05:31PM -0700, Sam Edwards wrote:
>> - 6.6 isn't LTS
> 
> It isn't?  That's news to me, you might want to check the page:
> 	https://kernel.org/category/releases.html
> :)

Hi Greg,

Haha, oh man... the resource I referenced on Monday was out-of-date and 
didn't reflect that 6.6 was LTS until ~6 hours after I had clicked 
"send." Should have seen the look on my face when I got your reply and 
went to check it again; had a moment of doubting my own grip on reality 
until I saw the edit history. Serves me right for not relying on 
kernel.org *first,* I guess!

Okay, since 6.6 is LTS, it makes a ton of sense that this patch should 
be in stable-6.6 and I withdraw my prior apprehensions. Sorry for the 
confusion. :)

> thanks,
> 
> greg k-h

Thank you as well,
Sam
