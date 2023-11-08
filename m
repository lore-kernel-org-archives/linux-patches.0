Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0939E1366
	for <patches@lists.linux.dev>; Wed,  8 Nov 2023 03:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jCK81mkL"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2806cbd43b8so5874321a91.3
        for <patches@lists.linux.dev>; Tue, 07 Nov 2023 19:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699414071; x=1700018871; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4ytmubGM6iA/R2uJJz2HTFch2ZXC0QBgruER0JS6cWI=;
        b=jCK81mkLq1y85hRV9Z58eRLaM/nNLG46KU5PA9GjGJkJFdcoqekHPqNIHlsxA4o76V
         ytOTLAsGD0nYJ15qVvbQbMGMGE8DcZkmifK6Y4AVRt2Wi3GHQEyNMvIj6W2WAOm/Z7es
         bImahspaDXpmcMyEQ5APimF7vQvIilo5gm88pYCDxz5XP4+mQEA7sPdHusCnrytrWn4W
         KJytSjDSpZG8p11eSYKWlg0kMAPMJtb13n8TstwRhwC+2+9lIXOe7zy//a0G62AgBo5t
         89+1TKLEXc4nm+4/x9a9IIj5pydKY/DOmgIgWNnk3X6stXeibsPTaShbFZUKLdoWq0lt
         iYGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699414071; x=1700018871;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4ytmubGM6iA/R2uJJz2HTFch2ZXC0QBgruER0JS6cWI=;
        b=PG3Ga9Wp5seFGD7EB7Pfa/SkjETgfY6iOf9KQGQT11HMLQRxNjP5sM86BOw8G2FHLL
         WW5XEVX5XSGa62VWk11iTQB8fzkgMlGkjc7qS5b+2TipXU+WM8STb1pAQrAwKPGYscYB
         dlujV/Yq9ZwXe7MBIkUpPMiquIrOfLR+kmFqNZf1F+EQeXFEDAXQOsi/dWncHivZuPsG
         1FSaoNJeqa9ODTM/L20COcYNrvGIrA2WIh6hr4kJgJ1ppV7C5n0i6R1/NfyECsmUxgX6
         p891MemEN6+pWQInlfrA3O2v0DC3Jmc1YndhyUuSX7nuufNBR9qdfSYTpKq/jlNxuwrl
         DP+g==
X-Gm-Message-State: AOJu0YzD3r5sbo9I6FxysHfVAoLX1XNuy5ALiykdN/2JoYmsoIa+6Plt
	fpbapZ+/ofIHu7WawBjaC0cCCwz0QtduFOnTtJI=
X-Google-Smtp-Source: AGHT+IH0ycX/rFIiW7psOnLdpKmm4wBQ4UWCo+PapZP6FLibO8CLA+H0S1Iy1s833hKLD2acI38/Cj6EHcAVj6yMjzI=
X-Received: by 2002:a17:90b:1b07:b0:27f:f1fa:b448 with SMTP id
 nu7-20020a17090b1b0700b0027ff1fab448mr653426pjb.11.1699414071202; Tue, 07 Nov
 2023 19:27:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231107202324.434534294@linuxfoundation.org>
In-Reply-To: <20231107202324.434534294@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 7 Nov 2023 19:27:40 -0800
Message-ID: <CAJq+SaCKgbQYL27m+msagHhsH4eJ9P9aDDA_uaj2of2d=V99HA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/125] 5.15.138-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.138 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 09 Nov 2023 20:22:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.138-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
