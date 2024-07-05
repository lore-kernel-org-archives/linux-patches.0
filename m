Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35AA13665A
	for <patches@lists.linux.dev>; Fri,  5 Jul 2024 12:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720183978; cv=none; b=KVoEL/vNkPTbAT/q/UtiEzvxGREwk7VnfVMOxgFFb9KG1ws942XUwHl4aKc1PKk5CIv18KnWDH4ne+iBcuvGosgt+j3c1M6yjeohwsd9DY3P/HpnIBH0ue3r94a/RSzQCkrSvJVrQ+kb8j/tVAJtFA2aufbP/3eqbMBpYIiTjIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720183978; c=relaxed/simple;
	bh=Ny4NipcrdKMJRHgPMlWIpSzIm0jwdGYQDrlVbxourss=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OoBaxUGGXB59vKRe/62X9ileJEqE/XWDpBt6+479PzXdUKOR1VossWZ028Pi6oySvlw1v00D9QkiXOzZmixBGJDkKCPlgkmmxW7id1U5pfgbBWc0LrtOFRNOunO7ryAskBQQmyDw3pSLlCPDD20W6ldaGnSeNMkmlZPSd866/Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=blo8Hybn; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="blo8Hybn"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2c967e21888so1101580a91.1
        for <patches@lists.linux.dev>; Fri, 05 Jul 2024 05:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720183976; x=1720788776; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ny4NipcrdKMJRHgPMlWIpSzIm0jwdGYQDrlVbxourss=;
        b=blo8HybnV8pIGSTuIT6ZIVso2DOdSiOiNuHqx/jahlezpwdRFolYw+7hAzVKhnZM0s
         aga2UMP1kBi+wg++cmJLG+2v9z8z/eX8woohYbc276OpqOycgBMnL7O1eZQk/YcUBxqm
         Igy2q1q497UhggT3r1KBtiACXk9zKaXCbEAg7cY5PXfC5beCX+iIP7j23KhNLyty85gl
         iXw/pnp8os9nEPlrUVUu+CMK3ekmJz+FLRCjyD/oeDVt9uncbqWWJCF8WC1YTOiml/Ju
         Erj8321q82gt27VwUn4mnp927PhNzUtKckNDoIKxWroiGH6xhBP+ok28amqTPcI5HCIR
         DcLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720183976; x=1720788776;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ny4NipcrdKMJRHgPMlWIpSzIm0jwdGYQDrlVbxourss=;
        b=a0n7vfT/pqyeshoYZTCmuTgD0uuEm2y0S5mYZZqCGRbzbzyLFEVLQwGqFNPNH2rE3/
         8D+8Y66C08i6X5gsXxIjCnb8Wul5e5jlpav0nElSlEXdv/5HirpqSO8Xwaq75t1D1KVI
         tonST2xiNQpIypaZA7TGIZjmpGnhgmnBt8hmjhK0/mvcitXEfH+zONJ2TLHvApusqiwS
         R/FGZzQpVhlMDaV4yfInPEADjbfTBC+BFOnCdw+KlZFHhZoZM+e9EuKstXfx0qj6A73B
         Fp2q4ujK2E3jOoci9KZDHQErIKqmMI5JlW/b6r41hlEqdM28zZ0idKyYaGO/TAeOfrQe
         spQQ==
X-Forwarded-Encrypted: i=1; AJvYcCWMXSHyjqIAlIga+OsSavffzYPwU5uJXYShrXaUQ5EfFpiWcezRnQDAMqT0vmjdteqq0wJGjuugbFF2qRj14Ezl1yBPnQRE+Q==
X-Gm-Message-State: AOJu0YwKtuFBGkQI24LL+OAyzefnLXu6tyDsczsSxaO6E9mrWHj+u992
	ADegmOJ7o+bJGpU76dRpE2O5Y5KHpjtNSq6Z1nuu4L6CDT76sQzhZTakar7aaQJwSkdLhSXsMw3
	h7XrYwXHRES+LOCmC/yvD41gAUcI=
X-Google-Smtp-Source: AGHT+IEzG1wQ2tyKmgXA6YWzUKo96HqR7GDGf+HBNV2kpFi+8P06yzDR0xNhdvTYwQ4FFo4HCneqcI3eTwMsgMHmaek=
X-Received: by 2002:a17:90a:de91:b0:2c4:aa78:b48b with SMTP id
 98e67ed59e1d1-2c99c6b954emr3709128a91.38.1720183976081; Fri, 05 Jul 2024
 05:52:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240701183625.665574-1-ojeda@kernel.org> <20240701183625.665574-14-ojeda@kernel.org>
 <ZoeQVYda-AZN6PYy@gpd> <2qwdfogh6jd5uixxjzlagmtfvnykk3x4ztqrn4j2v6qoref5rx@ooj6gq27bq4z>
In-Reply-To: <2qwdfogh6jd5uixxjzlagmtfvnykk3x4ztqrn4j2v6qoref5rx@ooj6gq27bq4z>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 5 Jul 2024 14:52:44 +0200
Message-ID: <CANiq72n6bYt0AKNxad2+gjwHKQ1RiDxAbjm-2u20L8TcSZE-9Q@mail.gmail.com>
Subject: Re: [PATCH 13/13] docs: rust: quick-start: add section on Linux distributions
To: =?UTF-8?Q?Fabian_Gr=C3=BCnbichler?= <debian@fabian.gruenbichler.email>
Cc: Andrea Righi <righi.andrea@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Jan Alexander Steffens <heftig@archlinux.org>, =?UTF-8?Q?Johannes_L=C3=B6thberg?= <johannes@kyriasis.com>, 
	Josh Stone <jistone@redhat.com>, Randy Barlow <randy@electronsweatshop.com>, 
	Anna Figueiredo Gomes <navi@vlhl.dev>, Matoro Mahri <matoro_gentoo@matoro.tk>, 
	Ryan Scheel <ryan.havvy@gmail.com>, figsoda <figsoda@pm.me>, 
	=?UTF-8?Q?J=C3=B6rg_Thalheim?= <joerg@thalheim.io>, 
	Theodore Ni <43ngvg@masqt.com>, Winter <nixos@winter.cafe>, William Brown <wbrown@suse.de>, 
	Xiaoguang Wang <xiaoguang.wang@suse.com>, Zixing Liu <zixing.liu@canonical.com>, 
	Jonathan Corbet <corbet@lwn.net>, workflows@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 5, 2024 at 8:47=E2=80=AFAM Fabian Gr=C3=BCnbichler
<debian@fabian.gruenbichler.email> wrote:
>
> Debian (for building firefox and chromium), and uses a -web suffix for
> that:
>
> https://tracker.debian.org/pkg/rustc-web

Like for Ubuntu's versioned ones, it seems not recent enough at the
moment (i.e. for the current kernel), if I understand correctly.

Also, it is a single version, i.e. 1.70, right? We didn't use that
particular version in any old kernel version (we moved from 1.68.2 to
1.71.1 in commit 89eed1ab1161 ("rust: upgrade to Rust 1.71.1") back
then). So I am not sure how useful it would be, but if you think it
will be in the future, perhaps it is worth mentioning.

> https://tracker.debian.org/pkg/rust-cbindgen-web

We may use `cbindgen` too in the future, but not currently.

Is something like `bindgen-web` also available for stable?

Thanks!

Cheers,
Miguel
