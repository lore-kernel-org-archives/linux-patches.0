Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093BD7E2
	for <patches@lists.linux.dev>; Wed, 14 Feb 2024 01:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707873476; cv=none; b=a8xT/kmUrvTbyqo39Z70vzsM8js9z0O7s5BbY0TJ9G07pFnTg+NcJu7YpumDJQPlDhxgCuM0EESdiisyLmzOubLy0oXi6OX1W6py+hdzbV3V25kM/6XogB0SwpMUcs2xBYwfFiFSu884zm8Q4Q8PFoOz7e6v8fawDblstn0nhIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707873476; c=relaxed/simple;
	bh=rBM05EwNb5zPmJZsUcrviXxJFm4T/Pw0l7QiMDppS5M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r7VQVQ1CtEZ2YwO/PufPFrQsf4pgfB+ZOJyGR917DH54PjzyyvOTE87nTrEYKpcmm0wChi4H8Z0N6ShavLPMJWMc+4N7BOwjijd0eHImtBl8uRyZ3qjX/NOr5Ll5BqSiO8zmSsjRNR4s0RDq/5wbVSE5dxVoqHqXM+vpg5fFKjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=lF4IVjVk; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="lF4IVjVk"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5611e54a92dso6198187a12.2
        for <patches@lists.linux.dev>; Tue, 13 Feb 2024 17:17:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1707873471; x=1708478271; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rBM05EwNb5zPmJZsUcrviXxJFm4T/Pw0l7QiMDppS5M=;
        b=lF4IVjVkq0zoeTjK/sRz5SP0JtJKd/YuJobILjJIkXwVbyoPpSYqX7Tb4jR3G8iyd5
         RWqhuYEyavUL9cghLStJLPscLjv8EjVd6fn57YzEcYfPQdsqrvqn7D8Cpz+Z2y+YXakA
         LQ9LksP5PKas91t/5Gq0e5Y2v+BDLCo1GiVjg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707873471; x=1708478271;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rBM05EwNb5zPmJZsUcrviXxJFm4T/Pw0l7QiMDppS5M=;
        b=nG/wn2bW6EWNtC/FCFt+8OyCO+Kw9F6EjeAIHxJ+SkX5msGLf9Os6Q3A314IEVgOkN
         wddFPScNRSpK9hD5Ma7xUrM1A2H2XSicj9nboFp+zRTmEHSohhsK+zkKoSsFB+8mKRZ3
         jGRMruPnQpxBRaaG9zr6bQTW97ZNW26wvRU021BEoj1H69pC3cyNnZo4e9Vo7CTeMZDv
         aUwASCSPajw0QRGTZOWZzIr0G+4Yzr3moNjDNtZNN8cSTT8Ptp1W3a+GN9N/GV5gq9+Y
         8mz/pq+c13NXapLvpgW5rwmM1oV9Unwi7x4DNOJZypbZJF3jWFiOh4vu2Prm/JI6Ccrs
         Q54w==
X-Forwarded-Encrypted: i=1; AJvYcCWhvEp/b0OYkO6OjWAof80PanxrAAGklADxNl1t5r2hli80FDStQ2TRZGxZKEkRi1pVmwn2rC/DeIvIgXvrBLhTunf+nYn1Sg==
X-Gm-Message-State: AOJu0YyJalyERhiRUZIftGojSEaG0zoExUukKhDAlsgUn0PgrABcMzgx
	mqD0ptIRChdtpyxu6JD0yKbG0R/RQS68umljT4H9bnEP0vyUbANlNvzpmlCMahJ3KKS7MId2r7j
	fJE1Z
X-Google-Smtp-Source: AGHT+IHUaejsl72+4GOZYE+XBsTeHx7mt2anr/2e3k0Obyog756eNvVsXJge9Qpf2Grp1CUJLrgK/w==
X-Received: by 2002:aa7:d859:0:b0:561:2f3b:7221 with SMTP id f25-20020aa7d859000000b005612f3b7221mr812996eds.18.1707873471238;
        Tue, 13 Feb 2024 17:17:51 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUhdHorMyHjXBZcVRlqd7W/4ZYwk1g5wgQgNnVn2NvICmKgoI8WVBNGvvtKVUhkflCN0eRqVPolbg0nTUfBGDAIOlcoB4xSOQ==
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com. [209.85.128.51])
        by smtp.gmail.com with ESMTPSA id em2-20020a056402364200b005621f7cba02sm267738edb.52.2024.02.13.17.17.50
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Feb 2024 17:17:50 -0800 (PST)
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-410c9f17c9eso104125e9.0
        for <patches@lists.linux.dev>; Tue, 13 Feb 2024 17:17:50 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVCPmdHt89MeYJUmmBsziToiUEuf57NkVs1dfiN7zykNrjJHvfrRj/7s5ojoIo1SvcOERiQ0P6Tk7Y/6ZrRhQ2D2f4S+K3SLA==
X-Received: by 2002:a05:600c:4e4d:b0:411:62c:b4ae with SMTP id
 e13-20020a05600c4e4d00b00411062cb4aemr75039wmq.7.1707873469959; Tue, 13 Feb
 2024 17:17:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240210070934.2549994-1-swboyd@chromium.org> <20240210070934.2549994-19-swboyd@chromium.org>
In-Reply-To: <20240210070934.2549994-19-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Tue, 13 Feb 2024 17:17:34 -0800
X-Gmail-Original-Message-ID: <CAD=FV=WE4bgwTWTKjPbQR9RCt-SEVZXfQtXoaXAjvTiZiMr=wA@mail.gmail.com>
Message-ID: <CAD=FV=WE4bgwTWTKjPbQR9RCt-SEVZXfQtXoaXAjvTiZiMr=wA@mail.gmail.com>
Subject: Re: [PATCH 18/22] dt-bindings: chrome: Add binding for ChromeOS Pogo
 pin connector
To: Stephen Boyd <swboyd@chromium.org>
Cc: chrome-platform@lists.linux.dev, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	Pin-yen Lin <treapking@chromium.org>, Rob Herring <robh+dt@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley <conor+dt@kernel.org>, 
	Benson Leung <bleung@chromium.org>, Guenter Roeck <groeck@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Feb 9, 2024 at 11:10=E2=80=AFPM Stephen Boyd <swboyd@chromium.org> =
wrote:
>
> Describe the set of pins used to connect the detachable keyboard on
> detachable ChromeOS devices. The set of pins is called the "pogo pins".
> It's basically USB 2.0 with an extra pin for base detection. We expect
> to find a keyboard on the other side of this connector with a specific
> vid/pid, so describe that as a child device at the port of the usb
> device connected upstream.

Can you remind me what the side effects would be if a different
VID/PID shows up there? I know it's not an end-user scenario, but I
have a pre-production "coachz" keyboard that's actually programmed
incorrectly and shows up as the wrong PID. Presumably I could either
throw the old hardware away or figure out a way to re-program it and
it's really not a big deal, but just curious what happens...


-Doug
