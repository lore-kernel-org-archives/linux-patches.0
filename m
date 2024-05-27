Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A8015FCF0;
	Mon, 27 May 2024 19:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836508; cv=none; b=QxKzGVUByD5OmFsiDB9PCQDL+9cz/Ln1niSCpLn5/avjS64mWS6dUyAhsvofvKL576alin+67DURHiEbcHl8lG8cN7yvq80OAkcy4BNX7z7pBKMxoIVDBb3+850M0HGjOSNPCnMjhvHKhech0BaEt7zHfFS83wisjaEca0DzxyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836508; c=relaxed/simple;
	bh=Ric1IJhSF8Ns21d+ppGJLB5rplmNeqIMYHmzJd5COEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WjbovqHdcZXCyp7qSdkvzsMsDrGHxTChuNIESbgSdIxiuyftxEClvncYMi1xMWxvEtXQmfUDQTQC2H2329mLuxb6gXSViFpBDijn2c+WgEiD2XK3mlUA1iOZcrcqcufhi/AKUwhDnCScmilxxaqvOYfWQ99mHW1GjXP3eS+cCG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=txUS1enZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="txUS1enZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC0EEC2BBFC;
	Mon, 27 May 2024 19:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836508;
	bh=Ric1IJhSF8Ns21d+ppGJLB5rplmNeqIMYHmzJd5COEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=txUS1enZxpJDYzUOmBVMGBoBT3XamyyPRgNPclERzugRx/SSwYW03snk0buIVgD3z
	 NfpNqeT9ZFVNKwfVVItf49v2aO1yZihLjLctHuB52rjfCefPHIrhzWuwCX5Q1Eevxg
	 IJ8ojteXFiuM2cOiunUbpflKdvekpetccXRLHxEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 080/427] s390: vmlinux.lds.S: Drop .hash and .gnu.hash for !CONFIG_PIE_BUILD
Date: Mon, 27 May 2024 20:52:07 +0200
Message-ID: <20240527185609.220226597@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sumanth Korikkar <sumanthk@linux.ibm.com>

[ Upstream commit 5f90003f09042b504d90ee38618cfd380ce16f4a ]

Sections .hash and .gnu.hash are only created when CONFIG_PIE_BUILD
option is enabled. Drop these for the case CONFIG_PIE_BUILD is disabled.

[ agordeev: Reworded the commit message ]

Fixes: 778666df60f0 ("s390: compile relocatable kernel without -fPIE")
Suggested-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/vmlinux.lds.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index 48de296e8905c..fb9b32f936c45 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -209,13 +209,13 @@ SECTIONS
 	.dynstr ALIGN(8) : {
 		*(.dynstr)
 	}
-#endif
 	.hash ALIGN(8) : {
 		*(.hash)
 	}
 	.gnu.hash ALIGN(8) : {
 		*(.gnu.hash)
 	}
+#endif
 
 	. = ALIGN(PAGE_SIZE);
 	__init_end = .;		/* freed after init ends here */
-- 
2.43.0



