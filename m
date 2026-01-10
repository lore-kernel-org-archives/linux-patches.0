Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B8E23AB95
	for <patches@lists.linux.dev>; Sat, 10 Jan 2026 10:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768040600; cv=none; b=aVGu6VimW+uJNFmOh5ssSUdS6oxYwUrx02HxeqXYmltCGr+RKSHHEUTnDmociEaFuvKDHv85js/jiSm+GlfEoVhOsLW1IqSuB1s/6wiF804t+JRlSfxA7GYgZAgCEFSbg1YnHqQ+IxH29v6FxFqwBCVcDzw/AX0iC3CNp4VgBfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768040600; c=relaxed/simple;
	bh=zht4NG8w5qQh6r7obvBvD8FNvTaT7jrro5YA+cdHMNA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vr5q90nyUUbUdAV+MirrsnTSVUWmzIwWbxKviW5DpNT5S3goJeqz8bx3P5PAY9rXXHL+MBsBdJSmnthETNSGk21KBDPM+e0rr9uguK3NjXCmZcAbz5jeRnErridwt3QyU2fR/r1N8VFweI0WLTsgkXkqZzrurIpeSkhTBxIHSxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=NlBTaF5d; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="NlBTaF5d"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b7eff205947so711665866b.1
        for <patches@lists.linux.dev>; Sat, 10 Jan 2026 02:23:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1768040598; x=1768645398; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=G4BxAxZnLKOTrhzC396UdOA96f2/ytbFCPOHJqjLm6c=;
        b=NlBTaF5d3IfEWPC7xF2P1Kc/87dc37xvdlU4dQcd1W1BIVBMzI6h2sw98DxPsfZY8G
         77D1By4jqR3t33De0jOoli8BySr6X9CjnATa/wzUkUIEYuXJNowiRisiQ7lMH+CyJqM6
         i0X9F8boyJ2SsC7G/bF8F20jJYRJxLbdu+/frCRh8wvS5AB4LcWokf34UC+HU7zttlh/
         B9knK+WSf7344gmUuO/2ZERbGX15i3QNMmyyTN3d+aRS0LPHj8yZIp8mS7oNoV6KnbvF
         1MsLhMN3WE8d91sHJs1PREBX5sNupoh2AYsARnP+R9iDpX9VC1vEt8yrX9x8xS+Zwm2r
         IRnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768040598; x=1768645398;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G4BxAxZnLKOTrhzC396UdOA96f2/ytbFCPOHJqjLm6c=;
        b=miqHxPYs769vxyt3DTLfyWX1N1e+4jWes8lnST4Gv4Jk35acwjBEl7yDupXZPRgAk5
         B1NoYXFMgfR9+k2L4s+m+C/9Jtfh8XbNGb8XwjmoinFHto7TO+FSv34xht4FVFWjRS0a
         7PoxNaFS7K5Oj1dOsrLfC51dr0xmbwytZa3HzeiLQvr60T6oD4+KXLoTcFfbDSuMqd48
         2nwcj0xgzK/StkkYD0U1RHA9EcN3kYp2w08YWeDMyYLOl7qe/1KPVw2F+GHfdYl/FQiA
         6Z3sLSHru4lKijHE0+6MtrZw945vfdVf4xb9ph21PZxyWmu8cbw3KQW9YyADPVGJ1vUh
         pI7Q==
X-Forwarded-Encrypted: i=1; AJvYcCVG1hzg8gbtNdskmr/AtUCmfa/1YiTmcPDM0+R2rpTvUrZqvla4Jbkaa356XBG5+Q1UNHsaWsYU@lists.linux.dev
X-Gm-Message-State: AOJu0YzQEWAX3dPQ07PiXWYa0yvYvwsm6sHU5G+PstT82C6MeL6PHVMi
	H1LOJ9c9IopHM1LZOkIZpULSuZRGLw2BnjxpN918EbbNCdY8e1sf4ufEZWac878E1QbT/M4qo2v
	YIF1gnxavhDjimrcvQYaz5THucCAP6M05n3gCmBVOfA==
X-Gm-Gg: AY/fxX5k1DeuZspkvDfLSp3ydoDCNUem36rlwn3Df0EswfniFgaOVjv94jY/JAqq+fX
	S1es0fzWRPVXfDnQW9CJ/SK+DZsp5xF/F+7BrskwApIFkr5t35tRNWHVQ+FJDvtUxFJ4hsuIW2X
	UErx6bYhIOkHv2gXpqEZon2PyP9vW44vN0OYFUxxRKinpPHABNNKEoM1FBt0iJ09/QNztf0gsnc
	f8LIz47KwM0vZui21Qkc8bvT+KlCZefKGzr7cZK3GMBFbDgQ9ACfyixrKWmSQjRkX0wMdJ+b/nK
	fnn33t0=
X-Google-Smtp-Source: AGHT+IHbSaD6+oPWJhQ6l9ENonTlbaI+R2La0ezC3QuQxixNeyO6lwscirrXz/C1ER15otFMLkzwn09DwL0wwb697/Q=
X-Received: by 2002:a17:907:6d1a:b0:b73:99f7:8134 with SMTP id
 a640c23a62f3a-b8444fabdc4mr1140449966b.45.1768040597694; Sat, 10 Jan 2026
 02:23:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260109112117.407257400@linuxfoundation.org>
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Sat, 10 Jan 2026 15:52:40 +0530
X-Gm-Features: AZwV_QjvqJG3bwNPbW5uK9ag62y-VideFHjRLoaVWOWugaO-tbrv36PmNctx73E
Message-ID: <CAG=yYwnEy9aX8B_rzhoPRb7FtrkAbpLqsUn187gArfRwsxkD-Q@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/634] 6.1.160-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

hello

Compiled and booted  6.1.160-rc1+

No  typical new regressions   from dmesg.

As per dmidecode command.
Version: AMD Ryzen 3 3250U with Radeon Graphics

Processor Information
        Socket Designation: FP5
        Type: Central Processor
        Family: Zen
        Manufacturer: Advanced Micro Devices, Inc.
        ID: 81 0F 81 00 FF FB 8B 17
        Signature: Family 23, Model 24, Stepping 1

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

--
software engineer
rajagiri school of engineering and technology
