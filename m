Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792933105;
	b=WtApW5M5S8VmD2a3jbxQTWFGIMxu09aIqIu3sPmzegorUqWKfELrcKszMu/YUH5VzYqs
	 3YIpqM1cphxBy6VQMqq27x0qKDE1bTpa/H3tOEzm/ovA4JAfwoyjvJ+tDf/uSUBLd79Ut
	 Dxtoz0kWUVEMbtCzuCB776myZ0dC6Xf+LjvKWHHeLrq7f6Wckbe+r+Bzzrhbwii8oHH6V
	 r2dK4l95bV8H5plgujG2Y4OxhU515AQJPtNruTE2vjcasr7aKE5M2FGGcvCApVJVakuPW
	 s9YZSYguWekIrt5x+uwqu6wUMfaeaXU4hT6CN3QleUrb/jYOINrpciL2UeIhDzTWa2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792933105;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=7uRCpw0dTORorjAakPr9rmxV64BViqawQfWAhL5Kh1M=;
	b=s/48Fzq7Kn+juzCA9WlG78p3LEPyWFVU80gc2jzqfszqKw846TwEpimbCk8IgBTzubom
	 Q+X6SzIvOFWO6+tB20hKnHPJ40ggBw5XNjpSvOt0rByoufRwke3HdwjX1wAsWy8aWq/cK
	 NievWboH9gMjqq/uA+xDvKqQRmMdYOAU0TNKVdLyqwR8g9hC9AtojGszYcpGqsQZKDXff
	 Tp80F5dPslIy3CAyvS4EyDlMVFtaiVa1gDdGXUnS0fiVgWfZMyIaaTXfNwTfLYYso1WYL
	 yfFGKNpoHBwdt6EFbyIQXUNCCcX59h4QpMIlUfJjkJNQS3iTnrmhtpT/lI0qfwL9UXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zLButuvh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E08606A31B;
	Sun, 25 Oct 2026 12:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zLButuvh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F681F031E0;
	Sun, 25 Oct 2026 12:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792933104;
	bh=7uRCpw0dTORorjAakPr9rmxV64BViqawQfWAhL5Kh1M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=zLButuvhg6zx06pj4hSLNrCGl6COl5emJ8yVzSk8fmU+dIypYeHqYKKoK8sBkznif
	 lFYAt4erIGM8ZbtC07TW3OuZ8Vob0gQ0gN1mIpz9otTXaQhttVxtRye0ViISy14hzj
	 5xkHuL3jM1oCFj23Y0Gv8+K+9TNh4r1WiBTi6rr4=
Date: Sun, 25 Oct 2026 13:58:24 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ron Economos <re@w6rz.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 7.2 000/243] 7.2.13-rc2 review
Message-ID: <2026102514-mantra-hypocrite-3567@gregkh>
References: <20261024064731.125251200@linuxfoundation.org>
 <567fa279-bdf9-4634-8b4d-ec64c627ebb7@w6rz.net>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <567fa279-bdf9-4634-8b4d-ec64c627ebb7@w6rz.net>

On Sun, Oct 25, 2026 at 05:12:48AM -0700, Ron Economos wrote:
> On 10/23/26 23:59, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 7.2.13 release.
> > There are 243 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Mon, 26 Oct 2026 06:46:54 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.13-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Upon further inspection, I've found a dmesg regression:
> 
> Oct 25 04:01:40 riscv64 kernel: faux_driver regulatory: Direct firmware load for regulatory.db failed with error -2
> 
> Unfortunately, the bisect fails to boot on the very last step. But it's
> either commit "fs: stop sharing fs_struct between init_task and pid 1" or
> commit "fs: add umh argument to struct kernel_clone_args".
> 
> Note that in the commit message of "fs: let idle threads share init_fs" it
> states "Note that kernels before 7.3 need a different backport.". I'm
> guessing all the fs: patches from Christian Brauner should be dropped.
> 
> git bisect start
> # status: waiting for both good and bad commits
> # bad: [7694d244b4f8a6e187060f1f66cc734f5ed16d7b] Linux 7.2.13-rc2
> git bisect bad 7694d244b4f8a6e187060f1f66cc734f5ed16d7b
> # status: waiting for good commit(s), bad commit known
> # good: [cc9de5d4b5ab6459f5774946aa3195ad51236fa8] Linux 7.2.12
> git bisect good cc9de5d4b5ab6459f5774946aa3195ad51236fa8
> # bad: [fa9a1ea1fe845ef8d55048bec58f0c1914f98190] lib/crypto: arm64: Fix lost Poly1305 carry when resuming NEON state
> git bisect bad fa9a1ea1fe845ef8d55048bec58f0c1914f98190
> # good: [8e0e8f6a2381e3a945953f522af34add71424c89] fs: notice when init abandons fs sharing
> git bisect good 8e0e8f6a2381e3a945953f522af34add71424c89
> # bad: [77d6387712803b293c9735c1511a70d38d746590] ring-buffer: Use subbuf_order in available memory estimation
> git bisect bad 77d6387712803b293c9735c1511a70d38d746590
> # bad: [25afd3de9842d1c1f2c443fb673bf9dabd2e5ea3] net: hisilicon: hisi_femac: Move setting of netops to fix crash
> git bisect bad 25afd3de9842d1c1f2c443fb673bf9dabd2e5ea3
> # bad: [fc4fb8a05292c20b1f7cdc310e10dad30da3ccdc] fs: let idle threads share init_fs
> git bisect bad fc4fb8a05292c20b1f7cdc310e10dad30da3ccdc
> # good: [7af0a9a193154ea8818b1d46930646d94818fbc2] fs: make userspace_init_fs a dynamically-initialized pointer
> git bisect good 7af0a9a193154ea8818b1d46930646d94818fbc2
> # bad: [14ec8230d78887f5018867013520f05e212aa701] fs: stop sharing fs_struct between init_task and pid 1
> git bisect bad 14ec8230d78887f5018867013520f05e212aa701
> 

Thanks, will push out a -rc3 soon with these dropped.

greg k-h
