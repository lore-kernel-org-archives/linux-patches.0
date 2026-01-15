Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86EE2DCF67
	for <patches@lists.linux.dev>; Thu, 15 Jan 2026 19:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768507148; cv=pass; b=l107U0RhtEfZin1otr6d+PEWWpkY6ltaTSUjPOb4Oe/BVlhAoYKw0kaAC0HqbsmBP6ITlMmONnko5CWQWObFxgTArumJP7xbCshcQJ17AaWHg3HaJR2ZB/gQa5kma9EgzFDWtP1WpzMBhEZjwzae4IszgNInKtYnmpajXgWtUZA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768507148; c=relaxed/simple;
	bh=HXGIPiUmMYQmAggMXf6TofPVJ08G0qCff1lEJIB0dYo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VlFnIh0aRBfvlVnssYHCp+A8vYeUuBC3hd88ouBy5FXGaHkdsq61oZuyRaSlhGc3Fd8YB0jF10drS9bAKOy1Dg/k/ccbd4xuZR7oCgOAsJyrlpBAJKB9M8SuoEUt+QiR3eJT7TFRP8ftUbb1dOroIaJHerIde/t+2u8US2kXrbw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b=DQF0u0wW; arc=pass smtp.client-ip=74.125.224.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b="DQF0u0wW"
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-6446704997cso1160549d50.2
        for <patches@lists.linux.dev>; Thu, 15 Jan 2026 11:59:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768507146; cv=none;
        d=google.com; s=arc-20240605;
        b=fq0H9S20Nwn6ArJfgao9HGDYOkiEMYRCuWYoum/RKjq1gc4JuMdptGlcmcX7AJCiKY
         /BQvEUyB3nVJ1D8W3eqjWwB8FMOHBpVjiy63Whk5KRCH2RKpBCQh+u/dSuDsiVHB03Wu
         dfPRpvoAynr1CeY18qiaq/frVP2P4TTL4ZGO7f6uPw5jQAcv7mWFFe/ERs9J+6CSOwfU
         xA5wNlePyfckBPc72PMVSG1F1S//Lqod4ue1I7djrPIIJGf70vekVebuKYpF6O7iTJaQ
         V9Ck0npQXA/1YdlFJpVgSNm+LT2erL+oY1Pm+BbdjLzJUgTldMLa6N0TQfIo6pU12NrZ
         kfhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yXy7cxDSk38KdQZVKqqCXFFDHkqTX+DHgbZccBbsdPI=;
        fh=3aNv4kG5FSwg3S0LdjsmRIzTBzhMBenTntC2TdTMug8=;
        b=hNVKT+Z42JYqNiwSWcF4m3LuQ4R9VN0nBUJbsB8DwkBTRAxlM6m1+QvvlnDKMHEziO
         OWA1e4RbWABi8I4YEKvxgU4ePXDW/qn/oFtvXB9Zscbz/UUdBCRjv5q0nz2FM2RBIrTU
         YfptkhtD2u57UUjHitmHOGnaDe/hF6Lfmv2rSy8vqj4HVzOfSHKAgOMa2beiWo29YqhZ
         /a0zeY/h4BuOSzsV0roobSF8iIs0rQukdyL7KeYK2c8Oldd/ga2lOe4CLS+4duUjbFGI
         M0AuwLoLwrKbtDpzkgOgW7hbDWBXiD1hpFJxBQvWYt0WJyJD1OWfQjChJ34e5NJV8V94
         ISIQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.com; s=google; t=1768507146; x=1769111946; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yXy7cxDSk38KdQZVKqqCXFFDHkqTX+DHgbZccBbsdPI=;
        b=DQF0u0wWfjzEge4zbPhQy22rNUSxhVV60TCfi1c07jL5L6v4L72sWgKikWIPIYSA0Y
         L77rHGj6g0YF4kvj3g2wpDccDGk8YaNvK5Zm6Ysbwdm3taVT8TzN2KwGeWKQtY7TE4CC
         V+r+2BV+2kJd3nNRTi2S1ic0h4KflHFN0ER+79vVa/j6g1zgQsrYnyKKySBKXqbJYfJw
         WhAA2I+pk9P6AH5hbudC/h0sJ86fmD+E7mU4L+5dfNtWbl5dGotMvhbPxKu/89He/IZT
         do3tivk74hG0eJUpt473k1cFZCaR2dFyYxrw8yHfU9R90m6gVje83uNbuhb8ecz9E7qd
         R8uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768507146; x=1769111946;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yXy7cxDSk38KdQZVKqqCXFFDHkqTX+DHgbZccBbsdPI=;
        b=uyrAgyvzw9jdLAQiwiXReQ+HRs1Vh+NNm0gIEQNIn76ES0CB9J+LjuAGYCyJMWwBxT
         3GmxUZlr3iBS7s9hZ4ILD1g2QpdPkAVLPYhCBigAe86JoCZGvgpOzZMqHCRHoEtDPUod
         chZA4GQb21yE5rkzhqPgIKgF/IxeC2o3Vjc3pCTGcDgfh8fE2wyXFAWkJuZgt/vDeVan
         WOn4UbiR5jimIcy22i3lQJnwKnaYZnSpEMpiUaN1XRrmRLVISGCshCDDYPFgNYbORE5n
         uX9ThM2U8VWAhZDv6r64ImcNW6kgZ/LdFoR79A0LEnhPE669Ibt93Oq3/UvYHRwdUd4n
         G4vw==
X-Forwarded-Encrypted: i=1; AJvYcCXf/CO6yf/haDuoqSbrbU6lHMPGmrONbI26Wckf79GGQAceeNumoechmG5inLS3yd22sw6b4c7F@lists.linux.dev
X-Gm-Message-State: AOJu0YzJ9x4PkoUr+sXz6oboIEZEzGYAKMIlcalUJXDSUdq9p/EnR7p4
	OEnyCZDq+xhSwYfjo4bWgH+KppzDiN9RzQHOu0m95CVEpJXm2yYPY6j+KuX2AZ9HegMYuxmrlwX
	kVNkFuXPLyD0W5M5cl/9o120eO2VqrATeV+kHnRYJkl7DiklV54H9rQGQnrB9WTa+HMXaWsQ2+e
	XnALvpzn2m3eU2IrmGX7YokpU7MEi+
X-Gm-Gg: AY/fxX42yvkNDZId2n5TwRw0ZW4+mcbXl/1MSAxpLhFRWenhnqXQaxhqb6YCnnL2S5m
	PDjTN5iogJxJbsEKizvfi88nos+kMVs+C5gercKmuazKrj5A8OS5rL2MZRRJ1x86mlAExS6fTtL
	MCYHfsmjcv9IWYOp55LzHg/ZVVMZiHxFhJuyRF8O6vgbEqAWkys8r1gPVrTB6uOX4kwU6UKl57e
	wcBSm8hY5X3WhisMAGWbswJxG9z08Ep4m4w5ALaHEYFmLHAb3/wIsFa/EPZOjc4ffn+pln2eavk
	NFzKr7ZZcvsYvhB3e8PvNGEybbQi
X-Received: by 2002:a05:690e:1489:b0:644:28d2:a4a6 with SMTP id
 956f58d0204a3-649164f76dbmr755428d50.47.1768507145966; Thu, 15 Jan 2026
 11:59:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260115164151.948839306@linuxfoundation.org>
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
From: Slade Watkins <sr@sladewatkins.com>
Date: Thu, 15 Jan 2026 14:58:53 -0500
X-Gm-Features: AZwV_Qj9p_zyq9fwWehuhzXC_D4wMSqt5CiBCMOCDBZLq5Uff2KxmGCqN5SVaug
Message-ID: <CAMC4fzLz4JxDMyD6Jc8BG_DXTKPeKQ0TXDY4vx646D1_UV_r9A@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/119] 6.12.66-rc1 review
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

On Thu, Jan 15, 2026 at 12:01=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.66 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
> Anything received after that time might be too late.

6.12.66-rc1 built and run on my x86_64 test system (AMD Ryzen 9 9900X,
System76 thelio-mira-r4-n3). No errors or regressions.

Tested-by: Slade Watkins <sr@sladewatkins.com>

Thanks,
Slade
