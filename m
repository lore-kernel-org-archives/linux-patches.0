Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CA3188925
	for <patches@lists.linux.dev>; Fri, 23 Aug 2024 18:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724438888; cv=none; b=FFHAcFiukZpU0uom86spYqe3x6ii4qAHLCSZ6LLnDvR4hFIA02o3y0R3R/uugPD3Ifwh3w4qYPp/gUZ8lxj9Eu4x6rlazNhGR8qkhKPC46c6NxSvR0PxEnZFTIzfZm0iPEp0gFEysdP3l4M47B0ICdzw5XjO5pJBOkNojDkJhWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724438888; c=relaxed/simple;
	bh=POw5n4uPK+5Wgj6bZ8E7UNaTIEwC7nnmx+EmsVvH934=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qj75PVCELCyH1/9f3JOqLIqIIH+cZF+uurkY+e96absUUNcCnckdFgM78Kz7u7Bi1SSoWFQVxkffuppUhv95VVUnoJ9sOiHUcWGw6FlkEOo1kd2sPfL0UM44jemdhI1jHjr7LA5tXz8qKY4tr8XeYGiLpRJL4HDVB9TiOZOXuZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NGTdMXZK; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NGTdMXZK"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-714481eca0cso81323b3a.2
        for <patches@lists.linux.dev>; Fri, 23 Aug 2024 11:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724438885; x=1725043685; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uk0/C1AkOx81lEeJcP/sdwvaYycc+SWwymWZxuohJG4=;
        b=NGTdMXZKkIuKCSXwFR5NM3yPs0sdL5aI7q/XXP9Uz7DqQXHaANYectKnK8X2jtC43s
         GN2pBAr5N4b+iDN1uBCyGYl40OqEYwyOVUjtZcHIdbIiLqglsnmglvDXDEd7gECjKLG0
         39U9vx0O13/sUmFWdGP80aqBJe4ot2quMGX62NnTvcUYaqQA7ZKfyG30RJ+9sG//z7xL
         7ceUkvQ1GW6sqKrpmzB+fGlwHcLRpOQk+2Z6EhfFAwzQ4TdtVRGBN1sJqnDOroeue5Gp
         lXEmbAm+pLEEJFZ99HUOKesA2CNfg1gl3KUZQ6UPy5lue0D3cIBy+r4Jjgi7tod+fgd9
         jkDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724438885; x=1725043685;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uk0/C1AkOx81lEeJcP/sdwvaYycc+SWwymWZxuohJG4=;
        b=soMaov1i0Kr7i6wmTV2h5uvExVcM1bfnXsXu7XLkSJ6IFl6cbAWJC8SJfht0aeNmLL
         9X7Cado+SxySGaCl65PG2cb59ToPtGO/KOCigOD/kKtE5QxJg1OhHEfC3GjmtIbpph+l
         0ZMsHXVd6nh5I9XGU9Dv7YXBErkgnIq9ppsZQ1r9XkJWbw7HCBjVyq6r7tXI3WyeXWPa
         x5YWPtsxSNbboM+EkNu3SKPkbk8onvDTodV/OJ8xXGUwm7OKE667AukY6sauKfwX7xt8
         xV0NlkeolN/Ucfyd0UrW34lJDDcM/J/SMtAIKrWIqSIFoow8XscoaeYJzRqC2RPQJHpf
         ejYg==
X-Forwarded-Encrypted: i=1; AJvYcCWhoPSgo2C/QU0T8BrSKuqT5y7stFxlAX8hV8QZdDdymA+xfhyIBHAw+/U+hsZVnA8EV3Fj9J4u@lists.linux.dev
X-Gm-Message-State: AOJu0YyEFwAUGJzd1PnKI4Nv6QUO9TFBUKSdcPsItoqyqf4uLht8bFU6
	XqBwygqPsUutZ5WdR8dBQm7PGmp8uzbhPrmW/tGI+HXwy+NazVex5PtxLkmnfQEwzYYIaZO9FsX
	4EfewajvXPBF83AxMRe6dI0HIG8g=
X-Google-Smtp-Source: AGHT+IHU1bqef0K7taMb7NU7AZLtkpaTLnqF/hx5h78WBNReGSNhGIsYsg5UQYCcuDeEKg1DlAP70nhcV8uXO1TKuAc=
X-Received: by 2002:a05:6a20:1589:b0:1c6:ecf5:4418 with SMTP id
 adf61e73a8af0-1cc8a01c07bmr2328000637.4.1724438885555; Fri, 23 Aug 2024
 11:48:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240728125527.690726-1-ojeda@kernel.org> <CAK7LNARhR=GGZ2Vr-SSog1yjnjh6iT7cCEe4mpYg889GhJnO9g@mail.gmail.com>
 <ZsiV0V5-UYFGkxPE@bergen>
In-Reply-To: <ZsiV0V5-UYFGkxPE@bergen>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 23 Aug 2024 20:47:53 +0200
Message-ID: <CANiq72khCDjCVbU=t+vpR+EfJucNBpYhZkW2VVjnXbD9S77C0A@mail.gmail.com>
Subject: Re: [PATCH] kbuild: pahole-version: avoid errors if executing fails
To: Nicolas Schier <nicolas@fjasle.eu>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Eduard Zingerman <eddyz87@gmail.com>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, John Fastabend <john.fastabend@gmail.com>, 
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, Hao Luo <haoluo@google.com>, 
	Jiri Olsa <jolsa@kernel.org>, bpf@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 23, 2024 at 4:00=E2=80=AFPM Nicolas Schier <nicolas@fjasle.eu> =
wrote:
>
> Do we have to catch all possibilities?  Then, what about this:

Something like that sounds good to me too -- we do something similar
in `rust_is_available.sh`. We also have a `1` in the beginning of
(most of) the `sed` commands there to check only the first line.

I guess it depends on whether Masahiro thinks the extra
checks/complexity is worth it. Here I was aiming to catch the case he
reported, i.e. non-successful programs.

Cheers,
Miguel
