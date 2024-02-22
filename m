Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00ACC28374
	for <patches@lists.linux.dev>; Thu, 22 Feb 2024 09:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708593222; cv=none; b=mZGzGaDqd4LDDKR1cQv3hAcXXZNDsaQY6cGr65TmhDIWviwFDUq33KBzjkW14vXB1tOGszHJ+VCW6/vzOIMWdFYqDwjywHg+rgPTuC36uYcRGmxD35RzFLYrzZcu35gVwIgcY8Rvw4bn+ngCMyyLqk8snRGPD6QnGSRjrhaurqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708593222; c=relaxed/simple;
	bh=iCzEZ8lYrrdShCCVZqfmdBGt2AhkulI/n1z634lrPKg=;
	h=From:In-Reply-To:Content-Type:References:Date:Cc:To:MIME-Version:
	 Message-ID:Subject; b=Na6pBv6zrs2T67UZJaHJBoL+itX1FiRGsOwIAzsPd4sfxGKYjBOct2Lp7pS2laHpFFy/7UP4jkk6wDq7ceG+vLhubB+qT4amHPgZlrcKpMNWbK11WTbF3pnTkOpoYaxMvai1XYLcIFy5qQ1SO9gQ9Fue0i4fDl9z6WT0S3r7KyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; arc=none smtp.client-ip=46.235.227.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Received: from harlem.collaboradmins.com (harlem.collaboradmins.com [IPv6:2a01:4f8:1c0c:5936::1])
	by madrid.collaboradmins.com (Postfix) with ESMTP id B859637820C7;
	Thu, 22 Feb 2024 09:13:37 +0000 (UTC)
From: "Shreeya Patel" <shreeya.patel@collabora.com>
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
X-Forward: 127.0.0.1
References: <20240221125940.058369148@linuxfoundation.org>
Date: Thu, 22 Feb 2024 09:13:37 +0000
Cc: stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, "Gustavo Padovan" <gustavo.padovan@collabora.com>, "kernelci-regressions mailing list" <kernelci-regressions@lists.collabora.co.uk>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <10aff2-65d71080-5-48916200@130435501>
Subject: =?utf-8?q?Re=3A?= [PATCH =?utf-8?q?5=2E4?= 000/267] 
 =?utf-8?q?5=2E4=2E269-rc1?= review
User-Agent: SOGoMail 5.9.1
Content-Transfer-Encoding: quoted-printable

On Wednesday, February 21, 2024 18:35 IST, Greg Kroah-Hartman <gregkh@l=
inuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 5.4.269 release.
> There are 267 patches in this series, all will be posted as a respons=
e
> to this one.  If anyone has any issues with these being applied, plea=
se
> let me know.
>=20
> Responses should be made by Fri, 23 Feb 2024 12:59:02 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4=
.269-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc=
.git linux-5.4.y
> and the diffstat can be found below.
>=20

KernelCI report for stable-rc/linux-5.4.y for this week.

## stable-rc HEAD for linux-5.4.y:
Date: 2024-02-21
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.=
git/log/?h=3D5e1f150bbbb6559cbc00080b9d6e324f57dbc7f6

## Build failures:
No build failures seen for the stable-rc/linux-5.4.y commit head \o/

## Boot failures:
No **new** boot failures seen for the stable-rc/linux-5.4.y commit head=
 \o/

Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
Shreeya Patel

