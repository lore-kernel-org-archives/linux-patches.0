Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705DE134CA
	for <patches@lists.linux.dev>; Sun, 14 Jan 2024 22:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=sladewatkins.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-781753f52afso636676885a.2
        for <patches@lists.linux.dev>; Sun, 14 Jan 2024 14:01:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705269678; x=1705874478;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZruNkfd9PVNgfFD6iIT+fQvo//foIvGP7J1NcC9VQ38=;
        b=u2qI01vwhP8jpZYRB/c59V6+kiFSdu4Jo/4GfQwdLTYAm4SSKLnTnoNAFXJb0slWr1
         wdfcNQWz6npCpda95UYPGSCOzUAekiusRHpdtP09yaYF4lVbmhV9LljzIoNThLReXzig
         L5rcH0Ovr4Pv9kuF4CUaN86EL5kmj+7scZBUINFN4MW+yllvps5THibvA8R1vydWGyaJ
         E0WychCWJrPLvnKt1nLnwcCSvHb3w8tEY3y0tEi8BAsctfHdtBQBz1zEH59m/FxmVwZx
         M8c/gfEN9WQgJYPjafd5TGCw+21uozFHcdx3ze6lNMMN+E1rCWR1K+BQva+KBfqobqIS
         QJGQ==
X-Gm-Message-State: AOJu0Yx3ZVM3bX4xxf22GAvI2ukuDmsa5tQR2Aa8rPbPIe0v93Q4zlVD
	MFEOCAOdOMUvtMUfbyzo1o4=
X-Google-Smtp-Source: AGHT+IGa7WwA2XLOKz2kFhSdEKxOhayRlscu6wgBOozx6WXEd5kfph7zONqrTT8rB+szFpLDcqdI1Q==
X-Received: by 2002:a05:620a:126d:b0:783:1e4c:b5e3 with SMTP id b13-20020a05620a126d00b007831e4cb5e3mr5452147qkl.88.1705269678399;
        Sun, 14 Jan 2024 14:01:18 -0800 (PST)
Received: from smtpclient.apple (pool-108-4-150-17.albyny.fios.verizon.net. [108.4.150.17])
        by smtp.gmail.com with ESMTPSA id a6-20020a05620a124600b0078327d52206sm2509717qkl.63.2024.01.14.14.01.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Jan 2024 14:01:18 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.300.61.1.2\))
Subject: Re: [PATCH 6.1 0/4] 6.1.73-rc1 review
From: Slade Watkins <srw@sladewatkins.net>
In-Reply-To: <20240113094204.017594027@linuxfoundation.org>
Date: Sun, 14 Jan 2024 17:01:16 -0500
Cc: stable@vger.kernel.org,
 patches@lists.linux.dev,
 LKML <linux-kernel@vger.kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Guenter Roeck <linux@roeck-us.net>,
 shuah@kernel.org,
 patches@kernelci.org,
 lkft-triage@lists.linaro.org,
 Pavel Machek <pavel@denx.de>,
 Jon Hunter <jonathanh@nvidia.com>,
 Florian Fainelli <f.fainelli@gmail.com>,
 Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
 rwarsow@gmx.de,
 conor@kernel.org,
 allen.lkml@gmail.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <6DDB9D3E-357A-4151-AF8B-2B71C38744AA@sladewatkins.net>
References: <20240113094204.017594027@linuxfoundation.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3774.300.61.1.2)


> On Jan 13, 2024, at 4:50=E2=80=AFAM, Greg Kroah-Hartman =
<gregkh@linuxfoundation.org> wrote:
>=20
> This is the start of the stable review cycle for the 6.1.73 release.
> There are 4 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, =
please
> let me know.
>=20
> Responses should be made by Mon, 15 Jan 2024 09:41:55 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> =
https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.73-rc=
1.gz
> or in the git tree and branch at:
> =
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git =
linux-6.1.y
> and the diffstat can be found below.

Hi,
6.1.73-rc1 compiled and booted just fine on x86_64, no errors or =
regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

Best,
Slade=
