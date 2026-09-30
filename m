Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAC251DE1D;
	Wed, 30 Sep 2026 18:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792861; cv=none; b=EEHARiOz/joz6MS5HkHVHBt92ozTLWodQmOT59lrg/jwRALnpiTt1QAnMymK2YeUQ2QdY6YyxjbBBQfeekgEag5UvSChS0aFrW3sxf3SsrYrjzOFt39RvkRr7WMtoXc7CEE+ZMzsiPx8+LoRIghHyd0FfF6jnpBxpb5+KrqJhE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792861; c=relaxed/simple;
	bh=embcVfFT5hhUGORCep9Oyr7RHvPycDuWy2Ocfb5vVwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PNDuYc42fB9KkbPA5tt0ZWyRlIRBNUTxjoQteLj94yNER0pWuASKDETR6FgbMz8zc9ejSe67SVKTCPKPotJQwyvYLY79rw5+FCdgywDXj83PJgjXDuJybnM0PlV3oI2GJ3Arx1VfaTHd2R0oEF+ZbxFI3QoWMAwiG6v2F+HiQsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fvqqb0uh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fvqqb0uh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D612E1F000FF;
	Wed, 30 Sep 2026 18:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792860;
	bh=sD3NlJDqBBNIKDPbMJCOkCzCDTIW9erzr2ZLceR2z6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fvqqb0uhv1ZYNpS/a5maKyXPfvsi36Iecg+7ISFfiASvtMOyWdXol7HHoymjpzr1I
	 cyq5lxF7WdLh+PlsfrYPHl1HRLa7GqaRgoS1qGyzf24evPbYpKyxnQcQiF3syVSSeT
	 JNV9ZkBY14pOCFcb5XxyYRFNOyu8MS7vYVJ5nuzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 051/395] s390/pci/docs: Fix sriov_numvfs attribute name
Date: Wed, 30 Sep 2026 17:25:13 +0200
Message-ID: <20260930152341.743116495@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c3476de4f0327..8dc09634163ba 100644
--- a/Documentation/arch/s390/pci.rst
+++ b/Documentation/arch/s390/pci.rst
@@ -60,7 +60,7 @@ Entries specific to zPCI functions and entries that hold zPCI information.
 
   A physical function that currently supports a virtual function cannot be
   powered off until all virtual functions are removed with:
-  echo 0 > /sys/bus/pci/devices/DDDD:BB:dd.f/sriov_numvf
+  echo 0 > /sys/bus/pci/devices/DDDD:BB:dd.f/sriov_numvfs
 
 * /sys/bus/pci/devices/DDDD:BB:dd.f/:
 
-- 
2.53.0



