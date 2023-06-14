Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C60134A7
	for <patches@lists.linux.dev>; Wed, 14 Jun 2023 22:09:12 +0000 (UTC)
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-bb2ffa1e235so1085069276.0
        for <patches@lists.linux.dev>; Wed, 14 Jun 2023 15:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686780551; x=1689372551;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1ZY8IYbBCwqFgvXl6puz847AvvCr9iy7X2X1F65i07c=;
        b=qo4/gsWJ49ZV1RB1v9Hag7fSKofMhHFr1Yb7+yLi+CrZbmi+/fIuin5MH/8Tl4CNnz
         4Z4+5viyR5gSk/SfWjh28CJRg2X5Rqf/91o3cpPKNlrAyhS8+kWcTkk3P+mYEC10xVb7
         4NjuEzf/rN8Xe/iB1VoTALNNo5Auue5tlDCL2gU576oMLQMNboy+JhgiM124otpssHvs
         UIeupf1PHsM7N/nBZXDLJXE5bzSdp6XHcNGF/6qqnmGF9y4ZD1L7f2GtkmH98pBzvRMy
         QoChaQyLB4L2h39C2PAotdwpDz+S6fUuk/K7roJFjOV9qXwCNkfs7/HB+MvA5PxRUiOK
         iXrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686780551; x=1689372551;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1ZY8IYbBCwqFgvXl6puz847AvvCr9iy7X2X1F65i07c=;
        b=CZ7+o28ULlOjwVAyD19NpBUFb5pCpxwDMjCzL+Y0ZYz5YXJNZg8y4QK1Ms6GitX4Fh
         7I+NwZqd0uvtWK9VvhQroS2zUeRmJYVqQM1FvdXREoKK8/Yt3d0f7sDfdvyPHECnV7nO
         CScLvxq7CFaOTJ+HTGAIXV3bhl2fifRCgC9cQ4kmoRJSIDRUvaD5t5t5Mr8Y4KAk6fs4
         7s8g6bVjR/NG63vF2t0Q8ttFnIAHyTfmePgofXI6SuryvBCb5JDGhq4mrLi88dSFSBbu
         2k7075a0wCfupsE34rKq/TxUoU/S5MuYpCEuZPmeLMSWj5ix7j993zQHjnvi7JhTrvq5
         mutA==
X-Gm-Message-State: AC+VfDyluTIAfMDl/Dz2Wki+xQSoFkFUhduCqpZ6eBXgSpkomEbQ7dKo
	ieCH4TiPcQeiDnHuPzzL+czoLBh1Z+gNKJyMMCo=
X-Google-Smtp-Source: ACHHUZ73VU9isra/qJrbZ9eQzPjDJFWewvwYjUqCmdZqS2Lkk2a0g9gKp33Fa1FYuwamE3ks65eoCOh+SYJDegLKPVE=
X-Received: by 2002:a25:d86:0:b0:bd5:ddcd:bc9e with SMTP id
 128-20020a250d86000000b00bd5ddcdbc9emr3275028ybn.17.1686780551502; Wed, 14
 Jun 2023 15:09:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230614180837.630180-6-ojeda@kernel.org> <20230614203803.2910957-1-aliceryhl@google.com>
In-Reply-To: <20230614203803.2910957-1-aliceryhl@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 15 Jun 2023 00:09:00 +0200
Message-ID: <CANiq72n-WocEegVc2-Em6muU4pOTOh+Lf8RAwiAtjuUUjnysbQ@mail.gmail.com>
Subject: Re: [PATCH 5/6] rust: support running Rust documentation tests as
 KUnit ones
To: Alice Ryhl <aliceryhl@google.com>
Cc: ojeda@kernel.org, alex.gaynor@gmail.com, benno.lossin@proton.me, 
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, brendan.higgins@linux.dev, 
	davidgow@google.com, gary@garyguo.net, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	nmi@metaspace.dk, patches@lists.linux.dev, philip.li@intel.com, 
	rust-for-linux@vger.kernel.org, wedsonaf@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 14, 2023 at 10:38=E2=80=AFPM Alice Ryhl <aliceryhl@google.com> =
wrote:
>
> This could just be
>
> std::fs::write(path, body.as_bytes());

+1, simpler, less `use`s needed and less size:

     320429      12736        368     333533      516dd
scripts/rustdoc_test_builder
     314701      12440        368     327509      4ff55
scripts/rustdoc_test_builder

Thanks for the review!

Cheers,
Miguel

diff --git a/scripts/rustdoc_test_builder.rs b/scripts/rustdoc_test_builder=
.rs
index e3b7138fb4f9..e5894652f12c 100644
--- a/scripts/rustdoc_test_builder.rs
+++ b/scripts/rustdoc_test_builder.rs
@@ -15,8 +15,7 @@
 //! from that. For the moment, we generate ourselves a new name,
`{file}_{number}` instead, in
 //! the `gen` script (done there since we need to be aware of all the
tests in a given file).

-use std::fs::File;
-use std::io::{BufWriter, Read, Write};
+use std::io::Read;

 fn main() {
     let mut stdin =3D std::io::stdin().lock();
@@ -69,5 +68,5 @@ fn main() {

     let path =3D format!("rust/test/doctests/kernel/{name}");

-    write!(BufWriter::new(File::create(path).unwrap()), "{body}").unwrap()=
;
+    std::fs::write(path, body.as_bytes()).unwrap();
 }
