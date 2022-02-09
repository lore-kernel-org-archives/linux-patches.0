Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0C82C9C
	for <patches@lists.linux.dev>; Wed,  9 Feb 2022 23:18:31 +0000 (UTC)
Received: by mail-yb1-f176.google.com with SMTP id v47so10500711ybi.4
        for <patches@lists.linux.dev>; Wed, 09 Feb 2022 15:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7HB6e1Vr3LMJMrComexKiElM7wBTKxyjaJy7JbLP6cQ=;
        b=TjC3rn4o4C4ruaw+B3GvA8WVjOJEdD3fjTRDVBGN2YuS3GpqwwV31f/jxnjfMvII6L
         ukj/tNvOI9qKvFyBUounY9/EE9INTlFPR/s5cORbl7j50llCQlsxJjmqEyCaqg7Axf6n
         dJhkOXOovMoLy7/nYRM/iGZ+zdwh4RtkGUjpANAoilpkcbVdXgOA63m0i0LQTVN2coMK
         beH5V428t8W1wLq6SymdzaAoTqD+Kn0GGACtcZYvI1lC9mjUPuVam3ElS6E+pPuxjNtJ
         3TD+11ypoIJNdVQ3tJKDpvPKpSIcN7SZaxk1YxjNeB5uAbAcJwQJHR25Zm9JdACnSmSp
         /bmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7HB6e1Vr3LMJMrComexKiElM7wBTKxyjaJy7JbLP6cQ=;
        b=rvam+eZ+dl2XlxUju0suXd0iSrPcFgjh9UiWwJgBVG8krJJ5U9cOaIkNU+1KIfBuVE
         CRg4JzXG1a4ctKOfFJorADzgMCUhbFYfKfcNvPIRdyZ1CgxrzwI7Zq4KRkjuyBiFH1TC
         k7j0NMmX9PDrzYvv9Xng1AUA8DauXGPT4x4DdtAsIcPNip3QNhzLcHn8thnbraVkVKHg
         DDFjICZaDLYvK6o/+sVQESOdt1gSI83N2rgiG0deo5kj43MuH6nnd+x7LUweQCvANXDi
         kDeFvnnPMIs98oyXf6+zdZRN99GKR5kPfT8khDNhISzA2Sypqm0dz72JqdDQ3Mow2lJU
         GKNQ==
X-Gm-Message-State: AOAM532TEOY31Ljs9fHC9QqXGYtJK15+FU4Fd/nSJ9vA1yDFRR7dw6WV
	8568+IuVz4g7SmXSObyg31Ps1mcIkMkqKfMrf28WhaNMXxztXg==
X-Google-Smtp-Source: ABdhPJwyPnOhPFLimZVUJ0nR3KgifupOjm09D6F9gFFUYZfM9mOPzcknnY05+jmgOm7JPT9N3Ig60AQOMZtHOQVWpww=
X-Received: by 2002:a25:ada1:: with SMTP id z33mr4713741ybi.182.1644448710821;
 Wed, 09 Feb 2022 15:18:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220209225758.476724-1-mcgrof@kernel.org> <CAA5qM4BBHj44NgH2210nfZCBru0NV04gd1t8Yp7Et6M7LmJK-w@mail.gmail.com>
In-Reply-To: <CAA5qM4BBHj44NgH2210nfZCBru0NV04gd1t8Yp7Et6M7LmJK-w@mail.gmail.com>
From: Tong Zhang <ztong0001@gmail.com>
Date: Wed, 9 Feb 2022 15:18:20 -0800
Message-ID: <CAA5qM4CZ-hj+R1OX1MjYfsMUnyapmdGeKCr=1aX5ZEvGsH7gjg@mail.gmail.com>
Subject: Re: [PATCH v2] fs: move binfmt_misc sysctl to its own file as built-in
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, 
	Iurii Zaikin <yzaikin@google.com>, nixiaoming@huawei.com, 
	Eric Biederman <ebiederm@xmission.com>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, 
	patches@lists.linux.dev, Domenico Andreoli <domenico.andreoli@linux.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Feb 9, 2022 at 3:15 PM Tong Zhang <ztong0001@gmail.com> wrote:
>
> On Wed, Feb 9, 2022 at 2:58 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >
> > This is the second attempt to move binfmt_misc sysctl to its
> > own file. The issue with the first move was that we moved
> > the binfmt_misc sysctls to the binfmt_misc module, but the
> > way things work on some systems is that the binfmt_misc
> > module will load if the sysctl is present. If we don't force
> > the sysctl on, the module won't load. The proper thing to do
> > is to register the sysctl if the module was built or the
> > binfmt_misc code was built-in, we do this by using the helper
> > IS_ENABLED() now.
> >
> > The rationale for the move:
> >
> > kernel/sysctl.c is a kitchen sink where everyone leaves their dirty
> > dishes, this makes it very difficult to maintain.
> >
> > To help with this maintenance let's start by moving sysctls to places
> > where they actually belong.  The proc sysctl maintainers do not want to
> > know what sysctl knobs you wish to add for your own piece of code, we
> > just care about the core logic.
> >
> > This moves the binfmt_misc sysctl to its own file to help remove clutter
> > from kernel/sysctl.c.
> >
> > Cc: Domenico Andreoli <domenico.andreoli@linux.com>
> > Cc: Tong Zhang <ztong0001@gmail.com>
> > Reviewed-by: Tong Zhang <ztong0001@gmail.com>
> > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > ---
> >
> > Andrew,
> >
> > If we get tested-by from Domenico and Tong I think this is ready.
> >
> > Demenico, Tong, can you please test this patch? Linus' tree
> > should already have all the prior work reverted as Domenico requested
> > so this starts fresh.
> >
> >  fs/file_table.c |  2 ++
> >  kernel/sysctl.c | 13 -------------
> >  2 files changed, 2 insertions(+), 13 deletions(-)
> >
> > diff --git a/fs/file_table.c b/fs/file_table.c
> > index 57edef16dce4..4969021fa676 100644
> > --- a/fs/file_table.c
> > +++ b/fs/file_table.c
> > @@ -119,6 +119,8 @@ static struct ctl_table fs_stat_sysctls[] = {
> >  static int __init init_fs_stat_sysctls(void)
> >  {
> >         register_sysctl_init("fs", fs_stat_sysctls);
> > +       if (IS_ENABLED(CONFIG_BINFMT_MISC))
> > +               register_sysctl_mount_point("fs/binfmt_misc");
> >         return 0;
> >  }
> >  fs_initcall(init_fs_stat_sysctls);
> > diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> > index 241cfc6bc36f..788b9a34d5ab 100644
> > --- a/kernel/sysctl.c
> > +++ b/kernel/sysctl.c
> > @@ -2735,17 +2735,6 @@ static struct ctl_table vm_table[] = {
> >         { }
> >  };
> >
> > -static struct ctl_table fs_table[] = {
> > -#if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
> > -       {
> > -               .procname       = "binfmt_misc",
> > -               .mode           = 0555,
> > -               .child          = sysctl_mount_point,
> > -       },
> > -#endif
> > -       { }
> > -};
> > -
> >  static struct ctl_table debug_table[] = {
> >  #ifdef CONFIG_SYSCTL_EXCEPTION_TRACE
> >         {
> > @@ -2765,7 +2754,6 @@ static struct ctl_table dev_table[] = {
> >
> >  DECLARE_SYSCTL_BASE(kernel, kern_table);
> >  DECLARE_SYSCTL_BASE(vm, vm_table);
> > -DECLARE_SYSCTL_BASE(fs, fs_table);
> >  DECLARE_SYSCTL_BASE(debug, debug_table);
> >  DECLARE_SYSCTL_BASE(dev, dev_table);
> >
> > @@ -2773,7 +2761,6 @@ int __init sysctl_init_bases(void)
> >  {
> >         register_sysctl_base(kernel);
> >         register_sysctl_base(vm);
> > -       register_sysctl_base(fs);
> >         register_sysctl_base(debug);
> >         register_sysctl_base(dev);
> >
> > --
> > 2.34.1
> >
>
> Hi Luis,
> Thanks for posting.
> I checked the master branch just now and the fix is already in, see
> commit b42bc9a3c511("Fix regression due to "fs: move binfmt_misc
> sysctl to its own file"")
> I have tested it yesterday on a debian machine and it appears to be ok.
> - Tong

One thing I forget to mention is that since we removed binfmt related
stuff from kernel/sysctl.c
#include<linux/binfmts.h> is not needed anymore and can be removed.

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 5ae443b2882e..47e1696e3972 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -59,7 +59,6 @@
 #include <linux/oom.h>
 #include <linux/kmod.h>
 #include <linux/capability.h>
-#include <linux/binfmts.h>
 #include <linux/sched/sysctl.h>
 #include <linux/kexec.h>
 #include <linux/bpf.h>

- Tong
