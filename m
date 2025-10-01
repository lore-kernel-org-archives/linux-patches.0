Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768ACFC0A
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 13:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759325433; cv=none; b=ERzavWrPFqDio83BBkMdLtu0kJDaATRCS9doVs50e1J8gHrOVR4r25BlBsYBQ48e3zuWxqXU14fyg8NmRTqo0dSe52GHSprmEcknGz1jleVD6LHNxewoDxePt/PiDKwiIjWZ6Sx/QZ6cwXZs+INTGb0ba8gCtAi5B2oKEQJc44A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759325433; c=relaxed/simple;
	bh=SktQ3kOlhBAC2x3vmzqqiWJIKayZPjyxZa2VPO2W95s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=boRQalNEIRxJIgJlAC05yWXqM5KSgLRG2d2xA/dKUv6iLIe9QIIp0N732FuKycAl/MopWrPZAbgON/AuTLTJvzuUuHXWlzScGUeHlRsf3P25ZOKDHIYejzooiNlPy/zTSuqNNxCQp8vurklWEojWV2qU0SR04oW8WS8L0dPFQhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=NN1kv7uO; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="NN1kv7uO"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8572d7b2457so126022385a.1
        for <patches@lists.linux.dev>; Wed, 01 Oct 2025 06:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1759325430; x=1759930230; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YCwcUuDlR2HsB5Hk2ZIMgqVF/pdzyf7iXfwKEpkpRxM=;
        b=NN1kv7uOa2+rdvNNnlTWlNw2OWeqj9xT9LDiCkszKpqzujkwy0EMVfT1GDvDJ0TnYO
         IvaoF1sUlJXfKa/0+KRgbIhbr6Gc4JCLikLS4JM4UhPpGZrJRglTwuC7NJJK5i5VgHzL
         P8qoDq6wQxcymEGyZkbojbZJKLsbEBS8XcFoa8Of2AR9MCAVddGFKcH/LBSc2Iuon7Wv
         1hpBt5ebf7CXW2r2TV92sFIKLwx3CFuhi8FzcZ6qbGtueM3gUXoqmERM9MPDlMt5QuOQ
         BujMd5iGxbCXRlRqYxJnX/8n3UcCytxeJjdo0KZbMSLz5lACSVJvz4EIbYcX75pqpd3o
         67IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759325430; x=1759930230;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YCwcUuDlR2HsB5Hk2ZIMgqVF/pdzyf7iXfwKEpkpRxM=;
        b=m2iybClqAgGJT7nRhTuGXLG3S71fycRARuzt7rwlvYR84wwV1kccBWSVtBJ7fSLrdD
         ObnqStSmRSkaz0JNod52HVTKPsCutFsgVaWupLinupFfQvvegcXthWbRlf2JYNWANHrm
         w89pE1Tsn2FtK6HeKz6SaneHUg4FTVKkvTovtvgvRNxYvbCFg/Fz14O0c684B6UUYzjS
         pTYr56tbbQa0Gz7fucQFhO1CRe6c1QgX2IgZwMa4RXnzhfPsKhUBL16A08eCpEur5rZs
         k5TjJh+QyP7tZRmrkGV4ULJm9xKt3VnpbyJ4oEud1w7VgXdTszSRpy/MpyB9nEqmoxSH
         8uAA==
X-Forwarded-Encrypted: i=1; AJvYcCWiPL5wbcq2Y5M6p3lSCGKp3M+rryqBZfQ1Q8pH81OyMrNYR3EPLFyg+sntipivG7tbTArRluAu@lists.linux.dev
X-Gm-Message-State: AOJu0YxPMmhWcOmThKrNosAp0NDXhIZHcba/8jsClCZm5EuQ+HipdWsY
	qQ06aLQ3YqFRhasFy+/TcmpnL7KlotfVd3YXg9BZ9DKXzFTH+S7ny2sZIYW0Bgiao+DGhM+IdQ9
	fFOTWyKK14A7PLzTXUcZRMKpvwYeGbi/5YA6Glt5b8fA+ywWxEk9Q5sinJw==
X-Gm-Gg: ASbGncsD6QEv/guAB0QJtqypaG1/XwbIWHk3jy/gGBCKtbCzELuP8sWc2UEUVk9YqCL
	OeRc57rOumWT+Xzp2tmZzUQuAlflz4uIFLF8uZ0f1AKb4QmNj0VDfKo4ivQ3a2kVm8/zjCswYd6
	ABHkx4lXbe8ONNjta4h2J3mkPn+Uk7hwwK9a0vyWjI9PR5b4PuMW6JfWYB9oN+xlhQ2Ttvv+0t1
	2Pt4pYqyGS3ljb4dcS64h52ldycdPDd
X-Google-Smtp-Source: AGHT+IFMFqctsC/gdxMYa79bTEHX3fAs8ipIL5VVoN11C3E29xDno2ZFwjrwO6xWIEz3lEpIgS6pt5gaKnnHsGAh2P4=
X-Received: by 2002:a05:620a:4508:b0:84f:8eb3:9648 with SMTP id
 af79cd13be357-86ee226f9b2mr1216961185a.36.1759325430066; Wed, 01 Oct 2025
 06:30:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250930143821.852512002@linuxfoundation.org>
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Wed, 1 Oct 2025 09:30:18 -0400
X-Gm-Features: AS18NWDMzWRD62Q2toC84MiLOfA3LeeQx4tD34WUJj7d19lC0jxZJv7F6icp5OE
Message-ID: <CAOBMUviHCYvHce4qoy_WXNK1tragYg2k5DbgpAxy_1dk3YtD=w@mail.gmail.com>
Subject: Re: [PATCH 6.12 00/89] 6.12.50-rc1 review
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

On Tue, Sep 30, 2025 at 11:27=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.50 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.50-rc1.gz
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
