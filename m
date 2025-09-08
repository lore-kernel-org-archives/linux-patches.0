Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6939721D3E4;
	Mon,  8 Sep 2025 11:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757330823; cv=none; b=bFvEY4IOPADKj7hJEn/0wtfNLwcnyeUhXub2l961ZJd3CRbU9Y29MLf5h866q7AIu2Ydb8juIazfhw1ZyptC9H9jZ9mg1BlxZj1mRyG7MELaWV9+e2pVmD873i+516W9Nj+YB2uBOOUEgpwDborEAO3depfkpZxw0JMJoItHmOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757330823; c=relaxed/simple;
	bh=X/jO8pWsLbAH6Yh81G2J0GT3k0C2SMOrX0dExuS0FhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sknj1t0mm2HBdBS9soLNAqQ+1dzENJHwA1eYpEAgTwBYzLD2aAz0zz7HJx/ZWO+PPA+yyk+ZQXVdPE8fxX/fsQM7IYBa3SWUl0ePQSMhN+2J5qdoNuj4JsCmIF4VXy2mf/SYNvMLTBqHqZ8H5Fih4ffx6RdscPRsQhDw6RAyoBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jqqZCYWX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jqqZCYWX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A61C4CEF1;
	Mon,  8 Sep 2025 11:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757330823;
	bh=X/jO8pWsLbAH6Yh81G2J0GT3k0C2SMOrX0dExuS0FhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jqqZCYWXk7QAPiACoRbvJYTnDYxr4vJdLBocN495dXhOunWB3Vk3QGdEHpF3eZWSx
	 rdx8taT7qbyMWr1pXPvlBEFwmGvjXhKeBbymv1VBda/psFDXjhSudidKBSe9ZP7kZY
	 o+XBs+LAidrEf4ECaqfP4NDRJn6kYCZdBFRPr4TAuypPD1ZXiW1dZIZ9Q2D0Gieni4
	 lMwjuCkSS/DvPt+yAuuy0vYt6U+Q8tBDcXby5vBdYa8i4OQFbCWmUnKlw3HU2wdByu
	 nNMxHQjzyLcxiy/BRW5mu6i4beVLcWxwXTyr8bNK208omXhpgThFPnQS+0Db3m0WNP
	 bZzR0lLmTCYqA==
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
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.1 000/104] 6.1.151-rc1 review
Date: Mon,  8 Sep 2025 13:26:50 +0200
Message-ID: <20250908112650.567205-1-ojeda@kernel.org>
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, 07 Sep 2025 21:57:17 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.151 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
