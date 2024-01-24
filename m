Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C436E627
	for <patches@lists.linux.dev>; Wed, 24 Jan 2024 00:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706055760; cv=none; b=ndzNdQB6dgc4J64jP8TG369Ri2OLr6p7y+hRv2kO0t+DBHiksmDFSsc6AdzafRzxUxo97zftHbCISBKj+bod/TpDZElKKHo4gbg49AolNnWAHfz+GwlpM3Gg9VWLmDvVBycdg5ftZT8mG1Vfw2xg0clP7aZak2xYPfXqNM47eDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706055760; c=relaxed/simple;
	bh=DJlfZwy5oG+ddPT+BAfbUa5jvLqlfyghhFKps3SyvX8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rkuVNi2zSP16TWPgvOt//tCZypWLPTGj3pH6l71PEXCaYKDEmHiv5YhrFljGH+Y9+UBENNxFsDv9U53xvS69xPn/8akXsx2KXAbsDMDxbCxZdCSJtwth+FM5mLmJkCdQxEJ09ERJGnhVMe1zVDg+wgxiSUxFkxHt7VO4AVOCUfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=HPB0FpAl; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="HPB0FpAl"
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-214917ed35aso564945fac.2
        for <patches@lists.linux.dev>; Tue, 23 Jan 2024 16:22:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1706055758; x=1706660558; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AsC4IZkrsCzp48Uq4gQMFalS4lpCTPnckc984N/Nfdk=;
        b=HPB0FpAl5sYnQJyGeIPtQW1Y4OdDU9elyFFObYGP61Vm/fZpMuozggLre8DE7MJFVE
         pbEFBGumaxeAKOao1KGrq47arH7t3ults2NcHgeTjxksRsT15/BsmzgNtioP83nAkYBZ
         dk6yYMWJ4ZQNTT3KMOAKZSA/cswIAvn3HgQME=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706055758; x=1706660558;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AsC4IZkrsCzp48Uq4gQMFalS4lpCTPnckc984N/Nfdk=;
        b=Rqc/KsDe5to+fmLPxREHG50BXg+ZSLqJmLk30jVc7vO3JbrGkxYqnTxqFgIJbste0z
         Jw0Nszt6EBjVG1S/mosrcrU3L7esVWc4X25CcD19YTPAm4wBBkS26jFVnkIThENKUn8e
         rGjDUuCgmaptmilbqneUxB1+H2l5RsRJ/Vb4OO7G4HO1YUQNGvPBKrSukHkr8PEiN7VM
         Age0HGhnPiKN5DKv1LkbHR/oIiDi3JMKwqk652fDybREBGlsIZjhVSZ3vrsASIiL/+rW
         H4X233YAig9R/5Y4jMuihVze9/plLgJxNlSYFJhzelx//e1tpw+LrdLKb7msEBC0+RAz
         +0PQ==
X-Gm-Message-State: AOJu0YwYnaPqPX4QmTVbDVu/GB8s29Z958AeK3+Q1XjW2GoZHoShXRkc
	IvOLwnP5ohHYmUiuVzRDahTkHiN/aUP6pVRRiHBqXWvYj/oTikG2ezUtUya1BA==
X-Google-Smtp-Source: AGHT+IF5j2CrNJpmt4xbjt5uNDLoyO8MNIxaA3XcNYGjI8dCmk2XJBy094kJqAM2+8lwjkq4d0k3bQ==
X-Received: by 2002:a05:6870:9693:b0:210:8c13:dbff with SMTP id o19-20020a056870969300b002108c13dbffmr2722563oaq.84.1706055757837;
        Tue, 23 Jan 2024 16:22:37 -0800 (PST)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id cp8-20020a056808358800b003bbe0c5195csm2404902oib.26.2024.01.23.16.22.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 16:22:37 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 23 Jan 2024 18:22:35 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.7 000/638] 6.7.2-rc2 review
Message-ID: <ZbBYS-i0uR08aEcL@fedora64.linuxtx.org>
References: <20240123174544.648088948@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240123174544.648088948@linuxfoundation.org>

On Tue, Jan 23, 2024 at 09:47:30AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.2 release.
> There are 638 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Jan 2024 17:44:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.2-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
