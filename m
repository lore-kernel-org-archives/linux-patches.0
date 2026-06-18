Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2D12EE262
	for <patches@lists.linux.dev>; Thu, 18 Jun 2026 02:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781749332; cv=pass; b=APRBdv+Z+1VwfFKneUpB3ikCFiFyADrvEt3dJheczNrLn7rRH3zM+jEir9sBtOY2pGK2UWhg5KFOm2A3yKqiqyiB4gQfKb+EUBo2EKbTdzVyZOezjasPSZm8U/3upsikhHlWS2eVOUvdU/AG6nhFQY/9W0gKW2ThCuL1yDBsjPg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781749332; c=relaxed/simple;
	bh=r6nGsSKBwNQZdHsTVUpLiXtBJUYztA0m6qq/c+j5McM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PTD/fHx/siavjMskFYjHWTYVJeptgsqz3cV/rOvsWqXM1XkSbSw3jglCsTzjWGWv4wDgN5hbASz4X9h5x3kh9BwHsjyOETG0HueB7qRmLBICB18RqauvfT1s+mljuRy/8pk1r9+Sd+WhioqPrGuvcizuy2SN2E9TNJnBMdr4Ewg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pkzpVgTj; arc=pass smtp.client-ip=74.125.82.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pkzpVgTj"
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-1370417c01cso659423c88.1
        for <patches@lists.linux.dev>; Wed, 17 Jun 2026 19:22:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781749330; cv=none;
        d=google.com; s=arc-20240605;
        b=UkXehufFjemfJhuOBh/ZCw4EyVNNHeCGDSq6IbYe+GGXE8AtwK052UEO8VPYUCV0gg
         v9zo1PerooGa9odrNUBfzwmwf8SQKNUJy9G/lk/M8hRITUXbTu+mxIPMJpNJNPkYbodN
         LQcjgW2jbQ89RMbQ2AX3ItlDxp/nR7/LWHLU/SOIE/xzxAhUmGb+9Qz1DW8v4+tIUWWg
         cgdaZTSkhWBReardaLA1x9ZLsC+S4Jiauwg+arHtGqJAlCMxbsdRU3vXq0FzGbR/QvdW
         8deqjwAtoPRslQbN1T4dVq6htFOop8atwhC3QoXT1+IZmw+NUkRJntOHCYVXRlbDN9mE
         EOKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6BhtNKXQbB9g+x/H4y1Xpyn02WNds6Z9fb6W/0gEDz4=;
        fh=Try3HqoowEjdsaomz3U35T7qgVafEuylPLjU8X0pItg=;
        b=aDGze0xxrjl2QKbQEuUEERL+7IBN2dpx/6QwooYJ4seByKxF3JENtQ/5Yq23RphZwt
         V1eZBUsBGRoNNtjA1gY49Pdb0n1TqLZUxLAgfS/uZuemhJ6r++zW5VQWRVLJwUzS14x0
         vsgslZBfU1vUlCAa7Af4GCLZimNTe9FN3F146xqx03e65tOwJmQCt6D1x5xOyFI/RvSe
         UwRzagGiv9GPLrGE1FWPLmp7omRHUfSNJgiGar+4xvU03zLD/0lNx+li88ICTrZK41yx
         4TRpqHVLXQdbQj4/+id+16yjInRhiNsLtSfXnGA3bbsbWAFJW2hZmfZ2RgNlJfK/he+V
         6YaA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781749330; x=1782354130; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6BhtNKXQbB9g+x/H4y1Xpyn02WNds6Z9fb6W/0gEDz4=;
        b=pkzpVgTjKahJS2SW6q4e9CXS4sdEstOhbudDPMEvaOLQpgSIemF5yrXlJyagRpbJx2
         nc/rE18HEeaFtzv4n55lE51jqfUya9lcR7w0evaeplzg+J3tpWg5ivZiWSX73jylCtOj
         ch3ri/2ctIv7cNaZsGgOMEJjBvLEjOwzWwK9OF2t/L2nEhd+/OAWqpRwmUCEJ7NAPlOf
         apbIdQ9pbNADIhWdM40EWxgkXLevngDBRvB6cIpNq1bMhuGjdvQGvPsSiX8my4qwljLJ
         5NLvPJMh1ukLigDTx/6R6+Fgun7W8XqHZ7jcP8Nqr6PHHdon/rA1TDR9BbsdG46XwoD2
         PZsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781749330; x=1782354130;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6BhtNKXQbB9g+x/H4y1Xpyn02WNds6Z9fb6W/0gEDz4=;
        b=DWN5lM8CeF5FB+WiNNhlnaDxdZld2h0or7r4WHxUq96MnP5cRsHucwoRMpWCFkFcCz
         OnyJBfZJ0cn8Yt2kBDByra89Ikbw3wj/K1szWr2y6r9eta7lPDrteciSzSQKC9BMlDwr
         lMzUx/w40ojrzom8c0SPGZy+TZk0V2rxgvwQzxinL3WdViZYiBXoK9+oHoyxWann2sfs
         Ks6O+21WXhxoLh8ltr5t1it4CAGepcpiuHPf9m9X1RTrRJAVE7Z7dDZSpME3gHZHWh+Z
         BvtT36ZMPsehio4zIjdQvrlPHeE+Lzgclhjd0egiOtUkQmjk3zXmy6kRySZbniyVH5Ki
         BMsw==
X-Forwarded-Encrypted: i=1; AFNElJ9GfYgVJSvDt6iQsrNN5eBq0wDl8ZAmuSzcCw4D+87FYhsw4b8J0roArTAuUaQ6m66O2d71yEkd@lists.linux.dev
X-Gm-Message-State: AOJu0YwQ8kauSZGy62oVY96dQS/r6neK5+pQHqsnC5tqgbNYUd4fVE5C
	ioRZRYpm7YNNVaOUNJuT9XSG48XIrePyt/nOq1rk48kI2uVEmijUj2Ca/wi0rIgDZDPdfezP0QM
	NoGX9cVRNqytFFhvNdXOAQqLeKtbUyKo=
X-Gm-Gg: AfdE7ckkRQKgXFymIbRBbL9APARmmhLpzaJ8UyPOe4jC/JAE6nPe4IcEz72SmsHXDWY
	fMhrqdSPJc/cpNWAySI1dPg6ieTVA/IB2cC7P3ck1GzR0JMYFEzfAQAUHWzLyNAA/JKWVxPabX9
	kHa0Dd+7dfC1nFwjixQXfUGGwoJuI7FH6r13kabUkKYb9MffSMsw+BmrYDkNpfCF+cMmXVkVb3o
	Udy3jR7CG/snGuvKfEtDQogE3SlMEVpp8BHknHRVu4MHMVU3eIsDJYzc9CuLEiSYUkYSTMmHlD9
	ysyMv418d7GSHhq9b9Df06s7Ux+xc8cQdcuutf18++umzHadtjkBZoQq/D14afp2glLeavu0JLM
	tCmt1KB/l2qIbcCn8eDbCmI0foOM93oSfYRT019SwXCoJaZrq0nOCrPoKklHfkgATb0gFZz9iPy
	QK2sVp1ZAo
X-Received: by 2002:a05:7301:1298:b0:304:cefc:5fd7 with SMTP id
 5a478bee46e88-30bca0edb63mr3334390eec.32.1781749330035; Wed, 17 Jun 2026
 19:22:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260616145523.335696673@linuxfoundation.org> <a937041f-31f6-40b3-83f1-1cac8deb1f50@googlemail.com>
In-Reply-To: <a937041f-31f6-40b3-83f1-1cac8deb1f50@googlemail.com>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Thu, 18 Jun 2026 04:21:56 +0200
X-Gm-Features: AVVi8Cfh5qmuvb8xKYlr8Hjdy0-Qs1PdSrej3d9CtH3-6LxQsVhaqCxNe20N9vo
Message-ID: <CADo9pHjMSqn_FH9vrDVtqUW2iLZFy6CpuLHEfebxzsP8e7urSQ@mail.gmail.com>
Subject: Re: [PATCH 7.1 0/8] 7.1.1-rc1 review
To: Peter Schneider <pschneider1968@googlemail.com>, Luna Jernberg <droidbittin@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org, 
	sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Work on my laptop Dell Latitude 7390 with Intel(R) Core(TM) i5-8350U
CPU @ 1.70GHz and Arch Linux

Tested-by: Luna Jernberg <droidbittin@gmail.com>

Den ons 17 juni 2026 kl 21:55 skrev Peter Schneider
<pschneider1968@googlemail.com>:
>
> Am 16.06.2026 um 16:58 schrieb Greg Kroah-Hartman:
> > This is the start of the stable review cycle for the 7.1.1 release.
> > There are 8 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
>
> Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server.=
 No dmesg oddities or regressions found.
>
> Tested-by: Peter Schneider <pschneider1968@googlemail.com>
>
>
> Beste Gr=C3=BC=C3=9Fe,
> Peter Schneider
>
> --
> Climb the mountain not to plant your flag, but to embrace the challenge,
> enjoy the air and behold the view. Climb it so you can see the world,
> not so the world can see you.                    -- David McCullough Jr.
>
> OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
> Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
> https://keys.mailvelope.com/pks/lookup?op=3Dget&search=3Dpschneider1968@g=
ooglemail.com
> https://keys.mailvelope.com/pks/lookup?op=3Dget&search=3Dpschneider1968@g=
mail.com
>
