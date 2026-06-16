Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B88F46AEE1;
	Tue, 16 Jun 2026 18:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635924; cv=none; b=Br6scT40gqNFBUKdqKzOpbDtNZjbzXTThNdb8KgMp4ASOSnF1XxePinBFWzHmoBTnavnao1JacsffH+nfWXmSoQ0w4tapyMRcHP32ez5qbajarDFeZgNVP2GL9eeKIjcRnQvoWHA9uPl237ZXkXrZiLJPGiGBm08Fjj07/2f+XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635924; c=relaxed/simple;
	bh=PrEl+t7VdMglqopZtGSwAo5S9vfaCFzCauHo30/7ed0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k4BMWshIqOmCwFNQLQV86YP3xiNip4u98JJsKDHEV38VpMWfy0QHhiC/EZsRxhXeeTXqtJ29g3mI7ABqhHoBFtwSuspCxs9cr/JdqBO/+RpmRuR3cbH3Ut4wukFtlcg2u5hxKlvT4QUyrZoNqS1YPt4kNie5HjlPiTbSmyJifzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H7h3UJUq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H7h3UJUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ADFB1F00A3A;
	Tue, 16 Jun 2026 18:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635923;
	bh=pQV4h8TmK99iDUOHSkWX6QBYg9O/dR+8bc9Gla/CQlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H7h3UJUqEuy95bWTECKb0dGyNe3dXBS7sbl3EdCpUd028CAbdyfUkMCV/hPDwZoJd
	 Wwal9OgNWiI8/+FPlZgaXNEIcCP6hPLFxR5q1oMgham/45mEPsKm1aKpjFXwoYjEdY
	 EO8TqLx5/e4gDMR9GRmDEi5JXrhD0ytT4/nQ0I+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 124/342] HID: core: Add printk_ratelimited variants to hid_warn() etc
Date: Tue, 16 Jun 2026 20:27:00 +0530
Message-ID: <20260616145053.983893681@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vicki Pfau <vi@endrift.com>

[ Upstream commit 1d64624243af8329b4b219d8c39e28ea448f9929 ]

hid_warn_ratelimited() is needed. Add the others as part of the block.

Signed-off-by: Vicki Pfau <vi@endrift.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/hid.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/hid.h b/include/linux/hid.h
index 03627c96d81457..ab56fffb74a200 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -1217,4 +1217,15 @@ do {									\
 #define hid_dbg_once(hid, fmt, ...)			\
 	dev_dbg_once(&(hid)->dev, fmt, ##__VA_ARGS__)
 
+#define hid_err_ratelimited(hid, fmt, ...)			\
+	dev_err_ratelimited(&(hid)->dev, fmt, ##__VA_ARGS__)
+#define hid_notice_ratelimited(hid, fmt, ...)			\
+	dev_notice_ratelimited(&(hid)->dev, fmt, ##__VA_ARGS__)
+#define hid_warn_ratelimited(hid, fmt, ...)			\
+	dev_warn_ratelimited(&(hid)->dev, fmt, ##__VA_ARGS__)
+#define hid_info_ratelimited(hid, fmt, ...)			\
+	dev_info_ratelimited(&(hid)->dev, fmt, ##__VA_ARGS__)
+#define hid_dbg_ratelimited(hid, fmt, ...)			\
+	dev_dbg_ratelimited(&(hid)->dev, fmt, ##__VA_ARGS__)
+
 #endif
-- 
2.53.0



