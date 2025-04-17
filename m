Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753C9257ADB;
	Thu, 17 Apr 2025 17:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912512; cv=none; b=VYF8BeOdSckpSL3XgjtmXbdwVbvtu+zRBQ2z4L4W8U+PJ/7fGBo06NIGF0FklImNFuRRlQMSADu4P6TW5QcFaiC4D67NKFxWL3A3gzxJlhfTtpusXTzo8QCkUpiCdEyG9XJwXLWw8UAWDkFyRsH4YEdJzJo/PQYvLORIVtpjDQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912512; c=relaxed/simple;
	bh=A5PTt5lRvk/yMWP2+9CPTF17Yl6wM3FMlMHKCHXC8Eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fc8cDWVd8rixZpkyR5Dyds2I3egCL8bj5ygjPOdCuaRgSi5kk1HqQuEq2QNHpS155k7eXtFH/JZNSl6zJbP8SNW9/sycjbjOtjcAvbqVNNlj1CL/+HALD7ln55qRcWX+6A+yn6oTlYGQj1E7CZOqBFZh3W9bdfHq016X1o6uwFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FG0d42tI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FG0d42tI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E372DC4CEE4;
	Thu, 17 Apr 2025 17:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912512;
	bh=A5PTt5lRvk/yMWP2+9CPTF17Yl6wM3FMlMHKCHXC8Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FG0d42tIo+1qKEd4scF7ARFecpOp8mgTligvA2QgZmYnUC8LeqCAy3KADsnyptrmO
	 hcuvlcRsE+CgsnMOMQy5SZIVDNG0EfKzvHSTd/H4bWpmZBOQln56kGpaxax3Oqu6UY
	 stTiGObPcQD+76t7vgpXBthdNVldGTTL/A4yJtL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <wagi@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 033/449] nvmet-fcloop: swap list_add_tail arguments
Date: Thu, 17 Apr 2025 19:45:21 +0200
Message-ID: <20250417175119.330851925@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit 2b5f0c5bc819af2b0759a8fcddc1b39102735c0f ]

The newly element to be added to the list is the first argument of
list_add_tail. This fix is missing dcfad4ab4d67 ("nvmet-fcloop: swap
the list_add_tail arguments").

Fixes: 437c0b824dbd ("nvme-fcloop: add target to host LS request support")
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fcloop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/fcloop.c b/drivers/nvme/target/fcloop.c
index e1abb27927ff7..da195d61a9664 100644
--- a/drivers/nvme/target/fcloop.c
+++ b/drivers/nvme/target/fcloop.c
@@ -478,7 +478,7 @@ fcloop_t2h_xmt_ls_rsp(struct nvme_fc_local_port *localport,
 	if (targetport) {
 		tport = targetport->private;
 		spin_lock(&tport->lock);
-		list_add_tail(&tport->ls_list, &tls_req->ls_list);
+		list_add_tail(&tls_req->ls_list, &tport->ls_list);
 		spin_unlock(&tport->lock);
 		queue_work(nvmet_wq, &tport->ls_work);
 	}
-- 
2.39.5



