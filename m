Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E99F7461
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 08:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aXVGP42n"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-5a8ada42c2aso42409737b3.3
        for <patches@lists.linux.dev>; Tue, 24 Oct 2023 01:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698137744; x=1698742544; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oLZGqz6UYX/ddgHmGp/3YSovbVZZCzUQK2Gy9MOvl2s=;
        b=aXVGP42nrSRK8gHbddnAGzaJ4Fdfp5ZdXBR70TQlBnLCX4hFM8PDKN3qsVDPFoYXnc
         ZocTXfy7p0xhI3CkG26xIjchkyYr+0oGiORNsys6XOwAjdVFq4OUwulHQljX/T5G4g95
         hZDav4Y8YH/L2P58yE48E+1Oo3ymlYPo0c7bPEuByQm5K9DmyEZgkkivwYutY2B4d5rX
         9aO2hbyuBQiynDggucMNF17Wb1kb68K8vNMKgAlCEBMyAu+xGdBHHemjY+ADfT24SP3j
         cyxguk5w2H/gZFPqI9Big5pDmqKOQuvy18DY7sUhf7+cmaDD1ctxlJ7HRf4WbQWXXSnO
         tjMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698137744; x=1698742544;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oLZGqz6UYX/ddgHmGp/3YSovbVZZCzUQK2Gy9MOvl2s=;
        b=pA6M/FlYcaM4d4jIuvynv3vGwv6jgQSb3Bkl1Il/N2ucpUfEBX5+hDyNst6TxwLsWv
         Hc/LR2gHL/3c2+AftwGZb1hQIWgsUsVEf9pxGEf8/EPkyDirpk0hdpdzB3lN3aOUlgvo
         +vDCtvoFhey3d7kW/W2lQtDqTG2xQCl8YEg4HpVCA37vQHysNSYm9wrK4VNFx0m/fPDm
         ncIDXrHFPOzsgnoObst9smbR1ajBcd22xLbpTlRt8sVzyMYladezZ4n6spoDbp+lnwsv
         yRhJq4gYN3053V9ZH5+mUcEiJBEWYl2STpH0Mu3IfTwdGVZThnOAliIdTjssLsusUjru
         h0YQ==
X-Gm-Message-State: AOJu0Yz+ebm0DOu+d4iSJsPko1sZjVcbyJxXQbVCNUj0nJFpgmt2iRVH
	07dkG/z1UiNbjN2QuJU1d4OfljC3GIf+dBugs+BKaaWpxlM=
X-Google-Smtp-Source: AGHT+IGG+PHV00fQVOh1xKFJBCV/fyXSVMUCW+/LlALS0zYopeOmD9HLQGdfyn9TCndvui+vGbcR/vNqzu3xWHKFtWg=
X-Received: by 2002:a81:7bd6:0:b0:598:5bb5:1801 with SMTP id
 w205-20020a817bd6000000b005985bb51801mr3460956ywc.50.1698137744345; Tue, 24
 Oct 2023 01:55:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231018160922.1018962-1-ojeda@kernel.org> <d47553f1-1832-4c69-8a8c-71c58048ff30@lunn.ch>
 <CANiq72=E7TPLcq-yiQF9E8a33ghbogPcbv-yMqFKBxMQ0oOxNQ@mail.gmail.com> <5c3f3ef8-e93c-49f1-881f-11c02afdaf7d@lunn.ch>
In-Reply-To: <5c3f3ef8-e93c-49f1-881f-11c02afdaf7d@lunn.ch>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 24 Oct 2023 10:55:33 +0200
Message-ID: <CANiq72k8Q8QCc+6azwah7ApFM5+7J0f4nWY3Rud1wqPOB0wP+A@mail.gmail.com>
Subject: Re: [PATCH] docs: rust: add "The Rust experiment" section
To: Andrew Lunn <andrew@lunn.ch>
Cc: Miguel Ojeda <ojeda@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, linux-doc@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 20, 2023 at 5:00=E2=80=AFPM Andrew Lunn <andrew@lunn.ch> wrote:
>
> I've talked to a small number of netdev developers, not many, but
> some.

Thanks Andrew, this is valuable information (also for the upcoming
talk in netdevconf).

We have been putting some of the meta-information you mention in our
webpage instead, because it is easier to update (it is our `P:`
field). We will do our best to keep expanding it in the future.

Cheers,
Miguel
