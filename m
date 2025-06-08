Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0106C19CD07
	for <patches@lists.linux.dev>; Sun,  8 Jun 2025 16:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749401872; cv=none; b=dV7c91al0tWH1tEG/TUo+TmUiqd5ZZdh1icWChx84R1Iqab846vl5JTndcxCwvz3qXI/xmxbDR0einKKrTTA7tGs84nzoPYhHBdcckLhyBjTV3vYNOcyb0PtyxN96MGF7nuFfyRqgQasGVUl4Z8THEHUpGTZS9zOovssaB2fW0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749401872; c=relaxed/simple;
	bh=V97iY1Sq/zaYk+CjyZO3kcrQTN6xQUok5+0Jb8EJswI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rYO0t07hLOOhMm1uZgYlCj7KKbkINVMLnsUZBTHii723k1OkPp5Mx/MZef8GbTD6uvO0Hn9PLGxU6gmJSu6Hy4/Eoty4ENtDfk/mlkRfr5pJA/HgqCX2eX98+dfGM112mHPcNMfQ2biQuZKYA4HDoFmaRXyrKGIo4zVylYjdWdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P9bEDRo3; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P9bEDRo3"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-234eaea2e4eso6656315ad.0
        for <patches@lists.linux.dev>; Sun, 08 Jun 2025 09:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749401870; x=1750006670; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V97iY1Sq/zaYk+CjyZO3kcrQTN6xQUok5+0Jb8EJswI=;
        b=P9bEDRo3uUYqEK4W18RVdmXqGkwuz9SMD9rnItJrk8SuqTMIBI79Sa+NcQwkrO924F
         4PW9sPNNykePx67n4f2OP0f3BsWWw5btMwnBRmfjsy92ocFqgoMtFFSEIAlBy5cEi6TO
         YKBsA58DhReefge4X6VnsFJ5skjGDm2CQzaQKRfvw+IFmpCVw6vAf5IMraC6qGyM9HnG
         EGtX73FdA1wPmoo0NHflyCeExF1Lr7WtXwh6LXQAIlO7Sq5yLpSCd3zvSklQzWgGqxGE
         kLtMbuLa+qD56qmnP3XhMRxswy8hRxMZUUaaiXiJbpY/6jKRoyCCSgkWlzuOs6sPKJoQ
         eXZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749401870; x=1750006670;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V97iY1Sq/zaYk+CjyZO3kcrQTN6xQUok5+0Jb8EJswI=;
        b=vCRmimntJAvd35vpBWY5hcUpF0aGSjqug3B55AFHHInE9cNDqWV940LW46q8ygDXYS
         hba81uoEyfGY2QejYQQziNKgjNH8IzLnLzQw+hGpRxk0VuOgPoSPtpNKebCtHrfh+CIe
         PNGKBeOmdBUrpw+bTswtXCFajFwSDd78zdJ889288f0a7fNmEbMkBS7C9LSIuDkBud78
         6LNqV1p0/KJTes2JjNeElgsPyJToATFN9wx8AyaXBlw3fhIL79Q2PKqYHmgIo1rxuMOq
         Su3Z84esFAsUCTqk0x2FXb7OjJMXZtQrXz1gTRAz4usm/NrDlY1c0NbKYcmWI3294g+B
         6w9g==
X-Gm-Message-State: AOJu0Ywbi+/Vq1e9Eih6YLhPaIqNOqpShaUYhf2RGXNPAeoCYY1odMV3
	gABOkqp05e6QuZ11bw3l3pym7r5qAladHVHfuSvdyPuu6zOFlfqSKLWen4odTGUZvBHA3wliPUd
	wNQ5rfbgfK4w7f18Md5HKA55OrgwXpgk=
X-Gm-Gg: ASbGnct/Hs4dx9DIKjuW40v/seM8HhJbTMqQDMH+v/M/jkX0eksS9k3S+gXIKWIiwP6
	CAYlyw6i+J3rRW5wXzN5uNlEOYXgU1QFP7Qg8cpFEF2oV+e+kBEA2H15USjspWGJ1MpyR69pJEX
	y/qOAc/3+mieZE/+v9/B0E2p/ulVu6vlpw
X-Google-Smtp-Source: AGHT+IEF2US5fJhPDCUr0zqu3y97vNhUhrFfv40wDL8whslXrtkv2lLuWp2e6TAgkQkr6IJlrkWA6WJB918dTFlaWe4=
X-Received: by 2002:a17:90b:3d04:b0:312:ec:411a with SMTP id
 98e67ed59e1d1-3134e3fa0e4mr5065645a91.3.1749401870302; Sun, 08 Jun 2025
 09:57:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250608125507.934032-1-sashal@kernel.org> <20250608125507.934032-3-sashal@kernel.org>
In-Reply-To: <20250608125507.934032-3-sashal@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 8 Jun 2025 18:57:38 +0200
X-Gm-Features: AX0GCFv9TBDVmHG78YzkdTI0QzxeKMKORLyul7ZTok5DuZiL-KNBn7ier0GIHk8
Message-ID: <CANiq72kkWkgzHAmBbfqj5cVBg7M-ubt5BW1UAXu1ns-XbUdinQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 6.12 03/10] rust: module: place cleanup_module()
 in .exit.text section
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Miguel Ojeda <ojeda@kernel.org>, alex.gaynor@gmail.com, lossin@kernel.org, 
	aliceryhl@google.com, gary@garyguo.net, dakr@kernel.org, boqun.feng@gmail.com, 
	tamird@gmail.com, igor.korotin.linux@gmail.com, walmeida@microsoft.com, 
	anisse@astier.eu, rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 8, 2025 at 2:55=E2=80=AFPM Sasha Levin <sashal@kernel.org> wrot=
e:
>
> **YES**

Same as: https://lore.kernel.org/rust-for-linux/CANiq72kEoavu3UOxBxjYx3XwnO=
StPkUmVaeKRrLSRgghar3L5w@mail.gmail.com/

Cheers,
Miguel
