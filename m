Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F61319005F;
	Mon, 28 Oct 2024 08:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730102566; cv=none; b=mlVksBJAJENxHzO2PmVYqE7IM5H1rLKSDsriBF5RuQGkSQH/FFpfOm9NJ9IqTA4g3yGUVsU4eDKnxXWmtlXWShTT20lfC55QNg3rASE+1W+ex19UxtAYZgw1PhF3tmF+hFhBsj9Ljb5n+XDGt9h3KSsBromrS/H3GMGdZleV1i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730102566; c=relaxed/simple;
	bh=K8ruHr4Vpi6UuS7UYRX7Do+93K2LGPQkisXuaj/syr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kpqg5t2IH0iZforrMAGUxsjY+Y3WSN1NLQrBqpAcnixXP7yggfvT9ZPA5w2Z3J5dZPjJ3AAEzivJfODiRmXDPagg4iDzo3Zg+fYYoF4hBo9SUyz4MGrSfPy3ZQGSTRCC1+UPj+zTRz6voJYbJ/viqGKCSTcQneXqqnbEjKL6Zr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JAMlfA3W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JAMlfA3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81376C4CEC3;
	Mon, 28 Oct 2024 08:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730102566;
	bh=K8ruHr4Vpi6UuS7UYRX7Do+93K2LGPQkisXuaj/syr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JAMlfA3WanPo/YvYH/hFi5moQ1zRFVz5T20FSKviO0FbXMlxafGT66PmrS3aQXxHG
	 3U0qygwaQilMl8bR46BygNTi7JK8jKlGby+LBBuoS9d22nEJQp0qU6aqE7tjvC7WVb
	 C1Kci0jnyeosZAIIf0AvKsdpcm9coPQJgwb2NgkNdRL5WEVsQMSuDXiQ2/Z6SgFeQv
	 Mz9bgr5v8QSULJIZtc5myt5pAqouiXwR3L5lWOIgmewILbcq4XPXSa1I1Vo7DvCKac
	 vxcw8oGxr3VhW7G1P69m9eXwuKXAwobdleyXEhDaOxR/U+tAw4C9jGkCy/uP73copZ
	 +sbsn0Xp5VeNQ==
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
Subject: Re: [PATCH 6.11 000/261] 6.11.6-rc1 review
Date: Mon, 28 Oct 2024 09:02:32 +0100
Message-ID: <20241028080232.589602-1-ojeda@kernel.org>
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 28 Oct 2024 07:22:22 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.11.6 release.
> There are 261 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 30 Oct 2024 06:22:39 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
