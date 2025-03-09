Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBEA214218
	for <patches@lists.linux.dev>; Sun,  9 Mar 2025 21:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741557347; cv=none; b=FHjt1v1tmZSsrA1m3ZK0zQY8peRzv9Q5hloaGGEKnaS4XI1XgBVRGo8rOrJe2AXRbp2otACYBmsZ9LbHzikPY5Ns5ZSb4wmKC8XMJPFUk+NkeYN9BD2fJH7Ge6hJXV/EU/+V1+K2fKw9/YaC7aYANTcfGdxvyuQP1dLUjzwPdNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741557347; c=relaxed/simple;
	bh=GTq6UEu3Li4X7ErToPMFMwx2eg5l8CAxQ+gMdiZqzhs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ipoecnuyd8tfgA4nJl1paI9IcSkHMXwBol0T8Sevu6t5UKRw8Sd15oP2M+uyYAaO5XdSWdLYw3zEubM8xMElYWwm6dBCe8B8JfFGHu9d6u6Ur7oDGM4AKphhbUFbXu9Uo5JPWEuaad+R3ch5w3P118/Qkvf39jG+T8NR4hwwivc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OHJ4T2aT; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OHJ4T2aT"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2ff73032ac0so904337a91.3
        for <patches@lists.linux.dev>; Sun, 09 Mar 2025 14:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741557346; x=1742162146; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GTq6UEu3Li4X7ErToPMFMwx2eg5l8CAxQ+gMdiZqzhs=;
        b=OHJ4T2aTapGIicF5an66ahfp9i9KRnnTq0jTRAv3SnETHgFr+S9ovaDnui2EXjsN7q
         MWknnSZXVYNdhBj794epVQqn0cU9/GVGPb+/0FAmRWIM64JpiNYrK6le3Lu5gCUFrLFN
         E2CNRJUvKMqGLcgomI/hJaKoeDKh2e3ll2iXPCT4aFEcg17uFPBGfbybjhVI0UX80bt8
         e7l2DP1/H5b4xIIAbkxOveO8FRwPexYiLOkS/OmfhzQzFl/dxY23AtESXMSCLALURp4b
         JIvqH0cZCvPfOyVIlW+25MGwWvyeL0R7dxjS9epY9sEU5gXFcyxfi9oUxP/31TfRHS8v
         9fHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741557346; x=1742162146;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GTq6UEu3Li4X7ErToPMFMwx2eg5l8CAxQ+gMdiZqzhs=;
        b=pw1D+zx4hrbjGh/nNLC2fjniKBMYtPHIcatEAvgaKfIRWFMo4qsI/XrF8SrQOqbNMH
         1xccranmWvZ8LXOYe+KiBBvTYMiy0ixGNojQal5QKmHXQr1edhSxO17ftcGoXuLwnpXf
         S6m1XNiax6hNBmc9PkG4ttV22hE0Hpd8ViCva25i38X1ywLeRa++DsLledH5xTy5g4Cs
         17UiURNUdw3F6P9oFgaPNk5V1EWUxFFoeGX0wHhq1MinwxgI+xlj268LgCWZrOeI3uII
         M3R7cnbcHERzx2uz8a1OAi2VEvqlZ0IMDROwvs+xXuYalq1w4XUPOK+xuY3BBq6qX8Yv
         MjAw==
X-Forwarded-Encrypted: i=1; AJvYcCU1AgJ2tT2UJ1648dcFGCYeIKyAahws7FsTp7TOn1AvJarBh27aAPe5IG0sFKA6QdbVAks6SfeV@lists.linux.dev
X-Gm-Message-State: AOJu0Yx9O/xEJHmSi/iWjRrT86sdKHtXq9wU334QITxr/GQUxImDTpP4
	mTgjEFRXeq91jTSVabvp8fTly96TrTPu7WUNk8KRCM8rnS6h5hU5NVuCrqQUqM4MGcaOw7xwPch
	6tAUDAECz1T1WjA7eMQ4ao5pziWk=
X-Gm-Gg: ASbGncuxom4i3UddlNTEyQ9e5fduFrEG4oa/V2NUeEA85+F+H6bRQKS1oZ0/pJSg2k1
	s7g56L054GyHiKxigkBBEHdflhRATdxQov50PzGSP3nf3oLks0BuqHvxO++6nzzKWNciDXXDF2H
	T8WOiqmjm0g8tE4KptOVtQSZhJRw==
X-Google-Smtp-Source: AGHT+IHXlAJPVtOg05iMzwq+BMigf1lmxizD3DaJUYSB9U80GIORpHkKG2bK6XK7N00HhDagNjnQiESufq7xg5WfLB4=
X-Received: by 2002:a17:90b:38c1:b0:2ff:6ac2:c5ae with SMTP id
 98e67ed59e1d1-300a2b6b6f4mr4206702a91.1.1741557345730; Sun, 09 Mar 2025
 14:55:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <Z8sXqXgfhHbNpG6B@google.com> <20250309214857.1559606-1-ojeda@kernel.org>
In-Reply-To: <20250309214857.1559606-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 9 Mar 2025 22:55:33 +0100
X-Gm-Features: AQ5f1JplJ2sdLw88CGdK_039ODMPr-eVmC66w8cRjSL3sCK1VExgIqPYi5hdaQg
Message-ID: <CANiq72nfdTDdk2TFJXMtdM5fpRQPkn38FEqQkNH1+xB45L99QA@mail.gmail.com>
Subject: Re: [PATCH] rust: kbuild: provide `RUSTC_HAS_DO_NOT_RECOMMEND` symbol
To: Miguel Ojeda <ojeda@kernel.org>
Cc: aliceryhl@google.com, a.hindborg@kernel.org, alex.gaynor@gmail.com, 
	benno.lossin@proton.me, bjorn3_gh@protonmail.com, boqun.feng@gmail.com, 
	gary@garyguo.net, lina@asahilina.net, linux-kernel@vger.kernel.org, 
	oliver.mangold@pm.me, rust-for-linux@vger.kernel.org, tmgross@umich.edu, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 9, 2025 at 10:49=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

s/kbuild: // in the title, sorry.

Cheers,
Miguel
