Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7FC3859C7
	for <patches@lists.linux.dev>; Wed, 25 Feb 2026 23:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772063388; cv=pass; b=MvmMX3Y7VqSlzwi+0Qhz1rbHOlj5oBxAEZK95t5z6azUS3oDQi8h2pfCSe4O6ljakKSoHr0c62SZD9ZvPNJIAn3pqAy5H5qSfDQug+ZL1qT/G/OtIhWXb8ldh0bZIE5We5pMAXFJ8FqqhEHBWS3cDqEx/A2FO2Wl6akwrkbVvE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772063388; c=relaxed/simple;
	bh=O34avBaODu+8VDGPBSXMcJ3k14OqcHx2ReLTo7Qqoys=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d6gRQF5IgQmLbagkE3tC6hPrL0UiA1u2XuI8+t9y0H4eFUgGVlHnKZ8v3ial+0sMPHjiECf5u6YfHtsvSX6a5L2hZG3241tVoH9zqWWyX8LFCJGTbSaO9aCv6l73vaPq/jM/S+p8smM0JHqYgjtHRxkFAMMnY4Sml+epGx2cO7E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=W/nxev/Z; arc=pass smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="W/nxev/Z"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-899b676b5d2so3556746d6.1
        for <patches@lists.linux.dev>; Wed, 25 Feb 2026 15:49:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772063386; cv=none;
        d=google.com; s=arc-20240605;
        b=NIVfYfBMAwSrD6ffXym2t27B83oBPW7dXyRfHrwVVmgGdeHloF+sOvpYCB5u0pZN2k
         NJoQWQnJJuDQEKGljMc/IKSXWtsEtZa1XyGdRVhOZYScgnrWRS/oLeav8QjTDqsLdMnb
         7PTeD80J8KV6tGJhkvKsW1mM4A4l5PrtxLe6deZzEaBpjEawnmpb1QoC30CvvQ8YZCLb
         w7diEUd6BTaHuNkSHYreax2DtKZnDNyyRo/YlIGCe/hL9E+WjMJG3Ur2wcXdnFCdTTRJ
         1juFiy4pAosFVwn2Yo181a6VBIVN/JzlQEvoSzD/ba0Ly9Y/6SRYQYmJWRB3uc06JUDa
         hz7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7/VkhlzMD6DGWoME1jale0+nAQrLb0QhvAu1GVkq1EU=;
        fh=xR6vhZs3ICR1Gyqg1Rr2A4PGY4eIT+BqJepCpMY7oZ0=;
        b=PLpYfnNVOBM2CME9PR1TlcSYRvEBcwjJDUbIOm9Yeml3DY1BgSSOiCVgTfqPOMCNwO
         okuvJaBblfsDVZFrD/qVe2M7wjiSTqg39eBpKISp9aZ8Yq9LNgC347FzZJDeb+Fnkbg0
         NkcF2kAkGQjVYOFjEjw2l23l8NzEyrtrEatncWmEJGtpRMCSLUUUlFAbIppPYL3U4TAb
         R2FPamNucaIJAvSOAA2BXww0Dv3aX4H8HNKrprgx2OTo5iojJFXOTTmYLOTOPVE/ICtK
         oRXA4Sbg5pQOc7PBnDUYDI1Z7yz7ZHWEt4eACvNxfM60564s8Ni5hCApyJXiSdYUIglu
         thOw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1772063386; x=1772668186; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7/VkhlzMD6DGWoME1jale0+nAQrLb0QhvAu1GVkq1EU=;
        b=W/nxev/ZwasAorHD+PZ6CKMHxPY7lf7+5+qxiGND7D6nQoQKQGbTGfVU0F3dB7Q1M+
         eV91XGVCZoGG1AlA/tbADReJ0IclCAQ0bMr7k+7pDLgLoStvTB5GMNyw8sADHcXi63AS
         3AARxHkPJkuGEoJkOkSWDYb9i0UCC4CXfooXVIc3BEErFFveNZalAKEqoD95JIDyI4TY
         vFpTGbhw5noe4Ew38JmqqGWDH3Lu0qurNO9Zmdv2PPmo6u0p2bu1LHoqSZsX9VI53RZq
         cmCVIJnume4RCzS6UHyLR/wABvF9asrgcZtRZ2lKl3VvE/FDpbUmG7HOqd9Cm5qi8kIr
         iZ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772063386; x=1772668186;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7/VkhlzMD6DGWoME1jale0+nAQrLb0QhvAu1GVkq1EU=;
        b=DcTjX676GmYROv0G7Ad+EjpG3+YtBYE1Pv9S/ac+FkBHW/v4hCou+uk3dn5Bc6GF4j
         rPxPOx1WUh6qCBUWm0ETMx1Bv24ViwGAGnkhBnrRXG7yYTIQ5wEi0UoDitCdOcTvcGtI
         qMRD6PD7FVxceFLSf6ftQcuU8euRHU79/H8WzGENHYDrHn4vVzXjMgNpfwwtYcWGKB78
         ePgmlilITsYiaVTlgAalQR99gHZpZHT5u/ScQnvaMQT3bNaPFxjmM3AX6uIRZ+3JszR5
         cRTGN5QKi4CRXvW/rzIWO4DUg2cFfE8rgSXQioBIctirDk3sQz4t3xO4ytPMROVAEW9r
         E5+g==
X-Forwarded-Encrypted: i=1; AJvYcCVTX3Q47a0eCF0PYlS4GO7tTLr9HZ5wci7kIV5fwDTuD5FcVG0D7386nUj7jurX7pssYqnSFqst@lists.linux.dev
X-Gm-Message-State: AOJu0Yw2O0DY/EqVgpR7Gm57rXwE7LiEQNdbl7rvINZOel2Goz6yyP6V
	d38o/jujnZXfZzCGS2jLQNoX9aY0FKI55yo7XCMSHEoYQ/GboSKYybSXz8DYpx7GZh3wmcmNDmD
	wOqPfO3xn9YqWmKr/uewXsvAB1V6WO3ElmQ/9n8CS9g==
X-Gm-Gg: ATEYQzxWPdw639MewDv1/o0apG+wBG/AYUHuofEgdaGVuPTSeaSPU0fuI1H0+JqO6qQ
	lphuHj4TtgFon5zz4ZPdFfmxr5PdF2UTb2V7hnlf4Ryj4uoSUSXsLzGoB7TfG7xVm3xtl23IuAy
	yASevYMcfpgG2TJlCIQ8jep/6yW6aw1TliVdTD09BwGH0S3htJGxzuC83ud4tGGG/M9wpIP/DN/
	cIXaFfb0WGo0KH6uk4/pIRkfxJ6C+GpSIx9f6Aif8b1FkBa1G5Qb3GByhfC4+ZDN+klTUHu3MUp
	eOzO/xUHKTauIP+sYT8YCCr3Ap6lh/7F4rewqqAo4A==
X-Received: by 2002:a05:6214:508a:b0:88a:589b:5db5 with SMTP id
 6a1803df08f44-899c12613a3mr32829836d6.0.1772063386278; Wed, 25 Feb 2026
 15:49:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260225155341.094945851@linuxfoundation.org>
In-Reply-To: <20260225155341.094945851@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Wed, 25 Feb 2026 18:49:33 -0500
X-Gm-Features: AaiRm525TY0ZiOc_VdSE2OAeJjHmYCRhHh9Jcqrsk89dOJ1vpmn9GB-Cf-ZsvrE
Message-ID: <CAOBMUviRRVom_5fvqacAzkqBHsXz1gDa5-2a3HnT2nE_rhu5KA@mail.gmail.com>
Subject: Re: [PATCH 6.19 000/781] 6.19.4-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 25, 2026 at 11:16=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.19.4 release.
> There are 781 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 27 Feb 2026 15:52:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.19.4-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Builds successfully.  Boots and works on qemu and Intel Core i7-10810U

Tested-by: Brett Mastbergen <bmastbergen@ciq.com>

Thanks,
Brett
