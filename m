Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9555680
	for <patches@lists.linux.dev>; Wed,  1 Nov 2023 09:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MDsBqIfi"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1cc2f17ab26so33267785ad.0
        for <patches@lists.linux.dev>; Wed, 01 Nov 2023 02:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698831797; x=1699436597; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2A7Y/11whjGsMhAiEp81xRL7zeK5hRlJmAi1MKSmNLM=;
        b=MDsBqIfibPUOY5ISsSxuKGOs+wWP85H07qiqNvlhtZoZ/YF7SyALxqrUppr4ih+sqz
         r0H/tct5FcL3mAFFXUqGzlFsbhKOR8aGZ+KbIGb8u5XQKSylo/VQvzwS90d4lN0YIurR
         6WsMFbazq0GFDkTfLZM9EcCA0FSoVXC4Yvp+I8j9wVS1J9nhiAsjbjNPAt60YZ3UrUmq
         5/Pl7rYxPysXjhywSNc/BrfP+FZ+Hh4gOPYhrfzBw44FP9B29PROJvymsYa6bCaY3zBe
         xEMz6PWAyevUaezFZm7fsKW2kCBELyiuhOdzDuLXCwMQ9/4a7zcII7GvndLfIMQBbzGN
         uyKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698831797; x=1699436597;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2A7Y/11whjGsMhAiEp81xRL7zeK5hRlJmAi1MKSmNLM=;
        b=JJSA2A3Ivy+vu/1ozZcKGVzv89IJDL4ynFa0Qao48whPdTJAPTB3+jhCtmJOWZwzI5
         9V7t4rcakU3Wu5u1mv1ytgIBiTXYn0etbuM76JisTOCefck2Eipp0/4U54IvK9xsk/FS
         YVbVPNVLpnB6IGmzjofnaEsiyGxtoLNsoNZz3V4x/EKOjwuVAku3xHTCpzW9FpZakMLF
         Vl37csfXWZn3mpNYH7pvQmjAfWc4GNfOvqqLlQAXZxD/JBzf3kpG0Sv5YI5ilhFYNzdW
         vVAWPk+/7zwhhCA5OhOTDvRVWNrxLcspZj+bWBRhfwe1iVu83ZYAOgj0I185lc2CZI3Q
         zISw==
X-Gm-Message-State: AOJu0YwX0sy8QT2dcRVw4run6OsXWZVm9hO2T2U34STahAO4G7w6rTtb
	2onluEg7WZb9kste71xT4qM=
X-Google-Smtp-Source: AGHT+IGT4O+L81nSAQ1uLW6groCXyS4JSYmHYensOGSr/USkULHyEEJ53PQy564JiPHsQnCSCV9Ktg==
X-Received: by 2002:a17:902:d4c2:b0:1cc:5aef:f2cf with SMTP id o2-20020a170902d4c200b001cc5aeff2cfmr6986814plg.9.1698831797023;
        Wed, 01 Nov 2023 02:43:17 -0700 (PDT)
Received: from debian.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id h18-20020a170902eed200b001b3bf8001a9sm990713plb.48.2023.11.01.02.43.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Nov 2023 02:43:16 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id A3A8997EF4A3; Wed,  1 Nov 2023 16:43:13 +0700 (WIB)
Date: Wed, 1 Nov 2023 16:43:12 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>, x86@kernel.org
Cc: Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH] x86/resctrl: Fix unused variable warning in
 cache_alloc_hsw_probe()
Message-ID: <ZUIdsK5LGmRww9ER@debian.me>
References: <20231031220534.37730-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/kDkZH0oq/bEChkj"
Content-Disposition: inline
In-Reply-To: <20231031220534.37730-1-tony.luck@intel.com>


--/kDkZH0oq/bEChkj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 31, 2023 at 03:05:34PM -0700, Tony Luck wrote:
> In a "W=3D1" build gcc throws a warning:
>=20
> arch/x86/kernel/cpu/resctrl/core.c: In function =E2=80=98cache_alloc_hsw_=
probe=E2=80=99:
> arch/x86/kernel/cpu/resctrl/core.c:139:16: warning: variable =E2=80=98h=
=E2=80=99 set but not used
>=20
> Fix by switching from rdmsr() to rdmsrl() using a single u64 argument
> for the MSR value instead of the pair of u32 for the high and low
> halves.
>=20
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> This has been annoying me for a while as the only warning from the
> resctrl code when building with W=3D1.
>=20
> N.B. compile tested only. I don't have a Haswell system to check this wor=
ks.
>=20
>  arch/x86/kernel/cpu/resctrl/core.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/res=
ctrl/core.c
> index 19e0681f0435..4084131d391d 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -136,15 +136,16 @@ static inline void cache_alloc_hsw_probe(void)
>  {
>  	struct rdt_hw_resource *hw_res =3D &rdt_resources_all[RDT_RESOURCE_L3];
>  	struct rdt_resource *r  =3D &hw_res->r_resctrl;
> -	u32 l, h, max_cbm =3D BIT_MASK(20) - 1;
> +	u32 max_cbm =3D BIT_MASK(20) - 1;
> +	u64 l3_cbm_0;
> =20
>  	if (wrmsr_safe(MSR_IA32_L3_CBM_BASE, max_cbm, 0))
>  		return;
> =20
> -	rdmsr(MSR_IA32_L3_CBM_BASE, l, h);
> +	rdmsrl(MSR_IA32_L3_CBM_BASE, l3_cbm_0);
> =20
>  	/* If all the bits were set in MSR, return success */
> -	if (l !=3D max_cbm)
> +	if (l3_cbm_0 !=3D max_cbm)
>  		return;
> =20
>  	hw_res->num_closid =3D 4;

No noticeable regressions on my Acer Aspire E15 (the laptop uses Intel Core
i3 Haswell), thanks!

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--/kDkZH0oq/bEChkj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZUIdqgAKCRD2uYlJVVFO
o7upAQChP7LAJsVZ5cqzDRXlqbqiXTpUB/Z1skpOBG/2zdp9JQEArZ7+m7m+fKJv
+QWUOzcotSAdWID8x86Qxj8mNM+kuQc=
=nlab
-----END PGP SIGNATURE-----

--/kDkZH0oq/bEChkj--
