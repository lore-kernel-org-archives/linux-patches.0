Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364544C33D1;
	Wed, 30 Sep 2026 16:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786337; cv=none; b=mnA6x5zfVTfIh4rJTNJOACtps7pYQ9N3hbmyhtSSuLFVwRb3Bvc5M8hVFfP6raYYokJS6NQexV55b318jfTLz+iBGfpgw8xSaQ7TBy6hkWi47kj/Nm4dQBnHADK3b98/tQv3+nqu5wgZ9jzKqX3kL4bfl9pgR90sGQ+ATIOxI4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786337; c=relaxed/simple;
	bh=Y6uobPcq/lPe3NuQu1Enqrf7q5Rl9pbeEp+p6HeCtUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZ/o33HBxHv4ihV0T7FxV1gREuJ5yYj8PD92qkllpM8kbx2shy8i0+aCw6QR/5a8oaMYeJqvi5jjKUB1/sAkGFQAaWrYzDRVotQ1WR8+ABf4b2euCizNMGEQx4o7KonliDfO3ys1a+le9o4hpBHEWF2VKH/I3MZ0KnQ45NP5H80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tIZI4Ubu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tIZI4Ubu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9203C1F000FF;
	Wed, 30 Sep 2026 16:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786336;
	bh=4CD1/D53U6UzXuU3j8OJOweyjl4p7K1DUGBZ+0F5Hmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tIZI4UbuGOaOQlID1SJbWwxVvFFYBdbI5ZNlHKj9ptgVdcFVEBrQ73zaE4V6+voKT
	 QUn2XAaUnbAjNLlc/PnDnhsBhWeYcDTA+V7npdMlVtmwL6NKUlD+2K2p3YIufCV+AI
	 OgXnQc+jYnA5olm3awifFenNBIYWZ4D2T+nD8sP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 824/982] s390/pci/docs: Fix sriov_numvfs attribute name
Date: Wed, 30 Sep 2026 17:26:00 +0200
Message-ID: <20260930152434.457652236@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



