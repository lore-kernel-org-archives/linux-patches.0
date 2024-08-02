Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15D73F8E4;
	Fri,  2 Aug 2024 06:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722581985; cv=none; b=F/94+Ne+VVoqY/osQUNCiZAMENa2/uZkOtujxeNKpslOebxQTaxqnQdeLAZbT8MvKbOKgs6NUy9GrJ021Bq4VHIf+6TLk6OgsQspKRw1+XvBgCq/c3V88bjgHAQpdEYVwUv2ySpRXsaZaIcMqUU71XrnnIG3b5uTkO8ww3iA3h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722581985; c=relaxed/simple;
	bh=wPXo9WLXJgkiQ1f24ZSB26fzNkiXPfwyOUq78QRxsnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbn4MrPQvz9V4rOlV83RYqOGSsbzEQyhSMIeNqwkdGLqZ3rNIQykPMyC+h72I6MoMTj7jFQ66cwtXr9Cl5KrrAWJ2rAfz0P5BQwsIOjgXrf7RJjveuZ/7xxC+dR7nTXp7IHdj/TTsTHVCQHMj8r6A9dHBjWEOfE2TEXcAWosthQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RDxjVouU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RDxjVouU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DFE5C32782;
	Fri,  2 Aug 2024 06:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722581984;
	bh=wPXo9WLXJgkiQ1f24ZSB26fzNkiXPfwyOUq78QRxsnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RDxjVouUiwaJUcIK17B7ea7csWgd0xhvss2+JIdXEw55Z7cRlGexRAXN+RtegSlhp
	 3k9dXLIkHTTmPZLN2EVN1jORovtqbRMZR88chDeRBm6VbZoebzf7XVKH5bI/mlmvWH
	 0mhfurrzOThhuxWHee8Rml7UCWEESikHCebXizXLwHqN1NNHHj7jNLVz7SBgut5o2S
	 V+pC3tTKHO0fMAGuQhdRQvPEFrUnC/C+aJEhQSKn3maYfHtDP0LWxi5N42CwwKSCj9
	 lBPaZTUId3XbENEKRv0CeStrV+KbRYUnFfUPwHyXq8w2bXYl/BXctCa4FuoER3HIPf
	 M1z4HJBvYjS8g==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
	allen.lkml@gmail.com,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
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
Subject: Re: [PATCH 6.10 000/809] 6.10.3-rc3 review
Date: Fri,  2 Aug 2024 08:59:24 +0200
Message-ID: <20240802065924.80385-1-ojeda@kernel.org>
In-Reply-To: <20240731095022.970699670@linuxfoundation.org>
References: <20240731095022.970699670@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 31 Jul 2024 12:03:16 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.10.3 release.
> There are 809 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
