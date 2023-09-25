Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0D511C96
	for <patches@lists.linux.dev>; Mon, 25 Sep 2023 10:43:19 +0000 (UTC)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38PABl4l012852;
	Mon, 25 Sep 2023 10:43:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=XUdoET4sY79tEV/B9Ag62XK+BviDkp/Ly6AbzuRVVUM=;
 b=G9ENNjYtldt5ag7cWIsDbGlRAwQPImrEkWtkvbXJbE6cAz4zd1IAVTUvEJBm15+ZiIYa
 kkvXoYSvBBnUAz0oOaLPBJwNz7jSG5Be68MqizQvaPzssb34j3REnHLCmtmNWrElDk0j
 wpBGYfKUshqXP6lk27jAulqsYk4rmIK76/icL1/9uEXKQknHkaASllxv+xymuJbSHgux
 6W3OpKun3Qll9NMKrwOMqgm4jlCmvChg3XxmK/qs+wAQVMiVpuzBEdW1ohgk/JTdFf9l
 RUT4837qzutBbvJcWo59oLFNHZkJVJJYiYgeBusphyGwyKj/Mtk8hrbjdm2bsmGtujAX 3A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9pxbude4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Sep 2023 10:43:06 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38PA66mt039347;
	Mon, 25 Sep 2023 10:43:05 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pfacffc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Sep 2023 10:43:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kqzR+5VRJUdVM2neHCUih2P+RRVNt+WYzaTh29TBNlfN/kDui/LFEPhPwa4ORo9GVvZgD4jDklXPLy9+NsI9RjE/M0G/svWYBCrfwHCT4NEbJ3Lt3t999Bg4eLoOBbv26C+La1LWjeNQJ2ZQptCwVlLsSs+NjVlX8cbtpUAAmR1jM2GVno5LFagq0GEt67bphy1vOZCRdqiFOut2Ywqdn1P+6yYIYmF0TVsWKJbrxTEUICoHcoNZQEcP3Aq7k3UqWFMKffmC4mfWCuIrQPd08lXOTTS0DgEQ9l+KO3N2BMXvl+aytj5y8DmaAZldN7MOJma4DK9NB39J17jj18lfuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XUdoET4sY79tEV/B9Ag62XK+BviDkp/Ly6AbzuRVVUM=;
 b=R2oOkNb7QgFkESAiAML28mP4Dp5n2ac/u5MHoWmIrJkHCouxL0vHzEjZbq0GPpKmAGGL4BY+IJXiZaZ4BfApr2CiefyHVSvwYBOdsxOZPkRVZ3ZMeYPc3KHOHIjhW7gLJAWskifYR5opcMY/4GlEwUh7/O6SdKu5XQh0SB6+Em4AZPtJCa8FOgaKG7B5cCr7Pay80IoeL9+0kF0q+SeP7mW+ITZwyhnaEXLnALIRC1GzWKiTDNJ4sy9PhCW8YGOUEDT6hx2jMXWauBQTd+itCcIuk9zNmP4mym5/lkRlGpQ0reYesLUrJolkiqqEUkY78fdv4eJ4JIJc+7/29Lu44A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XUdoET4sY79tEV/B9Ag62XK+BviDkp/Ly6AbzuRVVUM=;
 b=oP8XzyXsrgtvLTHvpXaXkH1lnLPmfxCrQnd1xOkWTa8pdgCIFplUTeaqY+SwR+Y8a+po+3JlwKaVCHbrHXzVE0Jud/hql+FRn/k+EyqSMK0GmPNTklDK1Y8oo04XYK8pNzBVUPLf6f+QUW7sc+G1M8lOKLjp9krp4KEABbr2QLo=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Mon, 25 Sep
 2023 10:43:03 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::3ec2:5bfc:fb8e:3ff4]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::3ec2:5bfc:fb8e:3ff4%4]) with mapi id 15.20.6813.027; Mon, 25 Sep 2023
 10:43:03 +0000
Message-ID: <68411d25-c9be-da40-0d42-405654fef7b1@oracle.com>
Date: Mon, 25 Sep 2023 16:12:53 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [PATCH 5.4 326/367] libbpf: Free btf_vmlinux when closing
 bpf_object
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        patches@lists.linux.dev, Hao Luo <haoluo@google.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Vegard Nossum
 <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20230920112858.471730572@linuxfoundation.org>
 <20230920112906.975001366@linuxfoundation.org>
 <e7e9df6b-d3c1-0fad-1cea-94dc74dbf281@oracle.com>
 <2023092303-rotting-strum-1509@gregkh>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <2023092303-rotting-strum-1509@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCPR01CA0192.jpnprd01.prod.outlook.com
 (2603:1096:400:2b0::15) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|SA1PR10MB5867:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dd4d811-6337-4d67-d675-08dbbdb431a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	dvD9RFgSJ6yLAgiDynoDTWaKjROp6eFrWfRz++9tn9TJKbd4RIRd+VoFzlNGivm3p49wKW1K4gAyMrktS5tQI9jSvNkSpWt1/4eEQooN+1Oy0BvMVdStSk7gpQfRJ80OUkLOIHQ+blDy3yaYDUMtmSIYaTCmMyJ0D5B5Iz/JWZt7jvbFqjKjYRjN8jBlLVbtLz3D5c87wKsDbO8G32ERvdaNBPza6WrPz9ojXUZxZKM/kEO/xkCQyUU0NYVrVjTy8L877SDnVIgIZMP7Kc7tiGRM/77DauG8IuopNOOSDXmIqgtxPQfiIvLSAD4gli+TZvddXJdD+HU80ITbYO+PLWjA/h/6acGabxHj9H+qEgvzxWc+LjyU90AlcZxuWcqai5VA6OpmrTnwXr7ms8J4hEFjAA2HoemM6tvLgwV+oHppdBUlFdFmQnhfMv+lJmi0a1ThviY5EzoAfgj1Wx16MAGGJDWbFoPjwhz9fFtFJ1K/fM2hIfT6b+qMUu0Jr8T6ScsrsYP4vPhHMOh6BcPewpaILvc+kyn1T3qTxVGUEqUaJjfIhDGBGpxL/X4SAc7t5RTl4zDr8GkUwHMge8RBUH5Q845Py64GTq4RBcfg8/1A/jhPCMYDYBYFEjrRmU679NmtFiTJQlRPGQNR3LL0Xg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(376002)(136003)(346002)(396003)(230922051799003)(186009)(1800799009)(451199024)(2906002)(83380400001)(38100700002)(6512007)(66946007)(66556008)(66476007)(54906003)(966005)(53546011)(6666004)(6506007)(6486002)(26005)(5660300002)(316002)(41300700001)(6916009)(478600001)(8936002)(8676002)(4326008)(107886003)(2616005)(31696002)(86362001)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?RjloRWxwVEpyR1BnWUN2MEcxVXkzUk5QclVjSmZ2N1FlZTRkWUtGdmJqaUZB?=
 =?utf-8?B?Q2RkS0ticnhpRmp6RVNlQkNsSjJJMk1OU3Q3Wkd2TW1KdlUrbVdSVzA4cG1S?=
 =?utf-8?B?Z2x0R1pkaDRXQnpvNkdhRGZGUG5FSTBXWGYrNVJ2b2lTaTkyQlBLT3RiTWI0?=
 =?utf-8?B?NFBiNTdRUnBtMGk0WElxSi9hMVk3MnhxSnZUQTVVUlBLdTIwRGp5dmdVR09p?=
 =?utf-8?B?RTV3S1lGRmx3di9aNDYwaFRmMU1vbTI2STFGTHFtVHJ4OE5rOVZZWU45N1lq?=
 =?utf-8?B?YmNyWUxGQUtZRTRBRXNKYlZYN21WYUhBRmVKVkRkWnJscWZ5dWt1cXFudXY5?=
 =?utf-8?B?MGxmdmdtcE0wTDZkSitLRG0rQzJEYmkxRWt3WHVWemt5RjVOVlBjWHlxOElO?=
 =?utf-8?B?T29VV1dUVGErTXRnSXcvMytKRnpRUG5KODVPb21RSHJFWFpKQUtmaUNMWTZa?=
 =?utf-8?B?akwzRFhabGdzdHdZa0JvTzZZeWlxUVVsejVYNnRKQjhLeldzaWR0Sk1mMjM2?=
 =?utf-8?B?VnI5Y3F1b1BGdkJuWkYzcGFsWnI1RzJVTnVjRllrWU9KaEVHZFJUaWdYWVcv?=
 =?utf-8?B?WHQrd25FUTJkcFIvMUxNT1JGdWVWS3czaWVSb243QzZBUHhQdEZITHRnSi9p?=
 =?utf-8?B?MVJtUEQrZ0VmSXFCME9rZ3E2dTJVNjZuN3NnbUR1M0dFbjRGcnZoTnRHWVgw?=
 =?utf-8?B?SVlCVllJVVBOYWFKcTlUVVNGR3dqc0pHaVRLNVp6V3E5MjUvL0RDTTM1SndW?=
 =?utf-8?B?akwwOW1GOHdDWkM1N1I2eVZsSWhLeFB5WnZiandsMmZnTEhzWElDQkdnSElG?=
 =?utf-8?B?TDI0T1pjYWFWNDVZSWR0Sm5kSWdHQzg5V1dtYTBYYkg5UVVUNForTnJyRXVB?=
 =?utf-8?B?bTd5cEV6cXI5Z0dPUlg4RVhBMnA5RG83bHRicWxyMStlTTF0bUc5OVIrZHRp?=
 =?utf-8?B?RDlLcHp4MjFQMXpzMjFlVDlJQkVsQzk4SGZpN2gzeWFuUC9zTFRRMEVxN3FV?=
 =?utf-8?B?WDdrclBHcEpzWE9EV0pmTFhEWXVxRlVWeUFkdk9vUWlocWtKM2Nra0xkSnVr?=
 =?utf-8?B?TU1UYlh6Qlp2WGhCZWJFa3VIWVFsMVFBbjZscVZiajZIaHhGeVBtZ2JIOVox?=
 =?utf-8?B?U2huWXVyUmJyMm1wZ2VDTnpvZEpndHFqc3YwL1hJcVlkanJla3NrYnNQVXJn?=
 =?utf-8?B?SmZUMEhjZnMxMkpBQlRTUVRoQ1dCQUpNQ0dJMVpxNFNseTU5TFZYZGI0MlRI?=
 =?utf-8?B?ZXJPaVBtMUUwcXU4aVE2NlpsNUViVDM1K015bm1ONVdBdVBMQ3lrdk55U2Z2?=
 =?utf-8?B?bU52anFPQWVzWUhwR0F2elJrRFhDNXVUOHREc2NnaEFUVUppU21oZ0xyWWpO?=
 =?utf-8?B?OHV2MW51WitSNmh0cDhDR1JjdklyZytiQW9zV3NzenRUQ2lUejUzUFFrbW9G?=
 =?utf-8?B?Yk5YWWRONmY4eFpuREJpcEZXWDREZ3lSSTRRblZXL2JrMGc1RGdnU3VmTCsx?=
 =?utf-8?B?VzdLVHVRckxNaklGVTZXeTJDVm9WWHdXdUNqazV3VDNhMFJjY09Yd0l6M1g0?=
 =?utf-8?B?eDM1M29pOTJRUkQ1OTdwdksyVDJKOEU4aUcya1QweW1xNVByN2puRG5kVE43?=
 =?utf-8?B?dTV5S1F4MFpaNW4rOU5CS3BEN3l4d3U4RUZzWHJ6RlQ0czBQZE10MGJDM0I5?=
 =?utf-8?B?ZmlxdzAxTkdSbEpPc25ORzQ1aGNGWGdoZC9ZdGZrVFpNVCtadVlQOXlncXpN?=
 =?utf-8?B?c3dHcUlxOFIySlRnQW1sT0hEbWY1ekJuUnc2ajBhRzdibGlxWU9WUDlTU24r?=
 =?utf-8?B?aTN0MmNyTzRyakhFQ2dXMDA1ZVVXbkVuSkMvTTJ5T3FITklXK3ZpcXpybTdF?=
 =?utf-8?B?TGFZS1ZQK0JyS2NucllqQXViVGhSOGlVM01ycFpDR0hFZlZyeFBOQyt0azRU?=
 =?utf-8?B?b05sZHE5VnNEcGZDY3YwOWE0bC84L1hkc3YvZXorNE1xOHhZaEEvKzNmbkpu?=
 =?utf-8?B?ejhxcWxmN1hDQ25PcjlLRUszSjVaNHh5cjFVVlFyZlNTeThFUlpoSDJLT2Vi?=
 =?utf-8?B?eTUxcG9ENlBVZDRTcVFBbDVPSzBaU1djemJBWWxIQ1pNeW1tZkYzNFR3YktW?=
 =?utf-8?B?M2orNGFFVGZyR094cE5lVmI1SmRXTDhhMzRlQTlzNlFQTDhDcWYzK2tZZTJC?=
 =?utf-8?Q?aFVx6kvB6sW8Y/4xhNvRdNk=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	5SEcmFAh3XopziZUmt+bYevidJZzE9AFjt9o8jeiyVrmeMv4m6Nh1nhgITplzh4LZ1OmkagBazmT+cjzgVo+GU/bRxJfq5t/ahzVytyvfGojSilYLQNcj64+K7Z1KsnHHFJmxCaU7HDnogdDCHAwp8+8IpIjgk+fQHLOtuo7QF/nw07qfUtADTdb3mQKoQgjpJooEmAkPl4X5CkLCIMZcOWr0zJ/xjSBFuARZAF8T9dvbg3nx079kfm14W8n4Jq4QwNjC1JqL8VZH71KqwaggBS0HxF2bgH/P0sJUrRJnf63bYuPYivd2NpIoJzOwoCyGUyyfnqWR8Ksf7yN6L7N0Lr1/gYRrRyoPb8rDwZlL51yB++GL+E/MVRrfOG7N/R7kSOR/DLmYtmWVR1dbPKPGDg9iGKgOGzKGlezsI1EocCTDzUetGp1fDso096oKkdJ6/mYo4a84CO0B+5uCQx3rcgr60d7y4DyQS0iSxvtGoSC2yrtBb/G8pzYBE9kCJtnZp8e0JJmNnRFcH6L7wd48TmprrQz5T3c8U3ED4eEEBZ9b5g4swTqhV+oT9tVJ6GNf18+zDdSAUtNKJqjZy4Poi6y7SS0En5K563oQzqacCNhzOfAvhUyv+5uXeQ5PYlHpnJkmUGPtYb96ye4g1cv5PTrqtDTk9+7wpgWEhQsIWL1TfDTKYkjM10pXmPo7m4VPdNCrEcmgq3GALJT4CdYkGhUbA1RpmMVf/wiZPIZGwwy1oDbxjT/6D8veYrCdiCgfMZl/uq12cKGm8aRPBFn8OSNLtS7//QLfjlB9xIGLAjQxxmjEO+1fdeEWWA3764yC4x50AxuvUUthy8UPGQR3yXDCrK0fvqOh9n9B9sYrD0eyeWlxiuH7HIHk5Se1+O3uuZW6lMTFnFqg54r6k2tbJcyQkZiMCPmXshflFF0TWw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dd4d811-6337-4d67-d675-08dbbdb431a1
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2023 10:43:03.3268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8UOScqH1IXrVgtXLSP3eV3olob8byd3KSUYchdCDe47qpt4Gu3CyTDrtuVmFdk9rh6+d8blqt3s3VPBSUkF3jg1pqjTWkRbrxFQosZ4yeWZEguhdJ+tA0IkD93DjY+9J
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5867
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-25_07,2023-09-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2309250078
X-Proofpoint-GUID: N7XytusF2_jT1jtT1AnqBwftur7Jfili
X-Proofpoint-ORIG-GUID: N7XytusF2_jT1jtT1AnqBwftur7Jfili

Hi Greg,

On 23/09/23 1:55 pm, Greg Kroah-Hartman wrote:
> On Wed, Sep 20, 2023 at 06:58:45PM +0530, Harshit Mogalapalli wrote:
>> Hi Greg,
>>
>> On 20/09/23 5:01 pm, Greg Kroah-Hartman wrote:
>>> 5.4-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: Hao Luo <haoluo@google.com>
>>>
>>> [ Upstream commit 29d67fdebc42af6466d1909c60fdd1ef4f3e5240 ]
>>>
>>> I hit a memory leak when testing bpf_program__set_attach_target().
>>> Basically, set_attach_target() may allocate btf_vmlinux, for example,
>>> when setting attach target for bpf_iter programs. But btf_vmlinux
>>> is freed only in bpf_object_load(), which means if we only open
>>> bpf object but not load it, setting attach target may leak
>>> btf_vmlinux.
>>>
>>> So let's free btf_vmlinux in bpf_object__close() anyway.
>>>
>>> Signed-off-by: Hao Luo <haoluo@google.com>
>>> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>>> Link: https://lore.kernel.org/bpf/20230822193840.1509809-1-haoluo@google.com
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>> ---
>>>    tools/lib/bpf/libbpf.c | 1 +
>>>    1 file changed, 1 insertion(+)
>>>
>>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>>> index b8849812449c3..343018632d2d1 100644
>>> --- a/tools/lib/bpf/libbpf.c
>>> +++ b/tools/lib/bpf/libbpf.c
>>> @@ -4202,6 +4202,7 @@ void bpf_object__close(struct bpf_object *obj)
>>>    	bpf_object__elf_finish(obj);
>>>    	bpf_object__unload(obj);
>>>    	btf__free(obj->btf);
>>> +	btf__free(obj->btf_vmlinux);
>>
>>
>> This patch introduces a build failure.
>>
>> libbpf.c: In function 'bpf_object__close':
>> libbpf.c:4205:22: error: 'struct bpf_object' has no member named
>> 'btf_vmlinux'
>>   4205 |         btf__free(obj->btf_vmlinux);
>>        |                      ^~
>>
>> This struct member "btf_vmlinux" is added in commit a6ed02cac690 ("libbpf:
>> Load btf_vmlinux only once per object.") which is not in 5.4.y
>>
>> So I think we should drop this patch.
> 
> Now dropped, thanks.
> 

I have tested kernel(5.4.257 final release) where the offending patches 
are dropped. No regressions seen there.


Thanks,
Harshit

> greg k-h
