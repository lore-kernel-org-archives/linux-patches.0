Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27B01DC997
	for <patches@lists.linux.dev>; Wed, 22 Oct 2025 02:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761099366; cv=none; b=S/LJ+CxQel5cf3wajKp2pm/BMOm7zLc5GV9qn+N8tWsRlt/DhgMu5CMEXcfZcFCsTmZiFaTnOTQDOTrK+1jPIJ88P0Tn4pQWEu94fP6bhVGYpAqrSf1sCcrVlau5L+ZDgcqZDk2h15P5jtjRtL5L4sp9a9GInwocbsHrQFepNSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761099366; c=relaxed/simple;
	bh=ZNYpaJWfK2uX7fNuNpV/cydFuI7wkAz8CLs/mB6yfTU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UNLMcCd4Xl/k2icNdV9r+jEV86tHLQdwOSXtkceyThSdOUEuJ8t8ZoUrpUoiw56cGb+iL2KOC5Adnd+TuEdq2lJcEtJipyo/CPdmGgcVoneOhIiABYRvZzoMN57nf6bil1CmLPSRRwzMo9Cflc+z510QR4YJDJQJVUEZF2ogc88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b6t3V04T; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b6t3V04T"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-781ea2cee3fso5631005b3a.0
        for <patches@lists.linux.dev>; Tue, 21 Oct 2025 19:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761099363; x=1761704163; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+yFbQwKVrg4ulSzHTYcdE0/YBPiD7WzPZ8N0zJ6yfUg=;
        b=b6t3V04T9h5AMwapuA+RCe3WfLcBHV+hoLXYXWB3o36Y7dHLcGQlHRx5tZ3sM/Ur6X
         zVrHkVfzX24q9cymjNsjkijCD6vzOwuweqYS/MKzIxzS4Vt0bKAlRWnrW/qJ0FHBKq3S
         2AZpWGg50JH2kF0admTV65NmEcqAONxTqkzVhSNjG/eL4xlwdFHja+l1rWy3LskBJoFw
         RkJKiAF3ABLnCQgtWwTkg8mHI9rSAGRz/S362CxYnewsVSe/kXZj+IRmZgS6yMOY6bph
         YaA9HI0PfQhzXMvJb5o0yHIPxBNdGLztALpg2/VSctIcJihSKlqeWTjgI29TyfQxP/Um
         H7rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761099363; x=1761704163;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+yFbQwKVrg4ulSzHTYcdE0/YBPiD7WzPZ8N0zJ6yfUg=;
        b=MlU8vQy5qh7UlwYn8vC9o99Z9LzqUxNDTvnhYYZ28oqeM2KirtMzbchJtSGO90tYkV
         swfA0pNbmmosudxSjg00TNwxpEuaskMdnJRRAmIcMoutloiIgKUtKUOIL9kUbCs1I5y0
         IvTPCc9JLjm/uxXtdd/PIbdmylK6Q+3sW4Afbgz9dye6MEuv8Jm0/uvURZzLcuWxSk3b
         qwfV01RFEhSQe9VIxPaeTYrn6ryAX95QSUPwEO6rTQX4/9FHse+ryqYK/9fJNyTV6Z3q
         Iv7gtsjcyV+VQ78QN9Kb/LYtO7eiudISQuWZ73mp5+VnifrLb5Qh0K3sUZXz6Egv7MJk
         Dstg==
X-Forwarded-Encrypted: i=1; AJvYcCWcIroHcAre9+/vtd9bzvfNYRwOQCnC3oovzyiyWSeGB78R7PpgriRPN5q/m2H1qj9ObFpzbR2B@lists.linux.dev
X-Gm-Message-State: AOJu0YyBNxIorMvE2fI1f8tvK1wKUG2nTMAWPFWln7vCOfRb+M11Vdn+
	YebiDIzMNqtBGNmjQu1mxCo569CjaiuwXMcw8wmQtn60XWJC+aGepW1y
X-Gm-Gg: ASbGncsvRpAV1ExAzCZs5Q/M7WqCDLpfOEcTl1Iq56j9g9TjLsuM2v6tdYSK2dpovHv
	cSKOOx0gBkAMACrmVW0/oCXJPe3gSIOd5sbYn2mQ727ChsMpS4jd3iualhTw1cdWWgwaLWQBdqA
	CrKBkpn3ZxCDFj5tyc4Dybo+yC+to0h+1UvuVEYgtA2GwBFMDarP8K4CYYxgI/ggrY/v40rr+Jf
	tqRANfOUbK4TIuYStJKKFpoHm+bDfegcawIiWvP34oNlsZxDSuHpSA8XjV6Itv4zxRGgJP5simX
	oxecuKpaz/EdGfoJ3Xnpt7leXiRLv3+1jcLjGt8zCJ48aFStnDcyRzCgD81/PhWyWBZM0IiPHFu
	pybcnqCY7S4qkepPVqOuBJ9rjijhWIUk0jod+v4Qxq+/Z9PKyDoINbu2kLSvqqj40ZQBjkP4Ylq
	fsxFh8eW0RNwjR
X-Google-Smtp-Source: AGHT+IHgcLczGY0gNkz46ZH3wqYDdp+xytg9WZxLoXNNek71M0Z3I+LEtQXMo7LSXlQTlq9C1XGtow==
X-Received: by 2002:a05:6a20:5493:b0:304:4f7c:df90 with SMTP id adf61e73a8af0-334a861852amr26222250637.50.1761099363079;
        Tue, 21 Oct 2025 19:16:03 -0700 (PDT)
Received: from archie.me ([103.124.138.80])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a23010da0bsm12753936b3a.55.2025.10.21.19.16.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 19:16:02 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 48C344209E4B; Wed, 22 Oct 2025 09:16:00 +0700 (WIB)
Date: Wed, 22 Oct 2025 09:16:00 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Askar Safin <safinaskar@gmail.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Julian Stecklina <julian.stecklina@cyberus-technology.de>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Art Nikpal <email2tema@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>, Rob Landley <rob@landley.net>,
	Lennart Poettering <mzxreary@0pointer.de>,
	linux-arch@vger.kernel.org, linux-block@vger.kernel.org,
	initramfs@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
	Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <kees@kernel.org>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Heiko Carstens <hca@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
	Dave Young <dyoung@redhat.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Borislav Petkov <bp@alien8.de>, Jessica Clarke <jrtc27@jrtc27.com>,
	Nicolas Schichan <nschichan@freebox.fr>,
	David Disseldorp <ddiss@suse.de>, patches@lists.linux.dev
Subject: Re: [PATCH v3 2/3] initrd: remove deprecated code path (linuxrc)
Message-ID: <aPg-YF2pcyI-HusN@archie.me>
References: <20251017060956.1151347-1-safinaskar@gmail.com>
 <20251017060956.1151347-3-safinaskar@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="m/ueW+980/ea0Wf8"
Content-Disposition: inline
In-Reply-To: <20251017060956.1151347-3-safinaskar@gmail.com>


--m/ueW+980/ea0Wf8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 17, 2025 at 06:09:55AM +0000, Askar Safin wrote:
> +		if (rd_load_image()) {
> +			pr_warn("using deprecated initrd support, will be removed in Septembe=
r 2026; "
> +				"use initramfs instead or (as a last resort) /sys/firmware/initrd; "
> +				"see section \"Workaround\" in "
> +				"https://lore.kernel.org/lkml/20251010094047.3111495-1-safinaskar@gm=
ail.com\n");
>  		}

Do you mean that initrd support will be removed in LTS kernel release of 20=
26?

Thanks.=20

--=20
An old man doll... just what I always wanted! - Clara

--m/ueW+980/ea0Wf8
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCaPg+YAAKCRD2uYlJVVFO
o9OtAQCr/giTF4+FVt9hiDGkb1l4yn/kE0D0NKGYI1gigRnAqAEAhLIU0ssllGOB
IgSBphGX7ddV9bgZvHiqagtFYOgJwwo=
=plLG
-----END PGP SIGNATURE-----

--m/ueW+980/ea0Wf8--
