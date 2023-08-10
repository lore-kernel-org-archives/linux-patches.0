Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D118422EF0
	for <patches@lists.linux.dev>; Thu, 10 Aug 2023 10:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1691663430; x=1723199430;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KHNhJ8wIRQzxKkGQXQ2id5gPJS7AognrfbDYBi13We4=;
  b=LQqMEve31ls1S1PWWzEqDhimynvh2F1EMQOzIuuuDRQKsVwhwyL7rLEZ
   nhxkT/dZiRr2SyUtS8aeTABe6sRVCLVnPOwvK7+Eu45HPmvf+uLpXcv+U
   d22YXOxUJcgB+PfL0mOnLV9AOcJM6uCPdRavRngIrAUd0IisnWSJhmbl5
   BzxfGaNDBCWrXTkDdm+uhe9PevLpdkfzPXX4eXRgqrMh+xI8sa4av0nda
   kM9OVJ1bN53l62hcjVTnulJn8K9DoYQsXHE+m3Jcw0DZV0C2SwWVmB54h
   8SngnxuZW0s/WJ4uVoZPYNt45vvz64wAI6BWFnESGxTCngrRF1bTKdqy/
   A==;
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="asc'?scan'208";a="165807440"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Aug 2023 03:29:20 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 10 Aug 2023 03:29:16 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Thu, 10 Aug 2023 03:29:13 -0700
Date: Thu, 10 Aug 2023 11:28:36 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>
Subject: Re: [PATCH 6.1 000/127] 6.1.45-rc1 review
Message-ID: <20230810-estrogen-tamale-61beeb1f5f05@wendy>
References: <20230809103636.615294317@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="S4iBG1PC4gJAxsGe"
Content-Disposition: inline
In-Reply-To: <20230809103636.615294317@linuxfoundation.org>

--S4iBG1PC4gJAxsGe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 09, 2023 at 12:39:47PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.45 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--S4iBG1PC4gJAxsGe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZNS71AAKCRB4tDGHoIJi
0oBoAPsEKD8DhdPcCOEoDAGN8NTZGo33vuALblAp/znrcrLAPgD+Lh3Kh7Pxi97g
NVXyOxxui+KhNtkyvvDua152TFgsZwc=
=ifbY
-----END PGP SIGNATURE-----

--S4iBG1PC4gJAxsGe--
