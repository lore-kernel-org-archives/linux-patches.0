Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1721108
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 05:44:12 +0000 (UTC)
Received: by mail-wm1-f52.google.com with SMTP id l41-20020a05600c1d2900b003daf986faaeso1421194wms.3
        for <patches@lists.linux.dev>; Sun, 15 Jan 2023 21:44:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7zRCfVXAHn6QI7MUc3yzNddVItUeMkttZMVHdMI9lzI=;
        b=79Immi82AXBHBdtuAwmdHlkxbWf+HZqPLQrShoh3V+cnxeHzwSbzkuWV4LsnOwf3z1
         9xme7tDxRoGtKO21tSuCd84k25lu8X42fwNtVROCwsSYY4cNIHfS/k4ieVlPKU39CSd4
         fyEzUhyluxFzUEduleGwvKmMM6y8IEQ0uWNqMbhBJ9NxJuL8T+XNWLpyutmNDFSZXozm
         fZEYvDc3/4ma9mylCe2+FnwTiSM3pMPjjLmBN2pHY7GMVkfPWfYecxppdWin8fLjwkl5
         U/4ZmfMOp4FIQ77Pa7NpDdNFDHo+AdszBCSTDTdQwBwQeSRvV+ek3dkytTMsaP2liABo
         6CPw==
X-Gm-Message-State: AFqh2koaP0xITMpdgYvZg/RPuH/glasvGoDgXu16VqgVjRIl5Up3QFjJ
	0Ri0SgLywHq8NB2sqZOu4tU=
X-Google-Smtp-Source: AMrXdXs/lEjg0thvylnDtAtEHXTD/Wa8S6KWaDuNlRMVx6agb9MEQayHgLF1TjfYsEn8WR01Jr08cQ==
X-Received: by 2002:a05:600c:1c1b:b0:3da:fada:e38a with SMTP id j27-20020a05600c1c1b00b003dafadae38amr2395835wms.24.1673847851170;
        Sun, 15 Jan 2023 21:44:11 -0800 (PST)
Received: from ?IPV6:2a0b:e7c0:0:107::aaaa:49? ([2a0b:e7c0:0:107::aaaa:49])
        by smtp.gmail.com with ESMTPSA id 2-20020a05600c020200b003d9ef8ad6b2sm24204067wmi.13.2023.01.15.21.44.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Jan 2023 21:44:10 -0800 (PST)
Message-ID: <7ecae85c-7562-aee6-a174-5d12af3c64b1@kernel.org>
Date: Mon, 16 Jan 2023 06:44:09 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 6.1 09/10] gcc: disable -Warray-bounds for gcc-11 too
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Kees Cook <kees@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>, Guenter Roeck <linux@roeck-us.net>,
 Linus Torvalds <torvalds@linux-foundation.org>
References: <20230112135326.981869724@linuxfoundation.org>
 <20230112135327.373332907@linuxfoundation.org>
From: Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20230112135327.373332907@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12. 01. 23, 14:56, Greg Kroah-Hartman wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> 
> commit 5a41237ad1d4b62008f93163af1d9b1da90729d8 upstream.
> 
> We had already disabled this warning for gcc-12 due to bugs in the value
> range analysis, but it turns out we end up having some similar problems
> with gcc-11.3 too, so let's disable it there too.
> 
> Older gcc versions end up being increasingly less relevant, and
> hopefully clang and newer version of gcc (ie gcc-13) end up working
> reliably enough that we still get the build coverage even when we
> disable this for some versions.

No, this did not happen and I sent a patch for gcc 13 long time ago (it 
was not applied):
https://lore.kernel.org/all/20221031114212.10266-1-jirislaby@kernel.org/

So should we simply make it CC_IS_GCC && GCC_VERSION >= 110000 until 
this gets resolved eventually?

> Link: https://lore.kernel.org/all/20221227002941.GA2691687@roeck-us.net/
> Link: https://lore.kernel.org/all/D8BDBF66-E44C-45D4-9758-BAAA4F0C1998@kernel.org/
> Cc: Kees Cook <kees@kernel.org>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   init/Kconfig |    6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -892,13 +892,17 @@ config CC_IMPLICIT_FALLTHROUGH
>   	default "-Wimplicit-fallthrough=5" if CC_IS_GCC && $(cc-option,-Wimplicit-fallthrough=5)
>   	default "-Wimplicit-fallthrough" if CC_IS_CLANG && $(cc-option,-Wunreachable-code-fallthrough)
>   
> -# Currently, disable gcc-12 array-bounds globally.
> +# Currently, disable gcc-11,12 array-bounds globally.
>   # We may want to target only particular configurations some day.
> +config GCC11_NO_ARRAY_BOUNDS
> +	def_bool y
> +
>   config GCC12_NO_ARRAY_BOUNDS
>   	def_bool y
>   
>   config CC_NO_ARRAY_BOUNDS
>   	bool
> +	default y if CC_IS_GCC && GCC_VERSION >= 110000 && GCC_VERSION < 120000 && GCC11_NO_ARRAY_BOUNDS
>   	default y if CC_IS_GCC && GCC_VERSION >= 120000 && GCC_VERSION < 130000 && GCC12_NO_ARRAY_BOUNDS
>   
>   #
> 
> 

-- 
js
suse labs

