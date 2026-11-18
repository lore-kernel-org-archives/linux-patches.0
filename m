Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015828;
	b=ypk0KfpOgB8DYRlXwqI6e1q1/9wietSyGl0Z+6sObAx42lL4NJ56Hons5Nig0SljI04M
	 X44JhSUORUfAGimEAeEwPUwSzkKGJeaj/utnpL/EP9/fnrwzD2yt1knJAlKINw3JrRFV6
	 xC6X5UElUNvqjnof1n0ivdVYwnJ9BFmH1PAT1Xl5qlwJ0h1mmZtdmeXPRrHOnk8F4mBQC
	 tKsO6zptf6sdcNsYgJi8YBQ96Bw0jFmP7Bhmjjq157+ziBhWMZ7eauStT1uA1somqWzhd
	 qfmjdxdGbwCD6qylWyBLJ8WV9yjQW95y599o//bAHI4xTAA1VzsGNLykKNNimbGO3zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015828;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E8gu3gENb2jcU1u4WYiF2OKwlMVP7apasG2Ph5IQWQM=;
	b=Mv4AyfctfnJqFzbouzo9EfsW9GgLcqp4Aso9duFM1AQS6N6keRTk/dcHzFAOjQZtJdOG
	 n4zk3HV1dCrm1Inu41fJV8gvC4BPfMJqXRA/+omqUxOfmZbt7QmqTXKG/YP2u6qnynWr2
	 9s1Udf2xZv2F80aDbJYJyq0D2bD42/I8QXFtoMGRuqGWbBLMeR5oMqw0ItriabY/3fm/w
	 f+vDaFm3V00Cj1jogXHGn3jaRvVL8QrxasERpCGUIA8dXg6GwOP7yeSoCBAhLej3GVALX
	 HCOS3en25WtdP0B+0QUxWqBdB724oGU+8wuurrWWeYPKbVSwblPGyk+ZlfLjrFifqFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zfhdDUDn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3EC60A2602;
	Wed, 18 Nov 2026 15:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zfhdDUDn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 002311F000C4;
	Wed, 18 Nov 2026 15:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015828;
	bh=E8gu3gENb2jcU1u4WYiF2OKwlMVP7apasG2Ph5IQWQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zfhdDUDnbg3EwCFLKwL+TcdS/G/D+c3sddE0V7J0QeeXv5ko1A08Lq3SHpVZM4mst
	 X3RGFMWIo2PXUvWCUUXWIUf7MaddF0KAN6NY13yBSHzM9CNkhj4hxZlb0a5o1SBvyg
	 nRZ56XWS/dkjHSEwfkt8ZosYjNPGJO0q8kZ25ESI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qinyun Tan <qinyuntan@linux.alibaba.com>,
	Yi Lai <yi1.lai@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0312/2651] iommufd/selftest: Return dmabuf fd from IOMMU_TEST_OP_DMABUF_GET again
Date: Wed, 18 Nov 2026 15:25:52 +0100
Message-ID: <20261118150259.123309033@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qinyun Tan <qinyuntan@linux.alibaba.com>

[ Upstream commit 1d56f4d6db3d2b2c93017a80c4f9c4cfffa9d193 ]

The selftest helper reads the new dmabuf fd from the ioctl return
value:

	*out_fd = ioctl(fd, IOMMU_TEST_CMD, &cmd);

Commit dba4254e216d ("iommufd/selftest: Fix dmabuf leak in
iommufd_test_dmabuf_get()") fixed the dmabuf leak on dma_buf_fd()
failure, but the applied version also changed the success path to
return 0, so userspace no longer receives the fd.  Note the patch as
posted on the list returned rc here; the change to return 0 appeared
when it was applied:

  https://lore.kernel.org/all/20260707030635.221577-1-seven.yi.lee@gmail.com/

Every test using test_cmd_get_dmabuf() then operates on fd 0 instead
of the dmabuf, and the dmabuf_simple and dmabuf_revoke selftests fail
across all fixtures:

  # iommufd.c:1595:dmabuf_simple:Expected -1 (-1) ==
    _test_ioctl_ioas_map_file(...) (0)

Keep the dma_buf_put() on failure but return the fd on success.

Fixes: dba4254e216d ("iommufd/selftest: Fix dmabuf leak in iommufd_test_dmabuf_get()")
Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
Link: https://patch.msgid.link/20260902085414.549830-1-qinyuntan@linux.alibaba.com
Tested-by: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/selftest.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index ee706f18f7e91..f6da927461b57 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -2056,11 +2056,9 @@ static int iommufd_test_dmabuf_get(struct iommufd_ucmd *ucmd,
 	}
 
 	rc = dma_buf_fd(dmabuf, open_flags);
-	if (rc < 0) {
+	if (rc < 0)
 		dma_buf_put(dmabuf);
-		return rc;
-	}
-	return 0;
+	return rc;
 
 err_free:
 	kfree(priv->memory);
-- 
2.53.0



