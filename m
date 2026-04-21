Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B68D35AC1B;
	Tue, 21 Apr 2026 10:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776766626; cv=none; b=MGSCNXKZY0F/tPm7LmDMf7K5EIsArFgOiUDBY2E660ePYbVwPIKCtNyRNbIH5Sd8ntK1HL7XRvf/ril7G7Nb6wJpqKrIUhfYwZBtKDYpV/iZ32j+kQuPpEKvL3ikcIIfJya0VFznACU15tJpTHH75VUjSlaVr4ZameAI6ubjQwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776766626; c=relaxed/simple;
	bh=4PRqmWDtQ76sNSo2eUskyCxMXlYwICJjI6rrLmEXqtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9DUSJklJd7hLlO3WIGidGwklvdXwXZxJU3Z4BfSqAjBNsOufSKt3dtvs9ZLf9P0OtVF/eh5CLE6/vEw3ubGtzdvEZ6TGYSK9xdMmUc0bUI/4tqFjjhiNvgiDMkk3QekUTQfsmURzI4Dl2yeJQuPT8lbrVuMQ/3pRsf8MWCPNn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jRAHah0J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jRAHah0J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2334AC2BCB6;
	Tue, 21 Apr 2026 10:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776766625;
	bh=4PRqmWDtQ76sNSo2eUskyCxMXlYwICJjI6rrLmEXqtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jRAHah0JoY8tVdXJlledkZRtcmGHF4mBq8TEEATMG6TvGBE78pNgT9u8+mYycCkfk
	 suBE8jzUmM80PychO5xdPOJ8Lk/ZfCI/BSvCIbH7yDUQvINZlPFk+gyku+069CXBiU
	 8MBzDvXtIp18FPBatVglkxxlUcRdO6vHEdhcGr+ytwyRpZXIAm/iaQQ22NmGYVVtB6
	 vVq28PEqDsS/gCaqC/8g6zz2LuLhe1ii6kqPcU5Er375td2AONajSIctpZMLSk5fT8
	 FtYBiZYjlhbJnDGozjvUWCjXDOZR7BpPxAszAPy3T692xqm+mEXY8bsMXlUNDRVWMJ
	 eOgyqy74nOPzw==
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
Subject: Re: [PATCH 6.19 000/220] 6.19.14-rc1 review
Date: Tue, 21 Apr 2026 12:16:55 +0200
Message-ID: <20260421101655.49996-1-ojeda@kernel.org>
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 20 Apr 2026 17:39:01 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.19.14 release.
> There are 220 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Apr 2026 15:38:52 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

I also did a few arm 32-bit build-tests, and they look fine.

Thanks!

Cheers,
Miguel
