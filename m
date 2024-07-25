Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AC419B3CC
	for <patches@lists.linux.dev>; Thu, 25 Jul 2024 17:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721929612; cv=none; b=ZPm2ORrQhH+Efcsm8RBSsfVAzBHkVutPSQ09QpKj0uCs2E1lE6EpdaxuQ1Eau3/dAc6KdjM5Y/0BGSKjSDshp4M2L/FtEycLBCBVzeVVOKRR7PlL5Udh2qBX/JNu+SNPn1ifzsYpu2HywA6BSCidwBtMvzqqQYDt6qYFtuHLKQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721929612; c=relaxed/simple;
	bh=JVyel6TyoIgSIzZnF0S8FKLtkmddgEdvOUC+QVqFR4E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o0u+kjcRMN4TiceEdBs2LAXj+RKAWIy5qUof1QNqN9Whe0pNJW9z771GQfnE5MVLMolkjASj7VxHMm4/Q6iU9l0u51JP5H5U2bXrFtpgftTFpcEzOf3C3vx361n2vaaa/bEk7DI16lkxxuCSHP2Lr2VNN6f8UtgRdsvJa0UsirM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kdBHLvM4; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kdBHLvM4"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2cd1661174cso113177a91.0
        for <patches@lists.linux.dev>; Thu, 25 Jul 2024 10:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721929610; x=1722534410; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JVyel6TyoIgSIzZnF0S8FKLtkmddgEdvOUC+QVqFR4E=;
        b=kdBHLvM4YYKOCbbk+FcWgHgNx079Cu6PpEpM7RpN3RjWkudjv4iPpdJ6PPGQ7z/uY9
         wmYh+/WRKF0f8Kr6vuVQ4uu3Tn1qDk/wjy9aNYGeSeUv1LZg5IjvS6L6Pg1Kdf7da0U1
         jXO2XOGOYCgQfwggCS8D/mper+ciC3HQY0eLdnaZSjYMssNTes6EIr4x161VnIwOKOjp
         wYQnB2PktsgbR4l0ya2++qM/uprL7IeyGbqaQO0lf7hczbnA7lKmueVK6wKxGwDZ9/dc
         edrYjurg8TAz+aXhRYRysa7Pk3cVhjFMeQo0gL467cwF91ZWkTAhekwIvFI+AKfoR/Ht
         x5Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721929610; x=1722534410;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JVyel6TyoIgSIzZnF0S8FKLtkmddgEdvOUC+QVqFR4E=;
        b=nvEvTBeLaVwRkfTlrvJ3F2os2+jwgbrGYkZIpFe+ui1iiMC1hjDcVmAKj8xbkq0khV
         6moNz2CPSQwU39wg+jokofLKqqIeAXXPrL8rWoJs6NXwaGhdw5QVpsWo75XM2rV1Rddy
         AfdGDrmyOwF36plDLEZIp0MvVl9gm72GBSSZWrvCYwO+WnPxd7/6mu9pV6X/UfdhaKAs
         TF+rC3z7IPkrLmIh179EaUjRNWUu3Wafd2lQDkhIxsqDNT119QnlIhKAQuEVbPaVjkMI
         rZwCf6L/JjaGH9vUAtjyC9WLe1MZQPxv6tXv25PkUi8q8L/A20EXbjsNBmvYwkE7hsjs
         ci+A==
X-Forwarded-Encrypted: i=1; AJvYcCUQ3Fw4JdlVW58pkH/8zVmPkxJ4YRGHTSASBFNxP2UVdnDvmMgBmM8NxC49EFVP5wyRqpy9ECg/jULby0HSFjwynaEzfyMKUw==
X-Gm-Message-State: AOJu0Yx1rQvY/R6QcQ3uoAkeyPiFGsUiSaUdLZ9hYnHcEN/xqH3Mpjzi
	3NoHUxSWcqgJfhbA1k9+BARmxrX7yq9T/4luN8kYceQO0ZQtw8aCfr5s+cEjn+mpJh/Wr2OnHKU
	0bFn5AIo1dz1BL79ZsfyzAMDsFhc=
X-Google-Smtp-Source: AGHT+IF/zsC4mt8anDKAXtlX5iOlGNHy+uUW7r23kwswz+uALnsBpL3D30exas+OKtu+RrmYR1kD4OJidTO6Lz8BwO8=
X-Received: by 2002:a17:90a:c58f:b0:2c9:77d8:bb60 with SMTP id
 98e67ed59e1d1-2cf23df82famr4118133a91.35.1721929610169; Thu, 25 Jul 2024
 10:46:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240724204649.7de3ffed.gary@garyguo.net> <20240725174449.102724-1-ojeda@kernel.org>
In-Reply-To: <20240725174449.102724-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 25 Jul 2024 19:46:38 +0200
Message-ID: <CANiq72=9CWHgzTdUMePNVGpNpHuk8TN8i+bhq7cyBe1_iWLBPA@mail.gmail.com>
Subject: Re: Re: [PATCH v2 1/6] rust: module: add static pointer to `{init,cleanup}_module()`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: gary@garyguo.net, a.hindborg@samsung.com, alex.gaynor@gmail.com, 
	aliceryhl@google.com, benno.lossin@proton.me, bjorn3_gh@protonmail.com, 
	boqun.feng@gmail.com, bp@alien8.de, dave.hansen@linux.intel.com, 
	hpa@zytor.com, jpoimboe@kernel.org, linux-kernel@vger.kernel.org, 
	masahiroy@kernel.org, mingo@redhat.com, nathan@kernel.org, nicolas@fjasle.eu, 
	patches@lists.linux.dev, peterz@infradead.org, rust-for-linux@vger.kernel.org, 
	tglx@linutronix.de, wedsonaf@gmail.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 25, 2024 at 7:45=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Boot-tested under QEMU for Rust:

Sorry, please ignore this message. I run a script of mine badly... :)

Cheers,
Miguel
