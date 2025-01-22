Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED621C3C1A;
	Wed, 22 Jan 2025 23:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737588575; cv=none; b=VNJkQC3TMyZjYyNBpTQ4eYEc0H4IOFvfwei+C3E7GuxZYj527JUq03WsCPY3L8nm8P7hX6geSCup+zYnqf6Bnx91arVpt1ImV5zfdPaX4q7wrziKLqnbKMjLwjGAbOAy2I5sU00dgHGSkbM5XBfQFB7EbcKnbKEN55BOo+VZScE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737588575; c=relaxed/simple;
	bh=KPLA+ozFyStNyDu5+oahWKpg/XxYALlOC+cMlOAhVF0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Uw2nWTvbkqEcfMlSroQwcuhAmYw5aBPQGiua0GFWz6szi8IfhLz0vWFBv5UemQB2Fa8v09a+bt6pwX8/2fCmn2PcjpPfgCNeOizb0YSzyegimmaUt6vAGzKhLcgfVN2gvrglL6Ckn3gbxvq36axzrgdRWimugua+EnO3mPVk8qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=JEU3VOkb; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="JEU3VOkb"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50MKEfjS004149;
	Wed, 22 Jan 2025 23:29:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	zeAtijeaCJ4ez21C9cUIRbkYnE5HuPpu9Z84QgSRD7E=; b=JEU3VOkbC/aeHZwB
	Z05kLF9msPsptf4++vzqB6aNMTTufO/DhmZvqZfJdeEcupx7KXTNIna+d61LGm32
	HWqUkZFExMzztZwPCZPf3Ya4eyCn2oVhF6utQXfFyRquYXglLShh09Cmg6Yo5cKk
	2xP85LQo+PGqKz4Z7v0lTjIH5dsAPvPxjTVqARqPxH4+/puu76HmrDQFLt+mWaPU
	GBkKRB/3O0sNtepA1fNmY0azcFWuni/Y1EkRZjav9uJ77nLLjbKA3tF9byG4gE/D
	SI8kj3dCjWn0q1anE/PD5tC0Aem+a5hXgEWFIScRn0ERv0RKNggVO99YaCVjJ5or
	wLoKsw==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 44b7ht0a02-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 23:29:30 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA05.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 50MNTTbu015529
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 23:29:29 GMT
Received: from [10.81.24.74] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Wed, 22 Jan
 2025 15:29:28 -0800
Message-ID: <99de1bb7-0a6b-4965-b913-e0ec6e428477@quicinc.com>
Date: Wed, 22 Jan 2025 15:29:28 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] clk: Make debugfs code into a loadable kernel module
To: Stephen Boyd <sboyd@kernel.org>,
        Michael Turquette
	<mturquette@baylibre.com>
CC: <linux-kernel@vger.kernel.org>, <linux-clk@vger.kernel.org>,
        <patches@lists.linux.dev>
References: <20250108005854.2973184-1-sboyd@kernel.org>
 <20250108005854.2973184-5-sboyd@kernel.org>
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Content-Language: en-US
In-Reply-To: <20250108005854.2973184-5-sboyd@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: uE5tYn9tBRyrLeQcfOwlgnaj8IZ4pEnL
X-Proofpoint-GUID: uE5tYn9tBRyrLeQcfOwlgnaj8IZ4pEnL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-22_10,2025-01-22_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 spamscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 phishscore=0 priorityscore=1501 mlxlogscore=737
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501220170

On 1/7/25 16:58, Stephen Boyd wrote:
> Split the debugfs code for the clk framework into a separate loadable
> kernel module. This allows the debugfs code to be loaded later, or not
> at all.
> 
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>

...

> +MODULE_LICENSE("GPL");

Since commit 1fffe7a34c89 ("script: modpost: emit a warning when the
description is missing"), a module without a MODULE_DESCRIPTION() will
result in a warning with make W=1. Please add a MODULE_DESCRIPTION()
to avoid this warning.

