Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357EB54F81
	for <patches@lists.linux.dev>; Thu, 25 Sep 2025 23:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758843975; cv=none; b=I2nLHGwFefCT1A5sH2h5fD7al+WXXitk2Ro2Z26mxn117V8nBLK5kiSBmoC6Rrd5WBZurI3KuVnRhO596VTKjzM7lTN5mpZ/LxGwddXtOyu6nFAjks5FUaSdjc9rM8HT8ehz3Vah9UyW5NzBXzpniBuie+K+aoCsrntPXvF6f9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758843975; c=relaxed/simple;
	bh=BTz2dqzjufAff3cToSGp2U+KM2FiE2ziyECnjpSiYcg=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=gNU2m9vvGIAGXRd9eq4FHQNAwDXuitmNs+rZq919tQuOKsBzTvQdw4486UP+djfDjLmIvGV2VuH/cjNv1mWUKuWkx77RMza9BjYtxd62V70XZM/N9cu60UntSFZzLPQI838sR1XHFh0UbhQxjSNIP/NsKO7E04gRcuRQvxjtVMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QEsgX/7w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QEsgX/7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65AF9C4CEF0;
	Thu, 25 Sep 2025 23:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758843973;
	bh=BTz2dqzjufAff3cToSGp2U+KM2FiE2ziyECnjpSiYcg=;
	h=From:Subject:Date:To:Cc:From;
	b=QEsgX/7wcHRNzl+DejZjlOEZH+Px+o+nSZg53fjdKmF63FCc50uro/GCKWcjCouLg
	 IRBVqoZ4CdHTps5ywhfTtg46E+xHmlX/788swYivwRbG0nqye7EFyIIV1/Dtb6QYh8
	 IFNMBOOHUHZBw0WGfQFUa47Q0ksrr/jdV9+zqhNBhPCqTRtvErKhKrOLu4WMJ9p+Ju
	 KEiKb1vNliCOgy5evYKCw9fWdN+J3U0VN7W1FikOcWTJZ0DQezxgqfRvHsgUkh82Q8
	 ZbzUa5an1pBVQoNLl9nyVQWCJRMXauozPXwjT8LbVWrwUURg/cD7kaZSwzQgsI0/yu
	 A9WRteHU3INBg==
From: Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 0/2] Fixes for pmac32_defconfig after fb.h removal from
 backlight.h
Date: Thu, 25 Sep 2025 19:46:05 -0400
Message-Id: <20250925-ppc-fixes-for-backlight-fb-h-removal-v1-0-d256858d86a6@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAD3U1WgC/x3MTQqDMBBA4avIrDuQDmh/rlK6SMaJGWpNmIgUx
 Ls3uPwW7+1QxVQqPLsdTDatmpeG66UDTn6ZBHVsBnLUuwf1WApj1J9UjNkweP7MOqUVY8CEJt+
 8+RkpDP5+Y5bREbRVMTmbdnq9j+MPf+/WQHYAAAA=
X-Change-ID: 20250925-ppc-fixes-for-backlight-fb-h-removal-2b6a87cced02
To: Lee Jones <lee@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Daniel Thompson <danielt@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 Christophe Leroy <christophe.leroy@csgroup.eu>, 
 Simona Vetter <simona.vetter@ffwll.ch>, linuxppc-dev@lists.ozlabs.org, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=832; i=nathan@kernel.org;
 h=from:subject:message-id; bh=BTz2dqzjufAff3cToSGp2U+KM2FiE2ziyECnjpSiYcg=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBlXrzgdUnxtxKUdeFHILKSJ5eL7NKNTLtY3VjLpntdfe
 n+C78EZHaUsDGJcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAi4XsZ/uelJu19XOr49Nfm
 qtN57VcWCD98dF/o3J0D77e82hfD/c6NkWFjCPPcnZY/IzUNPs380SWXLGcwZyb3GxfFvy/OWlR
 OEuIHAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Commit 9f218f9bb9d2 ("backlight: Do not include <linux/fb.h> in header
file") exposed some necessary includes that were missing from a few
powerpc drivers, breaking the build. This series resolves them.

This should go via the backlight tree, which includes 9f218f9bb9d2, but
I have included the PowerPC folks for visibility.

---
Nathan Chancellor (2):
      powerpc/powermac: Include linux/of.h in backlight.c
      macintosh/via-pmu-backlight: Include linux/of.h and uapi/linux/fb.h

 arch/powerpc/platforms/powermac/backlight.c | 1 +
 drivers/macintosh/via-pmu-backlight.c       | 2 ++
 2 files changed, 3 insertions(+)
---
base-commit: 9f218f9bb9d274b9d5d48a4c95e1b199141fc1f2
change-id: 20250925-ppc-fixes-for-backlight-fb-h-removal-2b6a87cced02

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>

