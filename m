Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F5633508E;
	Fri, 17 Oct 2025 15:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715202; cv=none; b=QHl3xWHBc3WAaDVvbrElLoLzYm+rmHDkvu74dZjS3ZmCfoSdWEQ5anIG+usUFJA0nvokZYUkvBtxyjo/ApYxTWIaDkL+yPMhnHzosyifr51bW3xHrXmKwzklr/bCWvupMfYhk/7ZCvrl/D0Ke5HIHC//Ej1TGhQ9GoBl9gBZiwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715202; c=relaxed/simple;
	bh=o3TtHpvnnc82H7yNIMBhkaxhFHJQrVVIyyjFGkw6dNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C4pycxWZawbN1N80Jin08mOo4AwcnpdSemMF85K07lCR0yDeDro/KFSZBngqWVVowLVxGOwsRaWpeRfkTAGposPYCoDfPWFYqVSZH1OFoUsZwPeCGoWVkCLJzI/UsDks6QPmdWg16J6OHZfFcccZfmY6plw7oPS/AcUP1rHPYso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V09AMXF4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V09AMXF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D882C113D0;
	Fri, 17 Oct 2025 15:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715201;
	bh=o3TtHpvnnc82H7yNIMBhkaxhFHJQrVVIyyjFGkw6dNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V09AMXF4ReKuuLebTcI0OEiNuukxI0uB4SmpQqAvRG2wkvXY9X5v4etBR0sUTxgcZ
	 hciPSNY0aNJZ9o+ZmK/1KyHhDP7BMOs/m+P3Gp4nC1P0xI95RXrCSvC92a2ILsny+x
	 Vx6iItj8OKYQcpWlxblQlu/HhkThAyXIMqpsZKa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	linux-s390@vger.kernel.org,
	kernel test robot <lkp@intel.com>,
	Alexey Gladkov <legion@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 134/371] s390: vmlinux.lds.S: Reorder sections
Date: Fri, 17 Oct 2025 16:51:49 +0200
Message-ID: <20251017145206.777084323@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Gladkov <legion@kernel.org>

[ Upstream commit 8d18ef04f940a8d336fe7915b5ea419c3eb0c0a6 ]

In the upcoming changes, the ELF_DETAILS macro will be extended with
the ".modinfo" section, which will cause an error:

>> s390x-linux-ld: .tmp_vmlinux1: warning: allocated section `.modinfo' not in segment
>> s390x-linux-ld: .tmp_vmlinux2: warning: allocated section `.modinfo' not in segment
>> s390x-linux-ld: vmlinux.unstripped: warning: allocated section `.modinfo' not in segment

This happens because the .vmlinux.info use :NONE to override the default
segment and tell the linker to not put the section in any segment at all.

To avoid this, we need to change the sections order that will be placed
in the default segment.

Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: linux-s390@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506062053.zbkFBEnJ-lkp@intel.com/
Signed-off-by: Alexey Gladkov <legion@kernel.org>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Link: https://patch.msgid.link/20d40a7a3a053ba06a54155e777dcde7fdada1db.1758182101.git.legion@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Stable-dep-of: 9338d660b79a ("s390/vmlinux.lds.S: Move .vmlinux.info to end of allocatable sections")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/vmlinux.lds.S | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index 1c606dfa595d8..feecf1a6ddb44 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -209,6 +209,11 @@ SECTIONS
 	. = ALIGN(PAGE_SIZE);
 	_end = . ;
 
+	/* Debugging sections.	*/
+	STABS_DEBUG
+	DWARF_DEBUG
+	ELF_DETAILS
+
 	/*
 	 * uncompressed image info used by the decompressor
 	 * it should match struct vmlinux_info
@@ -239,11 +244,6 @@ SECTIONS
 #endif
 	} :NONE
 
-	/* Debugging sections.	*/
-	STABS_DEBUG
-	DWARF_DEBUG
-	ELF_DETAILS
-
 	/*
 	 * Make sure that the .got.plt is either completely empty or it
 	 * contains only the three reserved double words.
-- 
2.51.0



