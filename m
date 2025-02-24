Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B1224A04F;
	Mon, 24 Feb 2025 14:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408589; cv=none; b=ahqW28HmxuI1mOoW6g1MJ/dxW3C0fdJfUQPkWFbvmWXhFgiyP4e7bp7bTqbEWS6Pu8BHfflFPHfkkPpqIUde0cE/9bKdEf/3Wt4L4XoxwYNC4jqnCgzsVYKthWNzAaztopN84ZGKcvGlpQ3hyHfd/YMPSWTjZDYTWYdeeOqmmX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408589; c=relaxed/simple;
	bh=uPn8DAvUpTQLTrhCIDFlaaQbhnzq9+cR6CsSab+9YpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LHdChAIPIqBcX0EPsK1Yahk9p7ukh0MFtnrVgPPi3tOEF3rZ8HeKl/LZ2Klr0L27DN8UbRWRPdAIqsQzt8Ed7JvD2ugSARkTT6ahk03Sx3jyuYqcvtOUO1f5WaK7ojkMeyOdfh9DwNn/UAa6RKFvUimJfLO6X08//UmAwKXXQuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VolYslKb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VolYslKb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9146C4CED6;
	Mon, 24 Feb 2025 14:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408589;
	bh=uPn8DAvUpTQLTrhCIDFlaaQbhnzq9+cR6CsSab+9YpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VolYslKbWPh+uRxmvwkHrdezzxtD8Yz0/Sv0u552meYdoUEQNA3LHbtXaEVse5niY
	 Cdy1Xm+vy3lPVUpizR/OdpsrUjpq8b992QOtBdypsRtMuVRKSHb/fZv9ni/ZeIOkBa
	 ZefdnVCiKIZTSk/tua15CBE1nqnfWYY4eQaW7ItE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 102/154] nvme/ioctl: add missing space in err message
Date: Mon, 24 Feb 2025 15:35:01 +0100
Message-ID: <20250224142611.057008544@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a96976b22fa79..61af1583356c2 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -276,8 +276,7 @@ static bool nvme_validate_passthru_nsid(struct nvme_ctrl *ctrl,
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



