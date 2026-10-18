Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8074C376BC2;
	Sun, 18 Oct 2026 18:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792347687; cv=none; b=iQkQK8KSdlGup6zrOX1hC4prItNFBTYPVtRQkmxhDMefcvRtEaGrX4MeiBTj7n8Ztlq1j4n8fZ+BDc8dBXxgSRlhVtkL9t/QaBTYw9Z/Pinr2oIcrzlF2G2E3MXMuHZdj1HNstGhPDmoHQwWSv+5Gd8ujQbLtWq4RKcMlFigPuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792347687; c=relaxed/simple;
	bh=/Da0XkWapf9tvIH8y4DOZ8InOtttFKkLYkGwlJLhPrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMlob7fVIEj8b4RHc/FDKHt1+VREeJom8IHFj1SNwxIknxrcMQVLhPCrEJP+WKskBqvNDEi2jULHs6eBaTxjBrsQpkvcUjt3XkNLh+eJyTfgelcOraDCdNN84g4h5UswJVcOQRyIk6/JwfZXrRPlJ6JBbVjHDo0yh/KSMTPfWHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hc5SXIQC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hc5SXIQC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5E11F000C4;
	Sun, 18 Oct 2026 18:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792347686;
	bh=e5O8Tl++2piX9n5bEiJ+TETTvEyspyg/xEnESqzMi60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hc5SXIQCc7wW/oa8+l1FNM5ZioQjUxJB+Zv8dD+iyr7dlYUsgdI4Ysc0JZS252Xm5
	 XVKOeb1PpB784V4JC1QkeOHZ8lfA6xqGezCHH0UC/ycO2bKLw0nJW3XXjcV8yBbkPY
	 hpyM6CVAArED/k7CulXKlAbXDXRdlEm2dObdtvdahU5iLlbRtyGVSkKoejyDQmAB7Z
	 raVPsDmPCI4WOLJEl0Dj538xlMdWZo7JWKLnrmTc1CuD3cQaSGMThwsKmNsLMDFXd8
	 SGOcsC0LkCmvEWSwoaqFU5WhHreLPLFZUh7wigGRzBj47DPmAclkPOm8AASoRRQOWG
	 wIcFhdM+YffZg==
From: SJ Park <sj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.18 00/52] 6.18.58-rc1 review
Date: Sun, 18 Oct 2026 11:21:18 -0700
Message-ID: <20261018182118.376825-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261017155104.830766652@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 17 Oct 2026 17:54:01 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.18.58 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This rc kernel passes DAMON functionality test [1] on my test machine.

Tested-by: SJ Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr


Thanks,
SJ

[...]
