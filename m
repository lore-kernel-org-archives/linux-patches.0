Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378AA10F6
	for <patches@lists.linux.dev>; Thu,  1 Dec 2022 16:48:06 +0000 (UTC)
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-142b72a728fso2759040fac.9
        for <patches@lists.linux.dev>; Thu, 01 Dec 2022 08:48:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0KbdoDEh91rw5IA0oIsvOgRB+4YOafY3auigAzlBBag=;
        b=EPKhZXBMmm+34M/64/xV6xZhG1xerm6CGLwtaXkeLtWtvyX4Sy34w1/6qhuA/VHkWP
         erNVVD7FNH5nVwQWwgAaZo/yWktEnLq4byDjsHYTLXKEeqYRBPqZwEpbEQayuA0QaW9T
         71tpa5Wvugjjjx9WGptYLDh48ffcFalHTyoDQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0KbdoDEh91rw5IA0oIsvOgRB+4YOafY3auigAzlBBag=;
        b=yAUbG+ouKu1G089eD6VkSjkOKhwB/fQyqgzDRv0wV8phajfW2a0TGEF7KKyQt6k1Y8
         t+tLrnCKBsCZtTD/J/l7FH7sbO6gQUUdXpiC1JQeY+gtHWP6l4kAL6oA9LTYFIVrhbeP
         KtTsUfLJN+EX/i8CKWlBVwoBBF4AcNcsxNfBUoMHK6BymsRigJQT5PxygAHJwK0CrzdU
         sxl1ckk4qyW9d591QZdchgFWkGM4OPBXsWeOwhCnVjQjYiJUYDTK11ZdgOOaWWqrP+un
         qhhh5cWqwQ/YZ5GOfjHsNZmlAedMagEUqgQBTixNCqGwk7yQqzZs3Vzd+VUHNDRzsb0v
         b8Uw==
X-Gm-Message-State: ANoB5plI/EHM5hbasoKBiaz1zmNIXvtf4XFaGs6+MX/xGh3I3hHjCjP2
	qd3n9/sCunwlXL3sh3tWzqVi8A==
X-Google-Smtp-Source: AA0mqf4/fo9us4v8SKKvRbiImh/8ffy6lzShfRTPXNemoNig9f5abIkulCSItNfCwIzXRSrqETSytg==
X-Received: by 2002:a05:6870:41c2:b0:13c:12cf:174a with SMTP id z2-20020a05687041c200b0013c12cf174amr27094701oac.197.1669913286025;
        Thu, 01 Dec 2022 08:48:06 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id h9-20020a4a9409000000b0049f9731ae1esm1923473ooi.41.2022.12.01.08.48.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 08:48:05 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Thu, 1 Dec 2022 10:48:04 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/289] 6.0.11-rc1 review
Message-ID: <Y4jaxBOj1p6Dw+xX@fedora64.linuxtx.org>
References: <20221130180544.105550592@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>

On Wed, Nov 30, 2022 at 07:19:45PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.11 release.
> There are 289 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Dec 2022 18:05:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
