Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0BAF131746;
	Thu, 25 Apr 2024 16:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714064183; cv=none; b=GzO74ixVL0S2W3TV+4jgYePW0tHouhjzkpeCmldzTvpvG3qsuCIIjdoRaC/fOn0e8SXuw9OrX7SMLla154dfL/zHLmf2lopT1EoJekgnV/93PsKYTCA3j5n2HTMUyzRfSkd4uJaTXPqMPUx5DH9PxQ2eZ3cQlBPiyQvdzRLDtHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714064183; c=relaxed/simple;
	bh=pqXBKkfg16S/wSwcWzhP5AcwQgNcYGD8sQW2Qy6S2gE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=nEYsWs3NPgqwgUTXIPIsjDWrcNJCQpIWcADeGb5PI5dHsxAaysX2kBNtEc773y5G/VtPhPhS/fUOV/mrEO1bynu9m7ZT4DNGMJP4Y4izkZPh1owo50YWow4nvBaTv5V8Bvs3+ILVoQnc9vkF5fA3EqEde4HfcnHYRXUXZPZJars=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SL9MpaGf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SL9MpaGf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B274FC113CC;
	Thu, 25 Apr 2024 16:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714064182;
	bh=pqXBKkfg16S/wSwcWzhP5AcwQgNcYGD8sQW2Qy6S2gE=;
	h=From:Subject:Date:To:Cc:From;
	b=SL9MpaGfbXcWzu9Uv1a79Wr92gN6jiJcV684kZW+4XurbeG/EN2FP72lQUjdCdNRR
	 sJ80EkmgXtGdWWm6RRusMZ1L3p6ucWGWxUpCIzFDO2/V3AU+DjYVxlrPT0NFlkLe2H
	 RjdfljbIKaAyAOdawrwGS5i537euKB+WcAZMPwFrdt+Vv+SML2T+YIucXUqohqhnO5
	 Z91H4akeaY3xAs7cpwOV4/Kdl+GoC0LwfIVN/7dsl6Bm/ZqVdfEPJzNAs0WD0Fe/Ov
	 cI+PVSp9rm+za59x5V//1nybtJTsNHD7s6+4cy5m1jHJc13gMA6RtdATW/GCV5dj/a
	 cwgn/EO04N8jg==
From: Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 0/2] clk: bcm: Move a couple of __counted_by
 initializations
Date: Thu, 25 Apr 2024 09:55:50 -0700
Message-Id: <20240425-cbl-bcm-assign-counted-by-val-before-access-v1-0-e2db3b82d5ef@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABaLKmYC/x2NQQqDMBAAvyJ77kKMoWC/UnpINhtdaJOSraKIf
 zf0OAzMHKBchRUe3QGVV1EpuUF/64BmnydGiY3BGuuMsw4pvDHQB72qTBmpLPnHEcOOq2+GU6m
 MnohVkVI/xvtgkg0OWvFbOcn2vz1f53kBHlj2WH0AAAA=
To: Michael Turquette <mturquette@baylibre.com>, 
 Stephen Boyd <sboyd@kernel.org>, 
 Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Kees Cook <keescook@chromium.org>, 
 "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
 bcm-kernel-feedback-list@broadcom.com, linux-clk@vger.kernel.org, 
 linux-rpi-kernel@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-hardening@vger.kernel.org, patches@lists.linux.dev, 
 llvm@lists.linux.dev, stable@vger.kernel.org, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.14-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1140; i=nathan@kernel.org;
 h=from:subject:message-id; bh=pqXBKkfg16S/wSwcWzhP5AcwQgNcYGD8sQW2Qy6S2gE=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGla3abLrAoyVDOP535XeDTxamfGtwvcnaemf4tpfvwwY
 ELsZ46nHaUsDGJcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAinzIZ/udP3uh/yvPh92e8
 c/zCBb6f0b7G9iD6ouLqSyWvNj85d1Wa4a9ccah26p59wQyHkv667c78Hdv+8do+3Uemtcu/HbX
 YbcAHAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Hi all,

This series addresses two UBSAN warnings I see on my Raspberry Pi 4 with
recent releases of clang that support __counted_by by moving the
initializations of the element count member before any accesses of the
flexible array member.

I marked these for stable because more distributions are enabling the
bounds sanitizer [1][2], so the warnings will show up when the kernel is
built with a compiler that supports __counted_by, so it seems worth
fixing this for future users.

[1]: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1914685
[2]: https://src.fedoraproject.org/rpms/kernel/c/79a2207963b8fea452acfc5dea13ed54bd36c7e1

---
Nathan Chancellor (2):
      clk: bcm: dvp: Assign ->num before accessing ->hws
      clk: bcm: rpi: Assign ->num before accessing ->hws

 drivers/clk/bcm/clk-bcm2711-dvp.c | 3 ++-
 drivers/clk/bcm/clk-raspberrypi.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)
---
base-commit: ed30a4a51bb196781c8058073ea720133a65596f
change-id: 20240424-cbl-bcm-assign-counted-by-val-before-access-cf19d630f2b4

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

