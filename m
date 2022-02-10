Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260E92F20
	for <patches@lists.linux.dev>; Thu, 10 Feb 2022 00:14:20 +0000 (UTC)
Received: by mail-yb1-f171.google.com with SMTP id y129so10765733ybe.7
        for <patches@lists.linux.dev>; Wed, 09 Feb 2022 16:14:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Akgx51vaaMrtc+I5CN79O3ziymolIo3sR9qZ9Dclibo=;
        b=AEBGLpCXKdcPH9e6PUy58PqQod9wcJMMmgPof7QbAjGzdeRF0q/P+pH44kUmDYXM/F
         C6+CQsZ6c9rK9EupFMDkbqrM+DfqjV3UqaYarinoJuK8CpLMuOSYGk0Nq3fK7PkcpJiv
         gc3gi9uZiUi5N6F9eFpds1/g29PT9p4qlJyx2BXQXdYrOZgxEQFLAhy5KtNI/x0tz2d1
         CYDNsBHC8TGTARw17XIoxMfsxSrrgp9U8OU+gFqikpI0xY7rPvk77/dEVBzWrqP9NPvs
         WxZKuHq9PDqZh1noKcc4emoD1TSxaY52F/MXWdCIbNnZArQhD6UiMiq20odVQfx2X8Tt
         bfXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Akgx51vaaMrtc+I5CN79O3ziymolIo3sR9qZ9Dclibo=;
        b=UzOK5pkSM4wSIhklxfChVX0+o8HoftU0q7tdqUI0M8aIcUkoKuDHbr4UjLQon69Dul
         O+HSHBWbYyrNhmjBOY2kkOZshQTR9qJuhAnpqqySSUeOofvIPyW1JCvicBV5u2tYhaTu
         G+S6xUbH4J7QWx0acgR1PxtjoOGYD4ocKnXgbOXzDMv3Pe56wnfNVTfpZvgkbJSCdNGS
         v3v3ApduMVPbQCHxdJXm0fBttTWwYEtq6O4sFusfcLkjYNSYSSov0HCDit3liVsz+TSo
         tsc7MuOXQv6HzpxnRFYsAPVJ8Hu1n6d9AmJRLALVcOTen8Vc3uaE2d5Uv9EvEifj5Rl4
         6Ydw==
X-Gm-Message-State: AOAM533Lv/xr+MvclQGmqAmAYEbXk8bP5G5qsMtVkYnNx8fzEnuLoPPw
	IkZWihzyQiaxAwnI0N7Td3UlXtf1L5TBQx8cvjM=
X-Google-Smtp-Source: ABdhPJx4o8BFRxE3WtS5vfxB6Q7U0LsX8rDHfugHML6AhQxaWreAtX6zQ2pAj5U4yGvassMurqhVlDu9siwHSMj6Cbg=
X-Received: by 2002:a81:310:: with SMTP id 16mr4869228ywd.35.1644452058925;
 Wed, 09 Feb 2022 16:14:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220209225758.476724-1-mcgrof@kernel.org> <CAA5qM4BBHj44NgH2210nfZCBru0NV04gd1t8Yp7Et6M7LmJK-w@mail.gmail.com>
 <YgROSgDA3keJowks@bombadil.infradead.org> <CAA5qM4C2g6=6mWsQW4vkbSV0ykEjBgNYGp8oVFKtQfKFn5OFjA@mail.gmail.com>
In-Reply-To: <CAA5qM4C2g6=6mWsQW4vkbSV0ykEjBgNYGp8oVFKtQfKFn5OFjA@mail.gmail.com>
From: Tong Zhang <ztong0001@gmail.com>
Date: Wed, 9 Feb 2022 16:14:08 -0800
Message-ID: <CAA5qM4CGCfLUv8o0Er1FL-2+ntqsTgw1FQODnCH9FA8WvuSr=w@mail.gmail.com>
Subject: Re: [PATCH v2] fs: move binfmt_misc sysctl to its own file as built-in
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, 
	Iurii Zaikin <yzaikin@google.com>, nixiaoming@huawei.com, 
	Eric Biederman <ebiederm@xmission.com>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, 
	patches@lists.linux.dev, Domenico Andreoli <domenico.andreoli@linux.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Feb 9, 2022 at 3:39 PM Tong Zhang <ztong0001@gmail.com> wrote:
>
> On Wed, Feb 9, 2022 at 3:29 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >
> > On Wed, Feb 09, 2022 at 03:15:53PM -0800, Tong Zhang wrote:
> > > On Wed, Feb 9, 2022 at 2:58 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> > > >
> > > > This is the second attempt to move binfmt_misc sysctl to its
> > > > own file. The issue with the first move was that we moved
> > > > the binfmt_misc sysctls to the binfmt_misc module, but the
> > > > way things work on some systems is that the binfmt_misc
> > > > module will load if the sysctl is present. If we don't force
> > > > the sysctl on, the module won't load. The proper thing to do
> > > > is to register the sysctl if the module was built or the
> > > > binfmt_misc code was built-in, we do this by using the helper
> > > > IS_ENABLED() now.
> > > >
> > > > The rationale for the move:
> > > >
> > > > kernel/sysctl.c is a kitchen sink where everyone leaves their dirty
> > > > dishes, this makes it very difficult to maintain.
> > > >
> > > > To help with this maintenance let's start by moving sysctls to places
> > > > where they actually belong.  The proc sysctl maintainers do not want to
> > > > know what sysctl knobs you wish to add for your own piece of code, we
> > > > just care about the core logic.
> > > >
> > > > This moves the binfmt_misc sysctl to its own file to help remove clutter
> > > > from kernel/sysctl.c.
> > > >
> > > > Cc: Domenico Andreoli <domenico.andreoli@linux.com>
> > > > Cc: Tong Zhang <ztong0001@gmail.com>
> > > > Reviewed-by: Tong Zhang <ztong0001@gmail.com>
> > > > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > > > ---
> > > >
> > > > Andrew,
> > > >
> > > > If we get tested-by from Domenico and Tong I think this is ready.
> > > >
> > > > Demenico, Tong, can you please test this patch? Linus' tree
> > > > should already have all the prior work reverted as Domenico requested
> > > > so this starts fresh.
> > > >
> > > >  fs/file_table.c |  2 ++
> > > >  kernel/sysctl.c | 13 -------------
> > > >  2 files changed, 2 insertions(+), 13 deletions(-)
> > > >
> > > > diff --git a/fs/file_table.c b/fs/file_table.c
> > > > index 57edef16dce4..4969021fa676 100644
> > > > --- a/fs/file_table.c
> > > > +++ b/fs/file_table.c
> > > > @@ -119,6 +119,8 @@ static struct ctl_table fs_stat_sysctls[] = {
> > > >  static int __init init_fs_stat_sysctls(void)
> > > >  {
> > > >         register_sysctl_init("fs", fs_stat_sysctls);
> > > > +       if (IS_ENABLED(CONFIG_BINFMT_MISC))
> > > > +               register_sysctl_mount_point("fs/binfmt_misc");
                             ^^^^


I'm looking at this code again and we need to mark this return value
in kmemleak to avoid a false positive.


diff --git a/fs/file_table.c b/fs/file_table.c
index 4969021fa676..7303aa33b3fd 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -27,6 +27,7 @@
 #include <linux/task_work.h>
 #include <linux/ima.h>
 #include <linux/swap.h>
+#include <linux/kmemleak.h>

 #include <linux/atomic.h>

@@ -119,8 +120,10 @@ static struct ctl_table fs_stat_sysctls[] = {
 static int __init init_fs_stat_sysctls(void)
 {
        register_sysctl_init("fs", fs_stat_sysctls);
-       if (IS_ENABLED(CONFIG_BINFMT_MISC))
-               register_sysctl_mount_point("fs/binfmt_misc");
+       if (IS_ENABLED(CONFIG_BINFMT_MISC)) {
+               struct ctl_table_header *hdr =
register_sysctl_mount_point("fs/binfmt_misc");
+               kmemleak_not_leak(hdr);
+    }
        return 0;
 }
 fs_initcall(init_fs_stat_sysctls);
