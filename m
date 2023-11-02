Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F7E219FB
	for <patches@lists.linux.dev>; Thu,  2 Nov 2023 20:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b="V+Fqv1x6"
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-5875e2b27c5so465199eaf.3
        for <patches@lists.linux.dev>; Thu, 02 Nov 2023 13:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20230601.gappssmtp.com; s=20230601; t=1698956635; x=1699561435; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZYxqorYTLyNgH4Ys5lNUekyUrwpkE+NAoR9Xx/kQ8MQ=;
        b=V+Fqv1x6OfCPePJLEzGlXazH6iXYqoOiXxmdsMXzwcVenXkv1HzqP1nMnC0PKLuDVY
         8EMwUHzxYjEuI76cDEWa9yRkftehszwxkWzwnjxEVX75IG3KMWz9YFD/iY5KYARwxm+u
         NBg+1FKxxYOCtmcGglomRS0u37eXgPOERgEyJM6nas80MUZFsHDB5DJRmG/CkftP8TgK
         t+YVqPcPewSKtAlxZGuHufOoo3zKZBNVpQc1mfQ9sILc/+iM3E8/rB29tgXYFGZEuPWz
         Q5EWuruz+EnL6LysqWp2e9TaFc8y/RtwVbhbasXLPK6vv8hZczcR3GcHTAKqPPXN8XuM
         Gw3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698956635; x=1699561435;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZYxqorYTLyNgH4Ys5lNUekyUrwpkE+NAoR9Xx/kQ8MQ=;
        b=K7oFO63klVKGrJzibtK/DK+B9VRRER9bi7DlsC+qxU7hBwwkwV1CVWVPZs742KGitP
         Dd3fsMDPeFy1YGDH8oV45HZp8B5dyYUQUb6lHOs6ZwZTBVglUvNAXxZSjrXi/1cbj+3w
         0t7OCInK+cNUt3Xe+AxFiX3HeLrE2OntBvZKmx7e5dblU/V242BdAKw5G9wlZ7PNScU3
         AWRm1QVq3RsHdvGgFOaG2FXwhvGZYuBH7SgrHWSklbeLiet/vXiZja3rSbHwdlvjc2Rc
         AXx0Ar6yFRHBOS2JCH6SGL14OTLtV03/QggPMcPp83R30We56elZ/IhVsw7aqRshuJUQ
         HuKw==
X-Gm-Message-State: AOJu0YzN9y1TW2iEEYEi0gupU0/onTH/G9pJJvLe6FMa2lIkUQlAJOW6
	ll4mOkSsEnb+JR/IRqJOENZvzA==
X-Google-Smtp-Source: AGHT+IHvjzSJSgbbFHJHFSPQEfHZb0G1dwFxE6QUSYdRHcKUimuPg3oA0e89k53MrVMNkydfp+r/RA==
X-Received: by 2002:a4a:b487:0:b0:581:ff09:62e4 with SMTP id b7-20020a4ab487000000b00581ff0962e4mr19252180ooo.2.1698956635428;
        Thu, 02 Nov 2023 13:23:55 -0700 (PDT)
Received: from localhost ([192.184.165.199])
        by smtp.gmail.com with ESMTPSA id 64-20020a4a0943000000b0057b43a25deasm52070ooa.3.2023.11.02.13.23.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 13:23:54 -0700 (PDT)
Date: Thu, 02 Nov 2023 13:23:54 -0700 (PDT)
X-Google-Original-Date: Thu, 02 Nov 2023 13:23:51 PDT (-0700)
Subject:     Re: [PATCH net] tcp: Fix -Wc23-extensions in tcp_options_write()
In-Reply-To: <mhng-41e9fb36-f703-461e-b585-9e8dd5984714@palmer-ri-x1c9a>
CC: edumazet@google.com, davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
  pabeni@redhat.com, ndesaulniers@google.com, trix@redhat.com, 0x7f454c46@gmail.com,
  fruggeri@arista.com, noureddine@arista.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
  llvm@lists.linux.dev, patches@lists.linux.dev
From: Palmer Dabbelt <palmer@dabbelt.com>
To: nathan@kernel.org
Message-ID: <mhng-7500e386-1e83-4303-a1ee-cd2d5688e73e@palmer-ri-x1c9>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On Wed, 01 Nov 2023 18:42:10 PDT (-0700), Palmer Dabbelt wrote:
> On Wed, 01 Nov 2023 18:07:23 PDT (-0700), nathan@kernel.org wrote:
>> On Wed, Nov 01, 2023 at 05:41:10PM -0700, Palmer Dabbelt wrote:
>>> On Tue, 31 Oct 2023 13:23:35 PDT (-0700), nathan@kernel.org wrote:
>>> > Clang warns (or errors with CONFIG_WERROR=y) when CONFIG_TCP_AO is set:
>>> >
>>> >   net/ipv4/tcp_output.c:663:2: error: label at end of compound statement is a C23 extension [-Werror,-Wc23-extensions]
>>> >     663 |         }
>>> >         |         ^
>>> >   1 error generated.
>>> >
>>> > On earlier releases (such as clang-11, the current minimum supported
>>> > version for building the kernel) that do not support C23, this was a
>>> > hard error unconditionally:
>>> >
>>> >   net/ipv4/tcp_output.c:663:2: error: expected statement
>>> >           }
>>> >           ^
>>> >   1 error generated.
>>> >
>>> > Add a semicolon after the label to create an empty statement, which
>>> > resolves the warning or error for all compilers.
>>> >
>>> > Closes: https://github.com/ClangBuiltLinux/linux/issues/1953
>>> > Fixes: 1e03d32bea8e ("net/tcp: Add TCP-AO sign to outgoing packets")
>>> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
>>> > ---
>>> >  net/ipv4/tcp_output.c | 2 +-
>>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>>> >
>>> > diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
>>> > index f558c054cf6e..6064895daece 100644
>>> > --- a/net/ipv4/tcp_output.c
>>> > +++ b/net/ipv4/tcp_output.c
>>> > @@ -658,7 +658,7 @@ static void tcp_options_write(struct tcphdr *th, struct tcp_sock *tp,
>>> >  			memset(ptr, TCPOPT_NOP, sizeof(*ptr));
>>> >  			ptr++;
>>> >  		}
>>> > -out_ao:
>>> > +out_ao:;
>>> >  #endif
>>> >  	}
>>> >  	if (unlikely(opts->mss)) {
>>> >
>>> > ---
>>> > base-commit: 55c900477f5b3897d9038446f72a281cae0efd86
>>> > change-id: 20231031-tcp-ao-fix-label-in-compound-statement-warning-ebd6c9978498
>>> >
>>> > Best regards,
>>>
>>> This gives me a
>>>
>>> linux/net/ipv4/tcp_output.c:663:2: error: expected statement
>>>        }
>>>
>>> on GCC for me.
>>
>> What GCC version?
>
> 12.1, though I can't get a smaller reproducer so I'm going to roll back
> to your change and double-check.  Might take a bit...

Looks like there was just some bug in my test scripts and the original 
patch wasn't actually picked up for all the configs.  It's working now, 
so

Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>

Sorry for the confusion!

>> I cannot reproduce that error with my patch applied. I tested mainline
>> at commit deefd5024f07 ("Merge tag 'vfio-v6.7-rc1' of
>> https://github.com/awilliam/linux-vfio") using GCC 6 from kernel.org and
>> I can reproduce a similar failure with ARCH=x86_64 allyesconfig:
>>
>>   net/ipv4/tcp_output.c: In function 'tcp_options_write':
>>   net/ipv4/tcp_output.c:661:1: error: label at end of compound statement
>>    out_ao:
>>    ^~~~~~
>>
>> With this change applied, the error disappears for GCC 6 and GCC 13
>> continues to build without error. I can try the other supported versions
>> later, I just did an older and newer one for a quick test.
>>
>>> So I think something like
>>>
>>> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
>>> index f558c054cf6e..ca09763acaa8 100644
>>> --- a/net/ipv4/tcp_output.c
>>> +++ b/net/ipv4/tcp_output.c
>>> @@ -659,6 +659,11 @@ static void tcp_options_write(struct tcphdr *th, struct tcp_sock *tp,
>>> 			ptr++;
>>> 		}
>>> out_ao:
>>> +	/*
>>> +	 * Labels at the end of compound statements are a C23 feature, so
>>> +	 * introduce a block to avoid a warning/error on strict toolchains.
>>> +	 */
>>> +	{}
>>> #endif
>>> 	}
>>> 	if (unlikely(opts->mss)) {
>>>
>>> should do it (though it's still build testing...)
>>
>> I am not opposed to this once we understand what versions are affected
>> by this so that we have some timeline of removing this workaround.
>>
>> Cheers,
>> Nathan
