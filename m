Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D173DF40
	for <patches@lists.linux.dev>; Wed,  3 May 2023 18:29:30 +0000 (UTC)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-959a3e2dd27so1060293366b.3
        for <patches@lists.linux.dev>; Wed, 03 May 2023 11:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1683138569; x=1685730569;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LKqR2DGNy5P181vP5/oL8+jtEnGqbzk0DswhgBhpOjQ=;
        b=HciNp/FGShU3XLMHkn7wGXlmK30tWNxdf/jCPLCXq4pY8MI65Hl8J9H5wvJfFOHpfQ
         kjnZRQHG8TpEy8p9H9H+8VQPH8CUHAAY0wA0E7hKovXOGv8Yii5LT9WBpSw1Eu8/hh/5
         Tk4QpvHqtR1iYuRtJyPD0VZIahvjQjDsfaFTM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683138569; x=1685730569;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LKqR2DGNy5P181vP5/oL8+jtEnGqbzk0DswhgBhpOjQ=;
        b=Vb5HDuPocCa02jmH/kigmLUa6iCgDyYBLmITXyoAz5St4DAjmmgKTju4mY59xLSPOD
         +Zi94Chls8qe5TtmGJmWXsP4olHMhkHZMdrk1LBXKPkUKXQPb/XvVkk023heZUVn9NdO
         W7GfYb9W9JuWByYpeIuHEGxWgpAYJg0WdzMOL+zD18yg8tSLKC/ma8Hkmd5bA7DK0C+Z
         t+FF8vIv4TP3E+4oZgL8sCsKa2n+FIAif1uV44P+ratb1N741wyRmB/dZU8WHphmvLAb
         UfDpIno2swApv8pTDPoGcLemC6bvJ0CKUp859stbVtM5OP864gioAc3SPc7IzPasSSFj
         rAMQ==
X-Gm-Message-State: AC+VfDxmXHNm2k7+YtKt7TPsalAwj5aIV2P54/JQtqrXrEEAhs+7DcE+
	5Oj1CkkLd9jc40C339VdU1PCy6Hkn0aNQw75ig8fnA==
X-Google-Smtp-Source: ACHHUZ7yVX1xfNujRSL2o1Ya6LFA+1nGDY0pqzLDb6oWGGazeQTKWkIu1nI+nXaUvko8XFc7ixqqig==
X-Received: by 2002:a17:907:a427:b0:94f:4a87:7a77 with SMTP id sg39-20020a170907a42700b0094f4a877a77mr4644099ejc.36.1683138569151;
        Wed, 03 May 2023 11:29:29 -0700 (PDT)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id b21-20020a170906151500b0094edd8e38fasm17576003ejd.76.2023.05.03.11.29.27
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 May 2023 11:29:27 -0700 (PDT)
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-50bc070c557so8972025a12.0
        for <patches@lists.linux.dev>; Wed, 03 May 2023 11:29:27 -0700 (PDT)
X-Received: by 2002:a17:907:74d:b0:94f:250b:2536 with SMTP id
 xc13-20020a170907074d00b0094f250b2536mr3524559ejb.28.1683138566776; Wed, 03
 May 2023 11:29:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230503023329.752123-1-mcgrof@kernel.org> <ZFKKpQdx4nO8gWUT@bombadil.infradead.org>
In-Reply-To: <ZFKKpQdx4nO8gWUT@bombadil.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 May 2023 11:29:10 -0700
X-Gmail-Original-Message-ID: <CAHk-=whGT-jpLRH_W+k-WP=VghAVa7wRfULg=KWhpxiVofsn0Q@mail.gmail.com>
Message-ID: <CAHk-=whGT-jpLRH_W+k-WP=VghAVa7wRfULg=KWhpxiVofsn0Q@mail.gmail.com>
Subject: Re: [PATCH 0/2] sysctl: death to register_sysctl_paths()
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: ebiederm@xmission.com, keescook@chromium.org, yzaikin@google.com, 
	j.granados@samsung.com, patches@lists.linux.dev, ebiggers@kernel.org, 
	jeffxu@google.com, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 3, 2023 at 9:24=E2=80=AFAM Luis Chamberlain <mcgrof@kernel.org>=
 wrote:
>
> On Tue, May 02, 2023 at 07:33:27PM -0700, Luis Chamberlain wrote:
> > You can give it a day for a warm fuzzy build test result.
>
> 0-day gives its blessings.

Well, it's not like I can pull anyway, since you didn't actually say
where to pull *from*. And I don't want to randomly apply patches when
I know you have a git tree for this.

So please do a proper pull request.

              Linus
