Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA2835950
	for <patches@lists.linux.dev>; Fri,  8 Aug 2025 14:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754661728; cv=fail; b=f1QAwo2MKhQO9Fqm3KqhaTkkxS3ddpd45+i2x2wJkXTaCW89ecQQpoaCyXOjLm1v0CGOoI5QdN8OKGlb/tTnusNkY29FPjBPfJoYi70f2sH+TOzg0r1z6bg1BtTdv3tVjvl//JPzatfgdFKamJY/amnh5C7VjZGwIklpNzYR6QU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754661728; c=relaxed/simple;
	bh=whw11GcMQykdNAIR+WIDkyuAXJn3se0+ouZhy/gyxpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=K6MaNzn/NqrmXG97R2pv2DdGzdWPzYDDOvALCmBoO/g3qmnPBt3xRm4cVAXt+skAjlWvTnrngw0qh9XeMIH73tT4GgRgJ1M69tAOsniRl12d6h5q6jq+QIi7l/CgziO1w9h7E5/ul5TCV+3LL8SZ1wAOlAP2/9cckS/+o2opog8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pHtGB1P6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=L9Lrt7JI; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pHtGB1P6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="L9Lrt7JI"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 578DNUPr000798;
	Fri, 8 Aug 2025 14:02:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7sP0jMBC8wR8UiKVYn4X5565snoB67tNTQCNDynI8GY=; b=
	pHtGB1P6OLZn82c5Xtw90DEDZa9o/q2gwixwU4tlf7+YLG9o14x6eLi3yyehhOt0
	wmTMHJvY546qEmlBjhbBTfumTxY2yJjhj8GcZtnQTd96rfZXhdcJPBWZRiZorub8
	fjnMjN4ki3Kvnhr5FkpaBKse2KwAexp/c34rbbtnzDjkMo9zYqd5zmS4vQFXSenV
	QXc5kIpnJvhy9ZOMEtHxFvd7N7FgX3eHd7L2iJmA72+2uEK+631Q/ycW1dsBP6bT
	HeZg4OdCxnSKi/OOJmq5r5Kt2XzyBbSIt5+MLYXpPpZkp3ebNaAc9LKjHDmsBYPy
	41iWQQPNIWpKkF4Knxa8rQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpxy6gjc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Aug 2025 14:02:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 578CYfps027280;
	Fri, 8 Aug 2025 14:02:00 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2066.outbound.protection.outlook.com [40.107.237.66])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwqs7ff-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Aug 2025 14:02:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pRXQIrx8he4gOTDZtIxPCEKukvj/vGcX3vMHwuVB+RJXIVGAri4fWfWKzaZ3SU7DWzaI9YP2QQeY8X2pDv6AjrGSmfgebYGXpFVPRt0RX9IJpzCocSQ1rXRmcaNuqqKSj/7YkR9LmXx7W8LWc8quph0AlhDUBagwuiZY/btH6XyHztErLzon63XdQaKRC9LruoXPIeD9s/XYNJbHm1aHR2eVF2zYffvLST/r5YoAJyzk/Zcp4FaD9/KGGEcJm4OfAoSjHEaZmjlMTG3ZfW1TfgAj5UninuHNPiTzAn1G1hgSER25SO0rBD63M/7ZIeXGuBSFbJ0fYAne7EW+3cYFYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7sP0jMBC8wR8UiKVYn4X5565snoB67tNTQCNDynI8GY=;
 b=ajDuTrmytFShc8hBMGS9hIiDD4yjLE0kLEqlyB9XTEN49y6RMp3YcJzyjB/MJbuxhd+Y5nKT5OvRlmTLDe5uEzwVsRf42TXIlq6QaTlpJIz2DE0T7irjnNAeRt/IGj+eZZlMtqhn4/d4kEd245rWOlb8dgdd2AHt8J3onFjUXTPpBEFmBWkM/Ipk/6gaeNGGvf1yqhdFICaRtj3IdDQWAs+FscWmTyTisNCAzUG3JvatnkHLOwwEBNrg/P6/ebvMk1W4RsshChZ1mAUsukR4Xo1Tq1bC5w3FGm70Awj7X8YpVY4tzJ1etcyyhYLdO6ZsRGdJYj47jlI3BTdhJNXISw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7sP0jMBC8wR8UiKVYn4X5565snoB67tNTQCNDynI8GY=;
 b=L9Lrt7JISc6Fyo/BYtI8+YgPcysCDAvNR2sUjF/c337b/bY7rxoakXNMpnbouyiXUUI70SW9q2mXhWmfncxejogxln6+k5enO/w5ogScw7mWSYkT+CsoKi5LeVqhpgy3A8rrMp2in9wkScsEaDsccGWDd/GWTvPGX1B0fZnt1X4=
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DS0PR10MB8149.namprd10.prod.outlook.com (2603:10b6:8:1ff::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.14; Fri, 8 Aug 2025 14:01:56 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::156d:21a:f8c6:ae17]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::156d:21a:f8c6:ae17%7]) with mapi id 15.20.9009.016; Fri, 8 Aug 2025
 14:01:56 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc: gerrard.tai@starlabs.sg, horms@kernel.org, jhs@mojatatu.com,
        pabeni@redhat.com, patches@lists.linux.dev, xiyou.wangcong@gmail.com
Subject: [PATCH v5.4 2/4] sch_hfsc: make hfsc_qlen_notify() idempotent
Date: Fri,  8 Aug 2025 19:31:35 +0530
Message-ID: <a67f2f17755345d4b95b0602706dcba079fe302b.1754661108.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1754661108.git.siddh.raman.pant@oracle.com>
References: <cover.1754661108.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0164.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::18) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DS0PR10MB8149:EE_
X-MS-Office365-Filtering-Correlation-Id: 83dde0fc-bd5f-41b8-ad4d-08ddd68422c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WHPat/UJYGJqBW/Lr5pIgy8jZkwMmDn1FylZSutVtR90dUh1i3vtqehF5aer?=
 =?us-ascii?Q?s7vNFhLQWpODtiv2wdGLx4Xv6NW/zkFqEIaP4wIbeFKdpMAL/Vy8IxH+w4Ut?=
 =?us-ascii?Q?+m59Tme5hagxo88uoBkFulW2eQCEAOtGhSHoDTK8VLVPGnU9lUWubpJQn2us?=
 =?us-ascii?Q?MeQaqUKEE4/seBf0aVxzkQK4to+i2+ejo0ZHagsbCyXNNA71/UTgxC4lgghO?=
 =?us-ascii?Q?dSN4OYF88xzFUhpIDDT4iW2az9iDmILO/ZSDRQvaMT9q4IM23Srre8CwaqDh?=
 =?us-ascii?Q?nJ+ZJty0KGcc60ZTufmr5m9oB+exLZm1wxin0LmicXCXziG6WRENBh2VFYW3?=
 =?us-ascii?Q?yq3snhpefAZQiKM5wXX9zrOBWOODYwcnM585iSxqiJLjvWaK05m1OgBc35n5?=
 =?us-ascii?Q?RYjXiQgJzpHFLwUGIAnLTLGpp9/7eGJlB/hrGmRW6Ab1NMqwhGDWp8pHs+wJ?=
 =?us-ascii?Q?poHreJoIrYk+D1f4rrQb4/WDyoNpjmmD2MI56ykmd8ZOMVXyNQYaCxuyyNJy?=
 =?us-ascii?Q?Hq8R6FfskJnSrxrxvLeVmaP5qSxiSv32P6XR7eJUWLy+KdV7u2mSfJKJTrTa?=
 =?us-ascii?Q?EK/ywopByJ/KR+PPLVUseBlPHLYde0QSIFj5iiv8h7zLbNYm5kM1F+aoUG2K?=
 =?us-ascii?Q?aQoBGzPKDSUFgbEAclxop6Ih2O8v75QxJWec9BGuv1UTLOneo/BlSclqJDWe?=
 =?us-ascii?Q?7UvDtUbxH1qIM5oCWZ5HOCVVnsoYRLun9ocOuTLd7qt1K6QkwAR3TWUuj3J/?=
 =?us-ascii?Q?V4BPIGnFhM996+wUVgpQexR/RVwUm8/4KXHcgd3Nk8SMYCygG2xtz19g1piq?=
 =?us-ascii?Q?UnLTFQTw4iqycxXi/9CJLU1qnUtavtRnC2gDD09XIU7PmOQMlsoqwPIcrrkW?=
 =?us-ascii?Q?OJnG1oRRxI/cDluB1TA3U3tQvHqEMbVF0Eo/s5l0vwiz/v0AwWyKCQTLxyzu?=
 =?us-ascii?Q?fDVyNVY4wjao22rzIIluoheHOJt2rmt2OZsfy69hgNUMixHRZn0BStkdLJ3G?=
 =?us-ascii?Q?btB+QKNdKfSIVGsuCfZU8Mj1n2jzplY8n2K0efMSjDgiQYqzwnrc3HXY1LWE?=
 =?us-ascii?Q?WS8tp2ny5q5Cm6+Z5Hx8pbVGmiF+4Uz9OIqouWbYBIGCMrFY2BJwp9dvV0Y+?=
 =?us-ascii?Q?b8CbK4fOfX4pJh3Yu1rJkWn1eZZJTMif/Su7f9XMHb9AflI8DHnL5/QvRVqm?=
 =?us-ascii?Q?JJ8D/ZNuAUaiMA6nnyURhWMFV1h2yanVaV5l7oU5d7sTZwcmnWraBaHqmzj+?=
 =?us-ascii?Q?ZpJ92I6guV3xL9owIIrMiGFRvXPX/YvqGkQZUpE+s9zDcaNajlvLl/nHNsG3?=
 =?us-ascii?Q?PxIuzAwcEh+AvaEuwyIKIQl4kN6YoJSiQloAPJdajZ8+0jf0a82D3jT3TFuT?=
 =?us-ascii?Q?EHLgWEg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yaUrEBu9ri8REnqHHaDCI9mU+A/zMK+mfB4DB+YBedL9DJLpwYg0UKkxeWM4?=
 =?us-ascii?Q?GYpD8Yssy5V/gDjDjitMSObn+mQbTUyoYjwZEZa1JT1BTVye9cqSCZlYiJ7c?=
 =?us-ascii?Q?FoXZA8LB2cmtMSrYhcuc68ZwBw8tUbkMPjxAIQpZbU3mJf1hGiuxyaJDjncT?=
 =?us-ascii?Q?zhUY5D8p5YzlyI17UtrP8fx8GXnSHDDHQKGMB/4ZbFzKp7yLpo0tW5yQvXew?=
 =?us-ascii?Q?aJxV8L1vkTl0xJrp1mV7G3QOu2amZCfW8z2Beajg6pK5j6EqSpLQr133tlVc?=
 =?us-ascii?Q?OZtFLrIbptLhTjqGXNi6cumT1EahN2Up8B+j0chQjvkht6vtcpOPvw+ybeFK?=
 =?us-ascii?Q?CQPPYyLjSXcx0xRqLfchX/oMmQa93HRmnGCivpS+fPJWKrRpbWHYMePkHqZV?=
 =?us-ascii?Q?IrLG4p+n287ij4/f6juC9CBPrGtm6Fgtelf+uLhRfOaDTkq+WFfiAHfueul2?=
 =?us-ascii?Q?1N+mRkDbxoehJQpLj/8URL2JNGTw9Xga0OprD4yvUzOS+w3jOz1Iw14f5i1C?=
 =?us-ascii?Q?qBzoyKyUklP/NwFROHtffp6pPdzztxkAAXdV79VVbvrxVkmHUJtZwryYoCzI?=
 =?us-ascii?Q?RfJrBp8pjt5rvT0CZ8iWNtIzh4Fz2p7ttdZA+dfcUTZl7TxedrPZ8x+igM9m?=
 =?us-ascii?Q?3/VIXV3DQKf99aLNPxOS96IiUnK5S3mqSz8M3iWqBI9KP2YCiSt0bffkaqdy?=
 =?us-ascii?Q?IDE0YwZYECUgHZKdogT9xFak3ZwAgFavYqYlxoEoug1t7KuD2DLwA2f7Xqii?=
 =?us-ascii?Q?lx5NudYqOvCR4MQcgsnujGaFeeZD0bClrOzLEtXNUKKR9y1RWso+7UdoLu/j?=
 =?us-ascii?Q?yAk06SH1L6va84vUBQ70AZC0BPQj8OFMvZmNE2zkeEgd0o5mOxqNql/XBSB2?=
 =?us-ascii?Q?D+cHtUhREW7dto8Qt6D8m2vl03e04+LseGO7TFoDjtG7kEj2iRSoWVcm39GB?=
 =?us-ascii?Q?Re5U/7Dqb+ZKneGq/jCMmP/IQCv8NZrWkz8gTKInlNJJ8Xcc5iCo8Lv5Suzv?=
 =?us-ascii?Q?9CL2WmXReQKFi6J6wDqvAL3h256zjr65SHWzWFJkrBUXoXeXrrKLfOJSBUgD?=
 =?us-ascii?Q?Wbt2+Ffe8w56x+EGO79n3Mml+Vew0s4NMsh+PGc+WiHFSeGvdn2yBnlwDSvA?=
 =?us-ascii?Q?XxMVhY2h5+63qtDNEZAm4jM0mlibQr+lLO4lySdege36hY/WUSUN6ffwAL8p?=
 =?us-ascii?Q?kYAu7SQVVpcCUmrDq2C627ZjUW2DHl4WlTzQ5iOGJktqNLW41J3GsJE7uiIe?=
 =?us-ascii?Q?4gMr4impsjieJ1EkTs0KeKZN1/nMwVgdXC9L4Lls0CW44eEXjMKeffsEEu5f?=
 =?us-ascii?Q?XOlCDrrElGO8zE5/QPaxbVq51Rb5R5HxXXH+MGleqhFM5BDdqIaBQtJSFQUD?=
 =?us-ascii?Q?VSpVCYblOC69LOkmfdSIxe13zbwCuhUTZqG0wL4EHxVDYHH8/soY+J3u+umZ?=
 =?us-ascii?Q?eqauZIcBw4D05qGDq90WciMN92nrWIB35tDOa6oS4PmvtdacaJJB0dh/fh4o?=
 =?us-ascii?Q?QqYR7DhDWVZkNblPrREDCAJlf0VRBLaivOlmZ41tOfb8zRUcfJ5M763Rrh94?=
 =?us-ascii?Q?8gcj5zJirFsJYTocvQDecppx47l2nv3mzJSUGpwSBGjl4fyyjZmF6obZzY/H?=
 =?us-ascii?Q?nGxmQ3iYypimwCw7m4Za+KJnoUjWN1/aeBYM11UYzIjxXjgtNB6ifP9yWtbZ?=
 =?us-ascii?Q?4OPeCQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	swP5UTTXA6dvOBhdjIU/Ru1OLavQAgvWqnyR9v8S/VN174UusKW1StXAuw1OGp6fubBpM+pjfgF4KksAPx80VEpGl/hv5rWjWp5lWvJiUwq7+8rsXnrvsWsS+RD1911hpGlfgNjpnMrVEOG1tgMyHi1MnELM08yx3alEkkg3WHwaQM5qd0k7MFV+AcfOBETEqnNLoCKiSzOZdBewXwZMx4lbe5sCfxJWFv5FHa3WnWFsM0nahTvwF87ghRRQ4QRMxDik+eNYpmI+6CWFJiEn3gKc7FmSjVLKEXZZW5MYHTiVLn/cVfQV5bZa77SNk6cCBrTIiVvZmFUaX8FOFz8gliOdgmGCbY3mt+uTWthDT0bP7bxPzaRb1WelPqHvEqQhSvAiWUGvaLoARg7eY8svJF8Rc5i2YdBghOiSlD2x7SD1EQp779HL7bcGTdgWd0lTssnQ2iPFgsGS4H+zrSxgkS7j/BUP6ewapBts62Dq3Ckr5lnMSlwRF/AlmhT5jedDzBagWtTmukxTUhkuoUKTBEC0O+YuRInHZnnNbEr/k/GUVLYaNMpJPD0UgODuqck2YSSr+tPjvSAA2j44ZvxM57QIYKbl0Cy5kaq3irIsq9o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83dde0fc-bd5f-41b8-ad4d-08ddd68422c2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2025 14:01:56.7064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XeEI3rjVIR2rSg7E10x4KASgdmpEqDMBaTp7skYQBJI9C20W53Z9YMSRHcQfkmO0gixFjYgF/HOeVlbWg6uslAfDiithj+W7PT4QOJXc050=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8149
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-08_04,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 malwarescore=0 mlxlogscore=818 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508080113
X-Proofpoint-GUID: 4dq8S3geC9eaX_OHusqu4jYZkrl7i_I-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA4MDExNCBTYWx0ZWRfX/XYtzQryB/ZM
 xvRc2O3kLZcXJOGUgyYoNiP9XUNb+H1DGxT238PLfsLNgZYaL38cTxKkwHrR5AFWdkRcmWp9uD8
 KFjzG/+rXX13PLyW/DXYfk8BqJIE84A3GW0sjqdftjB2qOLmSgbuTLEjyG/Cdlhckql+tX9wTIN
 mnPHBTiuAWzDPVtlLwpzqJaZvT/x1eWsj1jWgR/jJzYceUPvqywReYbnc0DHEkJPLq4nK8NoHdW
 h2qCZTZc6SwXr6Tgykp3R9WukxsfrYBcXztO4ZqpRRMGR3k30K00Flc/vh4TMvPWWfDAE2i5R7a
 KmxwQk1mSDuuu86Bzt//j3tOhuyTqse9ckzn7pGRksTwn4y53F63B2ewLKKmE3hn7epC7IiiyOQ
 xA0M9mTx35r2i4a94RGdyIHY5ivw5jCxqsHhM8dliB2ahoUDu7tf1NrH2Ad7oSZLl1iXMoHh
X-Authority-Analysis: v=2.4 cv=Y9/4sgeN c=1 sm=1 tr=0 ts=68960359 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=bC-a23v3AAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8
 a=A7XncKjpAAAA:8 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=Kz4_hzx_z8gknMhM-a8A:9
 a=FO4_E8m0qiDe52t0p3_H:22 a=R9rPLQDAdC6-Ub70kJmZ:22
X-Proofpoint-ORIG-GUID: 4dq8S3geC9eaX_OHusqu4jYZkrl7i_I-

From: Cong Wang <xiyou.wangcong@gmail.com>

hfsc_qlen_notify() is not idempotent either and not friendly
to its callers, like fq_codel_dequeue(). Let's make it idempotent
to ease qdisc_tree_reduce_backlog() callers' life:

1. update_vf() decreases cl->cl_nactive, so we can check whether it is
non-zero before calling it.

2. eltree_remove() always removes RB node cl->el_node, but we can use
   RB_EMPTY_NODE() + RB_CLEAR_NODE() to make it safe.

Reported-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250403211033.166059-4-xiyou.wangcong@gmail.com
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
(cherry picked from commit 51eb3b65544c9efd6a1026889ee5fb5aa62da3bb)
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 net/sched/sch_hfsc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index 0f57dd39b6b8..5cb789c7c82d 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -209,7 +209,10 @@ eltree_insert(struct hfsc_class *cl)
 static inline void
 eltree_remove(struct hfsc_class *cl)
 {
-	rb_erase(&cl->el_node, &cl->sched->eligible);
+	if (!RB_EMPTY_NODE(&cl->el_node)) {
+		rb_erase(&cl->el_node, &cl->sched->eligible);
+		RB_CLEAR_NODE(&cl->el_node);
+	}
 }
 
 static inline void
@@ -1230,7 +1233,8 @@ hfsc_qlen_notify(struct Qdisc *sch, unsigned long arg)
 	/* vttree is now handled in update_vf() so that update_vf(cl, 0, 0)
 	 * needs to be called explicitly to remove a class from vttree.
 	 */
-	update_vf(cl, 0, 0);
+	if (cl->cl_nactive)
+		update_vf(cl, 0, 0);
 	if (cl->cl_flags & HFSC_RSC)
 		eltree_remove(cl);
 }
-- 
2.47.2

