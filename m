Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E732D949E;
	Wed, 29 Oct 2025 11:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761736654; cv=none; b=WAnhbmfEn78wnZSG1OrO4m30hY2P4NXTw7PfbZaoQrH9/Y025aboVMvemv99dCrCNKz54XtTMRgoA8zTPs2J/O70qjeEw1+AENFyrUXP4hEVT0A24FNt0zQUwnhpkLBpNeD7S4PF20oG77J90bXSB43w7bASsoqdQCSyQw6fq5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761736654; c=relaxed/simple;
	bh=iWFRpQCS3Vj+W/GLm+z3aHxmknQWqjk80hKz3Z3Gg4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=km3B4ITSfdgVkDzU7y9TAomAIbhi9qiLKSZ93KTC7gvPZbUnJw4uWdhsZco3yMP4Hpld16Z1mRJoBsDmMba5Iqwk05qXLBFu3z8dpjFhNYPdBnPAbROXoyA2vF0Mq9VRcXb85E3Qy3cZ0Pr1fYlXBGZkhfwBtRK4fBIaDlpHJuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TbEvKmKP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TbEvKmKP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970B0C4CEF7;
	Wed, 29 Oct 2025 11:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761736653;
	bh=iWFRpQCS3Vj+W/GLm+z3aHxmknQWqjk80hKz3Z3Gg4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TbEvKmKPjOvV6IvbFv7ELvMDfpogiDNlSQh7++LoUTM5SKTGqODvd/o/UCodyCIBx
	 CQDQ58VRUuN++fbkaXNumb1hTSVloPgVY1npKv/TbbVG/WX/f2WHGu6wjguhARmndu
	 SdBOGoHfzq549r/P0B38x78KMK7HkATZrX+ksD7fHkKR+LJaGsDQ8KlktK1R+IsWk3
	 bxWzzlcdy/9pytox/Bsl800zyHWTHTeKSmYPsE74Hwsh4X8YXFtl5vDI4jYQV7mXS2
	 DEKSQRoHvmnBAKtAhwTN+ZYIWkTeAEGs/yd3a+dF6VRDC6n+M27TQvQWJ6HnCbZlRC
	 stMZybETKhi2w==
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
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.1 000/157] 6.1.158-rc1 review
Date: Wed, 29 Oct 2025 12:15:16 +0100
Message-ID: <20251029111516.695949-1-ojeda@kernel.org>
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 27 Oct 2025 19:34:21 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.158 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
