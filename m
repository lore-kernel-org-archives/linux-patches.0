Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C5136F8F2;
	Mon, 14 Sep 2026 05:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789362398; cv=none; b=M+lYklvzqMM9LM+lk/XxAwlIsdVT+IoMnOwa77y/unL7Kq3yDtz+pAkG0t5sI4eDrqitHRtk+WAh88Hn3rMt+B3cIxQnEWBX24tn/3PB7DfpKkUlADfwJlAA/0FQ7M3T3X16tG1nJmYP154ibXVZNzDKmPUIId3LOAENy7JLUQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789362398; c=relaxed/simple;
	bh=6p0IJaosUrwlwjoMdYx8YAiYWVBuHBN3azZTi7wl8VQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQ1foEoBWeJA6Gc2k9GYgAkLG11w8nfNdaGeR9E+8n24u2zF4mNa57+wqCkAZ4SJ9TNZJvUWixc6Ac1r4enLn+r0lDPLE4A9lEQITpU7lo4cqQcpnjiVVSLwqZMXJiWkCvry0uFFJOWmT49Hie6rYGpPd9gYQIsvxJ3nq/qyJ+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AZabo5II; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AZabo5II"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD35C1F000FF;
	Mon, 14 Sep 2026 05:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789362397;
	bh=xjNgw4QFLXMz+MuxUvitIDZK54AxEdkX1cZ0f8AGG2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AZabo5IIytEX3kyQteUIyREv18LTvVDOvG1XhVOaPnXzDfnbQty97OEdasX5dus/L
	 iF1B7zQttbwDZuR75fkIrEYTVnPJ0tMGI4TnZrOkhqi5viGqmUZjVbvZd6te+1xkB/
	 1u+OV9m0IaoofiPYMhCh0lAYNkfq5/uXgRzyMSPRabedzqA7tVO7FYzK8kqLbn4NoA
	 HgBvaiT2GFfz75EvtyVcYi92aGMDw9pNmII+kq0jIFIIjHfHYRU/cj4uNafVSNNpKa
	 PKg5Ji/WDASA6+JNjqa04jU08xd/DKWW9OilL/NasfmjN2WVn0HAB1xjmdvVw16qIr
	 c/u1Z0JRrrQSg==
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
Subject: Re: [PATCH 6.12 0000/1376] 6.12.110-rc1 review
Date: Mon, 14 Sep 2026 07:06:18 +0200
Message-ID: <20260914050618.9466-1-ojeda@kernel.org>
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 12 Sep 2026 08:40:26 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.110 release.
> There are 1376 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 14 Sep 2026 06:54:17 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
