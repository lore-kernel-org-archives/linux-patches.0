Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7BB326924;
	Tue, 16 Jun 2026 16:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628992; cv=none; b=SsVX8Dz7TlpKRyZgFOw+4lGvCd9I2gm1SgbuVlGkk7guBSAB/8NwZEJctPjyAyFJBUKh5fr2JNlvgILY3R4zIwNLOY5oBf7YF2rkkhgyalM+R9JVX9so/AQNLdhCyIaXbUOosLnPcsgEFkFu7sXHEg8Z7LJldXVHrOKpHY+JkbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628992; c=relaxed/simple;
	bh=X2c5gx8DYQdsJiQl5s2bqYIYHeiJyIo3dwAWVZlkJ14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xvq9wgQ6kTj9gUhX1dlqX7ovoGHtgFBiAgzL8WZWqz25DF316/7WzK0XIwbJVi7C0y2LeMsw6zfQ/QPzrktvKfW9pX68pwS2Xb2MVXjPCyRggkdNTN785BHjvWefJXD3Bg0DdCjtXvPj8BccPYS8DTgI/Ybe+U3fxmi2pR571ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V4tZbPr6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V4tZbPr6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8E51F00A3A;
	Tue, 16 Jun 2026 16:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628990;
	bh=0I69kVOs/kEiFdtut1DUhFEYOIx1tpFrDLXFj1VWRsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V4tZbPr60mKle7HXT5XMghLAbq8yHfhFej5jnnB3HVhALanCl6zUOusDNBGi3usdP
	 NGmQq/7lPiaT08Xni34o9j5Ft8k/dc/xf2DeydCVXwhc/FgJn7BS3z5BkUgH8d/P8m
	 6mq4mieDhfYOTSAzPCxsgngei4z2toBsmkCK0BAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.6 200/452] HID: core: Add printk_ratelimited variants to hid_warn() etc
Date: Tue, 16 Jun 2026 20:27:07 +0530
Message-ID: <20260616145128.332996007@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vicki Pfau <vi@endrift.com>

commit 1d64624243af8329b4b219d8c39e28ea448f9929 upstream.

hid_warn_ratelimited() is needed. Add the others as part of the block.

Signed-off-by: Vicki Pfau <vi@endrift.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/hid.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -1252,4 +1252,15 @@ int hid_pidff_init_with_quirks(struct hi
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


