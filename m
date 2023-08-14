Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320CACA46
	for <patches@lists.linux.dev>; Mon, 14 Aug 2023 21:27:57 +0000 (UTC)
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-6bd3317144fso2659892a34.1
        for <patches@lists.linux.dev>; Mon, 14 Aug 2023 14:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1692048477; x=1692653277;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h2Gb6QdAQZGLkPrUcUrS4E1/hnWfvRNciGalZbqgQQ4=;
        b=i11OJNbYHC5AYqDBR2eu2fGiK9DqeYAVHKwAtBqDqVczemPMwMq9yxj0tSz8BMAJy9
         Td5JKgLF5NR7KOz2qv7DwuVONvciQESKh8dLyfB6SZTY8qDJFQP3y0mQ1NbREL5rTC4Z
         F4fAQra83kQoWFJkYnHg+4p6ZlIDUtVKUTvZA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692048477; x=1692653277;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h2Gb6QdAQZGLkPrUcUrS4E1/hnWfvRNciGalZbqgQQ4=;
        b=LDzMEgfwtGBaoawmKamBitX1sB56PVJOqxeK1loGr+gWrI83cOahk0n/YERuRJrJy3
         KplxUEe44bxcyhdwZ1UpDH79XuB/ctAIm1vUoOkVu6DFTCYz2lcxgAu8yIELMHBzsh15
         dkxw7UAJVnDFtb3q8aACit27TtMJPAoySxD/XGHrh+XaAeE9CpwKTeWcyolstwNXjGlj
         vYArgHvmIoTp44U+C6mSwXgLF9L7IdZe0eLdlCHfAuZxWk7Owy9qpa2PhF3AqJp9vBYl
         R1r/6TMKBwHN3Z9gYQdhKXadvQ9wk6EzEne+az6h+cfFZyT8cZoLiCNX2Hc1hx+yWlAe
         G9Zg==
X-Gm-Message-State: AOJu0YyTn62Mt7sSGkfsKNrv/qR3phy2M8jwfwF14qRJey5rXpRcsju0
	Jeq2tPxnb1ep1JuxNhn6mzd4ig==
X-Google-Smtp-Source: AGHT+IF5Big4bba0sH4Y/J9B79lhl7z/AYAs28CvbkFA9qljvEtUNhSestPpkhMBziUHW7zBNaIktw==
X-Received: by 2002:a9d:684a:0:b0:6b2:9bdb:a84a with SMTP id c10-20020a9d684a000000b006b29bdba84amr10662554oto.32.1692048477015;
        Mon, 14 Aug 2023 14:27:57 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id d27-20020a0568301b7b00b006b1570a7674sm4708854ote.29.2023.08.14.14.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 14:27:56 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Mon, 14 Aug 2023 16:27:54 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.4 000/206] 6.4.11-rc1 review
Message-ID: <ZNqcWhqouBYey/8g@fedora64.linuxtx.org>
References: <20230813211724.969019629@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>

On Sun, Aug 13, 2023 at 11:16:10PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.11 release.
> There are 206 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 15 Aug 2023 21:16:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
