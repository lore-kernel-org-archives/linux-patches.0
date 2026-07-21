Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D53269D18;
	Tue, 21 Jul 2026 18:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660075; cv=none; b=oj9qCihVdN7Et1dZ9s8LARhYgAdqOf3aTs8BOSmL0xm+QQ0DXseBX4wLwYvktnIbG5f5QJGBi8w8ABZjeqDO8BPyZ9QusaCaYgGvpsvWmpsnZZG8RTMxNiTVV6gn0wq/nqkAvDqP+/1yRWwfOcLETvlWqpZ4SZCdPzwYF4Y9LU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660075; c=relaxed/simple;
	bh=ikPbEgBQsVwZjLRdr+xgrOteq5KGcDQOixgHUmc55lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G8fC4DKfp/OWN9Z5Hswto5DwmBoCifqEqYjN2ThFSRV9jViBge9jCsLbHSBuXYbN2mIjK6j3NGLdg4oxn2/I+nPQY/bpJRRPTHaibP24jUgALYSFsvM6v76+r0nKPOXgWod+DyEuSoRsvZC/IZwiTZtHVletK6Zc1FPLjb8jo4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IIXyzYoh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IIXyzYoh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD6801F000E9;
	Tue, 21 Jul 2026 18:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660074;
	bh=xoj5tE+wegdm3JZazX9TMoHhnpY4YCHZvfxQzLpGth0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IIXyzYohe+X+yc99OgW5rNMsJOexl0aQvkoLT1oPM7FHZTpQUB6JFrVfZadb5rCgy
	 wCMYZ5+nanFdfdsk3IHzTofMTyQ7r3afq0YDoA1RDA6P1sw/zybnTAaQVe9jrWAskO
	 wGqyUIoYzOFb9iluZRGDbKGqujYf3KRcIM0q3JTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Simon Trimmer <simont@opensource.cirrus.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0843/2077] soundwire: dont program SDW_SCP_BUSCLOCK_SCALE on a unattached Peripheral
Date: Tue, 21 Jul 2026 17:08:36 +0200
Message-ID: <20260721152612.675595708@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit c368dd5cbd61ffab2b6f8a89b0d5775e2e16cde6 ]

The SDW_SCP_BUSCLOCK_SCALE register will be programmed when the
Peripheral is attached. We can and should skip programming the
SDW_SCP_BUSCLOCK_SCALE register when the Peripheral is unattached.

Fixes: 645291cfe5e5 ("Soundwire: stream: program BUSCLOCK_SCALE")
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Simon Trimmer <simont@opensource.cirrus.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://patch.msgid.link/20260428084612.322701-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/stream.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/soundwire/stream.c b/drivers/soundwire/stream.c
index 4ed8fb7663ad40..0b96268380283e 100644
--- a/drivers/soundwire/stream.c
+++ b/drivers/soundwire/stream.c
@@ -697,6 +697,13 @@ static int sdw_program_params(struct sdw_bus *bus, bool prepare)
 		if (scale_index < 0)
 			return scale_index;
 
+		/* Skip the unattached Peripherals */
+		if (!completion_done(&slave->enumeration_complete)) {
+			dev_warn(&slave->dev,
+				 "Not enumerated, skip programming BUSCLOCK_SCALE\n");
+			continue;
+		}
+
 		ret = sdw_write_no_pm(slave, addr1, scale_index);
 		if (ret < 0) {
 			dev_err(&slave->dev, "SDW_SCP_BUSCLOCK_SCALE register write failed\n");
-- 
2.53.0



