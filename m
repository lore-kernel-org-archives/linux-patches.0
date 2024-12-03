Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773231EE001;
	Tue,  3 Dec 2024 15:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239425; cv=none; b=OsgQ3ai6fWrwE+dXnhULD6RcEO9yfsRCAeg0Ntx5jPS/PbfMQaz82msNdUF1rf4tl2hTyg8eC7sNKf/3dWBJZge/XNN+uJi7HJXYrBatkhfRMBE2E8FQrIOBRt0boD2FlkBXdYqslnpMdawRFL8pJTBmAU2WnZIAale1ZH5Cq40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239425; c=relaxed/simple;
	bh=ISyQWJAGR7B2WQvYzgu/Ch6zN4LnmFMfV+2Bes5v1Bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNHhK5ZN3Efxe85L96P/yjcue6ylDfhaFnEbWyR9zOORAcKWD8qoHhig3V9JrP7ukgokN2l7OvpNvOHhwbeYL5HbCe2pzdSHYLd23lGPKAVw9OotdkKpJvDmuUxm3H+r/VbooTJkuQ1RtWklXdGrg9pKEtthOkGaCOsAu8u57OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jPL3w2/V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jPL3w2/V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3483C4CECF;
	Tue,  3 Dec 2024 15:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239425;
	bh=ISyQWJAGR7B2WQvYzgu/Ch6zN4LnmFMfV+2Bes5v1Bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jPL3w2/V9g1UB7qJEWUYo4dd3TJnOzp8SQesQvRxGJWGxr1hNREVbl7HtZVri1lcu
	 K+l/LlVkFvvDFzARAN5SN8LhPoLJfnSwiNbpZAZcmnl0Prh6KERpvnbImroEWypImR
	 qgb2l4um3OXvaetyQ03NFcRYMUD3OVBkKeawGJrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 578/817] octeontx2-af: RPM: Fix mismatch in lmac type
Date: Tue,  3 Dec 2024 15:42:30 +0100
Message-ID: <20241203144018.478354839@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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



