Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4AF11DE8BE;
	Tue,  8 Oct 2024 13:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393246; cv=none; b=PZL0vD+bWx9H813C0AerDfo5dGlfAMkYj+Fwals7cvhsaWKHnb3hY+efsO3UWCO6qMjnk8SrrGYWHLlj5Zat8qZYnRvJd9nVJeVUJDI0P7cDFbQvHmI4FgUsbfXG8R6eIh1t2Dxo/C4ULqlJpkgX41fAuLxJ0LydhCwTcAGAmvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393246; c=relaxed/simple;
	bh=hunVHJpD1oRAKYPJ9am59t9++gi0DfwaHnSTz5fqpk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iY0VDoI19lmD8b/2xrg1fjymuiR9idwRHBCcLn7uK4hirh24sX0NFftV5i8bh9EmssMBmiDfWReEY+Hnvi0KQL3a5iWHZ2cutEG492banqRlfXJSJk4MBE1s3MFA8wAeoagIvYoxhEHvhvG5PVWqpZo2PS84ybr8q4hsUbIJd7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jXVvHLT3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jXVvHLT3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C43C4CEC7;
	Tue,  8 Oct 2024 13:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393245;
	bh=hunVHJpD1oRAKYPJ9am59t9++gi0DfwaHnSTz5fqpk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jXVvHLT3Tx+8YmOoPJV3pWiVp7HQSJ5JUgcqYWPD3dItf7e6XQESwzc+jF/gG0k0o
	 o9LMJx0IjNGfuREXtPi5k4TDZrwmFm1RhyTIbKbtL4+7bqa5fPpsLozxCAsxymXPJj
	 xZG3H8Za3F6kOOLw7ftgyP6ng/tHqJqfi/VXrVGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 088/386] bnxt_en: Extend maximum length of version string by 1 byte
Date: Tue,  8 Oct 2024 14:05:33 +0200
Message-ID: <20241008115632.918306814@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Simon Horman <horms@kernel.org>

[ Upstream commit ffff7ee843c351ce71d6e0d52f0f20bea35e18c9 ]

This corrects an out-by-one error in the maximum length of the package
version string. The size argument of snprintf includes space for the
trailing '\0' byte, so there is no need to allow extra space for it by
reducing the value of the size argument by 1.

Found by inspection.
Compile tested only.

Signed-off-by: Simon Horman <horms@kernel.org>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20240813-bnxt-str-v2-1-872050a157e7@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 3c36dd8051485..2e7ddbca9d53b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -3021,7 +3021,7 @@ static void bnxt_get_pkgver(struct net_device *dev)
 
 	if (!bnxt_get_pkginfo(dev, buf, sizeof(buf))) {
 		len = strlen(bp->fw_ver_str);
-		snprintf(bp->fw_ver_str + len, FW_VER_STR_LEN - len - 1,
+		snprintf(bp->fw_ver_str + len, FW_VER_STR_LEN - len,
 			 "/pkg %s", buf);
 	}
 }
-- 
2.43.0



