Received: from mx1.emlix.com (mx1.emlix.com [136.243.223.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4963F7B;
	Wed, 24 Aug 2022 05:24:02 +0000 (UTC)
Received: from mailer.emlix.com (p5098be52.dip0.t-ipconnect.de [80.152.190.82])
	(using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.emlix.com (Postfix) with ESMTPS id 913A860697;
	Wed, 24 Aug 2022 07:16:14 +0200 (CEST)
From: Rolf Eike Beer <eb@emlix.com>
To: Andrew Morton <akpm@linux-foundation.org>, Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH -next] mm: pagewalk: Restore err initialization in walk_hugetlb_range()
Date: Wed, 24 Aug 2022 07:16:11 +0200
Message-ID: <3830122.BTrY59CkKH@mobilepool36.emlix.com>
In-Reply-To: <20220823153055.2517764-1-nathan@kernel.org>
References: <20220823153055.2517764-1-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1700889.S5NpyQqGGO"; micalg="pgp-sha256"; protocol="application/pgp-signature"

--nextPart1700889.S5NpyQqGGO
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Rolf Eike Beer <eb@emlix.com>
Date: Wed, 24 Aug 2022 07:16:11 +0200
Message-ID: <3830122.BTrY59CkKH@mobilepool36.emlix.com>
In-Reply-To: <20220823153055.2517764-1-nathan@kernel.org>
References: <20220823153055.2517764-1-nathan@kernel.org>
MIME-Version: 1.0

Am Dienstag, 23. August 2022, 17:30:56 CEST schrieb Nathan Chancellor:

> Restore the initialization of err to zero so that it cannot be used
> uninitialized.

There are actually 3 places that need fixing. I'll send a patch in a minute.

Eike
--nextPart1700889.S5NpyQqGGO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iLMEAAEIAB0WIQQ/Uctzh31xzAxFCLur5FH7Xu2t/AUCYwW0GwAKCRCr5FH7Xu2t
/PA1A/9g/6sS6lDuyk38tf1/eHYl+I53B+DD3z2sWtdm1dXVvg7zDye2aW4AXtaE
4IpyTOHFQdMtpQ1Vj9wSNdh6F4dcwduma8KBaDM7ZWg9PJD6MrTfaYn1wsdtqiiW
JQeCpb5maLzf2vnF3ZHOCLLxb6AU5LLwd+qhg1wYYosoNKEhfg==
=YTMg
-----END PGP SIGNATURE-----

--nextPart1700889.S5NpyQqGGO--



