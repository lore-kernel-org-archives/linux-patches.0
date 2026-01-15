Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA61308F13
	for <patches@lists.linux.dev>; Thu, 15 Jan 2026 19:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768505403; cv=pass; b=GTWwdnAjKPbKnaHBWHD9m5TY7Sblhr5bfgviP3MOHGCttPVCQEhHDuiPW7yOiE6/s7l1e4umPH9gWbpBTr5k8gJgQrmI1NVA+gq75wyLbLLpzkw1ZtlqDBBqDNbrOpxWrQOD4rJmUqozaAqdSF6SdS4Gkj26CYx9A9v/98evGjk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768505403; c=relaxed/simple;
	bh=xpAe4VquDRlbvhlajgDJdW88OXpSMesEONtyCKGlhWs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RByaV/iyYUhe567mWUuvqyVgKNrI6uYHGNIU7XbW2GaKSw/MXYm172JWGJ3Ev4dt7YMxNjWs4r7O7U184OvZcXn3ccOigC3KGl1AVopVvnrMNBRz0GWHQfvwNyZS2jA+QJGLPwkT6bEgeQmsCmOnZ3tQI6Zr7S4NM40ZdhsJPJA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b=oh13fPQJ; arc=pass smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b="oh13fPQJ"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-64b9cb94ff5so1912438a12.2
        for <patches@lists.linux.dev>; Thu, 15 Jan 2026 11:30:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768505398; cv=none;
        d=google.com; s=arc-20240605;
        b=StZU8EVPRtKleEg1hWfKfZGF4Iz1QnAjR51qI6I1k/3/adzdmq13qqyCSWPm4Xz9M2
         FMNtP6B+fjmlnH2mEsnM1ZpEZ/0WKrMEUnJVec79oVAQ25DnItNapSzf4+iUkxtzDxps
         VWs+EXYvFVeyPGF7XABj/NnsWowYNPvkkqPwesClvekK853ODvbyFXExf46CkdqtmqVs
         fsOFVdjpGZL84wH26bB+p/m5hXFm/HwnqYGlBC/lJX8qOEA4ZdJmpe+oIOVM3qGPZVyP
         DJMfD+qWl4U6LYooNRFWRsklwRXX0ECh3HKmVs+n5XjZEZXy1NZ+Kv71e0MXIPChFgEy
         LLnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RLeW5LqW4wx788qexxNJwmsPJ9CgRqRlygUR7u9scY8=;
        fh=wWY6YAWiElluM9Dr1htKHc+NWteJtjfrxNbcrNVzEY4=;
        b=UahF468iqsPSnzf/202kWbFf880n314Zcp4236kXiMyzHZh9FNuEyHdrL7OyLYG8Uh
         UDJ05QAjVVlYG/OFwZA54TTy7KAF0YRuBLF9HJPrzz5imxurEOXPwS4Qtvh/WHcLOO4F
         NEK+tBVLPsKZ1Zf0D6nEWrWpmtws9a2vGectTF6NBVW9Pk3KZHOha1bXIHgcTkIuqWw5
         +xtYURIfcPaBxyhEVEY3B6sg5OYZzwUXg31ZA1Tmwi2XdePeeduXrf9KiblrXwOstFaj
         +qIFCThZulWXVkk3UlO4WVifGsZ15D1xjEicIVC3YkHFsc7vAXHDa8hokNoWN5Hx7v62
         SyRw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.com; s=google; t=1768505398; x=1769110198; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RLeW5LqW4wx788qexxNJwmsPJ9CgRqRlygUR7u9scY8=;
        b=oh13fPQJGEjVSbxr5QAwb7IR6ho3Ia8ijKtY5BhJds/p7kG59guo59/l54eJBNikQO
         WMM2bj5yyYdWXnkviVKLF++jTa5F4lknsYicjLvfBBp8LKNpgzZ31gxxBkOzycYWRRLw
         ZcRRaLF5yqagc/42FrTETXGOdveVIpDph2TOSCNecJEKtuBEdccbvbmkVwfbZ8ltvsQd
         PIi3vWz5KCy+udw6T9DvTsfzr29+nkwmz9Pci5+dMLwjtACjigjuTf5rjAyItDPJirMf
         K4y4YUXkf4C3Nn2RAEA8Z1K4PUih/4JDk5Q4NjPc9TcydBJ50lTKe933DwN3623qiVFK
         VUmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768505398; x=1769110198;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RLeW5LqW4wx788qexxNJwmsPJ9CgRqRlygUR7u9scY8=;
        b=sNUxRZA97wbwncKpg6PEUonvChS1KVxI13Ujl48IXZxZ5bHAXiQgiilOQbc1tOJW0V
         CNQ7ixn8Qt4pi9/nbut6+dTh/doLeRe0SHnWI/eRqWMdMVr4GeLOa/WXB4VcNqB/dVa4
         rEVNrtiLJwm8zEEHTR74aooRuDG3AvdaunRBHI4mtrMR+oTIACMWmT+l4eFANdrPmZFA
         YjYnGIZexmpoPrJQtxdiOkZjuTJ0zaLijRwhbU3/mNQhs2g6x2k2FyR19hfeNVs8ivTs
         kY0YdDpMZlLhlRhpEc7yR3gpu0T0rTfTeWt3g+ijnNrra/KpMgnpgwLE+qywKUWzr56F
         MoDg==
X-Forwarded-Encrypted: i=1; AJvYcCUh+fqOLzRr45ruc1+WaSHiaJ2zQk6FrJMs20KMNa7j59WfPoJ8WacBXIj1uyzkpHX4l4NSwsjJ@lists.linux.dev
X-Gm-Message-State: AOJu0YzFFHrIeMq9tCIto9EQofVQD1p4I+KejgvKAKkkyGfJfU/34XEP
	2APHqRICknzjfZXcI72cHvIcSA3hipu3vk5bB2IhYl/oiJJ70kEJ7cWBa/FzJOUyqwMKOlJlYkh
	07ezuiwRpeKk8EWCHOUMYC4ZTUyaEP1xf+fSAMmVXmc5nR4TsqlQ/XLMNUhJQ/kybtwVQn7RwFb
	uQAaVFcZA7L+UdUVauzxQukNKRfY0G
X-Gm-Gg: AY/fxX55eGZDYORh0CuTHQM2NliVlFBDMmrJh1vOD0BogR7UU+IiC1JFvvhhdGiVqnb
	AfUCoG1lA8wwc/IPiVT3fKseY6r2ShVM/OC9a8Pz3idk4tbcz+gsfoTuPBpA8Q7ONVDkFRhcvQ2
	cZX0MoI76Z6aDsRc97n3Kzy1WmuIl/LsbILrNmYlh78+c+17wR/o7Etc076EwbbIqDPsYYKYwak
	8Ss8TgNwNQkZepA7n3rjqu/PD6GPqyodPC8h7ppd5j7uo/8FJS2vZuwHUBREaO+P3X4ObjGcSlK
	HgTN2C09DEC1D929lAZso/84vts0
X-Received: by 2002:a05:6402:1ec2:b0:650:891f:1c07 with SMTP id
 4fb4d7f45d1cf-654526ca179mr478548a12.14.1768505397625; Thu, 15 Jan 2026
 11:29:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260115164230.864985076@linuxfoundation.org>
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
From: Slade Watkins <sr@sladewatkins.com>
Date: Thu, 15 Jan 2026 14:29:46 -0500
X-Gm-Features: AZwV_QjqLkCgApoRuKv35Ai4LvCRp9OylMJtBpKdZNvHB7wDFP7nb5QcJ6zDEls
Message-ID: <CAMC4fzKeXhgotO=3nB=csqZ=gaF9xRj2+AtfdqpLYE6j8dGQ7g@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/451] 5.10.248-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-SW-RGPM-AntispamServ: glowwhale.rogueportmedia.com
X-SW-RGPM-AntispamVer: Reporting (SpamAssassin 4.0.2-sladew)

On Thu, Jan 15, 2026 at 12:40=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.248 release.
> There are 451 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
> Anything received after that time might be too late.

5.10.248-rc1 built and run on my x86_64 test system (AMD Ryzen 9
9900X, System76 thelio-mira-r4-n3). No errors or regressions.

Tested-by: Slade Watkins <sr@sladewatkins.com>

Thanks,
Slade
