Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840452F27
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 15:28:28 +0000 (UTC)
Received: by mail-qv1-f54.google.com with SMTP id o17so21758481qvn.4
        for <patches@lists.linux.dev>; Thu, 05 Jan 2023 07:28:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=to:cc:message-id:subject:date:mime-version:from
         :content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FldW873lpxyZUgJl3Gn79d3ABr7Mbt6BQFXBgqMjN4g=;
        b=A9jOz6sfESY2vupB9VK1hFQayWSwN4Qz+KE9Y18HeXt7i8p6Y8Cd7k1QSsdF37MG2W
         tVe+pgFJx3dvSajHVCLPLsDuHqe3Mq6nECeZAB63VaK1A/Fr87YZTG2T73i4VPYHaWwd
         vKJv0h+o0sJSdIdqCqyYqQBYN3SEc9ycLVhlc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:cc:message-id:subject:date:mime-version:from
         :content-transfer-encoding:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FldW873lpxyZUgJl3Gn79d3ABr7Mbt6BQFXBgqMjN4g=;
        b=AnMwyKVsQciMfThJZTJZMrgtrjh/YzY8i+5Ih3ik/0fOeCLfkrjzRtzeWtLJXKBJ+f
         mmPpOl6BxN8DzHR3+fXtwJ8HFy7dAtLGP3uwu8VfoE0vODQTsXUm/toT85J1SXQAYKJ1
         Y8u99CV28n7v+IRw5ceuTLIhEAS7E5uRwhWTNOzzLY0bBBfijtsmfeaFxBMMBFKjF8Er
         pJHl2UHalZEUuSVkrOth+vfVDVZulhAE3VxUR/fsyOhfxRaDdE8e20B8750dQMj3DZ6u
         gdoBkHn1BwIpVewKhw4B+GNYTbwVk+yN6nUFl4C28jOr0mYfixCE54CPDX/NURgQm8cb
         lM1g==
X-Gm-Message-State: AFqh2kqVM/591CKQdlWg9BggbnktkZMrNhJrX/YHO5F028PWrEo46afU
	2DPveW8dUddjCHfoI8pUjQ8aQg==
X-Google-Smtp-Source: AMrXdXvO4YAvMAf5z7gOFCnlfp3u0UaOR58PNp7Q7w0C5P/uXexZOlrDC5oKmltFky47DWvSYZasiQ==
X-Received: by 2002:a0c:c783:0:b0:531:c27b:8ab3 with SMTP id k3-20020a0cc783000000b00531c27b8ab3mr21415196qvj.41.1672932507387;
        Thu, 05 Jan 2023 07:28:27 -0800 (PST)
Received: from smtpclient.apple (c-98-249-43-138.hsd1.va.comcast.net. [98.249.43.138])
        by smtp.gmail.com with ESMTPSA id v2-20020a05620a440200b006fed2788751sm26290698qkp.76.2023.01.05.07.28.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Jan 2023 07:28:26 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Joel Fernandes <joel@joelfernandes.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (1.0)
Date: Thu, 5 Jan 2023 10:28:15 -0500
Subject: Re: [PATCH 5.10 00/63] 5.10.162-rc1 review
Message-Id: <214361C4-9FE1-426D-9C54-9EF332604ABE@joelfernandes.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: iPhone Mail (20B101)



> On Jan 5, 2023, at 6:43 AM, Greg Kroah-Hartman <gregkh@linuxfoundation.org=
> wrote:
>=20
> =EF=BB=BFOn Wed, Jan 04, 2023 at 04:56:31PM -0500, Joel Fernandes wrote:
>>=20
>>=20
>>>> On Jan 4, 2023, at 12:29 AM, Greg Kroah-Hartman <gregkh@linuxfoundation=
.org> wrote:
>>>=20
>>> =EF=BB=BFOn Tue, Jan 03, 2023 at 04:16:07PM +0000, Joel Fernandes wrote:=

>>>>> On Tue, Jan 03, 2023 at 09:13:30AM +0100, Greg Kroah-Hartman wrote:
>>>>> This is the start of the stable review cycle for the 5.10.162 release.=

>>>>> There are 63 patches in this series, all will be posted as a response
>>>>> to this one.  If anyone has any issues with these being applied, pleas=
e
>>>>> let me know.
>>>>>=20
>>>>> Responses should be made by Thu, 05 Jan 2023 08:12:47 +0000.
>>>>> Anything received after that time might be too late.
>>>>>=20
>>>>> The whole patch series can be found in one patch at:
>>>>>   https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1=
0.162-rc1.gz
>>>>> or in the git tree and branch at:
>>>>>   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc=
.git linux-5.10.y
>>>>> and the diffstat can be found below.
>>>>>=20
>>>>> thanks,
>>>>=20
>>>> Testing fails. Could you please pick these 2 up?
>>>> https://lore.kernel.org/r/20221230153215.1333921-1-joel@joelfernandes.o=
rg
>>>> https://lore.kernel.org/all/20221230153215.1333921-2-joel@joelfernandes=
.org/
>>>=20
>>> That is not a regression from 5.10.161, right?
>>=20
>> Yes it is not.
>>=20
>>> This release is only for
>>> the io_uring stuff to make sure that backport was done correctly.
>>>=20
>>> The current "to apply" queue for the stable trees is very large right
>>> now due to everyone waiting to get tiny things into -rc1 instead of
>>> before then, so the above two are still not yet queued up, sorry.
>>=20
>> Sure not a problem, I can resend again later if it is still not queued.
>=20
> You should have already received the email notices saying they were
> queued :)

I happen to take messages from Skynet with a grain of salt ;-).

But thank you for the automated notification!

 - Joel=20



