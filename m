Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829494;
	b=oujo5G582pYVPl5snRbzLigDTJWLvDrX0wuayY7k6My/Is9YGroBFAuLdP2GqGXaKNZJ
	 +pgh0X60ETvOEQeae6NN2sA1+Kq5TnluDgSLB57yjDjhnrItO9naLaOPLmZ1wo2zqk3ax
	 BDa9JcszOtfOQv1tD4qRxB6PvhzcEZfCNLRG9PFIg+suPKoujev6odkDF7e+dxgCm4k4o
	 ws4nyLeWEBtqCFU6MGum8y9OBNlnV1pBVnGmw96r2tuCZLO1DwCpPL3QDbETXuIInjjNg
	 2gt7kUOijMlG008AoKVD895XUukCiLEo9KW3CR8HANubBNF3A1Wdcyfd8v04c363r0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829494;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Kbdihp0dpe+owL7gLaay7TiQnifi4PVYbRXCq9um3k0=;
	b=2IWvjVT8g9p4FatwQ9NYOLqGYLqLourYR3/gfNZbnxJ0E1pCYb4LasD0XPLbdwPuTvfC
	 6Tm+HxihF9fHcE/tv4iJeMgWrReuZH+j4Mf5lUNPM00hbixuakUd5H0cFmI6knnK7O4W6
	 JHVcNbfNl6E2crryju9y73FjcN+wa3XFWgVRcWu+WK3QgUC9ACvwnVr41lIvexmnx53N1
	 1OY0r7BGTYE8LgpVno5uSobDUR5f2DJQ29wbkoguJ4xBtM8XCLQ+iULSSXemzQ+pR0ALh
	 y8RUEpAyAwBVCa4oDB4wt006sKFMwEpbyb3j7qExxPvisoAj2rxPvIa7LyHM6ZnjKnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WzAUDBWK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16189606A878;
	Wed,  4 Nov 2026 21:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WzAUDBWK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A70D01F000C1;
	Wed,  4 Nov 2026 21:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829493;
	bh=Kbdihp0dpe+owL7gLaay7TiQnifi4PVYbRXCq9um3k0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WzAUDBWKCNiFcJNwNt9bj+90bAvajKw7K8v1RrmRdAUSMJrQmAZH46V5FlHYf/e1Q
	 wbL4GAvX0qDkucJyyN/hNXQJtPK1qvLi8bb2X+lYtJdaQ/tjFTYoGxNMqAtzAmBUw1
	 4gBOWqXELOSWj7oKQMzZUYYR6OcV7uCn0TIb5u1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0160/1005] remoteproc: core: cancel crash_handler work in rproc_add() error path
Date: Wed,  4 Nov 2026 15:58:13 -0500
Message-ID: <20261104211048.241080155@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jingyi Wang <jingyi.wang@oss.qualcomm.com>

[ Upstream commit 0ec167625b4fea30b26da33c188e853ff25d5583 ]

Ensure crash_handler work is cancelled before tearing down rproc resources
to avoid accessing freed memory.

Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260623-rproc-attach-issue-v3-3-8e24310707ce@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 068a3ef467f78..70c990c3a5d76 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -2358,6 +2358,7 @@ int rproc_add(struct rproc *rproc)
 	return 0;
 
 rproc_remove_dev:
+	cancel_work_sync(&rproc->crash_handler);
 	rproc_delete_debug_dir(rproc);
 	device_del(dev);
 rproc_remove_cdev:
-- 
2.53.0



