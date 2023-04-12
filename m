Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C1E746F
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 18:16:37 +0000 (UTC)
Received: by mail-oi1-f175.google.com with SMTP id bh10so8419215oib.1
        for <patches@lists.linux.dev>; Wed, 12 Apr 2023 11:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1681323396; x=1683915396;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I6yK3C0YkeZPBasWtG0thFawQkYVzEsDsJhqcXXdP/0=;
        b=asSjimKN/i2Aszfl+ZnzPLkjjLIEZFj2RTSZfhLN7EuVnH8kgQHSPy/dGBXt3SMCCJ
         OcD0MDUdzIn6eRR71ZpWS0IiVjRaqKrSaG2/JN4d0UaUrD0LLr6SMOEpmrKGAgLoRAJg
         n1bf7v+40xJPo3sU6a+tLBlXAmhWd4WKy7s5Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681323396; x=1683915396;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I6yK3C0YkeZPBasWtG0thFawQkYVzEsDsJhqcXXdP/0=;
        b=Se+25l/bLRYEDDksWmvp/jcT95/Vt+MkjNeo4W36LPlu44H3iI5VQ6WlbZSjDLXTkC
         Vmg4Hec5ijimdEDjVFotUnaqZI7DFOlHI/IEqR3csgYZUHBhNJ/cAXDbLV7lFhlgf6Br
         h0zRS6NOn8WARkRkWD0mjnc6TIEKvmGmzOuZjaIdqnZZEPOKBc/1kgYxHVw4RXORC1MC
         6tZjyl5ZvQzyoJX2i8ivUHbmYXLuIHLmfkLHtKni/v3GhSaJPaUgJgpHk2OKXaNQw+hG
         XKB9n9YouZjAbNMlRgAsTGa5ikg9L9vpVa7wJ7L7CStEtIuy9FyjpNEaU/2S1Kokr0jP
         UlUQ==
X-Gm-Message-State: AAQBX9d0TAkHb/lN35f5XPi+U5edqpCv5xtOOJBeNdLJw9bWGWBfs3Xw
	2kEJ3wDoTCx/99DgxHkU7ZO3Cg==
X-Google-Smtp-Source: AKy350ZJnxb7/erOSQdKo3r6KSUFa1vRi2QvZAo8RaoLpq83BtLcR47FPLfDgR2lZKwIHgI0isCeQg==
X-Received: by 2002:aca:bd05:0:b0:38c:696:c99f with SMTP id n5-20020acabd05000000b0038c0696c99fmr633352oif.16.1681323396147;
        Wed, 12 Apr 2023 11:16:36 -0700 (PDT)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id e9-20020a9d5609000000b006a32eb9e0dfsm6675982oti.67.2023.04.12.11.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 11:16:35 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 12 Apr 2023 13:16:34 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/173] 6.2.11-rc1 review
Message-ID: <ZDb1gtPI2dje3Qv3@fedora64.linuxtx.org>
References: <20230412082838.125271466@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>

On Wed, Apr 12, 2023 at 10:32:06AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.11 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 Apr 2023 08:28:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.11-rc1.gz
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
