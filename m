Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDE323D7EC
	for <patches@lists.linux.dev>; Thu, 28 Aug 2025 22:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756421618; cv=none; b=NmYuh4R7WVf83X9LuHs8oBBi/mKJcIgjS10xOC002Qta/lxF6i1bLPqF8pRgOjfC1BPGUjCVkIPvVytQmUdMGv4HY027aec8BfpJj2FAFCo3obnNXfuzO9djVflkPJuWxtlMmgswcgxMiGsGAogMWXqbIqGqP4RLLdNH5proNNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756421618; c=relaxed/simple;
	bh=bRiDCfz0S+U/QPTf4FoEVSczI7dQRwbekvj4mVUeptw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgThpnBrDAzTrlcEI9XNF389IrgnGcP76QzFpMX7HnhQUdlOfiGjSVJ70hR15fpdg7M1UwsjQjBdqccA9QQymKr8vrnZUwsj3I3WdOjMhuTacAGL6MmrOyyXwFIH/EJBb8Ix2/IIoH1yxLhfQPP4l/Xdgk9KuO8yFgQqDmGsGhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lY3RW1nv; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lY3RW1nv"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SLV63b024128;
	Thu, 28 Aug 2025 22:53:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=bRiDC
	fz0S+U/QPTf4FoEVSczI7dQRwbekvj4mVUeptw=; b=lY3RW1nv7XZvNcZCb4zQs
	r9BiJif5tOVo/uzCY9g6RDdqMntKqY94abDn17jD6rR+tRUYOvH0DXhMIY9d8DnD
	QAF9wsggBsulOBdiecnEDM3N9QkCHb4dNxtt8aoiMPcCWTAlT6d73ECxd0eRzBx2
	VD9/aT+fR9w5aTdcyBwm4R3a2fRkHCq/9ni1LJQubmJ9StpRulXsmoM0aygoWMs3
	T9ac5VaJdC8jaB5r3YmYSIzrbwdQuMHFO8KJsx+D4J9quPAZ3lZ6cZaBF1rzTwva
	SclK6UcpkS9h0P55Cgg3yQc5YZwEvADIsS3qOyku7F9yKIDYQktwdX8fNsCBj3YP
	Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q42t9c22-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 22:53:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SLoqcR012131;
	Thu, 28 Aug 2025 22:53:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q43cf9d2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 22:53:25 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 57SMrPPk008159;
	Thu, 28 Aug 2025 22:53:25 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48q43cf9cp-1;
	Thu, 28 Aug 2025 22:53:25 +0000
From: Sherry Yang <sherry.yang@oracle.com>
To: gregkh@linuxfoundation.org
Cc: johannes.berg@intel.com, patches@lists.linux.dev, repk@triplefau.lt,
        sashal@kernel.org, stable@vger.kernel.org, sherry.yang@oracle.com
Subject: Re: [PATCH 5.4 098/403] Reapply "wifi: mac80211: Update skbs control block key in ieee80211_tx_dequeue()"
Date: Thu, 28 Aug 2025 15:53:23 -0700
Message-ID: <20250828225323.725505-1-sherry.yang@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110909.381604948@linuxfoundation.org>
References: <20250826110909.381604948@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 mlxlogscore=632 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508280191
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxMyBTYWx0ZWRfX9RCrHox5HDeb
 arWfj/IXaqdra3rbcO3mRXu0V0aydZmSdFZypgGDZMrH15+iD41VPAeYJfeqMInISBjcQRGIaTq
 3tGz0mpbgk4OUfV7F6OPI3yRsrduoHYZ4aiYWDA9cHkMpFWyVzrzqE6WK1FUyD+Y2X3qT72fP5v
 6F9bDi3J5lEd975GJ95Sj3zaw4wDhkxNwx7vOBov1765XK77Aj+Z0VRlXIhZcriEjYdtG1pS/Qr
 fXvBckwNBYFsTrH//47/CeQpoylSVsnc9BE9/gJXiLpK6cO3dY/6TIzmcmIb4DByPg5LbHohH35
 za8c3Vfgf03DpU08EUDU14JRRsKpUq4b1B7+12HkG0QSlO6B8Ptodg9JIbhGhjurPjKxfEpsFVM
 dbFUXkfqE/pB5D2ndSjbX6+xPBQg+g==
X-Proofpoint-ORIG-GUID: vQigp2RMFE0UusNMNVYTwLKfGw0zpDOU
X-Authority-Analysis: v=2.4 cv=RqfFLDmK c=1 sm=1 tr=0 ts=68b0dde6 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=5S4kX0IQPxXMa9SJivYA:9 cc=ntf
 awl=host:12069
X-Proofpoint-GUID: vQigp2RMFE0UusNMNVYTwLKfGw0zpDOU

Hi Greg,

I noticed that only [PATCH 2/2] from the series

[PATCH wireless 0/2] Fix ieee80211_tx_h_select_key() for 802.11 encaps offloading [1]

was backported to 5.4-stable, while [PATCH 1/2] is missing.

It looks like the 1st patch is the prerequisite patch to apply the 2nd patch.

[1] https://lore.kernel.org/all/cover.1752765971.git.repk@triplefau.lt/

Thanks,
Sherry
