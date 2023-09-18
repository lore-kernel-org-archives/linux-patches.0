Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC8014017
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 08:04:20 +0000 (UTC)
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-1d69b2ffa1fso1397276fac.2
        for <patches@lists.linux.dev>; Mon, 18 Sep 2023 01:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695024259; x=1695629059; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KPP0JSvglHXB5a6MB2wK6irdRvbJ0js+qbHXjwIeNOU=;
        b=SSLrgsHG8vxlh1mp2HxXVX9k/7mC2O8rUVtlHhetEnp4ZwlL3LZ59ukd9Hqz+hTLQT
         2XtiQU3NfnvPmeYpAkJo8Ho4a3lR0hhH0UD8zsLCRIIZ1vl3+9gqonLuhiReUHfNo4pX
         /wNDRRDeBZCklXFxWtp/g/nKuHM4NIL9rqTuUPAnWCMnLkPXI36bvImTHkux6L6bevCa
         L0c/HcUGvgKw97lzbox+k25rMourY0zg27TbfLFpASf5np9MuOHOu3dZOggya4l5K28Y
         80Ly7TPR1RDKo4R+DejhK3goCUv7A9cMekmx4SfeS2fQxCprtZgpaGRH5IO2WnmRbolJ
         EjoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695024259; x=1695629059;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KPP0JSvglHXB5a6MB2wK6irdRvbJ0js+qbHXjwIeNOU=;
        b=l7WXw+Qt1cL3TCXr/ptL76JztGKTZRS5xD9ft2OuncJPcKcD70YWSF6iMnKnADXidF
         lmmXN1Vsly1JAbQJFazBLMXTUsORxKx79uEAZCBSb9LW/oomk2BXDtuoXdeGEp/D+osN
         pjTdmckrwWHEl1P5pZulxOK1/B8OGFNeZPRe7LLe9VmzoJLA5DrfWQwf+0dlWR1aiwyo
         W3L5EXb7uohnHiYFhauwQkEeo4p0hqMow2/efg/RBS4yspv2qsnwAC7gl8r9E+1NsQGU
         bO7f23xDl2ZD3AWIROclN/cPDU11lk9mJPsqftXZwwT0ZmJ1AM6assFHzgwQ6q6xME6n
         w6ig==
X-Gm-Message-State: AOJu0Yww5fd72F8xrwnYghhNZABnaeQpenlob6Nfalj4BjpgNkxfmGzG
	a1QnkOyrSZ7l4j4VD0GHnV+h/pFX9NOWNVb+Pho=
X-Google-Smtp-Source: AGHT+IHQpVuGvrGSLu2qPivoM1jgXWzjRIFWvsbeUKzZ0adYjeJzemaCk5yAN5b3j88OAoAl67U+GmR3m0xaBmycl1w=
X-Received: by 2002:a05:6870:8991:b0:1c0:3110:12cc with SMTP id
 f17-20020a056870899100b001c0311012ccmr11379120oaq.55.1695024259470; Mon, 18
 Sep 2023 01:04:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230917191051.639202302@linuxfoundation.org> <20230917191055.579497834@linuxfoundation.org>
In-Reply-To: <20230917191055.579497834@linuxfoundation.org>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 18 Sep 2023 10:04:07 +0200
Message-ID: <CAOi1vP9Mh02NB4-n5Wy3Zs1Y8M33qJsZzd12Y6k991jubQVzwQ@mail.gmail.com>
Subject: Re: [PATCH 6.5 113/285] ceph: make members in struct
 ceph_mds_request_args_ext a union
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Xiubo Li <xiubli@redhat.com>, Milind Changire <mchangir@redhat.com>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 17, 2023 at 9:49=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.5-stable review patch.  If anyone has any objections, please let me kno=
w.
>
> ------------------
>
> From: Xiubo Li <xiubli@redhat.com>
>
> [ Upstream commit 3af5ae22030cb59fab4fba35f5a2b62f47e14df9 ]
>
> In ceph mainline it will allow to set the btime in the setattr request
> and just add a 'btime' member in the union 'ceph_mds_request_args' and
> then bump up the header version to 4. That means the total size of union
> 'ceph_mds_request_args' will increase sizeof(struct ceph_timespec) bytes,
> but in kclient it will increase the sizeof(setattr_ext) bytes for each
> request.
>
> Since the MDS will always depend on the header's vesion and front_len
> members to decode the 'ceph_mds_request_head' struct, at the same time
> kclient hasn't supported the 'btime' feature yet in setattr request,
> so it's safe to do this change here.
>
> This will save 48 bytes memories for each request.
>
> Fixes: 4f1ddb1ea874 ("ceph: implement updated ceph_mds_request_head struc=
ture")
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> Reviewed-by: Milind Changire <mchangir@redhat.com>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  include/linux/ceph/ceph_fs.h | 24 +++++++++++++-----------
>  1 file changed, 13 insertions(+), 11 deletions(-)
>
> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
> index 49586ff261520..b4fa2a25b7d95 100644
> --- a/include/linux/ceph/ceph_fs.h
> +++ b/include/linux/ceph/ceph_fs.h
> @@ -462,17 +462,19 @@ union ceph_mds_request_args {
>  } __attribute__ ((packed));
>
>  union ceph_mds_request_args_ext {
> -       union ceph_mds_request_args old;
> -       struct {
> -               __le32 mode;
> -               __le32 uid;
> -               __le32 gid;
> -               struct ceph_timespec mtime;
> -               struct ceph_timespec atime;
> -               __le64 size, old_size;       /* old_size needed by trunca=
te */
> -               __le32 mask;                 /* CEPH_SETATTR_* */
> -               struct ceph_timespec btime;
> -       } __attribute__ ((packed)) setattr_ext;
> +       union {
> +               union ceph_mds_request_args old;
> +               struct {
> +                       __le32 mode;
> +                       __le32 uid;
> +                       __le32 gid;
> +                       struct ceph_timespec mtime;
> +                       struct ceph_timespec atime;
> +                       __le64 size, old_size;       /* old_size needed b=
y truncate */
> +                       __le32 mask;                 /* CEPH_SETATTR_* */
> +                       struct ceph_timespec btime;
> +               } __attribute__ ((packed)) setattr_ext;
> +       };

Hi Xiubo,

I was going to ask whether it makes sense to backport this change, but,
after looking at it, the change seems bogus to me even in mainline.  You
added a union inside siting memory use but ceph_mds_request_args_ext was
already a union before:

    union ceph_mds_request_args_ext {
        union ceph_mds_request_args old;
        struct { ... } __attribute__ ((packed)) setattr_ext;
    }

What is being achieved here?

    union ceph_mds_request_args_ext {
        union {
            union ceph_mds_request_args old;
            struct { ... } __attribute__ ((packed)) setattr_ext;
        };
    }

Thanks,

                Ilya
