Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.26
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795478929;
	b=WJHqV+HQ3cAlidAWUILaEJzMX+luQ7x8KkxrQVcAWxRWwkNZfu4KmCpehpgK9S+ISRFO
	 eK/fnVJC8tt5PE/ET/je8qQePNQ+fVcZYoGMN26Yya52kB5646+G4caBmkMf18lA7xsd3
	 l26l5WE5YGZ5twj2e/RMigqtRHjz+9L5scdKA+tq4qfdVwGa3dkhalhGpGPBUKDBKej4v
	 VFlqQcDFU0YPXyhUKV4nllISs+uicpsEzq5bydNO937u4E3wwKjS5mZ5UeM0+l4OWDvuU
	 EkdeOeTD4gxuftfJ794/Bm1QszHg4+4WxVL1jfvvMNDXnqxGLt1Egohwk+y4C6r2Qaw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795478929;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=H5W/fCCAsN07I1uuiaX/94nQ4prvOJ8bQHYTcI6FfvM=;
	b=BDxL52KW4Y33jeOTCpBeqTFBV7pH/PsQR2c5tjKJbdrJJZbz3XVIg1GHm07XzbEZ4rGA
	 5I4q/8hwXgt8G3//e4Gw7lgEv+1CJ9EXHrxuB3tqY2FsIpFhFIMymfr57SJmkszjXEoDa
	 vejcfuiYzhq98ue6LtG9V3iQqr6LTVeySKHo3HQ5zngvB6k6oyudPBVZb5GrHvfVTEJE3
	 39vp5x72+oylWAd4FQWBw/KihhBoJn34MlNE1wmvu5rS61ZPhrAms0Zw6er0wCwiip08Q
	 4li0PYmzRtAtBSa8T+PEZ8gjzdJIJ/lgKFJwdpAxVE7nRgwk5Whx8wl+X54MtrWIxlA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=vs4atQlz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.26
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011026.outbound.protection.outlook.com [40.107.208.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00330606A31E;
	Tue, 24 Nov 2026 00:08:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 00330606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=vs4atQlz
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZNlIwz0nJ8WmjvQCeWZU7zrwG5Sx0/JatUqJkXVQP4iqv80eAwkOZrBW42W5pP6stDtjabCNJurji46eUiDNg/sGx9j/4ujU0775TxMCi2jxbqV5Rd474bJUzAbSUeyiG0qPn40YuNYWyruFrJsw0/kshhOMiic33Skx3avA9F8D8XcsAdhvj/0OCbx9w9uivCkcT816zycYUdUieiPAI21pZ3hPTa5zqydgKjnYYbSD1vKzitD/pNHwnCcL/36at4ZUmPJRnwaYbJ+4ryAp7IJII54BMxd8eyGnvJLUamDE9LoX0Jo7V+jCuaBin0gYy7GUTSeAI3l7eGmBmjE4OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H5W/fCCAsN07I1uuiaX/94nQ4prvOJ8bQHYTcI6FfvM=;
 b=gXPxO626O4/FpMMtVdEMes0gkrpkr4xlQtI6ULnLC7psniVgsZ8hRnNZzZqxiGucWoJNoE87YS9uSQRXBerQqDdoJnV0M1PPOYIMmCnoIZ/m6Llv6rpyjBReK5J9oUetMP9+kEhbElaFC8S047EingQfYUa7NicG/V2zeSbKkaNULwqudpodyfBLG+AhX2uK7VlC91alhhj8N/JC/dQiN99KnExBjeaByA268JS1JwK8FAl/jr7euXdQKfHK4mSYLjZl6OnRhWc86QBRnXxSTEzKQePEQEaH1xh8WwGH/j0MWBgF/bIkf3qBb/l6YG+kqTmtHe72Vzgk5uMXmeGUaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H5W/fCCAsN07I1uuiaX/94nQ4prvOJ8bQHYTcI6FfvM=;
 b=vs4atQlz14V/tk7osRT8RqsCUKKrXoWXgyl3Jb6enVReUcz35PyEhPp/GmOPsELqXa8qlB37jtlY8R8JXs39JCZ2SGeHLiJagELB9MVOp8MrqkNjFhZZ3xE5x7Ad5fMU9sLS//dNw/f+KVypEb7dquJi1jfcPvzhQ4gs1dEhtmk=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 (2603:10b6:806:4db::10) by SA3PR12MB9090.namprd12.prod.outlook.com
 (2603:10b6:806:397::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Tue, 24 Nov
 2026 00:07:40 +0000
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3]) by SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3%6]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 00:07:40 +0000
Message-ID: <7289e52d-eaba-49fc-a6a5-c3e24871dac2@amd.com>
Date: Tue, 24 Nov 2026 11:07:33 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 09/10] PCI/TSM: Build encrypted MMIO descriptors from a
 supplied report
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 linux-coco@lists.linux.dev
Cc: Dan Williams <djbw@kernel.org>, Leon Romanovsky <leon@kernel.org>,
 Bjorn Helgaas <bhelgaas@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 Xu Yilun <yilun.xu@linux.intel.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Steven Price
 <steven.price@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Lukas Wunner <lukas@wunner.de>, Ashish Kalra <ashish.kalra@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, driver-core@lists.linux.dev,
 linux-pci@vger.kernel.org, kvm@vger.kernel.org, patches@lists.linux.dev
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <20261123083337.2731019-10-aneesh.kumar@kernel.org>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20261123083337.2731019-10-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY8P300CA0030.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:29d::32) To SA1PR12MB999228.namprd12.prod.outlook.com
 (2603:10b6:806:4db::10)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR12MB999228:EE_|SA3PR12MB9090:EE_
X-MS-Office365-Filtering-Correlation-Id: 13b211e4-ec96-4947-b2da-08df49bef459
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|22082099003|18002099003|6133799003|261009221227099003|261009223027099003|3023799007|4143699003|56012099006|5023799004|11063799006|10067099003|261102123227099003|261102130727099003|261026140227099003|261028144727099003|261026121527099003|261022075727099003|261021121427099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	MzYMbeJ/rS03NHcbs5Sl5FIMJhYEFIT0F0tm9SJ44XQBkbZyw5UOyHRlbHWPVSvaUTgbR03ewVCjINQAfRMX8X+XL7RGbQewCKkFuq47rfrWS4rEx2DuR4RHwnhOj4K9pn0iSk9+OwIMnCnd7Caf25ewJPMSYgBNGyRlQKW6wmtkIUcHO+L7OQGFuIQrc4FDAXiaq6JaoBZhcHYcLaY/tskjlxJ+cOxQraKERXmK5JQwwFiPkbxFuLiJqUyuFusP3Bxn11wQb2EAKep2ozbHV8zMCoJHZyxdngor+VVQaQ7Q/FeTfQS9a854sYXBf7FSH6DWjThh/2OllhWEjEY8l2cubEDBQXe6YPrmOdASASmF21V3uomlqmQVNobRhctzJZtC0zHFQCdU7PbpGX5V8FmDCwFgIfb0v/aBs/kVEleeFVD6ep0qS/yqOrdye3T/0CM9c2+3WIA0N97MTdNHjWpEWQoJ+o7JotZs76O1LlO7Ez7Jjxo1oxxMjJOFIsZ9mkUm+KNdC3ah3E+Zrgu+YDy4Es8KdVbhFXQbzwzt8oWS2B1tQa+GBHQNLMujH/T4kQGl9rMD0rAM01pYNliUqPJV6mRq32AG6BIkokZILmxJlg8IgBSvrJa+itIM4nzn3+yXuK5Az1hVH799XewTzoHyW05/yyVxpAtErrky6hg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB999228.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(22082099003)(18002099003)(6133799003)(261009221227099003)(261009223027099003)(3023799007)(4143699003)(56012099006)(5023799004)(11063799006)(10067099003)(261102123227099003)(261102130727099003)(261026140227099003)(261028144727099003)(261026121527099003)(261022075727099003)(261021121427099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eDI3UjBKWk9FQWNCK0FydDRWeUdSY2tMVklpRFFKVGY3Qkg0bkZkSHZYZFBU?=
 =?utf-8?B?dm9ic2dEUmNUS2dvdnhiczVhendlSWhYUnRHUzYwd3dqc3daMG5QdkZsUTNm?=
 =?utf-8?B?dDllejJHb2pBSXRWRWZ4Z05JZGNOZWNDTHZlKzRiTklLUGxzYjI2NnZIak1x?=
 =?utf-8?B?NTNKMmZZYXZPbXFjREpUMi9UV0VQS3F1SXh5WnBhL3ovRk81dFBNV0Q4clZ3?=
 =?utf-8?B?VXBRQ3BqbXRHSmFadzZtM094ZW9McjNvT3FrLzlHS05LWEViQkFHZTUzVG1z?=
 =?utf-8?B?am1TK3AzcEVmY2REUyt6aXFKZ1Y1Yk1IYVlnM0xLVytYMjNScVFuaSt3N3dt?=
 =?utf-8?B?Rms1OEpvbmVoTnhBWU10ZndRRkgzbzJTTS9nTG9oYzBoTXVoUW9tTDU3dmxD?=
 =?utf-8?B?cC90VFN0UXNrMGRxcWQzemxMR0JHNWN1QnpoQk9TczVQUzJhRFMrdmVJYkw1?=
 =?utf-8?B?eWtQd3hocWFBMWdzR3I3RXR2emV2aDRPK2dYUGhpdnV4YThqanR1WTFHK0hh?=
 =?utf-8?B?R3RtOU1EVVRBaHV4NkdROERjRG4veEFFTTY2WEFEdnRNemxtSHNQR1AzWXNP?=
 =?utf-8?B?UWpsaG5ZT2Y3bW5qYUVhRnltQVBHZnRjR0Vlc01jbUZlSWJxVFQ3WUlIN2NG?=
 =?utf-8?B?bHRCa1dPdm56Mmhsd3FoM2R6Uys5WXJuZVNrM3VPR3pCeGxZYkRaR1JUUFZs?=
 =?utf-8?B?VFhWSEhrOUN5akFBWEhkOG1CMmpUdlY0Z3pFNVJZMDFvRG9lY3UrSmpZUXFp?=
 =?utf-8?B?RlhqYkF5bDUwQWJGcWZKYUJ4aE5TNDBLMGlzY3k3NWxSZDVsa2JaSDQ0MWJB?=
 =?utf-8?B?NmF6TGU3M1FOQnVtQWpZcXFGTEtGRnpCR2FlWG1oZjZvNlFUVE1Ka2I1akxw?=
 =?utf-8?B?SmYrdmxHOExYcjRKUTZHTVBKUjFjQ3FPa29pWlV3K3IzSGNiVk1ONURkS3VJ?=
 =?utf-8?B?cWY2eXpnTzhxNFhJMnV4bzRmYjVyK25FeFBMQnVBbnVrdFJSa0tIUzhWSGpT?=
 =?utf-8?B?VlducWxhYjZvNDd2RGtvVy8ycUR5RzBobURzODQ5d0t3Q3RpK2xCaHVScDlj?=
 =?utf-8?B?WERHajB6UkZYQ05DNTlVWThGL3Bjc0JjczFab2plWTM3VmhRdUxxVTkyR2RN?=
 =?utf-8?B?NVp1SzZldFFUdVpGR0dOYnV2MWFubW9kS0hiRmtMOG00cFR0enZiMUMyYVBH?=
 =?utf-8?B?Rk5OaFowNnBGQjRseGlKYVdFZkNReGVxZXBNbUtuOUZ6V09xR3lhOGIxQnc5?=
 =?utf-8?B?ZnNvMGZJRC9MWEtPNEpiTVZkOE56YnNValAyYnJuVXMxNkZpdzlhdTBiTkRy?=
 =?utf-8?B?SURmSjFPNTFsUUE4VXZjVlkxVzRHeTFQWm5lRmdGWlo3WjNuc1Y5SE03NXF2?=
 =?utf-8?B?eHEzNFRTdHRNeVB3a1RlemR2MDZBaWZ3MVJXcXluUDh2Um83TFY0MDRyWGg3?=
 =?utf-8?B?Q29iVUVPSTBObm92R1E2c0tWRGcwNmpDb2x5VnFvampKNlowUzVwNGlkOWhH?=
 =?utf-8?B?SDFCSjJheHBNWkNqRUJrVmtFUm1jZ3RVMEdCVm42VXlldDhsZlduTHZ3eGJn?=
 =?utf-8?B?ZlRkbDdVWlR0MmllZ3puUVpBS3Q4d20vcjluLzgwOWZmV2RKOFdadlNYN1NK?=
 =?utf-8?B?UDlXKy93b2xXLzc2QmVJZ3VCMkk5QUlsLzkvRjZ5Wm1ZZmt3ZThRMkNUNVpC?=
 =?utf-8?B?ZVhKeUUxVy9WN3VNUCs5MGx3Zk5mWDJUNWFGUGFEQVNSenlSN2NlTFRpNXZz?=
 =?utf-8?B?Wi9nam9UMTJ1M2oxSG1NMDJuZ0tkTFdKWnJzNlBScGJPMG4xMCt2azg4T2c5?=
 =?utf-8?B?Wi9OM0ltMjdublV6OTgrMisxZFRSeURRUlppZTlqa3BjSjR1WUh0MkF2UEVN?=
 =?utf-8?B?U0ZqSjFWbkcwdFI5TytpN0RIc3F3aGU2ZkJHckIxZG4zenRaTHA1WlBubjNZ?=
 =?utf-8?B?U054RnJXbDdXSy9lNHgwUHJTMG04bEo2Szdoc0VnR3g0cnkyTUpRRDdxYk1O?=
 =?utf-8?B?OHpPbGhZQS8xR0JiY3I3TS9YMFVaODdjdkxlQzJaUGszVXBncTJtYmhJWFdQ?=
 =?utf-8?B?NGg4aGRiQ1RGYnlXZXdHS01Ec1pkdW9PZU9OK08yT2ZhQWVLQ3RJY0NBaDVX?=
 =?utf-8?B?bzhoeVVvOURkeFcyeGpFSXlXMHFwODd0ZTIrT2dPcDBTcVZHWmFVREl0VmR0?=
 =?utf-8?B?by8vL21wbUQwd2Fwc1NXQzdSMFpMUEU3RGtFVmxSMkpURXg3SUtpWHozcVRO?=
 =?utf-8?B?bVIyTU5lais3cWxzblZpYnQya29lSmVpQzNzamhJTXpDWFdrblN6QTNvOCtt?=
 =?utf-8?Q?klTF5stSwnMC/JabeK?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13b211e4-ec96-4947-b2da-08df49bef459
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB999228.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 00:07:40.4725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w6cmejyV+D9WUYbTILyywiTcCma6xMP+8Mc9d3fqAkC5mq10nmxLDFuHVvEdqKYK0MPs592ObEFNJhv4Q+7A/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9090

On 23/11/26 19:33, Aneesh Kumar K.V (Arm) wrote:
> The TDISP Device Interface Report describes a device interface's
> configuration, including its MMIO ranges and their attributes. Each MMIO
> range identifies its BAR, starting physical address and size.
> 
> The device adds the MMIO Reporting Offset (MRO) to the physical
> addresses included in the report. When the MRO is a multiple of the BAR
> size, masking the reported address by the BAR size recovers the offset
> within that BAR. Combining this offset with the guest's PCI resource
> start gives the corresponding guest physical address.
> 
> TSM drivers need to parse these reports and identify the MMIO ranges
> requiring private mappings. Provide common PCI/TSM helpers so each
> driver does not have to implement the same parsing and resource setup.
> 
> Add pci_tsm_mmio_alloc_report() to parse a caller-supplied report.
> Record each range's guest physical address and retain its reported
> address for firmware mapping validation. Skip non-TEE and currently
> unsupported MSI-X ranges.
> 
> Add helpers to register the ranges in iomem with IORES_DESC_ENCRYPTED,
> Setup requires device::mutex and rejects devices with a PCI driver
> attached.
> 
> A later guest attestation patch uses these helpers during
> evidence-accept. The caller remains responsible for verifying the report
> and validating the MMIO mappings before allowing device use.
> 
> Based on the original patch from Dan Williams <djbw@kernel.org>
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>   drivers/pci/tsm.c       | 227 ++++++++++++++++++++++++++++++++++++++++
>   include/linux/ioport.h  |   1 +
>   include/linux/pci-tsm.h |  35 +++++++
>   3 files changed, 263 insertions(+)
> 
> diff --git a/drivers/pci/tsm.c b/drivers/pci/tsm.c
> index 2fbd146db387..c21066e55d3b 100644
> --- a/drivers/pci/tsm.c
> +++ b/drivers/pci/tsm.c
> @@ -21,6 +21,7 @@
>   #include <linux/slab.h>
>   #include <linux/sysfs.h>
>   #include <linux/tsm.h>
> +#include <linux/unaligned.h>
>   #include <linux/xarray.h>
>   #include "pci.h"
>   
> @@ -650,6 +651,232 @@ static ssize_t dsm_show(struct device *dev, struct device_attribute *attr,
>   }
>   static DEVICE_ATTR_RO(dsm);
>   
> +static void mmio_teardown(struct pci_tsm_mmio *mmio, int nr)
> +{
> +	while (nr--)
> +		remove_resource(pci_tsm_mmio_resource(mmio, nr));
> +}
> +
> +/**
> + * pci_tsm_mmio_setup() - mark device MMIO as encrypted in iomem
> + * @pdev: device owner of MMIO resources
> + * @mmio: container of an array of resources to mark encrypted
> + */
> +int pci_tsm_mmio_setup(struct pci_dev *pdev, struct pci_tsm_mmio *mmio)
> +{
> +	int i;
> +
> +	device_lock_assert(&pdev->dev);
> +	if (pdev->dev.driver)
> +		return -EBUSY;
> +
> +	for (i = 0; i < mmio->nr; i++) {
> +		struct resource *res = pci_tsm_mmio_resource(mmio, i);
> +		int j;
> +
> +		if (resource_size(res) == 0 || !res->end)
> +			break;
> +
> +		/* Only require the caller to set the range, init remainder */
> +		*res = DEFINE_RES_NAMED_DESC(res->start, resource_size(res),
> +					     "PCI MMIO Encrypted",
> +					     IORESOURCE_MEM,
> +					     IORES_DESC_ENCRYPTED);
> +
> +		for (j = 0; j < PCI_NUM_RESOURCES; j++)
> +			if (resource_contains(pci_resource_n(pdev, j), res))
> +				break;
> +
> +		/* Request is outside of device MMIO */
> +		if (j >= PCI_NUM_RESOURCES)
> +			break;
> +
> +		if (insert_resource(&iomem_resource, res) != 0)
> +			break;
> +	}
> +
> +	if (i >= mmio->nr)
> +		return 0;
> +
> +	mmio_teardown(mmio, i);
> +
> +	return -EINVAL;
> +}
> +EXPORT_SYMBOL_GPL(pci_tsm_mmio_setup);
> +
> +void pci_tsm_mmio_teardown(struct pci_tsm_mmio *mmio)
> +{
> +	mmio_teardown(mmio, mmio->nr);
> +}
> +EXPORT_SYMBOL_GPL(pci_tsm_mmio_teardown);
> +
> +/*
> + * PCIe ECN TEE Device Interface Security Protocol (TDISP)
> + *
> + * Device Interface Report data object layout as defined by PCIe r7.0 section
> + * 11.3.11
> + */
> +#define PCI_TSM_DEVIF_REPORT_MMIO_ATTR_MSIX_TABLE BIT(0)

TDISP_REPORT_MMIO_ATTR_MSIX_TABLE imho reads better.


> +#define PCI_TSM_DEVIF_REPORT_MMIO_ATTR_MSIX_PBA BIT(1)
> +#define PCI_TSM_DEVIF_REPORT_MMIO_ATTR_IS_NON_TEE BIT(2)
> +#define PCI_TSM_DEVIF_REPORT_MMIO_ATTR_IS_UPDATABLE BIT(3)
> +#define PCI_TSM_DEVIF_REPORT_MMIO_ATTR_RANGE_ID GENMASK(31, 16)
> +
> +/* An interface report 'pfn' is 4K in size */
> +struct pci_tsm_devif_mmio {
> +	__le64 pfn;
> +	__le32 nr_pfns;
> +	__le32 attributes;
> +};
> +
> +struct pci_tsm_devif_report {
> +	__le16 interface_info;
> +	__le16 reserved;
> +	__le16 msi_x_message_control;
> +	__le16 lnr_control;
> +	__le32 tph_control;
> +	__le32 mmio_range_count;
> +	struct pci_tsm_devif_mmio mmio[];
> +};
> +
> +/**
> + * pci_tsm_mmio_alloc_report() - allocate encrypted MMIO range descriptor
> + * @pdev: device owner of MMIO ranges
> + * @report_data: TDISP Device Interface (DevIf) Report blob
> + * @report_sz: DevIf Report size
> + *
> + * Return: the encrypted MMIO range descriptor on success, NULL on failure
> + *
> + * The caller keeps pdev->tsm valid throughout this call.
> + */
> +struct pci_tsm_mmio *pci_tsm_mmio_alloc_report(struct pci_dev *pdev,
> +					    const void *report_data, size_t report_sz)
> +{
> +	struct pci_tsm *tsm = pdev->tsm;
> +	struct tsm_dev *tsm_dev = tsm->tsm_dev;
> +	u64 last_reporting_end;
> +	const struct pci_tsm_devif_report *report;
> +	u32 mmio_range_count;
> +	int last_bar = -1;
> +	int i;
> +
> +	if (report_sz < sizeof(struct pci_tsm_devif_report))
> +		return NULL;
> +
> +	if (dev_WARN_ONCE(&tsm_dev->dev, !IS_ALIGNED((unsigned long) report_data, 8),
> +			  "misaligned report data\n"))
> +		return NULL;
> +
> +	report = report_data;
> +	mmio_range_count = __le32_to_cpu(report->mmio_range_count);
> +
> +	/* check that the report object is self-consistent on mmio entries */
> +	if (report_sz < struct_size(report, mmio, mmio_range_count))
> +		return NULL;
> +
> +	/* create pci_tsm_mmio descriptors from the report data */
> +	struct pci_tsm_mmio *mmio __free(kfree) =
> +		kzalloc(struct_size(mmio, mmio, mmio_range_count), GFP_KERNEL);
> +	if (!mmio)
> +		return NULL;
> +
> +	for (i = 0; i < mmio_range_count; i++) {
> +		u64 range_off;
> +		struct range range;
> +		const struct pci_tsm_devif_mmio *mmio_data = &report->mmio[i];
> +		struct pci_tsm_mmio_entry *entry;
> +		/* report values in are in terms of 4K pages */
> +		u64 tsm_offset = __le64_to_cpu(mmio_data->pfn) * SZ_4K;
> +		u64 size = (u64)__le32_to_cpu(mmio_data->nr_pfns) * SZ_4K;
> +		u32 attr = __le32_to_cpu(mmio_data->attributes);
> +		int bar = FIELD_GET(PCI_TSM_DEVIF_REPORT_MMIO_ATTR_RANGE_ID,
> +				    attr);
> +
> +		if (bar >= PCI_STD_NUM_BARS ||
> +		    !(pci_resource_flags(pdev, bar) & IORESOURCE_MEM)) {
> +			pci_dbg(pdev, "Invalid reporting bar ID %d\n", bar);
> +			return NULL;
> +		}
> +
> +		if (last_bar > bar) {
> +			pci_dbg(pdev, "Reporting bar ID not in ascending order\n");
> +			return NULL;
> +		}
> +
> +		if (last_bar < bar) {
> +			/* transition to a new bar */
> +			last_bar = bar;
> +		} else if (tsm_offset < last_reporting_end) {
> +			pci_dbg(pdev, "Reporting ranges within BAR not in ascending order\n");
> +			return NULL;
> +		}
> +
> +		last_reporting_end = tsm_offset + size;
> +		if (last_reporting_end < tsm_offset) {
> +			pci_dbg(pdev, "Reporting range overflow\n");
> +			return NULL;
> +		}
> +
> +		range_off = tsm_offset & (pci_resource_len(pdev, bar) - 1);
> +
> +		if (pci_resource_len(pdev, bar) < range_off + size) {
> +			pci_dbg(pdev, "Reporting range larger than BAR size\n");
> +			return NULL;
> +		}
> +
> +		range.start = pci_resource_start(pdev, bar) + range_off;
> +		range.end = range.start + size - 1;
> +
> +		if (FIELD_GET(PCI_TSM_DEVIF_REPORT_MMIO_ATTR_IS_NON_TEE,
> +			      attr)) {
> +			pci_dbg(pdev, "Skipping non-TEE range, BAR%d %pra\n",
> +				bar, &range);
> +			continue;
> +		}
> +
> +		/* Currently not supported */
> +		if (FIELD_GET(PCI_TSM_DEVIF_REPORT_MMIO_ATTR_MSIX_TABLE,
> +			      attr) ||
> +		    FIELD_GET(PCI_TSM_DEVIF_REPORT_MMIO_ATTR_MSIX_PBA, attr)) {
> +			pci_dbg(pdev, "Skipping MSIX range BAR%d %pra\n", bar,
> +				&range);
> +			continue;
> +		}
> +
> +		/* Update __counted_by(nr) before accessing the new entry. */
> +		mmio->nr++;
> +		entry = pci_tsm_mmio_entry(mmio, mmio->nr - 1);
> +		entry->res.start = range.start;
> +		entry->res.end = range.end;
> +		entry->tsm_offset = tsm_offset;

store range_id too, TIO will need it later:

entry->range_id = bar;

And I saw resource_contains() failing on empty flags so:

entry->res.flags = IORESOURCE_MEM;


> +	}
> +
> +	return_ptr(mmio);
> +}
> +EXPORT_SYMBOL_GPL(pci_tsm_mmio_alloc_report);
> +
> +/**
> + * pci_tsm_mmio_free() - free a pci_tsm_mmio instance
> + * @pdev: device owner of MMIO ranges
> + * @mmio: instance to free
> + *
> + * Returns 0 if @mmio was idle on entry, -EBUSY otherwise
> + */
> +int pci_tsm_mmio_free(struct pci_dev *pdev, struct pci_tsm_mmio *mmio)
> +{
> +	for (int i = 0; i < mmio->nr; i++) {
> +		struct resource *res = pci_tsm_mmio_resource(mmio, i);
> +
> +		if (dev_WARN_ONCE(&pdev->dev, resource_assigned(res),
> +				  "MMIO resource still assigned %pr\n", res))
> +			return -EBUSY;
> +	}
> +
> +	kfree(mmio);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(pci_tsm_mmio_free);
> +
>   /**
>    * pci_tsm_unlock() - Transition TDI from LOCKED/RUN to UNLOCKED
>    * @pdev: TDI device to unlock
> diff --git a/include/linux/ioport.h b/include/linux/ioport.h
> index f7930b3dfd0a..e8a9fd653620 100644
> --- a/include/linux/ioport.h
> +++ b/include/linux/ioport.h
> @@ -144,6 +144,7 @@ enum {
>   	IORES_DESC_RESERVED			= 7,
>   	IORES_DESC_SOFT_RESERVED		= 8,
>   	IORES_DESC_CXL				= 9,
> +	IORES_DESC_ENCRYPTED			= 10,
>   };
>   
>   /*
> diff --git a/include/linux/pci-tsm.h b/include/linux/pci-tsm.h
> index c43aa3e85bb0..aef6cfb87082 100644
> --- a/include/linux/pci-tsm.h
> +++ b/include/linux/pci-tsm.h
> @@ -139,12 +139,42 @@ struct pci_tsm_pf0 {
>   	struct pci_doe_mb *doe_mb;
>   };
>   
> +/**
> + * struct pci_tsm_mmio_entry - an encrypted MMIO range
> + * @res: MMIO address range (typically Guest Physical Address, GPA)
> + * @tsm_offset: Host Physical Address, HPA obfuscation offset added by the TSM.
> + *		Translates report addresses to GPA.
> + */
> +struct pci_tsm_mmio_entry {
> +	struct resource res;
> +	u64 tsm_offset;


unsigned char range_id;


otherwise looks good.

thanks,

> +};
> +
> +struct pci_tsm_mmio {
> +	int nr;
> +	struct pci_tsm_mmio_entry mmio[] __counted_by(nr);
> +};
> +
> +static inline struct pci_tsm_mmio_entry *
> +pci_tsm_mmio_entry(struct pci_tsm_mmio *mmio, int idx)
> +{
> +	return &mmio->mmio[idx];
> +}
> +
> +static inline struct resource *pci_tsm_mmio_resource(struct pci_tsm_mmio *mmio,
> +						     int idx)
> +{
> +	return &mmio->mmio[idx].res;
> +}
> +
>   /**
>    * struct pci_tsm_devsec - context for tracking private/accepted PCI resources
>    * @base_tsm: generic core "tsm" context
> + * @mmio: encrypted MMIO resources for this assigned device
>    */
>   struct pci_tsm_devsec {
>   	struct pci_tsm base_tsm;
> +	struct pci_tsm_mmio *mmio;
>   };
>   
>   /* physical function0 and capable of 'connect' */
> @@ -206,6 +236,11 @@ bool pci_tsm_context_match_device(struct pci_tsm_context *context,
>   				  struct pci_dev *pdev);
>   struct tsm_dev *pci_tsm_get_device(struct pci_dev *pdev);
>   struct pci_tsm_devsec *to_pci_tsm_devsec(struct pci_tsm *tsm);
> +int pci_tsm_mmio_setup(struct pci_dev *pdev, struct pci_tsm_mmio *mmio);
> +void pci_tsm_mmio_teardown(struct pci_tsm_mmio *mmio);
> +struct pci_tsm_mmio *pci_tsm_mmio_alloc_report(struct pci_dev *pdev,
> +					    const void *report_data, size_t report_sz);
> +int pci_tsm_mmio_free(struct pci_dev *pdev, struct pci_tsm_mmio *mmio);
>   #else
>   static inline struct pci_tsm *pci_tsm_trylock_association(struct pci_tsm *tsm)
>   {

-- 
Alexey

