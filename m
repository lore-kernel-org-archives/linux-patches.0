Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC93B225A6
	for <patches@lists.linux.dev>; Tue, 10 Oct 2023 18:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OTkb38hu"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1c9b1e3a809so8099025ad.2
        for <patches@lists.linux.dev>; Tue, 10 Oct 2023 11:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696961925; x=1697566725; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6XnyoQ1g3Q1HQw6m09F9jRitIO0RjbfZpnIN7z+4Ea8=;
        b=OTkb38huVp04aGVhAh7EEhcVqYqWy9lJgkWpo1bnw+JdEsHJhTsmPGONn06LN/1xd0
         LxKR6KkYc4i4C83zGecyAcIyW+UAoola0xoNE0vLRj5Az/N3Os+OMPqmUPsYu10RcG+H
         yQPyIHEkHeim2sQyh5JlcFU0SfIHQBubCtN/uxiiqpC7Og3z+TA4/X+ynywehJOr5kMA
         9c66eOOmSenhbSUqAswZugUzR3xh//iuxWKX32iQXISvNm55NTtAMFL9HrK00rYckDPS
         IdfRi4NX60dKmbxxzdzSQM83yh6iwBCcsg2V3YBsPucqS72yuKN5O1O4VwWMjLus69ye
         Bwrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696961925; x=1697566725;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6XnyoQ1g3Q1HQw6m09F9jRitIO0RjbfZpnIN7z+4Ea8=;
        b=JtDiU8RRN8ABjD11dyxwq0Cf8+0upI95AYHhpnmJb3ek5UDAp+g+A3vLN49GKtKot+
         TN6jgK6xXAel/crpo8xGOP3zXN5bVoomLGNMg/Gbgx0ThxzdSxXQ9nPIYrZ9u2c7L+wW
         BDM8IhifzImdogFMCKlsIhMuCFZzI0tEYtFrLoblpAK02AXAw33wYluyiGnMLcu4oTpL
         /vNI/aGh1V0Kh6FqLRkLWzzcC7zY53ldpQGfJM6AO6w1D/+Ijt+HoxQPdwZWY0VHnl/k
         qhA8I0ORuxnDz9fdfTFoZd6IC0SmRuej+8jSazCckV7u3JDPL/PkfnT0JCyepTcZ8BhN
         71Jg==
X-Gm-Message-State: AOJu0YwWa0ItkpoVtXuxc8DLqc6/7I3cU6fYeO6BmQ6VhvJvu07hbg+t
	LQE6pUkDghVLJ41/KWunJ4t/J6G9YbI=
X-Google-Smtp-Source: AGHT+IH0KmVaMdeP2KJmmw2jzVnlGC/X8o7+CPX68/TYmt/Ud6wSXDoKjFg6GTKhy0WTiTAN96ok5w==
X-Received: by 2002:a17:902:f68b:b0:1c8:a68e:7f1 with SMTP id l11-20020a170902f68b00b001c8a68e07f1mr7081125plg.66.1696961925144;
        Tue, 10 Oct 2023 11:18:45 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i11-20020a17090332cb00b001b8b1f6619asm12121601plr.75.2023.10.10.11.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 11:18:44 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 10 Oct 2023 11:18:43 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.10 000/226] 5.10.198-rc1 review
Message-ID: <63a3fdf2-737a-44c6-9a6d-bf5edd8df964@roeck-us.net>
References: <20231009130126.697995596@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>

On Mon, Oct 09, 2023 at 02:59:21PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.198 release.
> There are 226 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Oct 2023 13:00:55 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 495 pass: 495 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
