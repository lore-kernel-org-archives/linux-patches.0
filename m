Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA50F1A0BFD;
	Sun,  7 Sep 2025 20:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277223; cv=none; b=B4GIyBiMCLBmN4qhuR3jacUZivREyKDSRIOnnuhToPlUqJXY4qAwSwyaAHTzFyAmIWO29cLApcbzlfe3rmmIjyxh8s3t/5of0H3VSTzBy7G6E+xWCThN5/15vMPJvU2hJyyuPExFMmq/ygLiYc+K3rlNacttdRSXcrnqjdnkhBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277223; c=relaxed/simple;
	bh=wUSwxsLWlSsLw4XIgDVq+YuLUnkp/xkyTs7gLNF+BeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GVRnSj/qMxk8A1TkvnS9rLT8Jl2KfpsRWfYFZiVjS+uevqq+QRmnZ09bpRBUCo6cipwH8OCfzeznI+3ZnyBFCQ4i2eWofcR3J7Ox4I7DU2Tix/GRBfqlNyswO59qrFO0B1YkzD+SSzjhpTk71pQH4uXizm0zSbYr09TX2gJFaKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TC6A3FyZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TC6A3FyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A43AC4CEF0;
	Sun,  7 Sep 2025 20:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277223;
	bh=wUSwxsLWlSsLw4XIgDVq+YuLUnkp/xkyTs7gLNF+BeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TC6A3FyZA3ZBc4Tpcr8tFkTq5ceBUX4hkUSqG4igVKPrE4CJ6xwrOMSg36JpvVIvR
	 dBv4ET36mK6BZzZKdvJ0tdBST8obb9AhAJJpZFqxJus5Aez1lLJHk9Q+aWSwNq4Y9z
	 JlLjm2aJTj/xW7KRm04S3R4lOl7JXDEPnKpkSKh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	stable@kernel.org,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 122/175] microchip: lan865x: Fix LAN8651 autoloading
Date: Sun,  7 Sep 2025 21:58:37 +0200
Message-ID: <20250907195617.744404176@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

From: Stefan Wahren <wahrenst@gmx.net>

commit ca47c44d36a9ad3268d17f89789104a471c07f81 upstream.

Add missing IDs for LAN8651 devices, which are also defined in the
DT bindings.

Fixes: 5cd2340cb6a3 ("microchip: lan865x: add driver support for Microchip's LAN865X MAC-PHY")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Cc: stable@kernel.org
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20250827115341.34608-4-wahrenst@gmx.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microchip/lan865x/lan865x.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan865x/lan865x.c b/drivers/net/ethernet/microchip/lan865x/lan865x.c
index 9d94c8fb8b91..79b800d2b72c 100644
--- a/drivers/net/ethernet/microchip/lan865x/lan865x.c
+++ b/drivers/net/ethernet/microchip/lan865x/lan865x.c
@@ -425,12 +425,14 @@ static void lan865x_remove(struct spi_device *spi)
 
 static const struct spi_device_id lan865x_ids[] = {
 	{ .name = "lan8650" },
+	{ .name = "lan8651" },
 	{},
 };
 MODULE_DEVICE_TABLE(spi, lan865x_ids);
 
 static const struct of_device_id lan865x_dt_ids[] = {
 	{ .compatible = "microchip,lan8650" },
+	{ .compatible = "microchip,lan8651" },
 	{ /* Sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, lan865x_dt_ids);
-- 
2.51.0



