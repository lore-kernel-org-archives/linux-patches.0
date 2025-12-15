Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4D3279DC2
	for <patches@lists.linux.dev>; Mon, 15 Dec 2025 23:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765841393; cv=none; b=dUeOTHB3roSxYzi/S2BzOAdJmJVD3bs54xDQLQewO8dShoPLi9j4MlG6lvoEOAcvsv44jGnJKU5RKSZpChbiSAAcp9uYRhV63OdE3J85x8HbUnTrGQJYeG+kwlrdxUbXaJwdEIhDyc4Hqe576bfU7KI1kJjvWsnimsIBaVRSI6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765841393; c=relaxed/simple;
	bh=XOoPPexklsz7SvupO8sfvwY9ZiR6aEvcYtpvbQTfdQY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c7VeVb5PdeSyaSX5za92t8FUKd/sVcTr2q8JbCd0RQfD49MaimJ2zAIopPg+IU9eZmhDnKK4mBsR76wwhVj/wtjFQoIWsaSuZxEfDlvtlAX0z3N7XulqZL+liWE54uZHlbUFVYiqk5nMcTQj0Q08bRcS3Y8yQ5z8s/h+wcQzjqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TXCg4+Rl; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TXCg4+Rl"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-787eb2d8663so47118477b3.0
        for <patches@lists.linux.dev>; Mon, 15 Dec 2025 15:29:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765841391; x=1766446191; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XOoPPexklsz7SvupO8sfvwY9ZiR6aEvcYtpvbQTfdQY=;
        b=TXCg4+RlXOCvamohhH5oyMMfCPPwpPpYA3l1xdnsCKcg/rX68PvDdWDgP89fexV1bC
         1ph0cgI6VYydrnXpSsX8qckVfrAHaVf/FlzW+sxFcg5g14d/L3bcY3tBYCdZIWxIlH87
         nn+CKpsoqP0jUXGTHfcxQI0DWCRRYnxnMuFMx8a2a7JO64VHX2PaaB7+uAz7EQG5/YyG
         AWnFKlw+Un5NF+7KQsbeoUWUpzYOafEqs3agzL8iAygBfJf86kfPpvo4VCY0HR8wriK0
         XlpGK7u4K3+vcaH+IN9RGSQsKcnuvb1GV7w/gwNZ63GEAXSUZ1tspIut4OcNj/magv41
         OPJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765841391; x=1766446191;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XOoPPexklsz7SvupO8sfvwY9ZiR6aEvcYtpvbQTfdQY=;
        b=migCV2fC7x1VE6WtcwWVkEcQOfoo0T8X7DSeI7VWlQRyjV36XZH/8USGnG3WeoHvL4
         TfzM5RKLRzx+/5U5EytxmW1QPzBjrB4GsJQM+OxjiYS3V4I4BMxrVjZZcBkjzndXdc6a
         nzHksAfJe5b0zzlxSFdQ0Ruqn5Fvo9oub2Xv6glw9oWlCf9YdcdgowfARkXn8oI6XNfm
         h11GejNJTtYU/xE5mOxqHYOIY18yRad+a6MN+c4H0YnHT/nzzRV0mZv8AVrcXTJzV/m7
         WYdG8C7f9+LsriWaulHWEJh+uJxtsIoAT3BiIv3K4mIVT6MdZsSGxi0KUOhbSr9qRzC4
         7czQ==
X-Gm-Message-State: AOJu0YxasCvgkI+hAoh9MGc7S9GRWVfwN5Q0+T3u8gO7JOy2DXFwQMdY
	A3QNAvHAc6Vfr/lxQUSpmP4pZqzRDupH6CKDqeoS+AdD9pzJ902guqbsfGekdlaTPApgAQ/vTU3
	y3SINJBoa5dNZ77492TLBpXjl09tPLIc=
X-Gm-Gg: AY/fxX7RUxQdHv47ao5jAgvg/Sqqdi0HHtRtHXiTuOAbGfYKPE+aN6jY7JTE1nLEnC/
	Xk2FR5BH2YCyPVl0X/+gAATUDG6zidfP7sYyt55dQJkHr76cOGjsxxdJ+kMJ+Ojs7dTB8l+z12N
	SBcS8/DYwuHnESW4pCwOIB+rwCnUhhGK+15QgJOlHFl4A45EwrBZ0k132rtaUbKZphYx4UnHpm1
	hLS19xJ/edMNda+zi/ZHYBBLI90XXoa2FD86j/ooj9mPtKvwUTWw0/3Bt4TNisr9GJ5bvz2
X-Google-Smtp-Source: AGHT+IFXQr+WLdQ1LBgwmIwfs8QhQuZ97Em1dNVvE3JkMPBG6CA9xvDlyU87aqQvCFKYiFCctQjC/F8Jd4LH9bQoF0w=
X-Received: by 2002:a05:690c:385:b0:78c:4f8:f4f3 with SMTP id
 00721157ae682-78d6dfdfd98mr135081087b3.32.1765841391153; Mon, 15 Dec 2025
 15:29:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251215004145.2760442-1-sashal@kernel.org> <20251215004145.2760442-3-sashal@kernel.org>
In-Reply-To: <20251215004145.2760442-3-sashal@kernel.org>
From: Askar Safin <safinaskar@gmail.com>
Date: Tue, 16 Dec 2025 02:29:14 +0300
X-Gm-Features: AQt7F2othRtJTu3qTB-suXBFqWXz6gMb9saSL-bJoPW27po55zjiWbgVkURPqXs
Message-ID: <CAPnZJGD0ifVdHTRcMzKBFX8UEf_me1KTrkbwezZrhzndcTx-3Q@mail.gmail.com>
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

On Mon, Dec 15, 2025 at 3:41=E2=80=AFAM Sasha Levin <sashal@kernel.org> wro=
te:
>
> From: Takashi Iwai <tiwai@suse.de>
>
> [ Upstream commit 161a0c617ab172bbcda7ce61803addeb2124dbff ]
>
> When config table entries don't match with the device to be probed,
> currently we fall back to SND_INTEL_DSP_DRIVER_ANY, which means to
> allow any drivers to bind with it.
>
[...]
>
> Reported-by: Askar Safin <safinaskar@gmail.com>
> Closes: https://lore.kernel.org/all/20251014034156.4480-1-safinaskar@gmai=
l.com/
> Tested-by: Askar Safin <safinaskar@gmail.com>
> Reviewed-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Link: https://patch.msgid.link/20251210131553.184404-1-tiwai@suse.de
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

Please, backport this to 82d9d54a6c0e .
82d9d54a6c0e is commit, which introduced "intel-dsp-config.c".

--=20
Askar Safin
