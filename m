Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D34F390983
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 21:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772488323; cv=pass; b=Jek0aCd8ojR3PiLI/GzWT3YR7gX7H3HJNG3Rea1vKJHl0XQmuZTLJswlkr/Xhs3KabDz3FC9on+B6OtWR5Qcw1QTgKqwE/eovZN4Ko4QjodCzVGxQRS0UqnKcUVoM1rlNH0eiUN0YxC9602t9N3etHPrCqzp2NfwplwNB3eHdy4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772488323; c=relaxed/simple;
	bh=/aYkXHoceuLTDq+XODuF84znWG3nLcw1zyBW9okAvv8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pjkEVciTDoicuElWiwvCSM0ySPdHvqFMaAZ480IhQmGKEv3lM09O5+1bDyNLZqOzJz2hoqzHCxxHn2teW79S46uSTHsMcCUiDDeozUh4Fx8xRTuP1EasNM3ntkzzA8jNC7Vcg4g6T1uby111Ttvx+CpdR1uO23nI32+f8i2uDVc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=lm37j9bC; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="lm37j9bC"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-506aa68065eso48310731cf.1
        for <patches@lists.linux.dev>; Mon, 02 Mar 2026 13:52:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772488321; cv=none;
        d=google.com; s=arc-20240605;
        b=k3MZKj94MWdJlyB8LN8DBpabRCGAI4WKTt4hGkp1qBo91WYiwc6osfbIWTbgYDxecL
         V39dR7QjE1t4ZarsI1blvQO5p/ikeMpjyCC6oRyxhi7ZzNwyFv6e1cd4zS1Rnc3XCefp
         7r28A6coBObV6aGUZEf2u6s0SdBde1sMCewFgrljAgqgU7W14lByR+kW++1wpPd90327
         FRkujvn8afe8+fn3ZVb+GXrI4UCAbs8ynoeEV81bSZxkaXY1iJUFn+PTExmp/sSfNd6t
         phgLmb/kqXzybtAr6fK3wGgO3bA3bjbd/nBtPOAl0UXVrf76TQaCqnAH6lAH0MMrAXsf
         XxIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=U83OTh/J04tIfV9u9cnR7j7lp/7sDg2CrZNqgyJVfj0=;
        fh=YTxRTiMsZbPvBIaRvbxf8/BayhTb+o+c+e103lc7AmI=;
        b=QZ13lxa7xRnJxqToyxCyAeWjkOkgY94V6wcUd3bQNs0DwjCzmrcFJm/fDew5wvU/C5
         AzbZIzshjF3pPd0U6O91pmEfccLPPaajR/IMypRDR87QgZoIrMBOI9wp/LaFJWushrGf
         UmbTvOHyiDqfYmOHZe7q9DWUVyjtpI+E4TVlfSv105BCQKzTngydHtOIPwNo3VV89Jle
         EoYHFMJ+OLwfUAXVZncpYWzabKFnU4nUnCyGxB70ivJqiNRdO3VwDJmI6DsTr7Nn1oxI
         gUVKujduf3rkE3faQ2xNzdv5rls/lTpXfeNUcitHZ5SMWs5PApuNw9Mo5/Hm42p3Afk2
         nmJA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1772488321; x=1773093121; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U83OTh/J04tIfV9u9cnR7j7lp/7sDg2CrZNqgyJVfj0=;
        b=lm37j9bCR1M5dAM40osNkvd33ZdG4ty7fuVLxpfsbOX/VDfFVER22fA1uf3Sb3wVDC
         XgzPyFmW/FmLsyepWbi8x2oyqsSyJ3IHLQYdcq5e87gphMYmdPGj6E28uMwPKKieSE8p
         x44x9v1uAaNPQcRHanCmFAJQixL93nBqlUdY7+zQ+a0TBh+mYkmcYrTmQ7H5SQ28CvNo
         SBvsrz5YnPV3hmXxP9x6pE+zX+ZnYdZjhYCWzwyfYKbxppKrgd7JVq2lvXdo2C5bVepX
         5t3XWm9AB1m/3OCY1yi71e9dndRiBs3aTiaKgvdIIjjeuVnCFCdquqoQNTG8KFRitgbX
         /kYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772488321; x=1773093121;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=U83OTh/J04tIfV9u9cnR7j7lp/7sDg2CrZNqgyJVfj0=;
        b=BsqUhJaUyu7GIr13Tka/O//PhqfgnSzlOQIwUbD2QckCDJWZUcn200tKjadXa8ZKWb
         OxFoEs/XiXRuqGuAFQ/IZaJYTYuQsLGrTkm+HGVw3Fxa8lMtdO6oRFv8q/g5O2qiNHGs
         aRyldvY3MVba+b1CPtj0glxWPiPERZIT9dBT1eCIWS6R8ZsxghNeJqNmFzMihQNm3Qwd
         eKK0Wr3TjWzJFwfkfB5aR0DgzRTuVFVKLgQ8aqYQGe83bQEyzWZepo2YJuqM8TDQXeu4
         0S4ycWqC39RgC5uxUvMmzpQcpBKTObB1uby+uBwG8dCh65LidJT09x8u5gPeBVC3Ax2u
         d1xA==
X-Forwarded-Encrypted: i=1; AJvYcCV+TiY+pJVitC42nJ5XRkWvoqxAzyhAagJVdAk+0J0Fj38rSsW4sDkV0gkdWqa2xdnLKABpCMi4@lists.linux.dev
X-Gm-Message-State: AOJu0Yys2BuRbqF1brnZ3CZ1sBRJ9IKp9F7gf1E3o64mY2BYzfq+7P9q
	b4GdZMVEkfK9/j6dVYrhS+9aJYcYfByVZTwt80GhCbrOolli2lICjJbK8+2de4kND+wV+czezsn
	CoogG2UZl5lRrIKg+x9dv1aunI06s0Xw4M5SD2VhQKQ==
X-Gm-Gg: ATEYQzwpzhkVhEPv8bAcNne7K3mbMFLilk76lLoPEeFrIwbD9PHzaBglk6QNglFOfEw
	NsXs+r9F8kanb/YPkukExCLhkXxHB6yFTMJcoKJA9Jk4GuLBiD3MNV7IntarBM7T5peq87z4nCt
	auNtHvh2+Mg9ybBbO9+3OUJjnhRz9kHauVnR+JTcjF0dvxR7YsBPTJZSOy75AvmfIRGvcV3iGaI
	i9Aw3wI2wPVyr+1wUuVMCaR75mwZh+eKo7PTz8hDht5bHUoPXfFDpfDmeeCdob0dDtpFINhKuhd
	8U7LOmff
X-Received: by 2002:ac8:5ace:0:b0:507:3d3:6cd4 with SMTP id
 d75a77b69052e-50752875a35mr178404361cf.9.1772488321026; Mon, 02 Mar 2026
 13:52:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260302160853.2519610-1-sashal@kernel.org>
In-Reply-To: <20260302160853.2519610-1-sashal@kernel.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Mon, 2 Mar 2026 16:51:49 -0500
X-Gm-Features: AaiRm53PQsuGgYFDRMTR6ykQJnakx9veYaASPh2vMJjn7YulyJx3HyltF6zDv8c
Message-ID: <CAOBMUvhHsynrdfoc0opNRvEUm2Ddd9jObqs+1DsticSf9EgU2Q@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/757] 6.18.16-rc2 review
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	gregkh@linuxfoundation.org, patches@lists.linux.dev, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org, 
	sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 2, 2026 at 11:24=E2=80=AFAM Sasha Levin <sashal@kernel.org> wro=
te:
>
>
> This is the start of the stable review cycle for the 6.18.16 release.
> There are 757 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Mar  4 04:08:47 PM UTC 2026.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git/patch/?id=3Dlinux-6.18.y&id2=3Dv6.18.15
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> Thanks,
> Sasha
>

Builds successfully.  Boots and works on qemu and Dell XPS 15 9520 w/
Intel Core i7-12600H

Tested-by: Brett Mastbergen <bmastbergen@ciq.com>

Thanks,
Brett
