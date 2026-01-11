Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A06330BBBC
	for <patches@lists.linux.dev>; Sun, 11 Jan 2026 16:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768147351; cv=none; b=ds6Xb6CdsmTLiqiDaetTERYdDjlhFzacawyvue6d0QIMvryhaFw3zVg6qlFTV8g4ho3qVRebIQI7du3A+aGZGKsKGFPCHcup2tGlEFFdsPZeDkrzdxx4e75KlxkN43bbhYIZFx9WK8bD+ct/LaE5ClBLsi++2ZkrWPpx7g5wEVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768147351; c=relaxed/simple;
	bh=eSaYeVb9xp7hiZVnt79Dppo3RCzVphfcMVldS9mlf6g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jlNHi8US86f7d0QUFM/zxyLRrQOUCBO7ADyHnFUYHMU/mwmzgPJPVfnh7Cl+gmtvaTYR3nvhKRo0hz0RLW90iiQobl5H/NHWjiUcyixXFyKTrxi90l8n1nlBIHqvsUzbnvUCjwOBkH6+iJh6xYSHF69tUPksGe6lLGyUMlev+Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gfQDtmwP; arc=none smtp.client-ip=74.125.224.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gfQDtmwP"
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-6420c08f886so7954089d50.3
        for <patches@lists.linux.dev>; Sun, 11 Jan 2026 08:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768147349; x=1768752149; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mrycd130M4sr6y5csevbsCsisFex4vtcFdUC5UAakBY=;
        b=gfQDtmwPui66qodivKc1qkBcdGuB/glGATaeaMqWX+QxmvdjkbvxZ0gXGAZVCCrco2
         0Hd/eu32PV9KXc2Oah9p+2y58/CW1xq9tRB+C9KgfKZx1CZdRfIG31WsYYt87rFFWoEa
         M+svMm4WTO2nFYumw3pJ+Qz1J8ZBq3DKjr0w6LOJkW7HiCSN5ie4fRABJVp/uTnTsyAG
         tab0/Ai/oVUBldeWhA4mn4AvzKyw2XdWlXtXYafkXrOdxipDc0rFf/fFA+eERN4njqUm
         semgVUM9h+WQCRab6NUR8KXt4u0+n3TvYxVJRSWJ4W7qKqNL1v0ZIH6AkIZpEfLis8Za
         eTTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768147349; x=1768752149;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Mrycd130M4sr6y5csevbsCsisFex4vtcFdUC5UAakBY=;
        b=LaUnwAgbld6oKXRqMiyX3yzrJAxwRRiKMfA3efkwVtkNZ5Ps4WxQGPE+kW4mGHmeZ8
         4v7zEus24pyx0I9w9P4Pw4QA5tNKxQyhfkGssF6NT3vkoVEt8AZk5D0xkrBoZHXhrplR
         YZii+1b758D9d5jcBXXlVkm7zUAy2bxapTMYYTmd2XwqXmCkP8Ldm1u0056LhuD3ew+d
         G4vNYhr5m+CypXELOmfZjQw1oTRp1jgdz91ClSelzdJwoGiKxfLzLaUk2okpWfrYRysQ
         U8X8t0RBTplWF3/wpx6kmEc9p1eJ6pCrHdlC2re3OUpsoCwteFOAJZCWjueha7OU+/nE
         hOFg==
X-Forwarded-Encrypted: i=1; AJvYcCXMZSNY2DuZZ86B91bfRHjO2LVdmmdv3LFtFccGoo0/VdK1D6hR5WA16w3K5QYuDiL5eoljfXux@lists.linux.dev
X-Gm-Message-State: AOJu0Yzsmi0i2avBq1PtIwCEHlueyFZd4aAOcFpVwVIR2WMcGGEvON2A
	h1JZs/6yN+bd6bdrLUCeWRRjWDE0p5hXsNMAdwzKmqS8zYGLzqjYziHT9DXwSLbEHB/apgbJRbO
	bSzfsd7sTX9A4LyPcl4iXIuVUVY75Uzg=
X-Gm-Gg: AY/fxX70jXqQBIoVKSPu6Ii+1j1HCcwscKunCrfCNbM1s6EDJdg6ppA5Tn3vT3Hd/UB
	Hg5FBgXsHDioa8+Qj+ptafZHpsWyLg7Ne18uHgUL/8s30bmP5Zh1i8FxHZv2eqbSsAapG0vdWQE
	aTgAZ6pNA1BgTlUr3uET9bkVSj9cdtB9IHHKyuSaG5k0erN71a3IOK/2AFwUWIMDJ9MzDS/j+Wb
	YXVWC+sbr5d/PG5PXeopxLQu+xm2sJSrznuKpmbVZycM/hA/dQcABe7+Svmx9sxud5fKZQ=
X-Google-Smtp-Source: AGHT+IF8KwHX9n4cdLJcJVB+1Qbgj7xp3EnY3eddzftroQhS3lOBRejGEzTuxx79W8cJXIm8mv4flYclON7riLXunQ4=
X-Received: by 2002:a53:be4f:0:b0:644:7612:6298 with SMTP id
 956f58d0204a3-64716c94ef8mr9426151d50.79.1768147349222; Sun, 11 Jan 2026
 08:02:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251215004145.2760442-1-sashal@kernel.org> <20251215004145.2760442-3-sashal@kernel.org>
 <CAPnZJGD0ifVdHTRcMzKBFX8UEf_me1KTrkbwezZrhzndcTx-3Q@mail.gmail.com>
 <aV5Ap8TgMEDLucWR@laps> <CAPnZJGCJ1LZRzfzO=958EfcrLm4Z3pYdtHZEpp812fstsUcOAQ@mail.gmail.com>
 <2026011119-stadium-trilogy-22ac@gregkh>
In-Reply-To: <2026011119-stadium-trilogy-22ac@gregkh>
From: Askar Safin <safinaskar@gmail.com>
Date: Sun, 11 Jan 2026 19:01:53 +0300
X-Gm-Features: AZwV_Qj8Iaiq8jyFrAWd7h_o61n6oQGSG9QPqA4Rx4PSntORpllo3Vv3IL8l3rU
Message-ID: <CAPnZJGAXLEgqKx+XA3RugES1kcawtqMEYPTzFERcf2kgRjNbFQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 6.18-6.17] ALSA: hda: intel-dsp-config: Prefer
 legacy driver as fallback
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev, stable@vger.kernel.org, 
	Takashi Iwai <tiwai@suse.de>, Peter Ujfalusi <peter.ujfalusi@linux.intel.com>, 
	kai.vehmanen@linux.intel.com, cezary.rojewski@intel.com, 
	ranjani.sridharan@linux.intel.com, rf@opensource.cirrus.com, 
	bradynorander@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 11, 2026 at 3:24=E2=80=AFPM Greg KH <gregkh@linuxfoundation.org=
> wrote:
> > You mean that 82d9d54a6c0e is in all trees? Okay, then,
> > please, backport 161a0c617ab172bbcda7ce61803addeb2124dbff
> > to all trees.
>
> Why?  I see no context here :(

Please, backport 161a0c617ab1 to all stable kernels, which have 82d9d54a6c0=
e.

161a0c617ab1 fixes bug, reported by me here:
https://lore.kernel.org/all/20251014034156.4480-1-safinaskar@gmail.com/ .

I did bisect and found that 2d9223d2d64c is the culprit. But then Takashi I=
wai
explained that the bug appeared earlier:
https://lore.kernel.org/all/87345iebky.wl-tiwai@suse.de/ .
Iwai said: "the bug itself was introduced
from the very beginning, and it could hit earlier".

I assume "the very beginning" here should be interpreted as
"commit, where intel-dsp-config.c appeared", because the fix
modifies "intel-dsp-config.c".

"intel-dsp-config.c" introduced in 82d9d54a6c0e, so
161a0c617ab1 should be backported to all kernels, which
have 82d9d54a6c0e.

--=20
Askar Safin
