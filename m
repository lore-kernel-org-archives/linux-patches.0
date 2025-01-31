Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459E91A3BD7
	for <patches@lists.linux.dev>; Fri, 31 Jan 2025 10:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738320556; cv=none; b=RmWjIiWa9FnmD7K6v34VJAveuUufMbPKVRRto5hP33N5Nxy/jcW6AIJOMi6oLTT6iZh899EgYiZsKftvwsVOK/195hPknLkRIvKicRrXpX5olP4zHJ8oYy4ufDeddqoKvh9lKjIhXjhhh4AGiCaRxPP7K6TrLdmzCu/2gq6dmSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738320556; c=relaxed/simple;
	bh=IIYKwK6gZm3RIvkU5BV1j672fhQTKpiM8TLnp77ECi0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tgp0fkUgHHRMfcw177A3LU8m+cyYcGEoOvMEvgOef2E1F8ScElZeKSDBZrJ0ZPWHgT4ETUST4/HjrM51sA5SmaOc8QUiBjjaJ47dhP1sPtZECUFV4bW6uao4Gz9jA4i37ICz2OtEUGtY/TN9cDuUWu8h6awk7yAOWfVhXR2CAjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=jG7P+vST; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="jG7P+vST"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2ee76befe58so3186410a91.2
        for <patches@lists.linux.dev>; Fri, 31 Jan 2025 02:49:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1738320554; x=1738925354; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NBZYZHrEvu4xGP6oPB0bXa2YOEKtC4uPTQviRrKj7b8=;
        b=jG7P+vSTZf0W7yMfgVo0KCTx6Qj6Y3mWeDxJbNm7cemYpEZ8O3pqwLlWXGD4nlQavx
         EfUknKxn+BZQnaX7fxaHNUu3QqqN4G56WtmU9izaz9Z05NRRQvOq9NWOqjTHfNtoCQUi
         44y8vX/qqNWJQeCUAiquePHZxUxH2s/8VXUttw/Zumk3NDmfVQl6ubBIfqmQHob7KuP1
         U2A0OyAVdJ/P9DZxVf9v6zv4hjGEYQrRlp84IBbnhZcGIP7DlIePEnYXFgXscKfOPSUT
         lmL9HJoNi1oaKlyzAyvDNESGAsDw6gJXm2eVqiGbfZStlqjpmP8bcioCm8SYUns5IhXw
         nLjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738320554; x=1738925354;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NBZYZHrEvu4xGP6oPB0bXa2YOEKtC4uPTQviRrKj7b8=;
        b=HbtyxCcpIHoDuntoQSVKWyeSMBkMyAty9mRLA0vuOXISJlrr+6+YyL4YQTptUWu7pE
         JxNsoE/yCSwQt5DGgzGGHJen0Y1NZNQHYbyj4BRASHaqfBsJH/YKEvdu7wIC1+XNMuvx
         4mmkCBGoSgBpq0d64pZUb1otZ2u49SDZhAinrmbqU8wZdumcbu55WGx2eYdxK7bxTEG/
         5d8g1FddW+Pzq+Oh0BFbWPkDYGdA8I+BehbjJuQ4gbbd37hT9PAeK2Nu21tr784wkoTV
         WBVRiAac+Pg7QA/hbhjkmRb8KobWxuHwGjIDxb8Xuc39jKBsUfcBPN5xv1atO63yKJkg
         0vxA==
X-Forwarded-Encrypted: i=1; AJvYcCWtoqtCwFcBQx0HUpzAlMAzJKwgNR3XXG8+3VKx0bDFakoWoShJt3RS18iP4Yf6ofQMniCj1ku3@lists.linux.dev
X-Gm-Message-State: AOJu0YyFdBSoWa/g2ecF6JeEmOgi2fu7kFNqiuAT4r1pYNA/reQi3jUN
	YDncA/pMOljjW0vGjEqSki/QPrJ1x5+P0VxuGvj1CmAz/iUQ2duwcKPux21HwXm4ozpf+Mrdrui
	2HUZiDHXBO7oXgOu8YeWC8VZDnmUtcvQQYgF+DA==
X-Gm-Gg: ASbGncs8uhYoAnNAdfW+vyhzVscG5VxoRCdjbCrUXc7W3UEHPoxTfudKY8qQ+oLoVJv
	P0Tgzw3XJDhl71cUqeGHyd4uA4B5Lh/qkOdx6sMVk133hRn58/gzhxHNy41QiFj5qXSOIVbzZ
X-Google-Smtp-Source: AGHT+IFKMXzXc4z9qRfH0nkfTgT5sHmXwdaig0w8m4WIvvOQeXzdGBoKKtImAcaIob7KYzCEPrYtBvH67mycnh7TPDw=
X-Received: by 2002:a17:90b:2743:b0:2ee:48bf:7dc9 with SMTP id
 98e67ed59e1d1-2f83ac0068cmr16801592a91.15.1738320554447; Fri, 31 Jan 2025
 02:49:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250130144136.126780286@linuxfoundation.org>
In-Reply-To: <20250130144136.126780286@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 31 Jan 2025 19:49:03 +0900
X-Gm-Features: AWEUYZmlkcZeCyYCkqXYCWF1l8nqyTSyhAYJRU0GENQ8PIYwKOuQ7t-L7mtJL6E
Message-ID: <CAKL4bV6=tBX95okqxpYJy8WqdWEsteb3+uK65Zf1xV+K8y-Gwg@mail.gmail.com>
Subject: Re: [PATCH 6.12 00/41] 6.12.12-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Thu, Jan 30, 2025 at 11:42=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.12 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 01 Feb 2025 14:41:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.12-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.12.12-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.12.12-rc2rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20240910, GNU ld (GNU
Binutils) 2.43.1) #1 SMP PREEMPT_DYNAMIC Fri Jan 31 19:24:31 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
