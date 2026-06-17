Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256A43932E9;
	Wed, 17 Jun 2026 09:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781687441; cv=none; b=CTmxQ02ju8Qw6qbQ101G8iY+hrBbfmCRlg9XaSmbA285I+g1iieqQjglA/JU2MtWJHWZ1zPa4VpaKmugp7b0PR8O4JMNEo2QAXoJWX9ziOvwLT97ZgHXIoFjrs91ALSzL05nnlqWeEWMHK3YG28FUgobEQ0pdfpGxA/J90KS0nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781687441; c=relaxed/simple;
	bh=WO+UA7TcWxNqjfd1fCVn1fa8PY6zGnnhK5XzK/1Gc0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WkAeXE8VBPk2UGe6tpw3hgMmvjXyligKc1lW4RRvySqQ4CtnoqIhI6ztYdz6vJatXfFsZFDLwQ9hxVDYmgI1vRIvqIrXwogyysIBDfFp1gH8uv2UnMJewIhMpU6W8jiUPbnmDKLdjz6VW5I7vqwVSID1hbXUw7DAKRNitteGx4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DutmQS5Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DutmQS5Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9101F000E9;
	Wed, 17 Jun 2026 09:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781687439;
	bh=E3z5LKCdXzZziaIE6FHRG+twXgjZt1cQ5YKBFYHvPBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DutmQS5ZYh2hI5yfN5HpHsrbpzURvIz2fv9FESEK/yJXyhYFYlWu7SoP1SJVst/YS
	 nu8L70D/H5HYLc+Q3xv9JE6ApaHHHzuBaQQcvOQsEIl3xviEfSpOtYdz/sZ5fB72fG
	 vEPg2016oGkGr7diTnWsG0dVMfMaucQrThL8zdBbXHv5GkBJkaGN1wxa0DDw6ARfVP
	 Zd01Jr/6+PwqX813zgO88+GSx8VJeWbMYjMgTpit1wTCo1MA8/pzsy1zL023j5F2ed
	 sngqzQ8TCe2DXFaNv3rbUVdifIR/lKAQHbPjQSGg7CBHSypT6eutPZIKI+OFvVh7Bp
	 6iegBuC98cgcw==
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
Subject: Re: [PATCH 6.6 000/452] 6.6.143-rc1 review
Date: Wed, 17 Jun 2026 11:10:30 +0200
Message-ID: <20260617091030.55301-1-ojeda@kernel.org>
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 16 Jun 2026 20:23:47 +0530 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.143 release.
> There are 452 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jun 2026 14:49:57 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
