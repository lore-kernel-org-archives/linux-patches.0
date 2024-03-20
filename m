Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7E7846C;
	Wed, 20 Mar 2024 00:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.168.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710895488; cv=fail; b=r/GbMF/rHF9Aur5pqYcIooFWve1HQyTWQeddPgDvkzi0FDSvVomEpgawgfmDlWIb5O/UKBgY3O7U8UQIHjkvf77DvVMkuPsh+TDfw+NB43AbebexoUFIwcW8Ll44eHeqB9Yt4JZK5NT6gAHMl4F9D3BIuWxPA5YxGe26CxEh/U4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710895488; c=relaxed/simple;
	bh=a9WjcG8CmRfhFZASvbvyVjX/27fsFaBOXcoTDAMBaS0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AbvqRu5etISH45vdz0rYo7Zq+/eg+pJv3EuPSbwSXSg3Ky9VH9JQrXYKZBXqLvJf+M3Fc/1gN1QW8pNROgnf40S/wmjyg8XUPDU5nDChEAfHiHO2Yz1RThbdJuby12hPyE5UGeR+QDSpe++dNrgngavfIj5S6ntRwqI7i+LaWMQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=AMTzdyfn; arc=fail smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="AMTzdyfn"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 42K0Zr0w013312;
	Wed, 20 Mar 2024 00:44:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	qcppdkim1; bh=a9WjcG8CmRfhFZASvbvyVjX/27fsFaBOXcoTDAMBaS0=; b=AM
	Tzdyfn2VSVQhDdKNwwVIBDfAwBRDaydIGmsXLn57Z2fPg8A77j7yzfXVM5guFE8N
	t5lTWvCmjQGT2ywCz4r96xx+SrlnMb35sfQ/TkxVFLlVZ5BlXCuSyBK1ojHb5+pt
	AYWjqHrlxIMIRdKqWHfxONqrvSZBb7E0qSo9gSSN+BUGAGFzqt+A+x2v7/qfqzUR
	AbHdPCiDk4Dbk2TfilbjKcN/ZE6Ty/ZNMasZ4znASeMJ9e+Ci0kOMPZ3xDKKza6X
	a4kxM9npIr1RBP8yXVDGb2dwCHAYb5sg9fBFFruvjl72U5VONgN7ghoPm2pzhIdP
	f4IQcNtrU76D/MPWoong==
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3wye5n9176-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 Mar 2024 00:44:42 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QM5kUyE6I/PqCQF8zxr2u8oFTIaZZijCCbx8miwARhBDqrCgIz7vo3PM5Kb0IpEjYWPdsB4oBQVWXqtM7nBVwuHUE5DBAq6Dg8GUrDP8Oq1sztFgrMv1ZmGmWD21H551brvZaUGbqbXZyLBkWNGDqOXn3EG5HSVqpMk9umnpeLAf1jMNa86b0GBFpVsFa7Kejksj54SLcLI2B0/XHVw+Ywvq6Flbpemb3mfOu5i7+bjA9etmRs3dY24V4qfjYJe/Pmpz5wYSl/jioITGN5xEQfVQwfVZ9J8+n/45umEsCPsmLQ3JkZGibzW2CFA0q/3PJsVcxZ+EkoHQbuYHK09JLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a9WjcG8CmRfhFZASvbvyVjX/27fsFaBOXcoTDAMBaS0=;
 b=MCCczJxz+gSF/6cN5csxck9aoorCk72tSe+FlBcBtFUynYiB7PHEbegXMXMgSw6/ulYdkmMBps5hF0jZG6uJbkvpVOxwpijV+w3uQlF2lZiO8iidgkYNPA7ayGl6C2UAM5OLUY25nV/odSNFw22nCsYNlCPsGemMHP89GW6zN3gqblG0Ql57ecJWGPXYZkzw6QM4rhRnfPxir8mL2zGDxJefbuImJNqkESn+pFu/Daz9B31FjG6SWrxsj+LdPuk/WXEOgB4s//US73xOdYquYWQ2pZn/3QtNRZi4B9zUbMRgfxWdRR/YTJlGAXqh8csAUc3B2SQnb28oTbLcI0bbcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quicinc.com; dmarc=pass action=none header.from=quicinc.com;
 dkim=pass header.d=quicinc.com; arc=none
Received: from CH3PR02MB10247.namprd02.prod.outlook.com
 (2603:10b6:610:1c2::10) by PH7PR02MB9358.namprd02.prod.outlook.com
 (2603:10b6:510:274::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.26; Wed, 20 Mar
 2024 00:44:38 +0000
Received: from CH3PR02MB10247.namprd02.prod.outlook.com
 ([fe80::a5a7:cae5:6726:a8ca]) by CH3PR02MB10247.namprd02.prod.outlook.com
 ([fe80::a5a7:cae5:6726:a8ca%5]) with mapi id 15.20.7386.025; Wed, 20 Mar 2024
 00:44:35 +0000
From: Brian Cain <bcain@quicinc.com>
To: Nathan Chancellor <nathan@kernel.org>,
        "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>
CC: "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "morbo@google.com"
	<morbo@google.com>,
        "justinstitt@google.com" <justinstitt@google.com>,
        "linux-hexagon@vger.kernel.org" <linux-hexagon@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "patches@lists.linux.dev"
	<patches@lists.linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] hexagon: vmlinux.lds.S: Handle attributes section
Thread-Topic: [PATCH] hexagon: vmlinux.lds.S: Handle attributes section
Thread-Index: AQHael7c9jIqEaG+ZUyoHQaUAIyiRbE/yrrA
Date: Wed, 20 Mar 2024 00:44:35 +0000
Message-ID: 
 <CH3PR02MB10247576D7A146AC35A025717B8332@CH3PR02MB10247.namprd02.prod.outlook.com>
References: 
 <20240319-hexagon-handle-attributes-section-vmlinux-lds-s-v1-1-59855dab8872@kernel.org>
In-Reply-To: 
 <20240319-hexagon-handle-attributes-section-vmlinux-lds-s-v1-1-59855dab8872@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR02MB10247:EE_|PH7PR02MB9358:EE_
x-ms-office365-filtering-correlation-id: 73391af7-f354-4dc5-b8df-08dc4876ea91
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 bhmwdtTscOv25Rd1EVfNHnyDeijmNpD0Sl1QSnwsFcSAK/Mtsgk2bfiDVEkzDmxF/W+hsd3nOGcONvVR70wYncQ7lV7LI4R8AM90gAeGhqoQq3vRX6o++smF0bJj4KGFTXXwJ7GfDsBYFLWXoSU0vG4B/nnmUtgKa6ChLGva3vqWB52x1UnWeOem5yMLYvAhOLBs+Oawm3jKSj2piqvb2B+iPezTnnqxaqVS+pUoqq7biih6FgGvL13phfRnqHx8Zrp8ffW4gzvQb7fW3iB3ekECslSYxNNe1O12OZFn+WB1U0+YMVLEq7CuoZAOYAu3suLvFzorI8Rsfn/3vZZGCc8+CH39wrIGp7eXnODPHv9jIa6pOd/IJDx980xqe1R92lzdN6k35zzDew7mgibF60MJOsrWjKVjGelKQon6OKKJDNjmhS5B53ZTfdr/KE4u6iL7ZLfnRy79SKylW/42MKQNY7IW6We1mfWK0znhhcOPboJ+eENqslnvr2s7P2i1bFZYYWntyg1oOI9vnDXUv0sxBJNMX5PHdg7TgbArbn3zEMO843mjf6GwMQNLvnM3VvhCkayUlYS0fOFAl90GC/RtyUG3J79lTf4TcTqwU/gizjMW9PkQdNYWg/+LrN9598wnVEwr6nNJhBipUH+gD7VSc7OkGQhmM6L6qnryegc=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR02MB10247.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?a1h2VWZDNDU5Vi81UFU0dVdOT3daYkplR2pJVXY4blQ0VnNRS25vdCtUVmdC?=
 =?utf-8?B?TVZ4VXN1RzltQWVHbjlVWW96K3ZVazdwZ29aMUcxVHVkQllDYlc1RSsvMnpK?=
 =?utf-8?B?bFFHSHpBNmpVQjRlT2tDREZ3ZExNazVJVnM4S0x5RFJOdDhPa2pDQWZzYWN0?=
 =?utf-8?B?WXZmTFhkVURMRGdrRVNxcUFtSVpLS3QxQlZSck9XRGxHd0w3SUxKSCtoUlhB?=
 =?utf-8?B?SmljSnJ4a3Ezbll1T3kvS0lYdldPdUI0cXBYVFQvaUcrT2RXcUtqRHl6UUVM?=
 =?utf-8?B?bG5sVTFoVHErN1F2ZXVMN1pjVjNlZUh6ZFZnRkQvT2VkeEZqV2hLZGNTSUdS?=
 =?utf-8?B?UTFwaVVDYkpwUzBjRDJZNkdhOWg5QXk0cTBhNkp6Y0ZEbDNZR2FTOUF1aTdK?=
 =?utf-8?B?MFFVU3pidThSUE5KaFZDdHlaNXU2Rmw2c0dTSzJ0Y29NaTEweXhJL08wMWE1?=
 =?utf-8?B?ZnQ2MTdMRlI0RCtzUmk5UU56VHMxVjlsS1M4eXVNdGJLTTMvanErOHNKcmZD?=
 =?utf-8?B?a2Z4RlhWOGhNTDI1OE1RSWJoaXpwZGsvRFNKNVhzcjFXcmFuQWtIcVVRNnd1?=
 =?utf-8?B?VUpYc3p2cm8wYWRQZmRLSEVkUmUrSVEraGZEOEtOWnRHUE9KazFDS2dXVjd6?=
 =?utf-8?B?N21BYnI5WVBQSVFOaTQ1SXV3MllDVzZ1Z25GRzRFNVFOYytYZFNIN1pXY1dB?=
 =?utf-8?B?RjR6aXJCbHZNY0t2eWFwbk5kZENtTFdOUWRuK3hHSFdZaFZqVG5LMWxGK1hv?=
 =?utf-8?B?a2w2czZ5N0t5YnB6bUtoTk84NjZGWmpEN3c3czdHb0NKcmticWsyYUFzaGd1?=
 =?utf-8?B?VE1PbkYzank3eWZyMFZFV0xVTEpIUzhaelBYVTJ0QVUyanZUcmlPbUVMN0ps?=
 =?utf-8?B?OSswMzNhRWY1Zlo3TnNoMnh1eDRqUzJ5Ujk4amk2V1I4RFBveTJhUUZUTDU3?=
 =?utf-8?B?emJTb3NkbEFWcFhycmc3dWEyWXdPa2Q5b29lTkQ5b1kxUnVydWpqTlRBUWdI?=
 =?utf-8?B?NDB6TGhzSEY4SlFydGdhNk1KV3RwL2NmTWxKSytXaEQvUEx4TVVoQWE1Zzln?=
 =?utf-8?B?TTV4WGIrTlRMbEk0WkRxdEd2eTEvVkw1bGVqVDRlOTNaSlhaVWJJMHlKd0lh?=
 =?utf-8?B?bzU3VzhxQ2loSkFZL2xyRWgrRWYyQ0tBZFhYUDBXc3JFYnR0SThxeGx5RkUy?=
 =?utf-8?B?L29IMENyYnVWc1cwcVB3bGwydWVyREtnOTFtNWlqek9rRTRveTBwV3lmR2xo?=
 =?utf-8?B?c0ViTm9mcjJLcW41U3RrL0tvVVNWQlNBdW5vQTFwcWdYZGduWXZrSmkzOGFi?=
 =?utf-8?B?TXZRLzhqY3d6cjFNSzRwWlpseTNrT0Z3dWtjeHQrYm1MbTdHSU8vczJqUFRa?=
 =?utf-8?B?VWM3bkwyZ2hJK210dGlGODlnb04zZUhUNzBxOG92YzEyTExQZWEvRkl0QlA0?=
 =?utf-8?B?UXFTelcvRFlzWkRtdTB4bVF5UUFmT21BNDJuY3JwNHRBNG5UUmR6N2d6UEQ2?=
 =?utf-8?B?NlRRKy9iRklzcHIzMFdkRUVMV1llVmI4QjI0UDUxemN4NEZwL1h0LzMwWW0z?=
 =?utf-8?B?bXdPckhNNzlScngyRmlreTVjRlppM1RZSjc1OXNid1R3U1RwR2VhdGdzN2JS?=
 =?utf-8?B?RXhxeXdGRXRsN0xTNzArQU1TWC9JTHNiVktyeG1jbmxLeEtHSFlVVUpkNGts?=
 =?utf-8?B?bTgxZWUxbGMrMlFNUFZLLytKeDAyTDgxTWF2WkFHUkVkMm5uaGpZTlF1WUFK?=
 =?utf-8?B?UzVKVTVtZm1TWklKd3U2UytUMnRkNldGNWVVY09pZTIxOGpOcGdlYURDSFhs?=
 =?utf-8?B?ZHMyZFQyYVBHUTZkV0k3Nks0ZWluZC9SeXQvMC8yQ1ZrZHkzVlF4MG9WMEhG?=
 =?utf-8?B?Qi9DWjVxVTBJVzBDazRQaE95OGRZOHEyQ3RTUkNYSVFua2pvZlpUcEoxT2dq?=
 =?utf-8?B?K2ljbzYvdlBNa0oxcjRjWnRCTVp5YitZN0VKdlhmT1ZNeVJBRW5TQnhLZnpr?=
 =?utf-8?B?ZmdNS1lYcmtMUEVFSXhuWG5sTzcvcE05VHg0SGhTZ2gvV1NhaXV2YnR5STEw?=
 =?utf-8?B?d2l4RmZDRE8rMytKdHRGV2l0WWZzeXVaTDRaQ1hYZHBTZTFPM0JnQk5Ic2pG?=
 =?utf-8?Q?m0aHt5HFFom0m5qI7aT/NbHhf?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	7nP0Ir0l4G8bGwAK+3G/pW2fB1+QKdLz6KKlsZAYGE4ML/utQJczakCDk6xbcWcGP48buv7orWh+49E24a7T6h6ogqx2/P+BALFCF+ZzMGy6qiFDujmRjbFoDcSu77ol4iqj5r7ef38bL+RGVy4lIQVX7q8bKe9hsj4yorn7eD7I26sNv2qKl0v2Rc/GdoXeJSAPSkQWmf+WUoj+RMNDcIxn4sxhb+uWyhdDMtwdjAACv2pCUdJ9WU/XX3YPegtVlDbB4PIgx6Ifczn7/hkMb7qdRF9k//6ARrPlqdNfcPqTutxQqLcXyOZbhOv5xSh+U6DHxCYPqyLPj8cFJRE7VtYFMbmt0WoGCMRBVYABA2B5TRFq+tvnsnzQKRW/6YDbzqd2E2oPmmVH1rhAftfkLiMv2TAyTYNGEQEiN/ZvoTBlS31NDRg0qAZkJ21HjICp9GMJed2ieIvc8Q55FhcW6Q8zWb1KqK73DCWbRcXmFbXE2P2CXldtwEdFJnpkfP98ZVgQLZpYdEER0SwAkIXjyEGdV2JyvJkPVblQ3Fynz/b3cTTJnD0JHhnLVC80ll24+dOk2J0b39hRlFOMMZiu0ECjgX1uOfI2d/xt83IjpgG1vFCHPxB3NzV7lSSfgJqV
X-OriginatorOrg: quicinc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR02MB10247.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73391af7-f354-4dc5-b8df-08dc4876ea91
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2024 00:44:35.7975
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IKk2VWsJ7HS6RnGVfJ2K9Y9dc5NdK/UFvQaIVHHwyixdH59tZozZTFpMFgYn7Ty6kS5KT6/zTmkjbq/I5ivoNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR02MB9358
X-Proofpoint-GUID: dfR43aQe3yN4lVY4hKlWuDORhuVb4ZDZ
X-Proofpoint-ORIG-GUID: dfR43aQe3yN4lVY4hKlWuDORhuVb4ZDZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-19_10,2024-03-18_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 bulkscore=0 lowpriorityscore=0
 malwarescore=0 clxscore=1011 mlxlogscore=928 mlxscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2403140001 definitions=main-2403200003

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTmF0aGFuIENoYW5jZWxs
b3IgPG5hdGhhbkBrZXJuZWwub3JnPg0KPiBTZW50OiBUdWVzZGF5LCBNYXJjaCAxOSwgMjAyNCA3
OjM4IFBNDQo+IFRvOiBha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnOyBCcmlhbiBDYWluIDxiY2Fp
bkBxdWljaW5jLmNvbT4NCj4gQ2M6IG5kZXNhdWxuaWVyc0Bnb29nbGUuY29tOyBtb3Jib0Bnb29n
bGUuY29tOyBqdXN0aW5zdGl0dEBnb29nbGUuY29tOw0KPiBsaW51eC1oZXhhZ29uQHZnZXIua2Vy
bmVsLm9yZzsgbGx2bUBsaXN0cy5saW51eC5kZXY7IHBhdGNoZXNAbGlzdHMubGludXguZGV2Ow0K
PiBzdGFibGVAdmdlci5rZXJuZWwub3JnOyBOYXRoYW4gQ2hhbmNlbGxvciA8bmF0aGFuQGtlcm5l
bC5vcmc+DQo+IFN1YmplY3Q6IFtQQVRDSF0gaGV4YWdvbjogdm1saW51eC5sZHMuUzogSGFuZGxl
IGF0dHJpYnV0ZXMgc2VjdGlvbg0KPiANCj4gV0FSTklORzogVGhpcyBlbWFpbCBvcmlnaW5hdGVk
IGZyb20gb3V0c2lkZSBvZiBRdWFsY29tbS4gUGxlYXNlIGJlIHdhcnkNCj4gb2YgYW55IGxpbmtz
IG9yIGF0dGFjaG1lbnRzLCBhbmQgZG8gbm90IGVuYWJsZSBtYWNyb3MuDQo+IA0KPiBBZnRlciB0
aGUgbGlua2VkIExMVk0gY2hhbmdlLCB0aGUgYnVpbGQgZmFpbHMgd2l0aA0KPiBDT05GSUdfTERf
T1JQSEFOX1dBUk5fTEVWRUw9ImVycm9yIiwgd2hpY2ggaGFwcGVucyB3aXRoDQo+IGFsbG1vZGNv
bmZpZzoNCj4gDQo+ICAgbGQubGxkOiBlcnJvcjogdm1saW51eC5hKGluaXQvbWFpbi5vKTooLmhl
eGFnb24uYXR0cmlidXRlcykgaXMgYmVpbmcgcGxhY2VkIGluDQo+ICcuaGV4YWdvbi5hdHRyaWJ1
dGVzJw0KPiANCj4gSGFuZGxlIHRoZSBhdHRyaWJ1dGVzIHNlY3Rpb24gaW4gYSBzaW1pbGFyIG1h
bm5lciBhcyBhcm0gYW5kIHJpc2N2IGJ5DQo+IGFkZGluZyBpdCBhZnRlciB0aGUgcHJpbWFyeSBF
TEZfREVUQUlMUyBncm91cGluZyBpbiB2bWxpbnV4Lmxkcy5TLCB3aGljaA0KPiBmaXhlcyB0aGUg
ZXJyb3IuDQo+IA0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiBGaXhlczogMTEzNjE2
ZWM1YjY0ICgiaGV4YWdvbjogc2VsZWN0IEFSQ0hfV0FOVF9MRF9PUlBIQU5fV0FSTiIpDQo+IExp
bms6IGh0dHBzOi8vZ2l0aHViLmNvbS9sbHZtL2xsdm0tDQo+IHByb2plY3QvY29tbWl0LzMxZjRi
MzI5YzgyMzRmYWI5YWZhNTk0OTRkN2Y4YmRhZWFlZmVhYWQNCj4gU2lnbmVkLW9mZi1ieTogTmF0
aGFuIENoYW5jZWxsb3IgPG5hdGhhbkBrZXJuZWwub3JnPg0KPiAtLS0NCj4gIGFyY2gvaGV4YWdv
bi9rZXJuZWwvdm1saW51eC5sZHMuUyB8IDEgKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0
aW9uKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9oZXhhZ29uL2tlcm5lbC92bWxpbnV4Lmxk
cy5TDQo+IGIvYXJjaC9oZXhhZ29uL2tlcm5lbC92bWxpbnV4Lmxkcy5TDQo+IGluZGV4IDExNDAw
NTFhMGM0NS4uMTE1MGI3N2ZhMjgxIDEwMDY0NA0KPiAtLS0gYS9hcmNoL2hleGFnb24va2VybmVs
L3ZtbGludXgubGRzLlMNCj4gKysrIGIvYXJjaC9oZXhhZ29uL2tlcm5lbC92bWxpbnV4Lmxkcy5T
DQo+IEBAIC02Myw2ICs2Myw3IEBAIFNFQ1RJT05TDQo+ICAgICAgICAgU1RBQlNfREVCVUcNCj4g
ICAgICAgICBEV0FSRl9ERUJVRw0KPiAgICAgICAgIEVMRl9ERVRBSUxTDQo+ICsgICAgICAgLmhl
eGFnb24uYXR0cmlidXRlcyAwIDogeyAqKC5oZXhhZ29uLmF0dHJpYnV0ZXMpIH0NCj4gDQo+ICAg
ICAgICAgRElTQ0FSRFMNCj4gIH0NCj4gDQo+IC0tLQ0KPiBiYXNlLWNvbW1pdDogZThmODk3ZjRh
ZmVmMDAzMWZlNjE4YThlOTQxMjdhMDkzNDg5NmFiYQ0KPiBjaGFuZ2UtaWQ6IDIwMjQwMzE5LWhl
eGFnb24taGFuZGxlLWF0dHJpYnV0ZXMtc2VjdGlvbi12bWxpbnV4LWxkcy1zLQ0KPiAyYTE0YjE0
Nzk5YzANCj4gDQo+IEJlc3QgcmVnYXJkcywNCj4gLS0NCj4gTmF0aGFuIENoYW5jZWxsb3IgPG5h
dGhhbkBrZXJuZWwub3JnPg0KDQpSZXZpZXdlZC1ieTogQnJpYW4gQ2FpbiA8YmNhaW5AcXVpY2lu
Yy5jb20+DQo=
