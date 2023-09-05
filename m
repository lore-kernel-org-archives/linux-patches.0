Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B377DA38
	for <patches@lists.linux.dev>; Tue,  5 Sep 2023 09:38:40 +0000 (UTC)
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-31977ace1c8so2031489f8f.1
        for <patches@lists.linux.dev>; Tue, 05 Sep 2023 02:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693906719; x=1694511519; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5YWqYpOjejr1s3ck7UjoKhIuDCJZwI6o2HKvOQT7nAA=;
        b=og9kTrUsqIcNHCQjEKJz489V+6HA8/0681UqOlqcXt8Sw4z7EDsv2rpXLZoNSz0IIo
         jI2akkeiqHUQBM3NXPgYg8BLPbKYJO++0lAMo7X6dTFoE08fFWcXrS+dK4YqCv1iTDk1
         t+X9V8Xf2KV5chwm9tQslIpB7bwV34nZvUCSRPl8xIylVRbQ4Hm5JLjn7x1x9jta6q4N
         Y3ZIYyc30olMqAwarrnGsCRQP/U0KOSM/ev6f360qJnEvtxx+OgE9gMpnOsEZelxm9cx
         EFSgFCH9xpburozCSNOrvlJVybKNz8H0JYCmJ0/GcJH1Ju0STdUcrFP2SlnDKaRpumjR
         0WYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693906719; x=1694511519;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5YWqYpOjejr1s3ck7UjoKhIuDCJZwI6o2HKvOQT7nAA=;
        b=bZTXP91Wl7tNNXBsFCK6I4qFmr+8XDykmVnn2b7ZoXrI1ZpDNjPttsryXMAUTWCJmG
         H7KJYOxeU1/8SjkRIg3U7npbG8xMuZ7miIKAkIh9q+HCPFyzhXpo/diu9k/ZsVr/tAP+
         t1fFx9xzydBVGFUGQlz3lorsD6aSmznszhf2EWEWUSAkGWTGFHQdA4bg8iekQxxlyF39
         sdOx40rHhFoy0KtNampXtjT4VGVkIm5lf/XCtSpnc9rDj17rjIl/dP7kiJQwq17KPwUz
         bgR/ipPTw22F0TjJWXFJBtz/PUHI7Jqcjdss+M+XFo+DZH7rNSWqBlhhjPF2GoRqZzni
         XPOA==
X-Gm-Message-State: AOJu0YyjPIzV2gOWkaTeMOz18OuaqeCVbla9VYs9B6CNAtJpi0W7i2fQ
	pIOiOfjQIA90EAKBvlrS344=
X-Google-Smtp-Source: AGHT+IE2wZOjcVFoM9PsqHK1B8bLhtoW705WXFzXq05pi2XmB6vFZniKw69cfoSvxGWmMcwph+PH0w==
X-Received: by 2002:adf:de0e:0:b0:319:7c1f:8dae with SMTP id b14-20020adfde0e000000b003197c1f8daemr9628315wrm.3.1693906718063;
        Tue, 05 Sep 2023 02:38:38 -0700 (PDT)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id m18-20020a056000181200b00317f29ad113sm16819997wrh.32.2023.09.05.02.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Sep 2023 02:38:37 -0700 (PDT)
Date: Tue, 5 Sep 2023 10:38:35 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 00/31] 6.1.52-rc1 review
Message-ID: <ZPb3G4Pi0C2pCCrn@debian>
References: <20230904182946.999390199@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230904182946.999390199@linuxfoundation.org>

Hi Greg,

On Mon, Sep 04, 2023 at 07:30:08PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.52 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Build test (gcc version 12.3.1 20230829):
mips: 52 configs -> no failure
arm: 100 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/4936
[2]. https://openqa.qa.codethink.co.uk/tests/4952
[3]. https://openqa.qa.codethink.co.uk/tests/4951

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
