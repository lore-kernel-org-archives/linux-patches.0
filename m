Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA285187D2;
	Wed, 30 Sep 2026 17:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789043; cv=none; b=mMAOELaRvy4X6J3thcDnDK+6txBODsCGpW0FPFLn+LoF5tclS3Cj6uHaqavb9uYkxD7EKGFWeCSn8jcgIZuxxFiQFkQ0sqrl4wj2B2sYELlF8q6NUp0mt2DNFRbp1Dal1tZVk0dLQkAV49NEaz7KqgKn6cdmIPNgp4ineAogZb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789043; c=relaxed/simple;
	bh=DoGNfSH/EkcUTMco3UlK+LyXfuplBxRYlBpl2tfCZbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpi7GgPnuKFIvqq5b5HaqIeqThD8T+H/Hl4XiDvD3opnbIOblMAxeHjCbQAJG/CQsYYTfDYfwAtM4izDTaBzpkNzU6MVGHtD9AkZKW+rr9lZBxx9tyrGsB2xE9nCF07Tnu5iPB7pgqXajvdkFANhsjvEKEUf2xq3pZTAbzma7j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wUcLD9JM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wUcLD9JM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C641F00899;
	Wed, 30 Sep 2026 17:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789042;
	bh=jdbQoTDrkfa8bWybNmaYULRNZXSULG7Jel2vJpeb0ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wUcLD9JMlSBX6pZhflRoOFbVL7dmm/12f0xrCLo3DKHFPFpjoy2jtdOpDr8a1pZIC
	 R0F6+mMqEt6SYm4DBOPFwzjV/dx0ZqXaSBBo2LKHmc9dzNO9SXhDbnSw6aPE+4NVDL
	 59vxp1Mk67Klquam8n0Wlmoy2d4vZwE6UmSywzTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 337/877] s390/pci/docs: Fix sriov_numvfs attribute name
Date: Wed, 30 Sep 2026 17:20:48 +0200
Message-ID: <20260930152421.944288411@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



