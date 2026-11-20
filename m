Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207215;
	b=u+FQ1mBqHYqt4yVcBsNxpwKxv9T8kM1ja4KP3lcuGZqu9HyfOOET1qSKyZ2rnZcuPgC8
	 cL00lPhE1f3UuaUrfbydKdvgvI6alIKmrF7ecTUs8DBlcKzsaPG397l69UMoYQPKroRyt
	 d0h9xNtRbQEwvN7NHvLt7ApQbwNiaQetqzvsmsbo8f5gy6IOHoPcbnM/IWg8RSUY6TiOd
	 VyrZy6fdZ9n+E4qJ62KlYKxiJezxZuLpj+cwvDfEvwDIublerGAJRW324+rQpEgQCnM4b
	 GrKD/o890kWWObVjPk+go7td6wzcmkFPzhv5N2AQ9LZ7K1kqD4ufG2MrGAx9DGI2rvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207215;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=5QF9H+f2hbQQ051TmWniOQsF7ZE4Lsik6x//rHw+JzY=;
	b=r8plpBxQdqcwGgowsgBQqMOUMEKSsO/rq9NUqnFj71nEaEf295sKPeIcNFsU32MNC1Jl
	 4w5oykL/skMZqGuayG3aKiq20R5G3tBhRgeVckpMm8uCjl+Hh+Amy47ABwn1f0PmqpvRS
	 a9tP4Y15QujlGRk5bZb5wxt7UQT56KN4GTqGbUWCywpBthur3B0cWetep1DK1hno+tplZ
	 4sccgCaqnrPcrpn98n3l/gR7MpGiYMmCcVQHtQArpWBvHRfcqP+aV2uF04hsK4d1NtMXs
	 ihrBCDMsZmE+2L5LCqpyvX6JQr/HlrLl4GsYQG18dvTqC2gEB35/Yxup6Ii/uzIy+jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mV8lwKs8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1D0606A339;
	Fri, 20 Nov 2026 20:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mV8lwKs8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D901F000C0;
	Fri, 20 Nov 2026 20:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795207214;
	bh=5QF9H+f2hbQQ051TmWniOQsF7ZE4Lsik6x//rHw+JzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mV8lwKs8eT6EQJpMO9bqBRHQP33SG0C4oKVMeXUTnJyFJcU2DvmkFlLliwwvPgh6v
	 EluejGrOYkjvHSSCL+nFPvsVIWLn7qYoF7V0rDbf+tXw2OqKLjs98pqVE56E+sFepG
	 ZYJjYiqqEUlZTWHH3rhO9MTXU3nhqwDbGH4Q8POFeLXDBJluHFC14IlaI5W6y9urtl
	 wuz5Gxw2fDoM54SN/ER/RsePt3NMLRmHwbORVhwcAQz+jIBpeXt4CZlKM1J8w88qUk
	 ohYxXDexBOxroTqv1CYgxH1WqnPp1HaUoTPAW8Hmc4JA2DeWP+4Q5kHxQCUwxlLLI9
	 euQPpWID0bHbg==
From: Sasha Levin <sashal@kernel.org>
To: Gary Guo <gary@garyguo.net>,
	Thorsten Leemhuis <linux@leemhuis.info>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
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
	sr@sladewatkins.com,
	Miguel Ojeda <ojeda@kernel.org>,
	RUST <rust-for-linux@vger.kernel.org>,
	"Alice C. Munduruca" <alice.munduruca@canonical.com>
Subject: Re: [PATCH 7.3 0000/2651] 7.3.6-rc1 review
Date: Fri, 20 Nov 2026 15:39:19 -0500
Message-ID: <2026-11-20-1-daily-reply-0030@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <DMYV5T0TLKEG.1RHCZH8L40LWY@canonical.com>
References: <DMYV5T0TLKEG.1RHCZH8L40LWY@canonical.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> After dropping the above patches there remain a few compilation errors with LLVM=1. They all seem to
> relate to pointers in bindings being sent across threads.

That's the rnull TagSet issue. It's fixed by 06dad60393f2 ("rust: block:
implement `Send` and `Sync` for `TagSet`"), which is queued ahead of the
configfs patch for the next rc.

-- 
Thanks,
Sasha
