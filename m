Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7CB43B49F;
	Thu, 23 Jul 2026 11:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784806139; cv=none; b=bETTlBNy2m0IZlPI3Z6yc+MhGnj3XYq0YsUi1OW9MlUBwPkkEUXdbW5maOnk9m0Kz8IemF8+Af0K0Z36kaT4BPf6ykab3db4pUWc9iAWKn3tWE8NhbdMTQcbsyq3uHs71XszVVUZnmkrBncwLOU+LgeY4DtiRq7k3pU9E+S6jko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784806139; c=relaxed/simple;
	bh=NGSpQcpdzQ00f5ns4MH3+A1Ah9pGMTCTvWL4KDMwCOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4d580JB3wKVMNn/1rOdFrwFtHt1OsU8Q7d58icxnzLXYLPigyfaY1MJK01RZQ8/wz4xyBXCtJ9Q9HlQeUsqo90oasMAfitgCXiM0guiZ/LHb9u3b2Po2B565NsQQNBYaBqMIp50BPsjwi1LTeViYU6iOLBbD6DrcP1ESbjSkXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h8dpV8kE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h8dpV8kE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76211F000E9;
	Thu, 23 Jul 2026 11:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784806138;
	bh=ClPV6Zb+LcjSATxJaLNCBx0GH0xEJscTyVbaw1VQCFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h8dpV8kEkfIieNcyJJ1COgIofnWoUhGJfPg/i6z/AldDApMQUs1VIXIVj7iFluVmB
	 9h8PyxJZ73Ca+eRDmHuufYkwXsG+fllJC/ut6xyxRRZ4yy/F2IttoD1TiQnms8Zt86
	 2J3LjfOvqTREWJnW4Ul1Npym4NaV3cpParaSN73sN8E3nzwVoO3ZnEpESff3q/DQli
	 nenCCJVHmqV8s6CicqdKWRDTkFDaaA7huK0H2y3A7xtKesT2r651ZdzzsKK1n3Xlu6
	 gp7s8a5krBZC+3Rakv806so4m9KJLK7xrjmhY2yxTzGXxzr2MjNm1+RZy7CS6NkMNT
	 ucQV51uUVXSDw==
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
Subject: Re: [PATCH 6.6 0000/1226] 6.6.145-rc2 review
Date: Thu, 23 Jul 2026 13:28:46 +0200
Message-ID: <20260723112846.28712-1-ojeda@kernel.org>
In-Reply-To: <20260722143258.264584003@linuxfoundation.org>
References: <20260722143258.264584003@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 22 Jul 2026 16:33:42 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.145 release.
> There are 1226 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 24 Jul 2026 14:31:21 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Same applies for -rc1.

Thanks!

Cheers,
Miguel
