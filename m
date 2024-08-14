Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FEB1AE84A
	for <patches@lists.linux.dev>; Wed, 14 Aug 2024 10:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723632199; cv=none; b=UkW/PU3EXShfgntydqe14A9xfzEs/GNp+9rKonzedvdsiUS4KQ6huD38eJYT9jeRxTW0kQ8YzDxs7TIcd/XpS1G5b304kYmIKUjCMAa3k4SDcU/jhLHR0+bXZPdTKnci4DeOYdrUdT4AljPmWXXS0cS/sf3OZ/KyRpl6uAnsDzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723632199; c=relaxed/simple;
	bh=SJgGuHiDF6Pum/YzBX1eIhR+ZuD4wPAvutfWL+CK068=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GuhYGux0zj/DPj76uyDJv3yYe8+tXrlOAsL3oa6STKEJzh9n5ujVnDjcILA1gh3UzN+qIyqVBPSS/EKtsfiBJfMzqgCJRkPpqsJ1+9va4triEq7TpFvJZOfom7ooLtxATml1R1DbSkBFL+4A3iT0JkdGDlVuAwzAr23U9u4Q/y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JikNl5sF; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JikNl5sF"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-70d2b921c48so4969745b3a.1
        for <patches@lists.linux.dev>; Wed, 14 Aug 2024 03:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723632198; x=1724236998; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SJgGuHiDF6Pum/YzBX1eIhR+ZuD4wPAvutfWL+CK068=;
        b=JikNl5sFWWgBtiGKe60FVEf1CTXW5cmdggZp3cazug06pgziaemOvt1YIyGeGUKert
         NWYWhkAToePX3CoIbA4VbKp6lqv2JgLkl0jhN2dj0om5+T1Oflz9NTTNMCwZAsCDTCe9
         LVPkRy5OzTf14eW+2/Vdk6QJJe9G5DvUPPl0GnnqzkwLBeWFH0P4NukBIv5uztZcrn8v
         ktfrAzWz5nL8BdU7yTyXHVVcLQKpUji6BXYlQe860yA0B/DoQacppRjy07cljZt1GJ7G
         pISBzinyKu3lXsD89PchXafleMMGakKKpkRpMCWKspgsLTIGdH0gAgzjmEVR1LM52eRZ
         Wjcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723632198; x=1724236998;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SJgGuHiDF6Pum/YzBX1eIhR+ZuD4wPAvutfWL+CK068=;
        b=DRWqlhEexH0v92KRERD6bVhHe7XaNMLANqx4eaaG4hJcipTZsTzAFkWNV2kXfhNKmK
         81k9+8iENtGLohoq2Pa0C64QyG9M3sT127fEJP/5JjG6ZBs1nhhph0TW7UdNPzIAFMEP
         y5NHNp6GQSRACYbzk6xaHZjz0TdpQKrbm6/Bapu0T+SyXoytrnMPmZVE8liADulLOEfl
         +OX085tIiGkCRMnTA3DxljkVFFft3KJ4flN1HyOdAuUEObdbhllZHvlfc9WGMQkpK4Qz
         8fmtJ7noB2lCWoGb9TJ3csKPByVsC7RgyuGGNNti0XjirBF6jI+/1VRr9+KDO6JwMetF
         S36w==
X-Forwarded-Encrypted: i=1; AJvYcCV0Ff4NyAUX+Idygm6Pb26dlUsZW4b+gSYb/FShnxh9/AEEJ3qfknpclRTX9mgKm1TS4gpl3QxWkQKI8KmBVfWTM5S637+XcA==
X-Gm-Message-State: AOJu0Yzn8/Kr0u7nPOXUKarItvwOtz57ItJIfkCWu3c4Z58dGec0lhuW
	GSL52RJv4o1CH228dYqBxTM9tZ07ZhMAQ/nr4irYra6BlwqbLDis/KwN+Hwj27fgEQBB1YtZw27
	FldsFifbXSK2qSbsCpuNTL4g8qC4=
X-Google-Smtp-Source: AGHT+IFIa9V3yWXmwOQT0TMkZa8EL8RuR2frnvNvc4Gi/6m3ZxiWzN6173URG1TTCP3M1canYCwYcwApz8Y44mtHaok=
X-Received: by 2002:a05:6a21:9184:b0:1c2:8949:5bb3 with SMTP id
 adf61e73a8af0-1c8eaf63b4bmr2851238637.42.1723632197682; Wed, 14 Aug 2024
 03:43:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240507210818.672517-1-ojeda@kernel.org> <ZjqmfIhRz99BqXtD@boqun-archlinux>
 <29eacb0f-fd78-4024-aac5-1606fe002dc6@de.bosch.com>
In-Reply-To: <29eacb0f-fd78-4024-aac5-1606fe002dc6@de.bosch.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 14 Aug 2024 12:43:04 +0200
Message-ID: <CANiq72nLgdkSJ6SgMOP_k9_PUNvPk2gqQQ0sKLGn6Sn9F0+uug@mail.gmail.com>
Subject: Re: [PATCH v2] kbuild: rust: split up helpers.c
To: Dirk Behme <dirk.behme@de.bosch.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Masahiro Yamada <masahiroy@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, linux-kbuild@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, 
	=?UTF-8?Q?Sergio_Gonz=C3=A1lez_Collado?= <sergio.collado@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 14, 2024 at 9:19=E2=80=AFAM Dirk Behme <dirk.behme@de.bosch.com=
> wrote:
>
> It looks to me that this is the only/last open comment? As it seems
> there is some consensus that this change makes sense it would be nice to
> get anything like this :) I just stumbled about a local helpers rebase
> conflict, again ...

Back then, we delayed this one because Andreas preferred to wait for
6.12 due to other changes. I think he would be OK with it now, but we
probably need a new version anyway.

Cheers,
Miguel
