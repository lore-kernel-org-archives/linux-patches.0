Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD8837998B;
	Mon, 14 Sep 2026 04:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789361942; cv=none; b=O7wBpyQGpfYtswPZFG9PM52XM0QL2hGVkBr8UfM8zAfNOIn8vCpqjtaCujGaHmSqPObFV4nCk9gjMs6j5zB8O2i+5WSzBpHDtwUlGq4xxtKlUxAfClWWfi+/MpOaLjWA4ZNNntdWUDRBagWGAHcRzMbEN+Zk2s03oNt31b672sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789361942; c=relaxed/simple;
	bh=dDN8cyCrIHgwtPl4Bhh29mpe/OB/GWOUd8rkjyuZSiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CIHdpTKS27moihgA1GnLok3OW3Q0cXTz5zVMXDUk8orKUVhzA/7duClJI69M2ZtbIaSnwpp/AbhlCaDqadY8rnjGKffB+3oRV8nR4vh8rkw9jQ6Eu/ZISJTeBbvjcKYPbnEuFVf2wFOzwkmjWZMxxcuwEhFDkybm+JK2jVkDAQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C6+wS4+R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C6+wS4+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C0481F000FF;
	Mon, 14 Sep 2026 04:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789361941;
	bh=cffVxMuNpZFzKhqi8Pf68Bzqc3VjfeVJjBu3q3skr5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C6+wS4+RvCHJRWAplyqxpIEX6biiQAdA0qvyK8tsH66p9gg45DMr6sVuCeToEhK7W
	 RBHUApWoCTKIgbh6hamulqLfSY82nwkB15OS45ItdTEjbtR4nOdF7jqEiJg8cakAdH
	 3GPja4i26hj6c2379+op/2TrU8F4NgJLlE7nCAsFTreOC7TgBvdN1TbBolAdC9/Ppy
	 4lZ5fhKElDApkg56AE+wS2CRX9YfgyhZHPp2NPcDArEJ2ONbBUNhu/NRxDdAtICWeI
	 OTkX/VOGBVGfnXNFr4SH7zlCD1+5dydTRBpxf4DBwa0Y5mVpC9dA2bjMMPSCstrdRD
	 p07nw4aqd0H1w==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@nabladev.com,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.1 0000/1191] 6.1.188-rc1 review
Date: Mon, 14 Sep 2026 06:58:45 +0200
Message-ID: <20260914045845.8257-1-ojeda@kernel.org>
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 12 Sep 2026 08:45:28 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.188 release.
> There are 1191 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 14 Sep 2026 06:54:17 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
