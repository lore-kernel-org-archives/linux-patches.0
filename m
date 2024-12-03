Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2A423CE;
	Tue,  3 Dec 2024 16:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241974; cv=none; b=ctyn2w8f3jRudpo7ilA8sstge1kwPKzzvYw9+NXNlhp+Jajjo3vuhas2WcU50fFK0MWe+4afEQgVuig1B2Z1yPvwqMcTxD3tzfOwVELwpMMESnpZx+hQL/N1LoZS2evUa9Wo07+sQMxvMRJxtpjEIYGGeCAoYG4ZkaWC0321TPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241974; c=relaxed/simple;
	bh=NDZQ3Sdg48CXAJRNVesRPhp6ctYwaGzi30Dm4pvBEaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qkCw0Muw6HlXrtX179oIieP7Sh2MQe+BTkCi3RAQhu2Glwb2jNsCex5uEwsWa0LdUaGs72OVXzrwOnhQ0dbEm4SDB1DHqNVVBxo/yRrywOEj9E2ELTfPVlPsKNQYWmRNaLO93FigDHCamRTTwvOqaK7p/6y/rZFQ/iyG8MgPZGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sCb+XbhT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sCb+XbhT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3562FC4CECF;
	Tue,  3 Dec 2024 16:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241973;
	bh=NDZQ3Sdg48CXAJRNVesRPhp6ctYwaGzi30Dm4pvBEaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sCb+XbhTOBGIqh1+g1HAcau5gJei+7iRJr4sOdZHP0rkPqjKg07R+QaRRnrGsrUAP
	 wNSMmSeAC9Mz97Al3UmRBUYDEWK626W0ZOK8YAEldEgoAiUw3zBwLiH49P2Sd/ZHm0
	 17aD7tRISdR7fj7vf3wXt/LU8lPfD5eLJlR/E6R8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 570/826] octeontx2-af: RPM: Fix mismatch in lmac type
Date: Tue,  3 Dec 2024 15:44:57 +0100
Message-ID: <20241203144805.983953427@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit 7ebbbb23ea5b6d051509cb11399afac5042c9266 ]

Due to a bug in the previous patch, there is a mismatch
between the lmac type reported by the driver and the actual
hardware configuration.

Fixes: 3ad3f8f93c81 ("octeontx2-af: cn10k: MAC internal loopback support")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
index 1b34cf9c97035..9e8c5e4389f8b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -467,7 +467,7 @@ u8 rpm_get_lmac_type(void *rpmd, int lmac_id)
 	int err;
 
 	req = FIELD_SET(CMDREG_ID, CGX_CMD_GET_LINK_STS, req);
-	err = cgx_fwi_cmd_generic(req, &resp, rpm, 0);
+	err = cgx_fwi_cmd_generic(req, &resp, rpm, lmac_id);
 	if (!err)
 		return FIELD_GET(RESP_LINKSTAT_LMAC_TYPE, resp);
 	return err;
-- 
2.43.0



