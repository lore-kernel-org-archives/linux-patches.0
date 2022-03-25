Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8824690
	for <patches@lists.linux.dev>; Fri, 25 Mar 2022 02:04:54 +0000 (UTC)
Received: by mail-ej1-f46.google.com with SMTP id qa43so12627807ejc.12
        for <patches@lists.linux.dev>; Thu, 24 Mar 2022 19:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ngtVr9tesRrH3h9QuJdwsRWwUqV+lCc3sEv7bM/pFPs=;
        b=S6nDFjuC5irly55Lifc9R62XBYSxZJDRmTi0DdDbogM1HSiCQm+1qbdjfGbyF021eP
         fEF2cncLSM88eWWsLKedyC+Z2HLojh7NeGRv6ZfKizTnEqphPmPBkhbk1gP4Cqld8agq
         j+FqOohMFDtUCRF5jWZ2XNLWo6mMTAQVnDgWg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ngtVr9tesRrH3h9QuJdwsRWwUqV+lCc3sEv7bM/pFPs=;
        b=CiMYSp76eg97NTOREzM4ZXhWu66Bu3yxFxAIgI4lg6DDi9uPk8X+lvzKN7Pt5IOxf8
         jxrvsrG9PM0uRxbbvmp8jFEH7WsdItjuxfyZA/fIu/Z0fMTz6AGmJy4CZDkFgU7XV2mo
         3TE+KmuHJcfqj77M1BYuH3P0jBIjwaZv+PKRMCw8defQuC+CDEwGDSjkc7RNSIalMIKF
         WKZEMBe5A76tQ3rB+CwIWh2SjSHzOwmH1Z9LJV5zYQFFRzSEU+f4lz0I76FeUelqOVnp
         zqzCbXjvBS0zLGP25PPP0vz213cfKcqS7ENkpQm+Ewq+Duf79eK8bkoUUVNSYK2Sr5z6
         9VEQ==
X-Gm-Message-State: AOAM530LJxzDQv8sxvpWvhEy1CnSRloKvKGJ3cSKjc+x/c69yWfKEjH/
	meeFIxkem2ayE/AC/9prNGT80jTnm47oyTj7mtc=
X-Google-Smtp-Source: ABdhPJxZZfubGisTEbWicH2NF2kv0WvXjJanPZaWPLqw0eJ9VOrBSDiPCPeSma/0kYwazYjbrXiKWg==
X-Received: by 2002:a17:906:69c5:b0:6cf:d164:8b32 with SMTP id g5-20020a17090669c500b006cfd1648b32mr9101061ejs.233.1648173892158;
        Thu, 24 Mar 2022 19:04:52 -0700 (PDT)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com. [209.85.221.48])
        by smtp.gmail.com with ESMTPSA id t19-20020a056402525300b0041952a1a764sm2257493edd.33.2022.03.24.19.04.51
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Mar 2022 19:04:51 -0700 (PDT)
Received: by mail-wr1-f48.google.com with SMTP id a1so8973057wrh.10
        for <patches@lists.linux.dev>; Thu, 24 Mar 2022 19:04:51 -0700 (PDT)
X-Received: by 2002:a2e:a5c4:0:b0:249:9ec3:f2b with SMTP id
 n4-20020a2ea5c4000000b002499ec30f2bmr6190271ljp.358.1648173425818; Thu, 24
 Mar 2022 18:57:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org> <20220325011415.C645DC340EC@smtp.kernel.org>
In-Reply-To: <20220325011415.C645DC340EC@smtp.kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 24 Mar 2022 18:56:49 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiLFGsHbbAEJV3j=Gj1p2foAf4+76XbH-nYzFh7EbxTPg@mail.gmail.com>
Message-ID: <CAHk-=wiLFGsHbbAEJV3j=Gj1p2foAf4+76XbH-nYzFh7EbxTPg@mail.gmail.com>
Subject: Re: [patch 113/114] selftests: vm: remove dependecy from internal
 kernel macros
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Shuah Khan <shuah@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ingo Molnar <mingo@redhat.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	Matthieu Baerts <matthieu.baerts@tessares.net>, mathew.j.martineau@linux.intel.com, 
	Jakub Kicinski <kuba@kernel.org>, Darren Hart <dvhart@infradead.org>, 
	Davidlohr Bueso <dave@stgolabs.net>, David Miller <davem@davemloft.net>, chi.minghao@zte.com.cn, 
	Alistair Popple <apopple@nvidia.com>, andrealmeid@collabora.com, usama.anjum@collabora.com, 
	patches@lists.linux.dev, Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, Mar 24, 2022 at 6:14 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> From: Muhammad Usama Anjum <usama.anjum@collabora.com>
> Subject: selftests: vm: remove dependecy from internal kernel macros

What what what?

> --- a/tools/testing/selftests/vm/userfaultfd.c~selftests-vm-remove-dependecy-from-internal-kernel-macros
> +++ a/tools/testing/selftests/vm/userfaultfd.c
> @@ -122,6 +122,9 @@ struct uffd_stats {
>  #define swap(a, b) \
>         do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
>
> +#define swap(a, b) \
> +       do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
> +
>  const char *examples =
>      "# Run anonymous memory test on 100MiB region with 99999 bounces:\n"
>      "./userfaultfd anon 100 99999\n\n"

Read that patch one more time.

This was already merged in commit 681696862bc1 ("selftests: vm: remove
dependecy from internal kernel macros"), just how many of those
'swap()' macros do you think we need?

Your patch managment logic seems to have failed the "was this already
applied" thing.

This smells like another "it applied with some context noise that I
just ignored" thing. Please please PLEASE use "-F0" to apply patches,
and if you have context that causes it to not apply cleanly,
double-check what is up.

(And if you are not git tool based, the *default* for git is to not
ignore context. But if you have scripts that do "-C1" or something to
ignore context lines, please make them warn very very loudly)

               Linus
