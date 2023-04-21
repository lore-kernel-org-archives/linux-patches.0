Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF502F24
	for <patches@lists.linux.dev>; Fri, 21 Apr 2023 22:46:46 +0000 (UTC)
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-b98415ba97aso2501146276.0
        for <patches@lists.linux.dev>; Fri, 21 Apr 2023 15:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682117205; x=1684709205;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vUUOIxrjpun/24RZv7I8ONxLUOsWypQs9rpKT/sGscM=;
        b=Q8aUqJuWAgeaQceyp3w7NMH6kiF/bAlhEBz0LOUheInmP3kOueg8pAgUKhqV394irT
         PqAWxm6mnhI78XaqtXQZWDSUtP5gPyR5UFsgf97x2Z5IcnzdekCfnB5ixtnkROc2ubFw
         qY14EDO/S/W4ozktddGWRVbQUyLHyZ6LKygUHC20VxSaQ5o5PtECnmYPz4H5URTYwinE
         RzemI+UIR4tm+0OeMaW037iVsB2XPVWy/9KJ1JjKsn9SB5hvRNW2/C1OEXqwnDzgwdzC
         NuyU71JQSvBSP+NbOfanjl/vEvgW54aaHUOsUTFYOmImBov0zqm0NvV8RjV2Fvv7VRtd
         nPkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682117205; x=1684709205;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vUUOIxrjpun/24RZv7I8ONxLUOsWypQs9rpKT/sGscM=;
        b=a5VBSbF2yZY0DaQsYpXN2ZSXxFbT9pfxGK5evpH5lW54PmCgXWuLT4sNFxYm3VGNdj
         jeIGzD+n7h6Zc+932I9z3ascAbLZ+7P81to7ep3hTYXATzoIO9i1pVh7Z6rSkUrq3LKX
         TeQJUUB4Gi5NVRIRGx12ITVsTOR/H99WcufHrLU7WczX6F2JZ40hcKd8c2grLVR1LENQ
         vo4Rd1HH5sKIHBEJvPXhAAsBwdwybitBxl+idAs0ZjYw+Twn2ZoD43HjLay3nMDyR88g
         uzbTHwTZjbMFZfSyOBDNDrBLiDuKCzUOUVA/7H918La9y/6p1d2TcQ66kjB3fKwDo24L
         Yb0A==
X-Gm-Message-State: AAQBX9eyD8hFxek+HDJ/IAk/dGxiu2r+GG5ZZRweFU28C4HoO5GH9H3u
	dCpEXBuB+pvHazdIkw/bxBRvdImQ5ZfSkhSmHhY=
X-Google-Smtp-Source: AKy350aAwaz5VZPCRreYkS3JrJcWaOP0Y6dLHzltykRV9YdT1BXuRHlfrSKtjt5f2GbfmQR3Zmrmj0j3/wZE4zDHG5A=
X-Received: by 2002:a25:2085:0:b0:b96:f486:9efa with SMTP id
 g127-20020a252085000000b00b96f4869efamr3478748ybg.40.1682117205383; Fri, 21
 Apr 2023 15:46:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230413100157.740697-1-benno.lossin@proton.me>
In-Reply-To: <20230413100157.740697-1-benno.lossin@proton.me>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 22 Apr 2023 00:46:34 +0200
Message-ID: <CANiq72nbRDp5Ei0dzkKZJw16CzO6iXwXaBZUigz7qKdjBn9ypQ@mail.gmail.com>
Subject: Re: [PATCH] rust: init: broaden the blanket impl of `Init`
To: Benno Lossin <benno.lossin@proton.me>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 13, 2023 at 12:02=E2=80=AFPM Benno Lossin <benno.lossin@proton.=
me> wrote:
>
> This makes it possible to use `T` as a `impl Init<T, E>` for every error
> type `E` instead of just `Infallible`.

Applied to `rust-next`. Thanks!

Cheers,
Miguel
