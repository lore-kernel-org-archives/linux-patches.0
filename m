Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9459979FF
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 08:43:21 +0000 (UTC)
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-570e63f5224so2866526eaf.0
        for <patches@lists.linux.dev>; Mon, 18 Sep 2023 01:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695026600; x=1695631400; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RZcC6454SXkCoFbPwkl3+gaRjC+6aJtJVnc/n+zS+3Y=;
        b=P45harJc+SLEOE4jzUWYi2viONll8TbBZOZ5WZUi85nBaOuHTtt4JHRIhZkGSOWe/W
         FrSOKlx/pPX+0NC8Hf+epOWlFddmrGQ83EROyoL6Fiy5B/AHyva1VKW7s7qSs0enVSTv
         RjdC77mfbi6nXB0yYwdTVFjulgd0gLGmS8nYIXxf57bvHl/6/FvPHsfByGJEyIH5HprI
         aS0QXJj4SqzkRzq4Wrxu6zfN6k1iEYLSR5xVT1EBgnGC9dwX/P6BcHD6q4NwcktWBAw0
         h8KW9yp5irWpOEnO7DX+plVcpMWveBXnFcGiUwCwkl7jlP5O9nhm0E8bjqTo+nmoDm0K
         EgUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695026600; x=1695631400;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RZcC6454SXkCoFbPwkl3+gaRjC+6aJtJVnc/n+zS+3Y=;
        b=P6AaujL98cOOVrgO/ozFBMqzjeoW02DaGI5LVJhbwU/3MeDVR1X1jRgipt3R2IvSpS
         W3gboCcm19tB+sHxHgSjqITPH73QAP75jVccBhmdebCq6nbAbJXueEbm20nD9MxZinZH
         lIuEIfmJ40eCO4hK/0spYSqY0g+XkV81zGX/SJJ43azdgcTx2X2p/Xih2OLo93unp4kL
         aRjUH0r6QVUIvuozzD7112FK6PAwZCg3v+fOcImWhAN0Kbi9Lk86hs/KrXQdjEzW4pxy
         w5KyDBxb7WlUKtSdO9hXCpEAxKiZ8vMyJ/S/Rl21vf0caUqxFyl99FOVkIFmXGK3gG6Q
         GS/w==
X-Gm-Message-State: AOJu0YyuL7pUpls5VmqUmOu33K8u42du2xKUczOKzZx5qqploFI1Ucbi
	VvhuiXDX3aTkNNmpdJrs0Fu9FTXaACEn3ilzaVU=
X-Google-Smtp-Source: AGHT+IEF2VoWcipTFMyJYQPN4Bn6tZtdzp2rsgL0ehDOFmvx58yi3mS5IXBaa3pjK080NAu73wGp8F9ktUi3fIbnRSA=
X-Received: by 2002:a05:6870:9f85:b0:1d6:63b4:ddfe with SMTP id
 xm5-20020a0568709f8500b001d663b4ddfemr4970867oab.27.1695026600464; Mon, 18
 Sep 2023 01:43:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230917191051.639202302@linuxfoundation.org> <20230917191055.579497834@linuxfoundation.org>
 <CAOi1vP9Mh02NB4-n5Wy3Zs1Y8M33qJsZzd12Y6k991jubQVzwQ@mail.gmail.com> <90c74084-d3dc-e1cf-0d9a-a244529f7779@redhat.com>
In-Reply-To: <90c74084-d3dc-e1cf-0d9a-a244529f7779@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 18 Sep 2023 10:43:08 +0200
Message-ID: <CAOi1vP9UU+GHn+rygfNgCdFMBCdgbB4h6FkzBOA56j9CesHBXA@mail.gmail.com>
Subject: Re: [PATCH 6.5 113/285] ceph: make members in struct
 ceph_mds_request_args_ext a union
To: Xiubo Li <xiubli@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, Milind Changire <mchangir@redhat.com>, 
	Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 18, 2023 at 10:20=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote=
:
>
>
> On 9/18/23 16:04, Ilya Dryomov wrote:
> > On Sun, Sep 17, 2023 at 9:49=E2=80=AFPM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> >> 6.5-stable review patch.  If anyone has any objections, please let me =
know.
> >>
> >> ------------------
> >>
> >> From: Xiubo Li <xiubli@redhat.com>
> >>
> >> [ Upstream commit 3af5ae22030cb59fab4fba35f5a2b62f47e14df9 ]
> >>
> >> In ceph mainline it will allow to set the btime in the setattr request
> >> and just add a 'btime' member in the union 'ceph_mds_request_args' and
> >> then bump up the header version to 4. That means the total size of uni=
on
> >> 'ceph_mds_request_args' will increase sizeof(struct ceph_timespec) byt=
es,
> >> but in kclient it will increase the sizeof(setattr_ext) bytes for each
> >> request.
> >>
> >> Since the MDS will always depend on the header's vesion and front_len
> >> members to decode the 'ceph_mds_request_head' struct, at the same time
> >> kclient hasn't supported the 'btime' feature yet in setattr request,
> >> so it's safe to do this change here.
> >>
> >> This will save 48 bytes memories for each request.
> >>
> >> Fixes: 4f1ddb1ea874 ("ceph: implement updated ceph_mds_request_head st=
ructure")
> >> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >> Reviewed-by: Milind Changire <mchangir@redhat.com>
> >> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> >> Signed-off-by: Sasha Levin <sashal@kernel.org>
> >> ---
> >>   include/linux/ceph/ceph_fs.h | 24 +++++++++++++-----------
> >>   1 file changed, 13 insertions(+), 11 deletions(-)
> >>
> >> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs=
.h
> >> index 49586ff261520..b4fa2a25b7d95 100644
> >> --- a/include/linux/ceph/ceph_fs.h
> >> +++ b/include/linux/ceph/ceph_fs.h
> >> @@ -462,17 +462,19 @@ union ceph_mds_request_args {
> >>   } __attribute__ ((packed));
> >>
> >>   union ceph_mds_request_args_ext {
> >> -       union ceph_mds_request_args old;
> >> -       struct {
> >> -               __le32 mode;
> >> -               __le32 uid;
> >> -               __le32 gid;
> >> -               struct ceph_timespec mtime;
> >> -               struct ceph_timespec atime;
> >> -               __le64 size, old_size;       /* old_size needed by tru=
ncate */
> >> -               __le32 mask;                 /* CEPH_SETATTR_* */
> >> -               struct ceph_timespec btime;
> >> -       } __attribute__ ((packed)) setattr_ext;
> >> +       union {
> >> +               union ceph_mds_request_args old;
> >> +               struct {
> >> +                       __le32 mode;
> >> +                       __le32 uid;
> >> +                       __le32 gid;
> >> +                       struct ceph_timespec mtime;
> >> +                       struct ceph_timespec atime;
> >> +                       __le64 size, old_size;       /* old_size neede=
d by truncate */
> >> +                       __le32 mask;                 /* CEPH_SETATTR_*=
 */
> >> +                       struct ceph_timespec btime;
> >> +               } __attribute__ ((packed)) setattr_ext;
> >> +       };
> > Hi Xiubo,
> >
> > I was going to ask whether it makes sense to backport this change, but,
> > after looking at it, the change seems bogus to me even in mainline.  Yo=
u
> > added a union inside siting memory use but ceph_mds_request_args_ext wa=
s
> > already a union before:
> >
> >      union ceph_mds_request_args_ext {
> >          union ceph_mds_request_args old;
> >          struct { ... } __attribute__ ((packed)) setattr_ext;
> >      }
> >
> > What is being achieved here?
>
> As I remembered there has other changes in this union in the beginning.
> And that patch seems being abandoned and missing this one.
>
> Let's skip backporting this one and in the upstream just revert it.

OK, I will send a revert to ceph-devel list.

Greg, please drop this one from all stable branches.

Thanks,

                Ilya
