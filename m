Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3E31E507
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 23:20:01 +0000 (UTC)
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-6bcae8c4072so301563a34.1
        for <patches@lists.linux.dev>; Wed, 09 Aug 2023 16:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691623201; x=1692228001;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/lRhXpkftV5WprBOjenlPu4RlVRZWyTjLExmBLK+zSg=;
        b=mVTrbEAuawdJx3ElwaKv58oDRhAx1j/Zgd20JP5iECUNCndAK5bBHxQ/M7Gzcy/AIC
         bEp9t4cWhfYj9qPehf0Q4kbHHfAjGPzFHt24SP2Goq4jQqCresNBZV1fDQh02mzPNuRA
         Z4hYxarDm4ZraeNrXzUZK2Br9B7SDN7pA/gbIzxhfaYHrAZMawdtZNdye1UoE/MH5nG0
         tbqT4ccCdMG9Z8Fb4OTYOonV2jtfeFvYPjyboY+sdn3mdF59FuqLG0af8O/bLx2pclzt
         kEXFGSCtHQRPdvRwcCHRgjW7hm447xc99gn2drGw/Gb21XM1TWHqGjatO2T5/bmiYhSP
         5+SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691623201; x=1692228001;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/lRhXpkftV5WprBOjenlPu4RlVRZWyTjLExmBLK+zSg=;
        b=khlr3LGnZ4ZWFc5YEEBZNPtdTBGqv1f8LSsTNwthuBFGdmpGpYeNw8tzfLcPBRqZQb
         BAQwIxNB2Z5lEV1X99zgKk1jvfcJcpbXeJVpiBgdzq4TbsxudjndMU+9/qowPAjGUrg1
         DDTVB53zkBjndEp9L44uyeoMfSGl8jj407S8OSF+lvzPuA7WpL9MG50Uetxk7GmKNbZG
         dNZLFW3KB4Aj3H5qZ3RjL9KnrZZjFOJVGt29v1nrZWe/FrWAvH21uUOZH5+ong86ItyX
         xTB3giPve/Wj0RRku/bejk224EBLziAwkKL3hVDIYpMAYeLQXAJpxqQpq0lCryNl3piv
         gNdg==
X-Gm-Message-State: AOJu0Yz+JDu7QymZeePkvHhloKM5eje3BMsBuV6mJqfQyPokQIKKSmmH
	L+TS9XqbfCfYdmf0FuOugrAvyEqdqZWWg+e7/Go=
X-Google-Smtp-Source: AGHT+IFVwAsHAc1I/f4r+kqoInQuxwLB7X/eKeE4VB/eVwqAdhRIKHNUJUJZUxVvn1vl2e7UmaDNzTGKAMl7IyEv1YI=
X-Received: by 2002:a05:6358:89f:b0:134:c771:bffa with SMTP id
 m31-20020a056358089f00b00134c771bffamr651523rwj.6.1691623200560; Wed, 09 Aug
 2023 16:20:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230718054426.1048583-1-ojeda@kernel.org>
In-Reply-To: <20230718054426.1048583-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 10 Aug 2023 01:19:49 +0200
Message-ID: <CANiq72k_tEaWO1MCb7mfoJPzAEFhCdSpiezvENSf0A1+mfHB8A@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add Andreas Hindborg as Rust reviewer
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>, 
	Andreas Hindborg <a.hindborg@samsung.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 18, 2023 at 7:44=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Andreas has been involved with the Rust for Linux project for more than
> a year now. He has been primarily working on the Rust NVMe driver [1],
> presenting it in several places (such as LPC [2][3] and Kangrejos [4]).
>
> In addition, he recently submitted the Rust null block driver [5] and
> has been reviewing patches in the mailing list for some months.
>
> Thus add him to the `RUST` entry as reviewer.
>
> Link: https://rust-for-linux.com/nvme-driver [1]
> Link: https://lpc.events/event/16/contributions/1180/attachments/1017/196=
1/deck.pdf [2]
> Link: https://www.youtube.com/watch?v=3DBwywU1MqW38 [3]
> Link: https://kangrejos.com/A%20Linux%20(PCI)%20NVMe%20Driver%20in%20Rust=
.pdf [4]
> Link: https://lore.kernel.org/rust-for-linux/20230503090708.2524310-1-nmi=
@metaspace.dk/ [5]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next` -- thanks & welcome!

Cheers,
Miguel
