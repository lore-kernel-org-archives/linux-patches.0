Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153DE3128A3
	for <patches@lists.linux.dev>; Mon,  8 Jun 2026 10:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780916248; cv=pass; b=AUIbQTYpaarFZvrHqkuiamwoTiMRL5+3jtf9hyh+mhCbjssukK9QMzuhu8h6/CJeMYjiGrMMvMCbg5frOxQQBsGVQXuybwkhrlFkiF8ktPJ4y9V2vjcAXMhQCkBVgz1deHwj9OmVD4tpBQeiXHtxzJjomgQ0g80zx5kpJujGSfs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780916248; c=relaxed/simple;
	bh=h5GwtUrO5YjewAia1LKWw8eyP/OHFDrD+FZ3lR6jbPw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QWsQBFCbHAccdS7qyzngX1cmPnfKfvaeyc2iRMX6SK8aE6DSeVD0CMivF8lS+d/yGxMXSni5Td5nVAG/yF23jBJ/ZB2PwaShqD6tFQOZRGOa1kNqigKDUx2D21yE3W0yvbPZ8tZMmOZy2DS6tMNoNWN4r8XrK/jEIP0CfzkvR7A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.b=QGc7L6Wt; arc=pass smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.b="QGc7L6Wt"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c85825bbc4fso2543843a12.2
        for <patches@lists.linux.dev>; Mon, 08 Jun 2026 03:57:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780916246; cv=none;
        d=google.com; s=arc-20240605;
        b=CHVF8GLTPcVQgOaxVbKvK/W1MkXICPTZFGD6rfyQFC/np2XhEFs/mwgi1kjp1qxXtn
         Rpk6gkf5jNYXoueWtlwGbqaQoM3514zI5Br55iSATze1USrY1g34cQjQHrnxoKwe6GHW
         iVKZ4f8gPRyuBMYsh+hp+0AA4+iHBKcOzwYzsZ3VzQdt/7xE4aSGGXYAboHbfXf6mNRW
         Ys2LG4ZbBUwhB0Dec0sL1RSGSE00Y7OVSiheblB9rXwpt5Xc+EbRu+LO4BXrpi5ojEkm
         HWo3a6z88kxk3+ym1X2nOIQlsoFkPgrdc5IDG8TtiUaBgO+ttw+OokX2qGRkJigBc8Yb
         L4JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ahSludj4wZP/wYjbZjK7tn5JJdzUwAesoF596bb6ciA=;
        fh=k9XZ1LrSsPjixWhrNduw27e3KTu3mw2XWMvl/SU89PY=;
        b=kYZa9N6Z86735omoTSuuuSi6ASdo9COra2scDIQoXtgKVdJsWcFqdhwqlirVSbVMLg
         hEHeQEUjNkcWhFsc//SUu9SImwS0CUduMaNphY4YI5pCFxhxF66AD+nDfrp4Ew9EMP+f
         d6U0dvrR9F0PGCTZN4NVMzn0dryUA65UBWuDchW6zvPFC6RaWxX6jKpyO3XLaf/9LH2r
         8WrOYfwSvCVorncTtYhX2Muj05ENid4JpcOKaxzMDkVmU3dUJH1kwtHoI6P/HtFr6TuP
         21tK+ZOndnF+zkwv9d8ZBGYz2HziQbsF1N/DF4t0KiLID/zq1bDimwavK1TRH3GzRttM
         6eVQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu.com; s=google; t=1780916246; x=1781521046; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ahSludj4wZP/wYjbZjK7tn5JJdzUwAesoF596bb6ciA=;
        b=QGc7L6WtEhMl87aWjUcvM9VIILH8h6445k4VnaZ3z87KKEArDI/mLGdFlgyBLdmlCw
         R3unv2LRpqbWuxZrOON1n/xbNR2/BSpVGWQDUzmJVjCpZE7XgaQs2SpNfKpZYdodi0df
         jmatNk1VLkNcPyPyujXTaouHi5o4FUcY9rwUI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780916246; x=1781521046;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ahSludj4wZP/wYjbZjK7tn5JJdzUwAesoF596bb6ciA=;
        b=DtgzZJra9wl138Y5bIgTMZ9b1b0sruwDAUmBKzjpPqMn/9LfbjWer4tI6zB2GFiV2d
         IyaR33qL7SgoiSTVcVayS6Xqp3fQ48QbCNCgv3xNqAloi/8olF/bEoP/XaOZ0amSl77F
         skx+gpdRgRnsaT/5Vnwc7Q1kmsLaKXrPT99C7A3RjlhDVH3FGru8IXG9YIkhxhnRYVvJ
         B8wBucFK3UKM0/zuKX2SYk6gtGN/VYM3jbi0CuzgYjycijkCUTaE+xJt91zStIwx967C
         PkbDm9HqcOLMfccQoTkrsSMc/LPtaLm4P1k3UGPXnp3Tiv8VTigNYfP2hXJZJoErZnBz
         DjlA==
X-Forwarded-Encrypted: i=1; AFNElJ8gN50vCsqTbN+Jwhw/ToK+KOMWwGd4YQxM47gqlNapsvYiw8jHevq+/WWhLq3AHdHytxqUeqJx@lists.linux.dev
X-Gm-Message-State: AOJu0YzVTT17jqRkXe6qHwPbr/CVdEOUNJKn1Wo8uEkLvYEPK8QXEXLG
	XaezzxdV/W2ul5XsT99eYgvVGLa45L27aHuwW1uwknIzjkbNKLrEs9BorJina8cYA2vMTpgLglk
	krFYSMAgwh85sI8prBQML2IJBVe8GGPtko9loRJuy
X-Gm-Gg: Acq92OFz53WkBntcyXpy9hY42hxl/8HFYAo/g7MUCeUCxeetVqRUMvvByKUme8TH897
	7NoImeMQRTP7IamZA2tAqtfIjz/gMyzasD0OXszDhi6x1rS+YWo2WYX/rcgBbXiO2QxcDT2tpAd
	plnQzHCw+EVy2blMzpUO+4FRYdYVsIEyZyIeUCLkI12KYagKbdHDPWkgGiY7l+lxk9wcN7yqk+w
	gzSerBzvRD8x+xgAR6HCEYHHFAy51waFgBgyZO86OOJIVFP7nqkkz9O6ufuBNvJANywfZHm793g
	t4Yd3vX09/zuboLFH/Q=
X-Received: by 2002:a05:6a00:228d:b0:842:6c02:2fa4 with SMTP id
 d2e1a72fcca58-842b0d60127mr14721457b3a.14.1780916246453; Mon, 08 Jun 2026
 03:57:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260607095727.647295505@linuxfoundation.org> <20260607173214.92693-1-ojeda@kernel.org>
 <CAM0EoMkszTXv82To=KnEYTgzQSmEdRW9XrAMVtJsUaDn=Akf6A@mail.gmail.com> <CANiq72mJNbNzYO37VK7s=ua5v31xBrRp8EnHDvEnKF8Z77jDmA@mail.gmail.com>
In-Reply-To: <CANiq72mJNbNzYO37VK7s=ua5v31xBrRp8EnHDvEnKF8Z77jDmA@mail.gmail.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Mon, 8 Jun 2026 06:57:15 -0400
X-Gm-Features: AVVi8CcZH7gb8WPQEP1bwBGyGn6nbunXL5d0GcMBpIG4fwbjLQQVvr8yXfV8paM
Message-ID: <CAM0EoMmHd10iivCpDoEd3h+eae9fSnoGWAH_AkwFhrnS6PN63g@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/307] 6.12.93-rc1 review
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, gregkh@linuxfoundation.org, achill@achill.org, 
	akpm@linux-foundation.org, broonie@kernel.org, conor@kernel.org, 
	f.fainelli@gmail.com, hargar@microsoft.com, jonathanh@nvidia.com, 
	linux-kernel@vger.kernel.org, linux@roeck-us.net, 
	lkft-triage@lists.linaro.org, patches@kernelci.org, patches@lists.linux.dev, 
	pavel@nabladev.com, rwarsow@gmx.de, shuah@kernel.org, sr@sladewatkins.com, 
	stable@vger.kernel.org, sudipm.mukherjee@gmail.com, 
	torvalds@linux-foundation.org, "Kito Xu (veritas501)" <hxzene@gmail.com>, 
	Victor Nogueira <victor@mojatatu.com>, Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 8, 2026 at 6:08=E2=80=AFAM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Mon, Jun 8, 2026 at 11:55=E2=80=AFAM Jamal Hadi Salim <jhs@mojatatu.co=
m> wrote:
> >
> > Thanks for reporting this.
>
> You're welcome!
>
> > Unless i am looking at the wrong code version, in the current code i
> > see m_eaction is always initialized before being used.
> > m_eaction =3D READ_ONCE(m->tcfm_eaction);
> > Probably a compiler false positive?
>
> No, it is an actual bug -- you have:
>
>     int i, m_eaction;
>     ...
>     is_redirect =3D tcf_mirred_is_act_redirect(m_eaction);
>     ...
>     m_eaction =3D READ_ONCE(m->tcfm_eaction);
>
> i.e. the assignment goes later.
>
> Maybe you are looking at mainline? Please note that this is a 6.12.y
> -rc thread -- are you looking at the commit hash I mentioned?
>
> Or maybe you are looking at `tcf_blockcast()` instead of `tcf_mirred_act(=
)`?
>

I was certainly looking at the wrong version.
For example what you described as commit a01fbdecc3a2 ("net/sched:
act_mirred: Fix return code in early mirred redirect error paths")
shows up for me as commit e80ad525fc7e

I believe this bug slipped in during a small window but was fixed very
quickly. Probably some fix never trickled to stable.
If you can point me to the exact tree where this happens i can take a look.
Still curious: So only the arm compiler catches this?

cheers,
jamal
