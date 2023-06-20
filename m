Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348CA125C7
	for <patches@lists.linux.dev>; Tue, 20 Jun 2023 11:34:45 +0000 (UTC)
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-307d58b3efbso3619622f8f.0
        for <patches@lists.linux.dev>; Tue, 20 Jun 2023 04:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687260883; x=1689852883;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wNmsRYXp3LiMqLeElIlXoDkwLqAfcZRTSlTeIqHQMaw=;
        b=gwnNn5B6lVlUbAXTwAt+yfhy6qCOBy+QHoiWSvoijiW/fbPhfoQRhGpjlvbMJn8Quv
         Ol04JoXSx/BhqgeHX4cg4sXvYowweqDffc7xTIBt4nq3STc98+gZBAO8pDgRkMfRIUtQ
         CpBcqDpji77J/OEb8gfe1Q0NEZ0Ne136da7BUtnq3Tmk1LwNnKf4lOwwjZwdVNgy3J6s
         Y5e7LKaQggLU0sEFyMjgIQ4wEVVjBW8y3LCAXyafOg5rcUKto7lYRo9qIRE7R3LdGF0f
         jqY3T+U2gNjW0ZxFPXJ3YzITFh+rTm/gNWtdN9Q/USlC0jAcisPoq49h+r5DY5QbGp9k
         J/oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687260883; x=1689852883;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wNmsRYXp3LiMqLeElIlXoDkwLqAfcZRTSlTeIqHQMaw=;
        b=eg+ctL0fGbb3MwBAJVrhgd4Fwd2cypXSCQVmOLCO14OEfKT8ETeSgaTfPQ3K3bzSir
         ZMiCnnN8clPlCUKHhNnspd1gZ8AM7qCLaoRbwqx+DU0eWKUMFeTDhPrlLOrVYTfGziDi
         nI2PtjvB9ehG35b1OvW6JNT9+N65Rop6sDlcrX2SBwkQnSdrFW3IQ3V5epo50Tik+CuB
         apo/jk/EHILIpk9VPEnjE5S8eIdp3VEzSyl6cPEvcWIM71vfFstmJHUnD4wCCLQ2+15z
         SApRHBPn5fMD6KuQ8BLEjZfvWjqyDPxTi2c8hALRmPxRAbHOG8lYFpQvc6caA30SHx9m
         RhlA==
X-Gm-Message-State: AC+VfDwtjWGB1M4XFp/D4/4ldNmQUJBF4F6DHGHLpKjsvi2qethRvYKd
	erB0qTQGYIWtZrpMX0Ob1hA=
X-Google-Smtp-Source: ACHHUZ7FRsTITb47OtP9ObIFUmd0XF8iyk78I8fpCv07AssJh1O0cUuctFjrufZYXNKwsEQuA04d/A==
X-Received: by 2002:a5d:6289:0:b0:311:ac3:909f with SMTP id k9-20020a5d6289000000b003110ac3909fmr8263127wru.56.1687260883200;
        Tue, 20 Jun 2023 04:34:43 -0700 (PDT)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id i14-20020a5d558e000000b0030ab5ebefa8sm1795944wrv.46.2023.06.20.04.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 04:34:42 -0700 (PDT)
Date: Tue, 20 Jun 2023 12:34:40 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/107] 5.15.118-rc1 review
Message-ID: <ZJGO0LTm9Fu4lNc1@debian>
References: <20230619102141.541044823@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619102141.541044823@linuxfoundation.org>

Hi Greg,

On Mon, Jun 19, 2023 at 12:29:44PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.118 release.
> There are 107 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Build test (gcc version 12.2.1 20230511):
mips: 62 configs -> no failure
arm: 99 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/4074
[2]. https://openqa.qa.codethink.co.uk/tests/4072
[3]. https://openqa.qa.codethink.co.uk/tests/4070

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
