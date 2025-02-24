Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45586165F09;
	Mon, 24 Feb 2025 14:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409051; cv=none; b=NMzAtoZmfLBMXd2WlHFAwNIm6E+9zuSlQjcBXNl02h41/3FHh4MXt+ZSsnc2HY8iIKki3m/YgKuK1FfRp1Dt6KOa3hKrR9Yl4HJRx9G9rGvRZKt+fFCsbjn4y0KXfCvOjc5xlKXDo0IvP3cuLtg+PHI504zPAWlCaJkYCtbcAQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409051; c=relaxed/simple;
	bh=BO9/gdLdfdNbXY9ELiG+8BD+wMbQXHsPKTqRQnMrA/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kbBKKORRTEmv/EmhABgHda8Si2+Hom1MBZlBqXglKz9nq6QwbEUUdL2qMvqPSU9l01HIbuwCjnL0cLwfWO/ujeD0JCcHXspZzWgO5QbDmrTeH1dK0kNCqrQxvqa0je3xw+CrlDvVZJhvAqUwfK69OV+c+QS5lFWJgRYRnt2R+Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cLtP82E0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cLtP82E0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6AC7C4CEE6;
	Mon, 24 Feb 2025 14:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409051;
	bh=BO9/gdLdfdNbXY9ELiG+8BD+wMbQXHsPKTqRQnMrA/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cLtP82E0EPF7Ai7vCtrZrKcwGW1l1REYGly0tAH6sHsNb00x8Z84MSGcdVUZPkrx+
	 q2jeOfXE63qjKOHutP16A2GWiVSBOpfBm7LNAOtQsFa42y7joEnRjjZpvNIwreISV7
	 cn1D9Fdm1J6ILB7NIPppzo66dlIwAx2nIa1zNhXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 082/138] nvme/ioctl: add missing space in err message
Date: Mon, 24 Feb 2025 15:35:12 +0100
Message-ID: <20250224142607.704430770@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index e8930146847af..b1b46c2713e1c 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -283,8 +283,7 @@ static bool nvme_validate_passthru_nsid(struct nvme_ctrl *ctrl,
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



