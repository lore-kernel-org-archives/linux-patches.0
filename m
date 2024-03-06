Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3791B134721;
	Wed,  6 Mar 2024 14:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709736974; cv=none; b=VKXHZfXUshtV3B3ywiGCX1e4S0aWvE8/BFV5mxHd+R8CJK89DIZ4MdahxMccLidtODhSWdO1eXhiv/fGfqpufDHC0gdsUlbZmo1e/6mjLPzKPuKJG4wBx63J2jS3uFT8+Kh+Qh9F54zk2Ff84UJA3ygKDzo+RpbNWlidgPhrIls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709736974; c=relaxed/simple;
	bh=CyxIq1hc0Pg4DlvLuQjoD77rmVt1bi1Xy2iXBKgigWk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CC2FTeQrjC+rmvDReyiNzi5ExdzOG4vFVnWhIHvrhvBpV7YaN/n4zKuF1ljLLt7o1vnH+jCFtXxlqApzgQ1E1wBLuFnlZ1JsVhvbRqfd8AxDKnHVibH51nLKRy++xiaAa3PLFTWSkQ6wo+2Vt+MMXodQd/fmiT0/ODjr9O6v6h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OoqWYC1f; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OoqWYC1f"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-29abd02d0d9so4594976a91.0;
        Wed, 06 Mar 2024 06:56:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709736972; x=1710341772; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qdH3H/B03w3oeOKNshM2umjOgNwIvpOsc9RqYT8vJJI=;
        b=OoqWYC1f67gysfCuc082Kyia4z90wZBZ70UyQyMhNPzWo2twARbkOxdM8Zrbl0SJNV
         hx2qq773rK/UYfqOZUTkIQlxWwgBNA2wOARdTTr6SUrhDTgwEVGkF3Wv7/MSn4P4TnmC
         IX8dhy+1fba9WKHFyRwhNVIqtqwWK3xatSbApaMBRFB6R6ADQ7Jn0Jn9EAMjS3vMzd9W
         iBQ2KT7VNFgil+XsyewUSQOmnnwK7lCdQEVpLF2FV3cVX+zSWfWilhm4hJntcrAKCu8Q
         Bf2zhQD/ahCyG0Z8LktMTm5p8ipv/JV/ZNcGokdVirGz/dOcg6HaY00NrI7pnBqTJjJ5
         7cmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709736972; x=1710341772;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qdH3H/B03w3oeOKNshM2umjOgNwIvpOsc9RqYT8vJJI=;
        b=ueQ7iw1rXWxlS1CgBrRy6x7gdLm82yHL6XYs9ChSUtr15uQEnT3LN6wR/Ll1KJEadV
         V5Pd0SRrrYe1sd3bhm3SnAoVbXU2O9lpef3GciGZivb0tCDYuEEUaF2xwB3j9QFCf6tK
         smwQsTHw/Nzo6ts6nxUEmvScq1QwupQklYLVsoQFEmZgtx3Aavjwz6Fk4zO+4m/LArEo
         gCmoNX83jgR3DNCjTGJ2YMi4qBIvjXYlCkeF1UJFcJHg8jrVV81mXQfL9VlcA7ar98VR
         YfCycPa4S940dJHkaSuWauNiPfG9FM5kgL1hHvBCUiy/Q2eygGm9DH9YuhqSF4pLchGd
         /Uog==
X-Forwarded-Encrypted: i=1; AJvYcCVo2RBv7KIQ30w9SxJ9lF1ZzpovRXj5vK63yA3Pv2/gTKn78oxoPN/LjgyxaOGXmTIDhp4wC+qPR2f0bNksgcP9NiSuTQPn0EE6/rcYE8kE5x5Aku8DJzPc0Nmkbmv1
X-Gm-Message-State: AOJu0Yy0Uw3fQZqzQ53I4wZOSDAWloNqHSq+r3t1JQRNZv/Zb1mi2kkL
	zf6BlrzrqQyEBSYkN0QPLcQlndbJu7l4H/yNGtzZSMD0BgiSUmvZZlx1cJMI9Yk/ul7Yo5tXrkM
	zeRp6qzo94VwR2o8iQEgY9p9k0xQ=
X-Google-Smtp-Source: AGHT+IE1Ifk2gRIsxJGsFMox+naGDQZbZsHvmMPliQl1ubSLocfF/8HdJ7TMoRwN8u/u/pDBMuXVrz0M0siJ9kYinmM=
X-Received: by 2002:a17:90a:d514:b0:299:782e:25b0 with SMTP id
 t20-20020a17090ad51400b00299782e25b0mr12209886pju.8.1709736972572; Wed, 06
 Mar 2024 06:56:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240304211551.833500257@linuxfoundation.org> <20240304224813.73380-1-sj@kernel.org>
 <CADo9pHi0az-CL_hktmpCVcuoiDaUJn2U208=TwAvBM6YQhfFqw@mail.gmail.com> <2024030653-reforest-gauze-149e@gregkh>
In-Reply-To: <2024030653-reforest-gauze-149e@gregkh>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Wed, 6 Mar 2024 15:56:00 +0100
Message-ID: <CADo9pHi--q0XrROk=NXkf+YBHkj6s3JsWKpJgMJU5judaJrKwg@mail.gmail.com>
Subject: Re: [PATCH 6.7 000/162] 6.7.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: SeongJae Park <sj@kernel.org>, stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Den ons 6 mars 2024 kl 15:52 skrev Greg Kroah-Hartman
<gregkh@linuxfoundation.org>:
>
> On Tue, Mar 05, 2024 at 12:05:33AM +0100, Luna Jernberg wrote:
> > Works fine on my Arch Linux desktop with model name    : AMD Ryzen 5
> > 5600 6-Core Processor
> > after the Arch Linux manual intervention for new mkinitcpio settings
> > and version in Arch
> >
> > Tested by: Luna Jernberg <droidbittin@gmail.com>
>
> Nit, this should be "Tested-by:" without the ' ', otherwise our tools
> will not pick this up.
>
> thanks,
>
> greg k-h

Alright resent the emails with the right tag format
sorry for the trouble
