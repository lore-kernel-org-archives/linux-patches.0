Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63A43E8C5F
	for <patches@lists.linux.dev>; Thu,  5 Feb 2026 14:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770302076; cv=pass; b=WNSyNB8KVkOZiHjoGolXvEZu+Our3WeIZrQI8SKLCPC60lEfENhIc2gCwA81BLfKWpQZVO0Fvw3idi2N7nmRGnig8MKFirbHgHlHkrDnFpuFFhjOIfZ/PErU5ZeohNV+pAy6ZuW2KTYSSviugQVw6z4OnJ8wsHzamaAJOOYpySU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770302076; c=relaxed/simple;
	bh=reZXgYMQs1E5L/mUDPMQtu+CUcwp1XuOpZjO9yoB8Pc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AKQHnVhYBkQ+Hef0FoqAZO+BjJ5OotMtUBBzlhGLKHYPnjLCGaLEG64fw7zi8rVTOquo90wuY9vUqQS2GKuVLnpqmVSBHyAW5JtMjn6tw8BaOxyA+WX1BKc+fPWnPR4aSj3h5KaaG627+C6XKasvvt5ssjb8LDLnZWEh4wiH6uY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=exLJHhyS; arc=pass smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="exLJHhyS"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-894676e6863so10238686d6.2
        for <patches@lists.linux.dev>; Thu, 05 Feb 2026 06:34:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770302076; cv=none;
        d=google.com; s=arc-20240605;
        b=JInOkyp6M/oksJDS6leYrSTMuyaBbZBoYXmlSOg2dt1opK3KN7PWXkiQfPQQluXeSe
         F2OY0rhvrOm2DebIOBeHNTPLcUjJkJCsPZ6wae6fUE3xa7BfM3wgTk91mgvjQUPF++Ta
         gLGAJSC2lM2VSYEiG6WUPsovfovIb+149CQssUGdbaINVcMl/IbTmY0BWngQbE1u2sFV
         heHncQxh6Wj++sFGd7GEdP9ifSORTV4n4iTvwbZfV6GMidsJWGAHOEDVlxkVCIjhLl9P
         DdlHJUPJ8DFAQ1rPowcEy8B7QXG309rhMXaRMhYJ7pWpzCCy6HJgtvfAuuLB9smXocAW
         pSyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5T8kSYzCJlABHfxuED/EI22H/0YkPSOohQqiX6XhgSo=;
        fh=al6SACQIZsyfWqsVvrwYs+z+w2VY79wL9xtfTYv7G9M=;
        b=UDEc2Xa6iPjg3m6IbkSYFArFGECpMX4RqBq+dkrDWwe6UMb71GZ8Y026hqTar5ORUl
         2GKbqzc7ETKJJoRXnVn7rTOhrgmKstTc/qmiCqEuJo3PRQ1hnK9KAmPrtrz17WJuDBOB
         1+ZGIt1T8/uKxDdFuKZtlGXCgeJg0UmwrCxYpqfpMZl6KmFPWL/1dpIkijFHtuO5b8HJ
         lH1aRD9qRJQA/NzweLKfitXTOv4/M9R+ZR5OWr1MyQpfovQW0B4lF/gpR/Sv+c30w2OS
         C08y+FeZOPpUN+AbDABkM2a2Kp2nHsRFQTgSeNQTKDUKA5EpNbQSQoLqZM2I8XGgHF1J
         XUCQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1770302076; x=1770906876; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5T8kSYzCJlABHfxuED/EI22H/0YkPSOohQqiX6XhgSo=;
        b=exLJHhySNS+ShdgIoxtJiMTSTq6tunFCSlq0gl+ZQXj9a343cdl3dQ6AFhXRzfPvMT
         UUAOuYe2eMdYM0qvicGkBdN7Y6fbb5+3mIKkjI1UkEsMmsiNl5MsJMa5VggpVWvqVgVs
         mjjjoj7ohM1smqgBlofG78GywCCOs+3iIMKROG+bteMNPENXl3KSpxXfJHSJ0KFsBb1n
         iJ5+3n57r6ORPoH/3XOSJ6GT1r+6fzeG3Qjw2aJ2z4hcDegMRKD1E/MRs2YnLGdXUIci
         2GQvI4VfCVwBE6xMyz7KFfRlx6ioXidEWBc9Qx8H8doXIVeCh20d9OnerDK6Dl7hstC7
         gn9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770302076; x=1770906876;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5T8kSYzCJlABHfxuED/EI22H/0YkPSOohQqiX6XhgSo=;
        b=ZCcHk/5FhZvaZK6F89SEAusWFmlaZ3rUibHJJ0O28UVYWQOFd5Kdu7R6+S0IfPEw2n
         S/PPgCn7J4kB1L0zfuzxA7EDLYv+7o0mThDZW0d7csIzdzovmVSBag98c1WUN9Uo1RJR
         j6ThTFuabu5R3qhdGz6zFBsvnZY+UqbDmZiZKOpK1ehHg9KEOtaSIAmiuOCs8ViiMmDN
         WEVGXucP7xKiZM7z/7T+yx0LOcm+44eUykzF+U1q7mKxo5ocoUVDqBUT3BW8xGhtkr+2
         zOBTAFZaOUzB3LKtxYdsvDXotAsLVe9u5QIi7W9kBtn36C4AcmhB5CyoU/GzSTbjVHGy
         m4wQ==
X-Forwarded-Encrypted: i=1; AJvYcCXPzdqRfepXNg+IYPuG7lycaHnMWBDkZcK3v0Kls6/6i8z/mKHgoGg/K13sDoKkx0ESjRvnkUMM@lists.linux.dev
X-Gm-Message-State: AOJu0YwrPxu/hJO3qfq2j2dfojw7dixfGK29kFYmXXt/3mGVJLO+jLHP
	Y8wXBfOxiQD8u/F2/dg5y2nwHdYo4wI0GmT99gOVg/S5kqjQ52YI3zqx1VUHX2329MJ92t7/+zr
	eBr7Re/RxUZwZXLbSU1XKdY0ji3Wk4BGmKXxysldm3rmJCatMW16nIzuafA==
X-Gm-Gg: AZuq6aI+XcsSa3z5XTR6SzVNNgHTQwuwwaaak2qaKFDPzohLq7r3Brw6orRMRKOCnkq
	kV9PjdnrDLdTW0P01tGw3CWVPEV3pSTT0F9nUppCnHldiGsTZWt8KsFfVQtynB3U1XyJTWS/OjR
	+strcGsdmJMMEdiEyFjy968gJGAzg0aSLvwmC0AQHkEOxUTHypvhV9MXfGK9v+7XGdeZlCFy8nG
	pkwDmVODggWsGqqr9FNIRp0w+LSuoWe8jui2O3PYvvy58vUoDNNskTHm5g1Zofcs2O7EKla
X-Received: by 2002:ad4:5cc4:0:b0:894:6f04:3bb with SMTP id
 6a1803df08f44-895221cc9ecmr104433826d6.57.1770302075594; Thu, 05 Feb 2026
 06:34:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260204143846.906385641@linuxfoundation.org>
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Thu, 5 Feb 2026 09:34:24 -0500
X-Gm-Features: AZwV_QhvyilFO5rNcQ43Antjxe7oGwhjvv7M5ElotkayOstzeUUcxm7UHt8eCSQ
Message-ID: <CAOBMUvjL1dq+bKWS915+=azSzn01TOHhd1TgLB4Kwqgp_1o5pw@mail.gmail.com>
Subject: Re: [PATCH 6.12 00/87] 6.12.69-rc1 review
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

On Wed, Feb 4, 2026 at 10:37=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.69 release.
> There are 87 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 06 Feb 2026 14:38:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.69-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
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
