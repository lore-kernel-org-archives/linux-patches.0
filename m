Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316E14C96
	for <patches@lists.linux.dev>; Tue, 13 May 2025 06:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747117524; cv=none; b=JBoBEH43F0ef0EDUJT8u/SZuE7oAJyuTyyAxAO62zI/T0GVGxMujytyJzijPI1Xg02TZA+/EsCSaxdvbQSfIpOaP/K2zWrPpm1QHobTxlYkiGyR1PW6GrnvLR/R7aeDQBtgSNGVMdkxp16NCAGMCBtnmkFIbraMFTpyYwiJx0KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747117524; c=relaxed/simple;
	bh=AHumA6Yr6/pS8vAr/ck3sCQM3vY1g7wA8pe6gTh3RMg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RBoOO1pB0zanq3TXZ7mkJO2Psybm8KWk89ag7hLuezonhrG1IgstDuBbKIIi3Jps2HxVs86X7zBtu0/P3Uo+PxJN1GuwZMwz0vsssUPgml4LvOsUzbS70qSSw5rA0x8leX2hurpcvQJ01VqoAQzoc2UUDND/EATy4WI46T3iuNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ay80UCzG; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ay80UCzG"
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-605f7d3215cso2623959eaf.0
        for <patches@lists.linux.dev>; Mon, 12 May 2025 23:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747117521; x=1747722321; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+d7AiXMLoB/R6GaZCR9iO4bJ1gIgBKIWJfItI2aaeUM=;
        b=Ay80UCzG9l76keId1PlzG57BGteuFvpM1DG1MW513JbJjnh5n38Mp0Gf7ieyTqCeDB
         wDQq+c2hoCf6ubvTtCWGmloW4sEuar8Qx+12dxQO3/grNifGBdau3R3MNR9fNvsqttpV
         aLxDJXiq29EN2ES9GIG64kv9vTu5BKQzZILmwOGrcGsMLpw+5xDQ0LfxVDzCGzHMUy3m
         FSflGUQ+FPBum+v6YPQR+CAoTMV7dNv/nGzwNsnGRmFH8+UrongJVap/XcML+E/LpDMj
         V2ZTlbf2rkmSb7IEtNVIaYzGPnibJTZLfjDYrTBwnAuYX4GNicRG/oibzTCnVJKO+Mf9
         OFSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747117521; x=1747722321;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+d7AiXMLoB/R6GaZCR9iO4bJ1gIgBKIWJfItI2aaeUM=;
        b=RaiwGc/n/+Bni/OS901pWzIvsmuK9hN6R4iyFWuLaR2hBLB19pKuc5CYlTy53al8DA
         jOCKv01Y5kr5DvhdZmEcEjWqMY1jAM+pTZdgXJBfWLH9sCRu+kyhh//JWLGgQ6rzSmyJ
         gInv1f/gsghhMTqNv88/6nJ5fqtHo16Khl9nUOjzPpyAtVUI2navmZuxZdoM4LlDE7cq
         46i4YqpsRCVsUVX9hn0inoD+NAhhkr8p9P5ZZtyqXI4Tv4+vJe9RQ57IfPpuiojKk39f
         x36LihQmlah95/WqLidglLNo99wQ86pCaE1Mu3Z3plcSn63C54lzlHsskOlhleYpTtd7
         dzBA==
X-Forwarded-Encrypted: i=1; AJvYcCWRBHHdOcWeS9zdBIcaI8l708rH+gCuA970G8J9hC9w2DDPHbefiTBzw62GWy7oEQkIWuHq3puV@lists.linux.dev
X-Gm-Message-State: AOJu0Yx349fypQjnLCfNNlLsF4HOoXrIURKQ7RmwYEdvWObW9DWHzxJP
	PDy2fFcCtEgyOB6oRHGaPqjgjSLxEYjgg/Q5LycTi9djN8POMJYYDyghwl0alazmWSi/0Le0gK0
	5GmXc/1KZmn5eKJ6Va3z84OtFGv8JuiYynz/wag==
X-Gm-Gg: ASbGncuq2LTeHKzpurkZL7PJigq6xYfScBbadZVVpackz7JOBnT5Bi6ETzNbOUPQS+S
	i021Qfoaavq9czChsfu6HZHKupxhadi6r7micx8IckTyVSma9ww8kTynGqjYNHbGavdA2WrskRu
	M9WkoyyldFKpO9O0xPR116FRlFhnfQq/Z4lBBc06M+fl2Nofk=
X-Google-Smtp-Source: AGHT+IG0k9n49cOjh73xTLTAVsRne2xlZWGuWDYYRqk0/LfFX1W3pBb5d3DQiusB5b+lH51H0KyvWCzJsuMO6T8mKkc=
X-Received: by 2002:a17:902:cf07:b0:224:24d3:6103 with SMTP id
 d9443c01a7336-22fc8e995a8mr296351835ad.35.1747117509885; Mon, 12 May 2025
 23:25:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250512172044.326436266@linuxfoundation.org> <32c592ea-0afd-4753-a81d-73021b8e193c@heusel.eu>
In-Reply-To: <32c592ea-0afd-4753-a81d-73021b8e193c@heusel.eu>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Tue, 13 May 2025 08:24:57 +0200
X-Gm-Features: AX0GCFtNwSVq55Z4HzqwiHR_CnV-BQg0ApDjFN6fcXXXh16PBFZM7YxQnupqCXg
Message-ID: <CADo9pHh6WZruG7XCO74RBbXRcd8d1KktTZAhG4FNXzv6ZpjVHA@mail.gmail.com>
Subject: Re: [PATCH 6.14 000/197] 6.14.7-rc1 review
To: Christian Heusel <christian@heusel.eu>, Luna Jernberg <droidbittin@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	Mario Limonciello <mario.limonciello@amd.com>, Alex Deucher <alexander.deucher@amd.com>, 
	Ray Wu <ray.wu@amd.com>, Wayne Lin <Wayne.Lin@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Yeah getting that too


[   21.463202] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: AUX reply
command not ACK: 0x01.
[   21.464700] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: AUX reply
command not ACK: 0x01.
[   21.466133] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: AUX reply
command not ACK: 0x01.
[   21.467631] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: AUX reply
command not ACK: 0x01.
[   21.469127] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: AUX reply
command not ACK: 0x01.
[   21.470631] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: AUX reply
command not ACK: 0x01.
[   21.472127] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: AUX reply
command not ACK: 0x01.
[   21.473624] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: AUX reply
command not ACK: 0x01.
[   21.475130] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: AUX reply
command not ACK: 0x01.
[   21.476631] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: AUX reply
command not ACK: 0x01.
[   21.478127] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: AUX reply
command not ACK: 0x01.
[   21.479624] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: AUX reply
command not ACK: 0x01.
[   21.481126] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: AUX reply
command not ACK: 0x01.
[   21.482623] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: AUX reply
command not ACK: 0x01.
[   21.484130] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: AUX reply
command not ACK: 0x01.
[   21.485630] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: AUX reply
command not ACK: 0x01.
[   21.487127] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: AUX reply
command not ACK: 0x01.
[   21.488630] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: AUX reply
command not ACK: 0x01.
[   21.490125] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: AUX reply
command not ACK: 0x01.
[   21.491633] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: AUX reply
command not ACK: 0x01.
[   21.493120] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: AUX reply
command not ACK: 0x01.
[   21.494642] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: AUX reply
command not ACK: 0x01.
[   21.496128] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: AUX reply
command not ACK: 0x01.
[   21.497632] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: AUX reply
command not ACK: 0x01.
[   21.499128] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: AUX reply
command not ACK: 0x01.
[   21.500633] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: AUX reply
command not ACK: 0x01.
[   21.502130] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: AUX reply
command not ACK: 0x01.
[   21.503631] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: AUX reply
command not ACK: 0x01.
[   21.505126] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: AUX reply
command not ACK: 0x01.
[   21.506629] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: AUX reply
command not ACK: 0x01.
[   21.508127] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: AUX reply
command not ACK: 0x01.
[   21.509647] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: AUX reply
command not ACK: 0x01.
[   22.259286] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   22.259935] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   22.260583] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   22.261234] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   22.261883] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   22.262533] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   22.263185] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   22.263835] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   22.264481] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   22.265128] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   22.265771] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   22.266323] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   22.266970] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   22.267616] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   22.268270] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   22.268918] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   22.269567] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   22.270213] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   22.270857] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   22.271506] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   22.272154] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   22.272802] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   22.273450] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   22.274097] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   22.274745] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   22.275393] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   22.276039] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   22.276682] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   22.277274] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   22.277916] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   22.278563] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   22.279210] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   27.335457] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   27.336103] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   27.336745] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   27.337387] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   27.338029] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   27.338676] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   27.339271] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   27.339922] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   27.340570] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   27.341216] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   27.341864] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   27.342512] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   27.343159] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   27.343806] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   27.344456] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   27.345279] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   27.345929] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   27.346579] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   27.347232] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   27.347878] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   27.348526] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   27.349173] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   27.349816] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   27.350458] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   27.351100] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   27.351743] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   27.352390] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   27.353039] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   27.353685] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   27.354273] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   27.354920] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4
[   27.355567] amdgpu 0000:08:00.0: amdgpu: [drm] amdgpu: DP AUX transfer f=
ail:4


but other then that it seems to work

Den tis 13 maj 2025 kl 07:26 skrev Christian Heusel <christian@heusel.eu>:
>
> On 25/05/12 07:37PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.14.7 release.
> > There are 197 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 14 May 2025 17:19:58 +0000.
> > Anything received after that time might be too late.
>
> Hello everyone,
>
> I have noticed that the following commit produces a whole bunch of lines
> in my journal, which looks like an error for me:
>
> > Wayne Lin <Wayne.Lin@amd.com>
> >     drm/amd/display: Fix wrong handling for AUX_DEFER case
>
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0x0=
1.
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0x0=
1.
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0x0=
1.
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0x0=
1.
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0x0=
1.
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0x0=
1.
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0x0=
1.
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX reply command not ACK: 0x0=
1.
> amdgpu 0000:04:00.0: amdgpu: [drm] amdgpu: AUX partially written
>
> this does not seem to be serious, i.e. the system otherwise works as
> intended but it's still noteworthy. Is there a dependency commit missing
> maybe? From the code it looks like it was meant to be this way =F0=9F=A4=
=94
>
> You can find a full journal here, with the logspammed parts in
> highlight:
> https://gist.github.com/christian-heusel/e8418bbdca097871489a31d79ed166d6=
#file-dmesg-log-L854-L981
>
> Cheers,
> Chris
