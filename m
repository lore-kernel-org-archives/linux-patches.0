Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B4E21CA1F
	for <patches@lists.linux.dev>; Thu,  5 Dec 2024 17:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733421121; cv=none; b=W8uXgxjvykxtp23tR9kp6262gOWStWJCv9+Dh18uzbwef4XXk1/ocGknO8cin46aWaIyKKzvRozsW/XnzAhWH7zFla96xwO2H8ANR7L8QYlGUpZLHzhbfjcoQCDL1Q/FXVgpFI7FW+yD06m4aMZNiFkkFtd2H+0vkEH32GebVSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733421121; c=relaxed/simple;
	bh=7MoIFK5OGXq3gDhad/EY4fgDc+nrvflIniaIyfUBSuc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tEMWpo18khSdbwr85xf9iGhe8wXC9512kqb4NgBl3AiQXlYWAolbZIRws8AsyCejz4IhGuO6Kv0BqCL9Pib+3b1elzLhnyXjyQssHuoRb5hfungEYX+7AnnRAlgzn/FjdOTY69FkoAmYsB6Z4fFZPoS0KpJL//DHoR5CW42y3KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S2k9zrnU; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S2k9zrnU"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-53dde5262fdso1603271e87.2
        for <patches@lists.linux.dev>; Thu, 05 Dec 2024 09:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1733421117; x=1734025917; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=z5eWK/vs7fqhFUwAujMxMk12h0AxsQYVmA9NF533vvU=;
        b=S2k9zrnUc4qjjcQD1VOYVrdXUgg8QXPRP1XGjkzgzpbOxeg1WKFzY6EcbwT526I7lQ
         IwtU6yXrkUuMedJsUCxifytCjDwdElqZ9qbhI+1GIRjc2oLW195t07L5G5MA7zdmWEsm
         YEmViVKcWXjgiMK141QH2W+8fZvZo3pwpcGc8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733421117; x=1734025917;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z5eWK/vs7fqhFUwAujMxMk12h0AxsQYVmA9NF533vvU=;
        b=BZSVsX6TjcQt+ENN5QrXLubbU2ycsz02fwSMEfeqnnwqbVUxi+IvWdJCsPs0y7iTfL
         9gJcJPkXWK6+MyWBWxT655XutjA7bvyL8kzwH1swmBas7PH8kFv+mvxPzeyjPeY7fvJx
         a0f2WyE/z3BWm+AUj6bCUwtr00jtEgW+64duJ9mb9AuarrNn9s7xhOxHD4a9U89kQhZy
         1RV0VjZAHNTyJZmuesAl6tOFsdxwEI8tLfz6kbaHFltCP2poPSOKDTQMW6QXTrIN2N4u
         mHc1xF8fnqRfTkqiveQTCWqCWw+tYmygmamt3ykjZujXjAHOzyHoPstdyuX9tiWfN8Br
         1pEw==
X-Forwarded-Encrypted: i=1; AJvYcCVHy9s2d3BjbEfw1+5f/5YI/A7L1YHls95h9G7pnOJvJlG9NXkhXkFX8zhrqmvNaZHlkD1MGXPt@lists.linux.dev
X-Gm-Message-State: AOJu0YxEAlf37jBp323znWU3t3QFUpHip8yIJieygJ/wZWq7Lq4OfZlW
	coe72yvTsaGb6AmOIOicKZ71rwswknEG9/z8Fdya0ANmVHMuw6I6FN8Vq0C7lbtAYOdzwnI+ihR
	fRftWsQ==
X-Gm-Gg: ASbGnctxAGFsKqdGmthn/m06sQuT9S1I8hQVVEV5VSMyWJA+qrsWfBMmYBCz0N3eAZr
	yRU29y1OYK+tapLPAQzNXD271rrExjwqfHyKdYzOUVtOIUVEEf4hCS4MD/XntXUF9p5gnjbXpG9
	CGtj7vNgRx5tVKEwoEFU4tDoaOnLjdoqPvv6caV/pTW7Epd6HnuGLYpAZhXm0fWrujovOoXkil6
	Srj4H1zI9aUUS+3OkBU8tMjHhBRRpnr9v+L4uHJAeKzPyGvcuy5gZmxyOjUWQUSJiTjave3ZTbq
	nAIpK0yn2HvwFNMPXQO53UxC
X-Google-Smtp-Source: AGHT+IF89zN7IOqU1y+IOJTX+WXv0wOUPr89VpTQ8IEwfbHeutIUwe/1caUwUT8pw33GIeBkKjYC8Q==
X-Received: by 2002:a05:6512:3ca8:b0:53d:eed0:8d9e with SMTP id 2adb3069b0e04-53e12a2e50cmr7240659e87.53.1733421117242;
        Thu, 05 Dec 2024 09:51:57 -0800 (PST)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53e229c276dsm298059e87.225.2024.12.05.09.51.54
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2024 09:51:55 -0800 (PST)
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-53e224bbaccso1324267e87.3
        for <patches@lists.linux.dev>; Thu, 05 Dec 2024 09:51:54 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVONbMQ0X9I15gKSVTW7yyBN03rbvAnV4J7aO7lDDMwB0DwV76TyZvSiYE/YTQT2qFR1ZR9wI/P@lists.linux.dev
X-Received: by 2002:a05:6512:6c9:b0:53d:e4d2:bb3 with SMTP id
 2adb3069b0e04-53e12a2e4e5mr7858256e87.50.1733421113830; Thu, 05 Dec 2024
 09:51:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241203144743.428732212@linuxfoundation.org> <efbda6ac-9482-4b37-90b7-829f2424f579@cachyos.org>
In-Reply-To: <efbda6ac-9482-4b37-90b7-829f2424f579@cachyos.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Dec 2024 09:51:37 -0800
X-Gmail-Original-Message-ID: <CAHk-=whGd0dfaJNiWSR60HH5iwxqhUZPDWgHCQd446gH2Wu0yQ@mail.gmail.com>
Message-ID: <CAHk-=whGd0dfaJNiWSR60HH5iwxqhUZPDWgHCQd446gH2Wu0yQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/826] 6.12.2-rc1 review
To: Peter Jung <ptr1337@cachyos.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 5 Dec 2024 at 07:46, Peter Jung <ptr1337@cachyos.org> wrote:
>
> Reverting following commits makes the machine again bootable:
> acf588f9b6fb560e986365c6b175aaf589ef1f2a
> 09162013082267af54bb39091b523a8daaa28955

Hmm. Thet commit

    091620130822 ("sched/ext: Remove sched_fork() hack")

depends on upstream commit b23decf8ac91 ("sched: Initialize idle tasks
only once") and does not work on its own.

         Linus
