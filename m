Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795183450;
	b=HSmM6O/Dv9rmOiHhsQeTEpEM+fovmEXqub5hmB7RvM7bqIpYeru50JX0G3QJRJbW4NJN
	 /Fcq3vt1iOfazNxb1sG3DKBHL4Q2gqwdGjZHC4exjGiO5FEPhETN5ZjetN6Qdx5gQLN31
	 xrw9e1BnMGiqS9AYet90i5u60SRdMkVR1q8WdIBog5yJg3f2bYtNJ5WbsyPIXBIDZPUD2
	 YRSQVDbcqukXoshd+d/GAyUp/iIQHSSjrRr2I4kBCHwwxssX+nUxfGMF/o9wTAOsUpE7o
	 w32wlVi7M6DN2M9Jie1rL77q7GC7hnPpZ4q4CpRThwIVMI2Er3xlDi/cw7mmEE1/vGw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795183450;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ebuT+f5EamFeEjXTBFPk8/I7Ne4UNxLTYT0YdYlrjqo=;
	b=TMXr1UHLjJ17ZYNSXsN+XoHc2fF+Ry3VBzcArT8LAJveay5FLrf/dDOXAyw1FemHmFkk
	 wqmdjBEmIttDzAyaWS1LK6LlgW/bmTxvemNnMu6SaiM9jr2lIga78a8680qaczapjhqo3
	 6rA9Ca5XQZTeGAU/PY7ZR8Oycw/wbbZCjeTAD/6wUO94PewLkwooXwgNcIOr52uzGDF1I
	 ojHaDlFJlXUJ6/HNvGqx/2tcSjE0ivmXNZ0/pkWt6E1kj/QzLSAUjfnllGAZxN2gDyy0V
	 dh00VLYAcauJN8fo06jQK/4g/0QOMnAjHCWg4Bb5JZhoSrlXIDo5r+3QInNSwHVfQew==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aT4wg9jR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.43
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D36606A325
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 14:04:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 15D36606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aT4wg9jR
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5c0ea47f5b8so98393e87.3
        for <patches@lists.linux.dev>; Fri, 20 Nov 2026 06:04:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795183448; cv=none;
        d=google.com; s=arc-20260327;
        b=FyTtZEdHfd0r6XFIzbp7cxj919kxR46adnqC991/m9yePUzC0kW0OMLx5mKMcSfgR6
         WwwPJHAgN0Jcg5pi1w3gmkJNRM6bq+D/VIlghDgFQDVlPYhBYLlJMIq1sivx01hEbY0i
         4CSm8JcGV8Sk1Gx5CjZVCLyyXXl45DzquKhHmOgDwakFW/Z2rlFBGe6jR8mMjQKKwZt1
         yq8mOta/dIYBUINOxHR+o4LeeQmPdELyYlvizrXz17Wpk1oYTpu9l/URQLvf3sNb6Hm2
         TgkJyUEE00gx2vX36tjZmhAEqgj/+kSBTVm7mPn4lLHfMnRHh708nKkQW0JboM1RF/QZ
         8Tbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ebuT+f5EamFeEjXTBFPk8/I7Ne4UNxLTYT0YdYlrjqo=;
        fh=v4tcuoB8rLnesQ+RHTj6rxATIT7UVLJ48Bz9MVEzFHc=;
        b=DJET0mzPDDrQUZnyLvLKOpDUF7Q/kx4Dn46JEPqeRiNgKN4cFSF0LUI1GqfBEu2on6
         hbBYzZb9vDu2VaDT124tHJ4sjYiunv564ywsp6bFNCzCXm/T5DKNLfYg4RTGJbBZttY6
         rrgdveRhqDgQiYoOP7T0hsgee8XzjqQz8twpZD6MY+G+hISHVXiMgSyrn/MoDF2ugl8s
         w4zdnIxvC/jQov49WpDi+4gc5xW6Fr2g0dkWZgt/tzQ1AcgQe4nCxfajB1H9TmroRMg/
         RLHYo40iZT9dofnKspOdhbLQ8gg8HbylOVl44WVEJuUhvGTleL/qi0DzKPkASbIFWbeG
         z76g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795183448; x=1795788248; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ebuT+f5EamFeEjXTBFPk8/I7Ne4UNxLTYT0YdYlrjqo=;
        b=aT4wg9jRTLCuoprON4h8S6juqH11tIJYFS3I1sFlkmFXFJzdRsSsKXL+bmu7k1r3Wx
         72EHQJwm7eX3pZh2D9TZ0r9HIJRGvvSlqRrMmFAUG3aYCi7rYMqAvJChq4o4dO9FklMh
         syHmawrF8WPhviABP2RjrYi9RaCbcHZ8zN3CLG2bJTn28x+LSXlLj/gr+vHB4UGIfBsY
         clxHifkwomchXsMpbqaa76JCTuoSQpGWgoKKBPEgArLQU3DqwdnhBMIDW8W9IB5hZ/6b
         iDhWGbXbEMrbY9maSfAfmdyfRTT3Aonr22qcMc429FjLNaJtqCSODmTlUe5tgHwG+ZCu
         fs3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795183448; x=1795788248;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ebuT+f5EamFeEjXTBFPk8/I7Ne4UNxLTYT0YdYlrjqo=;
        b=iX7ly5/lcgKpkvyTi6WvITGY1DrdTdNi0yzUiqC2j+I+GE2onKddXxqBNVqTYzqgDn
         1B5SZ3OuxzZUtXxvzUBbV9xJDkSvqAdxipLrXr3G1lkMmiM8/2AC56JqqobjVzovM8ns
         Ls9JGF4Ww75B6zhrGd62F8SvDBNFejcF1aHdzqzXFLGW58+aCgkVDwgiqHKk7eQ7MCVh
         aSLecgb0uLvBm/bRMHoOqyPfI6e6SepCkbJoNSX4RWtnCucwlKEUcP0kBx8H68JY04d/
         UurNy7Hb4lupgI+UxOqeuUvHWHT6ofhHBgl07NAjMtdSX14KPXDJs4zpKXVyJLjJZG0o
         Ge/A==
X-Forwarded-Encrypted: i=1; AL+hErFZW0dGlS3r5zfhBvF+kq0v75Omg3TOK1qd3G0J5Uc2EgJSJcJ+25VRn5iEIO2tXCB0gFNJ07BR@lists.linux.dev
X-Gm-Message-State: APuU4Z8SsEmJCCAPCr4UETwjpOVZiAxVP6dUKg2o/fFK2phPXvxpA/qs
	GdIc1hafyJHKbFtnnvQeVepdNLJslcJr3vjn2qD80zRn0fpSFQO2FJZc89pPFUpun62EtEWkGfl
	86TAuaACo2AKVyHbtu1IM617tw4a/D7k=
X-Gm-Gg: AZFdTZdug9Hsj90e9HEztSv4foGTgcqCVRI1+uMsAmC6D43PZasYq4AOfU8JwWNxGTY
	/iX6WHS5BkjwX8vAdKIH3ahek88roS048tzt3jBPNsCWxgSuAd+3saWhSc/Req5oC/erlfYmACI
	4JiIXoZF5hDtnMOhtSFV4BBIcKvoWdDHzhEK3Ukr9y9cTSUoQWT/6VqRZPvut4oTX3DeoFnWkNu
	3EBszW8qnRzByjfjpLgiXUwAV7jehNr/i/S0nRe5exeblBvfpHeNYB17fjjLiRJjnlrtIfwWF/M
	RsE9o/fFSLqMvnMAuqnX7owhmzHk7sYZikyUzm1jvpFIarLO4Khk0XNA71+pjBncsscD6Vh+8Hl
	odip7lZEL+Lv6YJ64tewNEl3jsRM4ohP398GwxyFl1lKVu7GPVoEhPigM2BRjLRpmnKkynWyhRz
	cWOgjv2qBOVAHYM2hQggTflJJB4A9oFhNC1ex9dj+6kRZ9IbXfqpST3CtMoN6UXg+DPT7OdB9M6
	d/c0IUY/JxRbIN4YADTdejZpBx5yBXW7yT43oMyPGn6FgaLVKFjXXrd8roiqo9DlDUjhTqX+mk=
X-Received: by 2002:a05:6512:304a:b0:5c1:57b9:90d3 with SMTP id
 2adb3069b0e04-5c1bc6d29ffmr1168124e87.1.1795183447989; Fri, 20 Nov 2026
 06:04:07 -0800 (PST)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261120055200.707545519@linuxfoundation.org> <20261120135123.16092-1-ojeda@kernel.org>
In-Reply-To: <20261120135123.16092-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 20 Nov 2026 15:03:56 +0100
X-Gm-Features: Aa3M54oqTlpP7aqhlAYeu20Jbztbh7rwwB7_36t7sUXGwDuDu1WrpuuSK4L4S9A
Message-ID: <CANiq72m0P8SjfLHKFh+NqOtxanEx1Q61NO=dRsuUwEKyTueOSQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 0000/2812] 6.1.193-rc2 review
To: Miguel Ojeda <ojeda@kernel.org>
Cc: gregkh@linuxfoundation.org, achill@achill.org, akpm@linux-foundation.org, 
	broonie@kernel.org, conor@kernel.org, f.fainelli@gmail.com, 
	hargar@microsoft.com, jonathanh@nvidia.com, linux-kernel@vger.kernel.org, 
	linux@roeck-us.net, lkft-triage@lists.linaro.org, patches@kernelci.org, 
	patches@lists.linux.dev, pavel@nabladev.com, rwarsow@gmx.de, shuah@kernel.org, 
	sr@sladewatkins.com, stable@vger.kernel.org, sudipm.mukherjee@gmail.com, 
	torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 2:51=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Boot-tested under QEMU for Rust x86_64:
>
> Tested-by: Miguel Ojeda <ojeda@kernel.org>

I forgot to mention that Pavel's issue about `__pud_trans_huge_lock`
in -rc1 is resolved now, i.e. I am not hitting it anymore.

Cheers,
Miguel
