Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E109474
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 20:13:55 +0000 (UTC)
Date: Wed, 12 Apr 2023 20:13:34 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1681330428; x=1681589628;
	bh=R+WoLmWuecqwRSEBmC5tnSn+wxUTipT0To/pDvrDmlc=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=RxO1+5fRUD7vXsUe+Df1yh0XPkds+RM3QbGWWnhb43rlSsEMHp5g1uUN3V/BMbaGy
	 VwirVEf6/RhJgCuW48gf4/3CnOMe+L/CzE1olgF3OHt+xD0BZxPFE2Ie3dtEofOhN/
	 tO6BjMWshp/c27NPPLVQrS+0nzDqZJ3D+D1VUwN4eOKHroNDYE1pBvzB23efZqtv4B
	 0/MoyD9t3GwdzU2TLgP14vn9s39ZUnP8Pe64Q+WND83EDLgWbPNGnS9r4IN0azOb4s
	 wIgpZDYaAY57s7pBA1b+/4AONizg4VkvSnxWApPJtnLbLr/isqCMh7D6cplgCygFgE
	 9STx4VX9v1XBA==
To: Miguel Ojeda <ojeda@kernel.org>
From: y86-dev <y86-dev@protonmail.com>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Alice Ryhl <alice@ryhl.io>, Andreas Hindborg <nmi@metaspace.dk>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v7 00/15] Rust pin-init API for pinned initialization of structs
Message-ID: <TTE27GJ76877W-sIzVb_b80o8dCEf-CSDOKHLMTeYD23mET-2EymYGp9PII26HWZb0vF-emqnkIVdVKNwEqQHmWNZq_7P_GiL_U9Eyk0R58=@protonmail.com>
In-Reply-To: <20230408122429.1103522-1-y86-dev@protonmail.com>
References: <20230408122429.1103522-1-y86-dev@protonmail.com>
Feedback-ID: 40624463:user:proton
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Miguel,

could you please change my current email on the patches from
    <y86-dev@protonmail.com>
to my new email
    <benno.lossin@proton.me>
Please do this for the Signed-off-by tags as well as the actual
git-author. Lina's patch to introduce `UniqueArc::assume_init` has
my Co-developed-by tag, also change the email there.

Much appreciated!

--
Cheers,
Benno
