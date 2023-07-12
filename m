Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F9C1FCF
	for <patches@lists.linux.dev>; Wed, 12 Jul 2023 16:37:09 +0000 (UTC)
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-6b5f362f4beso6178293a34.2
        for <patches@lists.linux.dev>; Wed, 12 Jul 2023 09:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689179828; x=1691771828;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kmKyOnNmUTgEJLuCWcdcYvSh4JHTJkDxRam3/lA8n28=;
        b=sq9fjSOdWsLlfQWyRmcEifnlqGQn9TpJbxNtbNHmAgHbMAEvEy9Zxfc84ukbvefysE
         Sg+7pFP5xIeg1me6sGQEx0SSFScQc85gl2kLGOqKCEkch3sZnfuR9rWwxvQ/mSuDZMmt
         1vBfSU2Tk1ttFA8Vgvs3NAaZa0itPPJXiwkiDupi76msNB/rBE5ozMXbr/tJDYu0ajo2
         OPw5O9KMZLY0EPnmV+a7J2dMPeVWnlw0gR5baIyR8vpthW3yzHTtbjJtprZD6Iq7MJLU
         9HDUfGDWrj0zX5vcQzFQyJCG5Z2AAf8ITRMC/cpqc6i6dTWq0nbwxcxlsrv5EFAZDzzR
         TdXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689179828; x=1691771828;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kmKyOnNmUTgEJLuCWcdcYvSh4JHTJkDxRam3/lA8n28=;
        b=cv8RWjLfL0TInMARu4sC5YxsFXb9NRBzvTMajHJEnqMM8yh7HnGAYl7wVZhOCPFdFa
         KPKNTHVzymICJk2V0TWQSnA2+aRmEyfqOxrrbMH645JjAyiufjmrm5C+QDUVUTBDHeCP
         ME8U/srRDHBSNKeL8DtncfZWGmpKh4EvMPLrLZiLiJiyX1Lr1X5Bc8Isg3JXsY0/T3+H
         1j0/DpwTW9Puo//WYB7BZKMVlKCGUnsFWhn39r6eDJUrQwdD+ij9Y29vz1Isi2YgaEPl
         +9k4HMCL51lmlTfPKwboU/mZVVGb8U6AC/Cou248BpZMdFVcTWVy+6Ic5ECimJGy49qM
         38Bw==
X-Gm-Message-State: ABy/qLYA5AqvBLQOtp4FYw7BPikIQc9KK5OcdIeFeTZI3sAk4CMbO0T1
	KpIEJ0KM28R7PE76vnM0BJFg9be5B80HNs7f12I=
X-Google-Smtp-Source: APBJJlEX/fKsBhslCfhWuK6jrdf/dbfJerv3ymjaUsU9DvA6tIoxIM2iPjeZ42d/Pudpe5i/v77731CUHtnc3RNt8WY=
X-Received: by 2002:a9d:7445:0:b0:6b9:a399:85b3 with SMTP id
 p5-20020a9d7445000000b006b9a39985b3mr1764729otk.34.1689179828673; Wed, 12 Jul
 2023 09:37:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230711093303.1433770-1-aliceryhl@google.com>
 <ZK3VEPeBEyErmerR@slm.duckdns.org> <CANiq72nktgf_j-+S7snysQgwqeqB12sfjc-vrLsnOUKiZZ5WJw@mail.gmail.com>
 <ZK3zj4xPBD0NfaxM@slm.duckdns.org>
In-Reply-To: <ZK3zj4xPBD0NfaxM@slm.duckdns.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 12 Jul 2023 18:36:57 +0200
Message-ID: <CANiq72mBNS7Vswn+3oLEB_Lj_TrWLY2HK2z9va-OBDpztywjeQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/9] rust: workqueue: add bindings for the workqueue
To: Tejun Heo <tj@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	Miguel Ojeda <ojeda@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 12, 2023 at 2:28=E2=80=AFAM Tejun Heo <tj@kernel.org> wrote:
>
> It's not a lot of overhead for me but I'm also not sure whether I can be
> actually useful. Once folks are happy with it, I can create a separate
> branch for this series in the wq tree so that others can easily pull from
> it. Let's see how that goes and if my involvement turns out to be pointle=
ss
> we can route future changes through the rust tree.

Sounds good, thanks! (and the branch would indeed be very good, in
case we/someone need it in the Rust tree this cycle too).

Cheers,
Miguel
