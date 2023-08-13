Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40D964A;
	Sun, 13 Aug 2023 11:03:28 +0000 (UTC)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id AC51F40E0185;
	Sun, 13 Aug 2023 11:03:25 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 5C8xwSiMocF3; Sun, 13 Aug 2023 11:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1691924603; bh=NElFY/m1+ArvR7Gho78vQn1P8OB5nFajoABT/fHSVYA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MRlyieZkkSnHX2qmgUCdPajG3wE+LhKL9EsOB5ghL6RcBk7UjCyxuTsq54EXTR82A
	 lf9MoTnC2aO9NLeAktosNGdKOdbzw8mILDzR76SatBUFdFULvrxWMI38b1ObZL4N92
	 yYnINJkF2fNHWIA8UCNzh7FW/TNhpFDX3Ri0m0hq8l36VOm4Q/VPfWAgNe0tTN7jCY
	 MDTYvlC6o97swoJ0GkuP2zQV+SJO86xRDHUTeJMUPSlWJqQfPPzicavmrxl4ZqlWih
	 /Z+nbuMxVqUH/LZ1Ao4WzaKbVstz+bzCnhQzXr8g1IeX5cWqMKMZ2ec+AYzmaIckJ/
	 MnzW/w3ZNECsSqzEFPyYZX+AZGlfv/R69CHqs/KH0cSI+wP8QLBTTSHjRUGNd6Lr9t
	 lFh1aqt1gLVWpwjTBlPEXEQon4Hd7/B0GW6uHk0ga6UUW+F7NJibcEm4K8Y5STsD/z
	 f+eMkUXc9zmL1radgTCguaJY9+Yv3bDYq24QcnMixrdrnM+e/rXWYNYVdTlKt+SjXM
	 noGRqPmEOcIJHzYFD/LV2VrMSrQuMqUwQXFJ1qiHMklqz37BwSGHLZ6MgX3QcY5A2w
	 3w7xDqv05uSIbUskK7k6MBVlYdmmeT/b7xhmnypBZwnkwta0R3hZxu2+vn9ievDLuI
	 weBr1CoqeYEuDDIBgiPug//Y=
Received: from zn.tnic (pd9530d32.dip0.t-ipconnect.de [217.83.13.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3F03740E00B0;
	Sun, 13 Aug 2023 11:02:59 +0000 (UTC)
Date: Sun, 13 Aug 2023 13:02:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	clang-built-linux <llvm@lists.linux.dev>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	Nick Desaulniers <ndesaulniers@google.com>,
	Sven Volkinsfeld <thyrc@gmx.net>,
	Daniel Kolesa <daniel@octaforge.org>, x86@kernel.org
Subject: Re: [PATCH 6.1 000/127] 6.1.45-rc1 review
Message-ID: <20230813110254.GDZNi4XhHjY4xlNdBJ@fat_crate.local>
References: <20230809103636.615294317@linuxfoundation.org>
 <CA+G9fYvQdQqTqCgbS4sit_Y2AtKtDiWMOkGZjoeSEFhc=M_jKw@mail.gmail.com>
 <078d6e3d-9572-a624-2c5a-e2d58473e6d0@roeck-us.net>
 <20230811041339.GA193223@dev-arch.thelio-3990X>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230811041339.GA193223@dev-arch.thelio-3990X>

On Thu, Aug 10, 2023 at 09:13:39PM -0700, Nathan Chancellor wrote:
> 1911 is still being investigated (some additional eyes on it would not
> hurt).

I'm hoping that we can take this one:

https://lore.kernel.org/r/20230809072200.543939260@infradead.org

which should resolve this issue, right?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
