Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F070248F66;
	Tue, 14 Apr 2026 17:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776188734; cv=none; b=UDwb17thE/Ne+4n3iKGY78HJalAJF40XqljAuopAkkJuXPbjTgJCyco9T8u1iMtEF0Jy7qxaAlU+H3MzYvCzMGz2c7NVtxWhqNqeJyIYVh/VRaUkoNkk/dYJ/8WzoAyxmD6lqU4JNBDvOXhrSRb1KQwJcTB7SShh4ApJbYEqxO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776188734; c=relaxed/simple;
	bh=IVFxht9LuSM2Mb2iAFzMnx7ETiHFF8Cbp0Ms8oj1CAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AvMZdco/QyJgg3pRXp7jQbCKmSrpcRTCtEGnaNvikFMHyyNuV1xmPjnmg08iQqCM3QC9zYkC02GXlAITFDPQcLdGltGL4jg0RhxShk+idmtTCNizhxHEjIoO2ABFLqPUVB7mJVDcfK/cXPZ6Jv7yCtSHYItdc1BKfwaZ+mpqCeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dafZb9o2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dafZb9o2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAAAFC19425;
	Tue, 14 Apr 2026 17:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776188733;
	bh=IVFxht9LuSM2Mb2iAFzMnx7ETiHFF8Cbp0Ms8oj1CAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dafZb9o2kbaU1sNOghl576TjMQkBEbdB3v4OqybqIavHlzpMNj2uszJbqnWb7szid
	 lwLlEo3klpttoQ5bu5ROFJkzaJfKEANtt4gEQ+OY8DSjH7F6g8m6nak9mpdbgoYGHj
	 pGo32Y6r5FnCC+dmRlEZ8nWe5VVfrLctuhyOm53ph2DJG3XEkEbRlEoV/jPmlPKWtm
	 GD7Xdhv7cBED9cRirdUy5Xpr1DYuXsDuJ1AqxDPU9pmTuYIFSGotLutHAY82X161qp
	 Exma19eOave7Bwc7GTEF92migoAZ9kEdgtMs8h1wUZcwUemYnkybsiRc3nEF1MkJWJ
	 rVBEeIakmI2TA==
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
Subject: Re: [PATCH 6.1 00/55] 6.1.169-rc1 review
Date: Tue, 14 Apr 2026 19:44:57 +0200
Message-ID: <20260414174457.268358-1-ojeda@kernel.org>
In-Reply-To: <20260413155724.820472494@linuxfoundation.org>
References: <20260413155724.820472494@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 13 Apr 2026 18:00:34 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.169 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
