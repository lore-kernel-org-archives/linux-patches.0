Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CF219580B
	for <patches@lists.linux.dev>; Tue,  8 Apr 2025 22:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744152164; cv=none; b=ipQgrfPfnl5Nj0KLz/BOItePBRF4yd6dtpthm9Q0W2S7xLek+VmHkquq1ignJ0CnzTumelnTHDvI9o8pzr7Kcsz6bp3N2oAh26UcdO2N0tnmrwvsY4hstT1DkPnLnp1XXw/Sxe4qxFLXuX1oNnAz+4JhkC3tAK4IlDm3hDdVaA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744152164; c=relaxed/simple;
	bh=VvOE2r3DtdBAe8IWcDaWLBTTphQj9Rjj5bt89NIvxfM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GlKLiO3F0exca3Yed7SDxftqAxXSPAkTZ9+iBhJAtzQQSII5A/8Bb+KwhW3NfpsjooB8aEeh4vn/AUeZ6D/YmnAM3ZQ8OAnwIf+HNkzDR2tFXo6nVrysRb8ka9zqnhVzfqwg4yfxHMx2s9lqPLBvHihKoathxm50+WMd0VXdWPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=B8uJgAa3; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="B8uJgAa3"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43d04dc73b7so65190135e9.3
        for <patches@lists.linux.dev>; Tue, 08 Apr 2025 15:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1744152161; x=1744756961; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cVrsX/RC2oFN8Uzy2xhFPNyhEXxy3W34iQYpN21V0sw=;
        b=B8uJgAa33LALSPuDjQ5IKUO72V9/p94tNZNaCIres4OUyT5z3qkfTlU72OjMF19mah
         15MUYGGW1BdMXpzgB9zx0wuUfS5jc3pxL5RDjAIdnN4zUvt9CEF/oMw30OtCySGgiGxP
         la7XwCy+EBWg4CXlK2w/EWasbjxMfI7+Te2dj27U5wKGXPOz9PrGWL7zanntR0UkMN71
         PTp2Nr2PzDp+QVbYRa3LjEdSrWAgACfIs3kDyoklkJYbh4VAHdp7RwzFQpMAehd8PQWv
         hgLejlkd57yQQwYBwg1aFK7UyxgMnw2E6crhNDTVJN2PS3hGe1ruggoU8Mfd4mW8GRRX
         NtZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744152161; x=1744756961;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cVrsX/RC2oFN8Uzy2xhFPNyhEXxy3W34iQYpN21V0sw=;
        b=GzOkSD1hwK9gDo/1bAD/RzXq5Xr6x88PB+R/axs/LND3FP24taa4DbBPmHDOaux9qP
         7ioi7MsTO7cEdoDD9CG328Slog64uJTUVe1nW26UXa/pBwmPOFjVklP0Z5joz0Su0V6I
         dd/gDO5kXuNcPy2P8verOrIQ0K/4Fkhp5knzOlNwcVmY9HBaebcpRF4RKMRDcqf+kmCf
         SXabxa65nBuyQ3LUAwaBKyqI96Q8q04us6VDwjkwqLSwwLl0dikrU/1LIDrQSZ+gl/kQ
         LRnesSVeBuWrBgp6gO/xikb7gwczEq+BFu/lhtLR3QHbg6tGYLTBnJTbum3f1bITDlza
         gqCQ==
X-Gm-Message-State: AOJu0Yy2/2RK1WpMEjnl+tDZcUqobpicu+rTphNai1esq0060+Hw2TuF
	d20UqztA5ZIddboK+OKBVHjarbqT9JW7gBJuHO0bHQBeTJ5rtWw=
X-Gm-Gg: ASbGncsoUl28VX8UriRQvcP3An2eXZdzp+r7iZvBlCM6L7Ah2U79hjZt4DOATwwyNTr
	aX03oJKRTysBbnCktNkLifaxjHD292iQs7sArHgpvxnwf+/b5E4nNnX0iQ+rLD7ubcc57q5Ih2p
	1016Ok7Y1AUQ9JvjLKXa6TqHF6RPQ3bJFLVGXfPvsNZmrWiW/fjvMMXwTxqRgb+6Yi7lYwhXl+p
	0rj/rSZT5KRiVe0KlO3SuBHMGycao4BEaqnrXjixO8dLb5j/NYzlBKbQUO0+PZeYboW9GdTivgT
	UR+j65e7gNdDD1r1Z14VL4M2OIYrhu7JhZGRNAjIPIUDx8ym3KI3xop+VatCOzeEP6wNpBBHRUr
	JqqTupmZYzPYbnkcd07BMrwFOAq700wID
X-Google-Smtp-Source: AGHT+IEHm/LVYmhjkn2NZ+yNt7YdDBEtZNlPDop53WT6mMXLBhiVifJtxaaSv6mZb6Y23He6cKCvRQ==
X-Received: by 2002:a05:600c:1d94:b0:43c:f629:66f3 with SMTP id 5b1f17b1804b1-43f1ed0b0eamr6927825e9.18.1744152161210;
        Tue, 08 Apr 2025 15:42:41 -0700 (PDT)
Received: from [192.168.1.3] (p5b057de8.dip0.t-ipconnect.de. [91.5.125.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec34be2f4sm171797715e9.19.2025.04.08.15.42.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Apr 2025 15:42:40 -0700 (PDT)
Message-ID: <87dbc3c0-dc7f-4d0f-88a4-bacef81dc56a@googlemail.com>
Date: Wed, 9 Apr 2025 00:42:39 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.14 000/728] 6.14.2-rc3 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250408195232.204375459@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250408195232.204375459@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 08.04.2025 um 21:55 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.14.2 release.
> There are 728 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Just like rc2, rc3 builds, boots and works fine on my 2-socket Ivy Bridge Xeon E5-2697 v2 
server. No dmesg oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
