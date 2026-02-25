Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4346248881;
	Wed, 25 Feb 2026 01:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983414; cv=none; b=MnYulyIGqV3ZDbfKgN5HvU5Om/ucN7W4O+tKfafoQGNOxSUI0ppv6vLNb+swOGenoKltr77aVIQ4UCp+iwVhH0jO6kauT9USY/veluGpMrfS0eQ5qK5aAvVMva11O0Z+/VJvJAwJOoeqWPVwxsyU8rEICzRclR3khjQg1zesBwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983414; c=relaxed/simple;
	bh=Fzk6gJfh3yJFYN9psbF3HcqW+1G61Q+r2h6BvbOni+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sroidfDuvtrz2SqEGkkpdJzDWkKA8THU4EbQeWcuiPMh+MBVYs36hzaMJtnVp7vDi+QZmW4ee1saEvGcGhP+VMnaAQ9asjeIvwM8kUvtJmlO0xzxlo3Yb3lAyAgESS4F+5jzRPMZ/+wHCK/jlFQdkb8awXOuP8Ypgxra//iSgS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FqlxL6mH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FqlxL6mH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C2AC116D0;
	Wed, 25 Feb 2026 01:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983414;
	bh=Fzk6gJfh3yJFYN9psbF3HcqW+1G61Q+r2h6BvbOni+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FqlxL6mHnnEZxKrU1F76LFz9osdcRDOsODmIjakfmciUXlWGuy1DINx70fXB5SXjK
	 kfY/kTw6HWZSryAhJ33MuD3T/vaRE5i1ljqXW9FCUEFSg1l3kjlO3eK2lvQqRCD/15
	 vnyEEE5KZEyfINFVeBv7TuBaa8Ps4eo6nIiu4f8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Richter <rrichter@amd.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 481/781] cxl/hdm: Fix newline character in dev_err() messages
Date: Tue, 24 Feb 2026 17:19:50 -0800
Message-ID: <20260225012411.611477729@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Richter <rrichter@amd.com>

[ Upstream commit e5b1887619403c2da25a5899cad3e1ab34e7717f ]

The newline character is not placed at the end of the string. This
causes unintended line wraps, broken log level and unterminated log
messages. Fix that for all messages.

Note that the messages are changed to use colons now instead of
parentheses, which is more common use.

Fixes: 24b18197184a ("cxl/hdm: Extend DVSEC range register emulation for region enumeration")
Fixes: 9c57cde0dcbd ("cxl/hdm: Enumerate allocated DPA")
Signed-off-by: Robert Richter <rrichter@amd.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Link: https://patch.msgid.link/20260109122952.639231-1-rrichter@amd.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/hdm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index eb5a3a7640c60..a7ad730763e85 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -966,7 +966,7 @@ static int cxl_setup_hdm_decoder_from_dvsec(
 	rc = devm_cxl_dpa_reserve(cxled, *dpa_base, len, 0);
 	if (rc) {
 		dev_err(&port->dev,
-			"decoder%d.%d: Failed to reserve DPA range %#llx - %#llx\n (%d)",
+			"decoder%d.%d: Failed to reserve DPA range %#llx - %#llx: %d\n",
 			port->id, cxld->id, *dpa_base, *dpa_base + len - 1, rc);
 		return rc;
 	}
@@ -1117,7 +1117,7 @@ static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
 	rc = devm_cxl_dpa_reserve(cxled, *dpa_base + skip, dpa_size, skip);
 	if (rc) {
 		dev_err(&port->dev,
-			"decoder%d.%d: Failed to reserve DPA range %#llx - %#llx\n (%d)",
+			"decoder%d.%d: Failed to reserve DPA range %#llx - %#llx: %d\n",
 			port->id, cxld->id, *dpa_base,
 			*dpa_base + dpa_size + skip - 1, rc);
 		return rc;
-- 
2.51.0



