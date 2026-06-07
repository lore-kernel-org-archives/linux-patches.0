Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D454071E3;
	Sun,  7 Jun 2026 10:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828139; cv=none; b=g1nI/gyKLWrlEZaNrQRC8mU2y3YhS5kIihOyl7vm1jznNl1A+j6OcJegKOg5dKQFYpLGacqTKPsaKgDLf+K4ORe+g9nqStNhejIStl5rCzBUDZBxWSz1oQPNWv6V13AeWmpUGKdJR74sVC2jYf3Dpbsnq6CoxOISBE6No+bpQio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828139; c=relaxed/simple;
	bh=wg5SSOT4KXawW3I8q0BisSXsq72gNbPa+sDsel/KvgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A8/rqW/ETQFjXGBVNihG4Gb55tzXZyEyifJJYsKbub3ms2pN2MoXIkt91i37alCR+2YXwhtPHjGxjbY5Yc6BVHjY1D07T62E6EpFCj8a0jEsi1CISKovDjCLlAvceU6NcF56K+pe4XNrOCRAn2J+OM0SHfCXukfZe7Tomw5TShw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dRX7UaJX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dRX7UaJX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2741F00893;
	Sun,  7 Jun 2026 10:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828138;
	bh=UX53BFDzq2rJWmeN1eXdl4vUxOeipeFTI8NVrbr2g+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dRX7UaJXwZHuYfJ43YM+TvkYD5hcn0yH491JueVqqzJYboy6TH6n1F/k3EyrBXl6h
	 1/EWkD9cz5Vx4a7KY5mtopJGIse870GLaEgRk1VhKDBN/YAE16iY2rZkFoxWegQiev
	 XhwTAAVy5LSAaiINkJlCwkzzqrpaguUhw8o799Ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 114/307] HID: core: Add printk_ratelimited variants to hid_warn() etc
Date: Sun,  7 Jun 2026 11:58:31 +0200
Message-ID: <20260607095731.961055983@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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
index 7d8d09318fa91d..bef017d6b44042 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -1245,4 +1245,15 @@ void hid_quirks_exit(__u16 bus);
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



