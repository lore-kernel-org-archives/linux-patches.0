Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D27A339B0
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bBhmvV4Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF091C433C8;
	Mon,  9 Oct 2023 13:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859042;
	bh=/xq3RiYsriZPf5HSigLpB3QGTPR2YKQ4xk8YxV1/a+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bBhmvV4Y+fKkcSviPJDQfanIqhYx8al3CY+JxuS3dwhNHQzeFNAb43zbG1qGo5psV
	 E4z+cI/aX/ZqrJoXQBOR3192T07xKAhiZR56ro7IFOoNJnI7JF9U/3gr4ydJdj6RzG
	 w15gipj1OWVPf+Litk1runsB1EexUcCOxbdiEEIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.10 152/226] Revert "SUNRPC dont update timeout value on connection reset"
Date: Mon,  9 Oct 2023 15:01:53 +0200
Message-ID: <20231009130130.677528089@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit a275ab62606bcd894ddff09460f7d253828313dc upstream.

This reverts commit 88428cc4ae7abcc879295fbb19373dd76aad2bdd.

The problem this commit is intended to fix was comprehensively fixed
in commit 7de62bc09fe6 ("SUNRPC dont update timeout value on connection
reset").
Since then, this commit has been preventing the correct timeout of soft
mounted requests.

Cc: stable@vger.kernel.org # 5.9.x: 09252177d5f9: SUNRPC: Handle major timeout in xprt_adjust_timeout()
Cc: stable@vger.kernel.org # 5.9.x: 7de62bc09fe6: SUNRPC dont update timeout value on connection reset
Cc: stable@vger.kernel.org # 5.9.x
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/clnt.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2354,8 +2354,7 @@ call_status(struct rpc_task *task)
 		goto out_exit;
 	}
 	task->tk_action = call_encode;
-	if (status != -ECONNRESET && status != -ECONNABORTED)
-		rpc_check_timeout(task);
+	rpc_check_timeout(task);
 	return;
 out_exit:
 	rpc_call_rpcerror(task, status);


