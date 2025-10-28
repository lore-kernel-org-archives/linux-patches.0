Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543BA30506C
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 10:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761648569; cv=none; b=h028XlCZ1jmA4rfYhSbmConc/YH/4iZMwSpchjy/p5mHMDgbmHCWOUErSycOpdjGUlsiHVEN4v2pATW1FbaL+E/4mi4g4nC50hweVtcAU8GjjeS8D/kwRZGcWtwgE//hwnEsk7DgMibONVAxSamfnzCebNo7o+b3WddDhrNQa6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761648569; c=relaxed/simple;
	bh=LfGgAPErQXeXoyFHe8PvWIEu71qn/w79FkU6l/R8Cto=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WzrBejciE4Ehl+zMtUICdw7qnBqImiYn3t7FkijXBOaMqd0R2hlSrNbqjfYIH9NOEAw3ODr82hqognYJhQC0u4IFbhAQGg3cqdmTOLj7BwR4Od72AW1DMdI6p+2vWDIje1amj08MRAd1cFASWYi443pQCtSqfjN6sBP7CuiU6fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=IkGJiVzU; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="IkGJiVzU"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-290c2b6a6c2so60726985ad.1
        for <patches@lists.linux.dev>; Tue, 28 Oct 2025 03:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1761648567; x=1762253367; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RyrXWow90L7YCheeS5gmaxrFltylHWAvgVWWr3hrODA=;
        b=IkGJiVzUDf+eOQwkDvHK4IW3BkxVDM6NtkB/2S5H7GcmO94UInjVmYLwdxbAzgkM72
         ADBtsR9o5ogwIDBX714rpe+dd+p4Gfo5KORYkmw+COx/Gpv8KpY81Qj3P/wQWBksiHBC
         jBNewyyEQeZRbezvOfhaBveGujHNUHOWyVzR0ZJyVnOWZTL55BaNNX22mJrMsFMzsnZM
         2kH7eA6C/k7v5ljReUh4cI1dbqTzvrjxayiMqV2kl2kHaCbihVpM0r9cuiba/aM9nmH8
         eyCCM+3pGnVQTj76Yoqksnuc2/x+Z8iVxmlkG6SIzppUtP/wzyyrPmSgZGc+jSpnCrBn
         iU3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761648567; x=1762253367;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RyrXWow90L7YCheeS5gmaxrFltylHWAvgVWWr3hrODA=;
        b=QAKGVhxFdCn4FUj+8uO7YaGyLO7o45yh5A3nfLhSPNPYccG939yCvMxrFynbwaRaWp
         /OAhdLVU3YBxp0pldqGuSQRYKXvTFofjlAUZMRkoM9NAJakIm/3RmdgIsTWK0UXKN5Ji
         UibyiaK+gcVxjNlIGiiSV4ewrtHW9USAV+Bz0HYfkstvVeOz5s2jacNyAbgc4HjyTfJe
         feaiG5WevBglp43SH4+wDbyd5rDwfBYZX1m2AOYcERXve1PCl2Q2I685uey9NWGcfgvN
         q+9rhp0k+lI7qbVcOPudf5K08aL5CHH9JsB8Qj/UlR5yffpfh3Z5R4QevSx93MtMa9t1
         5Njg==
X-Forwarded-Encrypted: i=1; AJvYcCV3DtNoGsEqUnxhbcnvyBPbIR2I/XxK4hpDapfN+Q5meU/EYYRuNFJqqwduo+7G7LVOgD+5QtlF@lists.linux.dev
X-Gm-Message-State: AOJu0Ywx9F9z7K8jqjJAJAgBNFvPhaTEV53/ID3dbj0XaxMMLhhgHhLH
	BvXwpct6fE0sdFRcmcw8ZWBie2B98nkckNatIrS+sV73/LbgQRYBTmbQ71io2ayJAYEJIEDNtDn
	Lzr0owUsOl27stI4JCHGHpEaQLxN3NTYvm99QuRfF7g==
X-Gm-Gg: ASbGncvH9KSNhN+rWeElqYYfTjvn6iWoQDCOpBC+7D3H3iMwj+/OmWqyoBi71J7p7qY
	Kc7kIBU7hTVVF6KBaFyPAO31XZbREu6tvjl4e5RU/qlkZ8CxeuVEMAI1Mg9/+TjCb1UH18nVdQc
	MW9k1E8nPyqUGhOsqqwF3rTiMylVjyFalnq3Vb3MucOcsgnOcYCmYWcGQuLko7VyAzbtzVLebGP
	A7YJmT1jVTEyHY4OcI1q7nNNy9GT3Ryb0Bq/wHWyRwd0YlU6gf4Tchk8BJatMhsGFQmF1QaUdjd
	457+jxbm3QnTwhkrJw==
X-Google-Smtp-Source: AGHT+IF3dhR4n5aqKeDp+Vo+LbBF2UMwZi7my529wiBD8hSsnjWc+zt+s30wJlDBzL40QuQ1+dCmkhZugs8gcsNfW9M=
X-Received: by 2002:a17:903:1249:b0:290:9934:fd04 with SMTP id
 d9443c01a7336-294cb4f2ff4mr35535735ad.28.1761648567248; Tue, 28 Oct 2025
 03:49:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251027183514.934710872@linuxfoundation.org>
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 28 Oct 2025 19:49:10 +0900
X-Gm-Features: AWmQ_bkjtaUA0BELjnw4P7h6Xptc718dXITNsaZ_Mm7C6-RhotK2D0-z3iB_A4s
Message-ID: <CAKL4bV7qVfhVdp=gDShvsjLY4g0asdhTmgsT2gj=FC_4c62pwg@mail.gmail.com>
Subject: Re: [PATCH 6.17 000/184] 6.17.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Tue, Oct 28, 2025 at 4:35=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.6 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.17.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.17.6-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.17.6-rc1rv-g10e3f8e671f7
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20250813, GNU ld (GNU
Binutils) 2.45.0) #1 SMP PREEMPT_DYNAMIC Tue Oct 28 19:19:34 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
