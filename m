Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBA215442C;
	Mon, 24 Feb 2025 14:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408227; cv=none; b=rKHqcuUobXUq6nGWixCNyjusgqCHsGTv3DuNPjEWfWjfFaAxVT1PQPeYPrNErtnKHxFUFj7xhzyu39OCDV6bNPR7xevra395fGPbZSwFo5+W3Mal1vPf7ImGFGeeRPAy7YB0AkaZuajr1/towijbmuB6E3xptm18OTbMKHETn6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408227; c=relaxed/simple;
	bh=NCVnbX3O9dyv+5c44AnIIqcw1uNUonQ6z9qfH9IKc/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kPGI6R5DvTxQiwXDgZLtV4javZTD6To0lRv1mFWYVN1ZcPTtGqkseA+5hTcvDLkFrrbbrLTUFKRlVHtiR7jIw8015LyR3vND88iX8WgSL0euDtaeJB50P2WkEuY370dtZXuqkBWCVe3nVUykP6yGwTcMIGugv0zUIFP664MUruk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZoC9KnOb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZoC9KnOb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E510DC4CED6;
	Mon, 24 Feb 2025 14:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408226;
	bh=NCVnbX3O9dyv+5c44AnIIqcw1uNUonQ6z9qfH9IKc/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZoC9KnObCs8oaIiEO7PYNfUTCa31xGRCHvNSMN2Eay3NltSGwBI1C0pN/gxr0kIdl
	 v3tALzWRmeWSlQ6IdRnr9OCUu9LM7uMb0kbWHBHza4jClqPgasQOD+9xiPI0q3cDgU
	 KE34k8d6l6sgRnxpn6xYl0oc6A2l052JeFOn8j8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 104/140] nvme/ioctl: add missing space in err message
Date: Mon, 24 Feb 2025 15:35:03 +0100
Message-ID: <20250224142607.100747139@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit 487a3ea7b1b8ba2ca7d2c2bb3c3594dc360d6261 ]

nvme_validate_passthru_nsid() logs an err message whose format string is
split over 2 lines. There is a missing space between the two pieces,
resulting in log lines like "... does not match nsid (1)of namespace".
Add the missing space between ")" and "of". Also combine the format
string pieces onto a single line to make the err message easier to grep.

Fixes: e7d4b5493a2d ("nvme: factor out a nvme_validate_passthru_nsid helper")
Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/ioctl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 19a7f0160618d..4ce31f9f06947 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -336,8 +336,7 @@ static bool nvme_validate_passthru_nsid(struct nvme_ctrl *ctrl,
 {
 	if (ns && nsid != ns->head->ns_id) {
 		dev_err(ctrl->device,
-			"%s: nsid (%u) in cmd does not match nsid (%u)"
-			"of namespace\n",
+			"%s: nsid (%u) in cmd does not match nsid (%u) of namespace\n",
 			current->comm, nsid, ns->head->ns_id);
 		return false;
 	}
-- 
2.39.5



