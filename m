Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B122722A4E5;
	Mon, 23 Jun 2025 23:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750720555; cv=none; b=KqnyeZce+MgLqvkGR/5mrL4p/ilhqerx4AGyE9shY5y/ly3aPV6+QD9eHqkgXhQRIoD8JF6DO7T583tDkb4YMuX9zM5euvST5Np3Inaa1egEuP6I43nvVZMneUkg3+i09oVIPlncwDztJz7rB1ecwHY8C1lziEkW1R/qYh5NSiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750720555; c=relaxed/simple;
	bh=ItaHT/im891VFodqldwiqii7BbPmwNiIwqJdZMdC67Y=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=Or4EelZwbYLk7O9Fi+3xsQTiMGZKEfc3N0p7ERzwUTDc0QQxzuuo6/QvPcy9Hn69PpRRz2kDP8J4IUmF7q/Jqh9+bU4DlMDwl42R13pfbwTXW2RSyxpD/9sHDEwVgGoveLsAteA3GA0RptEohXIlgEHOpNkCVzDewXKZR+KExiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pky3VpCg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pky3VpCg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798B1C4CEEA;
	Mon, 23 Jun 2025 23:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750720555;
	bh=ItaHT/im891VFodqldwiqii7BbPmwNiIwqJdZMdC67Y=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=Pky3VpCgjWMVKFwiRSviqk4YbbfU2AYUrGycxMT/GR/f4RXRUuyE5UnMQXCr3CGbg
	 YXRPPOFNlSVV8Ehp/IrtIj5m1kAtmSFq2JuBx3/zbWRxJgc9zji3vNH2dW0o4O3npt
	 z0mZlHmO/bPWaJFuXhI/llCYCnFgomGQeUegygpanp+uU0MVU4EpM7X2p53aasFf05
	 6IXBpalDskhxjjXfg0pA7oD6l4zLgJUsdNlRUvlkOJicW53G3/Ns4/bYUIbzB4OAzE
	 PdP+EpnmJBVJ8/b0Dk5V50qu2Bqkg17Cued53THxPN/fws4ple391zoufBE4a5QgKX
	 NbLPug4pNNgXA==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 24 Jun 2025 01:15:49 +0200
Message-Id: <DAUAN1I5C06V.2O7FW1AZCYNKK@kernel.org>
Cc: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
 <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
 <akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
 <patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
 <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
 <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>, <rwarsow@gmx.de>,
 <conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>
Subject: Re: [PATCH 6.15 000/592] 6.15.4-rc1 review
From: "Benno Lossin" <lossin@kernel.org>
To: "Christian Heusel" <christian@heusel.eu>, "Greg Kroah-Hartman"
 <gregkh@linuxfoundation.org>
X-Mailer: aerc 0.20.1
References: <20250623130700.210182694@linuxfoundation.org>
 <a0ebb389-f088-417b-9fd4-ac8c100d206f@heusel.eu>
In-Reply-To: <a0ebb389-f088-417b-9fd4-ac8c100d206f@heusel.eu>

On Mon Jun 23, 2025 at 3:50 PM CEST, Christian Heusel wrote:
> On 25/06/23 02:59PM, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.15.4 release.
>> There are 592 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>=20
>> Responses should be made by Wed, 25 Jun 2025 13:05:55 +0000.
>> Anything received after that time might be too late.
>>=20
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.4=
-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.gi=
t linux-6.15.y
>> and the diffstat can be found below.
>>=20
>> thanks,
>>=20
>> greg k-h
>
> Hey Greg,
>
> this stable release candidate does not build for me as-is on x86:

The error is related to patch #515 in this stable review, I replied
there, the completion abstraction (patch 1) is missing from [0].

[0]: https://lore.kernel.org/all/20250612121817.1621-1-dakr@kernel.org

---
Cheers,
Benno

> error[E0432]: unresolved import `crate::sync::Completion`
>   --> rust/kernel/devres.rs:16:22
>    |
> 16 |     sync::{rcu, Arc, Completion},
>    |                      ^^^^^^^^^^ no `Completion` in `sync`
