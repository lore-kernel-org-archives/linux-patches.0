Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C8D20EA
	for <patches@lists.linux.dev>; Mon, 29 May 2023 16:47:02 +0000 (UTC)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34TDO5Yn001745;
	Mon, 29 May 2023 16:46:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=HNUsnQiBCV/3npp9sVsAuKxLtSeBTFP1tWKJ+BopENw=;
 b=PNt3TYlJR6kJAcXdeX5hryb4b0fvEi63hFHrQ/6iLxOzoc16rBd6NFVNzhYPRTkPNd6M
 ahfSS9XkV4J3m3Z3hZebP+4A3HjL5cblaZz5Fk9WSSEb8wBkZA8VnZmsfCjSH9otUz43
 lTKVGV9w9A8PRNqN8DDrlbDYIv9Ii6pD4L1+NZJOQhY0gyI3+fqyyqR1qAtpjo+vzJeX
 t1cCnI1bOWit1b1A+HuDaFlKjV+rAkNnz9Ca6oBM3og4+Y7982+pmlQD+f8P8tUMC1Mc
 MXRhDogdPq2ToWCyXoKRUt9q9BVUGmBv/FvYeD0r3TNbqoHtIiumUpGmWKtjWkHPuAfT sw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhjkh60h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 May 2023 16:46:51 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34TFFh3N019752;
	Mon, 29 May 2023 16:46:50 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8a30q0y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 May 2023 16:46:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G7eZVwikpIqxC+FWO7j5M0/18oX9Hb7jo7CY7jJ5dKyUtKU4veVkL1wKyPgPiGBuuF0hXIuA7VpitHEev8hcBCcFGtYcvA/Z+PpvyRowEdsKuQJVucHGfSy79fHGEAvk39MpGFDZJdv/0twqUlHR6QFhTj6HaJEE/4ikkBfwT/MpbNo2uXzWa8ZTu6dYhP9Wos52pkitJvKjB9/trrlr3kWOPFBo6qGPLEmhHeVs9UNsxQjMpnV1Ppn9TQ4jonvGe93N+XhI6gNukE+xOoFNv3jXCwHH1pIHa8j7uWMpl+HM05DvxT40Lzpd+Pp49btwl42whWfOLjO+9KD33xYl5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HNUsnQiBCV/3npp9sVsAuKxLtSeBTFP1tWKJ+BopENw=;
 b=NKvdFJ60HGjr9TCGVY46EHK65Re3I1ab1N6b2SeNEY59fkt7gh7ubyaDcOYZq3eJxmXbDT3WpuuYYko4BZjLwlGtc8V9OLhkjbcJY7YwbSJzw81fox6CaW+4a0mrjnlQJecXscjgJAgbAIJ5Jt1cbqxXGBAGnwp9W5jXQSKGnL2u39YybmaPJHk1C215yTL4pIiD0ZBAlfeFhGqAANBCnTZRnAqku08UcxOfYiCWpu0rXmyl2OuW6+AlNNsHaXiM+LhO6WRBQQzLwa9U0GQn9FtAyTmu2nWc6jVnehlYHL/ctZBvtIfGTDAGkGnCM+mCxWQOKP5fd2eQNb+HX1q+Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HNUsnQiBCV/3npp9sVsAuKxLtSeBTFP1tWKJ+BopENw=;
 b=PZvg3kYsUQWw9C9M5TVQp2rURzfsI5RKJJdsPFPOwwE7SH+x8Bv2xRvq6TuzULb0JyKnkx4XO1TCy7+qN8L9B941h5rFwDGpCyAzYbAI7InN522eOChTr3Fj3FAthupvTnylPKyYeC3uDOIIiDJDgsRfRlPsVpwHlCIrOugyE8s=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by DS0PR10MB7125.namprd10.prod.outlook.com (2603:10b6:8:f0::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.22; Mon, 29 May 2023 16:46:48 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::68c5:330c:d234:3834]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::68c5:330c:d234:3834%7]) with mapi id 15.20.6433.022; Mon, 29 May 2023
 16:46:48 +0000
Message-ID: <2537a271-acfd-21c5-8dee-84db597e5ef6@oracle.com>
Date: Mon, 29 May 2023 22:16:36 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH 4.14 22/86] null_blk: Always check queue mode setting from
 configfs
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Chaitanya Kulkarni <kch@nvidia.com>,
        Damien Le Moal <dlemoal@kernel.org>, Ming Lei <ming.lei@redhat.com>,
        Nitesh Shetty <nj.shetty@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
References: <20230528190828.564682883@linuxfoundation.org>
 <20230528190829.378384329@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20230528190829.378384329@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYWPR01CA0015.jpnprd01.prod.outlook.com
 (2603:1096:400:a9::20) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|DS0PR10MB7125:EE_
X-MS-Office365-Filtering-Correlation-Id: 25505899-ad73-471d-3ce0-08db60644b20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	2LLwWF3omDW23ZpkmF46SC+StlsgsEpmecrXR+RlfHvPIyIEuUeR5yPqQ+vVbYQehFQLrnXefjGuriFKAaJFCT92VJP/Pt79IG2MOlPi1QLvdWQ+AuPlF29YXVrGqPUijOZXu6YO2Lkict6fsw9nQC16h/FqQXtdrCoC5RZBp+4PPSWiz2eG+LRYWMljpNA/ELmd9oMSvRLMBJkXL4p0eo1rBS+bb27h7OHba1oKvNTpA0SuEundl1mtaHS+8f/9W08E9r/OvEldtg9RgnwNFwXTKEpu2g2Yv6W8QP3RJ3fmiVqks1DNlfa2N8Rqb8H73/CRcqtTubPD8fruWR2vTgERoLtXynLVqiDP0ioLRMW3bzBqSbZtwp5Zli2abCAXPUoQ8Nmlqs7iAwiRcOPWQbTjo8ohyYWk0dziCe9OYk8Q2sL0Lm6Jx+BcSh8FWzsCVMFlgyLHNxyUl0uUGqIXtUm34OO2ZcmQB2u0PG+CgoDaKLwQLEOCXzMz50bPDTcYUBHhX+WbP0osAk9MLbutsiVzMI1xI95Xby+aHLbMWA312s62phnrDxlL9YfUCPK8nAkeEQBag0sgXYZnKsi+NsGZw3Rhh07opvptxyB2oIYLkFdoHI5rMJ6yUVDYnEPVNBCys35C+K8NOqm5gnAGSQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(366004)(396003)(39860400002)(376002)(451199021)(966005)(478600001)(83380400001)(5660300002)(186003)(4326008)(86362001)(6486002)(8676002)(8936002)(2906002)(41300700001)(38100700002)(31686004)(316002)(6666004)(31696002)(6512007)(6506007)(26005)(66946007)(2616005)(107886003)(54906003)(53546011)(36756003)(66556008)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?QXZUdGtsRzlMSXpvUnR0enFOT1AzVlRIaURaRGZ0YXJIanFrSTl1MlZkYncr?=
 =?utf-8?B?OVhLTU80WnBsaTZ2MVRENDVUZ2tmaThucXdaTU5aZHVSSG9ibzExOGhiTmZy?=
 =?utf-8?B?K0RNVUkvd2tUeXBmQVpuZGpmNmJyd1ZIellyQXdkUTdleG9pMWUwOXZtYXl5?=
 =?utf-8?B?ZkJROXRBaVcwa0ZGSlIvQkFxOTZ0ek40Tk56MzdTWmZKdmlRTll4N0pWTTlX?=
 =?utf-8?B?U0dSbnNsWk9kTEdWY0xwd05RY1hvc0NES2JXRmdISHQvR0ozVkMwdXdCYzRY?=
 =?utf-8?B?MlI1RGxDUVRrdjdnL05CTVovUDlWVlZ0eUpnNVg2amViRThBTHc5NCtCZUtp?=
 =?utf-8?B?NEtjSnNHRk1VVzBKS3dHQWI4S1pJQ01iY1d1NFJzNURNa3h2WWNSQk9yb1dK?=
 =?utf-8?B?SHdSbzNnZHFabUxoeEJMd0VDcXo4WFQ5ZFczN3dOL0IyOGYwNHNmcTQ3andN?=
 =?utf-8?B?T0NaQTFWYk5kd1J6eExCTW9xWDYwVWhKUFJ4T0FNVE1LRExXWXdBWnJ4bHJF?=
 =?utf-8?B?MERIcjJEaUJaTkZlMm04RVVsWGtVUnRnbFRmVWxTa3pwaUNtazFYTnpjNS9H?=
 =?utf-8?B?OEM0N2hjaEU0djI3dUR3UzZoUUt4RXJMTDQvTTRzT2daRFd1YzhNM3UxVDlI?=
 =?utf-8?B?T1drU201Qk84cFVWUDU2NUlYWXVTeklmVXRGSG1YV0pyQUlLTG1IM3dROThI?=
 =?utf-8?B?SDdLY0JndmZ0QUxQclh0YTlvYnVZeEZxRmlXT3kvbkFsL3c4V0NVL1ZybTB2?=
 =?utf-8?B?Q0NkQU82Szl0TGtHZS9jai9od3NMTzNMbHNWVU5JWjBoSVB1NDZMMUhZVFI5?=
 =?utf-8?B?Mk9IMVloUUFmSVRoYXNPUHl4OHpPMUVnRE9NRFB3QVhoY0VXZ08wS21aTGVU?=
 =?utf-8?B?RGtzd2R4N0JTTzU5eUpwdnVTM0ZQREJrajJ2dGxmQ01tK0JER2JLY3NkZnJU?=
 =?utf-8?B?RFdyT0M1eDh4ZGZZMlBJTitPT0c1M1FBSTg4cEpYbXVNd2lXV3NqVWtBNW5s?=
 =?utf-8?B?dUpUZUozUFErTmRFV09HSU92RzVZTHFEY3o3UVNHS3M0dDUrbTdLMUV2enpz?=
 =?utf-8?B?LzJQT0VDaVpQL3FWSUI4ZnVBN2c1NkhpL2ptdkx4TE1uMVRxRkMxUW5HbEx3?=
 =?utf-8?B?U2Q1K3NZMDZPRlpIZDNEREgvZDlMbC9Ld2Fsa2VNSW53bWo4c0tYWllRVW1l?=
 =?utf-8?B?dHJxV01keE5lNVMzMVA3NnI1VENBcmR1bWJGdUhTUThBN012VzBwTUNEdjVx?=
 =?utf-8?B?V3Rvc1lscEQ4NWtQVHk1N2FXa1Y5OU90UVdlRVZ3bHkvcThJRXJpRk5JTkEr?=
 =?utf-8?B?OWFpTzk2VlYySFRjdUlNamt6cjJxSmpmSjJGVVhVRlVieTFmOWRDMnZMVWxN?=
 =?utf-8?B?Rk8yUm9qc0ZjdWtObjRHZVRDRVpWS1F4aXlpbStWSThqWkJ0c1NiS3VWRkd1?=
 =?utf-8?B?a2Y5OXpOYWNXSCtxaXZ6a2ZqdnYvOHhvYWZyT1RZSnhpZzZPYjRPZlJhY0tK?=
 =?utf-8?B?WU1oWXQ0V0YvOUx2YWxnTW9ZdThLRVRwSnRjSG5WOHJKMHpLUnF3WVV2V2to?=
 =?utf-8?B?NGczSGNPb1VMS0ZqUDJDcUNkYXNwZDZna1Yydm1acUVsRmFZSXVGUjExNnFn?=
 =?utf-8?B?NzI2NWxQNE1GT3FHZytidlp0dnE1dVdpMXN6SkpMaWMwcmJwN0MwOEF6cUZT?=
 =?utf-8?B?MW1yU2p3bzlqNzdUZ3cvWVpxRW5XSkl1U2M4R2dhUzFBNWwyV0c2S01wcGV0?=
 =?utf-8?B?WUlTYjlWWWg1NFdobCtuc0NRZk9pK3ZQWkwvVE5iV2VJd2NCb1RmYUJ4S3Zh?=
 =?utf-8?B?MFJuc1hsMDRraDk0MzNjUitUcnN3cUw0dlJteTgyVHpPWjM0Qk0zSE5hVTc5?=
 =?utf-8?B?YVB6ZThsdnZtV3lGZ2pHYnhXQ3lKMzNoK0V2TlNkbXQ3MXZUQUhBY0d5WHZl?=
 =?utf-8?B?dmJXNVhDRHc2SXArL2VOY3RsMVlPRm96Ym10UlJtWldHK0xzZmppSU1iRnZH?=
 =?utf-8?B?UjFVc2NSbXVOYkhXbDZqZ0dacG52NlVIZFY5Zi9OQkU1VDNnMkN3SktIN0VZ?=
 =?utf-8?B?WDFZbEErTWNzZmlwdGtmRkNjTmgzKy9HbHJpbnNyd0xqRnFQSURxU081Y3M1?=
 =?utf-8?B?TU1LKzdDaEVJM0dOVEx0OGlkekZrbTNHSEUxbTBhelZJL1dPV0pZWitoUXh6?=
 =?utf-8?Q?egS1JiNqSHpGZXHdt2IJWeA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?utf-8?B?ZVBRcG1pd05nNFlXMXB5VlJJYTFqVnJ1dDRmTGhiOUlhNGRPc1ZveDVRc0lM?=
 =?utf-8?B?VXFEM0g1RTNBd1BFNFZHd3FHeWp6aTVaNU5LRnRKcm0rNHpKWXF4Q0RCRXBv?=
 =?utf-8?B?dTVPQ3JLaVZPRmllUHBqNElOLzFKREhZRFpQcjhDRkl0L01lM1JBZTlYbHlE?=
 =?utf-8?B?bC8zU29Ed3VpODZJbnJ5a2NWdUJxajNlZzNaRElQMmhPV0JsQ1MxNllHa01U?=
 =?utf-8?B?UHN5SnBwNDErM3NXeEtSalkrUmR5eTJZcXhGNnRXY1VRQ1VBSFVFZWhlcWcv?=
 =?utf-8?B?VEkxaEd0UHdrOVdWSFAvOWxpOWYzcWs3Q2hzY0VqZW1mbVFOQ2RFMXh5Q0Jq?=
 =?utf-8?B?NUtzemd3SkxNVUs5U1U1QnJ5S3FCM3IwNjZaYWFXZ0lyOXhhNmhEamxXRjhl?=
 =?utf-8?B?aytvRDZwVWpHc2YrWEVobjJKVEdZU1VRU050OHI1SUlKcFgyNmVBenk4RG5N?=
 =?utf-8?B?cmQ2T0pQNnU4cm45alBiOFU1ZnVaanBPMnlZSTYySFd6Q0VVUzBCNldtQ0pZ?=
 =?utf-8?B?Q1lMNGs4NnFBTm91dnh3Z2NnQkt3UFVPUXlZYmZ0cVBZL0dMcGZUMGVvdSsw?=
 =?utf-8?B?V1p5cjZ5cGVGTWIwY0phOHR2MzE5ZWMzdWV0OU9yeDh1dCtzTHBSaHhIcWhB?=
 =?utf-8?B?cWJldUp5V3RKTVF3cEptYS9zYk5RVk9WdWdGaVdOcXZlbmxhejZIRHpqWGR3?=
 =?utf-8?B?cEtIN3hDY0ZPa2RPdVNCQkxMODZzRlRyOUxsRFN5eFF4SVIvbTN1bktZaURW?=
 =?utf-8?B?dnI1bXh1d3VtTUtiUVJTTTFSMmtUdUtnd2hiV2FnTXdQNlVIT1NJM2VmRHFH?=
 =?utf-8?B?Wi83SUlrVjFucFJNeXZVZW5zT0J3UVprZXZ2eE82VkcwZ3dpUU9kdG5zN1dL?=
 =?utf-8?B?RzBnUXFGVHdjTWxpMnNYUXM5cTN0eHhWZUlEMnpZamhEaTd5S2hNeUl2SUMx?=
 =?utf-8?B?OUZMeENMRkR4S2IyTmJzb0xJb242RTVBQlZSMWtDUGRFMVczN2tvUkRiWHVL?=
 =?utf-8?B?NUVPc0xjSk8zYWFHcFFObG4vZW5oVUpxTysrSVIyVENmcXRoaEV1bjY2UHdS?=
 =?utf-8?B?akJmOHRSQzYrdXZjWXdpQXVVWS95NGxVYkgydUlGdzl5MDVuVDl6bEpja0JY?=
 =?utf-8?B?RlA4ZHlMVWpDeUpocEVuYXlBb2xPS2JSNmx5M1RJNTRrTW1xakJuc2ErMVor?=
 =?utf-8?B?aHhmeUFKckxTSnk5L1JvdEVCcHJ0aGNxdXdvd042aHhXVXlNSUNpeHlwbElM?=
 =?utf-8?B?MUE1U1FwWjBhdlBoNUhEa2NqTXVnRjNFb2hPaFNlUS9GckpyYkF3emtkYzBB?=
 =?utf-8?Q?gxt5xcxTF5LGuEcKz0nL8o+45l4lfOUB4y?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25505899-ad73-471d-3ce0-08db60644b20
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2023 16:46:47.8990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B5NEYcrkqyzQnM5LQw6Ldj2rzzhjeRt3w/21mzcFk4FiXDEtrwY/PMLJxwjpCckJ8/FtLK49sbTUQkxOU3FHdABQ2tHob6EFOVDr/R1zmvqa7S8Vn4oF88M+Z05KsSqQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7125
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-29_10,2023-05-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305290140
X-Proofpoint-ORIG-GUID: D2uusE37OMdUdldW1dOfTYyADQgkqH2N
X-Proofpoint-GUID: D2uusE37OMdUdldW1dOfTYyADQgkqH2N

Hi Greg,

On 29/05/23 12:39 am, Greg Kroah-Hartman wrote:
> From: Chaitanya Kulkarni <kch@nvidia.com>
> 
> [ Upstream commit 63f8793ee60513a09f110ea460a6ff2c33811cdb ]
> 
> Make sure to check device queue mode in the null_validate_conf() and
> return error for NULL_Q_RQ as we don't allow legacy I/O path, without
> this patch we get OOPs when queue mode is set to 1 from configfs,
> following are repro steps :-
> 
> modprobe null_blk nr_devices=0
> mkdir config/nullb/nullb0
> echo 1 > config/nullb/nullb0/memory_backed
> echo 4096 > config/nullb/nullb0/blocksize
> echo 20480 > config/nullb/nullb0/size
> echo 1 > config/nullb/nullb0/queue_mode
> echo 1 > config/nullb/nullb0/power
> 
> Entering kdb (current=0xffff88810acdd080, pid 2372) on processor 42 Oops: (null)
> due to oops @ 0xffffffffc041c329
> CPU: 42 PID: 2372 Comm: sh Tainted: G           O     N 6.3.0-rc5lblk+ #5
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
> RIP: 0010:null_add_dev.part.0+0xd9/0x720 [null_blk]
> Code: 01 00 00 85 d2 0f 85 a1 03 00 00 48 83 bb 08 01 00 00 00 0f 85 f7 03 00 00 80 bb 62 01 00 00 00 48 8b 75 20 0f 85 6d 02 00 00 <48> 89 6e 60 48 8b 75 20 bf 06 00 00 00 e8 f5 37 2c c1 48 8b 75 20
> RSP: 0018:ffffc900052cbde0 EFLAGS: 00010246
> RAX: 0000000000000001 RBX: ffff88811084d800 RCX: 0000000000000001
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff888100042e00
> RBP: ffff8881053d8200 R08: ffffc900052cbd68 R09: ffff888105db2000
> R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000002
> R13: ffff888104765200 R14: ffff88810eec1748 R15: ffff88810eec1740
> FS:  00007fd445fd1740(0000) GS:ffff8897dfc80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000060 CR3: 0000000166a00000 CR4: 0000000000350ee0
> DR0: ffffffff8437a488 DR1: ffffffff8437a489 DR2: ffffffff8437a48a
> DR3: ffffffff8437a48b DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Call Trace:
>   <TASK>
>   nullb_device_power_store+0xd1/0x120 [null_blk]
>   configfs_write_iter+0xb4/0x120
>   vfs_write+0x2ba/0x3c0
>   ksys_write+0x5f/0xe0
>   do_syscall_64+0x3b/0x90
>   entry_SYSCALL_64_after_hwframe+0x72/0xdc
> RIP: 0033:0x7fd4460c57a7
> Code: 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89 74 24
> RSP: 002b:00007ffd3792a4a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007fd4460c57a7
> RDX: 0000000000000002 RSI: 000055b43c02e4c0 RDI: 0000000000000001
> RBP: 000055b43c02e4c0 R08: 000000000000000a R09: 00007fd44615b4e0
> R10: 00007fd44615b3e0 R11: 0000000000000246 R12: 0000000000000002
> R13: 00007fd446198520 R14: 0000000000000002 R15: 00007fd446198700
>   </TASK>
> 
> Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Ming Lei <ming.lei@redhat.com>
> Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
> Link: https://lore.kernel.org/r/20230416220339.43845-1-kch@nvidia.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/block/null_blk.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
> index b499e72b2847e..38660b5cfb73c 100644
> --- a/drivers/block/null_blk.c
> +++ b/drivers/block/null_blk.c
> @@ -1780,6 +1780,11 @@ static int null_init_tag_set(struct nullb *nullb, struct blk_mq_tag_set *set)
>   
>   static void null_validate_conf(struct nullb_device *dev)
>   {
> +	if (dev->queue_mode == NULL_Q_RQ) {
> +		pr_err("legacy IO path is no longer available\n");
> +		return -EINVAL;
> +	}
> +

This patch introduces a warning during build:

  drivers/block/null_blk.c: In function 'null_validate_conf':
  drivers/block/null_blk.c:1785:10: warning: 'return' with a value, in 
function returning void
     return -EINVAL;
            ^
  drivers/block/null_blk.c:1781:13: note: declared here
   static void null_validate_conf(struct nullb_device *dev)
               ^~~~~~~~~~~~~~~~~~


The commit message explains on how to reproduce the bug, with my 
CONFIG(CONFIG_BLK_DEV_NULL_BLK enabled) I am unable to reproduce this 
bug on 4.14.315. So I think we can drop this patch from 4.14.y release 
as it introduces the above warning.

Commit 5c4bd1f40c23d is not present on 4.14.y, which changes the return 
type of this.

Given that the bug mentioned in the commit message is not reproducible 
on 4.14.y, I think we can drop this patch instead of taking a 
prerequisite(5c4bd1f40c23d).

Note: I don't see this patch being queued up for 5.4.y.

[Thanks to Vegard for helping with this.]

Regards,
Harshit


>   	dev->blocksize = round_down(dev->blocksize, 512);
>   	dev->blocksize = clamp_t(unsigned int, dev->blocksize, 512, 4096);
>   	if (dev->use_lightnvm && dev->blocksize != 4096)
