Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8B329B79B
	for <patches@lists.linux.dev>; Thu, 15 Jan 2026 21:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768512855; cv=none; b=ZPk44+HZUH/9WU0s2Y5Xd3mA5F84LY63O3QPj7W5jmReGzt9Qc3/nFnpsl9xmhFoeML7lHPVIxrPlof3Fbgh2WVJMhv3F1/Rd0sfiZeBnjOGYMawfK6biEj1RqkqhdQ694HrfScZlPTPtdsyYOis0mcAUuQ7iRfskFrgEbCWV4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768512855; c=relaxed/simple;
	bh=VcVChREIt2rD13SYLu7MBVGNyRsi0J6ASE3Rtf6xQd0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mYlHmCtzeA3RmsScKVWClfukgaGVwwO3+wf8usmCLoBZ4XUVh3OyE1dJdnd6nJ88ybleGLq8GjSuZbVSEWXv6kn2QZLp606kjckLomzSQkhWrkSfEhD/hxX3AX+0ln+NqgAQD85eOwkJuU9ueGbuJzXy1f/w16ziGzidHtfcl5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=La+7saJL; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="La+7saJL"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id E85341F997;
	Thu, 15 Jan 2026 22:34:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1768512852;
	bh=xu8XzqQaQw14s9/+mjwLRkq7wk57B3gcbzp+kYm/WAk=; h=From:To:Subject;
	b=La+7saJLgkH+acrqZOk20oCiXUtUTR1w4cjt5C8cgxTsmszCmYP3YVJSlOKejTLm0
	 AfuSXygW3dybYcht74VW5wRcRr3eL3kQ0IQ1dzDTCwkJTgS0oOf4R+uacXfdR4BkS4
	 kd7S3QP245pxWCOSKx0BgD3TrtnkxNn6PWmMLgXkyz5uRvY0scWmzqiM9YDjwsO0Te
	 W2O9NCKYxmOTEYrlLPDi0IMs4Do1GNNc47eTgNH/8P3cLLWXlzPIqb21HA+8wS9QOD
	 oCzXeodInSaVFMwuzRaC++3fzfw08I4RdOQ+UrauGuE0AVY6gy4MhR03NyJoWuW0fv
	 c9l6fJRh/Ytqg==
Date: Thu, 15 Jan 2026 22:34:08 +0100
From: Francesco Dolcini <francesco@dolcini.it>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/119] 6.12.66-rc1 review
Message-ID: <20260115213408.GA220049@francesco-nb>
References: <20260115164151.948839306@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>

On Thu, Jan 15, 2026 at 05:46:55PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.66 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Compiled and tested on

 - Verdin AM62
 - Verdin iMX8MP

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

Francesco
