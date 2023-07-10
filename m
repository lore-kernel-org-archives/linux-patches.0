Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB29E23B3
	for <patches@lists.linux.dev>; Mon, 10 Jul 2023 05:32:08 +0000 (UTC)
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6689430d803so1990838b3a.0
        for <patches@lists.linux.dev>; Sun, 09 Jul 2023 22:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688967128; x=1691559128;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xZq+Hz2DVjmoDUQM0f90c2lbY2SLTyJDQfq3fBqLjkw=;
        b=sz6TrAumUip4aqI9GNBXa+tm5Y04pfzFRl0h0y+Gk+yWS2OZ8jYhkOGq/ct7x8u/Z4
         s8Xf+aBQ9byGEHsoHHAnQqb5FAfZsCz5ADeD2xGryCFCurscL5mkDG48KJCIC1rkqxXB
         WPEdHtC3teWr3+Ig6wykTdd5gJtLyMmNOU7tx0kTggwIwfrYfFp4iKwOoeHvn4x+t0r2
         jZOW8JeD7z/DICTcINlpdCmED/SB5KdBvJCF9nEsDNLz7QMUnhCH75O1SqE6oVOyxf+U
         a+HwqtYXuS84Ni98TxDwQTcUI8+to+djaJIRhCQC43PlQcOJPujJrHnc1NCFUTI1MInf
         cIwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688967128; x=1691559128;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xZq+Hz2DVjmoDUQM0f90c2lbY2SLTyJDQfq3fBqLjkw=;
        b=CZ1X2Zj0PQJWnHEBjBD136t1+n9c/lWsxZgkRC+4cpsPIqN5CuvbqdHpnLGNvlyqfw
         LmO0Tw80vHoHm2EfR4AYP3lExTXdM4yMrPjMe2xRBaQN4DoGL1sbHAvR9kB5WaJfulZr
         pgm60XdKB35zjGb0JAo+O1L/J6xKOhSAI3dxhkswPuzDCWt6t36Gcn5Y+Q6fOw3m6Pxb
         wUL74IzXdBC/RYUmZcsHQgFTv3DXOjvw2H7QIAqBSWmpbnV1vZU2kdUcM6EP4CnJLNkG
         BE/ZAMoIFSGZkT2titIoD95LaKecfBPv+IdpSzApTzEOlX1k5i/EZ6F9KptZLkSAzAHe
         bENA==
X-Gm-Message-State: ABy/qLbQ9b3zYtyJeDiHBo2/j7kKriOstS/r5n0mH4B+nms42ZWbeL0/
	m5JO06pXjFvveq/HgrmxnXw=
X-Google-Smtp-Source: APBJJlHT4TVWDELt5QfX9k+VIh4sRV7vHhUQSonOcWQsrQTbt0453kd9DdfLrSieVAQGKdfO+j4hbQ==
X-Received: by 2002:a05:6a20:4424:b0:131:dd92:4805 with SMTP id ce36-20020a056a20442400b00131dd924805mr1251390pzb.57.1688967127906;
        Sun, 09 Jul 2023 22:32:07 -0700 (PDT)
Received: from debian.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id z3-20020a63b043000000b0055bc21caa09sm6491247pgo.77.2023.07.09.22.32.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jul 2023 22:32:07 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 7EEE58208E71; Mon, 10 Jul 2023 12:32:02 +0700 (WIB)
Date: Mon, 10 Jul 2023 12:32:02 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.4 0/6] 6.4.3-rc2 review
Message-ID: <ZKuX0gSlKFnSITOi@debian.me>
References: <20230709203826.141774942@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="AjhBD/Ows7aw9aei"
Content-Disposition: inline
In-Reply-To: <20230709203826.141774942@linuxfoundation.org>


--AjhBD/Ows7aw9aei
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 09, 2023 at 10:45:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.3 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--AjhBD/Ows7aw9aei
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZKuXzAAKCRD2uYlJVVFO
o91DAP4sMRRejEh4mQ9Ejbh8eUPw0EiK30tmOk5cKYkbGldaHAD/c8Em6JEDHTqv
/K+qBIzh2OnBYmhVchMpveU+lBup2go=
=NpJm
-----END PGP SIGNATURE-----

--AjhBD/Ows7aw9aei--
