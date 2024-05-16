Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B109156F4D
	for <patches@lists.linux.dev>; Thu, 16 May 2024 19:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715888498; cv=none; b=DTEmjxIRyd9xDNb2bNMtdg/Yayev0V7friQEOIcWt8e0MwEcqCU2WCKL80NNI76b52r7UzI6DoEGVYrNT4dqJEraQ+65oene6hcwHJhEOxUXp1WwidA9taljLtjZvi2V2kjDtUdcI2AjXa2pZ2KJ7zbEEu8gXCVsdmUalPA1z+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715888498; c=relaxed/simple;
	bh=tARt/4rffIQ5BN7K3M8M6Rr8Jh4ta32e77nbScSqGQU=;
	h=From:In-Reply-To:Content-Type:References:Date:Cc:To:MIME-Version:
	 Message-ID:Subject; b=EHn3uBQ2UrJIZzCdl1d9CkSbB4EaJz491A7F840T9ksvDoY9dfkA/hyMwxCCuD80jLFBAj+X5nTIu+aUQ7/hYhoaGT9ETOzdhjDPuwUni3PBV98Dx705l9eoUn78HpAGymYu9LG0rlZBXUtgOtKN2vu6uqnG/TFE4TTf0cr6aqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; arc=none smtp.client-ip=46.235.227.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Received: from harlem.collaboradmins.com (harlem.collaboradmins.com [IPv6:2a01:4f8:1c0c:5936::1])
	by madrid.collaboradmins.com (Postfix) with ESMTP id E965E37821B3;
	Thu, 16 May 2024 19:41:33 +0000 (UTC)
From: "Shreeya Patel" <shreeya.patel@collabora.com>
In-Reply-To: <20240515082414.316080594@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
X-Forward: 127.0.0.1
References: <20240515082414.316080594@linuxfoundation.org>
Date: Thu, 16 May 2024 20:41:33 +0100
Cc: stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org, "kernelci-regressions mailing list" <kernelci-regressions@lists.collabora.co.uk>, "Gustavo Padovan" <gustavo.padovan@collabora.com>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <15761b-66466180-3-67289d00@178251741>
Subject: =?utf-8?q?Re=3A?= [PATCH =?utf-8?q?5=2E15?= 000/168] 
 =?utf-8?q?5=2E15=2E159-rc2?= review
User-Agent: SOGoMail 5.10.0
Content-Transfer-Encoding: quoted-printable

On Wednesday, May 15, 2024 13:57 IST, Greg Kroah-Hartman <gregkh@linuxf=
oundation.org> wrote:

> This is the start of the stable review cycle for the 5.15.159 release=
.
> There are 168 patches in this series, all will be posted as a respons=
e
> to this one.  If anyone has any issues with these being applied, plea=
se
> let me know.
>=20
> Responses should be made by Fri, 17 May 2024 08:23:27 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1=
5.159-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc=
.git linux-5.15.y
> and the diffstat can be found below.
>=20

KernelCI report for stable-rc/linux-5.15.y for this week.

## stable-rc HEAD for linux-5.15.y:
Date: 2024-05-15
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.=
git/log/?h=3D1238a9b23a79317df7bcdecb6ef6d215d229ff3b

## Build failures:
No build failures seen for the stable-rc/linux-5.15.y commit head \o/

## Boot failures:
No **new** boot failures seen for the stable-rc/linux-5.15.y commit hea=
d \o/

Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
Shreeya Patel

