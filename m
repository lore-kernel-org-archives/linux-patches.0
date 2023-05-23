Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E0863DA
	for <patches@lists.linux.dev>; Tue, 23 May 2023 03:55:27 +0000 (UTC)
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-64d3bc502ddso4525040b3a.0
        for <patches@lists.linux.dev>; Mon, 22 May 2023 20:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684814127; x=1687406127;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VYUV13lroZp21dQZ+l6oL2IK7f4ffhF2cxU5Id8N1nc=;
        b=TWA2auq8EoZHsc0IWEG+GTa1YYtelvjAkAyS75mXLBeO6ThewGIi+SOWxBdqV/g+a+
         kBeNBPR3ifUwvsqGOFPmxlmIb0uEyx0MiDBxm1uXubJ/ODqi5PqEYv8VmG7psMcG0Xyu
         WNfyfql0sQ4eajwlM9CF3pUNVj7LWRARg6DvSZsJX5goOwOp4HAykN3gQ4TYHARqViOE
         SwkTgZDa4r6f7Nfas2a32nbQCLOrLf5nRRVRrK/4RCPzWrG0RyET2bnMDuDyeMbaXTzC
         vj4qFE+i+mnyQSE9r66CQU0l+S6fozfPl+lvy2I8LotwctT5V14TCLk9VtT3hN6JiZMb
         VnVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684814127; x=1687406127;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VYUV13lroZp21dQZ+l6oL2IK7f4ffhF2cxU5Id8N1nc=;
        b=UXRewNcTMwhVbfSq3dR3XZh7XpWXnUScSTVw+pcwNyrr2OduOk6CYPD/lASdI8B5Qp
         jXxYRs/Qg6mXm76VT5h/OTnerhuTahXZqCxnAGBA/27Ezc0704rNoZzdfXkZdTMMLpL2
         Oi01ELZAXh7T3lvtgeYfWAlW8PlWgMsvS0xOSo+lzQUhXjoj5olE6g1nmhEP0kG39VOv
         O399dclRj3qIT1DrM4hDu1wqCoqzJg0p4apjPXEYbdKYxUPwYPsP0/EpKC9sNqW1RIUe
         /xRlckIPwsrYt/ER8c9KDy6x7gg/+X8o9EWCEu0JFLsjZNcH7IaIR9doDvXA9NtAbjHg
         LrIw==
X-Gm-Message-State: AC+VfDwmqmsBhfBDZQlPEzKiCqUO104P66Ukqo7l2oH5rANdJAiD9lmw
	gGjb7DQNpo3RhIZtFitlN04=
X-Google-Smtp-Source: ACHHUZ4yWm+Gds5T21fDkBCEa4+bbSuphFCPX5GkZtzDfhgq19xGuzk5abEXhDaLZTfchNY0HtwD4Q==
X-Received: by 2002:a05:6a20:9388:b0:109:2f11:8b77 with SMTP id x8-20020a056a20938800b001092f118b77mr14627725pzh.1.1684814126812;
        Mon, 22 May 2023 20:55:26 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-32.three.co.id. [116.206.28.32])
        by smtp.gmail.com with ESMTPSA id f17-20020a170902f39100b001a6b2813c13sm5617664ple.172.2023.05.22.20.55.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 20:55:26 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 716681069AF; Tue, 23 May 2023 10:55:23 +0700 (WIB)
Date: Tue, 23 May 2023 10:55:23 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.3 000/364] 6.3.4-rc1 review
Message-ID: <ZGw5K+jBGakV3drJ@debian.me>
References: <20230522190412.801391872@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gXelIhH+DZCq6xQ9"
Content-Disposition: inline
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>


--gXelIhH+DZCq6xQ9
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 22, 2023 at 08:05:05PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.4 release.
> There are 364 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--gXelIhH+DZCq6xQ9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZGw5JwAKCRD2uYlJVVFO
o88JAQDO6fCyEAOEgzx/1/IP3dyUgYGqaGkw6cH/IRxzCDDImAD+NpaBg/sZoXc2
U5OTNIsoOGL2huE/a7TdC25I8KKisgg=
=5vo3
-----END PGP SIGNATURE-----

--gXelIhH+DZCq6xQ9--
