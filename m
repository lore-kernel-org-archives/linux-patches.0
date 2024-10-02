Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461931D04A0;
	Wed,  2 Oct 2024 13:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876069; cv=none; b=D4ji5R45kCIsgXBTRC16t+ZF5mHlCJRUGFQleU00n82y19KeD5/HIVxxSioE0wrIvu/anwqHl77VnKyp7EmcCEr2HiPzucSnlCWW5wgfUaIgCMPf5yYY4EMwtpn11FdvIdP+fxTwU1py27jGxbgtc0+am1ofw/MzOjHzLoEwyzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876069; c=relaxed/simple;
	bh=NIh/5i+66Duw2S50jyI3fTaqKkSbyvhUavdMaY2V7Fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XqmKNi5Oi+wjE/O0yBL0nAh2Gtp0kUDg3S/cX4jRFbRvG0iBvLjdJxlJTt30SrXDOQ+/t7mGte8H5DIjqFwsgBmDwnUXDlCZipJeQ9ZNfFLvZD02VISgPCk3/7pKlT8P2QVCSdD/TRoGgFFVIzPd0YxDBfH08MkLsg/xBxl7qo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=abIXnKsu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="abIXnKsu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83140C4CEC5;
	Wed,  2 Oct 2024 13:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876068;
	bh=NIh/5i+66Duw2S50jyI3fTaqKkSbyvhUavdMaY2V7Fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=abIXnKsudhRetzGc+mB87Gc3CY285X+RUXnvp2QZYuizb2ckfMKkqAx9ZNAQu8nju
	 QeE5QhhhbHM6O6RHqFVwCkPHSwwkAbHS1NH7c53G0x36vRB7irIE1RJo97RYVn9HxY
	 8i2srQoJlJM2qt/wVap0dRCDL+eepza6qaSCZ1kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neill Kapron <nkapron@google.com>,
	Alan Maguire <alan.maguire@oracle.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 290/695] libbpf: Fix license for btf_relocate.c
Date: Wed,  2 Oct 2024 14:54:48 +0200
Message-ID: <20241002125834.016270462@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Maguire <alan.maguire@oracle.com>

[ Upstream commit 4a4c013d3385b0db85dc361203dc42ff048b6fd6 ]

License should be

// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)

...as with other libbpf files.

Fixes: 19e00c897d50 ("libbpf: Split BTF relocation")
Reported-by: Neill Kapron <nkapron@google.com>
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/bpf/20240810093504.2111134-1-alan.maguire@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf_relocate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/btf_relocate.c b/tools/lib/bpf/btf_relocate.c
index 17f8b32f94a08..4f7399d85eab3 100644
--- a/tools/lib/bpf/btf_relocate.c
+++ b/tools/lib/bpf/btf_relocate.c
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
 /* Copyright (c) 2024, Oracle and/or its affiliates. */
 
 #ifndef _GNU_SOURCE
-- 
2.43.0



