Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700AA1CAA4
	for <patches@lists.linux.dev>; Sun,  2 Mar 2025 17:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740937527; cv=none; b=NcI6aU4C4RMA5T5V3SIZtuVqBjYmFaMoR1PzksPTKDH+2Ut4oWNsFa8+Y0RmHtMTT1Vkewf14Ja9iTT9b+RI3FtKMywufsKLGUEFkoJmaxBN88v2m1KaAlXdMg7lHDQJU0bG04mvmxYAZjlB7Kg/Xvi8Wcb/1/ErbJAVMUD0FgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740937527; c=relaxed/simple;
	bh=k3vFqL/xKCk8f4E661+8gVjTKIGeRjDEleSeHCMboHE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V+Md8ksuovLvtE9EWYlW6RwnKBPozRKyvzCD31yCmKwFj07m4vFTqNEJ5UvqfADTr+0TlcrEY5jdk/ECuSMXEx4WshK4zCK7Qb0gWHGZc3BCPCNNlmcEExiwcSTi/a5ALyHJw+AgHz9aBbeIhW90gLxKWOp67Ys5nEfrfoV5wLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BSO8pmGw; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BSO8pmGw"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2232aead21aso9508265ad.0
        for <patches@lists.linux.dev>; Sun, 02 Mar 2025 09:45:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740937526; x=1741542326; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k3vFqL/xKCk8f4E661+8gVjTKIGeRjDEleSeHCMboHE=;
        b=BSO8pmGwOsBy4QvkiuF/tab/IaE292GuljWU+VreioV+y7gm2VUW5NIq6i3Q9uwxly
         umP4p88gXyaRsWT0l+qJI5dWNpEBetq3/6Z30q2HxwfwVvVIYbSx9oQGsnHM0Qf5IkKx
         9oMDiZDxqp7wML4uk4dwlltpeV25c//1LfFEBSVr04C7y3+2efwO7twv2lBzlCa9XOWY
         gSPjkxJTFbd2hyVXUd+lLqTqZ7iCqQsL2PStoEm6a98eeAXGsWDVcEeQGf8FZi3d885Z
         JD4n1FTu1xpmnRAdW4G9PpjLncvEnlrZLKSYjNdOSaN9r5bqZvu+IJ2OWs6lzj18rjU7
         h7Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740937526; x=1741542326;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k3vFqL/xKCk8f4E661+8gVjTKIGeRjDEleSeHCMboHE=;
        b=f2wURLtsv110tCBELfakWY7ZpOx5ZUGdpjGVGkkqB3W+q73ZSnmn7rGsIn2naLDgZw
         9tISqNg8AR0SkNNEoHSpx1HgDN7OyMoVlcmc2vSdwWdS0hD9b5UGBcbhgWh+agcsxtFw
         lgP6LHuyHjGzzsz/rLe1w20Qyf6CFk8HCmBYzqAYNj+FlycCKkistSrA3fZg0YwrI4/Q
         V+2JozJvNMyPI5/r6rN99UbLTGmGa8JAqaH1iEMWc0E2I4vWQ8NVQbBWwgBkZYBOG2UA
         NoyV5azO95stJMNH1mp+sEEvfg7iOiDFUpFwjXlR+eg/iY1vVWZVfwrbryoZvVnxwVBX
         YVWA==
X-Forwarded-Encrypted: i=1; AJvYcCXmqoFIz6x9E19J+iq5WntuH1ODQIuX1yaU3t7ILEUU4YfTdei/+VtXg5rg2ey1NTiDZptjvH4M@lists.linux.dev
X-Gm-Message-State: AOJu0YxsoUf8PePlhNhpYlUgzGUliDx0HBRW+VfeiVi1S0usyJLDRGkp
	b/ggJ2PdssqJyVEVdKEKukD55nToW77PB1W2FUDUC9usN/1FTH4dXoTXK6m1eR5xWr7iybjL6Pl
	uFB31iqON7LhcwSuxktV3eSzFYWk=
X-Gm-Gg: ASbGncsACfGNn8k/qufgU7mx9GR65vExecxOuVWraBKS/xZqw9WyYlrogDPIIF8UWWV
	biFLSUiyurXwUWIRe1QjZ/XXiHLRO3mtyvDdfEi5VDt//7IMxGQeMloSXjSOZJeLiSZgXFjW10D
	4O7uJvLE9E3lDQheojW0SmZlvM1Q==
X-Google-Smtp-Source: AGHT+IEM14oBkasxbrfLuhdlkhBgKZTVdRXsNXBGHPpuX7+iINgsw0kMfQM1BNFq3lNwVS4ywEhQiqhc4ZksgvZKfdc=
X-Received: by 2002:a17:903:3ba4:b0:223:5e57:44f0 with SMTP id
 d9443c01a7336-2236925928cmr56864515ad.14.1740937525642; Sun, 02 Mar 2025
 09:45:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250301231602.917580-1-ojeda@kernel.org> <20250301231602.917580-2-ojeda@kernel.org>
 <CANiq72=69XAOapYBurbwsQOEaw2uamZ6ta=DT6cC-om9XK3dvA@mail.gmail.com> <Z8SMTiWzTDjIwGfO@kernel.org>
In-Reply-To: <Z8SMTiWzTDjIwGfO@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 2 Mar 2025 18:45:13 +0100
X-Gm-Features: AQ5f1JrCn6sPBiedOcepz2gVBmJgyJO37jSMsKXrpOq7sHIUfZKwiTfBkhdUN48
Message-ID: <CANiq72nQNFSa0quEwLYMUVw-2CH3FwrV695k-rWfoQn5r0Mo0Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] drm/panic: fix overindented list items in documentation
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Jocelyn Falempe <jfalempe@redhat.com>, 
	=?UTF-8?Q?Thomas_B=C3=B6hler?= <witcher@wiredspace.de>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alex Gaynor <alex.gaynor@gmail.com>, dri-devel@lists.freedesktop.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 2, 2025 at 5:50=E2=80=AFPM Jarkko Sakkinen <jarkko@kernel.org> =
wrote:
>
> (cosmetic) Nit:
>
> I think you could just:
>
> Cc: stable@vger.kernel.org # v6.12+

Thanks Jarkko -- I did something similar in the past, but sometimes
patches got backported too much because they could be applied.

Normally they don't hurt, but I try to be more explicit nowadays so
that the stable team can decide, and thus I copy-paste that line for
changes that are related to new compiler cleanups and similar.

Cheers,
Miguel
