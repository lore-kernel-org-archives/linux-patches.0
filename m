Received: from mail-ej2-f43.google.com (mail-ej2-f43.google.com [74.125.228.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6E7444708
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 11:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790250680; cv=pass; b=G91PkF6mez9Ua7GebnYoRdEyET+5neNrSdmWZCeuta/pufaC+En9pqWR2tis7EHEFruMHoKrngC1noUrRFbLEpBvV/gdlbltZ24Bpp96zVLwrU4E3VWgweoKf0qFeocZ/0fesFXsFRLon7VwxILCaGJ2OFP3ecpORDuq8cfA1ic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790250680; c=relaxed/simple;
	bh=beqzQKKjoxSVK9Ait4o2AWQYoYHmh36alBr6u7mmw2I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C5RLLijg0sZQLTTfMxV0Z60qyyeC0ivyQU6yueYb1eMgOpP0kWJgR+qSwdyU47IuZGRa/0oxMgzn3CEksNM6sYS5jmTykTXiZQLfiyiGJyyKhQstNIuoXSIjNZ6+95uGiL2Y6js092FlcLNDgbxfNGlSph49VkrEYTcvTeKWwI4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=xpOV51fA; arc=pass smtp.client-ip=74.125.228.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="xpOV51fA"
Received: by mail-ej2-f43.google.com with SMTP id a640c23a62f3a-c254f55efe5so316885966b.2
        for <patches@lists.linux.dev>; Thu, 24 Sep 2026 04:51:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790250676; cv=none;
        d=google.com; s=arc-20260327;
        b=A2bygeJKY5MLNdkUK/Wg1jwQoXCMIKGwFHgsNBJ6BrglXc1vNflTUG/K63jG7aV+Ff
         0LhGp5K1TITHMfLo+D5Y2NGJRp1Qxg3n3lvbigM3PYYTXV1V9HxO2oHf98ZoT7KbbggA
         VLWhRXIGN3xDMlGy9lOcDqruRCUTgXNvLz9QtTTzt9OUGtjMPiA4cuvBdq0m5BxWNUpW
         6ayOuDJybwkNJ2roPuZ2x1t9DVVLvo4iiRdA1VUl48R2OOz0ssYJR2JMn8hOUJ8W7KKP
         jifeVqSSUXFtmH9tSNWVKvuxGcQ7BGCT6u6OvN1yn4lJuI18rQKhTf1ntOJpsxJ6DpVo
         dnZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=omFqe/7YRCaMs7Y6/oYqn8ZEqPS++HtW5gJ+iDHObDM=;
        fh=c88K/ogOwHM1NuqgTkqi3IwCjWwo5OTBzYomSQVMeKE=;
        b=sW4J1TJ2KAvTfabvVXzIaQwa+iYO7RHl+uSvEtApZxEJ7mSBWgAaT8E9GKjUfEHp3d
         mqThrs3t0DV5TUK8iB+Ycl0I084Z3WhfYuRqp1kzsJ9e6Kktu6/+W+8bo5OrNT7O/Mhc
         BHvUjaFbZfv1jZGpXl7JdzH+3TOmTeptNrokx6UPFzM2OiENdLQerrFmcxeymJlK4wkS
         C+hUiqtQlxGfqFjPiSHhpPNK2i1uf8k+7lIRQwqJNNYClrkYZ8QDXFWSBgHGBGfToW0V
         77UXAoAhNdAxcGY3ZtIQ0sBX0C92LhfrBvA8YBETmjEZ1qQoB9/W1tz3YWqAp7b2UOQr
         XQ+A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1790250676; x=1790855476; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=omFqe/7YRCaMs7Y6/oYqn8ZEqPS++HtW5gJ+iDHObDM=;
        b=xpOV51fA5lPrhTC3N/IurYAFCwRI916RtoQhq3G3G4/uebM6U9FyLJ1zD7RheTydHY
         1p/OH/XvyA44IQMlYvT4P418VGY5jEbfl6P45OT4hds2xvpSSxUCNlia0HIabWCv8tj8
         ocIaSNRHRndS8JDR6eBSaGUel160i87t1JPSocLkiFkbUjuWwYHUkwArH9N7vKPDq27c
         Jp1C2ECYMuMxqA3BLwZjAn7+24Wwbfj26rblvj3dNYLkpD0OyFc5aX6PhjouWSWKbJtj
         aDfPue5cBTwDSahsIlqAbp+Z2zD4nkgczkXSGc9HfJIxOU3tasXCxxX3CRykHpHH7tfn
         YFIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790250676; x=1790855476;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=omFqe/7YRCaMs7Y6/oYqn8ZEqPS++HtW5gJ+iDHObDM=;
        b=fpx+6p8LJFd4ylXmTIfqWWnVMlgoXTGmwcagLq/rAPopWQAJTijuv2ivAqSxPzFlDU
         uzdGVtCTeZ0bn43Yutf0agvRndie3I99teC0OFfoyOLVrNSVsHsWYb7ikJaz0J3SOfLh
         QGiUZmStECmYCfBragXlmO3FLzCutEiSwe87u2ZUMCOqxZ+VFjPM3RlYUhJ3mRdE7KLn
         EUjhmQGud1xhKZjNFE1Z9jemVzRfWsVfsRPnbZ6OBOZpL0JwZuWpGWCyYGDbYJ9EmdmM
         1+6pWVk/Ui4EYiLu6hNZNiCQ8YGoDH9zwJ/0NpcJzlELJs+vC4CCyUcs9UlxJa86NAae
         3zpA==
X-Forwarded-Encrypted: i=1; AKwUvBzSBQkSpwGbzr4ehTGBPUX2/rFFOguvZyjJztFVc6DRHic2MgkdFhHQqUcjN/IQWfdLv07BSPaB@lists.linux.dev
X-Gm-Message-State: AFuF++ntfTitd7TOj9PHVMuqemtSltvcjgpUbs/TRFggiTb2w60LakC6
	uuDD/ADHPVRahUnuKY/ins7qtLBZf2yFHDfXk3JREOK964p/ReGPQrHjbJQu3xLJiVYLO4GO8n3
	2DGKO16RkAkTVD0+186M6PXQ/qSD0Ppk9KIITUiaI0Q==
X-Gm-Gg: AYBFou1bz/Zk2B2iD8Ej3OGE5qBYZQ0FDfS3WsKBduNFui0/8lnKi0ltR2FzsZySb5y
	uLGtzB4Y5xVjFMpEVIlSviIePZdTtlN1kvNeZjEFb7V/4tV24FtLQSNVVKS/O1XysQaKdZQ2Sre
	dR12tSPzC6gjoISDy8OCQNa8FL2WN8y3BVJGza7zQ/kRUUm7ABA8dQx73EOsVep3bF8zGG53fDH
	H2MraVSoTUnzCSjfZH3lgF12USrMHXsZlIRmTVDcHIi5HwgzEY7pyGyu0n2F5az3BnxDqdJgZhA
	ECKXAr0PWdSRJhTmJtV84FNbt9bEbaLyJLPyxfdEhb+GoUH03HFmVCRm
X-Received: by 2002:a17:907:97cb:b0:c25:6230:dfcd with SMTP id
 a640c23a62f3a-c2ac239eb52mr194296566b.15.1790250675739; Thu, 24 Sep 2026
 04:51:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260923140644.756254324@linuxfoundation.org>
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 24 Sep 2026 20:50:58 +0900
X-Gm-Features: AclHuK-Phr3WDpb7SshIHOAYwI2RYTxswDPC0MCmKsbJLi96tShPIIuezgDdacA
Message-ID: <CAKL4bV7H-9F-JEM2ohs3G6GyC5Gi-C2sb0wJdixuObcE-bSuCQ@mail.gmail.com>
Subject: Re: [PATCH 7.2 000/438] 7.2.8-rc1 review
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

On Thu, Sep 24, 2026 at 12:19=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.2.8 release.
> There are 438 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 25 Sep 2026 14:05:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.2.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Linux version 7.2.8-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.2.8-rc1rv-g54e8ef17140e
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.2.1 20260810, GNU ld (GNU
Binutils) 2.47) #1 SMP PREEMPT_DYNAMIC Thu Sep 24 19:15:39 JST 2026

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
