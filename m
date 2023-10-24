Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57321224C6
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 09:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ig8OiruR"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-59e88a28b98so35946347b3.1
        for <patches@lists.linux.dev>; Tue, 24 Oct 2023 02:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698139029; x=1698743829; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XNYeLrZv7kaj7YSjwLQVnoc7iNnINn+4roLTxfquFmk=;
        b=Ig8OiruR/wlhQW6mShsVbeVlDMoStzvwAyUdpUVURge/lFcDddAHaTJLw9v9iN2S0l
         +rZOyf6B2g89Xw4zZx4c+92Gso76KCdTqdaa+aCO4FJivmyma/8QNsMS3z3tOydiUz/k
         Q7pvGMMPo+pt/FTWvocrWWCh1jrsVrstfUHBucL2SiEBqFRovWg6oXeBW1gSYmK0T3wN
         EjzXc2IExvIWrsdZj81vssjCjDKcCK178uUb97ODvvv4NRmzcG5JKZEZMHIDu50ptMfr
         YQW8Dw/Xxw7HjRpLGXahhB3znL7jluUgBCtBQfuIZge6O75S0u2ojlnHAR2MXNhlveAP
         2bvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698139029; x=1698743829;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XNYeLrZv7kaj7YSjwLQVnoc7iNnINn+4roLTxfquFmk=;
        b=H4L/9ksnzBFIwD2mh+dCUqdUxsllD+30cwNMtg1y4benY6UqKC/HPHRq64mE9GKDua
         PrxCyQwLxSLc8l6fJl3ZgqWI0vOKxNGduMd8aSLdlHSfohvZscS0/pK5SR6Kl8wRu5J2
         LqpoXE1scMIi9nMnLLE4mL3B5D9SdB0SNkl2SXFurar2fTM0OXfOA4IQ6u1pcddK//2T
         Fe6u+o4XhffkoK2Uj2x/AT+aD5jBQk+LvH5Xqyis15DCjEKW/HWlVt2hLeLld60QrG8d
         ZbzS7+bL6KrFw0IoT9SB9Lq8P/OjuVKlDpbWzCu+aW30cGCf/Vks6esnB3CilFXBAa5+
         qZzg==
X-Gm-Message-State: AOJu0YxZwHqsO+LcYe+CZ/Qi4azKKkUqSjNKFP51zlSXIL84aA/3UiQt
	KCaxz/rK9iYMokKwMuwnqWECL3dDZqwNqh/2SH0=
X-Google-Smtp-Source: AGHT+IE5uxOZHvB7YhHuU8DvcHe0Glt6TPmvQBoHg68p9mpGEiIrWa8WAwQdbZ4hr++6HHHoiat5MZeXow2v8KGQWZU=
X-Received: by 2002:a05:690c:fd6:b0:5a7:f263:6873 with SMTP id
 dg22-20020a05690c0fd600b005a7f2636873mr13342557ywb.20.1698139029254; Tue, 24
 Oct 2023 02:17:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231018160922.1018962-1-ojeda@kernel.org> <dcb9d0bb-67a3-2f50-9d17-251baa24b066@amd.com>
In-Reply-To: <dcb9d0bb-67a3-2f50-9d17-251baa24b066@amd.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 24 Oct 2023 11:16:57 +0200
Message-ID: <CANiq72kjbrU7gDOx6m+KY89B0YhAk0FQ8L9BvSXEF2UeYqP88w@mail.gmail.com>
Subject: Re: [PATCH] docs: rust: add "The Rust experiment" section
To: Carlos Bilbao <carlos.bilbao@amd.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, Andrew Lunn <andrew@lunn.ch>, linux-doc@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 23, 2023 at 4:34=E2=80=AFPM Carlos Bilbao <carlos.bilbao@amd.co=
m> wrote:
>
> Personally, I would rephrase this to:
>
> "Please note that, as an end user, there are currently no in-tree drivers
> or modules suitable or intended for production use."

Yeah, I think the "yet" -> "currently" change helps, so I took it. I
haven't changed the "if" to "as" because some readers are not really
end users but kernel developers/maintainers, so I think it could be a
bit confusing.

> I think this will be helpful.
>
> Reviewed-by: Carlos Bilbao <carlos.bilbao@amd.com>

Thanks! I have changed the paragraph to this, can I still use your
`Reviewed-by`?

  If you are an end user, please note that there are currently no in-tree
  drivers/modules suitable or intended for production use, and that the Rus=
t
  support is still in development/experimental, especially for certain kern=
el
  configurations.

Cheers,
Miguel
