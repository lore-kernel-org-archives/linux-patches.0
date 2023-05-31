Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B7217736
	for <patches@lists.linux.dev>; Wed, 31 May 2023 17:02:47 +0000 (UTC)
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-ba81ded8d3eso8622207276.3
        for <patches@lists.linux.dev>; Wed, 31 May 2023 10:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685552567; x=1688144567;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FG1P2Nrcljeuk69DDeSeiYWvgO1FehBAcRPCmpA4UwQ=;
        b=KlobxtPFR6Ysp6yLDDnsHdfCA0ZYPKNHo639LUMZ8h+NKMw0AsLGQl9DxnfOQw3e2t
         TW2uqDVYIRr0NxB3TR0TLq4VHjzTZ0HR3uHJAGfjZExu4a5dorYiPmSUjUvuoFKU7z/J
         t//fDhFcLuZPmABgOLGTQKaVsua0XCepxrlXFzi9hpozGaqft4xdSGZ6aNannGoClQAB
         10vOsoWQAIYyMThwcBP4OrElZ1n05Ldic5W1Iih18/jNZlpIZAt0LTjSdhQyMZaapc4l
         ceK3f8R6DEoIA0bK3GiIKjUikG7cJQPIsFdzVl6Ic8HEGO1DP6TatppQRwHS3uRnj7Qx
         GLfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685552567; x=1688144567;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FG1P2Nrcljeuk69DDeSeiYWvgO1FehBAcRPCmpA4UwQ=;
        b=ACSGtCMDsL6ZHbh5pQX6tmQGLDuYgHdWXMszhiHfWuEajJjG8TfoVaNvZTfc8Fji3T
         bDAiqpREXZm10ALz48tz34KWZXMnnAgeU1NdbEcw+2lfNJ9968b4/EmiZIxuqJy2tV13
         aShy64j0+OmUzo5iZvX90GEjRRARFXl0zi3g7nNio3QZf2U51nA34c9eB2ftQauytWMz
         MA6upJLlOoLyrIsc0e7b64v4ez1/Dc35uvIieR/oXlHJOGdukGgGYTPWAyypivsfkWtO
         w+1pnsKb7vlbf1c3LxvpuopfEwYwrwqtTzxYK/zIWOiAMn63LoyV1ajyoWlKNOPd7w1E
         F34Q==
X-Gm-Message-State: AC+VfDyjGwoiP5xXMmatzh+slNDGlDWSEDecHc+zj5F16fM32gxsGQl5
	3xNiB7DLMifsVdGB1BilgL5WNjyXcEAN0EhzveM=
X-Google-Smtp-Source: ACHHUZ4wotzWkEI82wv2kvB1VEZ7nfcFE3vwSgsGw2wq4N9wemD12VZl2B9p3aWRiZZKlqFF5jUFl1vMDSV2L10Ic7Y=
X-Received: by 2002:a25:1982:0:b0:ba8:313c:6bec with SMTP id
 124-20020a251982000000b00ba8313c6becmr6517049ybz.0.1685552566699; Wed, 31 May
 2023 10:02:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230418214347.324156-4-ojeda@kernel.org> <20230419030243.540348-1-yakoyoku@gmail.com>
In-Reply-To: <20230419030243.540348-1-yakoyoku@gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 31 May 2023 19:02:35 +0200
Message-ID: <CANiq72knVpyaKdT2iwrBNYorAt3Y5M-r6pXHc9JAZRCVmBYusQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] rust: upgrade to Rust 1.68.2
To: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Cc: ojeda@kernel.org, alex.gaynor@gmail.com, benno.lossin@proton.me, 
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, gary@garyguo.net, 
	gyakovlev@gentoo.org, jan.steffens@gmail.com, jistone@redhat.com, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	rust-for-linux@vger.kernel.org, wedsonaf@gmail.com, william.brown@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 19, 2023 at 5:02=E2=80=AFAM Martin Rodriguez Reboredo
<yakoyoku@gmail.com> wrote:
>
> Kinda bunch to review, although may I ask if each time the `alloc`
> crate is updated is worth to mention the changes upon it [1], can be
> skipped otherwise.
>
> Link: https://github.com/rust-lang/rust/commits/master/library/alloc [1]

That could be nice if we could give a link similar to, say, what:

    git log 1.62.0..1.68.2 -- library/alloc/src/

produces (or perhaps a list of PRs) -- is it possible to do so with a
GitHub URL? If so, please let me know!

Cheers,
Miguel
