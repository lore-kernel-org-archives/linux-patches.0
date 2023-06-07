Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D8023D6A
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 21:02:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA6EC433EF;
	Wed,  7 Jun 2023 21:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171752;
	bh=xCCuFXSIC+xLhr8NQolfn7YyfiSOsvn4r9z2mEIBz68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mYbc+mxYlCGvfq14IlF1rCy3T143nWtfcyHZwdIZmKhkgStHsE5e11+tvcxoJI3ch
	 SkCgv9+MfCa3COXS0FOPQmGgZkoYam2z+91MoeJ1uGvaeYjXSP2AlKNe4CM2dJzXFG
	 9eYbHSGYKwMW0NN11/X06Wfr09uW0v+2lNMzHRXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH 5.15 135/159] selftests: mptcp: sockopt: skip if MPTCP is not supported
Date: Wed,  7 Jun 2023 22:17:18 +0200
Message-ID: <20230607200908.089777481@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200903.652580797@linuxfoundation.org>
References: <20230607200903.652580797@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matthieu Baerts <matthieu.baerts@tessares.net>

commit cf6f0fda7af7e8e016070bfee6b189e671a0c776 upstream.

Selftests are supposed to run on any kernels, including the old ones not
supporting MPTCP.

A new check is then added to make sure MPTCP is supported. If not, the
test stops and is marked as "skipped".

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Fixes: dc65fe82fb07 ("selftests: mptcp: add packet mark test case")
Cc: stable@vger.kernel.org
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_sockopt.sh |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
@@ -1,6 +1,8 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
+. "$(dirname "${0}")/mptcp_lib.sh"
+
 ret=0
 sin=""
 sout=""
@@ -80,6 +82,8 @@ cleanup()
 	rm -f "$sin" "$sout"
 }
 
+mptcp_lib_check_mptcp
+
 ip -Version > /dev/null 2>&1
 if [ $? -ne 0 ];then
 	echo "SKIP: Could not run test without ip tool"


