Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA35017D4
	for <patches@lists.linux.dev>; Wed, 19 Apr 2023 04:18:10 +0000 (UTC)
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-63b64a32fd2so2953453b3a.2
        for <patches@lists.linux.dev>; Tue, 18 Apr 2023 21:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681877890; x=1684469890;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1yOlmeuohL1y9HWwOAFFBHf0wIhbGMAUILl4Etf+xaM=;
        b=g9XFVOwTjnRDWpVUdboPuxWJfvxBkfOMlRJdLs9teGzJRpKulIKhsyauD7KhA8Ekg2
         mpPKfY4w28TdgGzFsqhbszZNyiZHeH3PVlhT0PjAM0m97jmt358oN79pKoypnHqbDEFW
         xPM6hdmSmji/hkD50tsDFj2qW2tvsi04D+2rcKCRvABqOXJ7A7XN4NLZtZWGVfIptKJl
         uI+1KCTyVW3gZE5bbHZR9ubkFBED5fPPch7D1SDUAdBYmLnQesJC8OuR3Sgh8VApXRMc
         29Tco9juXr+sEfqjS6TXxmZ6WYjjhLZEph2N4epdjC1fFbEL31fAFbbnBjNtZxUI3oLt
         rPcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681877890; x=1684469890;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1yOlmeuohL1y9HWwOAFFBHf0wIhbGMAUILl4Etf+xaM=;
        b=d/g8SWTIzu1mAdRAj3xoV+1B6shae7oektnolXhNMawkUg4m5p8/fa/yeHRmODCWKF
         zRAaJr1YRDlZ+uscHb8mWB+V9d2yCKtj5AzVva+ueFSgrI2m2Xx2CLC8rgv+cOkAyo1X
         JkA2Y2Y6JPftLfOICC7cBBIGtz5FbIAFolB4GfCd7yZFDa7qAtOuGPpQRzOVv1C16YWC
         qAr16SIwnAIBbu3H/SCbc/UMYSZPxWkU8yP1FDB8cdvFmuVZROSh2qM7MJbATv/SSaF5
         JJWIpJV/DUbV36obcPEt8FfH+fKlMK6BMTsr2u2RKlDEDafhuJE29uHTm9/U093SZtAa
         WmxA==
X-Gm-Message-State: AAQBX9epoUlgteKuYyVXBzpYyilkEljiRvewfSy/s63YG/6pe57IMfH8
	BU92OSaaEgz44XAEZko6hJs=
X-Google-Smtp-Source: AKy350atE/YK8xeOWPxEnBYau7lN2rbNThIlRZKxpoHVtBY0Iq/1BSox5hJ7WghB/cEHT2XXDpa4Jw==
X-Received: by 2002:a05:6a00:139f:b0:63b:8e12:7075 with SMTP id t31-20020a056a00139f00b0063b8e127075mr2246843pfg.31.1681877889814;
        Tue, 18 Apr 2023 21:18:09 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-1.three.co.id. [116.206.28.1])
        by smtp.gmail.com with ESMTPSA id e18-20020a62aa12000000b0063d37a45829sm1167463pff.63.2023.04.18.21.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 21:18:09 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 82DFE10673E; Wed, 19 Apr 2023 11:18:06 +0700 (WIB)
Date: Wed, 19 Apr 2023 11:18:06 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Tom Saeger <tom.saeger@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Yu Zhao <yuzhao@google.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Waiman Long <longman@redhat.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, Tejun Heo <tj@kernel.org>,
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
	Daniel =?utf-8?B?RMOtYXo=?= <daniel.diaz@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Darren Kenny <darren.kenny@oracle.com>,
	Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH 5.15 00/91] 5.15.108-rc1 review
Message-ID: <ZD9rfsteIrXIwezR@debian.me>
References: <20230418120305.520719816@linuxfoundation.org>
 <CA+G9fYs9sHnfhn4hSFP=AmOfgj-zvoK9vmBejRvzKPj4uXx+VA@mail.gmail.com>
 <bd46521c-a167-2872-fecb-2b0f32855a24@oracle.com>
 <20230418165105.q5s77yew2imkamsb@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="1l6DxsxNS5bMd6S1"
Content-Disposition: inline
In-Reply-To: <20230418165105.q5s77yew2imkamsb@oracle.com>


--1l6DxsxNS5bMd6S1
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 18, 2023 at 10:51:05AM -0600, Tom Saeger wrote:
> > Tom Saeger identified that the below commit moves it out of ifdef.
> >=20
> > commit 354ed597442952fb680c9cafc7e4eb8a76f9514c
> > Author: Yu Zhao <yuzhao@google.com>
> > Date:   Sun Sep 18 02:00:07 2022 -0600
> >=20
> >     mm: multi-gen LRU: kill switch
> >=20
> FWIW - partially backporting (location of cgroup_mutex extern) from:
> 354ed5974429 ("mm: multi-gen LRU: kill switch")
>=20
> fixes x86_64 build for me.
>=20
> Regards,
>=20
> --Tom
>=20
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 45cdb12243e3..460ba084888a 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -433,6 +433,8 @@ static inline void cgroup_put(struct cgroup *cgrp)
>         css_put(&cgrp->self);
>  }
>=20
> +extern struct mutex cgroup_mutex;
> +
>  /**
>   * task_css_set_check - obtain a task's css_set with extra access condit=
ions
>   * @task: the task to obtain css_set for
> @@ -447,7 +449,6 @@ static inline void cgroup_put(struct cgroup *cgrp)
>   * as locks used during the cgroup_subsys::attach() methods.
>   */
>  #ifdef CONFIG_PROVE_RCU
> -extern struct mutex cgroup_mutex;
>  extern spinlock_t css_set_lock;
>  #define task_css_set_check(task, __c)                                  \
>         rcu_dereference_check((task)->cgroups,                          \
> diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-inter=
nal.h
> index d8fcc139ac05..28c32a01da7d 100644
> --- a/kernel/cgroup/cgroup-internal.h
> +++ b/kernel/cgroup/cgroup-internal.h
> @@ -165,7 +165,6 @@ struct cgroup_mgctx {
>  #define DEFINE_CGROUP_MGCTX(name)                                       =
       \
>         struct cgroup_mgctx name =3D CGROUP_MGCTX_INIT(name)
>=20
> -extern struct mutex cgroup_mutex;
>  extern spinlock_t css_set_lock;
>  extern struct cgroup_subsys *cgroup_subsys[];
>  extern struct list_head cgroup_roots;

Yu, would you like to provide formal backport? Or maybe take Tom's
diff above and ACK it?

--=20
An old man doll... just what I always wanted! - Clara

--1l6DxsxNS5bMd6S1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZD9rfgAKCRD2uYlJVVFO
oxE1AP4/yqKP+7NfVKxZa3LJ3PAlg3lg8WKyBlBEhDzI2U/cWwD/a/+Hgb0Y/fqS
4SDj9K66itlA57r83DXzZFh4U2pXbAc=
=vtL5
-----END PGP SIGNATURE-----

--1l6DxsxNS5bMd6S1--
