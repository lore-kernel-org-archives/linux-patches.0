Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03C41C9B7E;
	Tue,  1 Oct 2024 19:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.180.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727809700; cv=fail; b=MxMtEzO2P6C6e358uioa4vEetH6IHIZjh5sGw0xQb21J9PhqEQUof3euuwScSLPlzmXo3+TgcxLbUFScD5BQPx87TENO6s683/JhOhEwCSkb5ASGzYkdcqiw/Db2K9nZJCmdCTJKJmSf4v8vQPiZl3g3HpOpskkmmSHKBasNxC4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727809700; c=relaxed/simple;
	bh=CF72991aWNpeS5sTXBuGoLIvjK29xzvxt6d+h+Qx3NY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CCE3K+kJfdjZs3inxAGHTkHD91zyA3PUfyh8timdqb2klwoZmfDk7hxpq63Gqdk4lXgY5Q2xTz2ovPXJ0AbHTsBuXXhwjQJbK9g0G54+Dh5qbBGZuTIliqsEthh6zo7mYkHMkML4+cKR2GTJNZeY/OTBRtuzQqVp2ssxYSem65c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=hZRb/Ucs; arc=fail smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="hZRb/Ucs"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 491Beu75015368;
	Tue, 1 Oct 2024 19:08:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	U6sb1b7lXB0QLM6JhrPNHpS8qOQSUZ15CfGfcuYKTg8=; b=hZRb/Ucsz0paHAPJ
	2ha/TZtSNCpsCKHWSjtNxDi4L7uZ9FOP8bxQoT3UjmVL2Jbkg5CaGFtDWEqvWWVi
	1xtQd/gFuX6kgQJDv0DdwbodbRHBYBNzGPpJu45yDEj86XM29Q7hSQJYnAfCxUSI
	7lfDeC0f21fOzuBVDvwTsd3tkO5ZwZOlSofav87vntVs8sVpjBPgNgehwTW3QNNO
	3B2UBDp2V7gM0GZOwqWywOipDC/O9zsoYtuJ2z1qPZTATYJ/ymbCUCKpIsUS3/gJ
	as4YQ9PPxWAc5TttcuGuiNk48++ybdbmeAIzz3r3tdKZTYj0dPoTw3vyZzL8mJDO
	bXTo5w==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazlp17012037.outbound.protection.outlook.com [40.93.1.37])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 41x9vu9fxt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Oct 2024 19:08:10 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dVn9lMuTsvN9dE9SgCeWJyHF8K77YYzCOFRz+BCtjTrLTGeFh79AFf4TwrFsxeLeUnq1HouGGrW6e2z6pkZipHXuMqgtCkGU7p1fkS6bhr0AvjFS6QGHPAWTCUrGjI9gkb19fZNkP6oXHwmAxtBkup7N8DidppcWuR8GJ58kU8E3+ij+yf3zJv6NSQlCtB+G7vNKBUrQOTSjSjjA8EdRqs2Lkxm9Iu7JZ/BNpj87uM+ok4tVC/goQHj2e7gJ7xyFqsALOWl7u0v5Vz5y3nO6KxOXBsRz4lLQxOhee13uWuOBGqZXAbdAwFM/jJU/eLdpeNB76vGsLOs7TP5DonQr+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U6sb1b7lXB0QLM6JhrPNHpS8qOQSUZ15CfGfcuYKTg8=;
 b=QXew7X6sXTBW6VHvK0K1F9qzyvDHafY6vt7+wTqQblyB9NLHbr8XaJxTCquSyxazcjgqprPTPi+5DEF99qWMsVTSkynpVC2dNVWSFjKz54rw9mSs2XU3SMMxK5TSL90P1OIUPUebSjTpF6MeEb+2U9dh71hpV16gxuUpH2lGqNBelbmo2I5n8OG1Xb4MM3I3+SdSu1gtQaUxO1V2TFPlk+ipV1hjqIh7v3WIZXrCRawjZmHmU2UP385dTc18RxYQXoPv0HB4Dd5YJx31mOQqf2/IXirCP7eTvho9PGH/ElBkPyhmwwEzJQ4TUCSZZrNpXgVs27enDYiy33WmNsGMtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quicinc.com; dmarc=pass action=none header.from=quicinc.com;
 dkim=pass header.d=quicinc.com; arc=none
Received: from DS0PR02MB10250.namprd02.prod.outlook.com (2603:10b6:8:192::5)
 by CO6PR02MB7619.namprd02.prod.outlook.com (2603:10b6:303:ab::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.15; Tue, 1 Oct
 2024 19:08:06 +0000
Received: from DS0PR02MB10250.namprd02.prod.outlook.com
 ([fe80::3df9:2304:93de:72ea]) by DS0PR02MB10250.namprd02.prod.outlook.com
 ([fe80::3df9:2304:93de:72ea%4]) with mapi id 15.20.8026.016; Tue, 1 Oct 2024
 19:08:06 +0000
From: Brian Cain <bcain@quicinc.com>
To: Nathan Chancellor <nathan@kernel.org>,
        Andrew Morton
	<akpm@linux-foundation.org>
CC: "linux-hexagon@vger.kernel.org" <linux-hexagon@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        "llvm@lists.linux.dev"
	<llvm@lists.linux.dev>
Subject: RE: [PATCH] hexagon: Disable constant extender optimization for LLVM
 prior to 19.1.0
Thread-Topic: [PATCH] hexagon: Disable constant extender optimization for LLVM
 prior to 19.1.0
Thread-Index: AQHa8mPregF3lu+qZUm0P9ZStAGVLrJygxwAgAACDkA=
Date: Tue, 1 Oct 2024 19:08:06 +0000
Message-ID:
 <DS0PR02MB102506E86619CBF49AB8C0A98B8772@DS0PR02MB10250.namprd02.prod.outlook.com>
References:
 <20240819-hexagon-disable-constant-expander-pass-v1-1-36a734e9527d@kernel.org>
 <20241001185848.GA562711@thelio-3990X>
In-Reply-To: <20241001185848.GA562711@thelio-3990X>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR02MB10250:EE_|CO6PR02MB7619:EE_
x-ms-office365-filtering-correlation-id: 4d4756be-313a-471e-9fdc-08dce24c61ca
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?m++1zO6Ws05z8XfSeJoE3Qmozb8cE67BaDsE0cWVKDFSPwTucZh86IV7sJ9u?=
 =?us-ascii?Q?LW7B8qYk6jNUtz/QxsHxUcF1OA0WPCQyeNjcQgFiJ4gcrloDrTSFOujwtopY?=
 =?us-ascii?Q?BYnQGrcVxPQdMtL+9fclfaM8AB928QbdBRmokemY4gJXbW0vPEIl3IdHEA2R?=
 =?us-ascii?Q?mAFJF8dzUkZXok0Duh/4JOcvMgz7YpdGz35HH3AbCE6WxoTkLfWm5z5DbR54?=
 =?us-ascii?Q?grLwUFN+wRwuS3N2TzOo8z/1x2rzLJQeyfyB9zP3yGfHfp+rQ3tXtr1sPRMZ?=
 =?us-ascii?Q?puMpElNGe3RzX/Hfa7f4BQ8+EgaUqfKVnYEySVCXgVFhuHwP0yGUcen3BJjn?=
 =?us-ascii?Q?iXidr9Fg/OaTOyEjVCp5mHQrJ8udNSsIf+YHj0uRhUhwdKFApADlhrUrg0v8?=
 =?us-ascii?Q?GMqranDV+b/9UkpFBQ4fRmSgPn2GMi1B5DeTPIeFUEmt29sfiV+iq2OweY8G?=
 =?us-ascii?Q?EeLlpuRRoKgjn4AbbJzXx54X4sRVpTyNFpiMcS0D9D3y1dP1KQO9NvEbi0up?=
 =?us-ascii?Q?FhqfuIGzkCg6YGsw9GBc8hw9MZzxhS0zZ5i9er9UgcuFzOrBp0HJXRsJt5PE?=
 =?us-ascii?Q?ggz+ZQI6dWsjc5rIhlaZV0uZkmpn5Yj7ja5WZfvGRgHZjg+OzGRTUTu82nRt?=
 =?us-ascii?Q?tw7DWJk77TzEQBaJi/8tWOKFAoIu4DafLXy7lCXtN1Tnc7y7L7P4zV/Q9f84?=
 =?us-ascii?Q?I2e/vuTnX9oELzIXAyl3iRC5JvqsuCrkwKXDV5Qmkov/Q4t4Kw9dpFnQg/WJ?=
 =?us-ascii?Q?6xb7DuIgITMKbIJsbEh5R/rWrFY3Wl3PFlNAx/qpmFR0MZpEpeJmJn7s8Bhy?=
 =?us-ascii?Q?aJeyJpJF3yvw2BZ7PfHSZRWoT/ePxgK+EYhOQsmCKatkekon52IZfRhv4FTy?=
 =?us-ascii?Q?ZziAL3m0akxBSwxAOKt7CoFF+snNkFHO0j1ouhTPLJH6YXmWq/MOYpUZily4?=
 =?us-ascii?Q?lDsieTGHT/Qc6+vowo62mDB/c2F5fYGeWsblnQqBGghCMa0q37+bz0GrV+vf?=
 =?us-ascii?Q?Y0zIx5prjbnKqtYb5i7ALjwQLnBefNHvpyKgDQIl9nFH4+PeLruQJEwgn4X2?=
 =?us-ascii?Q?4Wjfld4Oyltqh0TMvy7N+VYLncbEIa/lkrLjKZNTRWX+uIB3OvPMHNAWORz2?=
 =?us-ascii?Q?5omANatn2P3+57+Ds9IJAzUIj+HfGovEbagnV5aVvIiDyWXKGFVHmYnz/MVC?=
 =?us-ascii?Q?mzbO+dMrrJcHBQ26NACNpNXTFi+GSIoBwvIQql1QdV+eaxArQm6t/K/8vRhY?=
 =?us-ascii?Q?l2t0X6Zk1etkFAU8gEfscOXXPu3ZJGKeD3Blxaj7FKIU3SMG+YGVje8ksJ/r?=
 =?us-ascii?Q?1YuUSjmQ7CjvnTh7i+RnVPUULA5nqhNL0NouVrXV2pk0mw=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR02MB10250.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?OEl6k+QInukR7nFb9Wl0xCtC/KV1OubBrNXAxqzYpNsMj2BQdbd/VSBiV/pe?=
 =?us-ascii?Q?UWckzOwOaQ9mMCAKtS6i7KDjacBkxvEHDCNriM7/DXoz/4ibGKNapf0IqiUT?=
 =?us-ascii?Q?rNEFtlSM2oqj/G3LDnk1zY7G0rEtvMx7dIyxKy7lkaRioYS25Do7JuY2gtrs?=
 =?us-ascii?Q?tqh7WSayBw+E3hwvbhl+sgDeJ8J/fXGUUmLBAKDTVNiJXQfaKvYD/Pq8wsOZ?=
 =?us-ascii?Q?cWL+ukD1CQhwEBaZR3LrjcF4LOo1j/xqZ/mAFKQS/BNQ4ALVniKp/0ymFXSz?=
 =?us-ascii?Q?MpJ4ey8IELqsCjy2QQIG+n6T5j1BbSwAn9TNNaNTTk+7M1t1HL+Ei8o6+BPt?=
 =?us-ascii?Q?bqaft7XTzgLZmLFmMf/gNRg17MnqxUpgMlVE4rY+K8JLSYKisLhAN5kocQCn?=
 =?us-ascii?Q?YSSq08hZ0D/fDDiHjFChOeS/lvL3PwX3wg6uuXqAAMEEGCDWvwJqzHt+nc5c?=
 =?us-ascii?Q?XebXciC9ZGfpcK9jAiz0e1g8/0Mr3Ri2YITjrLagEPqQFuYS5+BTUpDda/MR?=
 =?us-ascii?Q?wLY/48IF/B89XBmo6C8nPOAUlghj2zo+kMRlxuul/vlyOkxWBpmQ8Cp9dGqh?=
 =?us-ascii?Q?MkoSL/cpoZTgDbkp/4VdNsDb1T0ntYBS6Ejw/P91BPd0e8EgL41rjqENZHMt?=
 =?us-ascii?Q?iHWJLqMUtFbAnCRsNq5LtMXzsdGY2CsbQEDPfzasVoa9uTSP337Axvf2V4sR?=
 =?us-ascii?Q?Fx3bHfsD/yRSAqdOm0fF6yOYY2enqCaGLQXsLuVsAwFEyLHJJcPjSPY2Oxuu?=
 =?us-ascii?Q?TlgIbkPyMJlSw++Ryv//H93cYeNmNRMBpLwm7dFiINmGx9AINgzqrxL6pGkv?=
 =?us-ascii?Q?8tNg+8+gDCylnRcENiOHt9EA6xe/SQqbJUI53XwE7ekvtjSUW9+GRMOpBzXy?=
 =?us-ascii?Q?mmHv8DVSCQqekuUz781B8VlzeM/YK+rzB7ganU46FqC3wlsgVlAZsm/tn8QT?=
 =?us-ascii?Q?AU38eQJF/Wui4SmliTASEKgDusMw62kSgKOjmpohkCdIH/DdwpPYLEA2OjKb?=
 =?us-ascii?Q?+cG1jH+0dn7xs36eZOHwbzns0bvy1lUIbZyNWJ0y1LjGG70MIbLjadzAEl0q?=
 =?us-ascii?Q?zUXCE8u8YwkRxOysBLC+AwphRw//QD2Y6+L5RJV5QenevABX0WRrkVWqwaJp?=
 =?us-ascii?Q?Cg7KhrrhfBQH2kTQF2MNXT1ejiNlvxCzlI4F9VAXjivWcXVjqp+kOkYAENv3?=
 =?us-ascii?Q?KHhWpuioJH3lgWIdqDBJc2NhlC7siMohBOoL0yWDKYvsVJCDW704QtkO8gCH?=
 =?us-ascii?Q?gbPBMm8E765Z5ENXnJYr/ulQFWzk7mtC4znv+O74wOD331OckwFRAnSD1Aai?=
 =?us-ascii?Q?yGFuAhZZGgo+3lr/ioaulpEzC4CEYoYOFgLDFJw+qTzhpJ4ij6L99fnvGdhZ?=
 =?us-ascii?Q?RypVk/3d5ErQ5xjLE70wDi5xxMLDsvcsn3RlZccVrksav4T+gSdVZo93Qe8p?=
 =?us-ascii?Q?9E13XWdBKlTvN3a2Wx02AT3nKKNGb+CrUci9sM+FdPLgPR3CW7kvmw8mESOQ?=
 =?us-ascii?Q?MBR7Xu/LjztuhVdlkNLWVGNwQUMy4tqYDC2JCBkJQc7wslA73Om8CAf//bOT?=
 =?us-ascii?Q?zBTqxw932pDmArLpz/x1F0rr/1MW/tOV3T0Tye5e?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	INfg5TCkFIJp4sJJTAZnIagpytZ829PT/TNbqHXep5L/a7R31Xxs/RoYGLLXbSE3qi47yXc/rgeQqpaU/OqE/FPNDwKeGtKPQjifTHLui419xvuk135TMXaMlzOD7YfQCxLPtVxQQe//H9PPOzy4IyusVBhYxf2dqH1DdkrCTnkOptXqR12QgTQg9oQQCrQRLMZ59BR1WsdHgrCKR8BupJ53+ihKc/NgFCp7wDCTFwkoirFhWO0VdO748nlTGn/1yATes1sSpoHNcJ5HRqWyNDP1wHpUAH8IWdcPlFuHGk9pIWJWLtgjAfxa07H7obYT3W20rUg8VUub8QQO9mCZDReYT4iDT4QwLylWypJDu0DAxv1XLoBkEqFgaKZSqEuE+2I9Ec1Ga7ZLpjHDKuTehzqdeBxVbKqbFqOrnWrjOm/g93pH9BHUq2/pu/p7e7aFNina1SO/TgppEemuv1Asf3Sscyh+nK206Xvq1B4BmOkik7iVE3Rf4gFeRHt9Td3BsdSFdgpQ6UC21DIuTtOtHETLnYHP6eykXZnx4G5/+zo/EdplQ+vamvSjvaL1X0TOVXmclFBmFJGq9GYbWN0rsWemW8oc3fTn1l066D2b90B3d/4GDGvz92S7fXsUEt/Y
X-OriginatorOrg: quicinc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR02MB10250.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d4756be-313a-471e-9fdc-08dce24c61ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2024 19:08:06.5379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8gZj1VmwfqacsS9ZOHPxSeke9uxFE8/rK6tN3tfGDJKkRSRKLvk3ghxeBpV5LlYathwUpqnP01QpqlDb5jYBag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR02MB7619
X-Proofpoint-GUID: EfgY9BmzxYe5a-6y4b81Q31mGtcNUJPt
X-Proofpoint-ORIG-GUID: EfgY9BmzxYe5a-6y4b81Q31mGtcNUJPt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 clxscore=1011 spamscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 adultscore=0 mlxscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2408220000
 definitions=main-2410010125

> -----Original Message-----
> From: Nathan Chancellor <nathan@kernel.org>
> Sent: Tuesday, October 1, 2024 1:59 PM
> To: Brian Cain <bcain@quicinc.com>; Andrew Morton <akpm@linux-
> foundation.org>
> Cc: linux-hexagon@vger.kernel.org; patches@lists.linux.dev;
> llvm@lists.linux.dev
> Subject: Re: [PATCH] hexagon: Disable constant extender optimization for =
LLVM
> prior to 19.1.0
>=20
> WARNING: This email originated from outside of Qualcomm. Please be wary o=
f
> any links or attachments, and do not enable macros.
>=20
> Ping? This hang is now happening in 6.12-rc1 in our CI.
>=20
> On Mon, Aug 19, 2024 at 11:16:10AM -0700, Nathan Chancellor wrote:
> > The Hexagon-specific constant extender optimization in LLVM may crash o=
n
> > Linux kernel code [1] (such as with a bcachefs change in -next):
> >
> >   clang: llvm/lib/Target/Hexagon/HexagonConstExtenders.cpp:745: bool
> (anonymous namespace)::HexagonConstExtenders::ExtRoot::operator<(const
> HCE::ExtRoot &) const: Assertion `ThisB->getParent() =3D=3D OtherB->getPa=
rent()'
> failed.
> >   Stack dump:
> >   0.      Program arguments: clang --target=3Dhexagon-linux-musl ...
> fs/bcachefs/btree_io.c
> >   1.      <eof> parser at end of file
> >   2.      Code generation
> >   3.      Running pass 'Function Pass Manager' on module
> 'fs/bcachefs/btree_io.c'.
> >   4.      Running pass 'Hexagon constant-extender optimization' on func=
tion
> '@__btree_node_lock_nopath'
> >
> > Without assertions enabled, there is just a hang during compilation.
> >
> > This has been resolved in LLVM main (20.0.0) [2] and backported to LLVM
> > 19.1.0 but the kernel supports LLVM 13.0.1 and newer, so disable the
> > constant expander optimization using the '-mllvm' option when using a
> > toolchain that is not fixed.
> >
> > Link: https://github.com/llvm/llvm-project/issues/99714 [1]
> > Link: https://github.com/llvm/llvm-
> project/commit/68df06a0b2998765cb0a41353fcf0919bbf57ddb [2]
> > Link: https://github.com/llvm/llvm-
> project/commit/2ab8d93061581edad3501561722ebd5632d73892 [3]
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > ---

Reviewed-by: Brian Cain <bcain@quicinc.com>

> >  arch/hexagon/Makefile | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/arch/hexagon/Makefile b/arch/hexagon/Makefile
> > index 92d005958dfb..ff172cbe5881 100644
> > --- a/arch/hexagon/Makefile
> > +++ b/arch/hexagon/Makefile
> > @@ -32,3 +32,9 @@ KBUILD_LDFLAGS +=3D $(ldflags-y)
> >  TIR_NAME :=3D r19
> >  KBUILD_CFLAGS +=3D -ffixed-$(TIR_NAME) -DTHREADINFO_REG=3D$(TIR_NAME) =
-
> D__linux__
> >  KBUILD_AFLAGS +=3D -DTHREADINFO_REG=3D$(TIR_NAME)
> > +
> > +# Disable HexagonConstExtenders pass for LLVM versions prior to 19.1.0
> > +# https://github.com/llvm/llvm-project/issues/99714
> > +ifneq ($(call clang-min-version, 190100),y)
> > +KBUILD_CFLAGS +=3D -mllvm -hexagon-cext=3Dfalse
> > +endif
> >
> > ---
> > base-commit: 47ac09b91befbb6a235ab620c32af719f8208399
> > change-id: 20240802-hexagon-disable-constant-expander-pass-8b6b61db6afc
> >
> > Best regards,
> > --
> > Nathan Chancellor <nathan@kernel.org>
> >
