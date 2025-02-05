Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BC5DF71;
	Wed,  5 Feb 2025 14:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767415; cv=none; b=bdD0Jxiv7GCDnuucXUNu49W5azRqGkukppx/sehkTkmVba6dBwwD/Wh4Y0Bek/RTFXy/L87Xy79pHuek1ZI4qJskLRjFowx/yGNvWSx0TZ8IBzwXYv6Ee7EXv+P6ddqVSyYFudRg4DIjtNfI2bhNKmPUQ9Q2OHZNrxPlDTkhmEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767415; c=relaxed/simple;
	bh=wnZFYk4sE5gyy7ZK8QugRowv8kfs/6PEyMAGJfjebmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTPocdqst7cFLjCk0Y/FZSIc+wcKUocq28lf6z5kA5bGakunbKaDeZ7bFxBvA0AMaOdHJHN5FFrnaxIpqc/+iRFenx0ldiTSMKKaa0MaWddPw5n5ujfRv7Rei0NIi2EPzIEYmnlTuwdhjAo1LmZ+BKO9LJfXPhGb/JGGQy4tP7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FLsB8dfG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FLsB8dfG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A45CC4CED1;
	Wed,  5 Feb 2025 14:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767415;
	bh=wnZFYk4sE5gyy7ZK8QugRowv8kfs/6PEyMAGJfjebmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FLsB8dfGQ67Mj5/JZ60Ov8eHXCCUidePlp+nDvDH3gevsK1Ym5EOUMzxWW5juHlPK
	 p07U9NOGN9bMCPqGgSXd5rvIwu0WwEwOBuqXIty4Sy5Rf7lI/yoztOTEh8doAn+Ms3
	 ODaUt7e1cR90PQgJmhaogMaeACSPA7fMa7DLKR/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 454/590] NFSv4.2: mark OFFLOAD_CANCEL MOVEABLE
Date: Wed,  5 Feb 2025 14:43:29 +0100
Message-ID: <20250205134512.634182375@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



