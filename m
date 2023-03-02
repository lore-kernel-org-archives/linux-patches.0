Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0712D524
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 20:48:14 +0000 (UTC)
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 9640C3F144
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 20:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1677789742;
	bh=VPNnC6C1cy3MGBtKJ7RY2J7qDK3sxM2tBtUziWuIYdg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version;
	b=fR5ykiFqiJqksFR5sFlfm4Bmdx95y8ThEG9bxzb9ocgZm7JiSZs1wFab84mZmZ+Vn
	 2ZFQAEWto8cb3rm9SAa/T9kds2vyfK3DbEcQt/ATL0WBqac3KLT+MqWjbS4DoWfIqk
	 YsBSa96Hd91XXSMa7t/2PYedkgcb4XKztIJ4MS6vQY0lMhb9/KWYocm5wyzrR+l4MB
	 SULOQn5t+TdskdpntxRp1iDHlNY5LSvKSTa334mmpIdePvmFZnyIwCTDN9/nLuha3G
	 MRbxlkqfE2xglf2JCMr+YB2EqL00z41Cb9drxf+eRtJR5qngvmBuXdIN6X5k3AsGbf
	 KPzUzkHKqPwsg==
Received: by mail-oo1-f71.google.com with SMTP id y29-20020a4a651d000000b00525101290e7so280610ooc.12
        for <patches@lists.linux.dev>; Thu, 02 Mar 2023 12:42:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677789740;
        h=mime-version:user-agent:content-transfer-encoding:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VPNnC6C1cy3MGBtKJ7RY2J7qDK3sxM2tBtUziWuIYdg=;
        b=7xWyuDmJaon57UXtdR6cN0anEjfjw3xKdgQacflVy+c90K7/GrIrfOavgkgYITVeha
         gJXNtf7oYmwBo20mL1jRKp0I4oKeh/m53SsmwABK22dIQ/WX9zkc/x3ypSIsPndix1eW
         8IrcK3b26WBXJVdChCBOi9ZSy/VQxH9yngVc+93Rnz1fp1HHA3SnBHIPom+8V3DOHgy7
         7nDHrUtCaE7RiE1HZnZytaFKjxlB/Rl8KmuoEWzXT9Ar0g8Gw22CHns3JPyhurDb/rMP
         +69RE8hy69QuShI5f0CEFgwUmHULc4PxBNFWEWTSq09Yx3Dj2McvCyd4DYj5b0xn5GT2
         hZYQ==
X-Gm-Message-State: AO0yUKULIK1liKd2jXMFUgIsHLJ3rBq3wCH8aQNaQs/vuVlPRmrlYK59
	93rLgC+e4JnTooo2TWHpVVV3prasC9VBAlK14l02iLIX+Ynyl4v3+GWwXJPAmQpWCqxKE96HR5g
	rfFx9dO52xh+YhFBd9ICvP2J7O8wIt7DO4KE=
X-Received: by 2002:a9d:803:0:b0:690:d198:4d1e with SMTP id 3-20020a9d0803000000b00690d1984d1emr1669408oty.8.1677789740519;
        Thu, 02 Mar 2023 12:42:20 -0800 (PST)
X-Google-Smtp-Source: AK7set+mzZi4KGEKQQVH4HIHgt8mr09sF5ZEI/y0N5gvVHOM4lDo9PhDEhWGcQyAF/1JU7UCO5GrTA==
X-Received: by 2002:a9d:803:0:b0:690:d198:4d1e with SMTP id 3-20020a9d0803000000b00690d1984d1emr1669391oty.8.1677789740223;
        Thu, 02 Mar 2023 12:42:20 -0800 (PST)
Received: from ?IPv6:2804:1b3:a7c3:d46d:73b6:f440:93a4:30? ([2804:1b3:a7c3:d46d:73b6:f440:93a4:30])
        by smtp.gmail.com with ESMTPSA id d11-20020a9d72cb000000b0068bcef4f543sm327296otk.21.2023.03.02.12.42.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 12:42:19 -0800 (PST)
Message-ID: <c010472791aa57c8ea838b5e85780f5be98898d5.camel@canonical.com>
Subject: Re: [PATCH 04/11] apparmor: simplify sysctls with
 register_sysctl_init()
From: Georgia Garcia <georgia.garcia@canonical.com>
To: Luis Chamberlain <mcgrof@kernel.org>, ebiederm@xmission.com, 
 keescook@chromium.org, yzaikin@google.com, john.johansen@canonical.com, 
 paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
 luto@amacapital.net,  wad@chromium.org, dverkamp@chromium.org,
 paulmck@kernel.org, baihaowen@meizu.com,  frederic@kernel.org,
 jeffxu@google.com, ebiggers@kernel.org, tytso@mit.edu,  guoren@kernel.org
Cc: j.granados@samsung.com, zhangpeng362@huawei.com, tangmeng@uniontech.com,
  willy@infradead.org, nixiaoming@huawei.com, sujiaxun@uniontech.com, 
 patches@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, 
 linux-csky@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 02 Mar 2023 17:42:07 -0300
In-Reply-To: <20230302202826.776286-5-mcgrof@kernel.org>
References: <20230302202826.776286-1-mcgrof@kernel.org>
	 <20230302202826.776286-5-mcgrof@kernel.org>
Organization: Canonical
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu1 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2023-03-02 at 12:28 -0800, Luis Chamberlain wrote:
> Using register_sysctl_paths() is really only needed if you have
> subdirectories with entries. We can use the simple register_sysctl()
> instead.
>=20
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  security/apparmor/lsm.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
>=20
> diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
> index d6cc4812ca53..47c7ec7e5a80 100644
> --- a/security/apparmor/lsm.c
> +++ b/security/apparmor/lsm.c
> @@ -1764,11 +1764,6 @@ static int apparmor_dointvec(struct ctl_table *tab=
le, int write,
>  	return proc_dointvec(table, write, buffer, lenp, ppos);
>  }
> =20
> -static struct ctl_path apparmor_sysctl_path[] =3D {
> -	{ .procname =3D "kernel", },
> -	{ }
> -};
> -
>  static struct ctl_table apparmor_sysctl_table[] =3D {
>  	{
>  		.procname       =3D "unprivileged_userns_apparmor_policy",
> @@ -1790,8 +1785,7 @@ static struct ctl_table apparmor_sysctl_table[] =3D=
 {
> =20
>  static int __init apparmor_init_sysctl(void)
>  {
> -	return register_sysctl_paths(apparmor_sysctl_path,
> -				     apparmor_sysctl_table) ? 0 : -ENOMEM;
> +	return register_sysctl("kernel", apparmor_sysctl_table) ? 0 : -ENOMEM;
>  }
>  #else
>  static inline int apparmor_init_sysctl(void)

Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>

