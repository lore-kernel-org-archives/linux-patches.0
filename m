Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564EF2E266B;
	Tue,  8 Jul 2025 16:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993097; cv=none; b=nIwLQpTShXgVonNiW7LGszdowAusX02oLIoTowqOuNw0GjRxX8lUSSc1O9VLDwgx2mZN4MV5X2SRtRVAMCT7HdaypLE1SCdLdABgC5nfevnJ1EnU28ko/RUPX1SLKwtzi0r34CuYgvpRHVLUQ1wQamLise3BPELOctSoxf/3T3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993097; c=relaxed/simple;
	bh=rYhDtxQp2q+IjFwjrfai2gC94AW7ioDv+Df0Igo8nAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ry+Fjr5lctMWKTeV2jbVwNHELgyC77Iord+ka6tjZ+TM0MM552jZZNyBW04w3+SyqGCOCCVqxKXWxqvbUdEE4ph/YOVXiTdjNlb9Yxjwts/rjEsSsnvFp3YZ11V2P6anLvRhbmvhGx3fUxxp3A3cnJtjDWQ1GtT4iFYgEKz9rgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TQbuusxk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TQbuusxk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE6CC4CEED;
	Tue,  8 Jul 2025 16:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993097;
	bh=rYhDtxQp2q+IjFwjrfai2gC94AW7ioDv+Df0Igo8nAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TQbuusxk0Qbfv1sOMuhLLo5FbzjiB+LGjl0kllIZ4G04SPipk2ickVCwfw8s0flhq
	 XFJalTJVnq5HRnEJ7zIu35ueMMiF5xvUSJ5TtPlEE64wqrGJAwvEpTtWgkjroxCC4v
	 2K7F1RGr3H+GJUKZbGPEWvj2Y4QMB5IKGfDgshgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+92c6dd14aaa230be6855@syzkaller.appspotmail.com,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 186/232] wifi: ath6kl: remove WARN on bad firmware input
Date: Tue,  8 Jul 2025 18:23:02 +0200
Message-ID: <20250708162246.299891226@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit e7417421d89358da071fd2930f91e67c7128fbff ]

If the firmware gives bad input, that's nothing to do with
the driver's stack at this point etc., so the WARN_ON()
doesn't add any value. Additionally, this is one of the
top syzbot reports now. Just print a message, and as an
added bonus, print the sizes too.

Reported-by: syzbot+92c6dd14aaa230be6855@syzkaller.appspotmail.com
Tested-by: syzbot+92c6dd14aaa230be6855@syzkaller.appspotmail.com
Acked-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Link: https://patch.msgid.link/20250617114529.031a677a348e.I58bf1eb4ac16a82c546725ff010f3f0d2b0cca49@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/bmi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/bmi.c b/drivers/net/wireless/ath/ath6kl/bmi.c
index af98e871199d3..5a9e93fd1ef42 100644
--- a/drivers/net/wireless/ath/ath6kl/bmi.c
+++ b/drivers/net/wireless/ath/ath6kl/bmi.c
@@ -87,7 +87,9 @@ int ath6kl_bmi_get_target_info(struct ath6kl *ar,
 		 * We need to do some backwards compatibility to make this work.
 		 */
 		if (le32_to_cpu(targ_info->byte_count) != sizeof(*targ_info)) {
-			WARN_ON(1);
+			ath6kl_err("mismatched byte count %d vs. expected %zd\n",
+				   le32_to_cpu(targ_info->byte_count),
+				   sizeof(*targ_info));
 			return -EINVAL;
 		}
 
-- 
2.39.5



