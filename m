Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D026514658D
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 11:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736249804; cv=none; b=S5YL9L+1hp1HqxyFwGdfVHSXShnlKWJ6uC/WM0iGgJ77nojj7Q2/3kM948eqeskbiIRHnRaF0/oqp3T+w8IRv9ofLYnLQfK/ECzm68JgBQvVr9sln10Jff6LmoIMI2lB2VHCvYmnVOpMlMo37WIasAWfXWRSKuw2Z7M82xVyk6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736249804; c=relaxed/simple;
	bh=Y9BesMiV9uMCy3y/CTJ8dLA38nejyMoFaiNgq7Tq74A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XFvIbq2pjgAHECF0AvbuW/cZuPJ7UvoOs1BPgvEiGJDKbThgjWf8PlijhLwD+nXsAlx6WvDfMgPJaulVGI58w0N9W4w5IXhkbb1HBM99N168GwVtJQrIikMcEcqtB2U3Npp1A3hDtl7VtIMlIf8SYyNi0qAJvPQ8B4r8AFw5b3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=3VP/WBki; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="3VP/WBki"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2ee786b3277so16659779a91.1
        for <patches@lists.linux.dev>; Tue, 07 Jan 2025 03:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1736249801; x=1736854601; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HezLHe4o9o/F1dzK4dU9Wz6o3ClQ7CI2rKrB29RoRCA=;
        b=3VP/WBkioL1bngC/Uik/ifvHRgS3OkwYKvn9N7zOwZ06ltXZvRO/Qdgleew1Fff6Pk
         rjig5QHHiWWNc+cZzT0XqoOdQoxTPcRNtpaTQtwcqnC951mAaGckBcvDj6g+TAXgPG75
         fcPW/lprL2GTKqDEs3syJadG+esHpGvOTcsbNkya8kz9S/W6A2W7Co48lfwPQdldOaP3
         4V7LK42SDfpToWbBZqy95r+rohAqSKExQ5wI7RUqJECwCHGOQ+VQuU4U0TnaBDDkByKv
         nBoMFe2oWc0+PUiC4DSOwZTeQPt4E7rG+RH0Fe0PBQdVO4ViRMisZYIh94vs82U188JW
         xPRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736249801; x=1736854601;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HezLHe4o9o/F1dzK4dU9Wz6o3ClQ7CI2rKrB29RoRCA=;
        b=HxaQgXH0x/YiZgbRcY48tNhiY0Ob6FRdzbtXL1GqsZJq0fPY+KEuMME18cvMAP8YnM
         eHH9Mx4fobma3vuA+HmUPtrtNym1CR1JQcRlht0iLR91rzDPC4oKMZcQWaGquwCe2cWX
         GHcyo1QmDmhhSPZJ/vk901H5D9Vi1cwJ4GptFofSMUyZHMigcLKgZDdUsnR+i7SPzFqY
         eeJiVdAuuvj+8j7+dSUbwfNDfFk0T0hGPVG9A4U4ukeLT99PF+BVYt74ybLyWjgSLpc0
         CWc63QiZpjTmspL3rSTttBbaS5Kv2F88dZnJYjvCA8rNumzS9NtzvpcCiLPFwavZeMBk
         xlMQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3jx+MARGFnyYWRcGfr74EKSMzLo43gbn/j87Su97HNsiH5AhLQTxS+87ZMrx1Jf/Pgy9gAWgO@lists.linux.dev
X-Gm-Message-State: AOJu0YxrwlpLkbIK1NECaRw0xsnFGCHfvoD36EA+O1xeRomDUAfGgewH
	NbrgBfFTL0vbvoFL0vXdjjAzZRuiGCWx7OomIMQtDhbJbFqkl2c89dXQC9raHDqFcAGyEupk7uY
	rFZM6vziTGG1xgjQd7rWDGa8CobiwOT45Xpg56Q==
X-Gm-Gg: ASbGnctruo53ZSXxhemriiQ+h55sAEzZXbVmTrzJeuoj+kgcIpDRYA/JW68wZnLyM+d
	X8x2O+vLtIvyQeESxy8DbPOZBYg2PerddeoIN
X-Google-Smtp-Source: AGHT+IEpYwKsbS+mCPDKNQglIw0fFMHrX0/2J4U1AUgg44SrAqTO7vSYUXvw4K7xW0AF8enbL06mVLQWtquxJUldXJM=
X-Received: by 2002:a17:90a:d88d:b0:2ee:863e:9ffc with SMTP id
 98e67ed59e1d1-2f452e4ace5mr80833760a91.21.1736249801195; Tue, 07 Jan 2025
 03:36:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250106151141.738050441@linuxfoundation.org>
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 7 Jan 2025 20:36:30 +0900
Message-ID: <CAKL4bV730JK+vXvpd0jqWfEPtN-tZAfud3F62ONvp48J9Bqxjw@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/156] 6.12.9-rc1 review
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

On Tue, Jan 7, 2025 at 12:34=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.9 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.12.9-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.12.9-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20240910, GNU ld (GNU
Binutils) 2.43.0) #1 SMP PREEMPT_DYNAMIC Tue Jan  7 19:51:46 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
