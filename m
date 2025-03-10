Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276C722CBE9;
	Mon, 10 Mar 2025 18:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630612; cv=none; b=qShaiqjifB4p7M+0OsuHk+8JGxcYCLJwIaUR3rNMkHombjw8A07fOy5MM4HIdSi6Fz1tVak1wWT9wZbGVKSDkUjeY10hg5wsoWL2wLZoNR8wE9FMXVg9IBQHv+/3jWuw0vhdMJLz3oUok6P4KLNpBBaYKGha0kfkrxzC+We53Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630612; c=relaxed/simple;
	bh=tvAOI3V5jZhHw95fyjiKjdIjXmRP6KoTWyjCcZOOQKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZ1T9tKm27QO8ps9+BFjs1EnnUy1lhw1DuJhnSB1CSeD4E//YUT3EqL2gmA3wOBGFwCIEnzqD1XCbJ/v1mgcF+kvtDHVDX3v9KnFW5uibF3XGBbVsqh80EEj5B/Bn90fxVPZ6CHMHsHjaLtf5h9XoMcL0UBdFp2ROqAgwGZjqjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MnLPmBaa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MnLPmBaa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B39C4CEE5;
	Mon, 10 Mar 2025 18:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630612;
	bh=tvAOI3V5jZhHw95fyjiKjdIjXmRP6KoTWyjCcZOOQKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MnLPmBaaM9JTDUJfZCgJEUWfEHTpow2FmvinBM4SA1iGfG8s7HPiYPFGsrgjWh7jN
	 QM4SzhX5qi9L84/WjHBeMldmbGwuD3Sh9AeVlX4TCIsm6IPn0fP6T6FXrgfvfOe1BV
	 0JAa4EL51qJboJ6/s+yHSsEErjGJvTgOahhvT3MA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 474/620] nvme/ioctl: add missing space in err message
Date: Mon, 10 Mar 2025 18:05:20 +0100
Message-ID: <20250310170604.287265697@linuxfoundation.org>
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
index 22ff0e617b8f0..f160e2b760d13 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -183,8 +183,7 @@ static bool nvme_validate_passthru_nsid(struct nvme_ctrl *ctrl,
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



