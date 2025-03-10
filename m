Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2741122D7A6;
	Mon, 10 Mar 2025 17:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629035; cv=none; b=fOV3AQO60qiUu1BxFFkeCBMepltmOfYpaBrb1RdfULR719S+mFAdvmmfeDGrTK3DqXRK0HvEXjnHTvrEY15ovV9iuuXpwujScHwMfCDmv1CK/MMjhUygEGOdvIrhf1JzBVwXOCnB6rzr1UNKtAcEuIXDUxQpjmslPHDTjG7Gp7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629035; c=relaxed/simple;
	bh=KlqEYSQv4KsPC0sQ24LdRInAAaSTTfacjoBdf03dB6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGHPAaSZN1cg2PWVRPFHvIkqkSidYNGMtJXruaLAcaWR5MXmQvn2Njo4XPbuN9ot3kl31wZHjT5MQA55aG62NJUYUnPKbOrZ3yfz7/HHFgq6OlN70lJu79XqasIoYyDQa3Kzsk5tpbbnJ3EjD3wQmV+s1HqHDRQAqo00xuyWIFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yAJLYR4G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yAJLYR4G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67D0C4CEE5;
	Mon, 10 Mar 2025 17:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629035;
	bh=KlqEYSQv4KsPC0sQ24LdRInAAaSTTfacjoBdf03dB6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yAJLYR4GJ9Udk2Je8IINlJRNyewmHLOKVXTvEcbH808cVD3tumLh9EOntF6BpFU/W
	 ungJNHpCdwdy6GNrJVCGky+h/4QoMxRPR/iFv3LVOdVhYPQd720Nt+zI4pHBnpSg3a
	 wGpA8hmXI0t6JRmrUb1PztcknfoPgGTnuuwHdAoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 155/620] NFSv4.2: mark OFFLOAD_CANCEL MOVEABLE
Date: Mon, 10 Mar 2025 18:00:01 +0100
Message-ID: <20250310170551.722595239@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index eb347742e611b..b57e3a631b975 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -541,7 +541,7 @@ static int nfs42_do_offload_cancel_async(struct file *dst,
 		.rpc_message = &msg,
 		.callback_ops = &nfs42_offload_cancel_ops,
 		.workqueue = nfsiod_workqueue,
-		.flags = RPC_TASK_ASYNC,
+		.flags = RPC_TASK_ASYNC | RPC_TASK_MOVEABLE,
 	};
 	int status;
 
-- 
2.39.5



