Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC182F3E
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 23:24:05 +0000 (UTC)
Received: by mail-oi1-f171.google.com with SMTP id t22so12177217oiw.12
        for <patches@lists.linux.dev>; Wed, 01 Mar 2023 15:24:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MBy37NoOiV44ZXQw10RgXnBxTEBWUevOWxm5PdpkoeI=;
        b=HGErcMlSAlTgH9cBRiSikCXGpHFgm8g1JIxHvOWfrNvR670hkZilAUeEe14dJY4bB2
         uWS3ELx4eMx4H4N32DDrDNfBbSJcRY2fZzYlgnYxB5GnJ+JyhpCY3ZuGuhXBGD1WOkjX
         HlU9C50iB2s4G3PWHJ6gcWwxzq1Ar8AzDDNyE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MBy37NoOiV44ZXQw10RgXnBxTEBWUevOWxm5PdpkoeI=;
        b=IcvgYBs19CZ4aqcqdYroFlbSpg5uRT5kEYX97E1+LwkbU30rMp9mBQ/q+67pr2JULP
         j2ylr4w6eqL59I9dqrWbh4DwYZb+0LkKBiaUHD00UqcoBNMqH6B4puZ+0g4DCE9639q2
         LG/f97uYDkd76YVTi3/PKCBHk+wzr3Zdsv4BVVxVV6b9bBOaBLAPW3IVbvLe4+EImkRA
         uQZhX7auwORU72DU1MpPyFrrd+lL9/J1FlUatwDtMyimIOObulxxAsHNkcT3k1LZYkDy
         IsUXu+u7xTBlA1glXMMJwxlMSKaw2LNQ69eSrmoUFfSV7VDWbvqx7c5uRzZCmHhTUwpA
         skmA==
X-Gm-Message-State: AO0yUKVwTFMwfXxJ3toU/RglJZ11mSKGbHxE4pDJDqLIkPF+l+rwxaDz
	bjSL6tLCNobrW4APbZf2nExv0g==
X-Google-Smtp-Source: AK7set8/pItrW8pjpdC5op9qqcqNb3wEilvsaJasloBHbzJntz2oYBL+QjHtnKSOy2h18KARhdqhFw==
X-Received: by 2002:a54:488c:0:b0:384:8a1:c14b with SMTP id r12-20020a54488c000000b0038408a1c14bmr4304349oic.31.1677713044362;
        Wed, 01 Mar 2023 15:24:04 -0800 (PST)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id eb3-20020a056808634300b0037d8c2ff0acsm6367101oib.12.2023.03.01.15.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 15:24:03 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 1 Mar 2023 17:24:02 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 00/16] 6.2.2-rc1 review
Message-ID: <Y//eknqY6WbJeXWB@fedora64.linuxtx.org>
References: <20230301180653.263532453@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301180653.263532453@linuxfoundation.org>

On Wed, Mar 01, 2023 at 07:07:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.2 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
