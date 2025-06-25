Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558E316FF37
	for <patches@lists.linux.dev>; Wed, 25 Jun 2025 14:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750861933; cv=none; b=SeyYiEWPeOnitEYJsb1OpApL7cyeD/I5vizbqb1Lhi/+u1gt+cs6Ms2Hajia/i/spse3QLGkaPjz4oOVaugBqEaWOcKg2F/IoIBclhls73Mboe5uSD1UsZWwrdaRwSo6sOscLkg24xKzmd5udbBXx1zjCzDEZM57eYR9RLOQ3z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750861933; c=relaxed/simple;
	bh=36jFcNi5AMtDfDUxJWLv7FOPyUhXdgiBwK1gip+Y68Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bUbCSnshKUuVuoqOBzXH3V8r3l9yEahrFAlZtp4RhtqdW434buk18zZGVGBh+Yun9L1WiWPDh0NmCY24c1+HQvRghWOoI6adE2e+o0EwirasGRuaAITmqMpqmVpaMuYXv7v7LUfdFZvVR9sP6AUjus2yvbtAOjhX2g69eFqOjCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=temperror (0-bit key) header.d=ciq.com header.i=@ciq.com header.b=TQ1T/1OF; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror (0-bit key) header.d=ciq.com header.i=@ciq.com header.b="TQ1T/1OF"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4a4312b4849so18648871cf.1
        for <patches@lists.linux.dev>; Wed, 25 Jun 2025 07:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1750861930; x=1751466730; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Vaw6UAlGLmX5XnFTSQ9UINLTAG+KGTITiCt0APsbtY=;
        b=TQ1T/1OFXBLorYWCAXGxfcYUI9onXlDqum0vnizVBg0SjU/HrMkMNxSPTzk2i53hfC
         w550EtDRPJJTcYnl2TjhTfVlIpSKEGuyXcQczj3TYayjtOUIYwQvMEPQ37DWz19b7VYq
         ivFFfNjVgUgsS6k9EHYemeXb+X1LqE4CUHtrA8aONFWF9/lmuqKwSOQrnDIZZFf/n06v
         vgiy3BJAYR5Qz5+FRJqBf+09uFf5JVGm0JTYCULFrM0MoPuE5XKTTwf/CXhF8rPQ0kb3
         r703cLa2hoKk3Qt8DgPNOH1jZlCzRFNc1dBfxDlphJbUGuqDl2q1JujqSh9LlkSQRJca
         uwtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750861930; x=1751466730;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Vaw6UAlGLmX5XnFTSQ9UINLTAG+KGTITiCt0APsbtY=;
        b=aQaiqtJrVDH/grrUx5zNQbaEGsBqfW5hQcctho1/1USoTRT8y+TiuJne5xPOQmKTfd
         p7wnX2mrFGR7HHPKzUIlrrEw1earDkHSnJipPOKzZi7lQ+baYj/yrQ72BfPyGhsOcADd
         /FLJm9ZnmkBUxuK5qWGPdWXDDL+XKDnYLjdyUsZGu6w1OQMseGx62kOEItyXEH02TCeQ
         Qu9gkrQoadggTAMhPRF7aTAG5dPQJRT4kk2eHnGcwqyOUD4m0Sq+zoVc1bUak7+TKbYU
         h6S8EhYG0UfIWEipkvZk8mTDdEf3mlR/JyplNlDYpkczHOCCm3ZsCsw0CtydWMJVs97W
         CWBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUC7O3VIVjj/dYlIN87NmtA4lb7b7UQ3S6yj+9sCCB8c6P27K5hlwvrXbdWfbsHaAA4tp96GJEB@lists.linux.dev
X-Gm-Message-State: AOJu0Yxk2REWXwROt9au1y7R7EdoyWoj43ldVR32oFqbSZjkDeYciZyB
	tIGzpHGI45Y+X8r5kV4SulJVih3MfKE8Otyemalslmxt5sRRx2wTErQP//O9ucIW9xmAod147E+
	zWVWxWJm79J5i42b3lrmfejNl+C4I9dH3Y3JLfwvp6A==
X-Gm-Gg: ASbGncsz+0p0avCPMG8csPFxxl2QAXCimCuFISS+o4CMvwfb+3YwRnBrRa8BG1GJivt
	Zqvc07DOAJTESQM401Yfak/cfdHeNa2pSf2ad8orj7iRZQ9vg8fTPw5I3RG6YGCu3V1oOIz3VQ0
	wKbtMEMRj9QJ78tPtZpwfJHQuDesO9cOUvAeVSUPJGY14=
X-Google-Smtp-Source: AGHT+IF2FmBWl6hqQSw2dIMa/iN1L0L/HGqhMRXMl7b4jLmd44qi6m3OJaL1JIBpTME2CDDJL00MZsFOUSwKBfmsMZw=
X-Received: by 2002:a05:622a:1105:b0:4a6:bd99:5b30 with SMTP id
 d75a77b69052e-4a7c05f9cbdmr46296431cf.1.1750861929919; Wed, 25 Jun 2025
 07:32:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250624121426.466976226@linuxfoundation.org>
In-Reply-To: <20250624121426.466976226@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Wed, 25 Jun 2025 10:31:58 -0400
X-Gm-Features: Ac12FXwA-ei6dK0JEz1zZ0PaTcCEPi5wGhoiU2mqpDM_OzesGNEGCpdmM0EPskk
Message-ID: <CAOBMUvhnQ+ijRh839SUT4g0-y0zy0E_Nx65xpqOx1=2fF14nRg@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/413] 6.12.35-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 24, 2025 at 8:31=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.35 release.
> There are 413 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 26 Jun 2025 12:13:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.35-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Builds successfully.  Boots and works on qemu and Dell XPS 15 9520 w/
Intel Core i7-12600H

Tested-by: Brett Mastbergen <bmastbergen@ciq.com>

Thanks,
Brett
