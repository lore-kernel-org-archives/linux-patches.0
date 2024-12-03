Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3041F76DE;
	Tue,  3 Dec 2024 15:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238661; cv=none; b=H0IJ8hbMrcDTUxe8CDiRuTrSICOUV0rVeqtDCLvElX3xw++nMRwwCwkxrNCr/ignzkIrWverBbz/KLcldGw1W+z+w9TVimQfPK/eKI2sSuNeBNx4FIAMJu9Cof5OoTKIO4pXsO/LrlSMqJbCdCB85M0DTyI8eidkyYOtY/2jmqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238661; c=relaxed/simple;
	bh=A1tpWOEgmJ1MSkCLR3O+5YhQ1nqT0RZMUoYRE+4J4t4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CsFhUHZhjJiw4HqWU6RbaRIghF7AJiGE60XJsD9jgaiweB7mmsoyqybmXqVA84i+mvCK9N+Qa9fTLI9mmUZEmA/tZ9iDkJ/jqMiDnx6jWnwaYoVCHXbZUDGKcQjVGducbZKtEwR32NMQubV7d3AG6sHHLfpKjtIfxZ901ZM8UWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BYhjxsR6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BYhjxsR6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C991AC4CECF;
	Tue,  3 Dec 2024 15:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238661;
	bh=A1tpWOEgmJ1MSkCLR3O+5YhQ1nqT0RZMUoYRE+4J4t4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BYhjxsR6KjjW8d6y4u5z07AIIGm6ne6xKaXYzECXzT69qIrGLT9KdtROOHYW8hK3k
	 4+Yy5mreL7ZupCyFo1T9m81jDwSU+utdsN3+puok16LrBdNagj1ElzgiViBcJ9OQqb
	 BPjWzjucpLCq+vvR1Ath/V0aPLGLkvUnPcVuZ10c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guan Jing <guanjing@cmss.chinamobile.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 355/817] selftests: netfilter: Fix missing return values in conntrack_dump_flush
Date: Tue,  3 Dec 2024 15:38:47 +0100
Message-ID: <20241203144009.689695081@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

From: guanjing <guanjing@cmss.chinamobile.com>

[ Upstream commit 041bd1e4f2d82859690cd8b41c35f0f9404c3770 ]

Fix the bug of some functions were missing return values.

Fixes: eff3c558bb7e ("netfilter: ctnetlink: support filtering by zone")
Signed-off-by: Guan Jing <guanjing@cmss.chinamobile.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/net/netfilter/conntrack_dump_flush.c  | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c b/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c
index dc056fec993bd..7e8ffe6b95a45 100644
--- a/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c
+++ b/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c
@@ -43,6 +43,8 @@ static int build_cta_tuple_v4(struct nlmsghdr *nlh, int type,
 	mnl_attr_nest_end(nlh, nest_proto);
 
 	mnl_attr_nest_end(nlh, nest);
+
+	return 0;
 }
 
 static int build_cta_tuple_v6(struct nlmsghdr *nlh, int type,
@@ -71,6 +73,8 @@ static int build_cta_tuple_v6(struct nlmsghdr *nlh, int type,
 	mnl_attr_nest_end(nlh, nest_proto);
 
 	mnl_attr_nest_end(nlh, nest);
+
+	return 0;
 }
 
 static int build_cta_proto(struct nlmsghdr *nlh)
@@ -90,6 +94,8 @@ static int build_cta_proto(struct nlmsghdr *nlh)
 	mnl_attr_nest_end(nlh, nest_proto);
 
 	mnl_attr_nest_end(nlh, nest);
+
+	return 0;
 }
 
 static int conntrack_data_insert(struct mnl_socket *sock, struct nlmsghdr *nlh,
-- 
2.43.0



