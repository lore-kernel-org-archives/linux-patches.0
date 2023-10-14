Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32321FBB
	for <patches@lists.linux.dev>; Sat, 14 Oct 2023 20:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k1TScJoi"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-79fb64b5265so134731439f.1
        for <patches@lists.linux.dev>; Sat, 14 Oct 2023 13:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697315126; x=1697919926; darn=lists.linux.dev;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E5emPS0MjB2QN+kJ9u45m+WJbhux12t/sQVDicjCU/8=;
        b=k1TScJoiPWNbRO4uKVwKe7Ssq0JsyGZ3Xg6MiLLoC9o/S0slB/uJ9MkVRpPB4ejij/
         cxR0vSUoRArholwsCxGQ2lfn6G2EVj6ELpF2A1o6qRB7fdO65icvkJocfqL0TTJ57NGM
         9+9x6nLlQTLWmhXcvIxBwrPY193Le6wqn9si4JXTdxvanGc9hm2UmDGedJewgIE6y53c
         5UAp5cKATHQTlwP9pqKiSSKgDcQnMMkXAu5g0VM3IWP5xh/gC5FRcjmpIpz3j2eiMGUD
         SJXsRYZkfL9tBbz3YWTbQblxx4XtGQYZ7nT7NhwP0oR8a5l353aC/4jtTMmzRbQA98HL
         LpDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697315126; x=1697919926;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E5emPS0MjB2QN+kJ9u45m+WJbhux12t/sQVDicjCU/8=;
        b=GqQ5FhXSG2PTIB4A+UeRzcBpTr1DBucEK92Mn6JR1SRTcJ/Mq0xuc/WoU9rYqZInhx
         4QThrnnROqip/xJQvSytEuzNp1u5NYCxJtnvREM+uaK/3KxrcuLU0Mn+3WZfvPix+/J6
         z6J7EF1xIgB5Tg4sd4SA7N5mnoo30RGtq6hkJLfISRLo2u7E1U0+YL0fBQdpbwxq5Pf/
         f1wjD/h1YlMshJvSbFTAUAQ331NgigOgcPBE3tvQEWmpyUFUzFIhqRzwnXOdK1ZAWxS1
         j/ftjuOoB5ldRpQaZMQwbkWSgeHkuzbIXZb6mD20G7bRl2Ihm52d6A6GRjeGDN0TvYEs
         AbkA==
X-Gm-Message-State: AOJu0Yw5FIOG44Jpn57S5Pk2YYoV2g/czcN8BWGIqVjjMbPJn7Uaecmj
	tJwWDaS+yQa7nhci8ndYwrU=
X-Google-Smtp-Source: AGHT+IHQ0wSofw+mCUxwMOTU704LFNtov6E/5kWHV55+P8O46TcQpo0iXIpmVZ9xJ+NCX1B/ckWz1g==
X-Received: by 2002:a5d:9d10:0:b0:79f:c9ad:19ce with SMTP id j16-20020a5d9d10000000b0079fc9ad19cemr30998453ioj.15.1697315126209;
        Sat, 14 Oct 2023 13:25:26 -0700 (PDT)
Received: from smtpclient.apple ([2601:647:4b00:6db0:ed49:22d9:e5d5:b7e4])
        by smtp.gmail.com with ESMTPSA id x4-20020a170902ea8400b001c5076ae6absm5861510plb.126.2023.10.14.13.25.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 14 Oct 2023 13:25:25 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.200.91.1.1\))
Subject: Re: [PATCH v10 25/27] x86: enable initial Rust support
From: comex <comexk@gmail.com>
In-Reply-To: <5D8CA5EF-F5B0-4911-85B8-A363D9344FA7@zytor.com>
Date: Sat, 14 Oct 2023 13:25:12 -0700
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 Ramon de C Valle <rcvalle@google.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Kees Cook <keescook@chromium.org>,
 Sami Tolvanen <samitolvanen@google.com>,
 Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
 Miguel Ojeda <ojeda@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,
 patches@lists.linux.dev,
 Jarkko Sakkinen <jarkko@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>,
 Wedson Almeida Filho <wedsonaf@google.com>,
 David Gow <davidgow@google.com>,
 Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Jonathan Corbet <corbet@lwn.net>,
 Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org,
 linux-doc@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <BDD45A2A-1447-40DD-B5F3-29DEE976A3CD@gmail.com>
References: <20220927131518.30000-1-ojeda@kernel.org>
 <20220927131518.30000-26-ojeda@kernel.org>
 <Y0BfN1BdVCWssvEu@hirez.programming.kicks-ass.net>
 <CABCJKuenkHXtbWOLZ0_isGewxd19qkM7OcLeE2NzM6dSkXS4mQ@mail.gmail.com>
 <CANiq72k6s4=0E_AHv7FPsCQhkyxf7c-b+wUtzfjf+Spehe9Fmg@mail.gmail.com>
 <CABCJKuca0fOAs=E6LeHJiT2LOXEoPvLVKztA=u+ARcw=tbT=tw@mail.gmail.com>
 <20231012104741.GN6307@noisy.programming.kicks-ass.net>
 <CABCJKufEagwJ=TQnmVSK07RDjsPUt=3JGtwnK9ASmFqb7Vx8JQ@mail.gmail.com>
 <202310121130.256F581823@keescook>
 <CAOcBZOTed1a1yOimdUN9yuuysZ1h6VXa57+5fLAE99SZxCwBMQ@mail.gmail.com>
 <20231013075005.GB12118@noisy.programming.kicks-ass.net>
 <CAOcBZOTP_vQuFaqREqy-hkG69aBvJ+xrhEQi_EFKvtsNjne1dw@mail.gmail.com>
 <CAHk-=wjLUit_gae7anFNz4sV0o2Uc=TD_9P8sYeqMSeW_UG2Rg@mail.gmail.com>
 <5D8CA5EF-F5B0-4911-85B8-A363D9344FA7@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>
X-Mailer: Apple Mail (2.3774.200.91.1.1)



> On Oct 13, 2023, at 12:00=E2=80=AFPM, H. Peter Anvin <hpa@zytor.com> =
wrote:
>=20
> Transparent unions have been standard C since C99.

I don=E2=80=99t think that=E2=80=99s right.  Certainly =
__attribute__((transparent_union)) is not standard C; are you referring =
to a different feature?
