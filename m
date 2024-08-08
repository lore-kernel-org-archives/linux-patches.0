Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25B615444E;
	Thu,  8 Aug 2024 11:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723115041; cv=none; b=PrmM5FUGhJLxyWYcLoAguWTSXeDxtX65c70XMx4PCyuvoPibZCz3dV5imvUNIT+L//LzoT3UArypobJGhUortBDWcqTQQLhZJyXxLVw35s1D8iFnXRdglrYbna4wTxuhW/OJDEFO8L5Ifs4RCvsGPAAoVHfhO5EdQtmlXK8WXgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723115041; c=relaxed/simple;
	bh=SDkI5yz9x2OUz58CqyQTEzvsVEE9I+ZkzDPzBDZ48U8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G4kH1ZfUw4YhgS+BMIqtK+W15u15jyj9xDkevyXUuUUxrnIJO6D8ubnRg3YDztIxlvlD1eYn3GOKyM+UvAouf9DjDtjQR/sUMiXYwHiUuY6axY5rlIZviWYepRB8Rks+PX8goKBtyx0ei0EO4rRNJS5fyxeIhII9E3mEyLCF4ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nw3Ao3du; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nw3Ao3du"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA4F3C32782;
	Thu,  8 Aug 2024 11:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723115040;
	bh=SDkI5yz9x2OUz58CqyQTEzvsVEE9I+ZkzDPzBDZ48U8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nw3Ao3dupKyg8Ygzo6pG9TzmPa25fbmnTWUETSk1X8fYM0NQ/zc0F/lK4rH6t+DU5
	 KTlCLYh1FtFIpB3fmn7auinYi+hecVaxJNdj69ERLWaoj9FpQv8E5GzfdZROx3wlLK
	 UW1ji7uv5wxQeCLuy5Wktfd+OOOyFc7UOgyPL8hbDZkIpDFrF9o/qg0fkXDxkwnoyq
	 BNFijGv3e0POcO+Sn/cQOVWjknn/Sl3s8OM2af6dg86Hq+DUeMPUSm9m7ynwlRzVU/
	 6revucvN1rCv2u7qOcey4GJMJO8YPjN8wcnTaYqzwv2l6azXhfeUBYqwKUm/epzmQO
	 TaqDe2GBdg0yw==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
	allen.lkml@gmail.com,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.1 00/86] 6.1.104-rc2 review
Date: Thu,  8 Aug 2024 13:03:42 +0200
Message-ID: <20240808110342.381363-1-ojeda@kernel.org>
In-Reply-To: <20240808091131.014292134@linuxfoundation.org>
References: <20240808091131.014292134@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 08 Aug 2024 11:11:49 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.104 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 10 Aug 2024 09:11:02 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
