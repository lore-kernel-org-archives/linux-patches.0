Received: from mx.nixnet.email (mx.nixnet.email [5.161.67.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76B2204C0F
	for <patches@lists.linux.dev>; Fri, 21 Feb 2025 09:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.161.67.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740130982; cv=none; b=EFBlT9zR7CQhXJbuSBQ7C+DbS3ujnU+rwk7A4d3c6f+QYJlzz/r8QKB3S+vvJJJ/+x1GigsqRhsqt/O+59wP4btMI/8Wbdgp+/LLrSBdMh68NyfMON9S/2e2JfH093WJ/agfG6YchBnei0jMofiy8tvsYUUme4jsjUPeEeDQ770=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740130982; c=relaxed/simple;
	bh=t4ousF8r2RyUSzA58U9BWyu9ewPTfWsYIlsf3MdymZ0=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=hCLE2lL/Twn3klhP48eXQZtMMcqsDrgrIznBpwOzUeJ8EvfpR9vqJqqy/oR370uHUO99AQ98MaKgoj3rnHPluP7vai2AN7/E2cXfBWYrXHel25fKDaC5JkfdupNrLQH2A5vxvZDKuVNnzq7XX+hydOS0f+D2G/DDUvHoGFVsZ+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pwned.life; spf=pass smtp.mailfrom=pwned.life; dkim=pass (1024-bit key) header.d=pwned.life header.i=@pwned.life header.b=jg4iC6oJ; arc=none smtp.client-ip=5.161.67.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pwned.life
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pwned.life
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=pwned.life header.i=@pwned.life header.b="jg4iC6oJ"
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mx.nixnet.email (Postfix) with ESMTPSA id F29F07D2E3;
	Fri, 21 Feb 2025 10:42:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pwned.life; s=202002021149;
	t=1740130970;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I0YiigKNZBH5uzypDeZSmXVaUB8aAJhqjnPQJx8cxWY=;
	b=jg4iC6oJldbUJf4fxIA6mPzCw4XvmH1CY/R4p+h4TKBHVfFJq/mas9kokftMg0pDhbyLIg
	Z9U72/r4ARn5ZXQXsQl1rS32m4zfNkl+ZAEqnTifwiX9kBvIx26cK91bQfY15F7fMAbE/P
	BB3NLL+RtYnO/wfSkewn7lw7ND35IjI=
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 21 Feb 2025 10:42:40 +0100
Message-Id: <D7Y0XZ9ADBZH.1XP8NW6BIA1E5@pwned.life>
Subject: Re: [PATCH 6.13 000/258] 6.13.4-rc2 review
From: "Achill Gilgenast" <fossdd@pwned.life>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 <stable@vger.kernel.org>
Cc: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
 <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
 <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
 <lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
 <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
 <srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>,
 <hargar@microsoft.com>, <broonie@kernel.org>
X-Greeting: Hi mom! Look, I'm in somebodys mail client!
X-Mailer: aerc 0.20.1-0-g2ecb8770224a
References: <20250220104500.178420129@linuxfoundation.org>
In-Reply-To: <20250220104500.178420129@linuxfoundation.org>

On Thu Feb 20, 2025 at 11:58 AM CET, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.4 release.
> There are 258 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 22 Feb 2025 10:44:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.4-=
rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

LGTM. Tested with Alpine Linux on x86_64 and s390x.

Tested-By: Achill Gilgenast <fossdd@pwned.life>
