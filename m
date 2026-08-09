Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831B52F12CE;
	Sun,  9 Aug 2026 08:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786264332; cv=none; b=UCEXb4mtLyQ98Yp/gWDepeD1IP6lT1YPVh8SIkS+EMEe4RNGterTksAzGFf4Vee3erAQYMU1Wb78SvcPVz32faWJ46lKx2s0HGzpugZc+0BFU3l5mIPjFjVhAMza64yezgJ/0daCZRyaFbCcocOK/M/iVopGz9kDzm5jTQN66iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786264332; c=relaxed/simple;
	bh=Jz8CeESlxEHv2Jvg+MO4iFywJzOI2NSilxv+I+QHLnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bPIrCz7DcbP/7PWJpH6bRyiIzlDF2J33O9ioa4//bxDXv2jPvPvtQCbmEGNZKn1wwqXBX2zsvHon5LoqyylhizoIEmvgrcgF2kX6H2VF4SnJUX3/KeoCgQ8IKCgjAdpU5FufWILbTfELZYKH43Vs/0pSJcqaeDvOMAwzXc3u/vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ej7lRU8p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ej7lRU8p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B781F000E9;
	Sun,  9 Aug 2026 08:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786264331;
	bh=381g/0vB3KRjTxOJkStjFA49RRFy/DgoKmlTSdidxTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ej7lRU8pcNwnfxeADQ/NTmtubiymAsOBcg7MUZfhQe7memlYfcErbtJfzqE7yct32
	 PwZBtwhE9m4i/ZM3ZrI42gVR8vS47OGIJEfmgnFgh9sxdJ+qCuke2uZGjDCMMM+UEU
	 cuaW50oR9JVxtt4/fFtqzrhynzDte2oRo3HwfD+q3wp98ZLnswE+cpMRtpqZIPnzFu
	 4fDu7+ex7NWEi+c+euwy+oytZIhLz9CrVg/eL5q8qUnKL0syg+6o3DNOsX3wrRkxww
	 oYlDx7dN/GYLfwcg7hcY85aVMKGNe7fgQh4Qrx+ovSvQZIEvZ4lC5Zd7NZP7azZ9Ur
	 rjfz1aGg53lcw==
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
Subject: Re: [PATCH 6.18 000/396] 6.18.44-rc1 review
Date: Sun,  9 Aug 2026 10:32:01 +0200
Message-ID: <20260809083201.253148-1-ojeda@kernel.org>
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 07 Aug 2026 16:32:40 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.44 release.
> There are 396 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 09 Aug 2026 14:33:46 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
