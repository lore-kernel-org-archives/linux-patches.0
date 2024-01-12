Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D707F1846
	for <patches@lists.linux.dev>; Fri, 12 Jan 2024 03:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=sladewatkins.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-78315243c11so416920085a.3
        for <patches@lists.linux.dev>; Thu, 11 Jan 2024 19:20:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705029646; x=1705634446;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JjSZW8FnU+OrzwsALUbbUaF+dnHxygb6H1sJlT6LvIE=;
        b=K47cVuTDPuyOeKiYMifPwYPHJlx24PodzMIEgxOQuwLE/NxgzB/tiOpr7Y9aVUBoCB
         pTrvBS8u4f30Hx2Znhl/fwCzfKSI7Ywxj7zZH/qbCvk4OdQyw2SmwkJI4IcN/iftSdy3
         9G6TQOtP2taRsI0QZysuj4Mzvwam9RE2GEUxg5p7Pkxy33rfWuJRjBoQpz/+88LX7bPa
         fHv+PZ60AhfTVae1zFRxEhdUxA1zYLlgKD38On6Qtqa85NK9t7MRxRuyzf/Uv2+b6mgS
         UnGmrlSi5c1QocJq3zmg5Cl73qtfuZoToYgBM+oow/Qiv426gbZnnsddpOjBF3CR/0z2
         YtCg==
X-Gm-Message-State: AOJu0YyNGADOo6uN8WyZCaaOJtCfuX2Skk8ZFmzFGTFF6oL5QkI6vVwg
	F2YRtW51VPHa/hzi94nP0vs=
X-Google-Smtp-Source: AGHT+IE+IjGMHZFRTO2SsMQm57qvjPv4hTZEK4rGOiUbRXGOPUCiSpYiymbpFBky4s8Qucq7uOeIHA==
X-Received: by 2002:a05:6214:2aa1:b0:681:304d:6712 with SMTP id js1-20020a0562142aa100b00681304d6712mr275862qvb.77.1705029645689;
        Thu, 11 Jan 2024 19:20:45 -0800 (PST)
Received: from smtpclient.apple (pool-108-4-150-17.albyny.fios.verizon.net. [108.4.150.17])
        by smtp.gmail.com with ESMTPSA id t18-20020a05621405d200b006810a0ebf24sm759708qvz.33.2024.01.11.19.20.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jan 2024 19:20:45 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.300.61.1.2\))
Subject: Re: [PATCH 5.10 0/7] 5.10.207-rc1 review
From: Slade Watkins <srw@sladewatkins.net>
In-Reply-To: <20240111094700.222742213@linuxfoundation.org>
Date: Thu, 11 Jan 2024 22:20:43 -0500
Cc: stable@vger.kernel.org,
 patches@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org,
 akpm@linux-foundation.org,
 linux@roeck-us.net,
 shuah@kernel.org,
 patches@kernelci.org,
 lkft-triage@lists.linaro.org,
 pavel@denx.de,
 jonathanh@nvidia.com,
 f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de,
 conor@kernel.org,
 allen.lkml@gmail.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <D11BBDBD-C19A-428F-B459-95B0761EDC16@sladewatkins.net>
References: <20240111094700.222742213@linuxfoundation.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3774.300.61.1.2)


> On Jan 11, 2024, at 4:52=E2=80=AFAM, Greg Kroah-Hartman =
<gregkh@linuxfoundation.org> wrote:
>=20
> This is the start of the stable review cycle for the 5.10.207 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, =
please
> let me know.
>=20
> Responses should be made by Sat, 13 Jan 2024 09:46:53 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> =
https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.207-=
rc1.gz
> or in the git tree and branch at:
> =
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git =
linux-5.10.y
> and the diffstat can be found below.

Hi,
5.10.207-rc1 compiled and booted just fine on x86_64, no errors or =
regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net =
<mailto:srw@sladewatkins.net>>

Best,
Slade=
