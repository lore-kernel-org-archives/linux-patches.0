Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844E914AD19;
	Mon, 16 Sep 2024 12:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488088; cv=none; b=dPfn9GXo60V7Sv5/UU9liWomr4XwaZeerN8EKM9QceJgUhMcBdlrVioLvqlEh3MaoAs+MAz8YOUfZhlOVmdx2m05eyZpw0c3rt9dDouqgWPuYjzqdZxwc/DWRtVPN84dK4UgXMZSrbW45pMjSqe9byaytoKAH0gUkangEyDiNpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488088; c=relaxed/simple;
	bh=sMJgYUBRtTBorl+awTEn/9CJ0yqriJ96nxu2NgJ9cCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRxeRURZ031mxrBEioP/PX8as0EEqbAjdjLZ5FWFsRk9sR1kWwwmxyJRwtLK38LetIOVl7ysUbUnlo+fAnSwMtYr+fFz7+4IHOP/l4eFnBpC/uzlcyd8PJmx64ZADv+RlrB9Ho8ubW8fATmEYAT9qTOGfuX6sEOXTSAYj8f2S7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pmDjSMRr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pmDjSMRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F85C4CEC4;
	Mon, 16 Sep 2024 12:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488088;
	bh=sMJgYUBRtTBorl+awTEn/9CJ0yqriJ96nxu2NgJ9cCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pmDjSMRr4kWOSA/torxxVDtAVC/cdT94CmEHvbwJNAJphSJnW5SQllgeY2RFbkXjM
	 589iHMM4J3RsEY2qhPmxxzOAPHxBi9JUVtJGHKxaLKsDb5NsTtLR7Ax08bWA4Ikpdr
	 5nuGVZhVkcqs+aQfBu1yN6LWHs7b/4kAQjdY604E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 55/63] soundwire: stream: Revert "soundwire: stream: fix programming slave ports for non-continous port maps"
Date: Mon, 16 Sep 2024 13:44:34 +0200
Message-ID: <20240916114223.004014441@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
References: <20240916114221.021192667@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1272,18 +1272,18 @@ struct sdw_dpn_prop *sdw_get_slave_dpn_p
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


