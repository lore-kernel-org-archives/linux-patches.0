Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2252376FC
	for <patches@lists.linux.dev>; Sat,  4 Oct 2025 21:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759612798; cv=none; b=LJtmtSn5Gb9PaGILf87hccsqqqS9xp37urdP0+mNIkiXyNd08UsGa+oiciQf0Vp8YigiOhQtu0BXRobPq3uBJscOMIfMhxV7b64TFHvXa1x34+gDGfuDfgScOFp9wGqAdmw7++ouuuLUrOKO4Fx1uojwiIjknOWjPEUKegSUrh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759612798; c=relaxed/simple;
	bh=eUHZflnSr2TEkpe2XPDQWxvjho7jjLPMAhUmxpQiU80=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kralobUY9gOV91EfeDyA0biIFUi5OcZeNObmQQqPfTYwtvB3cvKRyhE7/u6ULnalsBmJRZmOklouyF9V2b0csL6PhZrbz/fzqPw7XmtBcKGTOCrzDQmlva0nNxbTZkNik1fA7J44av0o3b0OYo4+VRJHnE9zKY6v/QQ7oM6V/Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=BBR+xByi; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="BBR+xByi"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-46e2826d5c6so27401605e9.1
        for <patches@lists.linux.dev>; Sat, 04 Oct 2025 14:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1759612795; x=1760217595; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hW7OEaTade5JEeRbSzzr5KXw6Vaivv6pg6suXCwYkOs=;
        b=BBR+xByic6zWop9aE4/ZfXEffhLxGh7jOWXtNh87Q+YmuActH8GMz9f/cx40u5uURS
         TvBc+EE79JO4cVszIOFhAmt5jrj+KVmY43ktt79o0R/MZa7UWN8JZXWVqeWsAbR4B0Bk
         maJRQRCS37yDpk03iCo/jt2whTuPSH5lsTHAJzJ58xTICka91W94eRjlCGHKPoEIVASW
         s71HNfA9owru8aJCDAIRacjyi4CNttcjUWEqdBcw3qKpEm37XGhMF3nWjpkRjiI0IVCy
         cOmq/BONzfc6kF7LVc/0p49r3P++WnTJ8PK3GA4m1ijt1KQHD3WTollABVM4AQoK8hPX
         ULFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759612795; x=1760217595;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hW7OEaTade5JEeRbSzzr5KXw6Vaivv6pg6suXCwYkOs=;
        b=b2fIsqizwc3wzoYgbMlIj1XQOQs59dp7XdkshDhrxKHNctHGLJLspEpABcRnabHnz/
         Iy18+5IVXxPB1Hf34rV2Y2x24daer/Ae4kZ2raj+rl7LKc+Ulg4XnS4Hgb3/D5X70BUh
         ykEJgX+UeNDxPRIwWYEP4cJNfvQUIlfacmGma06W9w9Py5vWE0xlN+lSogD6oXJNcSk4
         LY9mKHOFEXeXUSTY+1XVfgnORQwhhTGXuRP2qEUOLNkaAkz4cLsgiejHKLXYLMj+5BSl
         baHqBGaUh6q9AcRvL5/i7v6Az8G+rcahEMNcvFxNRZWRD26ZoNEahMv16ZQ7tn7Puqew
         LTLA==
X-Gm-Message-State: AOJu0YwMJgD/6mtWj14DA1aMzJXpIKXjejPNvR7TKSmhKcsVZtDLZmAQ
	+D61Zv0mS4az/PyX2hXlOuxf7r09eoBkShve4NXxCu2rHdWXQie/tOKl/5ns
X-Gm-Gg: ASbGncuJCSy/WftGww4s0eodEKLo3+y3jjYJehqdjZHlxSWL9FwD76nKwm+/HdUnJSz
	5szYv6gmvEFbnXmWSgIC/VdZc/Iq3NNJHE/KDhfU59fb4GC2WdoyctkzetgQLmnT6v3NpnzutDc
	3/k8O9WGFrec9/rs/+B4dzOXjLMonMPfnEXMBykhYSRNOgs1Sp01Lan5WJxo+4QZ43c+P1jv8Is
	xzYUS2oLBY4qiF+kMdk61bvTlCD88P118KXCCNa7RzpOwmLMDb6q0vEhTy0PjkoRrDKHmsyhgor
	ZoWvroBbNNFk9uT719Ps1Ova0Jxw5rm2W/azWXpy1wwjm/C+KxRrkVZAjGR25qQEke9vwFS6FM4
	qjclX5KXi1Cq+YWSqWnAGeJMpmI8FPrdPaavxS6q37iXh2h1UU3oMxDiS0VesWwKO7T/riXIEpm
	hdYxZ3iLe/AHGgWCzmTrjze5A=
X-Google-Smtp-Source: AGHT+IHfyPEEeoKKPfnxCwwTH4snrR1lqeeMT6o3OP7h3Ocjh70aKmFMr9qutwQp2ziuyduhO8+ugA==
X-Received: by 2002:a05:600c:8b38:b0:46e:6d12:ee4a with SMTP id 5b1f17b1804b1-46e71140cc4mr44684345e9.20.1759612794837;
        Sat, 04 Oct 2025 14:19:54 -0700 (PDT)
Received: from [192.168.1.3] (p5b2acd24.dip0.t-ipconnect.de. [91.42.205.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e723614c9sm86798675e9.14.2025.10.04.14.19.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Oct 2025 14:19:54 -0700 (PDT)
Message-ID: <a5750ce1-a441-4dd5-b9f6-5bc5e88d9723@googlemail.com>
Date: Sat, 4 Oct 2025 23:19:53 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 00/10] 6.12.51-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251003160338.463688162@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251003160338.463688162@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 03.10.2025 um 18:05 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.51 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

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
