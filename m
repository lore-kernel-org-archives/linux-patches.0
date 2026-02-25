Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8B4285C9F
	for <patches@lists.linux.dev>; Wed, 25 Feb 2026 07:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772003117; cv=pass; b=uLurol9sURXSaXT61LDAu/+OJCTReKTbpoOG+lyYMQLaCTsTEO5tjpKWamGs7+bekVsCpAiBdTirmriblwCXImUYqdQtv1iaukS4mQfQjsu+kbXKxgGtBzpTniC/IIRgCIuEvwQTIe0gBs7R/vlr2/aTSWjd5EeK3EY47wB4Hb0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772003117; c=relaxed/simple;
	bh=/k02X8PaewizvlJgw/fQUp1hsa/3ik7+nBt9aGGxX2M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uqELWKJxWEgvhyuftShNkn7lt3tE66ODH09LC1GgYlybvEbfHH9lqJSHJtq4wt6dcQ0eMGr89o5O0VF9cBjA2Lsfc2gcEptkWz8/hIjsSziLaYvR+ogo045wEpTDVyQQQ64OFwQkiMRvEFHE+96aKQngByH3KIqmtw1Q+UtlB18=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=Ed1DEfXm; arc=pass smtp.client-ip=74.125.82.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="Ed1DEfXm"
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-126ea4b77adso7807538c88.1
        for <patches@lists.linux.dev>; Tue, 24 Feb 2026 23:05:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772003116; cv=none;
        d=google.com; s=arc-20240605;
        b=Rtqr9zTfm0fotFd1rIsChgIQG/Bg11LChvi62S8X4NxKTM5KuuHR0gVilp8o+XOIMI
         WooK8t8Wb//9ePVCazpHZlQqilK2HUCKsKyGMo/5aG5isFDUKxi3mEzPBzF85HyjYM2y
         /57QTxf4Z/gONl168a/OWcYDmqB+iGKmFRh4wGE2UdGOBbtf5fKX6cg0PA5HEgqOJySd
         KDBUcJbwofSCBHhXyZpB/KCVa3zvQofYth/dG3T5IzyDy58oY5LamIocBoDDpH3SXEbY
         IFD/xJFWGU05zIn3LCDV3996pgYZXOdfiloMQIFY/k9UPmxnKDAG7C05azdR6HIODLZa
         AMiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7TFbtURUgNYCS5/WPabeVvrWCG/zY7PV+Pugh1pyRdQ=;
        fh=IkIl2MzJEVoeHtqv4WDXzLk5TTDEi9e5QS71kl5lkyI=;
        b=lfvLl/5bVaaTgzAlQ2jB6JsfHZ9PpQi5wnq/RWxevQYiw+OMQV8N+32RIg6zocWNn7
         7962gLEjhuOy4LH9UDCaBgponthlE1y4GqCmcOAbXThfYJDZYh71Am3fyx4VlWJEr/z2
         mAOLlhvm6HcXHQuW6gM1HEFv/xApigpvI2X8jLbMVU/B/h6DXvn/aa34M56OYkTtvuO9
         0JC/olDVSXmVmAsT75/Hfu05sl7Z9TDkglLeuXmmsJTycf7zro0DK+DAZOJpIuBBCFl5
         9p83dvCH5gc5ugxs6KwsmnR9p/YKu+CFOJ2QmDr8QHkW+WS9kY1cr/o7q7Pl9sUTscQY
         2Plg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1772003116; x=1772607916; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7TFbtURUgNYCS5/WPabeVvrWCG/zY7PV+Pugh1pyRdQ=;
        b=Ed1DEfXm/BiSAttzDR4E1zbMmijCQnIO7RNGjpls8lgQuJ7MT6k//ekS2/f4ZpXslg
         UgB8Kgl/aBstzQcOYdsQ6W+ZISh1FeCQ+9Fc/SB2bCjBGac3FT+9Ef/lGUDDrkE/vCvO
         7TNU4k0hySUWuOsAQ7ABf3GcvWvWAWdx5MR6MF4zk5sz9T2WXLDWqL7+om44EK7Irrqz
         P0Mv9cgwBp241IizO2NsyVEbwmU7NGLdLSLXVqgBL6vasWAZhIZNkMBk0OCY9g///HHp
         X9EthkkiCjHn+IMm16eAlOOMq2i/0Z4xE2dhlVpFxuTavnQslmvSM2sMA4erk5BX/G52
         NY5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772003116; x=1772607916;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7TFbtURUgNYCS5/WPabeVvrWCG/zY7PV+Pugh1pyRdQ=;
        b=hPWA3LGX6ohBtRVtgdQNwsNqrR4Qa+MZ2ikN8hGIOBQYBVmS6J961x2pAKYLhn6ltq
         byexRd2gYZZwNULW35klJ24Myb2bFeqkJu8xnlAF2KceUVqPu7CWWt5kFVtxyAJAAHCe
         v61rwNeh79pfFKXsZL5HOahyjpXC06yZrXwuyscDP80QLjEKq13/oa34sz0rHHye7ZOq
         DxqhgyZjTwl0IOa0kRUR2FtTWcdph9o6oySRk1gkwZaLiD/+cU3Z657ygcTZttxXLYUz
         BB+hlbItqzqaEuf/GKDkfEU49FDI11tErGsq2I0d9VgwiiTshDwm4iitixVFfPw9uDd1
         hylw==
X-Forwarded-Encrypted: i=1; AJvYcCXUiIxs7Mms2WNkBvtsjjTzflpWY5jdU8ziO4Vvgg74ps8e0OZoU5LXPfbYThcBK5DKZT5+/3bs@lists.linux.dev
X-Gm-Message-State: AOJu0YxdeU6fB32tWgs1dixK9rzrgjS9pkni5eBbHBjRqHPww3gUlCUr
	sXEjPJ1aJx9mSvEPPZwM0wT6XV7uo+e4uJpwuiew58vlimJotD7i9ZNZUSzE56xB/aVWe0Ft8F6
	TSojDuP6oTeheoGmRaIP7ITWqwkWtUhiQMj6OQFf09Q==
X-Gm-Gg: ATEYQzyFM4un2K4xeJhEk59haDQahUwZJzPbR1Nt2+IpJDMbeIuFTW1xO/bHSrJroy0
	S2LJnHTrPtS0bgKmxfbBAhWfroP2IeYdf+G+/UN0pPFFafm5KnM54fckFkKcfGlHui8gIYllqvq
	elKoyx8D+fs8a2AINpJzgn4FBXGzBrLn/3QdoR3+oqB5O8vX9Gjw8UABizv4BdXCp+udKvNp5bc
	ITjSGK9s9wDKLIvhFx71Q7AxWo3883IrjAhWZjQfNa8yvWTmsuD9NRPqOO7bqqDhFrkrNLiffxd
	AmUk9wwMqd94J7p13hVc4ciy73vUKLV0V5PF1vIj
X-Received: by 2002:a05:7022:2393:b0:11e:395:7dfc with SMTP id
 a92af1059eb24-1276ad1862emr6627438c88.28.1772003115532; Tue, 24 Feb 2026
 23:05:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260225012359.695468795@linuxfoundation.org>
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 25 Feb 2026 16:04:59 +0900
X-Gm-Features: AaiRm50tZLuddJ8DYu3vbB1Cq2ZxX5eSbN50zMadaSBbDd1MGNdy6MitJ2VBOZA
Message-ID: <CAKL4bV5cpxvJxFx31Pv4=rgXRvF1bcYjcHg8TORaanQRQptZdg@mail.gmail.com>
Subject: Re: [PATCH 6.19 000/781] 6.19.4-rc1 review
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

Hi Greg

On Wed, Feb 25, 2026 at 10:27=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.19.4 release.
> There are 781 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 27 Feb 2026 01:22:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.19.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.19.4-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.19.4-rc1rv-g88b880238ef8
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20260209, GNU ld (GNU
Binutils) 2.46) #1 SMP PREEMPT_DYNAMIC Wed Feb 25 15:32:50 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
