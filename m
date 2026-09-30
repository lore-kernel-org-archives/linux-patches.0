Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98060502D5A;
	Wed, 30 Sep 2026 18:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792379; cv=none; b=Kpb4vTqXBZvQOZh0gxD2RTKR8vIXn3En4H+/0BmB3dN61FU6irfn8IoPOoyGOs9T/Obm//ZQqPNjxmxcYWo35W6mV/fQgovtyS/nTONlp4p+H4uGW7MM0DlauSqheA6c2xLRGlnnrfWgvwtpEXnjdXofA8QRKohoXc7tl0xo4rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792379; c=relaxed/simple;
	bh=/b/m09aMAeiNNZymDZmS/HRaTMa0yVGs9PICjBIIWlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLOZtpGEiOzTCexdZinlzeWv3//9PZ03VRhma0OQkie1qA8P3CpmzNN7gqk1E80bAGT2etwBHmFBQo0DpnDdm02+94P6pCsVUSCP/bQJwB2lbJInISghFAVlQtmplgcNKfxpGGcs1MDLSsGBVchKoKSE9pZQlT3VBxx0Ln3Zozo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mTOdzb5B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mTOdzb5B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029001F000FF;
	Wed, 30 Sep 2026 18:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792378;
	bh=KKujh+Vy6nHy2HbrCUmbwpwcxS9LSzh1b2a/8iHdt7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mTOdzb5BTeuXYuJr+vNjjgQS16qZ8GcbVjCzSD+UTJ2SOBV31WX8xpW6agVu7imqN
	 4ve137Ll6cCRUY61eFXzIk8duRlw2XEDdHgyOVb2TsKfeQtYjv3idaXWLjpDWZvhdm
	 UcMF52CpKMcfsJdcJSZGOQ5rTItx8jaoIPlxr92E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 607/752] s390/pci/docs: Fix sriov_numvfs attribute name
Date: Wed, 30 Sep 2026 17:27:57 +0200
Message-ID: <20260930152411.418085861@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



