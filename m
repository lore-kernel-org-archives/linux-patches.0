Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1EF1CAA6C
	for <patches@lists.linux.dev>; Thu, 26 Feb 2026 22:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772144176; cv=pass; b=JiHhR77Ofbs/0kZrFAfFytOUylUDrf8mxmYQILhx2voiJS3EngMtQY9wEdUW7ea0DDRzdz8t786tROWFi7rGxtPpJ/NDNwuZgPwzy9XUWciikXgxziFddXQSOvHJX4If2fYdAtkhB5ye45EUiR94uf9M914E2Y6FXwrrBYTYaFQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772144176; c=relaxed/simple;
	bh=ZcoyTpfA4HkjTXMAUaYrW0VbtT6k/vrxz+1C/FMe8oE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nJSgan2Tg/UesMZ2rNDIj0PLf/GqD38apI4tvewX+81kS5l11xd0bLptkjkzFv+puneSJk8icqJGOsxMMoKr+Gw22gJ7fFAXdSffP1hOAtcu3J8kpaNvqTkwYCrqSQt5csO3teMsCkwQrQZLlErxPyBMICGVLmXggQ75bJR+BCk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EekbBPB1; arc=pass smtp.client-ip=74.125.82.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EekbBPB1"
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-2bd801b4078so159936eec.2
        for <patches@lists.linux.dev>; Thu, 26 Feb 2026 14:16:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772144174; cv=none;
        d=google.com; s=arc-20240605;
        b=gGhuzPlmYWIkuLUNLHkNAfH7nkqIRuiu3HTeCkkymV3F3KjvVMWtrjp9klTantUSXR
         q3YWS0qPhdF4jbxqodzd/zu01ttg5YcyIoZzm4eZn+78vxfPV8TOd+LrhtCC7shlPwwd
         v90xcu7K/QSpQOIQcyRtYE3sPJUJucSEUWQGYelSPfISUPBnq7EOS+ZUKYnsOFFwz0Q6
         0VU8MXaV7jgR0WIX4fEtbk8Ff8XA2W3zdj4hr9+7ce1TuZZwT9R/jU/8roFeAPVeZWZv
         jPzUPav22TeRf0ySEPE9PsJH57Kj6lZSMLx8EhC6W5PnBu4f7+FGyQPTMACOutQhavIy
         iwzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ulP51Bq7VHIGjJJp/bP8DBPXzvEaSZ2JqDdZ8djCmiM=;
        fh=rkaBsIF04KPTMG+NN3QJzAKMlxYtOEXLl9NXE8/jsqs=;
        b=TW/ydvyfO8Z1PZFL/5UWNe145rr7pdAXDq+77/MgybFpgHos0PYI6x1tc10cBX5hBa
         19skXfU1gJFaMtKAHgWhG4DQky3RnxHL1E28ZI2G6IW+eXuejlIMOpaPAn2Ila0c4ebS
         RZbJD13ApM8WW4SGFnWt12WwCjik7eByphwVvhml0m30Wu2MdwYSSS5CH0X5ODVP+gwJ
         sXTmY/ylW2sWBM/vrU+bVjDt9mLIMTHTitmfyOTg5GNB8pDqll0JM9TQwnldm9pLX2yc
         GCY9UlzSy4i3V/yos+ZM4V1tHqUfehI81Mjvdrbcj2+XhnCmaUeazxNuFC4rx/SjMVAk
         OKTA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772144174; x=1772748974; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ulP51Bq7VHIGjJJp/bP8DBPXzvEaSZ2JqDdZ8djCmiM=;
        b=EekbBPB1o4A5nNCGDbh0/T3XHKxGHnrGSRyaU8ylw5vP28CSS8cSoarLuxLdAuoUO8
         ctOLBOCmSCtw180xWvjROwbUkRI4mW0Z3jD+Tio02NRTx4CmkqBz6kuFRXzKi67st0NZ
         3qrSAxqB28FeLGgSyJjxK5XVxaSKVcGeHH343lIx9rQFhhPw9c4liiz0ImIZE9gH6LRG
         9sFon4fbUdZ8QrnJ3oSh2yuliHo8/Tg2SE3hTLKP/lc1NSCLuG2mxdjd44PYVwayz673
         wGxrQwfYBsa1ZN8d19vrKKsTN5UbkSnzF8hdEHvVJyhaYxHdh8KPLBh3GPPH2E7FlbNf
         rCww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772144174; x=1772748974;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ulP51Bq7VHIGjJJp/bP8DBPXzvEaSZ2JqDdZ8djCmiM=;
        b=AtIfx1uagUW2HYh0S5hZi+t3QH5vGOkVccY2M1KqqAh1+RmS24xnYNtYRjCFqvNY4W
         KE/VuESA2NtPU5KfWn08//PJDkZBILyiy3eewJiiH1YtSUDKQ83yKGQRT7icEiDKa4sx
         Lk9L5nrDkvW3vjGrpO+CBxKC4gbVmQA/vDEEYIttAPOcm3X/K5XddV7q4qHqZ+lXI/uq
         R9Kgmby/a8zDNNH6+jY3H+WJCvcZM6y7ReTJJRm0WZT3vBoNqr27zS3JwJ+gpNyor5Nl
         ROJu/nNBD0u0pPnJdQN++D8iyj+QPBv585uiL3mddtsz6yJvbu6HLCQN5VbRe4NWe4Yk
         x+fw==
X-Forwarded-Encrypted: i=1; AJvYcCUBM5manQgYg9zRlCYSBlVs5eynbp6YPFN1YEh/N+C+cAUQ/cNNsPKyMt4zNzVxWHLuJhxkhenh@lists.linux.dev
X-Gm-Message-State: AOJu0YwGhDpxBhkPYy3IqVkhr0/lXnlO1sV9EU1FFy3kFC2CTbLLer6+
	IbX5da61nldjeNYAL19wbcnGF31qeA4pECQv2ShNbCdp3uUazGfttAzaS6tYafxOnIFMG/dLo4/
	Lz+speU4y2OA1haJEhkH6KIFZOa46S2s=
X-Gm-Gg: ATEYQzzmYpncB5MUAnPdWJOkf6glaY5lTLbgKZ+OS/7qlTctr8xyrLvEIJzCzacmWcr
	eTk7d8xqM7EvjrESQu6FZox85qJRXJ13gc+Yo7/Dnl0CEDdRZLhxZCIulwnFarX3cMPvPqvqQLf
	9AYfwqjSyZPX474JpqwcmdKRqaNnykBJIOrE14vNrUkLNEj57poxmA96uErh9MbLiMDX4BnD77v
	/Vg5H7J76/ZXXPXFuwJ4Si1VGPiMyUzc8ECRgkS08yhmDTtCZT1Ocj/AUfbm8Y7GHDJwpX1x6fQ
	M0DOQv55miZgkyhMF5SavFfdws3hOGCWouIWWf1aMRL29LGtl5AFDM6npoDpdesKx+BeYjNeQox
	zxdGMfrRleI5YZ7TrLuAfficzhNhg
X-Received: by 2002:a05:7300:dc8c:b0:2b7:f145:a98 with SMTP id
 5a478bee46e88-2bde1b2878bmr169080eec.2.1772144173982; Thu, 26 Feb 2026
 14:16:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260225155341.094945851@linuxfoundation.org> <20260226201056.28728-1-ojeda@kernel.org>
 <2026022640-ranked-resigned-83a9@gregkh>
In-Reply-To: <2026022640-ranked-resigned-83a9@gregkh>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 26 Feb 2026 23:16:01 +0100
X-Gm-Features: AaiRm50fZ4_63VFBPIPEmyA0KTAsuRCj5482jErZ-4aNE-tCfX9R395x0A74Yd0
Message-ID: <CANiq72=MJOc5KVrzUaebHxLpHwFct8Xh9g25sHAjO9HBE4nS4w@mail.gmail.com>
Subject: Re: [PATCH 6.19 000/781] 6.19.4-rc2 review
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, achill@achill.org, akpm@linux-foundation.org, 
	broonie@kernel.org, conor@kernel.org, f.fainelli@gmail.com, 
	hargar@microsoft.com, jonathanh@nvidia.com, linux-kernel@vger.kernel.org, 
	linux@roeck-us.net, lkft-triage@lists.linaro.org, patches@kernelci.org, 
	patches@lists.linux.dev, pavel@nabladev.com, rwarsow@gmx.de, shuah@kernel.org, 
	sr@sladewatkins.com, stable@vger.kernel.org, sudipm.mukherjee@gmail.com, 
	torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 26, 2026 at 10:47=E2=80=AFPM Greg KH <gregkh@linuxfoundation.or=
g> wrote:
>
> So should this be backported?  If so, how far back?

For the warning one (`unwrap_or`), the patch doesn't seem to be picked
up yet, but I provided the Cc: tag so you should eventually get it:

  https://lore.kernel.org/rust-for-linux/CANiq72mMS2EeU9ayDpm+xCz3xQyRBgRyW=
W8KKvJLAuCC64Xi3g@mail.gmail.com/

For the error (`COMPAT`), it should be backported to 6.19 -- I will
send a message to stable@.

Cheers,
Miguel
