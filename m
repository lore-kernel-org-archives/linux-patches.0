Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DECF4FE2E8;
	Wed, 30 Sep 2026 15:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783706; cv=none; b=OQCkqdtlZYxMmEBUc5wcAT/WEtYtwgLQgAOGhRk0fY+wqMTuJJYNNOOF/43CjM6QTx4DsttoRGj63nHhiM1md0+gWqgFc96NVMy9Od2yCYm6kfLQe54dvZXf//KbkNrmf40Mi/x0rPP9JpAx6ghFhEHxG7V+3MlZ4F8zKHcXxzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783706; c=relaxed/simple;
	bh=jhPDkvcy5BK7F4v/cAVOoqpZDnzGmHKy9MjMQzTkY2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oMChGkfkOpV+uLnhlcCkgbpGk9FtjFBWZTJ6BDwy4wOw0aPactsyHpA3bvK6BsSomfZf6wjamOqnaX+2a+6KYr9pK35ncb6g/+n9FNmbT/w9GycQI07TY+a0/ffWdTXA4chSq3n64JG0+Xb5NFtBTlhw4M5ClpZtc7qGwmhSUjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mYJIlgTV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mYJIlgTV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A05F1F000FF;
	Wed, 30 Sep 2026 15:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783701;
	bh=KbwjaG/QULnWgQkmfTfRvQEDrH/mdZdz7MvpXex4rD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mYJIlgTVCfej58IlTMdgAAUEteCopHs13w1rlJMgVeMHloVgYDkH9p3yxSU6h15Qe
	 YrSi85a91V2qP7vNcNckVj+6oJL0MymmQP/Ve4sTB9RXLGQyfELa2Pn6IZLriAiR6/
	 kCG+AoCQ7Sg4yhgEMen1pKfN5Vdv+04I/IYXh5vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 490/595] s390/pci/docs: Fix sriov_numvfs attribute name
Date: Wed, 30 Sep 2026 17:26:23 +0200
Message-ID: <20260930152358.229725994@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 4525a911049543c23885a540a788d13be318a486 ]

The attribute is sriov_numvfs (drivers/pci/iov.c); the document names it
sriov_numvf, which does not exist.

Use sriov_numvfs.

Fixes: de267a7c71ba ("s390/pci: Documentation for zPCI")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/s390/pci.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/s390/pci.rst b/Documentation/s390/pci.rst
index d4cafd92529f0..c487e41d6ba28 100644
--- a/Documentation/s390/pci.rst
+++ b/Documentation/s390/pci.rst
@@ -60,7 +60,7 @@ Entries specific to zPCI functions and entries that hold zPCI information.
 
   A physical function that currently supports a virtual function cannot be
   powered off until all virtual functions are removed with:
-  echo 0 > /sys/bus/pci/devices/DDDD:BB:dd.f/sriov_numvf
+  echo 0 > /sys/bus/pci/devices/DDDD:BB:dd.f/sriov_numvfs
 
 * /sys/bus/pci/devices/DDDD:BB:dd.f/:
 
-- 
2.53.0



