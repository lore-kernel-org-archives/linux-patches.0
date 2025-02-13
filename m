Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87ED24168A
	for <patches@lists.linux.dev>; Thu, 13 Feb 2025 20:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739479979; cv=none; b=Bwq8QIncHQixF9UuR0njB3s31FHMzdDYUSZDzCPTiGLY4Y0AGSZfR6eKWO+AacHHhG7Wg9AgGTr2HsH4fGpXXjqtQ0te3qa0JHlT3GJj/cRaGGYxDdSgNFoenMQGWPo6Fl0E3KJdor/kmQnDV+UQ5lEYRjJUZXUizQrtYAk3e6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739479979; c=relaxed/simple;
	bh=YQfOmSG7bhXwrXEI7g7HfGozQsPSZTjYO8leaGIMmsI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZbfBRRmhCOZEl6VGgrX+EilDrJHwy0EG1m8GXZ8+bFW8ukO+TYbeA02+UCIrd3AecWUMxn9+Z0sRgFC0h4JLoekieOGyk1TZA0gyrxzsCkCQn7Jh7dh+ZroDJGJtH84DAElHS+pVKCfYain4+mNDvlwWK68uZRIH/vynOf94LnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=x1yHjgBQ; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="x1yHjgBQ"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-220e6028214so13677085ad.0
        for <patches@lists.linux.dev>; Thu, 13 Feb 2025 12:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1739479976; x=1740084776; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kD4jlIA09LlCQfIugtat8U7n/Mwu0d3vsRXd4yayRgQ=;
        b=x1yHjgBQ0Vynrvdk+Ub1GxMPA1cBpv83kRy/0W87llJmSE6OMibxYWtYYzcdaFs9kh
         YrOjNDwXhU6LegbdgsXCs6t3zxQkJ0AtPxofdhjgCDI/aKi1kVhfiB0uCjpQvdFwh7MQ
         doKU2Kl+Ycv5uf0xcn2VZvCgIYG0v+s9Kbrgz6T7zJodDAmL05z5u1PeZKmWVKDXepT0
         4YwQoheTDWm21rNlVch4CCX6WZDgjr2INvRtUm2fTCI4KFAWHbkWctCLMS/NlyBcjedB
         1heVJBx6xUuwoUbEmVeqgv4PlUMV1AZ6S5BcLvc/XgPd1q5RvL/DmsWBj2Bd78c2ZgEM
         mOvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739479976; x=1740084776;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kD4jlIA09LlCQfIugtat8U7n/Mwu0d3vsRXd4yayRgQ=;
        b=QvILexluh0pWtI/HpCcZ5VXueafidnFlfvW2+CT9F8VHEyhSAMEZvNr1XqrMYlLXrV
         MJ7l+bbUT8CjGZ+JV7MtmRWjy+gON87+wL+ooRxay6Q2mC/NcLSn0FsKGsAi39Db6/9U
         VMLoHHWBqRCHKZ4cGNYlxIydMsbHSsw8cP4OzMN9KPDt2U339uBCPTCdoJHq6PGAeKWT
         F9fioBEHcXr8WlFsGJi3mbpQR//dhUbyZumIpar9DDC2MdR0P7mQBTLknbugi5RKBVJo
         SGE2rGm0vBx1ixH/lE3YyzdeBG2qTF1tKHe+91s+dq5+M3V8g7X3rTbjN8TLKeOrsoQa
         Odwg==
X-Forwarded-Encrypted: i=1; AJvYcCXqLVgkHFZTHd2vq0HyowpzGmTa9hb8CKvO7zHwQbit3aL/IKaSUetqIQbK2G/xpY72I9nSIV2t@lists.linux.dev
X-Gm-Message-State: AOJu0YzFA+lqQaq/kstXM6QzCOUq8CyheZKZ/5Xm8LHNzsO89jh1Ak9X
	+bUn8y3p7qP18Ft4VFk69Bj+pQDLnJDw0lmbQhAzeRdGFWkRkDOAxsAw+ipF+bJT+VYjJ67pD4T
	4KEVX4oXyAOpy6fyEE1hiFlSKJC0LldyiSQp30A==
X-Gm-Gg: ASbGncv+V0ZOIZB2FtZF4nj80jLxsC+/29JjJmRwFSYLiT3v48JG/9coJ42u9DOUtpr
	97+dBFQwnxz90bvs31EWfDQ/WWbC3MbrbR877ajIUs9q6T9vPt7W/BApohCrKNnG0uaegyQQ=
X-Google-Smtp-Source: AGHT+IHjzHdPOUuygC6NBlatxleab1j3jR6rTUbN05uLgsUD63sYvsqWUeg/8xCBEvwpGmkWUxZGnEHEHJM5LlFEhYs=
X-Received: by 2002:a17:902:d483:b0:220:e9ac:e746 with SMTP id
 d9443c01a7336-220e9ace872mr19612115ad.53.1739479975905; Thu, 13 Feb 2025
 12:52:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250213142440.609878115@linuxfoundation.org>
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 14 Feb 2025 05:52:44 +0900
X-Gm-Features: AWEUYZnADGWAsmbaFXOyq0Ts9-qFL2MZJjpcjwmTCjML1qk57OFJC9AtigNj_Sg
Message-ID: <CAKL4bV58AGyft6AA5j5CV=Fvm+uX_czSmSu8a=sgdQqYygBjbw@mail.gmail.com>
Subject: Re: [PATCH 6.13 000/443] 6.13.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Fri, Feb 14, 2025 at 12:07=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.13.3 release.
> There are 443 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 15 Feb 2025 14:23:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.13.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.13.3-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.13.3-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20250207, GNU ld (GNU
Binutils) 2.44) #1 SMP PREEMPT_DYNAMIC Fri Feb 14 05:08:38 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
