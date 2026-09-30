Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1309E51614A;
	Wed, 30 Sep 2026 16:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786971; cv=none; b=WpNtxSbNOnZ/+rKAtn5/Y159oijMcAnqSUsYRnpEr3rEYle4J3VxrQilcYwnKIx3q1l2bKmC8HhMPnPUEeCDbQSnCdN4zEpj4WP9ruLUKhoN61OIqT6Iaww6Degu3494lmPHgp8tMHVPwe4OP0gpg1PUGbcF6YtkecPKdSPM3Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786971; c=relaxed/simple;
	bh=WKzTwQbK1cdfKVTAttebFD+DH7jVtDz7/O5fozQ9THA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQ4ILA1y7LhbJir1CgB9Uv7qTX7NfXBeH1e4oGKD7TyCRMinko5PJCDMldTgaAF/TsVJpuJGeyjX/Cgseqvird1Y7CjdPiusxnHXQ7lyiigcABlSKM/jHEKGMc5kXCNNwTS4F6CO/ejExc1/YwsRFNO19VBGuVKrf0jXGuxJLPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZKtHsPST; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZKtHsPST"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ACC81F00899;
	Wed, 30 Sep 2026 16:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786970;
	bh=MCdr4CT57VT2qzf0FMenSn9OzHN6qojj/xgiAUpXKlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZKtHsPST1pvYQKoQUomyxXx5zJgfiudzpnHDXuf33pkC4zMTGklZrCZQGnOupDKOK
	 Ij5vrChVHAZ8TwPcf4jY0t2iuHls42vk3B+9a3VB34PUgW2CjkNhsMU81ElfjvFN1X
	 vN/2FJh5Xe7bB6K5lEVUJf7yF+u/D0c+Rkd4Ulv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 059/457] s390/pci/docs: Fix sriov_numvfs attribute name
Date: Wed, 30 Sep 2026 17:22:44 +0200
Message-ID: <20260930152347.312057682@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 Documentation/arch/s390/pci.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/arch/s390/pci.rst b/Documentation/arch/s390/pci.rst
index 80f4ba1931599..565434626fb5c 100644
--- a/Documentation/arch/s390/pci.rst
+++ b/Documentation/arch/s390/pci.rst
@@ -67,7 +67,7 @@ Entries specific to zPCI functions and entries that hold zPCI information.
 
   A physical function that currently supports a virtual function cannot be
   powered off until all virtual functions are removed with:
-  echo 0 > /sys/bus/pci/devices/DDDD:BB:dd.f/sriov_numvf
+  echo 0 > /sys/bus/pci/devices/DDDD:BB:dd.f/sriov_numvfs
 
 * /sys/bus/pci/devices/DDDD:BB:dd.f/:
 
-- 
2.53.0



