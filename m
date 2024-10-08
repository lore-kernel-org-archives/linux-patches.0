Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64741DDC24;
	Tue,  8 Oct 2024 12:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391472; cv=none; b=nXRJBNEnib1SgCHcDnY61GVf6t+NGxs0tusGsgaoGYi4qx0EOb5yLQ7nQ33eSlgaGogERtD8CeYNry3dtbNcAjTbbns3QiewVXrZrXc9t3lsHwVxWGBSTtva4tpOvr8RWyC2zZgXPJMmFeh9+RjbLfyS1gl8orsRamZP5yTHRqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391472; c=relaxed/simple;
	bh=gBqeIn7sjNr/FhB2jq4wiEJk+11TNHktRlnZmM/Uzoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MOPcaMWCBrgMS1u/1mFxBkTVFbQBP9PC3fcHGJgZxE8LZI12eqNJDIslMGuSfo34XjkM3sPsuuH1I5vFzgIlSLLJSRMky4dzk0yGMVTpdubxUcu5ShwH1QeWSeE5K+eNOZKYLYpEZUNZpBoOwX39PvO1t820828LxfpiN3dGrN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PkW7gmRm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PkW7gmRm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2036EC4CECC;
	Tue,  8 Oct 2024 12:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391472;
	bh=gBqeIn7sjNr/FhB2jq4wiEJk+11TNHktRlnZmM/Uzoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PkW7gmRmSWHVMHOMX2rMSsTjh0/H8zAbua2IXm7OhYiHk5tlom8cbEg013gGt0gVx
	 YuvtZgAIXGObRCsn/2OvpBSQm1EKREh6J3FhIbUhlTqnKLTj+f4vF3eMDM/CZebFVr
	 YBnBwERz4ukP6t6WByM5+viOe8JovsrYwfvBr4Dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 125/558] bnxt_en: Extend maximum length of version string by 1 byte
Date: Tue,  8 Oct 2024 14:02:35 +0200
Message-ID: <20241008115707.284652596@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 4cf9bf8b01b09..ac06f4a4cf97c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -4157,7 +4157,7 @@ static void bnxt_get_pkgver(struct net_device *dev)
 
 	if (!bnxt_get_pkginfo(dev, buf, sizeof(buf))) {
 		len = strlen(bp->fw_ver_str);
-		snprintf(bp->fw_ver_str + len, FW_VER_STR_LEN - len - 1,
+		snprintf(bp->fw_ver_str + len, FW_VER_STR_LEN - len,
 			 "/pkg %s", buf);
 	}
 }
-- 
2.43.0



