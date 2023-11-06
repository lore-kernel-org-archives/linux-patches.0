Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCB0522D
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 21:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=arista.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arista.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arista.com header.i=@arista.com header.b="dxSn97Ic"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-40839807e82so30687635e9.0
        for <patches@lists.linux.dev>; Mon, 06 Nov 2023 13:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1699307299; x=1699912099; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=az7ExxO94n7Tzege6R79RlIuC0dJHugUw3dOV0fKG+I=;
        b=dxSn97IcA83oueRyS9PO6tPxOgDb5Z8DUK0D5Fwivx3ktv/MTp9jqlVTV1ZGGJWt75
         RBLTyFuAFsrpapALalJDtquBDHe949xnRfn3RP9ZBD1lWAYSpJhfqUyRi9YigXintdzs
         RkL+lELx0vBbbaFZjpX6IxtH5ObIbCedpiZqGi5ojo5oP9s93qM8+6AxrQQj3qCwdH1Q
         mRXdEaGG6eeSyM9AMR5Zfxo0AMza/ZheuIj3Uw6nkRnN9+YWDdToRGw6sV3epNzedKv7
         On7OoJwigbLUc4202tCzAMgH2xl68njpUwk1Jzgm2sZQ8yiQXgPQDZ61uo3sKA8uZBKH
         938w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699307299; x=1699912099;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=az7ExxO94n7Tzege6R79RlIuC0dJHugUw3dOV0fKG+I=;
        b=ijexl3gp2z2RCgXIciGhS8t8g6YjdZMKMvxs0y4h/gJUdkecy3JE8L31yhPz8+9uNo
         nuaNild/sidunJuyOPnza3RKyFWf5XKxcscskjHQc9qHb4wJGbA2JPT2DISfulJl98HB
         /NajkdPlI1mj35ICNfd7i6v242G4LbWq7FMUGf/fnZ0LD9a/LnDvW//krwkgM4Vadk+X
         ZEMQC8t4MpGaNelr+DUIQ0LIZZ48ObA+9zqPZn1TPEr4vJRd+yO4t4St+PmIaGE8OozU
         DFtruyR5S4jJDg83TVLwDtoRY1WcQo9rppmu7dmWx3EHo/A5M8A+i7hMG9hASTml5MWJ
         WWYg==
X-Gm-Message-State: AOJu0YyszbWOuf2eUY0z7MwjWxTK88vFkeu/q6uWa7faU3AU4ELL8eUi
	/+D8jWPJFGwkDqIUsnNSm6riww==
X-Google-Smtp-Source: AGHT+IEF4p80QoTLDD4KV3JQ2AnS0F8rRoHPd1/kCN+tYAzVUsjYELpEmJ4GHmO0V+YDLmjBPSTWBw==
X-Received: by 2002:a05:600c:2483:b0:407:73fc:6818 with SMTP id 3-20020a05600c248300b0040773fc6818mr1095597wms.2.1699307299346;
        Mon, 06 Nov 2023 13:48:19 -0800 (PST)
Received: from [10.83.37.178] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id u3-20020adfed43000000b003140f47224csm617514wro.15.2023.11.06.13.48.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Nov 2023 13:48:18 -0800 (PST)
Message-ID: <7be96bfd-7e79-4b13-87fa-0e3d06ead30b@arista.com>
Date: Mon, 6 Nov 2023 21:48:11 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v3] tcp: Fix -Wc23-extensions in tcp_options_write()
Content-Language: en-US
To: Nathan Chancellor <nathan@kernel.org>
Cc: ndesaulniers@google.com, trix@redhat.com, noureddine@arista.com,
 hch@infradead.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev, patches@lists.linux.dev, edumazet@google.com,
 davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com
References: <20231106-tcp-ao-fix-label-in-compound-statement-warning-v3-1-b54a64602a85@kernel.org>
 <a8cc305d-0ab8-4ff7-b11a-94f51f33ec92@arista.com>
 <20231106213408.GA1841794@dev-arch.thelio-3990X>
From: Dmitry Safonov <dima@arista.com>
In-Reply-To: <20231106213408.GA1841794@dev-arch.thelio-3990X>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/6/23 21:34, Nathan Chancellor wrote:
> On Mon, Nov 06, 2023 at 09:26:48PM +0000, Dmitry Safonov wrote:
>> Seems like exactly the fix that my git testing tree had, with an
>> exception to naming the helper tcp_ao_options_write().
> 
> Heh, not sure why I never considered that as an option... I am guessing
> it does not matter enough for a v4 at this point but I could send a
> net-next change later to update it if you so desire!

It doesn't matter really, not worth another patch :-)

>> But then I found* your patch-v1 and decided not to send an alternative
>> patch.
>>
>> Thanks for fixing this,
> 
> Thanks for taking a look!
> 
>> Reviewed-by: Dmitry Safonov <dima@arista.com>
>>
>> *had to fix my Gmail lkml filter to label not only emails with cc/to my
>> name, but also the raw email address (usually, I got them to/cc "Dmitry
>> Safonov", but this one didn't have the name and got lost in the lkml pile).
> 
> Sorry about that, b4 used to have some interesting behavior around names
> at one point (don't remember the details at the moment) and just using
> emails avoided those issues. Maybe I should go back to names and emails
> to see if I notice any problems again.

No worries, should be fixed now. I preferred previously filtering by
full name, rather than email address as I send patches from both work
and home emails, but also sometimes people send patches/questions to
emails from the companies I previously worked for, regardless .mailmap
entries.

Probably, they look for author in lkml/mail archive, rather than use git
to get the current/proper email address.

Thanks,
             Dmitry

