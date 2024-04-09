Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CEE13666C
	for <patches@lists.linux.dev>; Tue,  9 Apr 2024 15:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712676459; cv=none; b=L8nxIMzkpYd92U4s6hULm9cYkRB98vDKCP2L/5CRfiQK2dFt1HjMbCgMiqw4UKimuotqSfFmlKQml4UsVsQM3RVAnMZXNSc2iJUJs51rxQQmpHe1OBdFezyKg/150Vo4FoyfiVPm7wbe1Uwd4GeSs53OpMhs8fytkajrVxkh1Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712676459; c=relaxed/simple;
	bh=dexzRqm21eeJSqWAVRHkad4KsYnd/kRt9kFG5xKBSjw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hp9o19V5hSoP0CQF+ZWcgKLsk2HuGpM2+IYZWUE8W9atEi8REhhDdJPufoB7aSvhF5s22Ug5WvTG6dFsIiL9P6QiQZdoJxt7StAXx9+zQ6fxxefVD3FbUBbDUKgct3qnkRjyD3xKfBi8zP/Crpj1Db0ONrVzPqq6vjyz0VJM1Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=u4P6So/i; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="u4P6So/i"
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-ddda842c399so5909963276.3
        for <patches@lists.linux.dev>; Tue, 09 Apr 2024 08:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712676457; x=1713281257; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HzNV5FXSliq8ZbIpw2zckFkXIRHoYFy5vQtp+aDf1/U=;
        b=u4P6So/iyinF2kn3V5YeWPpU+ABOgS9K3jIUQ9N1n9w5XLKJpiCpBdjy3ejODkh2SY
         xV0UQUiTLGPPAtulYb71PzpR69pxzk9hVsAcYSgaDrPEjVZW22Rn0c+WJ0IylKdmRf2t
         Bl7sVW3BFWe95RdRk8n+lj/GZjNRD+nhX7RwnVV/2+eMT/zN7Bg6IWi03a6Qn2YSwQd0
         euZGbxkDyFnuaK/TM0RshDi+fKBgf/Q35VsyuTXczZY9/tGW/45JzYmO0o9bSHEn0YUG
         ilsY502Xi7Gn95NTyYJA44gnFnYKOgmTw/joo9LKZ/+XiJpBZ9QL2iIC7sC7AoOp715h
         iQVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712676457; x=1713281257;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HzNV5FXSliq8ZbIpw2zckFkXIRHoYFy5vQtp+aDf1/U=;
        b=Qri8XlYl/oq0fUTrTFzFmN7I2/rPeAPwHmbej/8z1ezMJJ4WtZ/18JjTv2Ws3V40nH
         x74XLtWU/42Lg7wI7aX4G5UNUz6jdiOZp48eoMT/12hXDAhNF/e9fjlYOjUrQk0/YK8Q
         AFj8/I4+p/gIzTjRJkrM857nAeIGWhoXklzewYVGjCOnelL0J3dzy37iFYge+pqEDTm3
         YD2CagYKFOYYI2MEPqu3HLycei3xrhm3rqhk3UKRcB+9YyXTuAqRoirCMV4ksZ5yF37k
         zi/f9KVVMeTDkr51Q5MsXz8fDQJkuMdCwJRARPplBqmboj8lKCViY/oVRa3e9tpYJ5Us
         Shtg==
X-Forwarded-Encrypted: i=1; AJvYcCWlHSprb0CaslS/F9o+NdPEC0rSgkG4LlxmQKcWfdp8kJcFbC0gLyw6GWk92V0onR1YsyiRFU9Zxe5OG4+nApwMPoKf6CgirA==
X-Gm-Message-State: AOJu0YwfoHsvVEbv3z4UfxTci2mdbG0E0LShf6bgo4lgK6FEwQWAfp75
	4m6vvJ0v8oyPVJ1ucUNt+NM0esT2ee9wAy1BZR7/wL0UiRH2pDnoyHHmBSQEVXoqg+ukFdBGoGm
	7iHxQEK8Xf7WBaDT4ENFCYo7BnPmMAZSyy/j57w==
X-Google-Smtp-Source: AGHT+IE6d+60UNgeFMm8vHhr5l4B78x85SmxpGyUIJbum81B9311rsAC2C/7nGWn32Skid9DOoxXv6B6TSLMxqYReBU=
X-Received: by 2002:a25:8005:0:b0:dcd:5187:a032 with SMTP id
 m5-20020a258005000000b00dcd5187a032mr66301ybk.43.1712676456879; Tue, 09 Apr
 2024 08:27:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240408125309.280181634@linuxfoundation.org> <CADYN=9KoZSBy_sbKR9ZTzcUXuUgA+PwdhAMuA5BEHP-BHjdnNg@mail.gmail.com>
 <yq1cyqyo9o3.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1cyqyo9o3.fsf@ca-mkp.ca.oracle.com>
From: Anders Roxell <anders.roxell@linaro.org>
Date: Tue, 9 Apr 2024 17:27:25 +0200
Message-ID: <CADYN=9+Ms-g6gJd43NKDTy9Sg1=P4x7Mv3FB7tL0cL-Bhw5Ayw@mail.gmail.com>
Subject: Re: [PATCH 6.8 000/273] 6.8.5-rc1 review
To: "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, bvanassche@acm.org, Alexander@wetzel-home.de
Content-Type: text/plain; charset="UTF-8"

On Tue, 9 Apr 2024 at 17:12, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Anders,

Martin,

>
> > Reverted this patch and I couldn't see the repoted warning.
> > scsi: sg: Avoid sg device teardown race
> > [ Upstream commit 27f58c04a8f438078583041468ec60597841284d ]
>
> Fix is here:
>
>   https://git.kernel.org/mkp/scsi/c/d4e655c49f47

By cherry picking the proposed patch
d4e655c49f47 ("scsi: sg: Avoid race in error handling & drop bogus warn")
onto v6.6.26-rc1 I couldn't see the reported warning.

I also tried to cherry pick it to v6.8.5-rc1 and I didn't see the
repoted warning.

Cheers,
Anders
