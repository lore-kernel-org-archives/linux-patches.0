Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181B782488;
	Sat, 28 Sep 2024 20:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727557187; cv=none; b=bES9Ih5X6VAfGns/LE8sstXPkoUKwlJLFIs7OQ5kZUWvzo536pJneCJOuGPNFsYcZIY8ahMqe95gCJKxiYYLSl4URZjHT/9BQfjsh6mjf8Sk87EWrzMJjMBEAc3hboYNqlwnuay3RhnYRgzH/SpdD//RAHzlUbFSxOskUiA+GDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727557187; c=relaxed/simple;
	bh=XLcLClrDjKAXamerDDN5J2Tr9UQKslt6wuhOFXsAcw0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gk/OtgPxKPeD19X8284R7GNHlngKvkopI80OVNT8aTVyTBvY03IEgSQI0aaA1wcCHF+2+0kYMWfobjltJSCvERNyesaqRs4uAdiGTjI0+HRvKP+szAKHx7/sE9AE4FPMvZOlQ2AeMaGfGgtY21fiiqcvu01l2H4YcErKB+lRzT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MEPzX6In; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MEPzX6In"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E422BC4CEC3;
	Sat, 28 Sep 2024 20:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727557186;
	bh=XLcLClrDjKAXamerDDN5J2Tr9UQKslt6wuhOFXsAcw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MEPzX6Inhs9v4VlSVmNnlD2tbJYOJU2RxMDT7+L34VSNM1oUMAl87Euvtb0+7jyTd
	 qGZr5mnRWsbaSzFqyjdoVRNZPT7ff2q2piwkcl6Rbwqht5g5tSySTCQtRWogFd4K+K
	 f4pNEJhwnuyqOHjmLL9GF7ei33bGhbKu4K3Ft/FGnz8Izrh/YkBlRBqxJT3lyvHYka
	 93CYXpIZSAwtH3fEd/M8xQXb1RiVi5V8hlZmidehREqObUKgsRSqq1r9bwk/icvSN+
	 JS5um6nxpzXtUaUFbmcDANyVrFsd62VOHyd+87uXRQk9PsoioV4xcBOMAK2JALhmkh
	 Hn1PA5ryxqiqA==
From: Kees Cook <kees@kernel.org>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH] MAINTAINERS: Add security/Kconfig.hardening to hardening section
Date: Sat, 28 Sep 2024 13:59:44 -0700
Message-Id: <172755718364.3162798.18308509472992030352.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240928-maintainers-security-kconfig-hardening-v1-1-c8c64071cc02@kernel.org>
References: <20240928-maintainers-security-kconfig-hardening-v1-1-c8c64071cc02@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Sat, 28 Sep 2024 11:26:09 -0700, Nathan Chancellor wrote:
> When running get_maintainer.pl on security/Kconfig.hardening, only the
> security subsystem folks show up, even though they have never taken
> patches to this file:
> 
>   $ scripts/get_maintainer.pl security/Kconfig.hardening
>   Paul Moore <...> (supporter:SECURITY SUBSYSTEM)
>   James Morris <...> (supporter:SECURITY SUBSYSTEM)
>   "Serge E. Hallyn" <...> (supporter:SECURITY SUBSYSTEM)
>   linux-security-module@vger.kernel.org (open list:SECURITY SUBSYSTEM)
>   linux-kernel@vger.kernel.org (open list)
> 
> [...]

Applied to for-linus/hardening, thanks!

[1/1] MAINTAINERS: Add security/Kconfig.hardening to hardening section
      https://git.kernel.org/kees/c/045244dd5d75

Take care,

-- 
Kees Cook

