Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105FC2D0600
	for <patches@lists.linux.dev>; Wed, 28 Jan 2026 20:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769631226; cv=none; b=M4uLBE4JinbPVPA4goX1lOMrKpVttWBkpoG+x9/ryww/uU9u/WpvoWYhb6jN3WRJtYa1FRAdHKX90XygI1I4lfqPib8MSXmDwHKbW9N/qytRB6wgUCh8uksyS7NeHvMws8/Bu/HSsoyC41aEu6bzgV8UDFv41o/ecKZhE2khYic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769631226; c=relaxed/simple;
	bh=UpisuyD4ZalI7kxCN0wYJbdN2N1j5/X+BuhtN2OtOsA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aBeecKAIo1rBK6iLnEHVnFqMTapiamjA/EP0cSO9hY+bB/eNV1AO5hg+EFNr6bKkbRgkGUgJ776rvZ1Un1TJ6rQppNcxflvYysn8puTrwRUZQmG5EnEP7gEn4e+6OgqQz8rBdgEgQ/cMWXTTX2GrpTiIqdpAMMgHMqyZQDleVA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ucw.cz; spf=pass smtp.mailfrom=ucw.cz; dkim=pass (1024-bit key) header.d=ucw.cz header.i=@ucw.cz header.b=RoAJA/NM; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ucw.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ucw.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ucw.cz header.i=@ucw.cz header.b="RoAJA/NM"
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id AA595327EC6; Wed, 28 Jan 2026 21:13:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucw.cz; s=gen1;
	t=1769631214;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lKDmAErU0lVt4KqWzSITaPblblMjoIdIiQTZKd6O9zY=;
	b=RoAJA/NM6X1/DogJdOVOTbkn0ogTybXEMmXMU7Xv4GXSVTUN632HwpkoK5pIhTki3SiCdj
	ZZwKCpGpkveZFmLCJ/PsBncukTAMrfwAWtmaPKbAjAaeJduj14ls9ks6hKJKAh/C8C8VTC
	7SfKRb7zGxA2h3vTZak/76k5E83o7HU=
Date: Wed, 28 Jan 2026 21:13:34 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, pavel@nabladev.com
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/169] 6.12.68-rc1 review
Message-ID: <aXpt7kUYDovR4Fxo@ucw.cz>
References: <20260128145334.006287341@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>

Hi!

Please update my email address. I no longer have access to @denx
address, new one is pavel@nabladev.com .

Thanks and best regards,
							Pavel
