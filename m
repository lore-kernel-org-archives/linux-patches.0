Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94AF017A583
	for <patches@lists.linux.dev>; Sun, 27 Oct 2024 17:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730051967; cv=none; b=aoxUCCEN4EctQRocuOBLoYqo9eaj+V7gRfMPVrpcnWrK3rXv1UBMwuguKWS943t2gH8FwhN6NfEyueqx0h/lPNdwzwJSYY86iLx3MvU7scRlbAhFcLeleXyoAFCUTxvignbqnceQqcqwLfGtS1UvIrAvHJym1jfIa/CB3OACPo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730051967; c=relaxed/simple;
	bh=0UbSjGcSDB+S7wUx4CXOcRobJQ1oRD4vD2zOYuX2Kew=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=njEbJBonSvOj57oLvRw2ZzXUSU3oDJ/gsWbBPN3PvESr79m5p81/lPPMQDiVcVH8wHpJpOQ2BdO1rdOlMZD9ywedjgKIU5kdoRtwA1djp4INmiX60G0I4/6qE+541OQboujuTaZviJH4sNgSEPVMwGNJ6eXQznggRVcrmJwORGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lC0i9x8O; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lC0i9x8O"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2e31977c653so548345a91.0
        for <patches@lists.linux.dev>; Sun, 27 Oct 2024 10:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730051965; x=1730656765; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0UbSjGcSDB+S7wUx4CXOcRobJQ1oRD4vD2zOYuX2Kew=;
        b=lC0i9x8OIj2oFg0x1ewjU6GUefgRzQmXozRtZfB6Aft96J0Vfs2n/EEPpkHV9eeQaR
         ubW17aXa41oA5/V/jW0OcXHLmxfx7Ydp+4ASIDF7g9kLv70Q/pGQjoN7jAg1k9Bs+rGi
         uY16oe8q2ioAlpd6mnQJu4JSlzELaNiu85RrjW0Q++lId4889PWf/3KNQrfWVC0weoyH
         Qu7T6vuXYBuLZFHKULMgcNjiysacaYGqTXI95Ir62MdB6Ydlit7f8gGOBKRsmiCe2hj/
         L2XhPmW76C3IPUE6yJgbw6PBtVUW/vTXJdUmngEpgJpn9BIxx/gbthZCs26qoUtkzQJS
         KVFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730051965; x=1730656765;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0UbSjGcSDB+S7wUx4CXOcRobJQ1oRD4vD2zOYuX2Kew=;
        b=AOIlxD4qbBRTMHtuKyl4361wA2px9li1O/NRABktlWUwT1OiuC3J9Vd2EODg4l9XX9
         VsLW8jt5NY9CmdPeMQ7yfcWO0Aaowai8URfbtHxrjk2q1qntEk7G80XzAtbLwJZAMyU/
         MnAmq/oLwgXd8jQlSM3LI9pWkdv6CuNnmKIraDRdDAMmqRotFjZaMgXPs8j41F+XHwxW
         +bTmiLokNRJc5KYM5AL+Jovd8FzFHJraNftoqagSsWNbhFAhKfLH9Mi/VwhiH0OWrKMC
         kzq3zBoBePV8I6X7cL7ihN0kCTudFop6UNueh1ZngQRtTX/ksivVCBLhAXvb1ixJxT9m
         n6pw==
X-Forwarded-Encrypted: i=1; AJvYcCWtt4g0eDSHRS12xGvfaw58/IdJ2k2oNsnCTXlsRG7SaE7JIRgdJ1QIKr16t/nxJVY/B2HvHpgE@lists.linux.dev
X-Gm-Message-State: AOJu0YxGuQ84W3pz3xN1OrP2u8v/Eclno+BQ387TSMFsR8Bt7LVq3TCO
	/Ve8mq6861NHlSZUhRmxgqaIG1b6K4jVS58DHVciZs1ys01hH6LPP7RZs68a2kKFQooS81Gfi76
	djG18eP9a9GTUdz2SHono7CS2VYg=
X-Google-Smtp-Source: AGHT+IEeZnnHbXtBp8iqrs4W8ijIFAmvZkYu6WsDP0Rj0vVPVd5O/4PVkQIVuOKO+4nppet5edWf+GUBkU6bai5spq4=
X-Received: by 2002:a17:90b:3cce:b0:2e2:c414:80a4 with SMTP id
 98e67ed59e1d1-2e8f12e1014mr3006581a91.9.1730051964867; Sun, 27 Oct 2024
 10:59:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241027145636.416030-1-ojeda@kernel.org>
In-Reply-To: <20241027145636.416030-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 27 Oct 2024 18:59:12 +0100
Message-ID: <CANiq72n3mFKeErzp-OVk=+yZD_sZurR-6u7mEn_QunfMTKD-Fw@mail.gmail.com>
Subject: Re: [PATCH] kbuild: rust: avoid errors with old `rustc`s without LLVM
 patch version
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Thorsten Leemhuis <regressions@leemhuis.info>, 
	Cameron MacPherson <cameron.macpherson@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 27, 2024 at 3:56=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Thus, instead, just make the match stricter.

Applied to `rust-fixes` early to start getting it in tomorrow's -next -- th=
anks!

Cheers,
Miguel
