Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14951346760
	for <patches@lists.linux.dev>; Thu, 22 Jan 2026 15:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769094532; cv=pass; b=MDUwI5IAsm6bsEvm28oWfE4b07mIhBP7Qg/EnDDZwopO5It4D4jcvPwTrrdPcUhVRtfr4uRixhFySljlQYxSGrEuUa8LZPmfMcMgJ+KmEAoCUdFuUMKazFmwEC5MjqHtmnJCvm30d8FK2cXtd1zBeCkDf9ueDXE85YdDCSFVxys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769094532; c=relaxed/simple;
	bh=Tjz1n/liWX/J7KdtrkYCzQ0rqZb/v1/aI34XVwCKU9c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kCh76Yw8ZYTW18PHNxkEA/ekqlxeXkfw5/fMRCmekEKgckDu/h9gu4oG4jai6F2G4KfnZpschfYpc86iI/EMmyZjnUyfrqBchM5s5210t5tn0nWKb+9WjXJnKff4Lrno3WxD8xXgKo64C+8E48zRxQkcCMbozONVyQsA+m/WnQ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=gR1Oll4b; arc=pass smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="gR1Oll4b"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8c6d76b9145so127356985a.2
        for <patches@lists.linux.dev>; Thu, 22 Jan 2026 07:08:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769094530; cv=none;
        d=google.com; s=arc-20240605;
        b=O2I9v+zy/kWF6a5//WosyTtK+ca3aUHaweOIs8LzSZx+V3fGUlPBDQ5S6QeX5MDHL7
         y6KVspDBn8k1R8mBdgGfbRxsXXb3olwENe7FzEqbWVnZ6WhMhHuz2ipzstRO2WyNQTYS
         AjtdRJsbz/2ymqFNV0iIIVs8t4+/yRHOdU72OMNHgwItlxQFi1e4F08riV58rwLaEtzE
         a+IPoqO/ezQefgNI13SIfdngiZ8/b5lqhRkjc76OCV23eDHsEFjnJnbugADiDy3rl+Mx
         T+cTLdfc5VaO3MmTs1BV/Ml5UU53LXIW3QKWfbohlurAfvnonBtyU2H/BZZHWrBbH7DB
         V+wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=M7fCfJMtEJsZ0dKz/99h9B45j09tit05GszkZNosCtg=;
        fh=wLXxRhE0SZ0Wk+x8zUJJwhge3okEEspKjUW+fE9ug4c=;
        b=SMrHec8N0c4u2QqqGqHdFA7mK/zBFzEreYHrGuHctQVqdVpN4Zpfx99cNp+NQ688C+
         EMf5VMB3HpbYgnFjMsuzfJcrnr2gxW9jsJkMuNCqB25qxUlOKJ1CEyNKHuDNILnDLJp2
         YpXXwmMukzLPtky4ZvjnIPpyudEL/dM0rr069EB64EKgbZ4Utlx6umBobcTnPQJXC0Ga
         it28QNNaW2k4lo0KN/MB7dZQ1auyjBsQz9Uiy4+N/1r1bBJsoFqTiQjZdY0PxXczloGB
         WzIwqWNrd6VV3MgGqQMrVYCcWJdFsLaUEZPQn3RrP0THC3AKHat3UFBO3XzL1RcCn2oK
         dszQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1769094530; x=1769699330; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M7fCfJMtEJsZ0dKz/99h9B45j09tit05GszkZNosCtg=;
        b=gR1Oll4b5bMy7CdU/GXcCHOPa3vYjnGzvGqWceQLtMoCL/LUZwbHaFHrvaPdERwOQh
         aKBSv8wUOsAOFOJDp/LmuxMtrOeMG8SoA5WcoTUrxx1KtGHacDIiQVR+f1jd5MDEM9T4
         5iIVvmednaDIkTC2fCJ3hKZ9bFUTaiILtBdLrdVLbl6kd89BLsfgP432VjhcSFIQf5Jy
         HYgwhCVhdpRTWXheCkL5ueFfCmGrJvaDqLp/oNg5GXrNdryDZOTGcTtFSAdVkWQldbCi
         wB8HGYXAZBfwPBr2J9R62DoglV07N48OgL2+OCD9fDDAU/A5Z/yJYtf0AdvVZnKWRVCP
         8lbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769094530; x=1769699330;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=M7fCfJMtEJsZ0dKz/99h9B45j09tit05GszkZNosCtg=;
        b=paFgQ2PVTlnmS5i+flVryydwIl6Pom3qrKsc3EWKJ0QSLuWaFFbF+g/HXL3NQO7aux
         zAuzlrk+ts4+YyzVhg9i86uaElk+yTKN86Qa8y76czLTD8iGNEinE3rp1BncV1G/80aG
         KWwJ2miPVpcA+dAhq8WWLD0tWXMUGqOx4VwAo0e45kelMZVigrXf/S8OUrNb4nkn9oPG
         LDSrSeYOqMgogjlm9eCBb7AycX9q/RebGLG3CVlMtghTaWp1Ez0Zzhj1/wsnK1WN5m5U
         u6XIbUP4q0Tg/SUV0SlVFtbOTxgiHdyLM0uqQkCkjXyGsIIQW90wNru1t5/8fylg/rsB
         tMlw==
X-Forwarded-Encrypted: i=1; AJvYcCW9K+Uv+mT/cAYkw9MYcFoZT7gt5OsKDUFnAbGWwyjEEb0NcO/oKjJJ2ikUJpvSLuM2ubpDGcT3@lists.linux.dev
X-Gm-Message-State: AOJu0YxgR6RMBddaSgtrnluBEI7bcmgu+a0eIJtpJU48ajkAfYpAL5Bm
	6+OiPOSsV3XbIuax2SdQTb2MUq1DAT0kBNlq57QK4x7EYBqR4xanqi1QlD50S+wb3PFs9f9DH0R
	J17dA31eb0zY5IDTjx5B7I9wsS9bH7YJ3dCnhLB6BRA==
X-Gm-Gg: AZuq6aKlRbr34/UNGbCqrevECo/NmCHp+kJQ7o5BkE0Vy1V+Ud7+Jh7GQ2OVqpMFJw7
	mW2dMS5/KjZa9+oa3Oa31Q8NLbOrye8dSD7qlyugj8V7HzeWpeSfwOQbFmPVgVrq5k+ys18N7aU
	uGfffjK4TPyxeNKikYMczwF6jXMEO3ImHqUVrfOhqqqUvLFApRmE+Cl+sGpLM/YyA2F1MYPXrIy
	DKO/PxumbOLtF8yt1PqSQknue/vKv3AwY4/qdRuTaEUCaViFwtoa4uVYhKZGsctLauqucly
X-Received: by 2002:a05:620a:4152:b0:8c6:a3ed:2f65 with SMTP id
 af79cd13be357-8c6ccdbf53dmr1159034685a.23.1769094529672; Thu, 22 Jan 2026
 07:08:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260121181418.537774329@linuxfoundation.org>
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Thu, 22 Jan 2026 10:08:38 -0500
X-Gm-Features: AZwV_Qi2-KKtNqzQziNRTefvMrx5KYCaonZmcP-5tIIsASJajubPco-z2jiXGBA
Message-ID: <CAOBMUvj6Me7bfDGSGyaXMc+arHOgSEy9FazAy3_CB3n2t8DTrw@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/198] 6.18.7-rc1 review
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

On Wed, Jan 21, 2026 at 2:47=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.7 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 23 Jan 2026 18:13:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.18.y
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
