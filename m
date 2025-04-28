Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850E722D4F1
	for <patches@lists.linux.dev>; Mon, 28 Apr 2025 07:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745826766; cv=fail; b=BPY1YW8anvjCFlSTPYPXhzR1vYCggX8YJkllJlCsrXHbuktClj1APt1dcVL9+tzfcgABgSMvvCMym+vDk9Ip4LpXVSsXowbtx0DrxjMc03czt8H7adFstL/mxtZy0ao2qHCKEoTY7pc2sD4Uz0OXGBcikAoU+O5zB5/R0nadb38=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745826766; c=relaxed/simple;
	bh=/vIH8WKyPASVwJcxTBJ3pIAzb1k6avA2C17lLK/G14w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ly7yt+QcgoXcrt4ThJrKKo5Hwl5jmyGkk9N+Fbr748TmRUJY6Gy7iSk55gptiO7ZOxIFXmE8Ki66JWL9ScMQJqA9+4xGZL10k55YNFrjva7ibcg+EX5CAXkw11rMP1nXNeZNU+tnwBHsTGMqvA9CFK81t0LaDtis7u3yer5EhA0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53S0nVwL020678;
	Mon, 28 Apr 2025 07:52:37 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 468mq1ap61-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Apr 2025 07:52:37 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v+R8af0yNdvPCcav+LaKEAhDstte0lnbWAuKiOtQ4IaJa9l7AqP+KzmLn8OEfGp0KVISqbRmsWdds6b1o3Nh7zld7ebquu06/p6NG8xeGvoYJwC5p7AKcMqhKAemnr6QvtS7NtvuCnvmOvcB4Ng9XFMGlpuTU86yjydpRhLbhRBAuJzXtc4H9Efx+Exwxj2oPvndEQz1eMn0DrpCH1s+Oo7kgpGmjdrGDOdkuGb4NOVaHj2Y5/ByGp2uLeh21ydrf5aNxCsZKILZVGc5uN7hEcvKHGdKOSoRNIWyBThpSxUkN88+3I7OcQfbyz5yQTqqWnFkf8LDpGSLgK4sXA9nhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vj+zeVk3oeMYZXPQdTZJE3loF3WQeQOS4p+73JB2AQQ=;
 b=C0PCAT0YubxJlwMvblAKDUyLYGb5OMNo+4QUz02SHCMlIJix1zh5GrDa1tOH6YGuB8xIXQB9W445AybjF7Wyg0kLhFiKRYvzvdbm/J0tY78QxiHRVuAMLg4h/1VC9z36AZWwlrfWsoXINCzhHPvlvBKbdp2n04O5PfqqMCTtbX6++bxzZHga4IkUAcQOfrLJ5RwcVDolag1eZJfBH2n4qQlJSMgyQyIisoiM3hQnKLwaQAw+9LtvhQhic29zAEEjkXNYv6qetIECu7d7cwLnF7FARf6uK52m7sfyRMhLRRVo1JpSsziUWUVBwpMr0OmnkX0+lrXni01oL5iX/7CjDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from IA1PR11MB6170.namprd11.prod.outlook.com (2603:10b6:208:3ea::11)
 by MW4PR11MB6886.namprd11.prod.outlook.com (2603:10b6:303:224::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.30; Mon, 28 Apr
 2025 07:52:33 +0000
Received: from IA1PR11MB6170.namprd11.prod.outlook.com
 ([fe80::f850:53da:e11b:1653]) by IA1PR11MB6170.namprd11.prod.outlook.com
 ([fe80::f850:53da:e11b:1653%3]) with mapi id 15.20.8678.028; Mon, 28 Apr 2025
 07:52:32 +0000
From: "Ren, Jianqi (Jacky) (CN)" <Jianqi.Ren.CN@windriver.com>
To: "Ren, Jianqi (Jacky) (CN)" <Jianqi.Ren.CN@windriver.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com"
	<xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org"
	<kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "michal.swiatkowski@linux.intel.com" <michal.swiatkowski@linux.intel.com>,
        "He, Zhe" <Zhe.He@windriver.com>
Subject: RE: [PATCH 6.1.y v2] net/sched: act_mirred: don't override retval if
 we already lost the skb
Thread-Topic: [PATCH 6.1.y v2] net/sched: act_mirred: don't override retval if
 we already lost the skb
Thread-Index: AQHbuBGU9YIRQNFKpUW7aXsI2bcSfbO4tL+g
Date: Mon, 28 Apr 2025 07:52:32 +0000
Message-ID:
 <IA1PR11MB6170EC372E8DA7BB8EB22441BB812@IA1PR11MB6170.namprd11.prod.outlook.com>
References: <20250428074550.4155739-1-jianqi.ren.cn@windriver.com>
In-Reply-To: <20250428074550.4155739-1-jianqi.ren.cn@windriver.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR11MB6170:EE_|MW4PR11MB6886:EE_
x-ms-office365-filtering-correlation-id: 7b82b1d9-9eca-4244-01a1-08dd8629a208
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018|7053199007;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?5BgY616hSfO02KPmOly020jvcjM57rfRMwPb3OhTs/CDGREcE6WrYnBxYSGQ?=
 =?us-ascii?Q?86nN9YCgqSxGTb2fMVqJ2xVKtUssQA2W1qU0KXnXgPkXrljdFlgVYsLS3nM6?=
 =?us-ascii?Q?vpg2bgqaFrbeEsqwFVgvLo1Kq3FpmYeoISVwu+7LjNlyosWAFNz68s4DwB0m?=
 =?us-ascii?Q?AtG3mmkQqIxk6HzKoOHg79RDtNH+iWvxaiA6L2qOba5e5MDRgCB3ydWCz/ob?=
 =?us-ascii?Q?56a1D/RMnhMSpcUcLXEE2/x/mljJOhNfzYtXWBjLORtRL5YnT2sY03XU259+?=
 =?us-ascii?Q?1x12XhFCHR8lS3dQa65KnPGXnMrPjXCCmIOyEdFWgt6L0XPNRGGzye6p5vAC?=
 =?us-ascii?Q?ilA38wq4/VGD4DVcQ2bPtXfHDu1w/k0DceKbfQVARv8R0Ew4H9X6tr1gw7ED?=
 =?us-ascii?Q?Uvwc0RxJ7wwRix2HP4NKdzlZ9KUkJgG+Pu7k2EBkLy0dgUi4+0k5TEReBWm8?=
 =?us-ascii?Q?eK9xwbndakuBtf0Imv5j3UmHNqgUB9fKmWgzKTbkVcjui1ZykhQS7nPquRA2?=
 =?us-ascii?Q?jWK/5qSfPEDFC6dxKEXbU84NF+KqAlLW+HkUoueUk60TTGBfDwqOJFZHrxcq?=
 =?us-ascii?Q?qw6kboU5BYYJPwKQw91WCj01wJ3LB73lkWSNKzr0Covna4Dx2JwyFTmTVGTa?=
 =?us-ascii?Q?6lgZvqQ6pMRY6aO1LJcnuw/Rnv1k+mW/KlYcpDrqdbl7p3xbBykdsEkug7jW?=
 =?us-ascii?Q?ESzjYoWeGfDzQ+hkE4hGFKM7dL2vDT855zpSYydlvy/GGaRuYWUW8u1DLXXg?=
 =?us-ascii?Q?jklK0NNcbz3cIIsd5NMZH2Ly6TZqMLSs4ySkxji73W3/zr1Z5kjKehg6nRgk?=
 =?us-ascii?Q?/+5zO+Yio6vlBOOOObSQbs5oc4mVNAwByW7AxPjDpqvzBeBitTEr8i68/NJR?=
 =?us-ascii?Q?e6BJYYkm2oFKYUKpeWl5LkxREayy3usodBY2Xe7q4u2gIk5hUrxLXzEfSaNs?=
 =?us-ascii?Q?ELkSPEJR3CUXOKHdnwmboJoKDHuWoBbQ79lqWUpUAHyUJgzaDTxhy8Ue5Eur?=
 =?us-ascii?Q?p3H9sotld9fsUMVhqaiOLDWBLh4hmqLVx3r2XdSJ63nP0hCgnXz7ElJrI5LU?=
 =?us-ascii?Q?dYwoSkKl6UtU1VbBSNAwqFAQ3NRKJ03Ayl2/4BM4iVst2PAvDQvtqrmrKSQH?=
 =?us-ascii?Q?noQcMYrX6oKSCLuX3X7a+3UUqal3CeVTY6domqHRE30fRiea8ktSe5zXqNhY?=
 =?us-ascii?Q?iqzjOr2ad+EHmhM7vs9i8aT0qk7SAZoMZcIePavHMn1jIkUKlm98VCEpFXh7?=
 =?us-ascii?Q?Wt59rhYt7dtiHrxPT6zIm45QC8w1jtPFz7tWkOUq+6+UbR9nnLeNZ5pd+y76?=
 =?us-ascii?Q?hFeFrDwCKK34BC2lLrVRZLsJlruZcPlR0iFcgISduhPngJGQOBofuPBrF4Dd?=
 =?us-ascii?Q?tlREA6erPHTZZchjwIPUTk+2veonbd5DhqQVDS2aydWDR6k06dWw+xN9WQm6?=
 =?us-ascii?Q?TmS4/YQFqS5Obsw6QAiCYYJnUhokCZEOk1P9vmWw+o0dUGlJgeU59oKRGCAB?=
 =?us-ascii?Q?WfqJcqwRye+QQyk=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB6170.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Of09n5OLGo8OR28KyClrrWrMyKbdkjRV4WhgJb07qhP9PdqN4ZQ+tHUiEc2v?=
 =?us-ascii?Q?uO+4EIj14qrfZuovGz5cw272itWr9cmstaPKDdcV5ACFPzpUHFKxNpoDmbri?=
 =?us-ascii?Q?1llxZtoUUey3PCzdP7hf06Lw703JEuKvHciSAiwjCnwu+oRmPErhD1bpxdqs?=
 =?us-ascii?Q?iWJ2ry9LIbmRmWwwVkKWY5nR95odo3HikfceyjMsm9vAsDepRm3dtkm0hbtf?=
 =?us-ascii?Q?3EDI+7NuJS19QuyMaZkWDasUfmPIgoHZanrUonmNei1CeSIq6Fwk8TpDiSdI?=
 =?us-ascii?Q?Bz9X8+jD1k8PPMP6k8vSWHD+ButD2lZ7JXZiLxtXZJD9gTs5i7uf2Vu++gKn?=
 =?us-ascii?Q?ngi567Tn8Um5kmyh6NBw+keo2+XgSHH43BGjasTE/9+YCA5E077BgKNR0nXr?=
 =?us-ascii?Q?8BDmnCXxp6HpJgBKtSLU45hYhz4CL1nJGCxdeMptOhx6TY9RbjmR0DFed0BW?=
 =?us-ascii?Q?LCMdMqYjQtwdYd7PIgcfLm7k42GzoG/xyfJZtMhmnlTYy8Bnssgt+PLLOAGP?=
 =?us-ascii?Q?UaROWlBzJJZgrLuUylilj+qqRtAVkmBaieJCnufGfNcuaE8wj5a32T3UVVHB?=
 =?us-ascii?Q?7zVNw6zKyGWqoUAm1hJQ28QEJrSJn2OKbqLY2I52Yd1xkneQMq2Z9yEhW+sL?=
 =?us-ascii?Q?odr1GPzRrerJG5/e0sCLMVcw5qxqrZbk8z83jzRRawC9jqAvFEeMrkjQRdPw?=
 =?us-ascii?Q?pPSFkD1M68L5TT9NYYiA/YKS17xX5+TkSsv53fMI9cRfLjWGp1ZEcHSyQmBV?=
 =?us-ascii?Q?NTGcVpIq+6f4dlMprII7/x3Abe9zK66slDWKh3YS4JuprjZD8luE11S7eMuF?=
 =?us-ascii?Q?rM1UsktpAwDLWPE92j5pE4MjBtdNCqBV68VtAqajGyQ8N1RmfotfkPV1rdPd?=
 =?us-ascii?Q?dlEM+UERzBhOEAfVf76107U1E63ikvCRLqmUGJ36GdKfpQZKJpekv5gxvcGJ?=
 =?us-ascii?Q?TRmxiAtGBMBCf7qcoosEEPgvL+L5dbxerwOI5RL7eeOvJxEUIV+Qhd1OsatV?=
 =?us-ascii?Q?/5GvlQ7HoAjFacUscxwJh3m/188o4cGAmPRiukv1GQ+3bfp0QEuLQpzNEDTs?=
 =?us-ascii?Q?Eq64XmF8YtNo+iJxlGz55jFVHu0+7J9AOsKXJYnBwRv/16xZiFFW4iIjX8EU?=
 =?us-ascii?Q?GIAKJuvn/8x9xg4RNQEnVZEtVi7DRBSmMFgSg5W6xi98eZl1TNcp109wL6EY?=
 =?us-ascii?Q?5SN/BD+W+TbihElQLjSP7eMMXwPyCNfjrEzLOoNrX0RyAblwKwte4RzaaIx7?=
 =?us-ascii?Q?50q4FSQFedEMtJLl+ScC5map6AcAcc4Qxovzlvzt/SKzOdSsYn0hEiaM+J/W?=
 =?us-ascii?Q?MOXsTahrABMJSA8wRNZOEZHT8y5ayqQnLZFxBpACbrFaI6sVQLt5jE/GJr7h?=
 =?us-ascii?Q?JecvQyt3uVemURrgtHAXE1FW98ogHDtF3ttzAmH9EwbXiY2f0Z8Jl4vmHM9k?=
 =?us-ascii?Q?MlPT1u5T4dT4507FQhOwB4ggYd/SJDWRN9Nc+R7lsVNLxSIKc2cjvx6lh9zb?=
 =?us-ascii?Q?0oSKryvaIAA3R/yN1mIKnMJQoxN6r4BfGex+HG9Aea1p0YSnmtLWAzpQccfa?=
 =?us-ascii?Q?caVAcbMCRJ0S/BQREBGNAoB5jxOh0sZOCdJmeVHU?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB6170.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b82b1d9-9eca-4244-01a1-08dd8629a208
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2025 07:52:32.6498
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XZfZ829My/AjgU/uSn3UVhO54sK76iD+qP94ntOULoHEpeD0AAAJ4o1Rc7Gu7aGwS23pR/TJUjzSMtq1KKh6TLsrVhErPX5cG0cQLkcHvXY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6886
X-Authority-Analysis: v=2.4 cv=KsNN2XWN c=1 sm=1 tr=0 ts=680f33c5 cx=c_pps a=smr7v+wKk2SgYJk0SwJNKg==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=XR8D0OoHHMoA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=t7CeM3EgAAAA:8 a=ag1SF4gXAAAA:8 a=A7XncKjpAAAA:8 a=J1Y8HTJGAAAA:8 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=Wh0hBiv9SY0KT2UuYdAA:9 a=CjuIK1q_8ugA:10 a=FdTzh2GWekK77mhwV6Dw:22 a=Yupwre4RP9_Eg_Bd0iYG:22
 a=R9rPLQDAdC6-Ub70kJmZ:22 a=y1Q9-5lHfBjTkpIzbSAN:22
X-Proofpoint-ORIG-GUID: YFrcBGty1zSY2dknS8xlpl_VHXX5tcKi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI4MDA2NCBTYWx0ZWRfX0otcgDhCxkz/ DlaSI638duzMxIZY+MLOd4/ytUpmYQbEu52PXzLiJfzZKSLkoiMsr6SQGng0+VZrjHbpfd7QrIY 3yPRm74/GVwHVbZZaUF4RY99vsDI9kgTh/Lz/XWZCG5ZSROJxI2Q1vNgegWpt8F4G+oQVD4vO91
 KpR+9fu0yV4VYCWdZNFLy0x8+W7bKpbjafqCsyI3QrRv4SRW07+2wat05E/z2e1P3+RBjUMsPcj 53DVuXsk64qsksHcKE3AmgO55iggGE9o2fkRsFj/d43z4JOFBDXXjQRQBJAFr+i+fumFmteg9Oy xKztAzsppQTwjX6zxvjLiZ+TmJAuOa2CYpx44gZUFYcpBxFSP5MCl3+7vay1370jOp6dJoeP8ey
 3AMpqfVDGuNjnHIKUJKt/93ChJ/htIR/O6638IgrUidmb4vzUe8jJI+MgYPM9JWaqBXao10K
X-Proofpoint-GUID: YFrcBGty1zSY2dknS8xlpl_VHXX5tcKi
X-Sensitive_Customer_Information: Yes
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-28_03,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 spamscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 mlxscore=0 phishscore=0 malwarescore=0 clxscore=1015 suspectscore=0
 impostorscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.21.0-2504070000
 definitions=main-2504280064

Please ignore this email for typo in comments.

-----Original Message-----
From: jianqi.ren.cn@windriver.com <jianqi.ren.cn@windriver.com>=20
Sent: Monday, April 28, 2025 15:46
To: gregkh@linuxfoundation.org; stable@vger.kernel.org
Cc: patches@lists.linux.dev; linux-kernel@vger.kernel.org; Ren, Jianqi (Jac=
ky) (CN) <Jianqi.Ren.CN@windriver.com>; jhs@mojatatu.com; xiyou.wangcong@gm=
ail.com; jiri@resnulli.us; davem@davemloft.net; kuba@kernel.org; pabeni@red=
hat.com; netdev@vger.kernel.org; michal.swiatkowski@linux.intel.com; He, Zh=
e <Zhe.He@windriver.com>
Subject: [PATCH 6.1.y v2] net/sched: act_mirred: don't override retval if w=
e already lost the skb

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 166c2c8a6a4dc2e4ceba9e10cfe81c3e469e3210 ]

If we're redirecting the skb, and haven't called tcf_mirred_forward(), yet,=
 we need to tell the core to drop the skb by setting the retcode to SHOT. I=
f we have called tcf_mirred_forward(), however, the skb is out of our hands=
 and returning SHOT will lead to UaF.

Move the retval override to the error path which actually need it.

Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Fixes: e5cf1baf92cb ("act_mirred: use TC_ACT_REINSERT when possible")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net> [Minor conflict resolv=
ed due to code context change.]
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
---
v2: Fix the following issue
net/sched/act_mirred.c:265:6: error: variable 'is_redirect' is used uniniti=
alized whenever 'if' condition is true found by the following
tuxmake(https://lore.kernel.org/stable/CA+G9fYu+FEZ-3ye30Hk2sk1+LFsw7iO5AHu=
eUa9H1Ub=3DJO-k2g@mail.gmail.com/)
tuxmake --runtime podman --target-arch arm --toolchain clang-20 --kconfig a=
llmodconfig LLVM=3D1 LLVM_IAS=3D1

Verified the build test

Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
---
 net/sched/act_mirred.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c index 36395e5d=
b3b4..bbc34987bd09 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -255,31 +255,31 @@ static int tcf_mirred_act(struct sk_buff *skb, const =
struct tc_action *a,
=20
 	m_mac_header_xmit =3D READ_ONCE(m->tcfm_mac_header_xmit);
 	m_eaction =3D READ_ONCE(m->tcfm_eaction);
+	is_redirect =3D tcf_mirred_is_act_redirect(m_eaction);
 	retval =3D READ_ONCE(m->tcf_action);
 	dev =3D rcu_dereference_bh(m->tcfm_dev);
 	if (unlikely(!dev)) {
 		pr_notice_once("tc mirred: target device is gone\n");
-		goto out;
+		goto err_cant_do;
 	}
=20
 	if (unlikely(!(dev->flags & IFF_UP)) || !netif_carrier_ok(dev)) {
 		net_notice_ratelimited("tc mirred to Houston: device %s is down\n",
 				       dev->name);
-		goto out;
+		goto err_cant_do;
 	}
=20
 	/* we could easily avoid the clone only if called by ingress and clsact;
 	 * since we can't easily detect the clsact caller, skip clone only for
 	 * ingress - that covers the TC S/W datapath.
 	 */
-	is_redirect =3D tcf_mirred_is_act_redirect(m_eaction);
 	at_ingress =3D skb_at_tc_ingress(skb);
 	use_reinsert =3D at_ingress && is_redirect &&
 		       tcf_mirred_can_reinsert(retval);
 	if (!use_reinsert) {
 		skb2 =3D skb_clone(skb, GFP_ATOMIC);
 		if (!skb2)
-			goto out;
+			goto err_cant_do;
 	}
=20
 	want_ingress =3D tcf_mirred_act_wants_ingress(m_eaction);
@@ -321,12 +321,16 @@ static int tcf_mirred_act(struct sk_buff *skb, const =
struct tc_action *a,
 	}
=20
 	err =3D tcf_mirred_forward(want_ingress, skb2);
-	if (err) {
-out:
+	if (err)
 		tcf_action_inc_overlimit_qstats(&m->common);
-		if (tcf_mirred_is_act_redirect(m_eaction))
-			retval =3D TC_ACT_SHOT;
-	}
+	__this_cpu_dec(mirred_nest_level);
+
+	return retval;
+
+err_cant_do:
+	if (is_redirect)
+		retval =3D TC_ACT_SHOT;
+	tcf_action_inc_overlimit_qstats(&m->common);
 	__this_cpu_dec(mirred_nest_level);
=20
 	return retval;
--
2.34.1

