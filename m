Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838157348B
	for <patches@lists.linux.dev>; Mon, 18 Dec 2023 21:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="mXbIUjT8"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-53fbf2c42bfso2872131a12.3
        for <patches@lists.linux.dev>; Mon, 18 Dec 2023 13:06:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1702933588; x=1703538388; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=36mhB37dzwFYxTc31wi9sEgexn00u1r64ISHaWciqdQ=;
        b=mXbIUjT8477yTLle2g1sTeYAs+jL2RSvKkUoVTVza9g4UWVtU/iJFwZ4h0kyb070x2
         9FdcUQS8d0Ij2P0sSN48sIHS+K9AFOQf65oSm80QiTVwI+45ZjFnzjrJV6qbFc6oFh7n
         wdfWyHbMHCTJkAqAqB2dfMNJ59V7/CQ8hyocHLRD+1BbAI0rgJPgcHmPUhkcIvwwNIBJ
         h2U0WWaDhJWuWi9EnoDsh0rU6uiHAhc4NIOF0WHkovLREkZPe7B3PgIAAIvfeZ6Mbm8u
         0WaBKjceWhIWpkLDA4ggN3C90Rj9GsvrfXmI9PxeQc414MwHl+3mDU1XWH+O8zu71gWn
         mkqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702933588; x=1703538388;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=36mhB37dzwFYxTc31wi9sEgexn00u1r64ISHaWciqdQ=;
        b=q8KTjr3HTqLjCBoUqiijS9lwVStIoUExqTFTK/S2UBDXmhMR8e/Sl1z268oLfCE2dp
         lJb/h1nHFV+qfocfRa8iNjxj8PYZ4LyzA0csS+PXUcCuO4jXnB4+eIZvVD/2ZCOb8TTW
         zmatW+52HxmlHpbTRELa5J8z+ajmsyDwQ9tXTmO+yazgFiWLabXGlWZRWESWBONbiWFR
         hCyxrmD2dp5pD/NMbOnCnGlaHGScOFBLx+TrD5PbuPw2iUDO3wcqz/4DSN2PrktRqjIY
         1IFE5Oz/Aob6n6uF/WRN1RvSA+yv21Lolm20Fh5V82yxbnTwXb1hU2lZ70j9yUlxQnir
         cqKw==
X-Gm-Message-State: AOJu0Yz8LcCuveayI4KdBvwYMieTPmqOLKFmvSrn4XGO/wn7MJrrPov9
	Olkt080pUIFLKqKWVDMJGqCzn/ZHAXLgr7amfOxzZA==
X-Google-Smtp-Source: AGHT+IFFWWsdRy/k0ymydJWK4zCUV+/JpG5DWtGZvqI5npFftIQI+RFLb8pwXUDFXBX91JKoBQDgehNmTjwj65jWClo=
X-Received: by 2002:a17:90a:e50:b0:286:964d:c with SMTP id p16-20020a17090a0e5000b00286964d000cmr11000939pja.86.1702933587789;
 Mon, 18 Dec 2023 13:06:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231218135104.927894164@linuxfoundation.org>
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 19 Dec 2023 06:06:16 +0900
Message-ID: <CAKL4bV5_vptGgsAC4NAYUhr-cknLTwiyR2z8JsvUwoDvmxKy2g@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/166] 6.6.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Mon, Dec 18, 2023 at 11:03=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.8 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 20 Dec 2023 13:50:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.6.8-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.8-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 13.2.1 20230801, GNU ld (GNU
Binutils) 2.41.0) #1 SMP PREEMPT_DYNAMIC Tue Dec 19 05:38:30 JST 2023

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
