Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278D41A3026
	for <patches@lists.linux.dev>; Mon,  2 Sep 2024 16:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725293478; cv=none; b=DOqRMK7C9LEOQvdyrYNW4BFbNnUWFp9ETOQ5nFE4/2W61RcIs/6JtLXzHYfxTwVsfuo5+d4S93f2ljQPfztn0Wk8nu0coHe32dHJk3vNM6X6ZOpu0iZN34VZkNOHhFiAI6fWqxRUapWeOnpZW9FwMUIWwWRz8q1zTaT5S66NJv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725293478; c=relaxed/simple;
	bh=wk7mJjx0Xs0Q7CfUTyDNU+Eh3I4XTXvSQzWkhmeVDwY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y6QCZwnT/Tz0TapfWSE9foHPxImbE63lv8ws+URsj7JmmLpEnreaZTD7QiHvJdycY3kDw1Lfr+n58NYiGa+q71tV/wKUx6zcZkz7b6KDG1WKL8Ze/jHDh2CMEcTuPWj8M1egPk+Vb4plfxoh8cqh2kJ855lqzWbou5U9zbwYYOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=myc1mpdd; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="myc1mpdd"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2d4750be8c6so724157a91.0
        for <patches@lists.linux.dev>; Mon, 02 Sep 2024 09:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725293476; x=1725898276; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wk7mJjx0Xs0Q7CfUTyDNU+Eh3I4XTXvSQzWkhmeVDwY=;
        b=myc1mpddBe7UquEw3mgS41MCWLS7XkV4e8tbEMQczo8uRmhpG/bYV0NjS+VHfg9TEC
         FFQX9a3M4l4JOMWwLbhcC3ZLM3I4R0sbKxfyEHtQ32eRX8GgU2b8n6dQM2uvMBNrYrKa
         tgGgAPvqoQ7LhLa/IczYqib+uu124OZkZG1wZAnzEKvEPDOoaWw7T5h+XlwhEBM4CMp6
         H/HkMFKfhK0Lig+0hPl9ueaPmoCZu39Md/2Ci0iVfMmFOS0h6lmJw0+wF8gIkX5I1tOr
         bhagthqZX0hW/jPY6q8p0K80rpOHJkgdKWCdmo4TYV4r5CM9wWZV70DiQ7nCudcudMys
         2Aiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725293476; x=1725898276;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wk7mJjx0Xs0Q7CfUTyDNU+Eh3I4XTXvSQzWkhmeVDwY=;
        b=dgPPcAr3EzD3TglOoGEmQbzAkZieOqqRaOhqQEUHCMkyKIIm3KF/xqF20pYvVebTTz
         T1F/klseXVBqzC9tqCWdWZmTo7fev32UYU5n6P+4pHHJt5kx//20YJvDAFRuqrIu68s0
         zrJLNQiMgm377geopd0gLJQIlrbmaS1rmdG4vnoSlQ1AFPMkVQ6qa+SavxZLjWGvI/qB
         OLq0SI9zZ2xs9PyfN4DTAzGxvcvz4GDWdAbKi7Wj6jnvuJPLR7KF2+/SvZQlN54+JmYS
         xYYac/Im3y80N0sD3X5AAXPzzJWxiCl0YsbmhGJF6/Kc6Sb4wDVW9CN9RLK/TH4x5BKx
         sJhA==
X-Forwarded-Encrypted: i=1; AJvYcCVDl2+sFZp6kdw+XDHPugVzd1G+7pFNlz5VQlI9uUVbJr8qAUsl3yWbIsZIyFCKXYLFVYdW4R8L@lists.linux.dev
X-Gm-Message-State: AOJu0YxKd/PBKUb9TphY9uEyvXYEIE38mBpi4tuWPRv3guzNsxb2WBKW
	qwhSgGsK5eyZdVrXAktrGg5xUCV0ZcBnlRpZIjNjnZ/toh/2lQsyez1h2K0FVMO+oe3URDfsfTe
	uWamHQdNeYXIeu/SAJ1rFzlgcHpoxUzZwtvc=
X-Google-Smtp-Source: AGHT+IHuwEJDhCc4s+mmfVcupdQTMg6prAW9eGXQCrQq50fzIiiapvtm80hin/j+dLtZBzIECbJiloot8yiAcR4eJR0=
X-Received: by 2002:a17:902:e303:b0:205:40f5:d1a with SMTP id
 d9443c01a7336-20540f50db1mr48362355ad.6.1725293476345; Mon, 02 Sep 2024
 09:11:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240728125527.690726-1-ojeda@kernel.org> <CAK7LNARhR=GGZ2Vr-SSog1yjnjh6iT7cCEe4mpYg889GhJnO9g@mail.gmail.com>
 <ZsiV0V5-UYFGkxPE@bergen> <CANiq72khCDjCVbU=t+vpR+EfJucNBpYhZkW2VVjnXbD9S77C0A@mail.gmail.com>
 <CAK7LNARJjM2t_sqE-MePzEEF3D3SznNYh99F5bM003N_xGFpug@mail.gmail.com>
In-Reply-To: <CAK7LNARJjM2t_sqE-MePzEEF3D3SznNYh99F5bM003N_xGFpug@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 2 Sep 2024 18:11:04 +0200
Message-ID: <CANiq72=3V2XYgmFME3kab9VMrT1yBi9nr99X6CMrqUjvTVMTtA@mail.gmail.com>
Subject: Re: [PATCH] kbuild: pahole-version: avoid errors if executing fails
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>, Miguel Ojeda <ojeda@kernel.org>, 
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

On Mon, Sep 2, 2024 at 4:15=E2=80=AFAM Masahiro Yamada <masahiroy@kernel.or=
g> wrote:
>
> Ensuring this should be easy.
> Why don't we fix it properly while we are here?

That is great, I would prefer that.

Sent v2: https://lore.kernel.org/all/20240902160828.1092891-1-ojeda@kernel.=
org/

Cheers,
Miguel
