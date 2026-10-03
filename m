Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C7A3806B6;
	Sat,  3 Oct 2026 22:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791067014; cv=none; b=GjDq+ZEvqNL1gIqinjQQJ96hE47iuT+4OHTior57nfHqKUmm2PziWpgbpSRfnKex3jiLI826ax4VR4Bx/d4vDPe0tzATJnKbOv+MWFY5zjXxktFsOB75mOVjiFwZF1j1z0ombI9kM5wuC1syOAcUUMB1NkP9iZi+gs1uA1RbhJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791067014; c=relaxed/simple;
	bh=AMpFuYq3C8xtyCRvVQPrgAhN3noBgs1FU0fpFJSFsJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e7fXW62o33eX4qGnLjtJg+2sBojuRbydQbn/M/91FwWxeYlPj3KNndALlin1rC+hMho7B2XhSu27MYf+nz/w6BfvO9MI4+kilOC0D1/11a9frYDTNKe3/qx6ijTT3PmNCfS72zJKFMt+HXG1URFEcFMMkDNjfvvVX+oTxGOZHf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a+/Tr7s0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a+/Tr7s0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C0F51F0089B;
	Sat,  3 Oct 2026 22:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791067013;
	bh=D+q/ygXBBkvcngPgORCK68+QrlMtaNhYb5v8i0xI/XM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a+/Tr7s0zbUvPAzLTxfbLHO80x5v8/c+RbLyjM8ZClFXI/gOcuxgBghcWDESMSbtZ
	 3Cyq5mO2vSB0tFOqtl1HBy0D3QUsymQ8NGgJVbOC9CP/ku6X3NSIk97ncTMeTJ8sIj
	 DIuNbX+blTJE8A4tMFvdIh3kJLqLYRHetyDBjMtbYF+buqMjBaHPkKaine3PdSsaL7
	 3Z5h1+4wqTc1x+vzJjMQmC8aOL3RB6AXPR7u/0542ptvzueYnc9tZjGF/fz0tlf7ls
	 MjhMuPth6W4MXp67Z38VyeI59N9yCn2pSOvCQux/gBipniXNfMgKDaw+RP9SSBz8Cz
	 E0J8qTYBrn4ZA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 584/752] drm/msm/adreno: fix autosuspend cleanup during teardown
Date: Sat,  3 Oct 2026 18:32:56 -0400
Message-ID: <2026-10-03-1-daily-reply-0015-re-adreno-pdev-earlier-followup@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <dea57868-11b9-4061-8b6c-ee1e2c227610@oracle.com>
References: <20260930152358.131179731@linuxfoundation.org> <20260930152410.929547718@linuxfoundation.org> <dea57868-11b9-4061-8b6c-ee1e2c227610@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I think 5.15.y needs an adaptation of 16007768551d5b ("drm/msm/adreno:
> Assign msm_gpu->pdev earlier to avoid nullptrs"), assigning it in
> adreno_gpu_init() before fallible setup and removing the late
> assignment, thoughts?

Agreed. The teardown change already shipped in 5.15.222, 6.1.189 and 5.10.271,
so this goes in as a follow-up. Queued for 6.1, 5.15 and 5.10, thanks.

5.15 also needed 46d4efcccc68 ("drm/msm/a6xx: Avoid a nullptr dereference when
speedbin setting fails"): a6xx_gpu_init() calls a6xx_destroy() when
a6xx_set_supported_hw() fails, before adreno_gpu_init() has set gpu->pdev. I've
queued that for 5.15 as well.

-- 
Thanks,
Sasha
