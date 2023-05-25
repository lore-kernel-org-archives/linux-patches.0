Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BAC4101DA
	for <patches@lists.linux.dev>; Thu, 25 May 2023 17:53:18 +0000 (UTC)
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-513fd8cc029so4948980a12.3
        for <patches@lists.linux.dev>; Thu, 25 May 2023 10:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1685037196; x=1687629196;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cki7nTSfn8V9Pz9bjx+wUZ3Q24K9M6RV4kOzAoI4Ezk=;
        b=D6d6iUjkz46uF5lcM4xKnjVBYMFgwmzQC2Gv7q7jtoXAmTPH31SoeNZ0EYsFNq1HCL
         FHpt6Dqayp7iUP4uroXvnZ9Te7yirPRkuvgSsmVXAi+VukHYxVB1yXCM7U/snsD/n8G+
         YDlUCHjvQ7SUxSCmocrK/cFYALfbBFxqZRtjQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685037196; x=1687629196;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cki7nTSfn8V9Pz9bjx+wUZ3Q24K9M6RV4kOzAoI4Ezk=;
        b=I8rwDgAwMnNeeoeaQDRL+mcYj5yaaeJIYjNB4lTEvvcMkRMIOCzp+2B3ZRi4MItOf4
         QnzZxFefyW6jN0+3lapc07MFjVWv5CEh3mCdWjp4V1gEGxUB2GTt7T2eXT1cfARmGX7g
         f/caUmDObO1+Dw1T8IU82/aeFCVilUQHXGugse9oIWxAOJv6SGTtBTFy/euk0T5KyhIK
         Rrv21EpAMy3U9ds+5dIGttJ8WnNEKPU5m/x0f1MbWHiX9hlcE1BySGj11k/VC6YFJTuQ
         VdvzUfM5EyBv8SUUsK1VmldpHuDw4J4s5Dlc35AwLaAb68Y9nJ2rpsiQys0elh3X3CYy
         B+zA==
X-Gm-Message-State: AC+VfDy+CsAieftgNaGNB/Qcg8JzBXO51aakR6s5yfX82SGlE3ME79EC
	A0QqX9msiFNVZ9ECPpw7X/3vVa5IciS07QzbdP+7AuN8
X-Google-Smtp-Source: ACHHUZ51Yj16G6RLQV2xVPeDWLsTF3FNPZcQYnR6yEtl5DTS2z5E/Mt4PBbPYUkzepVocjfAQGQ0vg==
X-Received: by 2002:a17:907:9493:b0:965:fa80:bf1 with SMTP id dm19-20020a170907949300b00965fa800bf1mr2195907ejc.32.1685037196354;
        Thu, 25 May 2023 10:53:16 -0700 (PDT)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id mj22-20020a170906af9600b00971433ed5fesm1110913ejb.184.2023.05.25.10.53.15
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 May 2023 10:53:16 -0700 (PDT)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-51426347bd2so3906323a12.2
        for <patches@lists.linux.dev>; Thu, 25 May 2023 10:53:15 -0700 (PDT)
X-Received: by 2002:a17:907:9493:b0:965:fa80:bf1 with SMTP id
 dm19-20020a170907949300b00965fa800bf1mr2195225ejc.32.1685037174582; Thu, 25
 May 2023 10:52:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230524213620.3509138-1-mcgrof@kernel.org> <20230524213620.3509138-3-mcgrof@kernel.org>
 <8fc5b26b-d2f6-0c8f-34a1-af085dbef155@suse.com> <CAHk-=wiPjcPL_50WRWOi-Fmi9TYO6yp_oj63a_N84FzG-rxGKQ@mail.gmail.com>
In-Reply-To: <CAHk-=wiPjcPL_50WRWOi-Fmi9TYO6yp_oj63a_N84FzG-rxGKQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 25 May 2023 10:52:37 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjWeV-ct7pFvBF6m1gzbqdp_K7nQe=++Ov029g6Fc3dsg@mail.gmail.com>
Message-ID: <CAHk-=wjWeV-ct7pFvBF6m1gzbqdp_K7nQe=++Ov029g6Fc3dsg@mail.gmail.com>
Subject: Re: [PATCH 2/2] module: add support to avoid duplicates early on load
To: Petr Pavlu <petr.pavlu@suse.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, gregkh@linuxfoundation.org, rafael@kernel.org, 
	song@kernel.org, lucas.de.marchi@gmail.com, lucas.demarchi@intel.com, 
	christophe.leroy@csgroup.eu, peterz@infradead.org, rppt@kernel.org, 
	dave@stgolabs.net, willy@infradead.org, vbabka@suse.cz, mhocko@suse.com, 
	dave.hansen@linux.intel.com, colin.i.king@gmail.com, jim.cromie@gmail.com, 
	catalin.marinas@arm.com, jbaron@akamai.com, rick.p.edgecombe@intel.com, 
	yujie.liu@intel.com, david@redhat.com, tglx@linutronix.de, hch@lst.de, 
	patches@lists.linux.dev, linux-modules@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, pmladek@suse.com, prarit@redhat.com, 
	lennart@poettering.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 25, 2023 at 9:07=E2=80=AFAM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> That said, I posted an alternate patch that I think _is_ valid as that
> quick hack. I don't love it, but it sure is simpler (and avoids the
> i_ino bug):
>
>     https://lore.kernel.org/lkml/CAHk-=3DwgKu=3DtJf1bm_dtme4Hde4zTB=3D_7E=
dgR8avsDRK4_jD+uA@mail.gmail.com/
>
> that patch hasn't seen any testing, and for all I know it won't even
> boot because of some thinko, but I think it would be acceptable as a
> workaround if it does work.

Well, it boots here, so it must be perfect.

That said, I didn't add any debugging code, and I didn't test it on
any odd setups, and I've never had any problems before. So I don't
actually know if the patch *does* anything.

But it did boot..

               Linus
