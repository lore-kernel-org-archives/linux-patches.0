Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9D43570DE;
	Wed, 21 Jan 2026 18:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020484; cv=none; b=XRHJtZ49xXjc9VkH+VRmCTC92Stz46xfHsD8TVzIlgt+Mk6V9lyXC/P6ND3i6R5NFmOqZd72KGKRB2fC/ARDhyXeGLsUFWhEJRN3ja7qwf9Iyawg25SRhX/lWrj0xpVNSJFSaeslPuSiAEj2iRSsfESd8+sjj8rclmFTQrvzi68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020484; c=relaxed/simple;
	bh=BXMwwrphfpowGpPIvikrv2dDLd8+8UIxVihVqp7BV2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bizE36b3QM5vK/o97/sK3RQydKt/hgOlY7QCZPEkKEbH51xoT5AICisu35w0PkkQqawdpdCHA0Kq+myh+AOcYl8TiZ+aqep4NdhGvG/w0iFcVA6wNroqoX/cv26tviIRQdy/ka4GM8VuiY0VUPhlM0iLOUWkaqs8TbyvWLsAumE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A/3x6RzW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A/3x6RzW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F06FBC4CEF1;
	Wed, 21 Jan 2026 18:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020484;
	bh=BXMwwrphfpowGpPIvikrv2dDLd8+8UIxVihVqp7BV2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A/3x6RzWiQjh6LPSZljRflCR2cTqiCmyUmTi/NtFi8upkTBzG3ne80c1Rt6EMVse0
	 MDgyN9G5p+OE1ZTc6Kb0ONByJiTlCLmi+CeJ6IAFtgQPumtjOPIw9oxvap9yKNaB0Y
	 mj0OYX5+LjoAYSeSGKtPSfwuBjzUa4SH4IcL7JTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 139/198] mm: numa,memblock: include <asm/numa.h> for numa_nodes_parsed
Date: Wed, 21 Jan 2026 19:16:07 +0100
Message-ID: <20260121181423.547596373@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Ben Dooks <ben.dooks@codethink.co.uk>

commit f46c26f1bcd9164d7f3377f15ca75488a3e44362 upstream.

The 'numa_nodes_parsed' is defined in <asm/numa.h> but this file
is not included in mm/numa_memblks.c (build x86_64) so add this
to the incldues to fix the following sparse warning:

mm/numa_memblks.c:13:12: warning: symbol 'numa_nodes_parsed' was not declared. Should it be static?

Link: https://lkml.kernel.org/r/20260108101539.229192-1-ben.dooks@codethink.co.uk
Fixes: 87482708210f ("mm: introduce numa_memblks")
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/numa_memblks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/numa_memblks.c
+++ b/mm/numa_memblks.c
@@ -7,6 +7,8 @@
 #include <linux/numa.h>
 #include <linux/numa_memblks.h>
 
+#include <asm/numa.h>
+
 int numa_distance_cnt;
 static u8 *numa_distance;
 


