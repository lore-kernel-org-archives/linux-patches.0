Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626336;
	b=N1Dt0VLtkdS0TMDzBjo3K6L0Se9n0Eox/r5miFkjR9090xK4qA4Mmso/z++SlW7i0viY
	 +zBLsPJJpK9NP3y6QtU9HPVxCWUP7fVBIXE0Tg+nAhyxg+CibVv1c4eAhFCsFqUd9TGGC
	 6UfnKhGbmEfpLp8QTNp/Tr9QgDixl7HXFRsZd+prv+0K78f8NC75lNPWo7K+dvVbnDHds
	 BRNM/BDl7mDK2Xgcski+ZIf6Mg5T3kksNYyoM4eHP0pAjqY1A+IguA1HRmfScQ81eZcPH
	 MrBTLh4RPVm9lC/fqpT/psPAHbquYdJuZz9AX66vbGPkNRqb7PwUEKVFJkgPql+YDFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626336;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dObEgtals4q0GNfepMUtpnLlxEgGS0+kzlnBwU9q7uU=;
	b=QekID4+oytVyeJD+zd70f2p6UCTEkGSfUJWA3bcoohDxx+973lBKmhIJ8ICAieb1Zm3h
	 I/oP+uGC2wfb/+ZOfRbKUVVMw7fRmyexm38BH83SsEyc3kbexJpSX8Vy+05hvNnuJZLr0
	 GEKPTMhpsSFR03YjhcdDcYFuHTyXHL+SAYczUDZ3u8pouaxm2OjSf+bHSpucz6BsWH9RA
	 +MyB1OFZ5vzwzZ25iKtKguJ1x5+Dkm5kMXPiHOOynf2WpL641TVupA4x4eV+cRR3lv5VU
	 D5LCWNNy2uy/+BRIKEdUa3yASeMsanzvPl+cdnooaZtpHjf1CJkiHjGdBmHN3GePaMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ezqo3dXr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDC7606A32C;
	Wed, 25 Nov 2026 17:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ezqo3dXr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A18B1F000C6;
	Wed, 25 Nov 2026 17:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626336;
	bh=dObEgtals4q0GNfepMUtpnLlxEgGS0+kzlnBwU9q7uU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ezqo3dXrebItHqWb9YmnIuNKfOvNNqKeNxLB51QLgjsyt2fklqwNVTMKYhiBHHTM7
	 6Ax2slOvgUVRNm5TpDRSPsELp1HTtdN3+FwwLHzd8vnTN9rEO2aLsqwTuLNBb5Rv/G
	 vTBwT3p77Bvbv0YnRzbBjSnnRuki4St/WyxGdArc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Gomez <da.gomez@samsung.com>,
	Ingo Molnar <mingo@kernel.org>,
	Liam Howlett <liam.howlett@oracle.com>,
	Luis Chamberalin <mcgrof@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 811/816] radix-tree: add missing cleanup.h
Date: Wed, 25 Nov 2026 15:39:19 +0100
Message-ID: <20261125143907.942435090@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Gomez <da.gomez@samsung.com>

commit be8254f694469e60252e35c467ac9a878d7797bf upstream.

Add shared cleanup.h header for radix-tree testing tools.

Fixes build error found with kdevops [1]:

cc -I../shared -I. -I../../include -I../../../lib -g -Og -Wall
-D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined   -c -o
radix-tree.o radix-tree.c
In file included from ../shared/linux/idr.h:1,
                 from radix-tree.c:18:
../shared/linux/../../../../include/linux/idr.h:18:10: fatal error:
linux/cleanup.h: No such file or directory
   18 | #include <linux/cleanup.h>
      |          ^~~~~~~~~~~~~~~~~
compilation terminated.
make: *** [<builtin>: radix-tree.o] Error 1

[1] https://github.com/linux-kdevops/kdevops
https://github.com/linux-kdevops/linux-mm-kpd/
actions/runs/13971648496/job/39114756401

[akpm@linux-foundation.org: remove unneeded header guards, per Sidhartha]
Link: https://lkml.kernel.org/r/20250321-fix-radix-tree-build-v1-1-838a1e6540e2@samsung.com
Fixes: 6c8b0b835f00 ("perf/core: Simplify perf_pmu_register()")
Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/shared/linux/cleanup.h |    2 ++
 1 file changed, 2 insertions(+)
 create mode 100644 tools/testing/shared/linux/cleanup.h

--- /dev/null
+++ b/tools/testing/shared/linux/cleanup.h
@@ -0,0 +1,2 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include "../../../../include/linux/cleanup.h"


