Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829403;
	b=mw1iycLBmk379IYrkTNBz/MXnLH8+HVKVKV0RLNMqBCtUkFNoevf0GzqR8ldMMuGJNjc
	 /V1ycOjLbQxSUbOFcRjNzRpPvWFoVMOugiLofi01TJljKwfnoUR5OsZBxj9QB1F283tIw
	 l5NtRjTOgMo4+7O9544qffPZkU+HbEucOkXHR9bfdF+eHycO64NurW/lOxw2tg8OVT0V6
	 61EO9BfHaSRUUXV/L6BnMoFwJuykbSmm6SpZbJkR6dOWXVQ/CqEGzMmlAGlERoQd2bKOW
	 jleUC/p4VKyKsmU+42okhn+O+MJe0oUX+6fKKSLmje+lE9bwdZceD8VHH+mPEB/Ey8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829403;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jrhdYsPNJy1RAr5bAz8ZiOz6rL6wnWMeUUl4mjzvOGI=;
	b=HyK7vvxULCjHbGsxTLSxuge2webB7XkhWB51lZDyUWazszPDjMerKzKi/keJNgpupw48
	 G/GuX//2QFrKT16VOWVxUZDxd5saE67MVy8hhYuIL8DSlcRhEddPl8/OmGDoKW4WHCWbP
	 eloagC3+vvzmSFA/y2WI2Vaa7ki2nojOtstydBm4rHDgt3O7x2IrfMetNpqCK6jOSquKB
	 +eLJBTkYCWd9ibGPiNVAHtRy1Uln405LL/yR1fGJugUFuRYuQHKUqg3nNLhhuk5ibGoNe
	 WSzjozX+Ilt0adguw5tsrTSzZXYbNpawaoJB1IKjztVmOBsKgiscBH7dyZkgtXNlRpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p3FEdyZf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4496086E79;
	Wed,  4 Nov 2026 21:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p3FEdyZf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 608631F000C1;
	Wed,  4 Nov 2026 21:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829402;
	bh=jrhdYsPNJy1RAr5bAz8ZiOz6rL6wnWMeUUl4mjzvOGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p3FEdyZfvoFd9b8xVDcqbfniuhBfq1Q08OASObzjrZpmkpHQK6dUloOVhTGW1bvWv
	 5AtL4QwPZoA3Yx6mbyNWwpl/fe5ZvKuiPrBndpymgiHF4FcQJsITJk4Z4CLekXBld3
	 E9/4uXaRuaMCCseY/49SpGcyMnOBIRADt6l3iOFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tanmay Shah <tanmay.shah@amd.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0105/1005] remoteproc: core: Full attach detach during recovery
Date: Wed,  4 Nov 2026 15:57:18 -0500
Message-ID: <20261104211046.593114726@linuxfoundation.org>
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

From: Tanmay Shah <tanmay.shah@amd.com>

[ Upstream commit d93ffd549fb4df18c934ca7a47d4128a18c718cb ]

Current attach on recovery mechanism loads the clean resource table
during recovery, but doesn't re-allocate the resources. RPMsg
communication will fail after recovery due to this. Fix this
incorrect behavior by doing the full detach and attach of remote
processor during the recovery. This will load the clean resource table
and re-allocate all the resources, which will set up correct vring
information in the resource table.

Signed-off-by: Tanmay Shah <tanmay.shah@amd.com>
Link: https://lore.kernel.org/r/20260630004806.3835488-2-tanmay.shah@amd.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_core.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index bbc781e41a1b8..2336c55eb021d 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1784,7 +1784,20 @@ static int rproc_attach_recovery(struct rproc *rproc)
 	if (ret)
 		return ret;
 
-	return __rproc_attach(rproc);
+	/* clean up all acquired resources */
+	rproc_resource_cleanup(rproc);
+
+	/* release HW resources if needed */
+	rproc_unprepare_device(rproc);
+
+	rproc_disable_iommu(rproc);
+
+	/* Free the copy of the resource table */
+	kfree(rproc->cached_table);
+	rproc->cached_table = NULL;
+	rproc->table_ptr = NULL;
+
+	return rproc_attach(rproc);
 }
 
 static int rproc_boot_recovery(struct rproc *rproc)
-- 
2.53.0



