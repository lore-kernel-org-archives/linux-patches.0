Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA92C515968;
	Thu, 17 Sep 2026 16:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664107; cv=none; b=LAqFDYt5pL2t4h32vFHv4nzpT72UwjkG0PnLh/YDZ1pLszuog4ijN1Sn+cdrLEMsKFGVZFPW421coR12txpXj2SONMBziSsvs/JQLRA919yAab+1ko81nwtzhmo0OQRLajppOzZnw1/q7vE4Po7BmSAwXOR8E6uCg9DZax1ZI+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664107; c=relaxed/simple;
	bh=3DSeFSoXnd+x1P5kDzwtgsTQSGNK8xE9IXkSXCcAOm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rN7qsHqxV3o/CmaQ/fo9QedhMPJ3EhXyypcDrj1Mxa+2OK/tUqgR0wk05feNG9n+jq9JkcPa3JTvBHiSlZAknrJyEK1KXYgxnv4lybBzT4xcbl6KYdv6PLqx79E/I7dzqi2muPMoEjwCtNMJBbUG8mTqMl/VQTKfB/QGvvWrt94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JRkP3F0v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JRkP3F0v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E081F000FF;
	Thu, 17 Sep 2026 16:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664105;
	bh=2R6iVN2FDi5ef04gCCvwfGCm1rav79t2ZbHce8yuTe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JRkP3F0v9HrGnryXrr5QA3G6uksTBGesj53iO8tqZel7AO9Ozj6pncPV51rHRIJL/
	 WBvI3wu/fC1p8AHk/pCt4z4sao8CMtewHlbNUazD+XuGT2/y9QYZhb2TgyCnsVWjRx
	 3EskFTnbnJuxYv28jG6dz0piyjC3Vog6iEQT79yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0262/1250] soundwire: only handle alert events when the peripheral is attached
Date: Thu, 17 Sep 2026 16:00:57 +0100
Message-ID: <20260917151559.251310418@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 38cd651ebce7065a81c7e950d9e2ea1572304605 ]

It doesn't make sense to handle an alert event when the peripheral is
not attached. The slave->status could be SDW_SLAVE_ATTACHED or
SDW_SLAVE_ALERT when it is attached on the bus.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20260520025720.1999367-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/bus.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/soundwire/bus.c b/drivers/soundwire/bus.c
index 45d786f379d84..b23a224f7a1ff 100644
--- a/drivers/soundwire/bus.c
+++ b/drivers/soundwire/bus.c
@@ -1989,6 +1989,10 @@ int sdw_handle_slave_status(struct sdw_bus *bus,
 			break;
 
 		case SDW_SLAVE_ALERT:
+			if (slave->status != SDW_SLAVE_ATTACHED &&
+			    slave->status != SDW_SLAVE_ALERT)
+				continue;
+
 			ret = sdw_handle_slave_alerts(slave);
 			if (ret < 0)
 				dev_err(&slave->dev,
-- 
2.53.0



