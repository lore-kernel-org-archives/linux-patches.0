Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59D819F120
	for <patches@lists.linux.dev>; Wed, 25 Sep 2024 14:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727274486; cv=none; b=b20qRlpoj0q03MDXAiDUerUZq42dyr0GtN09sPFRTXd8DYCuGR1WQt/DXnnA5eofYeo6UJiRltSgnFwr7IYjFolg/jAWbbEjft1vE5evJ2uOP5RRBY9i0wbu2kr6DImN6/jWNuDYp2tltQMLOcANbKxmDgCi/gv+WPGuh24CX6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727274486; c=relaxed/simple;
	bh=obC/7/KH2c7jTGLio49zTh/+gYmG1p+8KVkj8WjaOGo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BFxatal2y41ZwlPXBS7XLHoZH/ze+6bD4bLc65JYm75z+cf2Jjs8sheWdUSv1mRAMwm6pfyq4UOyc3T5RkRKZZJOBy1BKKkc95PJvqzRvkwYtsRDDa+eIZINqeu13bhWVgoOftzRUB3/oCrAPIUe21EV6b9rPd/rNx8lcGSh/Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1uNmS/EP; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1uNmS/EP"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-374ba74e9b6so5620138f8f.0
        for <patches@lists.linux.dev>; Wed, 25 Sep 2024 07:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727274483; x=1727879283; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=obC/7/KH2c7jTGLio49zTh/+gYmG1p+8KVkj8WjaOGo=;
        b=1uNmS/EPb/Z/oHK0J40pWlMJDgncAoV+UB/7ZWLiiulMyCbKg0rQZgC2Mi07mPzIUQ
         AbkCdUFjJ2omfjYg5thF640609/SYf75D8gjwYgzznjNPx9PyVpUuZVf6qM4L3JV+buQ
         YCR6HHO+5YoSVUYsBdg+f3iVPaSbF/XvcDdwx3btceqDfOK3sXHsreTIimsCp9Ki5tQ5
         01KTsz2algZqiX8S5Ky58SGsIY2MFrpQ0gtQjncPPuJuZYxPc/1TFeGruxzd23etsLwP
         i1HRAFTUa2pqmvIWtWdbu6H8ur3gpeeTz9adFrHx+MDikqL9AB/gLbYf5LApy6pfGBXV
         NtaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727274483; x=1727879283;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=obC/7/KH2c7jTGLio49zTh/+gYmG1p+8KVkj8WjaOGo=;
        b=PY6d0qvk6KWdq/bkxUstH7kHCOX75Y65I2xZTs0ZezHzhJhaLyOtL8783jotMybXeE
         GUcMBaAHQ+1wDcy4euGaNrHZxlTVK9fAQb10v87twKI5Qa2EbipSszNTLZ2WbJf+HQDI
         bEyZkz3CpdCly/x1EBqP7rupgftEzbFGlPqeEr0JRwOGUT8+FtMffpPIkqI6mNADpExJ
         Wt/AXfiClhk97jY+iEtoTvJuMpPPNdYmpzORasjEo8JLe9N6NlvZlZr8if/XZGAyGFP6
         ITwNHR0eQW+e3CRepWsPhVLiXHqV8A55ueYKza8RnVeUfsoBIztYy3nG/tEk4K34awkw
         ZIYA==
X-Forwarded-Encrypted: i=1; AJvYcCWZoMyo+ai8gu7qrLZV5hP5111GbIgHF+Bknq+lzkItfyK1otfCDSaI6txr4BaxmELPx242xmxs@lists.linux.dev
X-Gm-Message-State: AOJu0YzEt7g6xgMWVUg0VBAuMlmzS6ewdtpNfCOZ/glzujVlpiqncT/g
	HMZbHR0h8zzAVo9T7C0E3vT4+JPlUr7QA6FAzCy8XSkNtwae8bAEMxjMee2JaOAK9FNxgNkyqq8
	jwnIVctOm+XCykLV9JZYVW+f+4C8ZQakUe7u0
X-Google-Smtp-Source: AGHT+IFd9vRwftTt8XvUpteeBh1GBHyoPi/G9HBBRN0TTqfaKPh4NZIR8691AkkQ6GlnqZn4WH3b/ayxYAoChf7kkaU=
X-Received: by 2002:a5d:58fa:0:b0:374:b30b:9ae7 with SMTP id
 ffacd0b85a97d-37cc24c511bmr2574271f8f.49.1727274482535; Wed, 25 Sep 2024
 07:28:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240925141944.277936-1-ojeda@kernel.org>
In-Reply-To: <20240925141944.277936-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Wed, 25 Sep 2024 16:27:50 +0200
Message-ID: <CAH5fLggG1n5RMHcE3ZWjz4m7ybG86gwSAsnh2NU5pvTL+zqQgQ@mail.gmail.com>
Subject: Re: [PATCH] rust: cfi: fix `patchable-function-entry` starting version
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 25, 2024 at 4:20=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> The `-Zpatchable-function-entry` flag is available since Rust
> 1.81.0, not Rust 1.80.0, i.e. commit ac7595fdb1ee ("Support for -Z
> patchable-function-entry") in upstream Rust.
>
> Fixes: ca627e636551 ("rust: cfi: add support for CFI_CLANG with Rust")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
