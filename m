Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8664D53B
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 23:14:33 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id h17-20020a17090aea9100b0023739b10792so573146pjz.1
        for <patches@lists.linux.dev>; Thu, 02 Mar 2023 15:14:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677798873;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dK5xBsNL80qIVhQ78+b+C534EV7ZA+MEtH4IecrU8fs=;
        b=dQa60YkNB2aHmO2eQcUKKkWMpQNb0V1GmMgzCtjajumKPoUa34DT1KW4VyAmnDllnW
         tBCca31eWsY8i/Th0ibNmqeeF5yKTzOum5xPC8aoXRqxuyQgj9C/JlnCifC4KCtAwKb8
         v4pqyQ4ZiU+89CoZ5Y65rTyJozDPpo4HdJgXVwtmjxF22wLTfQyCouIvPQxV5uYQuCrw
         P/jszesABAwdcZOuQmfKH1fSIxYPeLX27XyemZD3D40bp1QyeRTI9GkjDnwy80Yz6mZP
         Y/v9wqkSOnnwI/cKXAGsP8HdbUugB3KtD44ZKRukUPs4uhA9J+HxV/G+qQp6JCvY/BCl
         suAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677798873;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dK5xBsNL80qIVhQ78+b+C534EV7ZA+MEtH4IecrU8fs=;
        b=Fc79mkKmJrSy0Nxpsp+kE4jHPcB4mp/HJpXTPjsi0lC8l3fVtPb5qCkMrTkbN56SZO
         fytXQqvxOH+shCRj5IYVk17En+Y6YTCaB85qJnXkF5kTH9r7nFHWLotupsiXSUKujbVX
         1Kl98L4fSip/v13MYdT4+OoAtkhmNt3GSUAgZrNn27lYPP67j6oZ9OpjmykOkDb0lPTg
         s54YyVaohfk2fJiSohL3vUzqA8i0Z1zCHQMcbLpXKiDLCEVNsuVRw+Yut6R+GNde7AUi
         jMLzDxE6j3k0m5rGRSxj/Vmo5IlM1nysZyW+ALcjwsnWviWbKs3RrT9w+O2/f3iJonL6
         o1BQ==
X-Gm-Message-State: AO0yUKXISarlwZ33d1YTenXCAj3bUzewn5D576idvPrLV0j6548kCYgR
	pejvYKfuum3tQfTgC7iWwuwxj9yL2DoII1kWO2Q0SQ==
X-Google-Smtp-Source: AK7set/wy4RYTpF9DE9+esAO3swTwx9AMlMSD7Y2MF1LhQ+HmQO3b//lY81QPmALZdw979D/M11S681c0YXmtKI/bVE=
X-Received: by 2002:a17:903:2591:b0:19a:8bc7:d814 with SMTP id
 jb17-20020a170903259100b0019a8bc7d814mr4441125plb.13.1677798872570; Thu, 02
 Mar 2023 15:14:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230302202826.776286-1-mcgrof@kernel.org> <20230302202826.776286-9-mcgrof@kernel.org>
In-Reply-To: <20230302202826.776286-9-mcgrof@kernel.org>
From: Jeff Xu <jeffxu@google.com>
Date: Thu, 2 Mar 2023 15:13:54 -0800
Message-ID: <CALmYWFucv6-9yfS=gamwSsqjgxSKZS0nvVjj_QfBmsLmQD5XOQ@mail.gmail.com>
Subject: Re: [PATCH 08/11] kernel: pid_namespace: simplify sysctls with register_sysctl()
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: ebiederm@xmission.com, keescook@chromium.org, yzaikin@google.com, 
	john.johansen@canonical.com, paul@paul-moore.com, jmorris@namei.org, 
	serge@hallyn.com, luto@amacapital.net, wad@chromium.org, 
	dverkamp@chromium.org, paulmck@kernel.org, baihaowen@meizu.com, 
	frederic@kernel.org, ebiggers@kernel.org, tytso@mit.edu, guoren@kernel.org, 
	j.granados@samsung.com, zhangpeng362@huawei.com, tangmeng@uniontech.com, 
	willy@infradead.org, nixiaoming@huawei.com, sujiaxun@uniontech.com, 
	patches@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, 
	linux-csky@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 2, 2023 at 12:28=E2=80=AFPM Luis Chamberlain <mcgrof@kernel.org=
> wrote:
>
> register_sysctl_paths() is only required if your child (directories)
> have entries and pid_namespace does not. So use register_sysctl_init()
> instead where we don't care about the return value and use
> register_sysctl() where we do.
>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  kernel/pid_namespace.c | 3 +--
>  kernel/pid_sysctl.h    | 3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
> index 46e0d5a3f91f..b43eee07b00c 100644
> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
> @@ -314,7 +314,6 @@ static struct ctl_table pid_ns_ctl_table[] =3D {
>         },
>         { }
>  };
> -static struct ctl_path kern_path[] =3D { { .procname =3D "kernel", }, { =
} };
>  #endif /* CONFIG_CHECKPOINT_RESTORE */
>
>  int reboot_pid_ns(struct pid_namespace *pid_ns, int cmd)
> @@ -473,7 +472,7 @@ static __init int pid_namespaces_init(void)
>         pid_ns_cachep =3D KMEM_CACHE(pid_namespace, SLAB_PANIC | SLAB_ACC=
OUNT);
>
>  #ifdef CONFIG_CHECKPOINT_RESTORE
> -       register_sysctl_paths(kern_path, pid_ns_ctl_table);
> +       register_sysctl_init("kernel", pid_ns_ctl_table);
>  #endif
>
>         register_pid_ns_sysctl_table_vm();
> diff --git a/kernel/pid_sysctl.h b/kernel/pid_sysctl.h
> index e22d072e1e24..d67a4d45bb42 100644
> --- a/kernel/pid_sysctl.h
> +++ b/kernel/pid_sysctl.h
> @@ -46,10 +46,9 @@ static struct ctl_table pid_ns_ctl_table_vm[] =3D {
>         },
>         { }
>  };
> -static struct ctl_path vm_path[] =3D { { .procname =3D "vm", }, { } };
>  static inline void register_pid_ns_sysctl_table_vm(void)
>  {
> -       register_sysctl_paths(vm_path, pid_ns_ctl_table_vm);
> +       register_sysctl("vm", pid_ns_ctl_table_vm);
>  }
>  #else
>  static inline void initialize_memfd_noexec_scope(struct pid_namespace *n=
s) {}
> --
> 2.39.1
>
Acked-by: Jeff Xu <jeffxu@google.com>
