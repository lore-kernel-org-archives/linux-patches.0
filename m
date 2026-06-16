Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2599D477E57;
	Tue, 16 Jun 2026 18:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633736; cv=none; b=inZUWM9Cf1w3XDs1U7Byts+z+rGgkMbE7vnKmxDWajL1zi6cG5AnB4hv2O5UBV/BcdoQS9quM1em002EZM/fdfaTMyeSxUd7FcGRuXq0vhdh1riGvT+aX1u+ijtwRtKlEXxrIkClTC4AclKEfbGmc4sF1TEK2QI9tLsTWmDs4Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633736; c=relaxed/simple;
	bh=Ay+XPR1FtR0aPqQtKIQQR2CA/gvAyg2AlpYwtRym1oU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVWHPEBabK5+AC13J6bFgg9aATcPFRUHc7LmZrfODQGwKDTNRFJ8p/HalDI6QLnf7CvoIC0v7JH42DySkrX/hCh4ZcmxunY/wKqz3sB7W4JEz08b85JU7nnjv6e1thKc6pD7UdzMUTIjGxw1cTkJ3xSBS5x8mwWV2NC9P+wQQvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r8FecDTo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r8FecDTo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0971F000E9;
	Tue, 16 Jun 2026 18:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633735;
	bh=8p+6+leTVjAOdAYC7rV2JLdZi7CDqG8kks2+aJTzLEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r8FecDToSIK6sA2Ef+VzTxZa4h+zdNhMNlOLjPBm+Bv1H7p7q8lyKR1ec1Mp4EgYc
	 3chJSX/3378aOMO9wxFl6y481M1p8PXlhML95Z+xYbMoplRQxWZpfwE2bdJWyeXTJV
	 lCrOjECg1fAEcnzbs9llbULOY4KCaXZD8yB/oqkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 136/411] HID: core: Add printk_ratelimited variants to hid_warn() etc
Date: Tue, 16 Jun 2026 20:26:14 +0530
Message-ID: <20260616145107.587773782@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vicki Pfau <vi@endrift.com>

[ Upstream commit 1d64624243af8329b4b219d8c39e28ea448f9929 ]

hid_warn_ratelimited() is needed. Add the others as part of the block.

Signed-off-by: Vicki Pfau <vi@endrift.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/hid.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/hid.h b/include/linux/hid.h
index 671403f208c91d..3968fa039c260b 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -1248,4 +1248,15 @@ do {									\
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



