Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F47242848B;
	Wed,  4 Feb 2026 15:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217710; cv=none; b=EJZ/9H37B4X/Z9B8pe/98EnxXgFh4GIUQBSNXtacob4VrLXV+MLVd+a4J9GkDWIYfJNojk84Vt4yeTVw9L12aQc05vNM8cxF8dbz9nHLyDZS5BRbPBdtONy+oWVcYpyypvBbtqUf7gJ3KShwjV5VF/q9C3qvHQR6klfAIPf+XVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217710; c=relaxed/simple;
	bh=uRLmcWpIbn8ZWCVJN11m+syaEUzklBc4wFDPq98voYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UN2iMxJsY5rSKCUtMQyJKdx2iasLyHoI5othF+0crpMbsdyy70TQCcLw8ypVGQPF+9eqh1yxrQIYlC5YdDcNL3lhLo0QGfWQy/rMBPDFhVF4net2umEvc3eyv4tFB4w4qa+dHkkK4C3RlYwgDBeMUYcI1hYip6ebiDJcmQ2D9MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NHljIq8R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NHljIq8R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C2DAC4CEF7;
	Wed,  4 Feb 2026 15:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217709;
	bh=uRLmcWpIbn8ZWCVJN11m+syaEUzklBc4wFDPq98voYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NHljIq8RO2UM0t16j2Sdf/0xdhTHWidSsxBp0SLstmT5TIwEr0zAcPrjnDhfRyvw8
	 dwdN88KYWSOrLbX7atGmgHY/PUjAvYc8YV8NgrQi6VEfL47S1lZqgWoN8Aqw+pOlbn
	 gKjPBT27gJopmvT+qSLvvqICHTYOsqqWp5+10M4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Wolf <wolf@yoxt.cc>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 096/280] ata: libata: Print features also for ATAPI devices
Date: Wed,  4 Feb 2026 15:37:50 +0100
Message-ID: <20260204143913.108127189@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit c8c6fb886f57d5bf71fb6de6334a143608d35707 ]

Commit d633b8a702ab ("libata: print feature list on device scan")
added a print of the features supported by the device for ATA_DEV_ATA and
ATA_DEV_ZAC devices, but not for ATA_DEV_ATAPI devices.

Fix this by printing the features also for ATAPI devices.

Before changes:
ata1.00: ATAPI: Slimtype DVD A  DU8AESH, 6C2M, max UDMA/133

After changes:
ata1.00: ATAPI: Slimtype DVD A  DU8AESH, 6C2M, max UDMA/133
ata1.00: Features: Dev-Attention HIPM DIPM

Fixes: d633b8a702ab ("libata: print feature list on device scan")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Tested-by: Wolf <wolf@yoxt.cc>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 3fb7f7a5181a9..96b13b89f0a73 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2884,6 +2884,9 @@ int ata_dev_configure(struct ata_device *dev)
 				     dma_dir_string);
 
 		ata_dev_config_lpm(dev);
+
+		if (print_info)
+			ata_dev_print_features(dev);
 	}
 
 	/* determine max_sectors */
-- 
2.51.0



