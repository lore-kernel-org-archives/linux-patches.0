Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4203976B3;
	Tue,  3 Mar 2026 21:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772572750; cv=none; b=jof5lkIVKAR8UCLBPCU+WON+2pjCnAMzIoxwFm2ILZrc1x+In8BcSkfm3Z+tMUEltSt+5U56vmPcZ/GeYvpIjzeV+uAI/Lst/WYoSxcrPc2GuheFmZML/ZASzHhBuWgFclMVuOprEsbsWkht7J85JtY2hCb8EqS2odkS2dLx6Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772572750; c=relaxed/simple;
	bh=38WL0l/D4ab0hAkQIgJlTU3wgrsv99zdty6WgnQ7naE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kn+Y7nbhMh+EZRgguvO743dMJrHbahdMKeda0oP0rirRzaA3Lzf6uLWWHuHqrY0ucMkrSWACBJmr4oNMw6pVmKnIuHcg0gNW4ruCVqWgEUMY0KOSHDP5FIAFjbseOs+g4zDiP92qf6AjzxhjX7qydXY2B7rTAIdH3GLes1pbxNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QeHu6WhB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QeHu6WhB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C24BC116C6;
	Tue,  3 Mar 2026 21:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772572750;
	bh=38WL0l/D4ab0hAkQIgJlTU3wgrsv99zdty6WgnQ7naE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QeHu6WhB1Z9RDOQxrmT57cPqOrOSUdt6bUDQNfOu5tjt5lO4sJvvIYhKX1LKTUBLH
	 ydlHaI+kj61pxOJDnz8UV6gKKJm4gQEfJXQJOeH0CEdGUlFujrmJfqHYVLMG64jhmR
	 1m/RXHxvpSJD4b+mfHyj35HKB8ZAQ+92j05P05QukodQX/N7yJM7nHnRKHlCJyLdPb
	 dLKHiApSXH9LSqOXuqu1MHBZ7JP5Jbg0N37W04qbuA5sxMEzDtg77pdtoVuKxqvNn6
	 rUvPb2Geoi4dr7m+BtnUcIrGKBZmu2YnF4nr2YDXBHoE3FnSjYYkAMKrFVCLV3Qwb4
	 sG4gQaD7OMRrA==
From: Miguel Ojeda <ojeda@kernel.org>
To: sashal@kernel.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	gregkh@linuxfoundation.org,
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
Subject: Re: [PATCH 6.1 000/533] 6.1.165-rc2 review
Date: Tue,  3 Mar 2026 22:18:59 +0100
Message-ID: <20260303211859.108822-1-ojeda@kernel.org>
In-Reply-To: <20260302160943.2522184-1-sashal@kernel.org>
References: <20260302160943.2522184-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 02 Mar 2026 11:09:43 -0500 Sasha Levin <sashal@kernel.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.165 release.
> There are 533 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Mar  4 04:09:42 PM UTC 2026.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
