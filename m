Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA224342538
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301770; cv=none; b=JqUP063W0Od+rzEvIoyB408zXl44Vhm0XrGdVgzu6X1VvLe+eetQQOYNCgfYek/62sg120fkQgncLBQhbBTp8pfEDdwSSvtupYnl/Rk+C8q4sbF/Eb/tMjPmRZC44d7FL/hNq1spCbHhrM9h9IOR8Pi+gR8q69ECJd9xHN2+w38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301770; c=relaxed/simple;
	bh=84XuOJBX5ixFB5dY8gadeLiy28oWLo8dKX3MMmHeGfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DW4P3893suSjosuAcIU5csiBu7IA5za7wkLpPWwnR248S0Pgmv4yVHUgUn7SdnOfBoczdO4KwLO6ZwyOcSCpZU6iA2BNRaV3iWJ2NkKO3JmH0i1ghyd/iLeGckLf9XIMRG+Mge9CkHu/BTbNoXbky1/wuPHM1p/bd0ortwK3Ds8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q5PiVBOt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q5PiVBOt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4411CC116D0;
	Sat, 28 Feb 2026 18:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301770;
	bh=84XuOJBX5ixFB5dY8gadeLiy28oWLo8dKX3MMmHeGfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q5PiVBOtorul/AacrXCTiSF1Wft7ckQy5c4HJMIMRjGeIUxeIBnMfAHz/FaBXbTI0
	 ozLDzaJBdEUMakogGVlJqkqD7GWHGsvV0thXdLqfUUKleKFuv7SwzjOrJnXRNhNI5e
	 Zy5fZHfdsQE0zJaQh/4T6RZvpx1aPMpbN73S7/sRvCITbxNn2Um+nD6/jCYpPORZ9/
	 YNErDHbO3rHXMShCTZ6Q+cqTCRdk1XIHsHbIVlqT0AGZJzXvq5ODBWrA5oqAUgC4w6
	 TjrN5MKaTdnNAyqYpGtQ5KQWhm14tPI5z2GXtX90oWgSqFWCCwI9PTeoeER6bJ+o4Q
	 z/iegjWLS9o1g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: SurajSonawane2415 <surajsonawane0215@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 178/385] docs: fix WARNING document not included in any toctree
Date: Sat, 28 Feb 2026 12:56:40 -0500
Message-ID: <20260228180011.1568201-178-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: SurajSonawane2415 <surajsonawane0215@gmail.com>

[ Upstream commit 998bece1d22bf2cbc819cb3a492148932d4e12a8 ]

Add debugging.rst to the relevant toctree to fix warning
about missing documentation inclusion in toctree.

Signed-off-by: SurajSonawane2415 <surajsonawane0215@gmail.com>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Link: https://lore.kernel.org/r/20241002195817.22972-1-surajsonawane0215@gmail.com
Stable-dep-of: 8236fc613d44 ("Documentation: tracing: Add PCI tracepoint documentation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/trace/index.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/trace/index.rst b/Documentation/trace/index.rst
index 0b300901fd750..2c991dc96ace6 100644
--- a/Documentation/trace/index.rst
+++ b/Documentation/trace/index.rst
@@ -24,6 +24,7 @@ Linux Tracing Technologies
    histogram
    histogram-design
    boottime-trace
+   debugging
    hwlat_detector
    osnoise-tracer
    timerlat-tracer
-- 
2.51.0

