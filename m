Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868093176E1;
	Fri, 21 Nov 2025 13:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731615; cv=none; b=Np3asFvb0vUqt1oSAgFk9nYjtFUjUPnsoO72WJ3UuSx0UJawP5vyi3VwXfu161wKfZ2JKYCVwosnDxFg37m5irNHjVQdzKfJ59dWwWaSUSNFISAQ8DvnIZxBwOBNinNDnSog1l3h2p2yFDBu+2KpYcGRsOrlGDnThvFwJahnuZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731615; c=relaxed/simple;
	bh=xppCginuM+isz92kfOvTC5Symw+Acy+vw0hT8yWUma4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K9ak2KmTnWI6/28hTGUXKwXIG+qCT2i9yjpy1sTxbPKH7Mj7Oj14dACpK0Mm/d3St/Wt5vP526PJUKu7LMbB4VQ3rsUhY83mqZURGii+rIVJhPU9TMcNjOnp/poWiMdmblbHzrn5bzt+DCsweZlYIKzGWwEM2CMoMuxprULbu3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J4IFU79J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J4IFU79J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B45C4CEF1;
	Fri, 21 Nov 2025 13:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731615;
	bh=xppCginuM+isz92kfOvTC5Symw+Acy+vw0hT8yWUma4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J4IFU79JykLYFfSgGRMuPQobpXhJGFulDjTOtUwz5uZK0YAnVCcicSVBJvbBGVDSZ
	 dkddPWetz3EXSmgn2BQ/31nL7JnJdoFus/LxMNH715L9d2OtLv5ooJ/lLJL4lFI1z0
	 XZo/36IL8LKG22zykdttWqcOyMSzbX/jGROTDNUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 022/185] HID: nintendo: Wait longer for initial probe
Date: Fri, 21 Nov 2025 14:10:49 +0100
Message-ID: <20251121130144.676229328@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Vicki Pfau <vi@endrift.com>

[ Upstream commit b73bc6a51f0c0066912c7e181acee41091c70fe6 ]

Some third-party controllers, such as the PB Tails CHOC, won't always
respond quickly on startup. Since this packet is needed for probe, and only
once during probe, let's just wait an extra second, which makes connecting
consistent.

Signed-off-by: Vicki Pfau <vi@endrift.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-nintendo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-nintendo.c b/drivers/hid/hid-nintendo.c
index 2a3ae1068739d..6bdc9165f8226 100644
--- a/drivers/hid/hid-nintendo.c
+++ b/drivers/hid/hid-nintendo.c
@@ -2424,7 +2424,7 @@ static int joycon_read_info(struct joycon_ctlr *ctlr)
 	struct joycon_input_report *report;
 
 	req.subcmd_id = JC_SUBCMD_REQ_DEV_INFO;
-	ret = joycon_send_subcmd(ctlr, &req, 0, HZ);
+	ret = joycon_send_subcmd(ctlr, &req, 0, 2 * HZ);
 	if (ret) {
 		hid_err(ctlr->hdev, "Failed to get joycon info; ret=%d\n", ret);
 		return ret;
-- 
2.51.0



