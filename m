Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7341331A43
	for <patches@lists.linux.dev>; Wed,  1 Apr 2026 15:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775059137; cv=pass; b=qF+stAaPZpOTzjM977H6ZQ7WK/5mM6kSCZuS6SNvvO24sX70/kbcnOb0VAlp5Yi9837AD2KvNOhVfCD361NrUMSp2lIDfff09bFU3A16vMORUrXKjSmny3gllGu7U9ncJHtE5RWfL9BbYNUEvICeiZ8KHs9+8FE23Ies6ISLaHw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775059137; c=relaxed/simple;
	bh=+SNyJtqnsHkXb/MqyOkimza1yNnqGZoQb7403XYFCqo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VQcumkC7OSmk3qSpdBG61jeMMPfK2Q4rSBEN/hlCm9TT605sF9UxT+1eJMS+tIAi+W247YmjQBIfzOgFQkkSdWB/sEqRRx0vUXyhei3A1RVTlxIy85to2Dvt326vGKhVcSKkW6zTH/50OndnXu1bri7pYApycCFq0NV/sSmJSlI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=hXaTqmiC; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="hXaTqmiC"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-66bd3d05e03so4626184a12.2
        for <patches@lists.linux.dev>; Wed, 01 Apr 2026 08:58:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775059134; cv=none;
        d=google.com; s=arc-20240605;
        b=aLoz1+M/GETAwd9mzsTGQwov/5MhAj0NHx+3lshe1aNtRRwLkGP3NPVNBZTfWDcOKl
         UqSvDynzbR8IDe94Bs6NRWzy9+8Mb4udZaVBZ6jahs6zOU6JqdoTFwhBBVuyLoXGjuYu
         qS1a5vaOh8xb4QtSyq/ijVnIxWoQRXtx52Hl7h8u2gSnTTwpHE9NSk0eK+ajNTHWuxSW
         5KShXqlAC65NiQMMQZ6jCfzd2B1t6cx7NkwYKPGqkJrMxzCO9jmfsXYLcNecJyVdEv8C
         6jcCMFuapycYqoe2hlYMhEs47c4yeBakMRIpLyHzJCsQFKbgf9eDlvarKaotl1n4iK+4
         0UzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ofZWgwy6iDaHBYYItk0VakheI0zjgXnoCfAl8Suh6U8=;
        fh=4j7yqLMvUX2wscUsK3WflHO8b8y/KOfnWoaBH0sIkHw=;
        b=gTxo3z2w8gWhvONi9ahwpzCcu01z9goDVjoIjoTgM5xZQe+aVQX7yUj3R1GDMTXG0y
         44EzKE1mEqT8zB0lAEqEZkiNDxgdxt9krsyjym8pCJzts9juIny7cqQkDpoFldHAvBZF
         PUM9D3VmeJH/5SHOS8DpdZbW/dnXhGh874WJR+08j+1W+h6bB59ZjKSnRaJ/wcIvH2Vt
         aQL1gbIAs8PAwk3ENxHXWIdLntF5vZohFLPXQKTKmjGwzes2iCcbny2YnnjwvR/1Hm3y
         2M2LIvas5VVGN+EvIof8IzVUTYXx36DEqjaNnUDrp/eAFxAPHG0EOib/cr4NicQC0ERQ
         nzgA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1775059134; x=1775663934; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ofZWgwy6iDaHBYYItk0VakheI0zjgXnoCfAl8Suh6U8=;
        b=hXaTqmiCaI7mxBEIcEs5u+npIC63cXrETOvlxoYojOjgxzXYekBfFCvJbwP8X+OS7c
         V2Jz2umVp7NAWDUXf2mhmDHZloEvFO3m6pEBLe15JM3ms9FPesMQbN8drgp9Xz8Pl7PN
         TBRICH+H81ksq2dnoq0Cs0DqQqUtArP8jKNHAy0Pc4d9rFZPgZmxQXLUSobL7nuOwDCE
         LdzXA5MsZsI9USCDwN5e723lGsL3DTWLGoTQ48OUq+gSS7nvZdvRJfC2F4r3jldlm6Vp
         4UX+YyBqW3fuw9r+cB8LEzXyI+QW62yEF8E0O16R9/s7gnw9us14rE1SyST8mk4MKTFu
         XDUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775059134; x=1775663934;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ofZWgwy6iDaHBYYItk0VakheI0zjgXnoCfAl8Suh6U8=;
        b=eeSO/OFAs6EujzGRINvEKDpXwsG9jJREX/4TZgBF8WP9Y0C5Df5apywb1FnVoEUdUs
         LKXypsi3MYwCoSNnp1n9R0meUTA1G8+GcXQpKTJWmlO24Rm5XfeiRt6giqlM0QMsm0Ls
         Pf0jNoaxfTUb6mcOW6JgBtuH8k+SqhqipZeH2MRejkOULrJgk7YBg2/5nlinhBur/pb5
         t936kTrdYw2w3aqQK2QRvjvrs+kCA3p+/KmV4mC1YZEjgWBw2Tv69YQEkUUUiPH91Dbe
         h+3Uq7OdPJX4tsZ2Aqcj4SJ7jCnC/fTguyea3iGD3NaDfZlXGQppX6kblyEOlI+M9Xop
         r11w==
X-Forwarded-Encrypted: i=1; AJvYcCV07N8r0WT17t9QjtnXKrDRIo9Q7EFdPpmjOhfQYpWBHPBfAcNUQ7mvP1h6HxhczN3cnzrtyER/@lists.linux.dev
X-Gm-Message-State: AOJu0YyKy/dA6eqqUPoLNx8rMDRlEOCgeZNiaMsudNzKUPbVjcf8t2Is
	I+nEGO3o9VZMVIAuQ86pPK+nojJ5+S/3ls1kKIVSVXXfukcfomMfauObygJO6+rdGzPqsFzdMvx
	g+UCKB07VYCPQ4daKUzJPTxFHcOiUCWD5nAKqbjo+OQ==
X-Gm-Gg: ATEYQzy6qk4tgLK9aCkzO5Zd/yZkxJ7QbrBWZHC7Z/L/tp3FThL9sAqSTn95LtLVeWr
	xQ40jnNRtA7aISHBJcEZuufHWXcV0TSqtX5KvL6uWmQzsfp/W3lGe37ct/oYDAVHsWg9s9gzC0l
	Vo12oQfCrG4oh6ANjvmFUFAuwDpVhOeIvzCU0nB6dEx7TSCPB0d5ZnA0ovwYlYcNkgEnWpakMjC
	n78o76VcNKlaZfUBxJk/9UPr5QTKgo02I4kkICxgespAODpHK0q13GQ3mw6+ocIOc+MCxepPXaG
	4OnKAtXzPVufpMWprt4lYiQPI+ucrfUfuO11tW4cbzaz96mlST0oV2pA9jmojWWg04JY
X-Received: by 2002:a17:907:a688:b0:b96:e593:fd32 with SMTP id
 a640c23a62f3a-b9c138e1fd1mr315996366b.12.1775059133943; Wed, 01 Apr 2026
 08:58:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260331161758.909578033@linuxfoundation.org>
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Wed, 1 Apr 2026 21:28:14 +0530
X-Gm-Features: AQROBzDKW8-Anb0EFwwtUyt6qA-W2aGf7GbHuxZGpnDMV6eYneZuJAyMWTsQiKw
Message-ID: <CAG=yYwm3YQ_yUFd_u5sQLYqMNnPP4uxcfuQT3vHJZVVZHjj+GQ@mail.gmail.com>
Subject: Re: [PATCH 6.19 000/342] 6.19.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

 hello,

$sudo dmesg -l err
[sudo] password for jeffrin:
[   11.985734] nouveau 0000:01:00.0: drm: failed to create ce channel, -22
[   33.336996] nouveau 0000:01:00.0: msvld: unable to load firmware data
[   33.337001] nouveau 0000:01:00.0: msvld: init failed, -19
[   33.366460] nouveau 0000:01:00.0: gr: TRAP ch 3 [007fb90000
gst-plugin-scan[1242]]
[   33.366485] nouveau 0000:01:00.0: gr: GPC0/PROP trap: 00000020
[RT_HEIGHT_OVERRUN] x = 48, y = 16, format = 37, storage type = 0
[   43.524931] nouveau 0000:01:00.0: msvld: unable to load firmware data
[   43.524937] nouveau 0000:01:00.0: msvld: init failed, -19
$



Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>


--
software engineer
rajagiri school of engineering and technology
