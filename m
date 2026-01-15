Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D19D2DCF67
	for <patches@lists.linux.dev>; Thu, 15 Jan 2026 19:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768506454; cv=none; b=JVMj2KRozouoSmeOy2WStrsbaFqJj0n0kKWPo/krbL1GMPwhPp2EqNlSR/y5QQAvgIUlnrWIkZiZD2XkztgsTSD4W+sbDZR7CxQiYaV03NcabkJNQPtrevWD7j02CtnrAKW2VHdDI1hGReEzZ8z4b8P3uJAOle0GoGKHkvy6q+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768506454; c=relaxed/simple;
	bh=VKi3la95horDA61dcl1O7wF5nn/3hAoMMKjYxUZaguw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a5IdwY7ybdYrQt+FtuxWtl8ZpblqH3Mx1gULAzamer+9NAnUDAciBHfPtL2Wn6eNVJa0+ZLa3091wpRvjyuMyw/WYphjRSFDnge3tVb0x6Dq0lpe9xqmoX4Ggl0f2VHmYBWOTBJropbfoJMwrkjP8t8CxWxOoFYPbPdXV1uJ1HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b=ZXng3C6D; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b="ZXng3C6D"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b876bf5277dso342301766b.0
        for <patches@lists.linux.dev>; Thu, 15 Jan 2026 11:47:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.com; s=google; t=1768506445; x=1769111245; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S3odQ/pxLnGS5MFj5IkMIFC8SRNuLPcBQQcOgmK4M8M=;
        b=ZXng3C6DEBZA2vO5qGFv7w0ZMJadS2RntjkRVN5N1zAnzSkOOd0UlaN3a7HOuo9nGx
         DR5Z3yH57oSZ7WnU51u3xNNX83kSM6FAM6N6ZbzBPNqBvu7vHzpy1EebpgK1hSKu/BJ4
         08sA4eLudaNNQIHx+WS3nIo8cyGMmO+F0+8RX0/xhOVIXAOuOTEqs3sWo0n66U+u+IX5
         xB/v2d35wYekZ1xY+ndsFMJCFDykGFEHioMnRwNPbc+wfgrGCuPdS4bxBAzkANEfuVv4
         62djuVBkqQdaq/riOVHQR4UnVz/oDkOk0NEY4mrppXVMDANqcWMJMxzJGqivMZ33/U9T
         T9cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768506445; x=1769111245;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=S3odQ/pxLnGS5MFj5IkMIFC8SRNuLPcBQQcOgmK4M8M=;
        b=uvVF2RbbOo4wXfiGB/kW5vJ7CDKtFq4vFqckfleud5kkqNsmJ4MkoFcIS7HJs9OU6a
         l/8r3aWO1XbLFeWvJPNockdmAGDGQ98MRexEOSLKIt16McPR5oni8fFDP+3UocmeDdSR
         BP6UaxtwW81M7NhQ3twoQkn06vU8f3+mFaBITy4F+EK8QtYWL375r1VK4NBqhnY2VSku
         3Y7rLZ0MdlXyB6fVmyY2LbZLp+7T6uIMC6fuS2xngTpOeDIbH2HbhFWUP++ZZHwHoShk
         gzxUkHWQKXqYMN5ddPkAdC/kwGIs40hbIUAWBvuD1u1LHzpVHSCfgryvfsSao8DxBiT6
         RyzA==
X-Forwarded-Encrypted: i=1; AJvYcCUviv1IskhVb7O2Sx5nPAc1LXnYAleLJN2QgV0JlkU64UOBciiCgBrD6CwDRRzNr8QsHRhgz9/m@lists.linux.dev
X-Gm-Message-State: AOJu0Ywnuvg28tDcw53EUGXBWkcAW1/by/8OraSkIwD9Cl1fNi8AZuSc
	gSAt1RYukvzPwAxlHQxYmuP8HM8+/h8WQiWD72iGqYF4jWj4DKaXjCig/fHnZ7Vc4HTjCYy04j1
	yF4Fa3LOZVMq5kVMurx95u+20oZKLJmE8awr8DwxI74XcQm/3RJ+PFbZwlZ0t33HcQgP0Yp9V9n
	UsA7KXDEU8ZgOH8TZFcFncYUKkRPvB
X-Gm-Gg: AY/fxX55NM4jaFUOs0gCnAeu30S0qImM7XOQyr+JygRH0pgMZ6QTHGUnNvpR40z6Xio
	gcpuhL2PwYsaQsTqCqsRQGR07VzNKMus7UG3DXyBIqNjLv52T+Ul1j8EykJ3IBhLB6n9rkpVzgg
	oPhoScD7o/k6htpQ9fZvypLrt+oyHX8CkBk5oRYqQ7Tps229YispeYHPCatlHdzbKSWYlIBrKvN
	5+yy/S7cv0Z3iQeeaPUQbIqem8zBJLROCMrwGhNA6CLnhQwQshr4OczLHMj/gEkOsWvP7we8e7a
	vWVdQYHIGUoUVT1pOoZKLXcBXISL
X-Received: by 2002:a17:906:3ca1:b0:b87:6c41:bd6e with SMTP id
 a640c23a62f3a-b8777a0b1a2mr260840366b.5.1768506444695; Thu, 15 Jan 2026
 11:47:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260115164146.312481509@linuxfoundation.org>
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
From: Slade Watkins <sr@sladewatkins.com>
Date: Thu, 15 Jan 2026 14:47:13 -0500
X-Gm-Features: AZwV_QibhZ9PAL5T2joVIo32SBlzjT97vwe-QD_Ct7jvNbEpwcYLciPgjCK4CUs
Message-ID: <CAMC4fz+zFOFetPaRPE3oMsq378B=B6ObpNLYQnafLBbEUZdABQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/88] 6.6.121-rc1 review
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

On Thu, Jan 15, 2026 at 12:06=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.121 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
> Anything received after that time might be too late.

6.6.121-rc1 built and run on my x86_64 test system (AMD Ryzen 9 9900X,
System76 thelio-mira-r4-n3). No errors or regressions.

Tested-by: Slade Watkins <sr@sladewatkins.com>

Thanks,
Slade
