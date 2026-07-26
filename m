Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3264227EA4
	for <patches@lists.linux.dev>; Sun, 26 Jul 2026 12:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785070659; cv=fail; b=fX12l1J9YKoZppIoPKI2bTyZUnqCG/Vuihw1RAC/uPbIkmJf8NWumOCUg+Wmg1uDbljtSe2DI7SgD8WNWU/Du86bKSGXDQkwtImfkzy4ygv35Dpk3CGhvf04uJdXDeykY5bU8myVSX8nJ4eVqQ+SMk3xLWedWxJUjIUySlAK0UA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785070659; c=relaxed/simple;
	bh=ywbrliwthUOx/2ShuMSzHOzl1s/m23P5KxWd80DQWdc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hKDVGfonK6Yg06LK8072sEWAHN16C2KsfG96QyKC2KO0HM1MKuAJ0VvuXsv9vCNQ0xX1tJ6DZZ2pFiRyJf1FhChdj5gZV+9JsuZzd3xvIUUIskoeG0YEaFgMwRpD34B+neeCD+OIADOFIsohgDSHOkXulnqnw0n5i2ezlFdilUM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=HpKAqMIv; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="HpKAqMIv"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66QCZ1sl2476860;
	Sun, 26 Jul 2026 05:57:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=2PFKsNBupVgrvTn6gT76OlqssSh9lrfKk1jfsVgwMf0=; b=
	HpKAqMIv2suoNeRKdckCWfY+4NByUEIOex/w1gEUSD+RPcy+JktoMf+G1QYCtMtO
	eVRZVq/YI1Y+edV/zuRDHiMavW0RvL91slRvtcyHQk0bdjFjwnMj0TQcA8RcAr/E
	QMcCTNSw5Gryfvzaj5wKQ06SmVMT9e/YqbIJbMZkAVIbLD7fK7t+L1JV9JtiOG0r
	9zji78b2HFdm6W2UbFoOa3ijUTLiU7V5J76gXSkp08UH46+ZBDBHwq3OlaSit7H2
	j15EWPj0T4a4FSrighi6FNiFPhfpAz1fyCFX15V91VRVLyYm0wPFMGOYtBapyEEo
	gtkurxGMSAynvl3hrDt5hg==
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012019.outbound.protection.outlook.com [40.93.195.19])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fmre00xq0-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 26 Jul 2026 05:57:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mbWmBJi5oIl6IsbJ+dezFB2x82NkR0jRetDB6laa780rjwJLfZwX0ettTahEhfprzd5h2udjbCT1BQIUqvMBDzok/jZvoz4Kzy3VxvUxLd7ScqIRl3VuYbCv+R4WB5LwSqI8rRkyajnJFK00ukbCPTViREz99Xy9u46DdAS60R3SJ6K0IlKyKAvdjqRHDfXoPvxlP9Ux6akn9d0CwY5pOA/oJ3L80TsblUvUHoRqmqbVfotYxkTnXE3GK2M77yuBuHwrSrKSRsPFgr0oArR16XNPYiHJNYgD1whu6VKVMJTytnmlwnYfyNXiWe1fq+fC0FznMfdaQbwNzXzkLukmuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2PFKsNBupVgrvTn6gT76OlqssSh9lrfKk1jfsVgwMf0=;
 b=OTJwxAZ5+p9bYHS+jx0FQP2ttDMVjZHTqKwDbKgwE+v1UaYZruyShuENAP6xMQexZx3T3d3TztkVr6uM5fBAoa4DV4GRDzihR8QE+fQ50siujpvL7c98x/okKhRqabu5K9FFRwyFAr9GGoikyYarvKpAK3j0ntWJsVgHluxh/bL77gRmB4zN1NgyDzJ+PZAv/BUkocoBAVHFra9+QijecGUtyW8VpouIbC7/0L3x1waQQOM+iNWKMS0AGynT8Cf7Bt/WE7N0c6UqCLpQah+aEh9zSl4PBJ/SfNoH7pb/Ym9x8NXFkBk0vIf/SeETjtZRrMnZxbvmjuNUKP4VjrlEmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by SJ0PR11MB6743.namprd11.prod.outlook.com (2603:10b6:a03:47c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.12; Sun, 26 Jul
 2026 12:57:01 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0245.012; Sun, 26 Jul 2026
 12:57:01 +0000
Message-ID: <c5237e59-280e-4cf6-a77c-c71a61c75b5e@windriver.com>
Date: Sun, 26 Jul 2026 20:56:47 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12.y] ext4: validate donor file superblock early in
 EXT4_IOC_MOVE_EXT
To: Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org
Cc: harshit.m.mogalapalli@oracle.com, stable@vger.kernel.org,
        patches@lists.linux.dev
References: <20260724143828.1668805-1-yun.zhou@windriver.com>
 <20260725192000.stable-0005@kernel.org>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <20260725192000.stable-0005@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0135.apcprd02.prod.outlook.com
 (2603:1096:4:188::23) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|SJ0PR11MB6743:EE_
X-MS-Office365-Filtering-Correlation-Id: c04686b9-4695-41fe-0b51-08deeb15626f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|56012099006|4143699003|10067099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	LtZ0AQLtOrkj/QwZAbMBy1Q9YQnvXa8mvT/99uQT/VFK6r8yLCAtkMJsulYHwMWh4KZcbL1zvt2MS1ZrsQqjwDoEKLUH1fv0roF632+GHEqj2EvMKk5AfYtNYbPHvnLB3wxDOZ+hys9We+oD6/S//4F0DaZJ8gKbZ/iIXSciNI2HIbbAEVZKZlTuygKfL2xS/A95vyFLgjQ1TRII6XRBS2l/CYWzcJK5COMfAet7Y52awYRpyPDGWCiyGqKC5EoelawDUzPl6nijn1Sbh17rt/a0ucrgvdqCEN7dGgCBXW4GUsSI1OqIBVI2I5t/U3qK94rdLCAUevGQPgXO0QaSkKUuDU/Emo6NwJouuBQLEE2oUwSmzcxZdEUE3CcwELXzW2KQKyFhsOtEZUYsxdCRXBkG3IhF5uoGtjacZDDTSQZZ5CFtrrfcdYvnLbdPav0kG2joIUyILA6akyQOl14/cLZjTrl4WMiXIZQw4FgEp5SBi+dSZAid6qeTwlVAyPl4dbFT479FZIs0k9+DVi76C6KT088a3bW5SnWvfpeea6dpXrp80S1PDXz9Q9jPf1xcaRckdh58qE0zDos377AWaYTR6ATrDPOpa7OQAgw2ayqFYfKhOruEJKQR8IiFy3UmDs5HltErnKmqAWwQZpqGvQeMxGjRua/R5lcNbBROzzk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(56012099006)(4143699003)(10067099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MktXSEtwcWdTbzNvbnhoVEVLSkZ4ZnpIWkhiS2p6dmdWTGxNamFRTGhhUXhY?=
 =?utf-8?B?RitKbUsrWHJQRzdJajdDQTlMV3QxWHdRemRaWFBzWStlOUppaWJJT3luYzd4?=
 =?utf-8?B?d2VYQnpIRGhJc0dNRG15dXZWWWFWK2h2d1pjR0xBZEtjZkR0TW1DVThXME53?=
 =?utf-8?B?NFdzWHNDa2gvMEtObFJ1UzE5MTZ2T0pXajc0azNUdWhmY0tPUS9OUnhxV3Jp?=
 =?utf-8?B?VWRwc2hyNzhkSXhHRk80Q2dLeGZza0g0L2NCeGhyRlZnL2FZbU5ISWJ6cVY1?=
 =?utf-8?B?d2hpNG8rMHBPOEtRaHNNaHU4ZVlLNllrb1pMbWNGdk5JUWg2TEdVTXRVU2ZC?=
 =?utf-8?B?bmEzejBvNUhBSU1WejFpeWtuYVJRYXluQnBwZTZkSUxnNlR3MHV6QlU5WXo2?=
 =?utf-8?B?YU85T3A1Zlh2TGZwRHpzMENiMCtTZ2RrTmJ1aHN5OHdpUUl0SmtiTWUvWlVm?=
 =?utf-8?B?dnorWjlMeVZsRXNITno0SkMrT0VTL1dyN2M2eTZtdkhTWkxuNndHc1l5OTZ2?=
 =?utf-8?B?YlpGaHJ2MWNWZ0syZjhLa3ZnWmNwWlZUd3NNMWZSK1dSd0gwc3JMaFNCcjY4?=
 =?utf-8?B?Q2FKNnE5WEYyYmJmcVZMbEJkbHBJTTdqRjBpZUhIZ0duTzg1RU9Fa0gvTWhD?=
 =?utf-8?B?d2UxU1JTdGhKaGJGby94SDZ3eHo1ZDdFMlkwQzB1VUxLNGprUlNGNXJTT2tr?=
 =?utf-8?B?M2RMb2MrbzlUcFBCV3d1THFveksyM05WOG5iVVhBU2hlelVJUUQ1aHdBeHN1?=
 =?utf-8?B?Y2FIRVZ0Q0toaUZuYXpKUnZQUmEvMmlpOUNPOTErbWFMZE0vNzlwT0NGYlVX?=
 =?utf-8?B?QU9xaGpndWtrMk9HYXdmNWd0THl1YmlCME9BM3pBTDRld3IzS0pncHF6QXVj?=
 =?utf-8?B?TmlFNUk0bDZZdFhIc0VxcGZMUjB3WEI5M3NPZXhSNUZGL0hNaHBzZDYrYW93?=
 =?utf-8?B?L0RtMjRkYU56TWJnSTdwdFRrRTVGVVpNK1ZNc3A3Y0VCc2NjUVhhVnBabXhh?=
 =?utf-8?B?N1hPWFllN1A0M2lsdGF0T3lXUVdoMkNIUGtVSUp5eURTREJuVHVLWVVITTgz?=
 =?utf-8?B?S1RXcVZrREtEbkE0aFZ4b2J4eU1qaFBSTGpET3prcWJiTTFvWmQwVUZweStv?=
 =?utf-8?B?TXJRMm1MRDFjMkpGMjNmZEo0OVNaamg4a3VMcmhrMkx0YUhVZnQ5VzUrbzBJ?=
 =?utf-8?B?NER0MTBEMzRjUUozNEIvSEJjRm1kNlBjdm43bGhnMGRNN3ZET2dobktxdFZu?=
 =?utf-8?B?ZEZHcEJrMjNLSlBlM3VUUTlSbUFrRGRzblRNODB3NlNZTUNYaVkyOFE4S2FO?=
 =?utf-8?B?YWlMeC9Ba3RWdXNxb0x2OENzSys3WUU2U2Y5WFYvWTMxTVZndUF4SGg5RXNQ?=
 =?utf-8?B?ZG5wbWpvR2YxV1h6U2FZcEsxRmUwZ2RYNDI1N21adDNSbHg5UFZEclRjZXo3?=
 =?utf-8?B?eVJUNG9MbGlrTHpqTVp3ZGtRb21jaVZUL0VjSWtvM1YvUFN0RXZtNkVCNmZB?=
 =?utf-8?B?TXcrS3pkTEE4YjRqT1REaWpzSm5XelpRdVVIUEVDME9XY3dnVERYOEdydndW?=
 =?utf-8?B?eW9nRkRzL3hDTmZBWU5hcXd5OHloL1RlRFlqRXhhSEpHWGwyanE0MkhZdkJ3?=
 =?utf-8?B?VFRqRmI1Y2s3aE5pbDVsSk1TOU1CL0Q5bXRDcDllRno3Zm5KZEljcVY5SHA2?=
 =?utf-8?B?MnZvcndwZTY2RmFOUk8xOHgwdVl5bXBlVXZweTliK01uQkUvclhQdWtOMU5y?=
 =?utf-8?B?RFJTTlQ3UkxFWURmRWFFMy81OWcrLzR5U2tQRlNWTXYveWNWRm42SjEvMTRl?=
 =?utf-8?B?V1JFWkJMT3hya3Q4VnQ3YnJ0eGtjaTFudU9hWmdzUDFxUmZpeWRxZnlYbHM2?=
 =?utf-8?B?Mno0OEh3a0p5ZFRvTlJYdm5RTHhxVEpTdS9lcGEyeHRQdnZzU3NTcUJ4azZu?=
 =?utf-8?B?YkxEaEg2ZTdVUUg3bDQxK1pSMStybXhjUDF1M0piLzN4QytpL1NYVkNTUnZF?=
 =?utf-8?B?TEF1Ri91VzBXWXhFalBPMjdIQzlERlg5YWJEL1JwZHBLU0JBbzg4SFJZQ0Fm?=
 =?utf-8?B?eXpOSi9IUG0zRStlcldRS3FkT0ZwNWphQ2RIUEFvaXZhTlBxUmgzWmRGSkxD?=
 =?utf-8?B?dDRYME1mYWFiZ2VWZ1pNd3pTL0dldUJZSVlSMkp5bTBUbnh6Umk1cVR3N29k?=
 =?utf-8?B?Q09NV1lpakE5Qm9hQk0yVnM0dlFMV1dTYlk1a2J1S1VwV0o3SXlBSEVYbWYz?=
 =?utf-8?B?WkUveFp1b2tKQjFCaGN3SFhaOGs3MUtrSldMc0RNVTZjL0QyNjBGdU5GM3dO?=
 =?utf-8?B?dlZpWW9HQ3c2S25ubWx4MzNYV1Rhd3pjRmZmcll1L2ZSMEZRTksrUT09?=
X-Exchange-RoutingPolicyChecked:
	MPk7vOfJ5OrSqUknxHhBijbKiLeYxOa3C3/NdD28MbZndkVMWN6Pwn7d+K8jPjxRudfgRKQFI5AdlaqvJdekBl8LrA1296Uf2ZChPBeDyFrYqPYarDnv2+LfXeO9B8SSq4VcdCGrdFKmuvykbT2YYyRpvv28EvAeVK7+rT6b5mbRz6/tas02acQ2hR9cxC/iReewwDhO6+bTIw++0hU3zNocz5iHjt46vtyBGOG7ecX/eZII0M7K3X4bmMyNVPl3duxO21pwTuqy9cdzGg5uDfJeXWa4BRvUrDcmLEb5ZtPmUk2oQzCAwz7U1KwwHalxG4MtdOnezIw0C1btmt8wFg==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c04686b9-4695-41fe-0b51-08deeb15626f
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2026 12:57:01.3208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NLANbL50QXXpmivHz0s0rMU8w04CVx0cMZQatHMqJmC9nJoJYKuSFlcmlavtPluV7at1WkUSvAI9f7GO98bToQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6743
X-Proofpoint-GUID: OZrk_NwMcKslOSLndqGbnhzSPGWl6bgg
X-Authority-Analysis: v=2.4 cv=E6z9Y6dl c=1 sm=1 tr=0 ts=6a660420 cx=c_pps
 a=7Di9vct5tcmjM1itADynpg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=HK-ge7EqtdluswH-FwHe:22
 a=VwQbUJbxAAAA:8 a=tFUAjZReGmMd-u4s648A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI2MDEzMCBTYWx0ZWRfXyH9GpsUDUOeh
 LqDJdXBo4uG9cab8GGRNr6QmiR3ju/SMMGjGm3UJuXWxJ6L84a1IRQfWY1EAVtcSGRZZucjfsED
 JWfhoBoJMjENG7HolZOIDSopXvJpOMXuERvQIkVqcs5xMaqQnD2p
X-Proofpoint-ORIG-GUID: OZrk_NwMcKslOSLndqGbnhzSPGWl6bgg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI2MDEzMCBTYWx0ZWRfXwxDyvc6EB7j2
 S1evhRcqDTqaCX6xLyM6dQnFZmMWM5Tfz4YgkMKSD1OCASnPDVJev43iu/lxDiToWz33ZiMu50w
 /GtL+rE7Jg8MgfIoYnv/ui+4777vIgXhdlqGus3+da8dVhAk0WDPlbcSngd+hMw5GMH33TgfrbY
 U1RPG+dNlp9GrKCkc6QsdAvIW4WOcW36Cfn2IWCs/7zWxXOHodTN+Bod6pZwY3gaxQBYU1sRtQn
 T8OMXUd8+v9LYfAm/noggKoVI0UZaLv/qOCyVuS7ySCUPN4AsCbInRu3+dP7MuBh9hoEHwxx3Mn
 v7Rg8kzKTUEyAGQQ8rcZa3PZo4SygSeHoMQ/7hoHG+SHUD5qd9fWnNvqLZSOedt9ZV5LTivUKTM
 IikJDjMEY7m8rPTKiCaoSo4Oj7FzVva9K13FjfumP2FimZgcUg8GTV0N84t6sZXLBFHVg04X+dU
 /MxHGKeFmdEYbVhmmvg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-26_03,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 impostorscore=0 spamscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607260130

On 7/26/2026 8:04 PM, Sasha Levin wrote:
>> commit c143957520c6c9b5cd72e0de8b52b814f0c576fe upstream.
> 
> Thanks Yun, and thanks Harshit for spotting the donor-fd leak.
> 
> Since the original backport is already queued, the cleanest thing is an
> incremental fixup on top rather than a full replacement (which just
> duplicates the merged commit). In 6.12 the fix is to turn the early
> "return -EXDEV;" into "err = -EXDEV; goto mext_out;" so the fdput(donor)
> cleanup at the mext_out label is not bypassed. Could you send that
> one-line delta and I will apply it? Thanks.
> 

I see that the fix-up patch [1] has already been merged. Could you 
please double-check it?

[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-6.12.y&id=913e7b4459d6eef807bb8088b39b890ed6a74ee3

BR,
Yun
