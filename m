Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795732762;
	b=GtmyRpGDlWpAJYi6CUjFiSt6KShUg1ssdZs5EjBH3YRJMRZnJEY6fvKasMqtN7+O+tLZ
	 cZoTodq0HbKXrjBtnIF3c7Q6OU8ZxgrshLk8PRxzPXlyxqq93MCbtYWtCiofvEfrRPw6E
	 bYWZlTn/huzWjdNPgrslzXyqnCgfcRJcyIqIAG49p71nk2L0LW03054fOfFlwZeyo2Dmd
	 oDhWSOPW10OAgimf1qOYWT3SFvTxqKaAcCI0zN2BLYKBWPK3eSrLhwZb702A1dXn61vP6
	 Zuy3oiMwpIzUPIYZnBsFn1DdBkvRYaAc+NShitrUWQOpdkNwy2p0JxaO8DXOP/Lqp+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795732762;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=j3sCvAM58RnPTWlkjVMsDMrLs+zOy3TWIqQOYkt19cM=;
	b=lQT7phb5YGEOWLb+ijp8OENLf2Pb7SdggIDXsgqKBk4q+UP+GwWM4OFMdJW1JQnUoG+3
	 IWxba0whZ0vI68LdFHvb1Xjbgi2iv7NudZ4pniGY/9d3KtEOWTw8u3BctiVaGXGtYZazj
	 PQ+kIwX4oC3rOoOYh05b8PHht2kFZWDpSMn8HECuOOHXlTf5uRVd8AcG9K8qxKMdO5WfL
	 BWl3C+YTbKNLNMUe8ZS87xa/DE2Z+at2ajUaLXpdEBDGOhqoNdPMHy6jDSdTO75QwMmdW
	 3khA+aroPuZFymGU9e5qhO56PsYaGGl6NlNbgIiZmUBE7dQ5DkBSbVMxtrsnbo8/9Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dmT8pSht;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7706606A31C;
	Thu, 26 Nov 2026 22:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dmT8pSht
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D2DA1F0089B;
	Thu, 26 Nov 2026 22:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795732762;
	bh=j3sCvAM58RnPTWlkjVMsDMrLs+zOy3TWIqQOYkt19cM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dmT8pShtqi3cBh79fvb/YLc3l2C/xLNdrxeCoZf0x3r+v2E4FR0LUNKYF/lc6k4py
	 Mdv1JFDz3bwH3Jb2YEamn4bXiMK/AJ2a7rVovYlNnRiqfZK+9QqTevo9sleYYhPngB
	 wy5EI8HkNxHcX3psxCzCmr1EAiKLoNlEFZQy4PqKHPXZu561tGqbqSnAYA3Uc+JlhT
	 rISGT2aW2/xLhHN96HRWFWPgN/eFso6BJIDlS1Gr08GlrWjStN8+iM9qkIR/yvfPXl
	 jIxzbjq1gg4t+GUJP8yTZn9lXnRp94D06yQKIRrzxDx2has01dOwlT4iduut6jThLj
	 +t5QMzI7DWodg==
From: Sasha Levin <sashal@kernel.org>
To: Brett A C Sheffield <bacs@librecast.net>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
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
	sr@sladewatkins.com
Subject: Re: [PATCH 5.15 000/319] 5.15.227-rc1 review
Date: Thu, 26 Nov 2026 17:39:15 -0500
Message-ID: <20261126223918.1165617-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <awhOX69A7DAA_-UX@karahi.librecast.net>
References: <20261126144006.732901931@linuxfoundation.org> <awhK_0exBWstjZw7@karahi.librecast.net> <awhOX69A7DAA_-UX@karahi.librecast.net>
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

On Thu, Nov 26, 2026 at 04:21:03PM +0100, Brett A C Sheffield wrote:
> # first 'bad' commit: [f1311182306c2b85f4724cb776467034a36baaa6] initrd: flush deferred fput() before mounting root
>
> Confirmed that reverting f1311182306c2b85f4724cb776467034a36baaa6 fixes the
> build.

I've dropped 807c1d7125a2 ("initrd: flush deferred fput() before
mounting root") from the 5.15, 5.10 and 6.1 queues. It calls
init_flush_fput(), which only exists since 386dc41cf54d ("init: flush
async file closing") in v6.9, and that commit doesn't apply to these
trees. do_mounts_rd.c is only built with CONFIG_BLK_DEV_RAM, which is
why it wasn't caught earlier.

6.6 has the same problem; there I'll queue 386dc41cf54d ahead of it.
7.3, 6.18 and 6.12 already have the helper.

Thanks for the bisection!

-- 
Thanks,
Sasha
