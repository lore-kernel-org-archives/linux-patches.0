Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F2123F417
	for <patches@lists.linux.dev>; Sun,  7 Jun 2026 14:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780840807; cv=pass; b=uDOp+LI7z4WAevjQHoCPwusyAxFg12oJS7NscR+C5teB0p7m9L+Glp+2kz7r9yzD+kTFiPKZ4uEPWIFOmNLUmKwI2Qd/dAlmIn0ARIUxBz5Mt/ehiEonYU5ByiX1xDlhimROL3Ayx2eFUiis70VcEXxutO2JsOGNRLhg66uxItU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780840807; c=relaxed/simple;
	bh=FFaZCZCI1aLwrKSfB/eohEPXsMJlsUISmfq99wdbCHk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LQ1S0wzmJ1OFBZ1/hTN07Eoj/h0Fn21R021zXa2mpKY+sElcL0KxG54rcXxSM2Zgy2L8B1qddHcYEs3uLWC6fbGdZkUXmCRgg3FYitJwE0YtwadshciAQ8GVh6FwZ6F6dE2mrRbbSKlxI3oybz9gjTUaf5u/xu1PxkYueCCk5SQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=DtZ60w7a; arc=pass smtp.client-ip=74.125.82.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="DtZ60w7a"
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-1363fe80fe8so4970460c88.0
        for <patches@lists.linux.dev>; Sun, 07 Jun 2026 07:00:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780840805; cv=none;
        d=google.com; s=arc-20240605;
        b=forMRyP8wq8gqCd23nfJ0PIPmVp+4Z3L9nNUyV1i+FUV6v7i4muQxQp/1NaIrAmRuo
         vyPaba89q2knjPO9skE239bwHcIvosMdn7jWpp9xuY0rASnfXVpvOuG8t4G7JTv1ch7u
         Gfcsm4kD8n7tPadoz+/KBcEj0GLxUZ1ZVu6gzNOib+YuDkTiiKBWrFfSwsyvIce+9aqp
         UkYgZc8B/BpUxqcSe3u/vGRDA8xAfcYZeaUtguVj7IRriKJ3L89IjaHmaGYlvK30puIZ
         mck/EckyrLLYw4ebCF1yxCpsfF8BJCkPF5/5tb/CuiSJGp6TpH2qqvhTbEUXjTUNvUtX
         EOJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RkQeYfFIuOUrnCngJydWaqMe29Hx6hUsX++EJF0iQCc=;
        fh=6nN+KbQsxWGzqFtnHWXsqwPqZIi5x7WfprYgibiR1BI=;
        b=f8V3iFQj9fTmCaYKfjdDVeevzj5mzlHMPYQVl+3xS355LxvfF80Mwr80z1G8Oyo2cM
         uQiwPSrsJUHwSQPEPDeyPcq3Xfq9e3gXRhGOcRMKt78uRzpKyS4smwnMgZSaLKhmMPjG
         c5e0db0AEZ45mdsLGMWlytqz34tYz0mx18BRpCqcwIyfRZ3qldeVKF1n1FpFxYl0i1IL
         2FEZg9hbWnAy3d1KTyuxmgtEfg1P14uV4W8hRDrbWRvDvKWnGv0uR97kP2C4JTa5yKuo
         q+g6CHZG+UafLfK0jI+2quhCqVqcl7VE4Dm8xzZ5V6LQz5sBluq8O1yc/yNNyjYT2BYh
         KLBg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1780840805; x=1781445605; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RkQeYfFIuOUrnCngJydWaqMe29Hx6hUsX++EJF0iQCc=;
        b=DtZ60w7avkjG8btpDSDPeptK7IpqT0m+KJrLkw0AIUNuoUOnSDApYVIjA3MchZAZXr
         B8XkARnEYgMaYB/gIaovNBugBtEz+NmfOVmkJBa+X3elypA4hcpTcneSAYzOOqcZtbJ3
         0S1T4b038CNRtIlF12Nq3GartPGBLQPMqsGSR59OS14M8rSpzWzAXojte8xX79C5HVKG
         cxxVz8u150cgZgyA/ImAcU+2Qv3J4idqzBhTFIDQsIoDMeMUtZiCzCERapuAEXUYvq5k
         UdAIOssTfn5ar5MDodwFx8nPsSnMUDdyot3YAhsfjoBuo8EvOATbssrhHj4b+gUo6IV2
         4S4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780840805; x=1781445605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RkQeYfFIuOUrnCngJydWaqMe29Hx6hUsX++EJF0iQCc=;
        b=Xk2XsEor0sPDpGG75fHjC2a0ycgkPlgnxyxPZKvHQxJFxVZxeFmqIGuP2n5nDAXOAY
         ntVH4beMK9DR2PHVqGRNvauYQIkrex0t1/Oz/YjfDplRlUE3Ef4GscaDz1E0MnS/5PG9
         Z9gavKWoDPhriBEndBvzHtTjwPf1HAegOda9JlREF4LDQytrGPK9vTfHeuqruHtZRMKb
         u2Ghmq5sEqnMF+GkBXJrPDagK8m6FdIQrUCeKpibDGzZ317ErWUUmsXkB5llNKpb6KNw
         JiA2W+cTQlwS7pPFu2mDXIxExy2oEcQJGP/woIyCK+eDUGkMU9X+rHyiJKGkQqxU1OFa
         b1Kw==
X-Forwarded-Encrypted: i=1; AFNElJ//2e/9JVBSJjciddcYUyvcoczNzqbVq/tKTaLwNoDQZN6sqFzmpbLvqUkzL8VSgmS/bqiBoZ4V@lists.linux.dev
X-Gm-Message-State: AOJu0Yybec+mK9FGdwshEf8cA4Yx5+fF3OxiQRrHyWBEEHXPwcviRqtT
	4oENzvSZlbI7ZFiJLqf1dFJcMpjDGMdQi33Muo7HPN+L+Va+xZ6a6ILFPIq6k/jrheQ+oUEJcWu
	k6+2WZDttBhT6zQbELNHSYO27QA8kJ/dFr4AAKe5SYA==
X-Gm-Gg: Acq92OEvZ2rJh63Ng6YuMoKIyXgQRLM8zDIKVdBV2/0fbQ1GF13Nf60MhXrCu7JPjZU
	myF+ja0LAaNLBzhFQ/3musGOKob5Lq2N9tn+Cd0srIHXZzzXBNNenQMN4u57NCcSIgrv7wUgpEi
	LY8bVkVq9M1sezE8CMA3TmhvcX5FacUNcwLUvIhnk2yxQ8yY8BOJlX98PWBB8BEO3bBinAwauNl
	g+aVdHDKuGWfAi9DKDcfZsC0umKno3nhYnOmkyWbhZMzhLgIkrNg3xYKjTsuL7HsqtF2hCDMIUh
	fDaGARU+iMBKpOd+VGA=
X-Received: by 2002:a05:7022:1e11:b0:138:12fa:378d with SMTP id
 a92af1059eb24-13812fa38ddmr4360570c88.22.1780840805119; Sun, 07 Jun 2026
 07:00:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260607095728.031258202@linuxfoundation.org>
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sun, 7 Jun 2026 22:59:47 +0900
X-Gm-Features: AVVi8Cd2KuRVPwE0_H31aM_kSW1Og_JUoZOaOfYaAHe7xAiu1CLPvdl7yB5cjr0
Message-ID: <CAKL4bV7=32jD92C9yJ2d40Z3dnWLC3zZt2b_74JExDsu0SJovQ@mail.gmail.com>
Subject: Re: [PATCH 7.0 000/332] 7.0.12-rc1 review
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

On Sun, Jun 7, 2026 at 7:03=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.0.12 release.
> There are 332 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 09 Jun 2026 09:56:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.0.12-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Linux version 7.0.12-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.0.12-rc1rv-g877a01113f80
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.1.1 20260430, GNU ld (GNU
Binutils) 2.46.0) #1 SMP PREEMPT_DYNAMIC Sun Jun  7 21:38:28 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
