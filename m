Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B263002A9
	for <patches@lists.linux.dev>; Wed, 12 Nov 2025 11:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762946034; cv=none; b=XJQJVEX8IfwpyPMFCw1VhdP3k19h7H7HZ2Lkv0qNQFJllXeX+wkq+OaDKefka05H1HL7MrJysj5gi3/bI2HOBEhUnx6mzXJx3JTUGDWSZEL+F42/E3yzv6VdSNHzX5BO47ST91zMFt36FwKfGrIctHCA4NC5RrmdU7TClXodw8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762946034; c=relaxed/simple;
	bh=HKRQgb7qkXFEXY0rIg9AQCQabb0xmTPYzrOWr+EJXY8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iCNRiFqSo11URfI8Qf6OF12iA7hyPP+Iw/73YRe6uMidMQ2P3e8l/fDcX2B7opMidyFswubZYbc+6esB4ektvDQVAmXaOEuLj/ILPsg79gb35tyZ7mhyp1s9fVEzpZ0rZ2I8En8gZwR/OEZ6jCerZ+f6lN0DWxixm3T2OapVstg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yixligy6; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yixligy6"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-297ea936b39so1046155ad.1
        for <patches@lists.linux.dev>; Wed, 12 Nov 2025 03:13:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762946033; x=1763550833; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HKRQgb7qkXFEXY0rIg9AQCQabb0xmTPYzrOWr+EJXY8=;
        b=Yixligy6VwwTWG8FDHYjWwz9hT8x+nlR7lkfehVGDcl3f3l87oL9goBNbKMecTkO38
         tZsAauRZRDBF9igAS80q6XR4+SxCYfzk0Cbhl5Z1s4ck6uER0/ou7UWEFnrLSRzuNcCC
         wAIoqtTOfDADnLErRyqvJwmukP8bB3C1VYjhmx7WRi0+ITnfzWEkZoXRiZhU+mfhkeVq
         hez1phs9UvJBxlnCV9Wkwk7n9zOSs0YO0Cp9hFdmR0qGjLxmHtsu+UIaC22ZRLPl3JXw
         47+k9l/rEPgq/NXzDm5v3OcSujd2CAilQh9f52ngbV150dmcOzqHoywNuPjzOHy+Gjsb
         J7ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762946033; x=1763550833;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HKRQgb7qkXFEXY0rIg9AQCQabb0xmTPYzrOWr+EJXY8=;
        b=fk2wmVUoN1sm/cuqlIM+wccDbVOiUQdUsvzpSzRmqBGM6heeCp9Y4lCRz5KoJYC5hW
         bHxYa4pbYEYmNxrfqD0J16wEW801yZA6kjp80yjznm5FzRqk6RkKvtorYx6Vrd0mml4T
         I69FNGH94YT+JK9923bRWSS0+o22Z7P8RPrXYJu/XmCCa//miUZfnxoXeQWe6ORfSvCF
         Wcf46ptCpCYB7RJ8cYaapSqeG2bFIK1c5WrJmZsxvR8uu9xQ4o6UTqyE64E54nxjh8xZ
         fSIoYRV5ExDG22FEh1bvI4A/sf1WNtSMY+z2xOIkM4kt1CtwgYTSe2Mkwi7B0qsy2boo
         0h+w==
X-Forwarded-Encrypted: i=1; AJvYcCVDts2JsYCuE+oM6ppufwKmxnlLXg1lJvcfUBS2yCt0dMoi3iuM5G1Jo2ydgKa5DMdGM554JeSw@lists.linux.dev
X-Gm-Message-State: AOJu0Yx6kbCfNR/LY0sJhu60RvE6WMB5U28VdN5Jt9vqmcecPXzbxN4v
	ALTNoIeSFjBe4KhwnwjFbdscph/vyriL8nffMyZtd34EIs0E4OTtN5gHYNDM1pzltRnPye74EP0
	L0DGdeqJIdRg7hATpCJq/oVInEpgFiI4=
X-Gm-Gg: ASbGncvmUW5jFEsqIcNaKQafOy0ala6gYJEpMkTuR6RWvUfPYNF/GGcgRTtgIYpuG9y
	Kfj10ui6uYD5nprpv043LiLeZl9Syu3/G52oYRhbFmfB4aqiEbCclUqEp71KUrgweIENpxWxALP
	xZdv0eO4qqlhYIB/5U2BqRsq4BWMxgVKG31aiWPqBoV8oWcZV5yN3kdvw1J6+wNnsCU5tpWxSVS
	ZSP032uYz/LSA+UsqachXaI+P6Im+sUzav4dziWlk5wSCIt2iKN+7zOkcbVgg3yMmPJ0t1I4Uwm
	8iZcAma5YraElVATCiZ/z/z/Ip9b0n1WJrfyP+++IFD2Jr/oBOmDZRD+QLtvtfLMueshtGc+4ky
	aJiidOwxylVhtPA==
X-Google-Smtp-Source: AGHT+IEMVOPLQ0kfBxj6LLguRfI9eu1jQSQHIP8wiKHhwLHRC1rvaWObMB1+XwvZaSaxDEkp8LUmHo0FgkmnVhYp2tM=
X-Received: by 2002:a17:902:e84c:b0:297:d764:9878 with SMTP id
 d9443c01a7336-2984ed48799mr19398545ad.3.1762946032845; Wed, 12 Nov 2025
 03:13:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251110095025.1475896-1-ojeda@kernel.org> <20251110095025.1475896-3-ojeda@kernel.org>
 <8e58087b-17e6-4362-93f9-f9aaac6c4476@nvidia.com>
In-Reply-To: <8e58087b-17e6-4362-93f9-f9aaac6c4476@nvidia.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 12 Nov 2025 12:13:40 +0100
X-Gm-Features: AWmQ_blP421Ww4skNX1IA86Afm7j4Lia0EL-t0RKvHyVdfTUWYuVKwSCLUjZdhU
Message-ID: <CANiq72nssjH0dZ5Yso8fp3sjHOMK2YYyfZG+uG_Fb_09xd5=vw@mail.gmail.com>
Subject: Re: [PATCH 02/18] rust: kbuild: introduce `core-flags` and `core-skip_flags`
To: John Hubbard <jhubbard@nvidia.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2025 at 8:18=E2=80=AFPM John Hubbard <jhubbard@nvidia.com> =
wrote:
>
> I agree that switching to ":=3D" for this kind of Makefile variable
> is a good move. However, it should be mentioned in the commit log
> so that it doesn't look like it was accidentally introduced.

It was meant to make it consistent with the upcoming additions since
this commit is essentially about that, i.e. it was not intended as a
drive-by cleanup (which I usually oppose), if that makes sense.

I will clarify in the log.

Thanks for taking a look!

Cheers,
Miguel
