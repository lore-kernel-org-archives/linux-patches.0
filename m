Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E230F2505CF;
	Wed,  5 Mar 2025 17:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197283; cv=none; b=G9fS9A7AM5oBgBqde7pcmW84rk2mZWVzaZ9Mt5Gaywv7D/OO+OPsAgq+ADuuE1H6GpWfNMf2ZpA8Ew+ga05Luh/8cYEFJ8NdPMMjqFhs6oyvqDomCoptI72HQw4l02rvsf+95a8/37VRZIFPeU88mJ4vokUyCBsnRCQw3oCS8i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197283; c=relaxed/simple;
	bh=lr4IuyUVVZo4a3/vA3khWo+6anIySPtBQIjCvd7rNrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IxM5cis9i23XtyT4YdUQ14wnkAMvZ2mxc14uYauy6eaHAnJhNq0+5KPta7Q9LWBtPKm++jA9LmQmC0QOaUwOUE9Zco3jgXToi3FFX6szHbLnPBgXahdODdV4IDc3keVNYrx8skFbpNQcornq8EQXr1wsNRVK4RfhIvhvLjtqJiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M1w6N2GG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M1w6N2GG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F163C4CED1;
	Wed,  5 Mar 2025 17:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197282;
	bh=lr4IuyUVVZo4a3/vA3khWo+6anIySPtBQIjCvd7rNrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M1w6N2GG1AaOJKDJuNYy1hobydTKUW0RLhlYaAkUB8PiMQNhLdyl3L7BsE2QVlgSZ
	 7/9if68Xodyfeva2ASXQg2IVOaQ+F0U5WeHCs71XYOd0rnXuBuW0Aw0ylK8okdg2Jz
	 TYGGBqs5j+wwyYUiFRO7i58WsBXgKVkhBWHB9vKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 070/176] nvme/ioctl: add missing space in err message
Date: Wed,  5 Mar 2025 18:47:19 +0100
Message-ID: <20250305174508.268567512@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a02873792890e..acf73a91e87e7 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -262,8 +262,7 @@ static bool nvme_validate_passthru_nsid(struct nvme_ctrl *ctrl,
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



