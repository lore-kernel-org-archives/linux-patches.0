Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894AE171C4
	for <patches@lists.linux.dev>; Wed, 31 May 2023 17:05:43 +0000 (UTC)
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-565a6837a0bso78088977b3.3
        for <patches@lists.linux.dev>; Wed, 31 May 2023 10:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685552742; x=1688144742;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jLI3C77UUH8a7vo/UtwCwZu01ZTIS8d3sU+aRADHIYU=;
        b=G4nllCdJCOjAFj8ZxauXRVVq7uw3y0OzOdsiezqKZ5DfFZNlEkLII7Hc7TJdeKh15W
         eLLTQmortFLT8AesUuBvWfjQ4B8Ene6kWHDmTjfJ3PgG53lkEywPKBTOSQ7nEvVYc5N9
         hqBGIrLP/kl+rwSgNz22YgWGan8dh0MG1T6q4N7Cuw8D59P6pTH0cIeQsCLSZE3vnVv0
         sVM65wKdQI4y/thZgJoRv5TOWcSalI0Rmj+V7cdo0Ma/nr4etRXgjHTyt/TpOwjOXfyV
         8XXrYhdlCvsQjWwrjIUpYSgrI+Djq9ea9+qe20Iq2aAfVOG25FogpBOjRa2bsnVtj8XC
         C5/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685552742; x=1688144742;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jLI3C77UUH8a7vo/UtwCwZu01ZTIS8d3sU+aRADHIYU=;
        b=bl0hVZKzu+d7iwWWzMaqFIYQloGRLws+Zz2/oqnGZNjJrgJNWRK1RDXozQ0GMYPF41
         Gskk3Ft98t/OB3UR79E2S3nRPUzxr1zvgGpJOJ/W4hybYflMALMcN09j1ChXoLOWTkVf
         nX1ffrkOOzpbr821yVMmg0jcD2LQInnhDtJ1jF3hC/52cu8zYuFerSsCSh25gnjRKwWw
         UG5UF9VH/Qw6bS3UBk976F/6CCUW/5l7YRYPID5nGxT11GhNCA8Vx1nyxf4G5dygbYhp
         /w6Ov0gD6HeGEMY+QSulB+SRm/IKjqNLkGzUxfUhNLe/NHOtF5j2WTmxOHsXINgmzP2z
         Snwg==
X-Gm-Message-State: AC+VfDwxdxRI2squ7TO5GlKrYAz2l/c2qCIZJz4RorBgBH5Zp7UJT9XN
	Pi3HIc3/9P71Yu9f3dwRoqrpPpBLdAf5VnZ7oKU=
X-Google-Smtp-Source: ACHHUZ7T5FWtaCksEYIGCfBxBoHHCSoylR97os4Rjz45cR+S5pJnqL6TG4nigKhZP13Jl/iqOnTvmluSNUoNaVjYCL4=
X-Received: by 2002:a25:242:0:b0:bad:c64:4e0d with SMTP id 63-20020a250242000000b00bad0c644e0dmr6780393ybc.35.1685552742397;
 Wed, 31 May 2023 10:05:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230306220959.240235-1-ojeda@kernel.org>
In-Reply-To: <20230306220959.240235-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 31 May 2023 19:05:31 +0200
Message-ID: <CANiq72kun_ZLRBB_h3-Dtby3G0brDV+xWb-mda=3QC_oRyzMfQ@mail.gmail.com>
Subject: Re: [PATCH] docs: rust: point directly to the standalone installers
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	linux-doc@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 6, 2023 at 11:10=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> The Quick Start guide points to the Rust programming language front
> page when it mentions the possibility of using the standalone
> installers instead of `rustup`.
>
> This was done to have a hopefully stable link, but it is not too
> helpful: readers need to figure out how to reach the standalone
> installers from there.
>
> Thus point directly to the page (and anchor) with the table that
> contains the standalone installers (plus signing key etc.).
>
> If the link breaks in the future, we can always update it as
> needed. And anyway having the full link includes the domain and
> gives more information about where the old docs were in such
> a broken link case, which may help.
>
> Link: https://lore.kernel.org/linux-doc/CANiq72=3DgpzQyh1ExGbBWWNdgH-mTAT=
dG5F600jKD1=3DNLLCn7wg@mail.gmail.com/
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next` (with Andreas' suggestion applied) -- thanks everyon=
e!

Cheers,
Miguel
