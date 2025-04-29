Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BEA227E95;
	Tue, 29 Apr 2025 17:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948503; cv=none; b=ZY+vJvo5YDwWJP6OPfoKqeMjm3Ma6H1P62yb2Ai/r1A17FtPYINZE0Nhj5xP8TxQxK/JuI16Bx32u5Zz3MchWFSIsO1fzSiNfMWxvy1u7QciRkc9EWlGjRiNPx+XpCbsquQ5DibFwcwHhYydouHCBi+KV3tP7mM+OBQgGiZ3Z04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948503; c=relaxed/simple;
	bh=1HIzW+TA/jZe7jMSJHIztBTCYWSLcRRujH1KHUl6teI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqa4P8TL0bETR5tP7QPSKWWP/Ml23BmY2AdhODYt9W/y065ZDG/UV69IEHeWBiVPYhR2xTboSWLTCQXtcAbVELZvDZx0SDbDic2dILZGBphvWmA6ezpfLT+ZgUSXaHjAqtoQRK3qxnbw9z641ok3m82G4Zo3ea1q/k6AwQOoXjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VIpBz99K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VIpBz99K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98029C4CEE3;
	Tue, 29 Apr 2025 17:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948502;
	bh=1HIzW+TA/jZe7jMSJHIztBTCYWSLcRRujH1KHUl6teI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VIpBz99KTHMcQIo9rJCA0R0SuhXI8iZImsE9MsOwHMEyLsl4A8SWIsDdIdFw3l91N
	 9jPeNCHm62863gBVcyvDoUjg2dWmt2zQu386ZGoj+W2PRtfzArescN6itC7DypPdHi
	 qhMXYuzghizx+FXZ3WfJHmVsCLSowqQHtf8Sl0bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <wagi@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 008/373] nvmet-fcloop: swap list_add_tail arguments
Date: Tue, 29 Apr 2025 18:38:05 +0200
Message-ID: <20250429161123.478331152@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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
index f5b8442b653db..787dfb3859a0d 100644
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



