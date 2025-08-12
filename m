Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686842FF167;
	Tue, 12 Aug 2025 18:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024311; cv=none; b=pw3Dgr390cFzZUg9/2Phej3unFxkLjm9XQgFseXZtuoB04ynpfY+z8GXByV1zbxzn6VqpO31uoCLB9Fjz4XN61fybVf0fcSbHQ3Zi4DeaA79A46FqDvpiYk6nVwGiAUlQAJx1QQ/hteVDknW+l8PQBkLm3JtSzkhZR+Jc6fLtWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024311; c=relaxed/simple;
	bh=cl96HL/4sSGMvvsAsedsrL36YEPVmWBj3y0b/9F9cEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kC/LDKRD285nSX387iLTguQaQpqKftbj7JjUtbD/RWuI3GhRwMEDDqpMloOATwrfWbZTrW825AlKgHLscayc/h8cTvDjxeQrlh6Ix9c2xXvG9AIRoFIQBob3BJ+UfU370Z23WaUbHgfYlSXM78IjNWmZuy7KoGwNJIMJFBdHyyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eMm3iAhi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eMm3iAhi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC56C4CEF1;
	Tue, 12 Aug 2025 18:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024311;
	bh=cl96HL/4sSGMvvsAsedsrL36YEPVmWBj3y0b/9F9cEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eMm3iAhiPeB9L1qyeXoABCljxfE4A5lOqlcpF6h1F6GwmhVzWU8dVeaOAShUrnrqq
	 WmV656gc+ZB4E6JhblLovCBfSN76z1a0QB+wizC0BiuxLBUHUN1DYwQrc0Gaq38AVK
	 2nIjaRhBrGqPf0Dqz+T5xqMKeNQU1DtGPp7CLJ3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 335/627] soundwire: Correct some property names
Date: Tue, 12 Aug 2025 19:30:30 +0200
Message-ID: <20250812173432.031442855@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit ae6a0f5b8a5b0ca2e4bf1c0380267ad83aca8401 ]

The DisCo properties should be mipi-sdw-paging-supported and
mipi-sdw-bank-delay-supported, with an 'ed' on the end. Correct the
property names used in sdw_slave_read_prop().

The internal flag bank_delay_support is currently unimplemented, so that
being read wrong does not currently affect anything. The two existing
users for this helper and the paging_support flag rt1320-sdw.c and
rt721-sdca-sdw.c both manually set the flag in their slave properties,
thus are not affected by this bug either.

Fixes: 56d4fe31af77 ("soundwire: Add MIPI DisCo property helpers")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20250624125507.2866346-1-ckeepax@opensource.cirrus.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/mipi_disco.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soundwire/mipi_disco.c b/drivers/soundwire/mipi_disco.c
index 65afb28ef8fa..c69b78cd0b62 100644
--- a/drivers/soundwire/mipi_disco.c
+++ b/drivers/soundwire/mipi_disco.c
@@ -451,10 +451,10 @@ int sdw_slave_read_prop(struct sdw_slave *slave)
 			"mipi-sdw-highPHY-capable");
 
 	prop->paging_support = mipi_device_property_read_bool(dev,
-			"mipi-sdw-paging-support");
+			"mipi-sdw-paging-supported");
 
 	prop->bank_delay_support = mipi_device_property_read_bool(dev,
-			"mipi-sdw-bank-delay-support");
+			"mipi-sdw-bank-delay-supported");
 
 	device_property_read_u32(dev,
 			"mipi-sdw-port15-read-behavior", &prop->p15_behave);
-- 
2.39.5



