Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB641B043D
	for <patches@lists.linux.dev>; Sun, 12 Jan 2025 15:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736696864; cv=none; b=KcErR6GNg7bwXf5KifikNcFGPNeK3R22OS9Vtz17Ef12kYnRgxGvLYrecD5NHXSRLkbs8KOHGGG3NTKHnACtlv6NiBj0C/a4d2tFd6he7BJXQUxmMs9KrBCK62AmDlMUUqBkwHZ5qK73hNC54pW60eLRDn+VKSbDkEX3RxmHYy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736696864; c=relaxed/simple;
	bh=LXeZMhXpbNWXXCw5j0HTKXlK5NN4ENbRgYHtNKHteRI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ah8zaWC4aQisCOHin12fEbwst/X7cmiqAaOrMwfl1bVJjxV5xEma6M1K4mlOvmUglAHhd3Mh12zVKcr6LupxlsWTGvLV/mSLqZftQc3gVOrXs6Cc4t9EhlkFRjfSICN5mJkqrcGR2/zynuil0m2W1/bOArsMROFMRsTysGdxras=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5d3e6274015so6005602a12.0
        for <patches@lists.linux.dev>; Sun, 12 Jan 2025 07:47:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736696860; x=1737301660;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HjyLEJ4LmDRPMeg7pmyVRbONKVM6G+SXKClWu3uonXY=;
        b=W5qXveGBU8ffXu9hDVUzq9bOjA0ppLRW3kY6ldiGytRp22FPR6wBpXiVF7KVTpVwQF
         vEMBxQ/2hoTOt9aMkZ7ic3tgx8P151EaqaIWV2kOGpMAA787XIyks/S8DmbDvvBsUv5d
         puVWoZS9q6y1aTU5v6Zx88TtlXtoK2OXJ0CbwlUnQGPy7dAqbKHtU+1nhPn/SChmNKhP
         0ODqm1hMYgBDcPngcIzB5ZDZdSrJGuMQJFot8/TTFBFwzIKQ0YKtcc/nU/UWwJgwaX2i
         sQRydXpqB1WGRf6Lm3+sdJ2Y86V4S1Kw+FAsXHKbAVD38tUlfmiyb1966fcUVQxZI2Qk
         wLwQ==
X-Forwarded-Encrypted: i=1; AJvYcCUgUxSEwuOZVrozf60ACpqmIKnpuzSmwiL59jq+By2MuNjRv4dvO3ekpGNYFHE0iZmFxAYs1G4X@lists.linux.dev
X-Gm-Message-State: AOJu0Yw+2MZK9MNUt15UuiTpZKIMf7Fy3t3tT29MNtClyTzx/XuH4cyO
	OTqtSMZDG8llSBR5J7eUUJdtvCsqyVN1Fl2DqIasMfrW1NaJCeRw30XHr4WACRA=
X-Gm-Gg: ASbGncvzXeLXKY1lMVzos35iJOqMYdzwW8paMzlNSBVEFLpFOW6/kFeuccISC+n4CJV
	fZU0OGppQEEpECX2kWImQo9iryvFKLr3iD2AVanjkmpFP434G/LmeaBMn0D88PPoyu6TYo7boNK
	0R1PtRPyrYTVVxkeBJL1VcORfPkNn/7zCbEm6GOEINvinFwHcqXHZ1/bYvCRweWnUU3z0xlhhqR
	rTsqmxpoCwIVgjSpzFmKhlTgkX3TwLPmqhZDvcJeCU3b86Q0LlDpfJSvb40fk++Yzhd3eF00Pw/
	oKvgR8enOgI=
X-Google-Smtp-Source: AGHT+IFI4/q/CfHhtBujk42NwOaeYoOBfc5KcuUOFxSXiKIZCKH8pDLvi0bexnWqfRlmiyRxHnSgxg==
X-Received: by 2002:a05:6402:4306:b0:5d0:c9e6:309d with SMTP id 4fb4d7f45d1cf-5d972dfe6a0mr16493431a12.1.1736696860329;
        Sun, 12 Jan 2025 07:47:40 -0800 (PST)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com. [209.85.218.42])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d99046a070sm3841376a12.59.2025.01.12.07.47.39
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jan 2025 07:47:39 -0800 (PST)
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-aaf57c2e0beso735441866b.3
        for <patches@lists.linux.dev>; Sun, 12 Jan 2025 07:47:39 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVbnaGVUgM3ksCsThtjsUEun2epkvbxUnbSHgoWUAqZzPkFyKklTmmQ80jRVrd2Uci4Ycd2qK+w@lists.linux.dev
X-Received: by 2002:a17:906:f58a:b0:aa6:b473:8500 with SMTP id
 a640c23a62f3a-ab2abcaafb9mr1563993366b.42.1736696859012; Sun, 12 Jan 2025
 07:47:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250112152946.761150-1-ojeda@kernel.org> <20250112152946.761150-4-ojeda@kernel.org>
In-Reply-To: <20250112152946.761150-4-ojeda@kernel.org>
From: Neal Gompa <neal@gompa.dev>
Date: Sun, 12 Jan 2025 10:47:02 -0500
X-Gmail-Original-Message-ID: <CAEg-Je-Knta8BtYSbZgX8cZ9Gd-2cpDAUE83dCJZbTbqmSfcKA@mail.gmail.com>
X-Gm-Features: AbW1kvY9sYe2UFYvoFMKHsHDuhdS2s-k0EW0KFNp10f0YtNTJge0UUivViciomU
Message-ID: <CAEg-Je-Knta8BtYSbZgX8cZ9Gd-2cpDAUE83dCJZbTbqmSfcKA@mail.gmail.com>
Subject: Re: [PATCH 3/3] docs: submitting-patches: clarify that signers may
 use their discretion on tags
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, workflows@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Sami Tolvanen <samitolvanen@google.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, tech-board@groups.linuxfoundation.org, 
	Steven Rostedt <rostedt@goodmis.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, 
	Shuah Khan <skhan@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 12, 2025 at 10:30=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> Tags are really appreciated by maintainers in general, since it means
> someone is willing to put their name on a commit, be it as a reviewer,
> tester, etc.
>
> However, signers (i.e. submitters carrying tags from previous versions
> and maintainers applying patches) may need to take or drop tags, on a
> case-by-case basis, for different reasons.
>
> Yet this is not explicitly spelled out in the documentation, thus there
> may be instances [1] where contributors may feel unwelcome.
>
> Thus, to clarify, state this clearly.
>
> Link: https://lore.kernel.org/rust-for-linux/CAEg-Je-h4NitWb2ErFGCOqt0KQf=
XuyKWLhpnNHCdRzZdxi018Q@mail.gmail.com/ [1]
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Acked-by: Shuah Khan <skhan@linuxfoundation.org>
> Acked-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  Documentation/process/submitting-patches.rst | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/Documentation/process/submitting-patches.rst b/Documentation=
/process/submitting-patches.rst
> index 7b0ac7370cb1..6754bc15f989 100644
> --- a/Documentation/process/submitting-patches.rst
> +++ b/Documentation/process/submitting-patches.rst
> @@ -614,6 +614,10 @@ process nor the requirement to Cc: stable@vger.kerne=
l.org on all stable
>  patch candidates. For more information, please read
>  Documentation/process/stable-kernel-rules.rst.
>
> +Finally, while providing tags is welcome and typically very appreciated,=
 please
> +note that signers (i.e. submitters and maintainers) may use their discre=
tion in
> +applying offered tags.
> +
>  .. _the_canonical_patch_format:
>
>  The canonical patch format
> --
> 2.48.0
>

A tag must not be dropped without the tag submitter's authorization.
Otherwise it doesn't matter what you write here, the submitter *will*
feel unwelcome.

It is rude and discouraging to do so without their acceptance of doing so.


--=20
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!
