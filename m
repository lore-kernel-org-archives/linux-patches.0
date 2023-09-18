Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF391CAB9
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 18:33:34 +0000 (UTC)
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-34deefc2016so16743145ab.2
        for <patches@lists.linux.dev>; Mon, 18 Sep 2023 11:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695062014; x=1695666814; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JTA1VVN3J1MjDZguKA7jeRxj5alEQOs99WsJuGyCrjY=;
        b=HvqNOZI7owsnkYQX8P1ep0HkAbCss/dab8AyvfyN4BdXQdAatX7SOl/Dj2yUnCq2De
         LTytNXs90UYDkhIOiVQ1szJVOceGpUvPORZU+zwfnA99Eck9eojdxGSwPFOsEv1lWIeP
         MUKA7vvJqPsDv9HLxXly6AG76wzUFRVyaTrmH3zpJhwHpVjK8izafcqJwN+wcP22YGZ6
         4ArbCDhrl6gmppjDv50DV5yn9y9ymJS4REg9Yk3DDTCh1z8tI5OUYFLwNTN6vp5XgDUN
         cZMnXdYuJU676MDet3cG4b9XpgLJpPJy3ZZxMm9q5d5Xpy2AriPZQBr538FZgV6FF/mm
         96gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695062014; x=1695666814;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JTA1VVN3J1MjDZguKA7jeRxj5alEQOs99WsJuGyCrjY=;
        b=iR/lHJgBEQ5mParP6l6FQOJEdpofmqC4H4W5xzrbeYr5/Sj4RSijcwTFtpmjDX0b42
         u1YtcYerZquPVvh03H7tqVM1+g8GA1MkOLSgs4mXgHWEYco+6dpoJyQjz2tr2zn+w7A0
         ZbnbJsYk2IAvhPd/2+I4KmmcxfWtv/vAz0GX5dgMBA29hrQqme1WixPc2KFblZ2f4HBx
         Vxu/BFR1rnz+FBbNzXo4amxKlSXGcil1Pn4OsjxSVk+iJqDrySGz8CCOWMg0y8vhWD/a
         0Op82h0e4/oJWao+KPEU1IIFLA/zLZr3LbNsHcM33aB6fsY/HHqZNGyN9cBZMldqyLIo
         CZ9g==
X-Gm-Message-State: AOJu0YwJQ9ECAep9nQJjAlVzsC+5xwIwHV+jgYRO20NBfG2fgayzKc2t
	qgeJLTrEK9qM3UdMMECFe3w=
X-Google-Smtp-Source: AGHT+IG+I26s4WOtf06vG+cUHmLc7QxIV17q4Uw/P9uvCip5VKX/U1XMB4ehHMXJaS4+IFeGa50bwA==
X-Received: by 2002:a05:6e02:1d8c:b0:34f:75cb:7f0 with SMTP id h12-20020a056e021d8c00b0034f75cb07f0mr14265147ila.12.1695062014195;
        Mon, 18 Sep 2023 11:33:34 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x59-20020a0294c1000000b0042bae96eba7sm267655jah.7.2023.09.18.11.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 11:33:33 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 18 Sep 2023 11:33:32 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.10 000/406] 5.10.195-rc1 review
Message-ID: <562e05d9-8559-430d-95d6-8873bed61223@roeck-us.net>
References: <20230917191101.035638219@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>

On Sun, Sep 17, 2023 at 09:07:34PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.195 release.
> There are 406 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 19 Sep 2023 19:10:04 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 495 pass: 495 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
