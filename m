Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8D510E3;
	Fri,  1 Dec 2023 00:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TH00kKku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09FF8C433C8;
	Fri,  1 Dec 2023 00:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701390154;
	bh=Ilb3eO3YUqj5y0/iW1QC4OPosOBHuPTRt4ffM3o09Wk=;
	h=From:Subject:Date:To:Cc:From;
	b=TH00kKkuGItNvWqeNvJ70BWhLJQSk7KOMGcvCwMFjUFfLBDqX2yc0uiKkFTn5Wc6l
	 3+yBqByk++TMFMXBv39sZNgoYJeqnvvS/HITuI+/Wya0BtZNiGy91Nrc803dOG9QZg
	 qamB6KiAjoTY8WWbY48HGVet62t3vFshFcyin+so6DziIgRRHAdfwztVO/9B7E4BRT
	 ZN7tnPfsASZH1T/ramBUO2F0GpRG4PlYzRsM6mQ5dfYP44SOHcyyhDwuDKeS7HrjRg
	 RBxDEV0uti8vmcZPICYSv4ntIp/aFuHeJByx60JeSxwEOJ5mdyGfA/LJ9/A8G+eFWl
	 Ecn2WnREnH1dw==
From: Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 0/2] s390: A couple of fixes for -Wmissing-prototypes
Date: Thu, 30 Nov 2023 17:22:31 -0700
Message-Id: <20231130-s390-missing-prototypes-v1-0-799d3cf07fb7@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEcnaWUC/x3MTQrDIBBA4avIrDPgD6XYq4QsjE7TWVTFCSEhe
 PdKl9/ivRuEGpPAS93Q6GDhkgfMpCB+Qt4IOQ2D1dYZ4zSK8xq/LMJ5w9rKXvarkuAz+UcIZGO
 KK4y6Nnrz+T/PS+8/HkQ8aGkAAAA=
To: akpm@linux-foundation.org, hca@linux.ibm.com, gor@linux.ibm.com, 
 agordeev@linux.ibm.com
Cc: borntraeger@linux.ibm.com, svens@linux.ibm.com, 
 linux-s390@vger.kernel.org, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>, sth@linux.ibm.com, 
 hoeppner@linux.ibm.com
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=749; i=nathan@kernel.org;
 h=from:subject:message-id; bh=Ilb3eO3YUqj5y0/iW1QC4OPosOBHuPTRt4ffM3o09Wk=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKmZ6p7i3SUXvN3ucW/aPK3bKWBheG6DXYhX4DnL1vxMU
 +uS2NqOUhYGMS4GWTFFlurHqscNDeecZbxxahLMHFYmkCEMXJwCMJFMP4b/8fdjQsUtI5I0hAPP
 sH6ZKa5x9tAbwx9Vln2mBTkPcu+uY2T4X/c/KutLykbdB3/0xBgcK6cHzll05uPByDiNJP6oV1M
 YAQ==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Hi all,

This series resolves a couple of -Wmissing-prototypes that I see in my
builds of -next, even though the issues appear to be latent. The patch
to enable -Wmissing-prototypes is in Andrew's tree, so these should
likely go there as well with acks from the s390 maintainers.

---
Nathan Chancellor (2):
      s390/dasd: Remove dasd_stats_generic_show()
      s390/traps: Only define is_valid_bugaddr() under CONFIG_GENERIC_BUG

 arch/s390/kernel/traps.c  | 2 ++
 drivers/s390/block/dasd.c | 6 ------
 2 files changed, 2 insertions(+), 6 deletions(-)
---
base-commit: 2cc14f52aeb78ce3f29677c2de1f06c0e91471ab
change-id: 20231130-s390-missing-prototypes-7d95aae2cdcb

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

