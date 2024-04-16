Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C9B8529D
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 09:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713259021; cv=none; b=dYrougH5mrClGqaIlh1qdLSWz//pkdPGje8o1OuTG/DTKWhejrVNBBTrIObGMOb59nVWRsgV1kXd2V4hcOe8B2jxZImH0a1TsgLQYvMtcPIdE/J6kmJTHV79znaBzUE53egxnY7CcKUk6/OJ3Z03jlY6dqt0VMd1aPB8CdOEyXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713259021; c=relaxed/simple;
	bh=8jgLAUJob4komqyCXQnIuIoKS9Y6WNsjEipKGCag8BI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e4uR8NEgws3nn2UMU5rzmNRB6RmfUTo4WY2s1yNxCyKpI68POYJH4UCG6X7q4+lTjXY3VdPmKbRBNNpwJghjTprOlxSFmqgJa3dJ0f81n3xNnK0OVSUitsh5Zrl2latu+svNIquS8wxfGjmpgJbfYgI5rCtb4dVHbyB+fvHAOMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wwa2vprk; arc=none smtp.client-ip=209.85.222.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wwa2vprk"
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-7e73cd45b8bso2080775241.0
        for <patches@lists.linux.dev>; Tue, 16 Apr 2024 02:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713259018; x=1713863818; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vVWn70QrmoA1ffZj2betPxocp2G4USrXC3Hf1knCx68=;
        b=wwa2vprkgKS8p2ujIxbJRChOdYx+CHgaCOx3VvdAdbzpjO0O3s2zidjU3IuxXdgfAy
         t9o6Cvdti5V7WRfmUnQxkljLM4k3tXK3z9cnPiv9ie2Gj09+hB0Q+rjtbw/Z7HvXnPAm
         WmNanLHZMnPNGHAHok/k+5TQjeTdbtaC4qVRzlvOBDNpbujAWroSTVEcaJBT2XOqKscq
         4JaZRhU3I2dr22PmsjiUXjiNGJEAyKmy8+qBlOHiFuzjn9ceVSeCl8aUCPAxZndQZC8g
         9e/ORChscQ6KW3u8J15OGhpUSXm3ElRYWmGZyHFD3rMiAQ0mKwUlT20eo4ZNJOtJju13
         kVTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713259018; x=1713863818;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vVWn70QrmoA1ffZj2betPxocp2G4USrXC3Hf1knCx68=;
        b=H/T0hAkXZCYAOCB9pTFKsJtox9VO2awa8d8pmr2j49VgWzU4y6aPecsI6iHpGwd9bZ
         XPlI+GWIO3u09Fl19Tj3sXEFHtELKXSJj+tI/qdi8sSkxJ+1kGOgo5BnlQr6cNmU6mcP
         Cmsf9Za6tSBRYQTFGcFZTwmG2J6JqI1g/e5/b+pwWSM5WOmEWWBYZyTZIgz9deWqF70E
         LrCDRQb8gsuN6tFZW01EpAa6uBu2kpPTpkC9PCE4b20IFBnpqFx+cxP9n0qdcHL+laUK
         4OcFlDqKIGY6M06DCMJ/djrIMgrYma5ETWgMW44IQbukr1vKyaqnXNOC5BzfPBpxBxaL
         4dMQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/JBMPwZuCN4Cc9XIWkhWKLv0upOsDnWVzh6SwcLkwh+qiZzGOyzHETCWe8l53KnAF8vNR06pgx0nQxz+X3gvf+y5NUGI/NA==
X-Gm-Message-State: AOJu0YwQk9HF5XFPjQ30XjNfT5JxYnyUUjg4KMzDjkIpR4ErZp7OhMXt
	bOU1fhOtvblnAHP7FdwVfqipy7qqMG7jVRsSsylNWmtQ0c8r4p+xi7mgF0nmJc5lVCnu+WAhS4J
	hB9ZUo3neRDErQSQAIMR7wNOEvMAyzZSYOT0ANQ==
X-Google-Smtp-Source: AGHT+IGdpoYmKI9SqOv3iUlv9BkJT85Yzy6MJYOaIEGPqruTKs/l0Rq7SnWeRhl+jvwoE4tXiBJFHrIO7sIJV7KYpIc=
X-Received: by 2002:a05:6102:b0e:b0:47b:9d4e:e0c with SMTP id
 b14-20020a0561020b0e00b0047b9d4e0e0cmr154923vst.12.1713259018530; Tue, 16 Apr
 2024 02:16:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240415141953.365222063@linuxfoundation.org> <Zh3AywUqfBB5wQgp@finisterre.sirena.org.uk>
In-Reply-To: <Zh3AywUqfBB5wQgp@finisterre.sirena.org.uk>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 16 Apr 2024 14:46:47 +0530
Message-ID: <CA+G9fYuxQemNR=6ypi681qMqg+szi+ZZL_Xdhz0Wg1BO0-7bjA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/122] 6.6.28-rc1 review
To: Mark Brown <broonie@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 16 Apr 2024 at 05:35, Mark Brown <broonie@kernel.org> wrote:
>
> On Mon, Apr 15, 2024 at 04:19:25PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.6.28 release.
> > There are 122 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
>
> I'm seeing boot breakage with this one on the Arm fast models, a bisect
> is running now, for slow values of run but should be done by the time I
> get back tonight.  It only seems to be affecting 6.6, the boot grinds to
> a halt shortly after getting to userspace apparently with some
> PCI/virtio issues:

LKFT also noticed the problem that Mark Brown reported.

>
> [    1.606075] VFS: Mounted root (ext4 filesystem) on device 254:1.
> [    1.608751] devtmpfs: mounted
> [    1.627412] Freeing unused kernel memory: 9152K
> [    1.627894] Run /sbin/init as init process
> [    1.627957]   with arguments:
> [    1.628009]     /sbin/init
> [    1.628064]     Image
> [    1.628117]   with environment:
> [    1.628169]     HOME=/
> [    1.628222]     TERM=linux
> [    1.628275]     user_debug=31
> [   11.764055] pci 0000:00:01.0: deferred probe pending
> [   11.764141] pci 0000:00:02.0: deferred probe pending
> [   11.764227] pci 0000:00:03.0: deferred probe pending
> [   11.764313] pci 0000:00:04.0: deferred probe pending
> [   11.764399] pci 0000:03:00.0: deferred probe pending
> [   11.764485] pci 0000:04:00.0: deferred probe pending
> [   11.764571] pci 0000:04:01.0: deferred probe pending
> [   11.764657] pci 0000:04:02.0: deferred probe pending
> [   11.764743] pci 0000:00:1f.0: deferred probe pending
> [   11.764829] pci 0000:01:00.0: deferred probe pending
> [   11.764915] pci 0000:05:00.0: deferred probe pending
>
> (no probe deferral happens for working boots.)


--
Linaro LKFT
https://lkft.linaro.org
