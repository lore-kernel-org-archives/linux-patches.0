Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD3D1F94A
	for <patches@lists.linux.dev>; Sat,  8 Mar 2025 20:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741465107; cv=none; b=hh8gdn5thUiLPXu3Ujo2AB1D4TiTSfux1kSV9sEouqx/ftHXd8GFT01PWCQOZkeIXw6teh343pcbPTWJJNWyfmCaEIycNZfPKzHATD28ovDtw9JrOFU35mUQd46N1jwJUDHDFwD5Dq1iAZhGqutdF/3QVFq61K+w97JvySX68gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741465107; c=relaxed/simple;
	bh=w+Ho0kdh+ZHla2AXe0wjcnltJycmfuibgP/P3gY/KKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gvr4Uhfyz2vIVbGBvfdFQtT+h1kGihVmMATQyc8Ny84311sJV3v4Xn9LvsEyBcM9Yd8rwRDgyONsN8QDZuvElcQcPA52wkHeYd9tJhCbxaYPknxdluft1V6rMgCLFvtOHQv13iw6PXjqUO0vI3j7V1tER5dMYmz1sTCrk6xHAv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Yjgkm1Xe; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Yjgkm1Xe"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id AAC4740E0202;
	Sat,  8 Mar 2025 20:18:22 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id MWd90MCkUWH6; Sat,  8 Mar 2025 20:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1741465098; bh=N+2HARJAq2hBsbEGiY6TGYAcPQtu9AmH1QNG+W8vS2Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Yjgkm1XeZYJIm5cYbD11x1cKYnG6M+KjsrT/MkA0waHYBrWaBznyS+rKbCENta5Qz
	 9VdSk02kRIC88+bqDB8z4sJgJDX3UkcBRo7GBXxDIEfAb0cso4QLCWFyzMuflRQjy1
	 o5uMcT2G+Dcd5G3cvvfyT8WWjPybrpP83RzTgx82YQ7M5MDWVfJmlq7ugd2Ft2eQH3
	 JDFXJ4wRwQY6t/BQbMqHEnNBAZw7p4XqutCYwDkZ0lt6km3IKsgR6Vl7m5MqUntQQj
	 NeLddCRgaiYsXLES2kn03SycAs7oKS70BB38qZHR85JDACg/Go4wxHQ7byybL/Ek2+
	 atcZKW/ksHmPBzIloh7eWNDEL7wjDV3HYO5rqYB7JRWIHKQOQ0eNYgP1Ba8wuV/ncb
	 RxOriCuRl2XV+JPqAH3FaUBOc032axdNmnI/CdFMKT0mEIUxp1b0zDMGXNsjDdLwt+
	 z4a7XqP3p62Ck0hBKUCA62pgJCB7u+748rnE95b80zqLCxHnnGRggINJ92uzyRBOCk
	 wFLRefgeThnVCxlleYe8u1hEOU2zS5htOUHyJbWrK00boOp86opv+TGufWINcFahC1
	 0OMjctBYWFVU6XaCcntS7t4FECFyUwexnRtLpUP4mwWlToFtmAQFo2aHDD8yq2g94+
	 50fX2/jzev4WklXk1GI6+Lkk=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E2F9340E015D;
	Sat,  8 Mar 2025 20:17:52 +0000 (UTC)
Date: Sat, 8 Mar 2025 21:17:46 +0100
From: Borislav Petkov <bp@alien8.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	Thomas Gleixner <tglx@linutronix.de>, nik.borisov@suse.com,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 6.6 000/147] 6.6.81-rc2 review
Message-ID: <20250308201746.GKZ8yl6tHf4aNOEFgp@fat_crate.local>
References: <20250306151412.957725234@linuxfoundation.org>
 <CA+G9fYtfmMThUC+erk6jVk8BN0jWJCw=FnKh68ypwhgv65OZ+w@mail.gmail.com>
 <20250306174442.GHZ8nfCiXOJj_fnQa7@fat_crate.local>
 <2025030633-deserve-postcard-9ed7@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0Km15duY5v01DIOH"
Content-Disposition: inline
In-Reply-To: <2025030633-deserve-postcard-9ed7@gregkh>


--0Km15duY5v01DIOH
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Thu, Mar 06, 2025 at 07:01:31PM +0100, Greg Kroah-Hartman wrote:
> A backported version would be great. If you want to just send me a
> single patch, or a whole new bundle, anything will work, whatever is
> easier for you.

Thanks, here's a tarball attached.

Now build- and boot-tested on my last 32-bit laptop.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

--0Km15duY5v01DIOH
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="microcode-i386-6.6.tar.bz2"
Content-Transfer-Encoding: base64

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
vuA=

--0Km15duY5v01DIOH--
