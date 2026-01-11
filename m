Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10A633C1B4
	for <patches@lists.linux.dev>; Sun, 11 Jan 2026 12:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768133126; cv=none; b=Wp8IVw2yMSVrzhMWUEH8CYzKGOHwxrq92VrIXAfKMPhY66VoTk+c0O4Qqh+te0IdOdeyKragB6ft2gAEHAv3SBe2UAC+QFxD1on57yaG3WIPbSwr4Z/78niu1EE4Ga/yQTRayO2OJzQuYRxW01cT+skehxRu+y19eeeD+Lo6Vjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768133126; c=relaxed/simple;
	bh=BJGL51uFk7fQ9hz7zeX/+jdsupIgJO3pK5yWzIkYIKU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y0ZNcUoi7oWLvngLgexM5lKPUlJhpXg1RvS2ow4iPbanfWGMCKRH73f3BqAhe+3jwwmF5Uin4ep7Ehw03gWq2CnLfbpZm2d56fE76d3wx7f2wm0M8IqB35ntFqBz5qFTU85yTMfejkonBR2zX6QjiQOs2XhlJ08g/mhWR+MCN8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O4l9o968; arc=none smtp.client-ip=74.125.224.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O4l9o968"
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-6442e2dd8bbso4317527d50.0
        for <patches@lists.linux.dev>; Sun, 11 Jan 2026 04:05:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768133123; x=1768737923; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BJGL51uFk7fQ9hz7zeX/+jdsupIgJO3pK5yWzIkYIKU=;
        b=O4l9o968OmBcurkoyCOV35kzQeGP9Pv7AdgkGaRuygb9G2sYHbn5aqk/DcC6VemIvx
         tywn45Oi0zJwpZp+mmq7TF/yC0q1id89SdOXupkHsnQAEf+tVsSoclTQEOVepPq53H8G
         IsArvjzDzJ8pmZQiMoW8PucDKq8zr+7mGd3XnnU7GdcYqwL4yTgAFEPdrr8y58cqEufI
         WR+9gtaTECNOKo4s76HxIYqhqXdQr0I3biwkSr8TNdXCHg/OpbSyYDZ4MKX/Hu/9mh2m
         YsnZcANfBsCwdCQ8ZTMNQT/+H3yvxrhlnEQqQWNYVTzv7y0p8kdFuoC2oave+afCTVA1
         mkgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768133123; x=1768737923;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BJGL51uFk7fQ9hz7zeX/+jdsupIgJO3pK5yWzIkYIKU=;
        b=jvB2rxn3HyQ4JKfmvqfAy6/zbkHn5wzxUl9TTlyqlHbMTeu8IB+UBE1IM+mfMnRsx4
         nLPOpKJlS/Bi9RCJW6ry1UrdDXiITYx/TwIV8jfERRgL2Hc4sf5e8KPd3RH4XzbWgyM5
         m98wt6VhLa75/C5YwQk2GxhqZh4JSQveumLuIEoyYNkRgg7xUUcYjDFfTiC01RUE89+v
         DVH4YMYQv86ptl+AyZ9Oz7hoHCaDEuPnc4wu67K8+j1CZXWLrIT5D5FuLobcOVAWqg8C
         ucfMk2G6qNk8dNcvwgLjBa8aynEHb2R9fUaQACgjmIuntrNRj2YPxk7X46XqmMKTOaK6
         db8Q==
X-Gm-Message-State: AOJu0YwCppAgxOsT1xr0uxuVM6aSSrInhfWCEfDJrjdXrz87Ih3kWk+c
	2c5AeR/UzEO4lsPHVUxQ0aSdlx2Xt1fWdLdQzBNpTv2ko4dqZvOgTmOdvgHULpskiucQsQKapQj
	FFzvjKkC5IEjWkPqHAdF6tWRfD+6Ot3s=
X-Gm-Gg: AY/fxX6thA3X5Vfo550ipPQsmyuH9noL1pJGr05DTZDz0h6eE4ZdopGrhK75TNVp9V9
	w9XxorRwShLQhgqdk3VzPs8a87XxFty36beIEfnQ+H0LF8qd5pkWnCnL43iUCkUoToL3XKBC1N8
	b725xZjSmUoUpYMMKL0f/PcYTRtYJr3hFw4WjbGIWZBLVYC0v100aayC5J9k3ZhgWr8hw9vBb/o
	bs1liqIi38W2b31sOi0Sa7TSiDA9l5SBWBxE4FCY/u5NPQL8lpN89RC5TuMYFq67AedXJo=
X-Google-Smtp-Source: AGHT+IGahIVp0QXfjLl8u9XAUuZ7fv6XRsqgXN/SrrswcxGhag6nP5JvuSR8ieSQy0oB8X46LSRqzKp520LUEChgAVU=
X-Received: by 2002:a53:ac91:0:b0:641:f5bc:696f with SMTP id
 956f58d0204a3-64716c69376mr12371028d50.75.1768133123569; Sun, 11 Jan 2026
 04:05:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251215004145.2760442-1-sashal@kernel.org> <20251215004145.2760442-3-sashal@kernel.org>
 <CAPnZJGD0ifVdHTRcMzKBFX8UEf_me1KTrkbwezZrhzndcTx-3Q@mail.gmail.com> <aV5Ap8TgMEDLucWR@laps>
In-Reply-To: <aV5Ap8TgMEDLucWR@laps>
From: Askar Safin <safinaskar@gmail.com>
Date: Sun, 11 Jan 2026 15:04:47 +0300
X-Gm-Features: AZwV_Qj8Sx4l4BPwlCO49T3uPzi24vzhWqsFCLRApt24D8voFX6GP-5XOhNcwiE
Message-ID: <CAPnZJGCJ1LZRzfzO=958EfcrLm4Z3pYdtHZEpp812fstsUcOAQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 6.18-6.17] ALSA: hda: intel-dsp-config: Prefer
 legacy driver as fallback
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org, 
	Takashi Iwai <tiwai@suse.de>, Peter Ujfalusi <peter.ujfalusi@linux.intel.com>, 
	kai.vehmanen@linux.intel.com, cezary.rojewski@intel.com, 
	ranjani.sridharan@linux.intel.com, rf@opensource.cirrus.com, 
	bradynorander@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 7, 2026 at 2:16=E2=80=AFPM Sasha Levin <sashal@kernel.org> wrot=
e:
> >Please, backport this to 82d9d54a6c0e .
> >82d9d54a6c0e is commit, which introduced "intel-dsp-config.c".
>
> Looks like that commit is already in all trees.

You mean that 82d9d54a6c0e is in all trees? Okay, then,
please, backport 161a0c617ab172bbcda7ce61803addeb2124dbff
to all trees.

--=20
Askar Safin
