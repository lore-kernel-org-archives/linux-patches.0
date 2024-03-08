Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FB92209E
	for <patches@lists.linux.dev>; Fri,  8 Mar 2024 13:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.153.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709904719; cv=none; b=kdK6QxZqyM4tm0I1eKIbkjMZ86srDzgrzt1i2/9p5ecooNHFAV6aZRkbD9k0jbrbVldh+KaFYHvDqMMEJzqgRelEleOe2jSxYJgr+AdIofST0YmROhcELopKXfi73Z2+3lnJ/u1R3P+dyl1bOEFa0K9kAsg7PtbeezsT41bdUpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709904719; c=relaxed/simple;
	bh=VRiN8CKS3sh1wMvDsax50mAoOBJo3MCRXqXUv0ang2U=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uyYEN3fFDEcUkg1yG8eGXLbecvHMe1FjJwbka7/eB5g8DRb/KhIV1VqaiNb/Z+l7D38ZEN/q26y6cwH/p8AJLxbR05e2vSkaOhUE9nHQQf87NCvn/n6Uoy7l2w6FzefchzSna08bP76/bRf609Crq2hTITwRvMFGnjCP6L6Vq7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=K+7Kl1jQ; arc=none smtp.client-ip=68.232.153.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="K+7Kl1jQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1709904716; x=1741440716;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VRiN8CKS3sh1wMvDsax50mAoOBJo3MCRXqXUv0ang2U=;
  b=K+7Kl1jQBVaco1bkKh5N+d3JtB9ehhpPAd/CbbhKsuhtlA8BN8m4xc78
   +x0HJnjzTFC9dDxcIbXcL73QPjqDsTjcPq8KHyMO3kXSBSIY0v0/7dAY7
   xzTaoWWGgUsrNg6cyOZSKFhZLk4rAHHDo6DCFRZfZAphBaAHFR6v8GGoy
   w2/u+pmw6Zpj9C5j49fuiU9rdoKmZqxS36sCRz6GhViKN402FRm9n35Hp
   UBMpHZN+e8gzQLpxolA9lnv4kirlYUOcApHbeUafGEcXUQPy83xmTHUOE
   +Wth+4bA6GHZKhc8+p3FiThOddbtz4XrKu+tYaUErvil+TQLWEDBJlaHT
   A==;
X-CSE-ConnectionGUID: 14jFhm6gRRWLoLmFhY4w/Q==
X-CSE-MsgGUID: DOI968ShSd6ruVMdhr/kkw==
X-IronPort-AV: E=Sophos;i="6.07,109,1708412400"; 
   d="asc'?scan'208";a="19066625"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Mar 2024 06:31:53 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 8 Mar 2024 06:31:53 -0700
Received: from wendy (10.10.85.11) by chn-vm-ex01.mchp-main.com (10.10.85.143)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Frontend
 Transport; Fri, 8 Mar 2024 06:31:50 -0700
Date: Fri, 8 Mar 2024 13:31:05 +0000
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>,
	<allen.lkml@gmail.com>
Subject: Re: [PATCH 6.7 000/161] 6.7.9-rc3 review
Message-ID: <20240308-upstate-unfixable-fed1854c1bb0@wendy>
References: <20240305112824.448003471@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="zZw4yvtNimRxhiAJ"
Content-Disposition: inline
In-Reply-To: <20240305112824.448003471@linuxfoundation.org>

--zZw4yvtNimRxhiAJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 05, 2024 at 11:28:47AM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.9 release.
> There are 161 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Clearly I am rather late, but I did get around to testing this one
yesterday.
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--zZw4yvtNimRxhiAJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZesTGQAKCRB4tDGHoIJi
0kX4AQCv00O2M6yh5MtQrgDk3ZQuEa0ffaeAI3tB/F6RASqF+wD/aHhZZiGmAaOZ
1QHCx7+UHu/ugZIzv2QL0+jpxwSt+gc=
=drbk
-----END PGP SIGNATURE-----

--zZw4yvtNimRxhiAJ--
