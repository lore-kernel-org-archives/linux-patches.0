Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD4F2E9743
	for <patches@lists.linux.dev>; Sun, 19 Oct 2025 18:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760900377; cv=none; b=rKzoQVlQ9pDiTS1i/ZLs0YxwEuTDzwjdFzrqANC3fqllFzhRs0X+VAwlzQ6ify0gkASq3U/7JHNDUscxTBnP2N/NyaymuzZ1IlXl21NUMWueMIpyGIRnv0tFFwL2v71aA5aeXbxXB9IWoUOprN2/YgauqMus1OBmDN5fPKm1qFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760900377; c=relaxed/simple;
	bh=nj/PwdyUHa3EdM3zA/zRNjpb3Mt3Z/MnFk71LgogL/Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QGljpsfKEl+MDSxjVdec7V0dP4mcOkytbfYDpNPTrf1LKSz156GHlHH6b9wU1pWOtrSY+mm9egLXcZadcePyNxnoIQy2FN7y19Giq/wwMeRjOOC9AmB14HT9qXfAP8iqjNguWL1jQj9PkGcLb79UpSXj769sC7G7nbHCc/laG4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ll5aP28/; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ll5aP28/"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-290a33bfea6so4605575ad.1
        for <patches@lists.linux.dev>; Sun, 19 Oct 2025 11:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760900375; x=1761505175; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nj/PwdyUHa3EdM3zA/zRNjpb3Mt3Z/MnFk71LgogL/Y=;
        b=Ll5aP28/QqABBC1i8RiVUYvejZgQVrKTLzVRdVoUWaGJSeRi7V4PoHxoRcoj7x0p9X
         J5YPEAy8Jkt07Ih+UmXIhaz1cXyMa2zkJC+xPN3ECGnqQRgryIz2Nj3Fxq26b2r8E5Wm
         OpSc9CTjP1hlaKFKaY6cDC9n/r+JgmUnYKtqeVyUfkvu3Et1u+CK58VMUcmF1mQ1OiQT
         9CaaxxgUtthKEfLTNy1kxDLbac82aItk1U3UFKbm6bcwhjaqGCbV2zzBOpQShmVkMJWH
         TNDActkyqNGReoF3hHImQ8zKBe859GCHb2ZOG6D3RSxtNoaRVhoaoDAGGnbsMtMgRRmX
         PlNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760900375; x=1761505175;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nj/PwdyUHa3EdM3zA/zRNjpb3Mt3Z/MnFk71LgogL/Y=;
        b=NSpBgpB1LhipukevuE8dKDOTEqIJ+He5Z9TOb8v6/0+w0j9ci75vvHSxP612p471km
         KO54gWncgHenUl5UwNcc+cxRsRenzKNtTvx3JNngc52p1RStaA9FhTjOawZPsbiZhaeL
         Zx40jzdC03qPsf4l1cL73v2kHl3x4eIeoqmFwkv8Fm2mq5KrI/OmDXHS9pFWPJlR2zCO
         ncWrcLpIjqEv8BeOopTHCLxKARhIY6X9NUktb/KqgD8en7aDbbgawhp/36kphm4In9io
         0Tmb3GZwitDilK+cM/O+psKDg3ZWhbW7KPgheMDIv4ETJL9RINA7nHwcronksvifAC2l
         QL1g==
X-Forwarded-Encrypted: i=1; AJvYcCU9jjSu5utwvsTM4qIqNjckiQyTf1kMOsVOEycjiuFhqGHCA14Wt/EvRJvOTTCZ64VjPrEGaP48@lists.linux.dev
X-Gm-Message-State: AOJu0YzJFkz1vQt9+Sc0dU2ryX/kob7IRvsymuPhEzMoFwIHZ2DQ1WYR
	C3ei9i7g3t+WfA/Slz0hd4u4Enf+XPsU9YWOLghuYCMPE9P1ZaomnUk9PjYRZJubXJbkfj1YqYh
	w6fu41H9gpV1ZsZKnUu3FXqRo3BpvSTY=
X-Gm-Gg: ASbGncvlPFjUu+RFS9k7fm9ooVhN83XJeqnGJfyaUyCz3HZHdYUcxfzhwJ8tjOg9Pzw
	FChc8kuLfevRqNL7hyhPDvXZ/erIBtciZhGrhY/G81rqcihlcMCg6+zwuq9SlZqlHi51Qxc/yR+
	Qun7TCiYuzgNFKZGn19gd8bjrsgfx6rbOFSN7o3WteSEazUU+JcYpoZhNXNZrXNDYyndmc0kwJn
	zcQ7/8tn+9fy/oe+cfgXRreutdDg058hMS4uw1RThlH644Nss5WXUeus2ukNx0Y/55bGFbg4+XK
	8rfn/DSWcr7Oa2v6r/tfx4LxS5dugkWI+/G38WJ/JSGQGMYFxgndfdXnYqjKXdM8kIZo/KDgQ4Q
	HXumF5Do/9/qDWQ==
X-Google-Smtp-Source: AGHT+IFUNFNsgIHwngvFwlMG8aMEOLjZJdhe4E9fo3Ad+ao+mbyr4xKCUfGHRwuRI7LG09H3cfLrVwORSg5QxYsl3ks=
X-Received: by 2002:a17:903:3d0f:b0:274:944f:9d84 with SMTP id
 d9443c01a7336-290ccaccc47mr69411885ad.11.1760900375198; Sun, 19 Oct 2025
 11:59:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251016231350.1418501-1-ojeda@kernel.org> <2025101758-mystified-prideful-8016@gregkh>
In-Reply-To: <2025101758-mystified-prideful-8016@gregkh>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 19 Oct 2025 20:59:22 +0200
X-Gm-Features: AS18NWB0V0r9stVsy6SHvBBPktKhMWz1R1H5p861HWbvzNbwfaAR3voM0H57gac
Message-ID: <CANiq72nXw4+HesrgNqJjTy6Ji=pVqUMzx7GDO+6U9VYWezTt6Q@mail.gmail.com>
Subject: Re: [PATCH] rust: usb: fix formatting
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, linux-usb@vger.kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 17, 2025 at 7:42=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> I don't rebase my public trees, so I'll queue this up after your changes
> land.

They landed in mainline, so Linus' tree is again `rustfmt`-clean.

Thanks!

Cheers,
Miguel
