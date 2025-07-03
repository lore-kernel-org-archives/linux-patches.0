Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39232E4242;
	Thu,  3 Jul 2025 14:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751553885; cv=none; b=XcschSCCyF2jUjZOr5hAYcvJ9Nh0cKF+pki16GSoTxK2SjhdXaVvx+8SLFeSI6O/pna2BKd3M5/pieKlsufkQ09A/wuQ6ZRkA1sh3grbHSkbOuMyNHIpmJo7UhTIjpwRjUVdrWKr1+NbX4v6Jkc2kuETwsEbc4jrQtwYVvzZqIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751553885; c=relaxed/simple;
	bh=XPEtNTVMCHdb4TNUMTFLcgrTFSjgJp+Y3kckMU7/x2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ShqqzR0Gm09s7KAYQxZ1W54wc8vJprC8jRLe/D35wGb23qWNPAOGBR4d+emYXMMGbOLD7RyaEOL/5Qc00wLKlxz1Ff+om+uutc+4CAY6Y8ZQfdp9aQ4KvrUbIrZtOLxmSm1XuuGSCYnBKzjISvsgVAhxBTHc4EuNM4LBn+ty3YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AdKx+qu6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AdKx+qu6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99476C4CEE3;
	Thu,  3 Jul 2025 14:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751553884;
	bh=XPEtNTVMCHdb4TNUMTFLcgrTFSjgJp+Y3kckMU7/x2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AdKx+qu6+PRJqqKdCb4EcwGsXpdxkX8FMCFPEjkMcSuM5LrVJvk3hyybz5kLcwYCf
	 BQakxNzkgqB4mHo9JuEQ5HufONfP32yAtp0Lm+/8ykyppzu+CDy15dJiFZcgAXdSM3
	 NQjVvNGgpC9OvyjmjCODHM1zm0PIy39qryke9s/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Richter <rrichter@amd.com>,
	Gregory Price <gourry@gourry.net>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	"Fabio M. De Francesco" <fabio.m.de.francesco@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 013/218] cxl/region: Add a dev_err() on missing target list entries
Date: Thu,  3 Jul 2025 16:39:21 +0200
Message-ID: <20250703143956.489548039@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Robert Richter <rrichter@amd.com>

[ Upstream commit d90acdf49e18029cfe4194475c45ef143657737a ]

Broken target lists are hard to discover as the driver fails at a
later initialization stage. Add an error message for this.

Example log messages:

  cxl_mem mem1: failed to find endpoint6:0000:e0:01.3 in target list of decoder1.1
  cxl_port endpoint6: failed to register decoder6.0: -6
  cxl_port endpoint6: probe: 0

Signed-off-by: Robert Richter <rrichter@amd.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: "Fabio M. De Francesco" <fabio.m.de.francesco@linux.intel.com>
Tested-by: Gregory Price <gourry@gourry.net>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Link: https://patch.msgid.link/20250509150700.2817697-14-rrichter@amd.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/region.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index a0d6e8d7f42c8..f5429666822f0 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1781,6 +1781,13 @@ static int find_pos_and_ways(struct cxl_port *port, struct range *range,
 	}
 	put_device(dev);
 
+	if (rc)
+		dev_err(port->uport_dev,
+			"failed to find %s:%s in target list of %s\n",
+			dev_name(&port->dev),
+			dev_name(port->parent_dport->dport_dev),
+			dev_name(&cxlsd->cxld.dev));
+
 	return rc;
 }
 
-- 
2.39.5



