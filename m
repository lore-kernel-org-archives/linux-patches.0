Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05ACCA52
	for <patches@lists.linux.dev>; Fri, 25 Aug 2023 12:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1692965890; x=1724501890;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pKrWa/+guseK12hSWiHg8JwVCS7BT39n7+hjvajt3Hs=;
  b=VS03x/pPUQAEWSAWxjG5mIqKP7tf3Z4x/DBajLnX//UsvYc7a8EV1J69
   8BQs/K/IcVYnEg8vEKH3SoJ4xl+9fc1hub/OVW7OIKX63v/Ek3i75ySoo
   hbNggfzoG79i5KlDhfV38UwIJNKFUBFbZY0iYpBP4Lol9dfB+/du9JQTV
   Og9awrLSk2YIIaqMtHyg4KJKzFamSWS17DTrgNj7kEadQQ+vwT7U96BwN
   U3TmGTKA6xRwrm0HoyHgHvuO014CeWyvANLqQgYInsbcxSKafW+87w/sf
   ettp8Zvg7ekqTqrCDNdCjHuWrN89WtuVDzVxw8XYjVflV2BakkmACqxO2
   Q==;
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="asc'?scan'208";a="168288541"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Aug 2023 05:16:56 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 25 Aug 2023 05:16:51 -0700
Received: from wendy (10.10.85.11) by chn-vm-ex02.mchp-main.com (10.10.85.144)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Fri, 25 Aug 2023 05:16:48 -0700
Date: Fri, 25 Aug 2023 13:16:07 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>
Subject: Re: [PATCH 6.1 00/15] 6.1.48-rc1 review
Message-ID: <20230825-radish-gong-b42f53b3e6ad@wendy>
References: <20230824141447.155846739@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="nkFZEeQSBoq7Dahz"
Content-Disposition: inline
In-Reply-To: <20230824141447.155846739@linuxfoundation.org>

--nkFZEeQSBoq7Dahz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 24, 2023 at 04:14:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.48 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

SRSO mitigations are probably not in the slightest bit relevant for me,
but I didn't get a chance to retest the previous stable release after
the build got unbricked for RISC-V, so:
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Fix for the build issue I saw should be on it's way to Linus today, so
I guess the original fix you were backporting & its fix should end up
back in your queue soonTM.

Thanks,
Conor.

>=20
> Responses should be made by Sat, 26 Aug 2023 14:14:28 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.48-=
rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.1.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h
>=20
> -------------
> Pseudo-Shortlog of commits:
>=20
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 6.1.48-rc1
>=20
> Borislav Petkov (AMD) <bp@alien8.de>
>     x86/srso: Correct the mitigation status when SMT is disabled
>=20
> Peter Zijlstra <peterz@infradead.org>
>     objtool/x86: Fixup frame-pointer vs rethunk
>=20
> Petr Pavlu <petr.pavlu@suse.com>
>     x86/retpoline,kprobes: Fix position of thunk sections with CONFIG_LTO=
_CLANG
>=20
> Borislav Petkov (AMD) <bp@alien8.de>
>     x86/srso: Disable the mitigation on unaffected configurations
>=20
> Borislav Petkov (AMD) <bp@alien8.de>
>     x86/CPU/AMD: Fix the DIV(0) initial fix attempt
>=20
> Sean Christopherson <seanjc@google.com>
>     x86/retpoline: Don't clobber RFLAGS during srso_safe_ret()
>=20
> Peter Zijlstra <peterz@infradead.org>
>     x86/static_call: Fix __static_call_fixup()
>=20
> Borislav Petkov (AMD) <bp@alien8.de>
>     x86/srso: Explain the untraining sequences a bit more
>=20
> Peter Zijlstra <peterz@infradead.org>
>     x86/cpu: Cleanup the untrain mess
>=20
> Peter Zijlstra <peterz@infradead.org>
>     x86/cpu: Rename srso_(.*)_alias to srso_alias_\1
>=20
> Peter Zijlstra <peterz@infradead.org>
>     x86/cpu: Rename original retbleed methods
>=20
> Peter Zijlstra <peterz@infradead.org>
>     x86/cpu: Clean up SRSO return thunk mess
>=20
> Peter Zijlstra <peterz@infradead.org>
>     x86/alternative: Make custom return thunk unconditional
>=20
> Peter Zijlstra <peterz@infradead.org>
>     x86/cpu: Fix up srso_safe_ret() and __x86_return_thunk()
>=20
> Peter Zijlstra <peterz@infradead.org>
>     x86/cpu: Fix __x86_return_thunk symbol type
>=20
>=20
> -------------
>=20
> Diffstat:
>=20
>  Documentation/admin-guide/hw-vuln/srso.rst |   4 +-
>  Makefile                                   |   4 +-
>  arch/x86/include/asm/entry-common.h        |   1 +
>  arch/x86/include/asm/nospec-branch.h       |  28 +++---
>  arch/x86/kernel/cpu/amd.c                  |   1 +
>  arch/x86/kernel/cpu/bugs.c                 |  28 +++++-
>  arch/x86/kernel/static_call.c              |  13 +++
>  arch/x86/kernel/traps.c                    |   2 -
>  arch/x86/kernel/vmlinux.lds.S              |  20 ++--
>  arch/x86/kvm/svm/svm.c                     |   2 +
>  arch/x86/lib/retpoline.S                   | 141 ++++++++++++++++++++---=
------
>  tools/objtool/arch/x86/decode.c            |   2 +-
>  tools/objtool/check.c                      |  21 +++--
>  13 files changed, 182 insertions(+), 85 deletions(-)
>=20
>=20

--nkFZEeQSBoq7Dahz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZOibhwAKCRB4tDGHoIJi
0ir9APwJNOqXyqbbaUtHMlbqI/DUrcQjWxsS98/PmHK//Tp7JgEAyhMga4q+QApr
kaPHLpoRzYPdyy8r/pOeGIvbCdPg3A4=
=tUo8
-----END PGP SIGNATURE-----

--nkFZEeQSBoq7Dahz--
