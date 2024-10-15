Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4251684A3;
	Tue, 15 Oct 2024 11:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992227; cv=none; b=pT1eugORO2gGtDSvN5Avpz1Ar/qEdHxCRJwZAkTXe15YSO1sAEHmFPrlWdsG7wfpn3qauUWNxtQUoEgFz/NYQ8n6c2ovHhG9qX/mPH35DZKMjvDBtmSsKR7Erzm1Mn+DfV9Q4TOcnqhqKE3Xw4a6zC8Ax1bX5wu1NSWvmlZV71A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992227; c=relaxed/simple;
	bh=sV0av/XoJqeeLO99F3ZEaQIpAbZpTzSF6uGgGp2jofg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hYFy6UGZ1PKcYoO+nsBIfch7/+PTw3ruMuIczxZ+TLEKwQNKbo127ukrGIYZJvQDD1jnomhKaw3DWNDY6WsDkJEQW30CqzPRgUfHERCj6teIRpzyjZkMJMqXHZvVvxtWnJlnjn7GAr/0MIFvntKpu1ydIKZeNeqCJNcl4+E4nTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cUDkTmqZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cUDkTmqZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4449FC4CEC6;
	Tue, 15 Oct 2024 11:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992227;
	bh=sV0av/XoJqeeLO99F3ZEaQIpAbZpTzSF6uGgGp2jofg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cUDkTmqZ8oc+CGgWYwxNktO8qvAcI4FIvlov7jMX07RZHESibpawiXfnfZ3R7Oa8l
	 pD+bK0uQvs3uhxiwtzhYf3h0n3bRA0GOzG3IyRVWeQnKlF24c80lMNXKiLI6COqU/c
	 tODkrPx/5Ir8cHEe86iWQ5uxpRixn5Xp8vOFseXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 056/691] soundwire: stream: Revert "soundwire: stream: fix programming slave ports for non-continous port maps"
Date: Tue, 15 Oct 2024 13:20:04 +0200
Message-ID: <20241015112442.577417593@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1445,18 +1445,18 @@ struct sdw_dpn_prop *sdw_get_slave_dpn_p
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


