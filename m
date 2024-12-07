Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898A224B34
	for <patches@lists.linux.dev>; Sat,  7 Dec 2024 05:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733547884; cv=none; b=Gb8OyrlXxrp4v8Nnm2vnqgI93CuPgUnXWBX8Dn610QN9/+QzIu8xQWhNZlexqxy0r6puHl2p/9qIFVw2OAHYsQBR1pJtEKCEy7RTjPWSgZSy4tGJU2s7g++uB016fN/UM3MLjpii7emfjbaMkDQMxEWy7trdoyNRfmfhH2/agZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733547884; c=relaxed/simple;
	bh=VUi6E6Tz/yc2Q0GE6Mu6Gat67zGMtdy2Gi4v3kMP7w8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s8eKprkGLNBOsexRGJJlIVtSFTxdmf1hJ7XmwQFgTqx42DbUsib33sLWDiJNRaJnRV3bQDdeoryay3UWR13vurhU4wlbHNfFxSNaeJR/cZPMjTDAwoR3+q8M8VloRM8Vbcb9r9I2QDrzV6y3BNSxARx3RffjB6qEzHbzjrXBDD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=Z47JEVs0; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="Z47JEVs0"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7258cf297d4so2727618b3a.2
        for <patches@lists.linux.dev>; Fri, 06 Dec 2024 21:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1733547882; x=1734152682; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Ddt2VEuIOo1iVu76Orar/Zo/Mdp1ppf8GycmQvRWHA=;
        b=Z47JEVs0+k5o+mExJGc3FShUr1oJzw+EWEqrg4D8KzSPyoIHFmWDB4gcGmJ0ITY3aK
         KB5BWk/XYcdbb1+uBk/yX5vXL4iIjhjT9r7Okz4570XlZ4wZZEiVhaX36R06/qRMonP/
         QhDi4wI0Jd2or9oKnDGiRGGIo4QO1Je8hu4h2tj5QoSpc1SAAgm+jypsTwc1PZz6hdMm
         gMMJP8pIsretKw+LlVGn0PdZa9ajGxrTvx51usaWPeTn1FxY5GN7JcHMtCgwH/J2sdF5
         V2Y05324YRDSxifYhqz1YQaZ1PRyJcuaza1fHHsPyZRMZ5HtbfQuiAiNUr/N5srTrMLg
         U2qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733547882; x=1734152682;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2Ddt2VEuIOo1iVu76Orar/Zo/Mdp1ppf8GycmQvRWHA=;
        b=HQucuonKOzGE9DqgX0JREr47Q7Cw/iqfdW3+/UKuk4aqoBawvwazQk5/ZRvv+yKpt5
         sOlaUde0IVSgMMdPb4nNbWkcyZdJk18vtfaB2AqtP+9hWgW3ElzQ9PbKDrSQOP0upbrT
         PH059kldcb04rD2uPhEv+0qh7DgPOY9UWgzD38dneaVmCjlAUlNd7QNJ1nuD/USlB0el
         MzboKuea+4yTwtrEUyorKCw1xpgLK2fbcx971GmQs6Sc324jeRoHCGM/UaXOJp9+kv4s
         gQfznhsfIbfUPrAj6D+cfQUpjmiWphip52oMbg7Pu6qBmdWixHbjryQCduAjWRM95WuF
         HOTw==
X-Forwarded-Encrypted: i=1; AJvYcCUC1u2FBmFvrfbR3OhaqXkwej2YNjOxh7kNnpDBUsIitkXIOaO4QckuiTVXNssjznVYU8dvg/oX@lists.linux.dev
X-Gm-Message-State: AOJu0Yz0d/vefTb4Go+5jXzxJd/UBi4OQrJ/S2RMfjS9Nzxc5FCH2N3g
	dolXxkoZftZr7eGimff9Dc8FkQf+3Vu7WIGo4zWUjZRDsjLgqegDlS2aVOe1a4TAcVeJ40c+Jqo
	eYGv1Pade/7lgZJYTmdyinhnGkpO+EgjLtDS0hA==
X-Gm-Gg: ASbGncszt5whL7mNUJABLHB/GCXKK/irZeNMThnGRHYLXEPiyEW4seLOpsh8GcSJ68F
	kkMvoyT5s3Abv4K1L9jE14kEFY+vBDQ==
X-Google-Smtp-Source: AGHT+IEyb3xya9vheBrL7IJRZCeTEEHlKpHt0HNZJAo076PAOtifRmW78Meq4o9kgxdcg0vlyTCPwLyJMgs9Bqw3+vg=
X-Received: by 2002:a17:90a:da84:b0:2ee:cd83:8fd3 with SMTP id
 98e67ed59e1d1-2ef6aadd741mr7528991a91.33.1733547881868; Fri, 06 Dec 2024
 21:04:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241206143527.654980698@linuxfoundation.org>
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sat, 7 Dec 2024 14:04:30 +0900
Message-ID: <CAKL4bV60tq-6dDy86C-8nKOf20iHygyW6ZK47DxiE_8zhHuD1A@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/146] 6.12.4-rc1 review
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

On Fri, Dec 6, 2024 at 11:39=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.4 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 08 Dec 2024 14:34:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.12.4-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

Linux version 6.12.4-rc1rv (takeshi@ThinkPadX1Gen10J0764) (gcc (GCC)
14.2.1 20240910, GNU ld (GNU Binutils) 2.43.0) #1 SMP PREEMPT_DYNAMIC
Sat Dec  7 13:07:21 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
