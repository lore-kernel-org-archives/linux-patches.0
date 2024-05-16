Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24740D271
	for <patches@lists.linux.dev>; Thu, 16 May 2024 19:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715887344; cv=none; b=PvritpySAOtIklYVq7es8REWLUDBOayyll4qX1doi3YkDrQL04NrHhrkD3oMGXNgQYJCQQeG7Oe8ta4Q+p/GDkKOREzRSaQxPhDDMktX+GjxeuW2SDbgr7Eq8xfUpCWPgzQ8r9X+V35AzXz6flKLwHkNMDmwRhMM0VZJbyMfZo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715887344; c=relaxed/simple;
	bh=MsPxAsB2IQyEs3D3KGaAQRNxnWjTBDxfefVhv/dRmjE=;
	h=From:In-Reply-To:Content-Type:References:Date:Cc:To:MIME-Version:
	 Message-ID:Subject; b=p42E+38oCSzK4m2GPcc2H1XejPUd5FJdQW6ZO+61ocCaMP+KSUlCxAymsLu6pcF7/lO0uPcPsUpERFJJdhif9YtZa8fFr0TtBHJHokoOTlV5OWw2aVqO/MWS/4YeYw2Jy/IqzIRuL+skqzbQyoPmWzIbYEW+fjL1k9X0ovBnQo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; arc=none smtp.client-ip=46.235.227.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Received: from harlem.collaboradmins.com (harlem.collaboradmins.com [IPv6:2a01:4f8:1c0c:5936::1])
	by madrid.collaboradmins.com (Postfix) with ESMTP id E50F63782186;
	Thu, 16 May 2024 19:22:13 +0000 (UTC)
From: "Shreeya Patel" <shreeya.patel@collabora.com>
In-Reply-To: <20240516121349.430565475@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
X-Forward: 127.0.0.1
References: <20240516121349.430565475@linuxfoundation.org>
Date: Thu, 16 May 2024 20:22:13 +0100
Cc: stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org, "Gustavo Padovan" <gustavo.padovan@collabora.com>, "kernelci-regressions mailing list" <kernelci-regressions@lists.collabora.co.uk>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <1572a4-66465d00-7-1446c200@6917456>
Subject: =?utf-8?q?Re=3A?= [PATCH =?utf-8?q?6=2E8?= 000/339] 
 =?utf-8?q?6=2E8=2E10-rc3?= review
User-Agent: SOGoMail 5.10.0
Content-Transfer-Encoding: quoted-printable

On Thursday, May 16, 2024 17:44 IST, Greg Kroah-Hartman <gregkh@linuxfo=
undation.org> wrote:

> This is the start of the stable review cycle for the 6.8.10 release.
> There are 339 patches in this series, all will be posted as a respons=
e
> to this one.  If anyone has any issues with these being applied, plea=
se
> let me know.
>=20
> Responses should be made by Sat, 18 May 2024 12:12:41 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8=
.10-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc=
.git linux-6.8.y
> and the diffstat can be found below.
>=20

KernelCI report for stable-rc/linux-6.8.y for this week :-

## stable-rc HEAD for linux-6.8.y:

Date: 2024-05-16
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.=
git/log/?h=3Dcb6ab33e1bb7469fd441b6a9c50c92190913ceb3

## Build failures:
No build failures seen for the stable-rc/linux-6.8.y commit head \o/

## Boot failures:
No **new** boot failures seen for the stable-rc/linux-6.8.y commit head=
 \o/

Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
Shreeya Patel

