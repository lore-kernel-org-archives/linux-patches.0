Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425E4481B1
	for <patches@lists.linux.dev>; Sat, 30 Aug 2025 13:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756558844; cv=none; b=sKm9dLCSr4mnke+hh5eS4V9v7N5iynDLInvlkU/4pN9KRlPuxQzhYNqBuqy2IVMpI8TJhQCeRQXg3wK5muXTNqabBqfHWgdOdArv35mHb7b04OvvfaIsIMpd6IwrZSobtlwq0XBA61iV9BAigl4N465tCBos3gyoSpnhdOSg6Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756558844; c=relaxed/simple;
	bh=Bx/hAtyOCoWdaGajFThJspKBa5Qz5b24ZK57VCx3CEY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AYY1VzKqj4ZKvXumnM/ECtnFyRzkce4v7dF8ML7P5ViqxzBfdbY+mXTKxh7yb3CzkgwyBHnmczglnxR5Ntwj7iC1taxxzdz7efZXDXJzFff8lKz4gllA1pdxu45yzmGqodLvtKWLP9vOAZMDsiK50b12tVCav82qlIRSpcwH7xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q6a6IObO; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q6a6IObO"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-24896af0650so5831955ad.3
        for <patches@lists.linux.dev>; Sat, 30 Aug 2025 06:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756558841; x=1757163641; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bx/hAtyOCoWdaGajFThJspKBa5Qz5b24ZK57VCx3CEY=;
        b=Q6a6IObObK11AeCFjDJLrjwuSdmt/ZtwO1hIcZ6DbmfygI2oReciTvKA/C/76QjeC+
         fVrN2eo7jszOCBleyQrMPuaeOLsGiiZJ/ousLBfH82VvWk4jZPJjZRm6K49iabF/mdut
         8dcZv1/anMOEUZq56bnuT/66PYIzvpcZviluF6IisrVcwZytOWgYWiFSOFtmzBJwyCzI
         NgPbLIujoUBp3+tgg5jhUR+4c9OXK3lpDlJxh2EdJaTP7L/Yr7pHjklkYyjZiu3ZTep2
         /3X0WANgMiXsXNJL1bf5oAY09QojdONv4mTC1tmSnLhgO/BRQsldDjgGz9s71HFssjuj
         QjkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756558841; x=1757163641;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bx/hAtyOCoWdaGajFThJspKBa5Qz5b24ZK57VCx3CEY=;
        b=QR+fG9bU7peU8O28dDw277eDVv3ZKknZZvhKax5ENDPJyA0pnyZU2CRB9FKUEicpUb
         UB/enY3gGHfyQAUvtxVe9u7kbgg6EG0Qwiq/u1IiMeBrr7q4GXznXS5sBwtWVWC8/mLb
         YidcH30RYuOeiEaBSGoJ8JGPqFqIZCJ4WaIeTz23+4nuTcEzryLHPF65mPXyDt6qKLcb
         MuPLNhuHFQRmfRXpn3TGeOoQIS20pHiEXU7qLbb9r1RLVHpvg8iGD5+iCqzYtZCYC8Og
         mqPfxNurGuKj3e851w6S6/96qjLp494FvVmLwQb4c1+2hS/wEPcaD5f1ATvwXFpPJwNb
         8JPg==
X-Forwarded-Encrypted: i=1; AJvYcCVBHyroJzGqhxPutl8VtqOCOrEyRKGWHSdMTIf5CHuK+/UIPSsIimMxSrlzzCJ7h1zhAl4tqwPn@lists.linux.dev
X-Gm-Message-State: AOJu0YyWIBRPMYBKOloQvKTDckWxDlf1LFlNtFqdGhaEdRMxZjyjVejq
	ErIE3f6g1Blj4+L1+hXx/PjpE7Mc2lb7GvLoD/KlVNfM5gP3QqR7gwmiE8YoNGPgYRazRB5boHs
	cFwyKN1CE/jbR/EKoNmw8ET5VmEX2o+A=
X-Gm-Gg: ASbGncv13yS9HGMFy8Eam6dnXocAGTX+Itq/dIAhHtPF78ceebmZ0XUf9T5F98rw/W1
	cdu871GQx48qSobQ9/OVpiT+xBDHnMqK5eAzF1OeRSRXP009epfbdNuNbKs/haG/AW0bPllIcy7
	tCOOYq58AwnfzpO6Ut6jskQRCa59dCZggrx6yP10GQih0cf0dVPzbfEZ1AmKFYZP+uyIizT629X
	DWP3kd9RwMxGs3xE1ueoXXt7vv9d7kqnAR0bslQ/VT9MTIeM67mbHEQsTFmklT9qQynwBk2C0kp
	9p9OSO73AQZBfemM3+djzO/lruMfpHPcyq0P
X-Google-Smtp-Source: AGHT+IHfl+YASYdINwtLRhRTrD0q/+tMzOV28mEvA8C/FMutP7GVc2CKdomiL4R6Uqe07vKqFV3NQFD8S9pGLI8hSuM=
X-Received: by 2002:a17:902:e546:b0:246:a488:52b1 with SMTP id
 d9443c01a7336-2491e1ed207mr32288185ad.1.1756558840986; Sat, 30 Aug 2025
 06:00:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250829192243.678079-1-ojeda@kernel.org> <20250829192243.678079-2-ojeda@kernel.org>
 <DCFR8DTO39D2.1RMIDS2RUJ3H9@nvidia.com>
In-Reply-To: <DCFR8DTO39D2.1RMIDS2RUJ3H9@nvidia.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 30 Aug 2025 15:00:27 +0200
X-Gm-Features: Ac12FXzGX7FXGSzot6iEYVQnSG3OajW9Y-2Vb2BYM5xN_BpYVdypT8X5l2h2PVs
Message-ID: <CANiq72ms=aqiSm2owBqTbviJVk35CMKQZ6G0XmeR7-0fajxjqg@mail.gmail.com>
Subject: Re: [PATCH 1/3] rust: error: improve `Error::from_errno` documentation
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 30, 2025 at 2:18=E2=80=AFPM Alexandre Courbot <acourbot@nvidia.=
com> wrote:
>
> Small nit: this leaves a tiny chance of misunderstanding that this
> function actually expects literal negative integers. How about using
> e.g. `bindings::EPERM` instead of `-1`?

Sounds good -- or perhaps `EPERM.to_errno()`?

Thanks!

Cheers,
Miguel
