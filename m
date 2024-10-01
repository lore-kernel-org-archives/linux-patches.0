Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA871C9EAA
	for <patches@lists.linux.dev>; Tue,  1 Oct 2024 17:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727802408; cv=none; b=YI9KSXxe768kUSV111SM+a0JzxS4i34nEwxBYxrbymvfOq2RPh0uGNt1YWzCvvngUv+Uw3Ss+51U1AWFxh/dZlwfcRbVUlSXU0ORurnt15nSTlVEJshgyes3xzbw/bBXGVDsjuqbZLtKJ5CLg/BqI7i0Hp3/tBuSd1kknXFMoEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727802408; c=relaxed/simple;
	bh=zqeyiKv76fN5fAHsmzCvDIBitSehZK6Hf9ZCqFVtUbY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=llGu7qWH9JDvH72UIxBGEROeFnYY3jMdY1BPJ+OAKpb1I1mLPkyzFUvRftvkSjelTLCHfdiGd6BOy9jpUNTSHNv5NJWgUSE0WLxWPmf1bbv2E7NohWdM3dU0VND85ppJjUKBbOBOPmgr+YxIxG2qJmd5ViT6MgOUF+W0mbVOI2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ko3NnCTj; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ko3NnCTj"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-718ebb01fd2so842675b3a.2
        for <patches@lists.linux.dev>; Tue, 01 Oct 2024 10:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727802406; x=1728407206; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zqeyiKv76fN5fAHsmzCvDIBitSehZK6Hf9ZCqFVtUbY=;
        b=Ko3NnCTjeq2+aUpVKCIyEFPx3brT6dRee124S/uxNfANuwqIXM1xHWdIpHWAJcHAPG
         TyR+rZ5waciIOrOM3JoBo3+W+dejFrjZat9FdZpcFvcMUXy4yQxq5hP9g69HBWKHO8Ys
         cGzlq/KIYZeFUUtqbmRatMZHKFhGxYI8sVIN7dTNCOEWWuuQZM560KsqVN/5ZG2Jc21g
         95Z0B9hXSrnsoWD2rleN11+l6UBrBX4aTUgwfE7PBUuf+ww3AVO0RGyAs7oKpBW++oTj
         sDfIfu6s/FiLrnqAh3PUHjM0upZi/WIDhMUb6OXzOq9fASbdrxi3nr+Y3al8/A/lH9HI
         oB6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727802406; x=1728407206;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zqeyiKv76fN5fAHsmzCvDIBitSehZK6Hf9ZCqFVtUbY=;
        b=sQri+4I1CWdUBsfdbWrQx7hDB8O4TKLFCcwo9yUB7bgzhdA3YMCNqjCmVy3/8dmZkF
         spIL99bVG81eCkMJ5oY2zUQQoDxmJPnLVpwdT5MkZwBoF+LB2OcFss8/o6Yfv1eBIOpA
         af337UMt2joJYkCYLLnax8dRnuw0/3QyrCUX7wEkO+VKruuLyt/9M8nah8SYvJK3dCas
         PRYB4F/nA5nQfRSzXJTPX1n2b4Si9/tBysddICsJySkog92q3wTxLC/+sdq7ng1HQc74
         M4RZ4vHlfx8xKwJhNJrlcAy45O/jcdLH99l0X9S2dzIqZ9hEz0iGvigaWQyO6M/7RORB
         hLSQ==
X-Forwarded-Encrypted: i=1; AJvYcCUsoWs+dgwp4n8PAH3TqMz3P79HWaZukNDDhpwWCervU+YiS+jkaoNWLjtkI3p2VH925xvUR6RQ@lists.linux.dev
X-Gm-Message-State: AOJu0YxAA822TG2V347vmJALtCB/VJe6+8o8EujCTm8P+9Qq4US6HCdt
	oWrzcIMmLrlxZ9URK1Y87OHAHd8Fl6flAxFFvnh6cEQsUVdNNOJhrZtxS3N1/zWAyIy9JenD0aJ
	NOV2Tv7658jajiiWGStUVTG2vD0E=
X-Google-Smtp-Source: AGHT+IGIQVO+FQ85WAIm/sMvZM2EtsMOkx2GGMHghXqo7HRV8k3Gp4cFH3MOrJUwZYsm/vyxfCqxmYqmzuVhTF6sEvs=
X-Received: by 2002:a05:6a00:2d18:b0:718:e49f:246f with SMTP id
 d2e1a72fcca58-71dc5d6f9aamr237915b3a.7.1727802405996; Tue, 01 Oct 2024
 10:06:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-9-ojeda@kernel.org>
 <CALNs47uC43vixDMt935BB-fuDJEKFE-SPFmSQp4Nt3v+O9wfbQ@mail.gmail.com>
In-Reply-To: <CALNs47uC43vixDMt935BB-fuDJEKFE-SPFmSQp4Nt3v+O9wfbQ@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 1 Oct 2024 19:06:33 +0200
Message-ID: <CANiq72kiQnRS9YAehD8-0-ZVtZzdrGb+NJehhnAXQaJ2nU7skA@mail.gmail.com>
Subject: Re: [PATCH 08/19] rust: enable `rustdoc::unescaped_backticks` lint
To: Trevor Gross <tmgross@umich.edu>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 29, 2024 at 6:40=E2=80=AFAM Trevor Gross <tmgross@umich.edu> wr=
ote:
>
> Maybe we should use something like FIXME(msrv) so things like this are
> easy to find?

It would be nice to standardize on something. As long as the version
number is there, I think it is OK even without a standard notation,
since it will be easy to find while grepping for cleanups on the
version upgrade.

Relatedly, Benno even proposed failing the build [1].

[1] https://lore.kernel.org/rust-for-linux/CANiq72=3D-bV_=3DTUoH6gLnPwTcxRO=
BqyrCpOpbumki_S+po1TPhQ@mail.gmail.com/

Cheers,
Miguel
