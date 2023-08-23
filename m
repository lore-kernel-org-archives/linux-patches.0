Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC44A92F
	for <patches@lists.linux.dev>; Wed, 23 Aug 2023 09:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1692784742; x=1724320742;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gFxUMckI2v7jFgYeql0OzzXtc/2Ei26vmidT8NcZ22o=;
  b=LQq4TOYSxI3mQN6sXwif+iSnilo85ZbsmreRnJRL9ilEfsYjOZuZNjWW
   0imqVNOiU/iGSh6wN40yFcv0/ENRnVSm/26pM3zzN3igmnHfsMI6DIHqw
   733KIY3MmS+qtLLe9tfdoEpBfPC5XhmTEhM7QJGxTWX1ohyDC2hCFuVvy
   5bCLDuaW8/eORrobGxtVK3k8XMy9JKUmWghGzCO5r+5D0R1VvulUPJ5qa
   BaB8siIv/3Gr/4EANpUaBvOoQmhDgOWo+wlqjfz7/P0kg3fa4AnjLGOMN
   2+uMopu6B9jfR2o6AJGTClDExuT8kx3rWpTem1wtML4stFAExmvNX7Jrn
   A==;
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="asc'?scan'208";a="861930"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Aug 2023 02:36:38 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 23 Aug 2023 02:36:38 -0700
Received: from wendy (10.10.85.11) by chn-vm-ex02.mchp-main.com (10.10.85.144)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Wed, 23 Aug 2023 02:36:35 -0700
Date: Wed, 23 Aug 2023 10:35:54 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>
Subject: Re: [PATCH 6.1 000/194] 6.1.47-rc1 review
Message-ID: <20230823-washer-reemerge-a412d55f8214@wendy>
References: <20230821194122.695845670@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="pXya09AKMWXNOkqn"
Content-Disposition: inline
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>

--pXya09AKMWXNOkqn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 21, 2023 at 09:39:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.47 release.
> There are 194 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Fails to build for me with gcc-11/binutils 2.37 on RISC-V. The problematic
patch is "riscv: Handle zicsr/zifencei issue between gcc and binutils".
Can you drop that please, probably from all of your branches. It
certainly affects 6.4 too & I don't personally test anything older than
6.1.

Thanks,
Conor.

--pXya09AKMWXNOkqn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZOXS+gAKCRB4tDGHoIJi
0lIjAQCAXxzyZlxsLvJ/co5B/fwvnQ2+nvGmfR5rAt25sZZm6AEA0NwOCebLuEm6
vpa/zZTlngSh1n+gKsdvZT5CZzgkNQ8=
=j3oV
-----END PGP SIGNATURE-----

--pXya09AKMWXNOkqn--
