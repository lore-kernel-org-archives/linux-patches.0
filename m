Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED891DF73B;
	Wed,  6 Nov 2024 12:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894907; cv=none; b=aH+ViBAz4DWWaDXNQeIBdAjq8RduwryPEIOzT7arJl1LlUSuvQt2ma6/LGR7jW/xV6e81+ZKQNDhOQJErlIxa1+uSsVslqhcWmWKeGL1ZLyVP2PEFexb+qQdWziDY/LLL/Hcvn720WXZv4GKW62KKqzoUD/3zdNNs0QWTVZXJLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894907; c=relaxed/simple;
	bh=P9EmB/CixudQDHyfpLj1yOgnGHa8bZq6tDf5CwMpzhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RnT4FhzJ2kyJuwrmLz3J7FOG95Y5AD1DwfZNs07Nf68KEv87HH8dGXOZwSTjqhJoCV2p03Pt8wf4NrIWO2ii905LR24BPcTJV067Wiv2p3Yeo9GSEgLP8l4fWn8MIVshXHMkH6yucP3gL2B72g3NEVKehHIpX/hazGJInsftTEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RONPAWWj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RONPAWWj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F85EC4CECD;
	Wed,  6 Nov 2024 12:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894906;
	bh=P9EmB/CixudQDHyfpLj1yOgnGHa8bZq6tDf5CwMpzhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RONPAWWjb1W0wLJUZSNBjDfhHmxFf4tpDmJpAFaAjEhmVSP86YFIjRUWMv/B+pj/H
	 v0nVtY3O6loGf6A/yrab+JVfiPdklMEKKViqbw6kMIehSz1SGqkwMUBCeIuWaH4/FP
	 p/S8432YHFnl7PzvaKdD3H6on1GhaQb+quE+kRac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 4.19 012/350] soundwire: stream: Revert "soundwire: stream: fix programming slave ports for non-continous port maps"
Date: Wed,  6 Nov 2024 12:59:00 +0100
Message-ID: <20241106120321.175334558@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 233a95fd574fde1c375c486540a90304a2d2d49f upstream.

This reverts commit ab8d66d132bc8f1992d3eb6cab8d32dda6733c84 because it
breaks codecs using non-continuous masks in source and sink ports.  The
commit missed the point that port numbers are not used as indices for
iterating over prop.sink_ports or prop.source_ports.

Soundwire core and existing codecs expect that the array passed as
prop.sink_ports and prop.source_ports is continuous.  The port mask still
might be non-continuous, but that's unrelated.

Reported-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Closes: https://lore.kernel.org/all/b6c75eee-761d-44c8-8413-2a5b34ee2f98@linux.intel.com/
Fixes: ab8d66d132bc ("soundwire: stream: fix programming slave ports for non-continous port maps")
Acked-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Tested-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20240909164746.136629-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soundwire/stream.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/soundwire/stream.c
+++ b/drivers/soundwire/stream.c
@@ -1232,18 +1232,18 @@ struct sdw_dpn_prop *sdw_get_slave_dpn_p
 				unsigned int port_num)
 {
 	struct sdw_dpn_prop *dpn_prop;
-	unsigned long mask;
+	u8 num_ports;
 	int i;
 
 	if (direction == SDW_DATA_DIR_TX) {
-		mask = slave->prop.source_ports;
+		num_ports = hweight32(slave->prop.source_ports);
 		dpn_prop = slave->prop.src_dpn_prop;
 	} else {
-		mask = slave->prop.sink_ports;
+		num_ports = hweight32(slave->prop.sink_ports);
 		dpn_prop = slave->prop.sink_dpn_prop;
 	}
 
-	for_each_set_bit(i, &mask, 32) {
+	for (i = 0; i < num_ports; i++) {
 		if (dpn_prop[i].num == port_num)
 			return &dpn_prop[i];
 	}


