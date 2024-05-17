Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFE82E852
	for <patches@lists.linux.dev>; Fri, 17 May 2024 10:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715942478; cv=none; b=c3fcDVGaGNpf3nX5QVlxoQOqUFFSLKklinxmZyj5DsSzVAJOqxoDWGRw10iMCMf+hXiDzXQG6uqxOWPU8q4CSHG85OtQaOFR+sB/57YVyPgDiJMgtEt3Tk94/2O6J/ofVs+/QReWpYTMh/Oo4RgSv+ZOKl89RV3PQ87YXA12Q/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715942478; c=relaxed/simple;
	bh=HnELnEyUYaEKQpflPqcDhBPrjVZ6I+K13o1A83gtzZg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JQ/oq6foEjL/hAdnSIffQBgjEWBcOpGIFTQavFf/OEehOkn+NBXEcNA/jFqR0+yG8gK2ssWHyiKUfZM679YjzyFz5ERhhCf7Im2yW6YRjkDcctmLzhmEhvIH562G6WTLE0nNmGyAVUnvb0nQ61xfUtRpo8zaETL0ED2hp5qkkKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jzkLmhll; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jzkLmhll"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-5ce07cf1e5dso853988a12.2
        for <patches@lists.linux.dev>; Fri, 17 May 2024 03:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715942477; x=1716547277; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HnELnEyUYaEKQpflPqcDhBPrjVZ6I+K13o1A83gtzZg=;
        b=jzkLmhllhOsdS10iMdVlpxBCWo49u+Dv8HOu2Jahbkzz4A1k9C3q81G2xg7ryG59wt
         JElAJYdc1NWVNs49xozy/rd9AKs2Lse0ggnGNb7OPPRRaXJ2wdvMnC00TqjqbMIxOho9
         pJckG35noxlh8QAuP+tdnYONagBOHYDeACPWxaGYchQHQxMypreajpGqBSufXxZCvpo2
         iRa3vjz8WnjOJMQ4h1q/GFWLzCZeRSTwXd56Mkn07h1tnVw9l8MGofXWaXRwke5xpxBW
         ypxphicauRH0dn+XEIyeKln8pLj+Z7bv0tQOuPeyWd2VusbwrR96dgiHFYpAzfydlJI9
         79Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715942477; x=1716547277;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HnELnEyUYaEKQpflPqcDhBPrjVZ6I+K13o1A83gtzZg=;
        b=llJYf0KByqLPL9O70FyB55zOC3LFtREhdGyP9k7OGXFxSuY9FwFuWimLCPtZf94PUi
         w3S6ty9VMBH2qy7s0bO5D0vahejkQx1LbXESp3MbIWQNB4Giycv3qD3ing2BFqKmlb7/
         JegmOsjdyIKoD+fZonAQL6tUN7tJa+wMJHhhmQPKpCuABF7oZmzUHpSCNwNy7zNPlW9e
         JxLwLl66Jnf59ivsZhxzIaSYXrTG31GwQLeVbWIeKvanDUHfzJq0+/sIlg53LNJvfwCF
         3RKvHOs0B3UOEKm0AgdySKqans6qQrXTajh2lZcWmJnVbVGbTTqaSjAb6wVsr4BhmIJB
         tnUA==
X-Forwarded-Encrypted: i=1; AJvYcCU2dbxYEXPBA8SmZ/qoY18bnI3Xe6RPQ2oLtAFpNdr5sr/VG3rk1ZlbAWkMcOu3z+cQE55uHTbDdGRqgHM0LuQVVMX5IpUgoA==
X-Gm-Message-State: AOJu0YxbmLqdWYmZNBCLDy3yFTQzSXarW8sN4Uqx3nsXAj99lDtyj6V6
	9gVmNvq2Elom2YfC6JEALvrzbla8V7LaIRltUPJeunG3V+tLtqPHPIXPqSObr30Q9ON9ynhS2ks
	yH9CbMiiR+1rWQcYydkekU1PqheU=
X-Google-Smtp-Source: AGHT+IHuZeKXtTVhGQKp1k29cbNkxgUfOuOsqfJ7eybmj4e6pQ5Rztp131C+Gw30g0TdCnnwnVqbyby7gn/y+vnmB+Y=
X-Received: by 2002:a17:90b:1d05:b0:2b8:e75c:c7e3 with SMTP id
 98e67ed59e1d1-2b8e75cc8abmr13712438a91.6.1715942476620; Fri, 17 May 2024
 03:41:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240516091232.619851361@linuxfoundation.org> <ZkYCYxoxqrwlVSI5@duo.ucw.cz>
In-Reply-To: <ZkYCYxoxqrwlVSI5@duo.ucw.cz>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 17 May 2024 12:41:04 +0200
Message-ID: <CANiq72k_JQVy=xYeFYb4h-gds=_4HPcV_1uBmUnaveSXVBPkdA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/244] 6.1.91-rc3 review
To: Pavel Machek <pavel@denx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, richard.weiyang@gmail.com, 
	masahiroy@kernel.org, ojeda@kernel.org, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 16, 2024 at 2:56=E2=80=AFPM Pavel Machek <pavel@denx.de> wrote:
>
> These are marked as Stable-dep-of: ded103c7eb23 ("kbuild: rust: force
> `alloc` extern to allow "empty" Rust files"), but we don't have
> ded103c7eb23 in 6.1-stable, so we should not need these.

I think what happened is that I asked for ded103c7eb23 to be dropped,
but its deps didn't get dropped.

Having said that, "kbuild: specify output names" was a fix in its own,
so we may want to keep it anyway (with its fix).

Cheers,
Miguel
