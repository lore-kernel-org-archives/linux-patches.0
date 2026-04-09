Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EB83396EE;
	Thu,  9 Apr 2026 15:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775749990; cv=none; b=uzJtD6i6NtTuwjW96dmiWZJEOlWrZJ7HaHkHdUSXbLprBJwjEXQm6CWlR57jKN3jQLk1UBeWGHxnG6H45r+z/WzUx9h4SCRQQhyb6hh1L86Q7PseQMGYrWh5XAEPXJnwpbaVxE1oUXOaK6oIZF+jtJ6Cojkv+mamMa0DN+4OnN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775749990; c=relaxed/simple;
	bh=nbnxF45uKdkyoBojSKe5w3g+H2dY/57nYrDVMRf/5Bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pv9jAbC4hXua/vdCac54jXOkxZkrm/qYswzoGYOnjMLCbAzvGUJRtWZgXNK8zUrw+yxf9ystmxBc34mME5qewXlN9cBEn04o93pBNsRvYL+NdDoS5Bg8mJrD9X1CuBxG5OHwSEkeawu0+VVLW7EvXtkMdInrXzoZq4I2RflYBQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ht8FngXt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ht8FngXt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A26C116C6;
	Thu,  9 Apr 2026 15:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775749990;
	bh=nbnxF45uKdkyoBojSKe5w3g+H2dY/57nYrDVMRf/5Bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ht8FngXtbg3oQBdmy7ibWrkAQ5w9X1kDLEPvLxfRTq4EIZ9gtQY8nYVtrYrwF3Ghy
	 EklkTnrOhmLfuzB5Stqo85DoMlPU29k0XmmeYynQVNk7c9ItvZpFfdgKZ+r6hzXG+2
	 LxHA/W3LafvQNr1Gmto2bFH7cT3Q7B9agdgg+nPda+VkVdVGfRsijFVuMsjL7ImW5t
	 2I68PrDdW6wGAAKNXqrxX4FHD9dLoBNXzHnU6+6mdBmSCinhYRt9CCLB2UM/8P0NdU
	 o4Z817rknwCGT8Qno6hX7L7nm1YP6gppOSQCBMWGJEw58B0aQZtO28TqoNkFHfkNEU
	 MvBeAd83+afxQ==
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
Subject: Re: [PATCH 6.18 000/276] 6.18.22-rc2 review
Date: Thu,  9 Apr 2026 17:53:00 +0200
Message-ID: <20260409155300.34293-1-ojeda@kernel.org>
In-Reply-To: <20260409092720.599045151@linuxfoundation.org>
References: <20260409092720.599045151@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 09 Apr 2026 11:27:43 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.22 release.
> There are 276 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 11 Apr 2026 09:26:30 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

(arm 32-bit seems to build-test fine as well. Same for UML x86_64 on
a non-debug configuration.)

Thanks!

Cheers,
Miguel
