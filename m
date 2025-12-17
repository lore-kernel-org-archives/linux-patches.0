Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFD8350D43
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 11:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765970998; cv=none; b=jQp1jj4fAyUYh2shKSPx6YhdQbxZtlPjQtocMXO0CGCDxjpqYwTnjpsWY0hFMxc6QH8fmHpu+vMAYCBjHib0kKND5T65q4X2jfXjVVD9DcXIzGo2ieV1J5RBTLQZ90a0xLUDeLRWRv2wftXOXXa1GNMlJwfE8gWkDhUvcjCDpNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765970998; c=relaxed/simple;
	bh=+eORQnfNHkjJr6Xg2rWitskVn7+r5m0p1og7dg3w4bc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jB6IO2WmrrpL+Tw4agR9fIVIUDCEaDR/Te5QHVdh5Fbg4kjjtCoQ9wHJkZfFHEXn5xEv/xXyZehvMpLELXiv2mjih1vR/X+51hO5F92b+IgzDNHyAVNKeAH+QUTqkDjN+jFrLLB3iyjE2JbqwjxHCjza7TbFKWSVLADOgNSkOYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=X3bx/k03; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="X3bx/k03"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7baf61be569so6719417b3a.3
        for <patches@lists.linux.dev>; Wed, 17 Dec 2025 03:29:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1765970996; x=1766575796; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V/bisjBvmzi/1keCLo+ftK1ux8Pzt0W77oVsy9zZJxE=;
        b=X3bx/k03IKddFq6/FbsHwibb+/tGizjbgV3esBr81Jjdwb+wceaUCDnxBJhkFDl8bC
         Mi8+Vf6Lrmix/eU4iQqUtfIJP0RX8hz0aMLIHiYjRE+FnVP7NNoYy+ZGycsgbWqJil3J
         hFYvPwCxOnl0hvhdkxRyTPB1Dg0jU8eBLIFa5PA4mbCW/oYo3zf5SFjwHkTFkfcKkjwI
         7L+W4wPEz+kc1FbneEVLclW0/B6TBor6hqV7+z7J/X+kYetydAKjBa9nwzZPStznL2cy
         JNPAQpjgJii6/j4WirAb0gKAPe19kew25qNCRwuzgU1rO3U3q2sIGLh3wlXUmTUX64/V
         BPKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765970997; x=1766575797;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V/bisjBvmzi/1keCLo+ftK1ux8Pzt0W77oVsy9zZJxE=;
        b=dpmC5mUNBoJDY71Kx/rY+UnnRMUKHrVeUKZV66Oo0Q7zZxy64HBhKMzukOChMxztVZ
         mHfn1ahw3hsdU0EXTi7boonIaBBKxn9WWanLihiWVaW+choCcao7LZXl23G6fbVbH9wo
         OkTvY1DiLGeXFSWX8GHJK0C9LelwdCk2vV7nxFpFpwFfl+tshWNsYY1AFvD5xxlu9vHK
         dyR6PPQEp+mOMB/SY28gmTuT/+HZhS80xwDHJ1u7f1FtllgDvZgjp+0tw1GVeUTkVKuw
         cvJWUfdNs40NpW8bhqkW97ZZ9TU02ZCpNbMKYSK5r4utzvOFDKHigtSBi50b+R9a2GHO
         Zjtw==
X-Forwarded-Encrypted: i=1; AJvYcCUwOTDo5pyI59U5DzhiVHO8vmZ+PKBM29ozKO2Jpey08IYTxT+/XOGC0iESHSsqcMHMaZqBpW+M@lists.linux.dev
X-Gm-Message-State: AOJu0YypsailhgAqv8Hg4X/EM0hyR/KdXpQ6tuRgusyDRYQg21+BuwFP
	F3C9AuSM4bq2Gx6uhdPMUXgBYWwTDzF6g9hlslDosdwouXeb0qXA9y0c/WgyJ1PPzXYeir7yPI3
	icPa7vQi1V095IebS9JwnmrzuV0HHfzfotQszTU59iw==
X-Gm-Gg: AY/fxX7UhHFERkul6mlDKOjpriNvauVfsjx11SSc+1xd8kRTEqLtFOErItYEuf5WmVw
	bRA/QqnXke4SYM6SbCKJKrjhjBCnzvyIZeOcdY44QQMXezN7rDRX4fTB8ITKiZWHEelkhRr6OZ7
	dnyAJNNSBAcUEZXhi/0NRBUvwnHRNZz9e19timRyU73+sI66nEY/4n+++KtNgl6C/T8zjPRLt+l
	yU/1A58io24JHGKMdgFCca0wYdOcMLgoV4iPBZDth1QPXqxCWpIYGjXLr6xWNpVzAg1pZZL
X-Google-Smtp-Source: AGHT+IG9P67VgmuMOXLvK3GgX/2Zc+rw7osjUXxUy22ujhVRSbgY3iniAtS3kk2B4eaDG4h3v8T9DTPeaAN8joiuMaw=
X-Received: by 2002:a05:7022:f511:b0:11b:9386:a3c3 with SMTP id
 a92af1059eb24-11f34c395a3mr11192278c88.46.1765970996468; Wed, 17 Dec 2025
 03:29:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251216111401.280873349@linuxfoundation.org>
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 17 Dec 2025 20:29:39 +0900
X-Gm-Features: AQt7F2pf2_9_E_Ow300D-yxZEM9q8XXfC7h-VNZnJ61nSNkFexdW4YoCWiUN3HM
Message-ID: <CAKL4bV664OmkNuNqTZTKMjwYUBNSZRxQMM=wuwdFZJEPSVUNVQ@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/614] 6.18.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Tue, Dec 16, 2025 at 9:53=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.2 release.
> There are 614 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Dec 2025 11:12:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.18.2-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.18.2-rc1rv-g103c79e44ce7
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20251112, GNU ld (GNU
Binutils) 2.45.1) #1 SMP PREEMPT_DYNAMIC Wed Dec 17 19:51:45 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
