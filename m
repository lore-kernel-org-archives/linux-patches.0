Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF2617F39A;
	Tue, 14 May 2024 17:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715709373; cv=none; b=UWb/HquWifhcxflBqrwYPWbPtCckKlMchGoPjO+Ic6Hk3Wt/yt+cdEZnlOt6G8r02j/nJof7AMfoOczO2RVn3CPMQwM3sfZJLFTfSdeYqbrGcySNGLRvsvy3fZZ1qW3uP9uPah6RJ4BoN9Vax0ED4sh1Jf3kDgSZHq+nQJR+6Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715709373; c=relaxed/simple;
	bh=Y3d30ZNMYjUADOqJO32TFp7nY/92mI7lTONWkW84cYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=swe1yxAcYZeA3NAGfQpxGIuLraisLQzpJbg0gh7VLAUuR1FwwtKnDKKp7PeSAY7Q+XPtT75XIMQ4dZEL69KcnuzwCcvDHcc3vSCfs+iWOuE5SfFQhI8MQLPVnpuIJR3zh8Of4tqZQy3bhiVMSEyLyyj6WZUl2kUVfQ1WOh6T8+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o3RR4dfj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o3RR4dfj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762A7C2BD10;
	Tue, 14 May 2024 17:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715709372;
	bh=Y3d30ZNMYjUADOqJO32TFp7nY/92mI7lTONWkW84cYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o3RR4dfjOpz6d+KvbmguSmCqvN4TKv0v8B62c+a4Mfn9LyqYjGtQpjfwosTL/eCEt
	 Ikk3ADU3kO46A9oY2iGcR3elaC0whPA76VwqB3XcfwgDxD6zMSX41pjjRepVRj2orv
	 j6DNkOMNMbnrTJXOoYmjGgUedlj53FbR1gty6TdgzpD0AwCsZylgKfMXI45Uv80vKB
	 FaiCrvkg/+fG9+/JE2HpRDplbZlNyzpKDALobFL5cIN9R5fkxvr5V4k7eqqAnQu0if
	 8KvgqqNEqNnPsLgCJFP9U/GRgjq0G2LvcN2yb9oRXR0E9hhWcO6spQTBdwgUfq0YZS
	 Mb/3pP73sp8gg==
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
Subject: Re: [PATCH 6.1 000/236] 6.1.91-rc1 review
Date: Tue, 14 May 2024 19:53:34 +0200
Message-ID: <20240514175334.24432-1-ojeda@kernel.org>
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 14 May 2024 12:16:02 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.91 release.
> There are 236 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 16 May 2024 10:09:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.91-rc1.gz
> or in the git tree and branch at:
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.

Boot-tested under QEMU (x86_64) for Rust:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
