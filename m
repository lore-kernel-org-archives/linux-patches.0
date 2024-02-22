Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D469364B3
	for <patches@lists.linux.dev>; Thu, 22 Feb 2024 09:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708592419; cv=none; b=VXDREvUy/3rl6VLXjcu2dbES7bJKzJYZzzo70W+hre+HraOSe4VfcNudZUAjrdwuB3abuQfYk3k2ke+Gfcg0EpO1om/nKs8jr693CuZByr5BBXG9ZVbnqkb3lcPt4TgIUO6kGhYLMT1f4DeVj/JsqQozbmat+TziNVGjH3zSJmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708592419; c=relaxed/simple;
	bh=9MXRsYld5gcuz4m2kWsdfnPBgyE1kvb6DCbkC5BZlSs=;
	h=From:In-Reply-To:Content-Type:References:Date:Cc:To:MIME-Version:
	 Message-ID:Subject; b=OwNTyYQr+Cj2ylcs8XzdmxD5pE2o3FhDeA+Otb+tvRfwtVGl3wuNuARpH12k6lBmcl7+VEJoDDoxB93ZGTjm+wSwPCCCSQFWFv61Mpgt57c1pVTGRg++rJ5zgpXjSK77tZ1BuHPByTSqO2HFFtqbKaEkP3ob29qDmlMz41LP5kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; arc=none smtp.client-ip=46.235.227.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Received: from harlem.collaboradmins.com (harlem.collaboradmins.com [IPv6:2a01:4f8:1c0c:5936::1])
	by madrid.collaboradmins.com (Postfix) with ESMTP id AFBF537820C7;
	Thu, 22 Feb 2024 09:00:07 +0000 (UTC)
From: "Shreeya Patel" <shreeya.patel@collabora.com>
In-Reply-To: <20240221125951.434262489@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
X-Forward: 127.0.0.1
References: <20240221125951.434262489@linuxfoundation.org>
Date: Thu, 22 Feb 2024 09:00:07 +0000
Cc: stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <10af46-65d70d00-1-46243c80@141388435>
Subject: =?utf-8?q?Re=3A?= [PATCH =?utf-8?q?6=2E7?= 000/313] 
 =?utf-8?q?6=2E7=2E6-rc2?= review
User-Agent: SOGoMail 5.9.1
Content-Transfer-Encoding: quoted-printable

On Wednesday, February 21, 2024 18:31 IST, Greg Kroah-Hartman <gregkh@l=
inuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.7.6 release.
> There are 313 patches in this series, all will be posted as a respons=
e
> to this one.  If anyone has any issues with these being applied, plea=
se
> let me know.
>=20
> Responses should be made by Fri, 23 Feb 2024 12:59:02 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7=
.6-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc=
.git linux-6.7.y
> and the diffstat can be found below.
>=20

KernelCI report for stable-rc/linux-6.7.y for this week :-

## stable-rc HEAD for linux-6.7.y:
Date: 2024-02-21
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.=
git/log/?h=3D028924d29f01deaa6bfdb53b7e5408948c909d91

## Build failures:
No build failures seen for the stable-rc/linux-6.7.y commit head \o/

## Boot failures:
No **new** boot failures seen for the stable-rc/linux-6.7.y commit head=
 \o/

Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
Shreeya Patel

