Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C8127147D;
	Fri, 21 Nov 2025 13:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730942; cv=none; b=dyvjIQ+urNzbZyD0a5ICBoQw46WEY7mwZ7Fi5MM53NbiY8pffeI6airIgZ5wjErtq0VrSuIS3Y5sAUiAVplaM5Uebf87Yaj4GnsoRy9QwhdmFOgnorK3sfD7xXKSDKG/dQSkgiqXMKv51FU2sPSqItzKlFTJWHDFQtOwef+RuJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730942; c=relaxed/simple;
	bh=rh8kt7sw3TfjX4NBok+tSG6QH3fZrgk5wkeJiYcXh6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mhd9WWmEuCBTcK9CYW54690DDib4YTkaJlREGoS1ij7VagCF8lsgE1a/AsGqjqyGycLt0oxDvWbChkL8tWXZRsjGZaweO0vMrSBq90KTd2pt6wPH+blv4p+U557IJ2hWZTbEZRV25+mrGNv14kQC55QNBxg9oi58cPRWZFy6OSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nI96ZNDw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nI96ZNDw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A16C4CEF1;
	Fri, 21 Nov 2025 13:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730942;
	bh=rh8kt7sw3TfjX4NBok+tSG6QH3fZrgk5wkeJiYcXh6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nI96ZNDwbywJb4hZu8cP0v9aFE4iYNYdl3OMeCrNdQqSAQ4E0Hrb2KQasRemHRxBd
	 xxE4W1qg0MNF6INRgaV+z0I0qbyUQxj9HicMPC2+koIqfHmpDXiruTn4BnKwj/uCES
	 /sKDQFqMrk8mNQma5w6/CIoY29XY8ih+mxbucZZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 035/247] HID: nintendo: Wait longer for initial probe
Date: Fri, 21 Nov 2025 14:09:42 +0100
Message-ID: <20251121130155.864505346@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index fb4985988615b..e3e54f1df44fa 100644
--- a/drivers/hid/hid-nintendo.c
+++ b/drivers/hid/hid-nintendo.c
@@ -2420,7 +2420,7 @@ static int joycon_read_info(struct joycon_ctlr *ctlr)
 	struct joycon_input_report *report;
 
 	req.subcmd_id = JC_SUBCMD_REQ_DEV_INFO;
-	ret = joycon_send_subcmd(ctlr, &req, 0, HZ);
+	ret = joycon_send_subcmd(ctlr, &req, 0, 2 * HZ);
 	if (ret) {
 		hid_err(ctlr->hdev, "Failed to get joycon info; ret=%d\n", ret);
 		return ret;
-- 
2.51.0



