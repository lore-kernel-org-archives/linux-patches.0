Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A03E6FCA
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 23:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=IPxttaF0efk5Fm54pzICCIxRrnPQujbmO8MrMUftOtM=; b=YuJsW9/zRa8hZXyM21I5mH50Ub
	xBMeiQI3pzkHEWi287B62QvE7AXSbwDWbniplfymgC1LTJ3HBQ690LkxbBfuSltwc6lWJp+aSksaR
	Jlq6G9vM/D+4vMc2wJvoeaxWb/7Tsxp4sEhMDVzjZBCbCZBIhqjv2QRxTLQrzVhM+MzdVloQngRUZ
	zTJwshebpto3XfbUAI4jvncngl/OgVlypXKFlT7pupGjpSIf/OYIFR8+VwpQwx2KoAeQL4J3Q7RZi
	IxZRuEfFFm6rC4hF/YleaQXypNIDLBQYXuymWqmva7r/qsjM58Du6uFdWBFU1ZfGHoV2MQOLFGe5f
	CSzOk6ag==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pb8oT-001UJq-51; Sat, 11 Mar 2023 23:39:45 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: chuck.lever@oracle.com,
	jlayton@kernel.org,
	trond.myklebust@hammerspace.com,
	anna@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	kuba@kernel.org,
	linux-nfs@vger.kernel.org
Cc: ebiederm@xmission.com,
	keescook@chromium.org,
	yzaikin@google.com,
	j.granados@samsung.com,
	patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v3 5/5] sunrpc: simplify one-level sysctl registration for debug_table
Date: Sat, 11 Mar 2023 15:39:44 -0800
Message-Id: <20230311233944.354858-6-mcgrof@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230311233944.354858-1-mcgrof@kernel.org>
References: <20230311233944.354858-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

There is no need to declare an extra tables to just create directory,
this can be easily be done with a prefix path with register_sysctl().

Simplify this registration.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 net/sunrpc/sysctl.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/net/sunrpc/sysctl.c b/net/sunrpc/sysctl.c
index afdfcc5403af..93941ab12549 100644
--- a/net/sunrpc/sysctl.c
+++ b/net/sunrpc/sysctl.c
@@ -163,20 +163,11 @@ static struct ctl_table debug_table[] = {
 	{ }
 };
 
-static struct ctl_table sunrpc_table[] = {
-	{
-		.procname	= "sunrpc",
-		.mode		= 0555,
-		.child		= debug_table
-	},
-	{ }
-};
-
 void
 rpc_register_sysctl(void)
 {
 	if (!sunrpc_table_header)
-		sunrpc_table_header = register_sysctl_table(sunrpc_table);
+		sunrpc_table_header = register_sysctl("sunrpc", debug_table);
 }
 
 void
-- 
2.39.1

