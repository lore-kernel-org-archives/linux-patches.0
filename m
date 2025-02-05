Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CAFD186E56;
	Wed,  5 Feb 2025 14:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765932; cv=none; b=E5dcKy/WTrmBBG9y0L5NQ70MRsrLGmw4FNRyiojuClvnpWizCgKyv/zk0eUP4Cp0/0HCW03KNpzTYydxG84kDtDglkjJcmY/3mdnYyMSWYGBqVJ6EGUS5hh5IyUGFthKE5Iy5Jv6by9CNSfGe6YLIG17zOgNyePxJnQVZPS/yQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765932; c=relaxed/simple;
	bh=WGsyU/JqILatUccGPYIPIAvz5jx0hF8shSj62bt//DU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oPbTxCySgOpKtALGgj15Qwd4GF7Dibn2+1wIcr+N2V6p0RgLK80DY1cHDW3iHw9bqqujJXEknsiS/rpSyG8ssG2BW5hx6AgXjVfx5mBHGqND2oNgt50WGtYuvvZ9qRaKigz024kvOwwIuFzS6/LBtsdXsc/jHxRG3t83aU3sYSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jgU3GLnd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jgU3GLnd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCBD7C4CED1;
	Wed,  5 Feb 2025 14:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765932;
	bh=WGsyU/JqILatUccGPYIPIAvz5jx0hF8shSj62bt//DU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jgU3GLnd/dOpFPmYYOlvIInAoeuXVuntRyvgvvGQJtYa8Lhzm7iK3SjdsVMba+4rf
	 a8mmxseoVz2hnwxCRRMjPmLoVV1ZcwSNRFTzKS1kkf7VeXwux5apn71gRFJZaYkByT
	 o244Mhrw8A184vk8S7W5OyIvGKW8CoYbet7zMPgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 313/393] NFSv4.2: mark OFFLOAD_CANCEL MOVEABLE
Date: Wed,  5 Feb 2025 14:43:52 +0100
Message-ID: <20250205134432.287706874@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <okorniev@redhat.com>

[ Upstream commit 668135b9348c53fd205f5e07d11e82b10f31b55b ]

OFFLOAD_CANCEL should be marked MOVEABLE for when we need to move
tasks off a non-functional transport.

Fixes: c975c2092657 ("NFS send OFFLOAD_CANCEL when COPY killed")
Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs42proc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/nfs42proc.c b/fs/nfs/nfs42proc.c
index 531c9c20ef1d1..9f0d69e652644 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -552,7 +552,7 @@ static int nfs42_do_offload_cancel_async(struct file *dst,
 		.rpc_message = &msg,
 		.callback_ops = &nfs42_offload_cancel_ops,
 		.workqueue = nfsiod_workqueue,
-		.flags = RPC_TASK_ASYNC,
+		.flags = RPC_TASK_ASYNC | RPC_TASK_MOVEABLE,
 	};
 	int status;
 
-- 
2.39.5



