Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8FC1640F
	for <patches@lists.linux.dev>; Wed, 31 May 2023 21:31:05 +0000 (UTC)
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-ba81f71dfefso101221276.0
        for <patches@lists.linux.dev>; Wed, 31 May 2023 14:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685568665; x=1688160665;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3qbtUs9ndxd3DZRGurVSS0a+crEkg2YIykbFZmkROUY=;
        b=FaD+YPSqNsZY/mGSAAERnzZe1f2X33jjBoiDb+rH4NSczlyBLiZXKo2Qnn+2BKWWjm
         jAPpgAXMav1WJQUJYY1TVFPKggA/4pXXSlxATfA2WpTmFR2+AN/t00m28ai2DunyRoxk
         +nt549zpGxdeyExkhr457WFgTCMik9qkgFyjMzJ9yVSolvHfimxS+QzxXnSWzef4aPvM
         wdEYfKPVQN0ilYkx2csygwReFSUjwGdHf1cEhVwcaDG2QaHbcqZzJc6lF9TQ/M0ypSBz
         2aL0L7OuiZKD2r7QGnp/9EVDWb6PsR5tAnldMmEtLlO7MP18fDXJgX11XBDsmbW3i6Ai
         i7oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685568665; x=1688160665;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3qbtUs9ndxd3DZRGurVSS0a+crEkg2YIykbFZmkROUY=;
        b=DVPpqqvS7CAJK0/DU5xtU8r0YNVktSyA47pDu07pJQfV2GHn5HJpyN3byj62ThXXLN
         HDPZLjykDZr3feZW/Lo8yhOswzJ8U0L9HB4W9CT9S8tpwOqDdOAmfyhEA3MNCftyammE
         +wQ6qZj4W4tBCCf3xOOsvdhnE542LHfA2xrcP0XV9Xt+NCSYlPmAkiNEkXu81wzFNFCx
         UcKsNmpWS38YrdE3Aha0S5Me/GJezx3WCA3nW8tLzkClcU0WquibBkFBKFolNkF3pKFV
         abTaEQ98o/srH9mbRlwRzqad872NAF4gVXks9RVItGjp2TlCHsNzpo7HQkhyfhR5xy+3
         rV5w==
X-Gm-Message-State: AC+VfDyd77QDRaQe9GCerDISCmFv1GllGWpYtGXbRLGk9fFoKF8RiWt6
	6C/5vHZMJjSXpvPl2ODXM/pttulW32h1mQfvjyI=
X-Google-Smtp-Source: ACHHUZ6ujjbi0ShQS7ASNw1bhHvEiNCLTRsHW0EEGz+/LG1Ttic9lcyt7OE5oEvg/mvDfWhqz9p4zHaFpSLA7EMnmcA=
X-Received: by 2002:a25:df87:0:b0:bac:7621:84d4 with SMTP id
 w129-20020a25df87000000b00bac762184d4mr8791481ybg.19.1685568664934; Wed, 31
 May 2023 14:31:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230418214347.324156-4-ojeda@kernel.org> <20230419030243.540348-1-yakoyoku@gmail.com>
 <CANiq72knVpyaKdT2iwrBNYorAt3Y5M-r6pXHc9JAZRCVmBYusQ@mail.gmail.com> <22ac8a99-d243-c537-41c7-ff2c5e69d28f@gmail.com>
In-Reply-To: <22ac8a99-d243-c537-41c7-ff2c5e69d28f@gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 31 May 2023 23:30:53 +0200
Message-ID: <CANiq72nm8DQECm0CRjCSyzjPQK+z44_LHpanjTVv9mWRvYqVPw@mail.gmail.com>
Subject: Re: [PATCH 3/3] rust: upgrade to Rust 1.68.2
To: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Cc: ojeda@kernel.org, alex.gaynor@gmail.com, benno.lossin@proton.me, 
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, gary@garyguo.net, 
	gyakovlev@gentoo.org, jan.steffens@gmail.com, jistone@redhat.com, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	rust-for-linux@vger.kernel.org, wedsonaf@gmail.com, william.brown@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 31, 2023 at 9:48=E2=80=AFPM Martin Rodriguez Reboredo
<yakoyoku@gmail.com> wrote:
>
> It seems that kind of URL comparisons in GitHub aren't supported yet
> per the docs say [1]. Sad but maybe in the future they are going to be
> supported, or at least I hope GitLab or Gitea do it.
>
> Link: https://docs.github.com/en/pull-requests/committing-changes-to-your=
-project/viewing-and-comparing-commits/comparing-commits [1]

Thanks! There is also "comparing releases" [1], but it does not seem
to allow to restrict to a folder... :(

A dedicated view where one could navigate everything between two
points (or at least two releases), including PRs, content diff,
commits, closed issues, etc.; and being able to restrict it to
particular folders would be great.

[1] https://docs.github.com/en/repositories/releasing-projects-on-github/co=
mparing-releases

Cheers,
Miguel
