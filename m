Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A8A79C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:24:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A48C433F1;
	Thu, 12 Jan 2023 14:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533496;
	bh=4jd6ruqudRD1vVIEqiyuBp9dASpT91D9wpGVIY+UDhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OSVMCbDUMWj6m5jyvjQi1tqXp/E5wqBtWRpt/w0iKSRe/+p1a1VvNHtc0K3BTVovz
	 9IQIqvIVQuozE4vw9FleAiFP9VIckcqxQjo3Iqq2lhr155RQB6V4JX4UWFdg5/6RRt
	 ACDTjtkh5PJ33GtdNAUXzi8w/z8/HcBJyK2gdW34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 470/783] igc: Add checking for basetime less than zero
Date: Thu, 12 Jan 2023 14:53:06 +0100
Message-Id: <20230112135546.012627654@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>

[ Upstream commit 3b61764fb49a6e147ac90d71dccdddc9d5508ba1 ]

Using the tc qdisc command, the user can set basetime to any value.
Checking should be done on the driver's side to prevent registering
basetime values that are less than zero.

Fixes: ec50a9d437f0 ("igc: Add support for taprio offloading")
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index f4082ea7beaa..45069dc0ccc6 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4912,6 +4912,9 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 		return 0;
 	}
 
+	if (qopt->base_time < 0)
+		return -ERANGE;
+
 	if (adapter->base_time)
 		return -EALREADY;
 
-- 
2.35.1



