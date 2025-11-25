Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FA92FB0BC;
	Tue, 25 Nov 2025 21:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764105960; cv=none; b=vA3zEuRqqMVJ9L+9x4zgWCbWh2ANLC0wZmwdgA/to+YNRKrJf/G5NAgUmb6LbK1IcpSsFbWpq+hVwHEZtijW9uroGswawb1vc4rdteAD7PUVVEXsQSLyMMhPGEPgH0KRyuCEGlet01tvWIw/EEa8M06fdUg01oMrAxTl301N5Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764105960; c=relaxed/simple;
	bh=bef6yMABPv/hypevyI4Lq+80S7ARj2nTb5O5egnjE/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LxWtQwy1vDPLsnaR3jofj77Bn80YLKhXUIXYA1YPOrrYEI7XakfqAxbW/XyCFpu3KrfVZUbMLt0/J3yUNBk3/D5WjzdYrW28er0PXbjK8upXH7vv886/BDDYQb49D1QaODLu3a0F+e0xSOnGfUwEpQElP+41P+Cbi3HVpuemARk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=orbMk4MH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="orbMk4MH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF28C116D0;
	Tue, 25 Nov 2025 21:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764105959;
	bh=bef6yMABPv/hypevyI4Lq+80S7ARj2nTb5O5egnjE/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=orbMk4MHqTKNugXgoAHwkxwN3XU1m9vyqO25ZroD7/chhRdCoAixusAKJHXt1CQI4
	 iDRCKXxf8XHRXEmk2/T8LmPWC0VXrzD0nRZCo5Fkz3anm87X7TEpZywCTxkD4GU1X6
	 3FO200hJe+YWv4MgASwhXtZlg/w23j7mXDTlu67yqJRhZR11i+pgfJeaglMF7Zt4zW
	 QahubkEAGVCT5NzmMjCPyVAItov8Hdnrxix6STvkVO8iQMG7z0Zrx9JofTGOQHacIy
	 SmLGL5ZulvEVEyKMryM6T15hJjt03jsNJXcOQAtrNCc/pxaDTQVDTBpOQiVBZkvzAd
	 PkDClAS1OCsNQ==
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Nathan Chancellor <nathan@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] KVM: arm64: Add break to default case in kvm_pgtable_stage2_pte_prot()
Date: Tue, 25 Nov 2025 13:25:56 -0800
Message-ID: <176410594557.1756747.6202745594251816164.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251125-arm64-kvm-hyp-pgtable-fix-c23-ext-warn-v1-1-98b506ddefbf@kernel.org>
References: <20251125-arm64-kvm-hyp-pgtable-fix-c23-ext-warn-v1-1-98b506ddefbf@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 25 Nov 2025 10:59:15 -0700, Nathan Chancellor wrote:
> Clang warns (or errors with CONFIG_WERROR=y / W=e):
> 
>   arch/arm64/kvm/hyp/pgtable.c:757:2: error: label at end of compound statement is a C23 extension [-Werror,-Wc23-extensions]
>     757 |         }
>         |         ^
> 
> With older versions of clang (15 and older) and GCC (at least the minimum
> supported, 8.1), this is an unconditional hard error:
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Add break to default case in kvm_pgtable_stage2_pte_prot()
      https://git.kernel.org/kvmarm/kvmarm/c/621e0a641f64

--
Best,
Oliver
