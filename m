Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E730396B7F
	for <patches@lists.linux.dev>; Fri, 13 Mar 2026 14:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773411086; cv=pass; b=BWccvpjKQ5aTv3lwW0u0cIvQpKOjhxeJPzEHUxNS64Cfjf7RMIOz0ZUcHD+2s7VKpmQZFZydf7YEjt0hGu42IPozFEvh2OsGtcR49/lTAhrYkiyFrNp1w69qMofo5UILF/6kT1jaAbL1tAy44mkxCwNPS78Ukw7bfRTOFOgJWqA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773411086; c=relaxed/simple;
	bh=tN8aEbL+UMUREEvHUigQI8zy0u5JmgzO+oNlqeBYNaA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=utS5lQxiUWkH2vhARYeBHxHIFqmsLm46VN2kjxRELNDUHFDZSDiyQFeeSOBSzHCWOIO9J491xKZlcvGknZaPRDuWRhhI3jCXOGNAC6HcEPOqGtqBsLh01S1nQN/DlS8NwvxXvXYmUnGCQhVRrI4Zp8gAWwvkrVIfbF6wc2q1+wI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=oROPQ9g7; arc=pass smtp.client-ip=74.125.82.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="oROPQ9g7"
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-128e4d0cc48so2555313c88.1
        for <patches@lists.linux.dev>; Fri, 13 Mar 2026 07:11:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773411084; cv=none;
        d=google.com; s=arc-20240605;
        b=dd8JtMTOFP1mkfPmrF9+91kDHBzJMk+Hlw7kimsD6MKYrszbT1+T+KeFlO+b0F2O9G
         v+Yd2YI+zqSrYKWEAn/70gKIvgI5mUvmmwsZalM3ps9HFECSAx17CyS9dGXX08TBG77I
         b95LI+/mCymtVNVtuMEfHXLVxSOSOZ6DG+Y9JeLbQnWb3kLZJFvFZ12Re6NTv97c1PXk
         DE6Frs9xqOW9eWv0/qndgZY/vtsuKJ0VNPXhKwYntpsqvDZgRXIgeu5nH1ewC1dJFhl+
         1/33I2FWFKFKhZT/d11Pr6XyVQf3oa/i6v90GIQF7LXO/qPICC2aFC5wUIxEob20tru/
         B9jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=y7631mooJHh1Ik/whGkGMVn1GYzZTs9RVCbxYIh21Nw=;
        fh=IwuXf0+o/FD6mGvQ9VNC9LYajUaVnGZkB+CqNK6qzvI=;
        b=AzpQ5cId3C5AHu5vs7QKjPvWfBLFIt/TkIuGNiqCI1I/QoyDJR5WExastmdBeMoYZ1
         rf1yx+Kpe0ggqfZG2kDoqc4eBq7uLs9Ph1XflAFMjGqgyTYg09n2QMWbQwvNDD5/+bv2
         vJgFhytdDebP6G9r3kZLLbQwbJQ7Zj5/2oLPbd+3LDutjsyKpaZQQfmKsc4n1YUcLkfU
         YOlYV4Ty6TLwZRHrMODOVNTrUe/cn0yCejpOjboYu0vEVG8wO48IqnLEuLBTAkgAhEyI
         Uj9h+3v5Z4vrzfBXQ6bcbPWuIMf/Us5nNUlTlfAP5UTXgCn5Zxn9eD0dkd6kEJk6HHOa
         s/Yg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1773411084; x=1774015884; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y7631mooJHh1Ik/whGkGMVn1GYzZTs9RVCbxYIh21Nw=;
        b=oROPQ9g7dBuT7qnXrpn+m3/xsFDHg2qhO6zN1KxQEzMiJzCB26HUDh0oUvQmaLaVzF
         w6cTMdltcLIlo2AtVWQmpj/AnGA0IdxIKdW4wH2qHhgKdu8IL8WBNyREOH5U6lThU+/F
         QBHkDBlV2CPbHfJc5gNpN/nBwMIMbMsD0aJOGG5hRoDT7AZZeSW7LuV6hqQZQS1FHacL
         QEYEWpZg06Ylc2zKSpYpOThavHo47wTOYcfcltZH354BxsqF/AGzJ4AwCQOvDETKN2XK
         VoDVemHv+mApWMDjE7DeNCc+Wry6RJsSLxtnPkj3ITCBd2ARceYZAzDBxxWX5lgKoIpK
         ot+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773411084; x=1774015884;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y7631mooJHh1Ik/whGkGMVn1GYzZTs9RVCbxYIh21Nw=;
        b=E1TrW6KSGMKJOkrW1FDChndPMsdT6gIjkNAX7zI/r2HmNO+DxWcDMsI7wTHIaFxVS3
         BDX2/nRwbGYY2yE8j75Q8mTRTxIe+5sCnCvPSlXbrUg+s916r8P4XBVVquTVq+Mr1Mgb
         Bbeq38OniXIefODSGkdPArevUy1WiTPRTv3RpTptTD/ZdUhWkH4dGLl0fOXxlgYQzRKr
         C5ncbLoZwO+cNROIavGh2hPRzQImU8TdXma0qaeth83vUt3MJmg0CSP8A+ngPI7G/xZE
         HumJWnIO9aPf5bPW995GBYO3+wEmBVe9HI6SsyauIgTy5mW9XDQQ8xQDHGoXdBQ09yy1
         V+uA==
X-Forwarded-Encrypted: i=1; AJvYcCWImIVojEVIg5bbxDFhTNZbYfwrcV82YN/HHWlib07+f4tnmRIQOO5m/H0sKyxCSYzUfFWz8JXC@lists.linux.dev
X-Gm-Message-State: AOJu0Yw8r5pgslJ6km2YsxTJ0tECKY0b4IA65XowpwSbOFzfo+O5RnY1
	x+YKs9zhYwbx3vfXjPCUR9p/stQdONTUxvIFZFOL3wKrIIdmDVzcD4WITG0xIHOu9SXmrCnt386
	qCJcA3h/AODSMT35K3I0/ni0cdwHErxfXDuEFZsNHEQ==
X-Gm-Gg: ATEYQzy442piC9HGArfqbaT6CpxTdWOCo/rXGirO2MvblyUnKAVU7/TNXydIwCoqCoW
	8F3eBxe9jD/qiZ9NrYlitSv2ekmN4fMRFH22ozzNSTeG8zkloNziIORo6FYv5/HYGDV04BoQ5Zw
	xJKbuhOaxcufgOv7ItzaVT8uG3DXg9l1KnB+l8HA1/VxCrBI9XwiiB4wCA61CEVlaMl9Rdho+qs
	7l2Ut0SuUHMtKQvSd88qN2NA08XbmongySbwJtETQA8BKMBhDi7Qx3v33bnMm/QwvDimt4ECfZX
	r3C9iJy1
X-Received: by 2002:a05:7022:fa3:b0:127:3b1e:7e0e with SMTP id
 a92af1059eb24-128f3dd362emr1472980c88.20.1773411083882; Fri, 13 Mar 2026
 07:11:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260312200321.671986598@linuxfoundation.org>
In-Reply-To: <20260312200321.671986598@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 13 Mar 2026 23:11:07 +0900
X-Gm-Features: AaiRm52A4WufwfZhX19dCMjL0VALRJ77y2dPNt6g8sh1ImlYHg03JDPx6Mznoyw
Message-ID: <CAKL4bV66vAW5hVOg0UPiSNLYse_Nt_kon61QXsF8U5KrTL3gXQ@mail.gmail.com>
Subject: Re: [PATCH 6.19 00/13] 6.19.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Fri, Mar 13, 2026 at 5:06=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.19.8 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 13 Mar 2026 20:03:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.19.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.19.8-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.19.8-rc1rv-gc1996363ec4b
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20260209, GNU ld (GNU
Binutils) 2.46) #1 SMP PREEMPT_DYNAMIC Fri Mar 13 22:20:12 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
