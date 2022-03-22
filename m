Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1AB6465
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 22:13:30 +0000 (UTC)
Received: by mail-lj1-f170.google.com with SMTP id 25so25850870ljv.10
        for <patches@lists.linux.dev>; Tue, 22 Mar 2022 15:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/JqUw7N0pQiYUGggfB1gLbjw37OlSObKornAcIsuE/w=;
        b=Pew1K7y3CpT1ghIeP6zNXgjqkgvlgq8GZ1eq5rwdB0TuKxLXxor0+ZVnKofKj/65cq
         oPtdFrkuNCC3crgTsACxwEy5zACBzm/eMnJg9RR8mpjJEzWJ3Ga1YUdGzrlkeM8D/fX7
         Fig4PvN6JpjdY+i/+N2spp17GKwsylL5WTl0Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/JqUw7N0pQiYUGggfB1gLbjw37OlSObKornAcIsuE/w=;
        b=dA8yGdHqu1rE1NohSWG5UHF7xXX3rQ2F9V96KzA0OHx91VKaXQ7jvbkRXOrFYqnR9U
         oEiXlwr0uGru/1C+IxTw68cWBbLrF1ufHD6snNPkp1DGNEgOaIOe2ZItne37UHMWH+ux
         0bZ78ObE52IrsU8sLWohDQnpIUQizX/HqzkXE5MPIEdy+O6D/Z3NdbgV4iapDlvWW3W7
         UIE3wA/wpQhCrvl+ca5stnnP72XendpISbqwsZo1KpbtRLvR3PCZpBY3+jB8//99pLt7
         7srQistfMieCGvef3NGFiPmwhIeSCl+NN5+pOT6mkFVuW6WHD5S42Sj93IME0/8PWuh8
         bXcw==
X-Gm-Message-State: AOAM531KRpXdXiQsUctcayO8Y5H2XpA6Upx+N/6rGgCAjwugOSPRo6nv
	IO84E5sI7fiaGhpuPzC3pJ2hTdBQZUrx1atZ1mM=
X-Google-Smtp-Source: ABdhPJx7+fJmDsy7FxWY2Pcat1dRacKt1LxtvNQAOmX+fXYIIHHJ8HGbkmA9EwOdEdqA0zcq8mHxAA==
X-Received: by 2002:a2e:54d:0:b0:249:8213:f970 with SMTP id 74-20020a2e054d000000b002498213f970mr10247676ljf.315.1647987207855;
        Tue, 22 Mar 2022 15:13:27 -0700 (PDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id m24-20020a194358000000b0044a3851f193sm480693lfj.83.2022.03.22.15.13.26
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 15:13:26 -0700 (PDT)
Received: by mail-lf1-f53.google.com with SMTP id m3so20143841lfj.11
        for <patches@lists.linux.dev>; Tue, 22 Mar 2022 15:13:26 -0700 (PDT)
X-Received: by 2002:a19:e048:0:b0:448:2caa:7ed2 with SMTP id
 g8-20020a19e048000000b004482caa7ed2mr20018350lfj.449.1647987206418; Tue, 22
 Mar 2022 15:13:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org> <20220322213840.3117DC340F4@smtp.kernel.org>
In-Reply-To: <20220322213840.3117DC340F4@smtp.kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 22 Mar 2022 15:13:10 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjn_YUDEhaSdNdU2nBJowDT3enKYR1w+HiAy_srvJN1nw@mail.gmail.com>
Message-ID: <CAHk-=wjn_YUDEhaSdNdU2nBJowDT3enKYR1w+HiAy_srvJN1nw@mail.gmail.com>
Subject: Re: [patch 003/227] ntfs: add sanity check on allocation size
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Altaparmakov <anton@tuxera.com>, mudongliangabcd@gmail.com, patches@lists.linux.dev, 
	Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Mar 22, 2022 at 2:38 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> From: Dongliang Mu <mudongliangabcd@gmail.com>
> Subject: ntfs: add sanity check on allocation size
>
> ntfs_read_inode_mount invokes ntfs_malloc_nofs with zero allocation size.
> It triggers one BUG in the __ntfs_malloc function.

Hmm. A more serious issue seems to be that cast to (u32).

ntfs_attr_size(a) returns a 's64', so it just randomly truncates a
possibly bad value..

               Linus
