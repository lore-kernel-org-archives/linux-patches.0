Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9607015FCE7
	for <patches@lists.linux.dev>; Tue, 25 Jun 2024 13:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719323396; cv=none; b=lqZJCmOD8irtC6jYwYEIMfxUNXGrqaNPf+ywUHowg+m9rhtkpc7kgSm2K1TjYCErnDRYM0O185FGq/pc/JIu29BSSfCu+YQG3+Ue6NleDo27MKmjZSzQalThgi3CoeR6xNv+fzYkHWvUj1yKAvFFmFRHeyhiTMz4uyW57tXIcFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719323396; c=relaxed/simple;
	bh=tNpmJll1ksRucbPOf2rcRJYDxSakaOfmTze6fQEjAgA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Sg9y6cldYButj9qC06h9FiFZ5/Its5xRFjB4h99YE3+BgHqmntlzA5FJ7cKNtJ0t49qiVYKEQVU34ZauLFr2hlRCI157wiCdSbI4yR9DdydeMgcHyRZfEvKgSXqTGrn601eg0ZLewykrALY7pcPmtaUDGCvOir2Eut/Rn06sDVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=n+dfg+S6; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="n+dfg+S6"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7066463c841so2364926b3a.1
        for <patches@lists.linux.dev>; Tue, 25 Jun 2024 06:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1719323394; x=1719928194; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iOSzHtQDPIiUgYObK0O0Y6dDs3viZenud8mWqn+tO/Q=;
        b=n+dfg+S6Q42Qb3q/oMJUBc8jx/qUqfu2NrCd+imn+jwmL3O/IS4MaUgW78rilZCxvs
         rDsu7PR7u6R5pQjk3ZHTaSGcUhV/vDi4N2QA0zFTj8C/Ss0+MobqhwCzr77rjrFU8vkL
         lftM9SDz121lturjkWZrt1ZhwOo0wf+IAAoSiR9DLT4Vg5h4fZP/AVQBx+czjnYIcNBy
         Y6jP1fFDAG+MMYHEvJYmtH7j0H+M43ceC7M6tvgJ1qUCJgcWrdr3Q8EVBhihq43BO1X7
         CHJz2YdYYdhpbYeF7Hz+uziRdct1Wy5VmHnAP5k2cVR4+peyxbEI45VwjIgJd9R/85W2
         xyqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719323394; x=1719928194;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iOSzHtQDPIiUgYObK0O0Y6dDs3viZenud8mWqn+tO/Q=;
        b=CeS0cy98symeQATdPPZ0GpV53SXMw94u2SzSRj7QextH66QWQKL0f3C1gjlPpDu5Zk
         w8uoQSEagEkvg5kfkp02vWd3Bi4ml9CXgl/ideGPcTU6aMXHejY5g7c9uNWs49D1+aiY
         712/mMt3JiokMODxCyoYftKq17ARNvBPN2DT9R5HoEeuct4MGTwF6kznFJsT1NvT5LzM
         iAhUZX2tGC04DMBZBSGcKyeGU1FLfeSt9CamLlMzPxTBy8GpBCGA4wEVkFODyIUYbO9w
         D415iBk0l0Hg9rzZbKsxfrHQCMB517n73905XKZWlgWkzqGwPfEnLT3DauvJfm2ippH6
         NA6Q==
X-Forwarded-Encrypted: i=1; AJvYcCV83plQtlzFNFhi+maCtUBUkR1rgC79gUgKCEHrzX27upt872m1Rjk0cbCG1y0xhEM2SEbHgDmsltWIERO25l3zr++sX+I4Gg==
X-Gm-Message-State: AOJu0YxJzh/0prxpzfV4QCp0g9CpaqwWdnzM1vQaoB8nAAsyON7RK650
	4wVMBIZnpSDOSKmoZFEgfijcChmmNg+jmJGbtW5hoaWEZ1gPrmwZyZJ2Inn+kjsxW0me0SOstjo
	yIi4O/8+K+WfyLrSTWROkwQ3hkH1SKXPHafq9yA==
X-Google-Smtp-Source: AGHT+IGukD7TL3VnIYSpdkVTf7oscbbD9B5o5/mEmcwIqPw5v7kMi+nq1AdyXTdqfXIEtbPOWU+LNjeL9LhM1XFoVoE=
X-Received: by 2002:a05:6a20:ba83:b0:1b0:2af5:f183 with SMTP id
 adf61e73a8af0-1bcf7e7ecd5mr6106084637.23.1719323393891; Tue, 25 Jun 2024
 06:49:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240625085537.150087723@linuxfoundation.org>
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 25 Jun 2024 22:49:43 +0900
Message-ID: <CAKL4bV708-YcfyLcuWSUSPS+aDa_Aas-F3JKY739MSVUzWFqxw@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/192] 6.6.36-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Tue, Jun 25, 2024 at 6:48=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.36 release.
> There are 192 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Jun 2024 08:54:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.36-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.36-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.36-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.1.1 20240522, GNU ld (GNU
Binutils) 2.42.0) #1 SMP PREEMPT_DYNAMIC Tue Jun 25 22:19:34 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
