Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B80B2EA49E;
	Thu,  3 Jul 2025 14:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554591; cv=none; b=ZMB23gXPGcXWUDH2ORB0814xVE3KVW6PNyhzlHX32TlkbkUP/dxSs0FCd6ufcz0MnNkl815IJnu7ej8B4dCKxRaB2mOlnuJdiGRLsqugChYEgvZEETNqauBtHei+qo47JSWsHKenwchACep27Wpm7wcLN1TMOGlfB1dDznk0pnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554591; c=relaxed/simple;
	bh=1Zjcp3M5Zaqw5Uxs4G0ujv0JQQ0Egu3RLi5CvnGRtzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7Y65plkzX0ASjZcAWAdxGDlYxin+P2/+Msuh/eJnUpu10K4T4059p06cjdUEXTVPdvNQKL+PVOT8dTqLMwH2mWDkPVT5yWeSaqm/YGiQXnNExmYK3pcbIp2kxfbxo5ZHRFhkVW0Rptoo8/nQpLBfW4Uu0D/gnUxnfbUB5z0iBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f48lvwEh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f48lvwEh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEBD4C4CEE3;
	Thu,  3 Jul 2025 14:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554591;
	bh=1Zjcp3M5Zaqw5Uxs4G0ujv0JQQ0Egu3RLi5CvnGRtzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f48lvwEhbUw7MYl4T4uNxkoe/k4z78MKIL1QE+khZn3Jlg4nazc1XiN9mfbflX+OJ
	 Au89ZB8MQLjPDQDU70GtPM5Didl2+DfHYK1sFfpX2yIKZBlcAFIk5iJ2O4yPtft2jF
	 5cm23WYMWK0tNRsZpwVmm75j4FqvZwe2wsZOsp44=
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
Subject: [PATCH 6.15 018/263] cxl/region: Add a dev_err() on missing target list entries
Date: Thu,  3 Jul 2025 16:38:58 +0200
Message-ID: <20250703144005.023394071@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index c3f4dc244df77..24b161c7749f9 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1805,6 +1805,13 @@ static int find_pos_and_ways(struct cxl_port *port, struct range *range,
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



