Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE5B23BE
	for <patches@lists.linux.dev>; Tue, 27 Sep 2022 14:06:54 +0000 (UTC)
Received: by mail-il1-f173.google.com with SMTP id i16so5165285ilq.0
        for <patches@lists.linux.dev>; Tue, 27 Sep 2022 07:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=08FYPXF8NGV3I7f8HvvukPdlDJ2mobJpfZ4nRRDrtDs=;
        b=b6TVXxWSSs1wWwgyy76IisEm+bMUWZ/TZVqBW0IiwdaKjq1GvfK4WvX0uioXtu2Hs3
         jcf/7ASYzYYGjL6N1NOc5gzJbhcbPXgiIpLgwYqW868sFRLRPVM6/+k64STgGvPwJUew
         W9D1rzvOyRhdq6qvOoo4l+TQhxonD+mm0Tmi89kwo2eBCe1tBmw5oSnGlOZ0+03lwIqh
         UWG5nRt7SlGk/zMWRiNvqo4hOtRSMoXiKKmuQuQA/I2I6ZhsS1naaE54ERdmVXQLa3Kt
         LpqxHrraYDNE+qytp1tQoK+LfPJPeUxJG720eFeQevCd3+3SR0yrd/vkxJRqWRuRvrkX
         XJTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=08FYPXF8NGV3I7f8HvvukPdlDJ2mobJpfZ4nRRDrtDs=;
        b=xWZEXDGRo7R9iqaO/R+E3VSF69YVInBoUvG2870xqizf2SokDYZtlLoTGGZnefD3H5
         7rLaKvwZBZRHpWycS5VgxmJg8a8ckepy0AI1pm8RYtXjMn1tbG0VarggeibNaX4iHrLE
         jFRfgZKRtmRHAYSo7UFCdH52FPsrhd8/VHTbywtBnuig9nttJW8oO2zf6udyoXOCRdME
         55J/VUcwnJv/pXkz8z9WCx+ap04kkp6nNwiOACb6h/MyRBO4l3EFiajzTk51/0hp/3tg
         7VqgeSpRVmW/M75eZKhNiArt1aORuA8I/dX0xx9U/q1USmsnX0pHHxxSDJZOjL7d+i/+
         iMaw==
X-Gm-Message-State: ACrzQf1B2oL+nReTUbwHgWdXX0etUuQ2sV+AEbSvkJ832Xb2ZRUNNrJ1
	fZGAzxoUMyQHNRp8Lfiqi9JllEsBJ4wC3T3mpdA=
X-Google-Smtp-Source: AMsMyM5syx+SHzekoKk5qqoxYITfSS3Xf+tq/gzESB0d3rgzZ2K4BALmcjzwKNLccON5ri7Ug7BCkO3JsxrTkg8RzqI=
X-Received: by 2002:a05:6e02:188f:b0:2f8:993:e7ba with SMTP id
 o15-20020a056e02188f00b002f80993e7bamr7861514ilu.321.1664287614225; Tue, 27
 Sep 2022 07:06:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220927131518.30000-1-ojeda@kernel.org> <20220927131518.30000-9-ojeda@kernel.org>
 <YzL/9mlOHemaey2n@yadro.com>
In-Reply-To: <YzL/9mlOHemaey2n@yadro.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 27 Sep 2022 16:06:43 +0200
Message-ID: <CANiq72kDPMKd0qLAMVrd2A3n9aAWhh2ps5DvKos58L=_V2-XwQ@mail.gmail.com>
Subject: Re: [PATCH v10 08/27] rust: adapt `alloc` crate to the kernel
To: Konstantin Shelekhin <k.shelekhin@yadro.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	patches@lists.linux.dev, Jarkko Sakkinen <jarkko@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@google.com>, Gary Guo <gary@garyguo.net>, 
	Matthew Bakhtiari <dev@mtbk.me>, Boqun Feng <boqun.feng@gmail.com>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Sep 27, 2022 at 3:52 PM Konstantin Shelekhin
<k.shelekhin@yadro.com> wrote:
>
> Not being able to pass GFP flags here kinda limits the scope of Rust in
> kernel. I think that it must be supported in the final version that gets
> in.

Flags will be supported one way or the other in the future, but I was
requested to do v10 as a v9 with the last nits resolved.

Please see the cover letter for details.

Cheers,
Miguel
