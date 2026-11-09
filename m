Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.162.57
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794244521;
	b=O9mGwscipFHXx3fDQkEvz+y64LhSi7q79dT2Bp+eZeKWhquQkfcRzXHIcKwjYX6jV+Ne
	 1ZzC4tGhAArQuHU98TrlpEAO02hXw65TQzlEVm6ycT/xPIAHFvUsErXlP9Qzf4woRcl2o
	 8yyz9UGR6/qofxgOY96vTGKjMyX8XKQPyCL8lrimBzeRCiPqb1B+HM+YVuFFpZbgg7T84
	 gTpFqnf/7PoM9zv68BbFVTVVuoYP3ohyYZrxVEHTTKztJbARMesw7de+ghSow3i2g8Z4a
	 BWBkF13A7etnhZgZTH+wzKsU4Mr2gNzyOREAOS96k9/jNli0Ow3dnudNOGebam0MQsw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794244521;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-Originating-IP:X-ClientProxiedBy:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=0IMeLB1dRvtT+Gu7UebExq027PIbf1THrmDYlH4ys4c=;
	b=d/K3/iWh3lFxSYVWbacDUTC0L7fzja8bPJLX3KXn2rLEefuDHi597KCkhpzLPCEmSD9j
	 LYJLdb0Ajeh8o4hLJeMVXrJ/INR1JzDYoIWkl5osJK4F6HdK9MXPc/xFWg6EvvimGesuh
	 3dZbX7iDC7Nx4vJQRBvgI7TbydTgGO0PK7R4gGgryeSQ1urynsznkrdByqj8Uxr+SvHyZ
	 mra6qxVIymAonA5QRlGGxdCDyXYH3DvjnjzxNSt62R0gsckXpsGgzF+uANYtGculueYpd
	 Z+BwnHa1eAKg7JD3m8cEH/kHb2RWnIxeShpgPnMBHygxcSOSfv1hMI49qnCIUThxxYQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=foss.st.com;
	spf=pass smtp.mailfrom=foss.st.com;
	dkim=pass header.d=foss.st.com header.i=@foss.st.com header.a=rsa-sha256 header.s=selector2 header.b=HlpyJv9C;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.162.57
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013057.outbound.protection.outlook.com [40.107.162.57])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFDB606A31C
	for <patches@lists.linux.dev>; Mon,  9 Nov 2026 17:15:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DDFDB606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.st.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.st.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=foss.st.com header.i=@foss.st.com header.a=rsa-sha256 header.s=selector2 header.b=HlpyJv9C
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fRqgl46EiX7tUsfNgL8n49O4+GEQili33pbxTuSIZNfObKG4WiyTjFOt6fWld2957hZZ+GJLz2XLH7vNAresVw8hrMna4qKNDVGYGtEy4gO8NdBYrZsXvOlHcAn8PLu1JM0V5dapS44mH3nSeLOx+cLn2EWGCNqZgHik4yYT2QE1LgWTNEgvjcG2dR52/V+uRPT0STKV+JLLXVGV1zAKKBQ94QpfCydL9QfG24OCoAeiQfc+BNSWmoP8fvWLRpzNx2lSElz9fvoX4jKGqgCInYi7osU58wmpdO7mWRhtyuEwE7v/P1UGLZojGFdUjs5J5nsRIulJcoR8mXfFMo42rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0IMeLB1dRvtT+Gu7UebExq027PIbf1THrmDYlH4ys4c=;
 b=W1ooQZIkdtC0wpf29TWrVVdA+Xp25PBDRCk3mI2unjguDul4nOjAQmJZJFJd6kbfEpea6XhhqiNHgv8UJzi3lWdXi2P1yS9G1HAgWoiHeIDF6nVnRHDo2NIEqzTO3HhnyNQOblB+KvzgcatDvmBbBh5K1OfSYFzBT4RNAypWb+undRkpk8tPtCO879IytB72sroWdEFkTUEckFvFFmjAIgqS98m5jxqvryDK/MdIJTzl8JSjx5MucuAiET9PqKiMyLyfFbc28PhfFOdG/Vpy+649FVlgx8k1TLNmVNNk1fKCyLmdIydu5wXkurRJftqNszaBn8ztYRZpGCFzKeF5UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 164.130.1.60) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=foss.st.com; dmarc=fail (p=none sp=none pct=100) action=none
 header.from=foss.st.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0IMeLB1dRvtT+Gu7UebExq027PIbf1THrmDYlH4ys4c=;
 b=HlpyJv9Czsfu+WWA9evxz2/Ahw7U0zT8jqdg/ShY1DhyOKjn5p+Uz07Q+Zdtv6E/AIaNYzwhxlKbBZAmBOCnoQgxMcWBoLvSR361j+AhNKrrbm7mEEY3l9hgBXEF2Fyx2/Ja+fcC+Eb00AczspMfZzuDh91OnQGeTr+ob2+XTJoOyC2a5/yhZ+Xz2iY+oUOvS2jpd8gNoqC3g0ucxDsSuoTpjQ918FRMKoUp1hH4B1A35lPy5HC0DxscjDdT62jGiG32SF65HbPVZxK/In5+GagnWq07C+ZuwAo4ei8bV0JPUjBMY57PlRuxKDBEf0gcPA5xCRKMYrus6x3NAEmxwg==
Received: from PA7P264CA0095.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:348::6)
 by GV1PR10MB6660.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:150:86::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.7; Mon, 9 Nov 2026
 17:15:11 +0000
Received: from MI3PEPF00008490.eurprd03.prod.outlook.com
 (2603:10a6:102:348:cafe::24) by PA7P264CA0095.outlook.office365.com
 (2603:10a6:102:348::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.13 via Frontend Transport; Mon, 9
 Nov 2026 17:15:11 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=fail (sender IP
 is 164.130.1.60) smtp.mailfrom=foss.st.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=foss.st.com;
Received-SPF: Fail (protection.outlook.com: domain of foss.st.com does not
 designate 164.130.1.60 as permitted sender) receiver=protection.outlook.com;
 client-ip=164.130.1.60; helo=smtpO365.st.com;
Received: from smtpO365.st.com (164.130.1.60) by
 MI3PEPF00008490.mail.protection.outlook.com (10.167.240.151) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 9 Nov 2026 17:15:11 +0000
Received: from STKDAG1NODE2.st.com (10.75.128.133) by smtpO365.st.com
 (10.250.44.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 18:16:07 +0100
Received: from localhost (10.48.87.238) by STKDAG1NODE2.st.com (10.75.128.133)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Mon, 9 Nov
 2026 18:15:10 +0100
From: Valentin Caron <valentin.caron@foss.st.com>
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <Paschalis.Mpeis@arm.com>, <aaupov@meta.com>, <acme@redhat.com>,
	<corbet@lwn.net>, <irogers@google.com>, <james.clark@linaro.org>,
	<jolsa@kernel.org>, <leo.yan@arm.com>, <linux-doc@vger.kernel.org>,
	<mike.leach@arm.com>, <namhyung@kernel.org>, <patches@lists.linux.dev>,
	<robert.walker@arm.com>, <sashal@kernel.org>, <skhan@linuxfoundation.org>,
	<suzuki.poulose@arm.com>, <amelie.delaunay@foss.st.com>,
	<valentin.caron@foss.st.com>
Subject: [PATCH 6.6.y] perf cs-etm: fix a compilation issue in cs_etm_decoder__set_tid()
Date: Mon, 9 Nov 2026 18:14:57 +0100
Message-ID: <20261109171457.1233670-1-valentin.caron@foss.st.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260912065621.463708027@linuxfoundation.org>
References: <20260912065621.463708027@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: STKCAS1NODE1.st.com (10.75.128.134) To STKDAG1NODE2.st.com
 (10.75.128.133)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MI3PEPF00008490:EE_|GV1PR10MB6660:EE_
X-MS-Office365-Filtering-Correlation-Id: 568e8cb3-bb19-4e88-6392-08df3e85030e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700016|1800799024|23010399003|261009223027099003|261102123227099003|261028144727099003|261021121427099003|261021123027099003|261022105027099003|261026140227099003|11063799006|56012099006|6133799003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	pKgsyZ/GrPps3f7En5UekHdV76FXJ4qyboOHF+hd+e0fMkoXpGsm+JN1Acq7Xj3xcRZCwsgOhyLsaQLsa9lQPYP32OKRX0zWN9d7PWmBQkgocC8g8r/Dv12c7GNTeEiejO/S5efhXy9F5TzLyUI/jIdG28yXNxX7CN+f8k4e73DRh98vQK+1ttjv3ntEV+eqK+03OCLzbWjwLazbMV7YG41ZAS5pOJCQsn5N/gWp+UyMW8wfRE8uTMcpYRi/ATL0x5fd4A+5E0N8M3MDCnIvhbV8bA9h+jJomWaWBldqMcwGbdzMbtdKUOvwWdfzSkKOzI01OL1ppDgQA/fZhsKzr6O7DrWjrKlQMbEeavGgDJTYyP3HPKLgLYPr9YOHJ0/5R8MYd84P6tpwPijfdR+cntPeHqOKR6FxwNt2O5+V4HzZyGHalzZ7dBnW+mZunT0XBKxZ15LHP2HL5Ml9r+/ikJXpKyz7D/tlJzH7a9RamguOkwf1PkX6JOvjpdEwXEnXStPjurmb5MdFUvSNouORgM14hXjniu1Fs0Xlq5s2kpg4mmikJ01y7ajOVjhDfXD9CquxU/M0sKqmljqKHoOnrhbeE4RLE2wZEXgRzOYCBheM5b3nw8tRAZ/YspQ628RmJO2WR1f3rn8XfmGXCr/mKcK1QTHIVxVI8QoKlFVHDTAqIjPIt6z6WY9lTENK7K7Sz6xRSaGdAdYbwueDlu539Q==
X-Forefront-Antispam-Report:
	CIP:164.130.1.60;CTRY:IT;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:smtpO365.st.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700016)(1800799024)(23010399003)(261009223027099003)(261102123227099003)(261028144727099003)(261021121427099003)(261021123027099003)(261022105027099003)(261026140227099003)(11063799006)(56012099006)(6133799003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	TspQH7CsYYrqRHqZalDPPdGOrwyZL8ANpaQDHMXNXRnNd2s4LoBkp09bOkwr2jmeH9TzwH9KZy7MDb4Xerr5nTv4z3txlLrGUDPGEWFRQE1wKV7UIq2jl8YkAl/M/WLHaaWIB1UbFvv6OkQhvFNK3vWjornBfGV0P+5L1UngI1nUiPRn+3r+Qr8suwqpNax3fZy5b7shEhxPdxmNC6jf7MxH9rPa3TPkDg8J5Dak/rV8tgP9TrnGQtqCcp9qla4OktFq8KgmQkCvLNuM2xzhUbfJUs+MeDXvthy3nhhXfIMBcXR4WW+z7XVCHsfxgMmPv2Nm/2w8J2mSbTAcE48pXlnE23yp/7dueBX7XLjXPIozp+DGOJeh6OnZpgWT5znORzPkmimUEF34H40f9vZjrkJtdfJ0erBmKqNIFISOg9sbVvWeZpzoSc4aSH+bWXB9
X-OriginatorOrg: foss.st.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 17:15:11.2021
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 568e8cb3-bb19-4e88-6392-08df3e85030e
X-MS-Exchange-CrossTenant-Id: 75e027c9-20d5-47d5-b82f-77d7cd041e8f
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=75e027c9-20d5-47d5-b82f-77d7cd041e8f;Ip=[164.130.1.60];Helo=[smtpO365.st.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MI3PEPF00008490.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR10MB6660

When compiling coresight tool with the command:
make -C tools/perf CORESIGHT=1 all

The following build issue occurs:
util/cs-etm-decoder/cs-etm-decoder.c:551:15: error: too many arguments to
function 'cs_etm_decoder__buffer_packet'
  551 |         ret = cs_etm_decoder__buffer_packet(etmq, packet_queue,
      |               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fix this by removing the parameter "etmq" from function call to match its
declaration:
cs_etm_decoder__buffer_packet(struct cs_etm_packet_queue *packet_queue,
			      const u8 trace_chan_id,
			      enum cs_etm_sample_type sample_type)

Fixes: 99d324594165 ("perf cs-etm: Queue context packets for frontend")
Signed-off-by: Valentin Caron <valentin.caron@foss.st.com>
---
 tools/perf/util/cs-etm-decoder/cs-etm-decoder.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/cs-etm-decoder/cs-etm-decoder.c b/tools/perf/util/cs-etm-decoder/cs-etm-decoder.c
index 277da9f767b9d..caacab8c92e26 100644
--- a/tools/perf/util/cs-etm-decoder/cs-etm-decoder.c
+++ b/tools/perf/util/cs-etm-decoder/cs-etm-decoder.c
@@ -548,7 +548,7 @@ cs_etm_decoder__set_tid(struct cs_etm_queue *etmq,
 				elem->context.exception_level, tid))
 		return OCSD_RESP_FATAL_SYS_ERR;
 
-	ret = cs_etm_decoder__buffer_packet(etmq, packet_queue, trace_chan_id,
+	ret = cs_etm_decoder__buffer_packet(packet_queue, trace_chan_id,
 					    CS_ETM_CONTEXT);
 	if (ret != OCSD_RESP_CONT && ret != OCSD_RESP_WAIT)
 		return ret;
-- 
2.43.0

