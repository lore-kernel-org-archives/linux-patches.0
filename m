Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060649;
	b=fglE9CW/MGzFE6YbQvdXA15FFhVkDLuUgV6Znd+nETntASibAG6P7WMRvr8SEQrg1Imk
	 EmbPcghbCKEuKIsj1ifKrX1i/zqHRakmmIXbnfJUBrfGY1JObOWMKPWZ5Hx7HsDONV2Xk
	 Niw/yDWIjh2vkTUxQnR+1IF52VK3GYsIcsjIHxIN3j0PJOiHe4985KjGnfs9p6c19WHaX
	 DsjBxjaeiDadV5JjpEugjCAJT3bVOR9v5sMr6AOc0I5opJgFogr9iYOeTIwQERdDQyagE
	 QVmiiD95u6qumm2DhJiqrH0mq7quuGTstMoWpQxGeXOC8QFNzwWBKrWnx+DaUow2VNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QT7rPtA85fVji9qax5HHWWfxKwl7xISPOXhaz1+W7Bg=;
	b=grEkpTBvCtGzCc2NhzXzrYoCmqBjdcNhx/iSXeWopVxVUB2tItyiaxt+UEbNcL6T/Ts+
	 PlBUFyhe9gKbYVUUzJjXyzl4JbyaxYvf7SV1nxCiIbVE4CTG1hVIgWSQXjf+JsJzMChgL
	 WUd3VIFGEEV5FphWhwnBXcmhwBPj0yBS9eMlCO/pwxa+i8ICxe0z1maqKnpkIqmw6pKxy
	 QyvdraljtfZhs/Wi6IY12hOZIj3evLUaoVK50zHkT/3wjLjg7v+qG1jKYefFKOX5VITQ5
	 aasPfegKgewsVygQ7pIdz4uRRnSXFCAb3XgLjdNRu1puCu60vYJeo/A+gXDGVKTwTUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sYJmN+bM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65CB606A326;
	Sat,  7 Nov 2026 14:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sYJmN+bM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D14D1F008A1;
	Sat,  7 Nov 2026 14:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060648;
	bh=QT7rPtA85fVji9qax5HHWWfxKwl7xISPOXhaz1+W7Bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sYJmN+bM5JzXNbuLficehkBQiXyap/BSRe2jngeHk2cnp7bBu6sgn7hKlddFHVqfX
	 JnrSJRH788AazMGRAVJbL/vzYwlcMyw/2eI4Fqf8CXeSqhARqWohWOcv9EphUMuaVR
	 FTcg0l2Nftd8G7f95fCKxcnGoqmSctxGiQR904aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tanmay Shah <tanmay.shah@amd.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0090/1536] remoteproc: core: Full attach detach during recovery
Date: Sat,  7 Nov 2026 08:35:06 -0500
Message-ID: <20261107135000.195049823@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 0c11a0b529086..392a11b474935 100644
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



