Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAAF231832;
	Mon,  8 Jun 2026 00:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780878893; cv=none; b=d8bBPtPFMrKqu8GsH98xKsad/ocVppFf1XY93AIr5LEodXm2Jv9vCcSar2g2UwX0c6MGZiKJ3kB5oawlRbFCt2It7iwom0s7dPcDut54fAdPa0qIseMPCoL5S3R8GJIeQ+NE96OcDPdlFxumIWTzIl+1RkRpGXTtW36a9wRCU94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780878893; c=relaxed/simple;
	bh=EOnlkpSzR/C/9MwgWO0igt25VjNRRz2875zDoTgWfzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMb9cSIpCU/RuhZVRG+h8BumFq+qSsBBNrPUu2KC8Lz2tLUuTBmh9+p7UanHP1H8BGRuTsv24ixPX5arRHuOW6xdCMgCrl4taLnGn5QBftags3PD9ZZglFsOjM6e86ONT/Ht2GqayFA86d8UGYd8t7Z05HWkzmWvXqq955zYorE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CjmC5Cwj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CjmC5Cwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4A41F00893;
	Mon,  8 Jun 2026 00:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780878892;
	bh=EOnlkpSzR/C/9MwgWO0igt25VjNRRz2875zDoTgWfzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CjmC5CwjFRZdh2qK9utIGxpNsN50IDADdVWdY7iNxrp7kRBReEoeHB5w2oBUvikeP
	 4HUZfmAnAxUdDWOB3lYJDaOyKI/2IoU4lZrSG/lBS8ghmVkUxBfCo3JEobdjboG9L1
	 tPO1Sv9eEk8TvMtqdCJWzD4vGhbU10f1yV/W2ZubBSgAU+8N07B4rI54J849MuOfVK
	 1YGUGK9Rub4QfJDGVRQpM0ythlEfJNStln0Ue2CAuX95DuHMlaydPg/L/ysftar4FK
	 LKDpM3IVWfW3SS8qxcZHmdVNcxTScHTA0ZFusxcRfoyF3OLNYOOHnU/xhDPzwL2SvY
	 i68dXq3EWEUIw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 6.18 141/315] KVM: arm64: Correctly cap ZCR_EL2 provided by a guest hypervisor
Date: Sun,  7 Jun 2026 20:34:46 -0400
Message-ID: <20260607202000.rc-0001-zcr@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <87y0gq8cov.wl-maz@kernel.org>
References: <20260607095727.528828913@linuxfoundation.org>	<20260607095732.780900893@linuxfoundation.org> <87y0gq8cov.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> This doesn't backport cleanly before 7.0, so please drop it for now.
> I'll provide a separate backport.

Dropped from the 6.18 queue (kept in 7.0, where it builds), thanks.

--
Thanks,
Sasha
