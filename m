Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50EB24F2B
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 20:45:16 +0000 (UTC)
Received: by mail-oi1-f178.google.com with SMTP id b124so7953607oia.4
        for <patches@lists.linux.dev>; Wed, 02 Nov 2022 13:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WSiWPJniiLxzsO2IMiTjGqMh4d3SMmf0JzhNe976ryo=;
        b=I8c780hRp3L9X3806uZwlBW1cU6xUdYgk4w+ZiYe0rwOddJKq6yBcaPz0oF1YxfJaE
         SYU3u/735UxSaDIowp8o5fYJyKXvApm5AHc9NrgqWQqb33/pjMVNO1LcD8vVdLDyowdT
         L+fyvqPMZGvFRE/AlVstiokInwsRwVr0zyHfMKzBCshVSIZo22+pXjluNqkwmM6rpP1+
         Qx5iGZWCddOZ+tyS/0KVcVrl52Q0AP14t0j/nyeUE2Bvh7NdNzGtxfdo3tAm+At97B8V
         Eog4/ocyrxkyv+kZD9h4QTMj62vry3BsMjg3mqiU3/DMft46BD4nmKZN3v7JdZ6FUbMp
         UDiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WSiWPJniiLxzsO2IMiTjGqMh4d3SMmf0JzhNe976ryo=;
        b=O5LLnwf8vDoC8INjsw7WK1NlNTVqMWz+jdtMOgb27Ta1bHZN4atA1DLMcAGy77INj/
         29yNAcMCKbRgXvsb8X1Xfihtf2LxkPXRfX5EUjlTj02odg2My2Blw7f3MG8/1DtpR2qF
         7MkymQiu6oLRXk4FRjYd8yPrqKKo80czQsU4ZNaM2J5DCnl4iu/5aTifRI3nIHZVC611
         /S6Kh7MksQ1g5lrP/XsYFbyTRMPicr+YUYAFyRVvJECaMGnR85FDURF55NHp1vIaBdiy
         kWNZQVfUXvhVHhEWyWpz22G4jqRVP/7yt/9d2b+Mh4BffVNlFzwxEeGlxRFin+MIYETq
         /duQ==
X-Gm-Message-State: ACrzQf1uUSBUwnIfOej96hW1d8+oIx+Z1M3x21RMofztHhd/blwQzHEq
	2731f1u/AhnkJqTYxvxVKdc=
X-Google-Smtp-Source: AMsMyM78I1JgVRU8WE1CtV6sWVA2ugCovJYFth9g0/88Bk/jU2d56hsGL67Xvh5zoTMmAsPg0OI8zw==
X-Received: by 2002:aca:4303:0:b0:354:cbc8:d269 with SMTP id q3-20020aca4303000000b00354cbc8d269mr14242321oia.115.1667421915999;
        Wed, 02 Nov 2022 13:45:15 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g13-20020a544f8d000000b0035437f4deefsm4946401oiy.26.2022.11.02.13.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 13:45:15 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 2 Nov 2022 13:45:14 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net
Subject: Re: [PATCH 4.14 00/60] 4.14.298-rc1 review
Message-ID: <20221102204514.GC2089083@roeck-us.net>
References: <20221102022051.081761052@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102022051.081761052@linuxfoundation.org>

On Wed, Nov 02, 2022 at 03:34:21AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.298 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 422 pass: 422 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
