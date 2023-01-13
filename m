Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17DA627
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 23:13:16 +0000 (UTC)
Received: by mail-yb1-f182.google.com with SMTP id 203so24145025yby.10
        for <patches@lists.linux.dev>; Fri, 13 Jan 2023 15:13:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=q6fjwFARDZpPxSIIIp1tFOycB9wl1pphbajvby7rx9s=;
        b=n5a3CaKEcj5VYNkID/sozPmUYqTpPAJeD+VL/ZpwAP/hLzaTNm47kX6XjMwYYa5rI+
         Zxl/2B/jyvSg/xiP+T9dw+MMkK/av9LiXPvq0U2FTvI27LLAuM4zog/Asf7rmdJD3RJp
         9xMGAzig24loJnaqcw+yBuQYqrwFkiERy/HYjsEkcd0UFh1mawt2AnMTxUq6AdTIU/5c
         r7q30QM1WD3jhFTidzev453cuwMpZcKrKdE/jKgZNwQ6SOR1hNfQ68gz8fh7+PugjUMo
         Wipl7XEeyS5Y7c3gFxs5RfZ++Pd0Gab575mEr/jg2LdKPUsqNKYsqvc09giFQYRgbVNm
         OC6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q6fjwFARDZpPxSIIIp1tFOycB9wl1pphbajvby7rx9s=;
        b=y0BUgwtyt8vURLFwAS3KQiShXlGA9uPxt4ZBdzh+5wTTjGTwskINv+p9qahqxWsHvG
         zenagMqiDJmL12uJg9/2s1+dLgCw+bG0zipecASXO9lMFQO0XycoR20bOtLKDPMsaAZG
         xGZzIJ5sz/Bmkm0jbSOko6TAfOvq7+1VGJEgqQppVEEaEKhlnUjBVHZ91wbO8slXL9Ne
         ytS3yJsVbpVrEBSXhKIv14G3ns/0ElZJYcwWD67yKwUYxet3WmXJj9/mNmT97rfC5P1y
         4c8UW7WRhtOI9cQsfUbi94czw07kv550tA7YadV19eDaVe7ME2t4B56Wf12xe2tvGfEF
         C4Vw==
X-Gm-Message-State: AFqh2kpsoqsffKt1aFlGwH+EsYc1oL3i20uu12kPeiNbf5gUm5/9+/Z9
	jPzfBrBm6uxCdsaiD5VYsR7jzplIoEdIg/KAPXw=
X-Google-Smtp-Source: AMrXdXvoTnn8SvkX6vZq37n4LxAUyWFzoyi5yBE3W0VJpCla3kdj2cETTQMc/PmuTAwpfi51GTfwJM3siTKFcxcg1sI=
X-Received: by 2002:a25:1004:0:b0:712:faac:e6b2 with SMTP id
 4-20020a251004000000b00712faace6b2mr8662761ybq.632.1673651595940; Fri, 13 Jan
 2023 15:13:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230109204520.539080-1-ojeda@kernel.org> <CANiq72m_+xJYUxrwFc7vNLkuOb6zC-W-wDzXjbPb8Ursqzwiaw@mail.gmail.com>
 <CAK7LNATmRkSU2n6AaeJenE-18gbUd4ZShFNfKysEjyCo4Q-eAA@mail.gmail.com>
In-Reply-To: <CAK7LNATmRkSU2n6AaeJenE-18gbUd4ZShFNfKysEjyCo4Q-eAA@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 14 Jan 2023 00:13:04 +0100
Message-ID: <CANiq72=G0P-XZ6Kn2XYFwbSdqG7Yh4f5zgAr-fn+85QJCMRZUA@mail.gmail.com>
Subject: Re: [PATCH 1/6] docs: rust: add paragraph about finding a suitable `libclang`
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, linux-kbuild@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Nicolas Schier <nicolas@fjasle.eu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 12, 2023 at 7:05 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> Yes, I can take this, but the doc change
> is independent of the rest, and will not conflict with
> any Kbuild changes.
>
> So, you can apply this one to your tree.

The doc change is not fully independent: this patch is first because
the next commit uses the fact that the documentation is written (to
point the user to it), and the commit message mentions this.

Not a big deal, but it would look better if all are in at once.

Cheers,
Miguel
