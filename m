Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2B23803DC;
	Wed, 17 Jun 2026 09:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781687289; cv=none; b=I/aJFaoTSGX9h+Y+2HO3TbQr5ZTzliRX0s+oyF/bAzr7sveiCgxhigcHYeu6hQr/UhmXJi+5HMxmQ1USR9/C+lBVtBlRSMbAxBsFkPsXqZZpiih6lo77wnjOrOPaKPtAKMgGXSfDtKiWBoR7RWS7f6Vj9Tkuet27KNUJEepDvOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781687289; c=relaxed/simple;
	bh=a1QvQE6yWN+wYpK2XAChf9thBli4ImftGUE0lJtBf6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDIwTysQyHdiZwpMjJlqoQk2C4pwdQyBqXSIuPQzw9sJLyrWbkG+k+D0/xSFkRw8B2r3QqRdAZWezLSZBmH57gP6MToz7oJ0Z1j+XmG/u1GDWT14JnVljrQfOVchqV+iWBEtQLLhd7QaGhq6d4rEhfiapxrTQMDfWp9FcLQSsUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IIPR+ycy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IIPR+ycy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBCC1F000E9;
	Wed, 17 Jun 2026 09:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781687288;
	bh=kqfLMfpwH8cH8XFM9LKqkK7lr4TVFHLhWav/HU3PIvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IIPR+ycyMcLRAVYNZuVFsdNCi/0h5W8KhP1F/i9Utcq9YVEJ01KEGgQHUpqppoGdf
	 1VgRoPt2rIefo4SKSu9WnEyRMv/0QFNGRMpbZZ1ylzQyIvKB96puz6mn4mq0f3MeBG
	 WlrKWbDXOl3Mn9hTt8zhXlVHHNSG3MOXZd/+QhaVqFnDGaoj+uJvXxQvIgiwNct8tB
	 +1S3Ap35NapGs1Sb5nPvWvyuFF/WAU4QsG85jX/+6P8KB7jG129lB8p0bJ9N5R+qnz
	 ANT0sLxwNvuwsJEAJekHOmX1Mwhz3fE2HJ9lE5tBOJjhK2yrqIR5aLNarsl05rwExA
	 k3qZEtARQZ5Ig==
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
Subject: Re: [PATCH 6.1 000/522] 6.1.176-rc1 review
Date: Wed, 17 Jun 2026 11:07:55 +0200
Message-ID: <20260617090755.55001-1-ojeda@kernel.org>
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 16 Jun 2026 20:22:27 +0530 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.176 release.
> There are 522 patches in this series, all will be posted as a response
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
