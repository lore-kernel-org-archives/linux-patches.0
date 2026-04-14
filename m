Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBE1318EC1;
	Tue, 14 Apr 2026 18:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776190929; cv=none; b=WE3mVsLgzBHOiIRYxnbKao6Ewaf19/Q66VNmt1UklURblj5muETDdpEmwlJJUX3Q0WBVdKJDAWlAJVacPJZZ4SHz4sgzvYPOnwpIGII6TD3DZ5hWJm81NkUePGdewLMF2ymvPF1w20xPwkFG6GEXCB785cZBr9hLfea709Mw6K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776190929; c=relaxed/simple;
	bh=jC4NIa88RJlvlo8beAEl5OfLPrBbh4PRrRGdH13t0GQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YYJHV026AJIQoQuQZZ5DPi9y1E5cOwtaBEiASdJlzfFZEdFQ0ANIBp4s4DHrZd+mcx2zkuiuNLr03Gp2ftNFecPNuYiFY+sHFbYXGTyFmAfqQSd8FTSuZgaDpP7eCv31CKY/EgJE8tAnumAHzgcf6y2ITQI/EVzij94jtja7u8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n4uOKkBG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n4uOKkBG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9771CC19425;
	Tue, 14 Apr 2026 18:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776190929;
	bh=jC4NIa88RJlvlo8beAEl5OfLPrBbh4PRrRGdH13t0GQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n4uOKkBGMrViO7q8QIl2lWIG967Qllz/FqVRMG+Jefx7J+qdV23coe+iRdmG2LOwg
	 bnigNZ3ZuPkDqhQ38gtKSn7smIRMdxy1DZmj9gjvhxgNz5PNMIyVF2lBeDoZ5zdlbp
	 BS7TDaBZ9RnRwMm9F5kPRs1w3AFzk4G80T1rzCVrztMZmBcGuCid1Yl22Om5b7lxxw
	 6Lvw0Bgjh8wNBYvcldD0XO4r1/jPLGAHVhlo0WQQhH5euoIKHj8MJAAnWl7+9wo0pj
	 wJVmsQyy3olaGHrm2WfP+FHn0aRB9EG1yY8DRaB4R49cAybUCzExdd/7vGQGE2U75o
	 CdocJrJYoSZxw==
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
Subject: Re: [PATCH 6.19 00/86] 6.19.13-rc1 review
Date: Tue, 14 Apr 2026 20:21:58 +0200
Message-ID: <20260414182158.271797-1-ojeda@kernel.org>
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 13 Apr 2026 17:59:07 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.19.13 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

(arm 32-bit seems to build-test fine as well. Same for UML x86_64 on
a non-debug configuration.)

Thanks!

Cheers,
Miguel
