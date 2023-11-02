Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B4D442D
	for <patches@lists.linux.dev>; Thu,  2 Nov 2023 07:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bbQV4n58"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-9d23be183c6so89779566b.0
        for <patches@lists.linux.dev>; Thu, 02 Nov 2023 00:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1698908589; x=1699513389; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=V3nhXdUPcKAOv9+XK9xkbhx4vVS0XEkJFjF8wpYBYas=;
        b=bbQV4n58+l5dKU8FG1LEF3VG2BRg5d5Izq9Yki2DBFpndScnA5EAYZGVcCsXBPq9e7
         TeQaQzJ7h44C0corvqcFmE0VrEMXGMponmjTFnay5bpRWpSEt0QVsxjh+FKcMWyYWMrP
         bzhA5OlmkZYZBSysPQdXITBfYl+hEf0TogiOQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698908589; x=1699513389;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V3nhXdUPcKAOv9+XK9xkbhx4vVS0XEkJFjF8wpYBYas=;
        b=iMx2FCpFe4mVXNLKSsSZYUDG/D/WsI2y1mtHRYwNEFx3+gWhUw7JRKcHVBZAQV4YCC
         oF8e7AXJa2pFvQT4K2TK7oY6v2vYlBY8f9Mq1jpfl37HjC37uAyp5s0oKs6s+A6sv6Bi
         5sQUa3cnVFNEHoeyu/jop5WaKIUsh8vOIlfU6DxgIfk5OBX0atbcJeDPthDhxo2uSONp
         USHO559NuivEAG/zqR/hrSIEfr5jvwIxPoPlHQMu5TACkmWQjjR9V7voLy4ixPngqLR7
         cd0t4GK5gMBR2yHZVrH6f3RvK3O/r6/8r7Vp36XWtjV8DMotDl9SxiQiWx+DRFrcRZc+
         okbQ==
X-Gm-Message-State: AOJu0YwrkEupqP1Gtedhce39A/a4GSBOYeXTsKdbwCbwn1jZhOatFd1k
	HikSLXN1apLR6NixkzU6X1cTDyVM/BzNQU17+barO2ub
X-Google-Smtp-Source: AGHT+IHOW83En9VruF2Z+wOclE/WpHyGiXjrgaitFaAYi7T19wTTN8WMXwk2gsB+uKNr1REAnnTRog==
X-Received: by 2002:a17:906:fd81:b0:9be:bf31:335b with SMTP id xa1-20020a170906fd8100b009bebf31335bmr3501532ejb.73.1698908589402;
        Thu, 02 Nov 2023 00:03:09 -0700 (PDT)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com. [209.85.218.46])
        by smtp.gmail.com with ESMTPSA id re20-20020a170906d8d400b009cc1227f443sm756361ejb.104.2023.11.02.00.03.08
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Nov 2023 00:03:08 -0700 (PDT)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-9d23be183c6so89776166b.0
        for <patches@lists.linux.dev>; Thu, 02 Nov 2023 00:03:08 -0700 (PDT)
X-Received: by 2002:a17:906:4fc8:b0:9bd:ac0f:83dc with SMTP id
 i8-20020a1709064fc800b009bdac0f83dcmr3363405ejw.54.1698908588450; Thu, 02 Nov
 2023 00:03:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZUKxT1CL9/0Dn6NE@bombadil.infradead.org>
In-Reply-To: <ZUKxT1CL9/0Dn6NE@bombadil.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 1 Nov 2023 21:02:51 -1000
X-Gmail-Original-Message-ID: <CAHk-=whFXNYXG2ES8HdoaMC=O4bakMXGZezmoqA3SXwn4xJUPQ@mail.gmail.com>
Message-ID: <CAHk-=whFXNYXG2ES8HdoaMC=O4bakMXGZezmoqA3SXwn4xJUPQ@mail.gmail.com>
Subject: Re: [GIT PULL] Modules changes for v6.7-rc1
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: linux-modules@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, andrea.righi@canonical.com, 
	keescook@chromium.org, zhumao001@208suo.com, yangtiezhu@loongson.cn, 
	ojeda@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 1 Nov 2023 at 10:13, Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> The only thing worth highligthing is that gzip moves to use vmalloc() instead of
> kmalloc just as we had a fix for this for zstd on v6.6-rc1.

Actually, that's almost certainly entirely the wrong thing to do.

Unless you *know* that the allocation is large, you shouldn't use
vmalloc(). And since kmalloc() has worked fine, you most definitely
don't know that.

So we have 'kvmalloc()' *exactly* for this reason, which is a "use
kmalloc, unless that is too small, then use vmalloc".

kmalloc() isn't just about "use physically contiguous allocations".
It's also more memory-efficient, and a *lot* faster than vmalloc(),
which has to play VM tricks.

So this "just switch to vmalloc()" is entirely wrong.

              Linus
