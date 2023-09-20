Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2A837162
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 13:29:16 +0000 (UTC)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38K9sRrb007737;
	Wed, 20 Sep 2023 13:29:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=+pb4FziG/+9KvH3wJEMYj7N5TikDHdqMRzvLlHd6jEc=;
 b=AConn3zww41lFKosbYIrkmhF+N92KFm/A6aLKs9Edjh76BcN3ym7LOAhPPON5RFeZzfr
 2JsWpRpH7lQSPaYqYTIEHDS4TlnGOFtG9CRzVIg2SQdQxtp/zKb0/tcpBYJP98Czu090
 Twoas1cuH4hTxfxj4Z8EyZj4pmEEAppfFqV6sqbPsQlYa3LTKPnVrKDKkvhIH82SZmUD
 7tCXXwCpfZhKkT8aowdYZN6CSUszZhByBTVoWvIdobIspnOydwQA+hDgUzF+HjJdXQ38
 SbNTm48pflXI4XV4JgR+Gar2QAVXuKb24tNP9lClFcW7gH9BYDi4fVY+wFVi9VYUuJlL OA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t539cqcuq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Sep 2023 13:29:02 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38KCn0R6012048;
	Wed, 20 Sep 2023 13:29:00 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t52t7bq1t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Sep 2023 13:29:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dvJ/FeShwTFjqpKOGbAPII7DwS1yM2u2MKhOTArHuDs1m8xk706LnAcAwUPpVaO8iTThCgahKbWW9Ucy+8abnE7WcZmV80x4s4wCOA/OOsI483YqvzB17dsp2kkncTsdWtebS+JwWW28JwKS3oEl8p0otQHg1piC0lhwy5E3VWkYy9770z/uFX3bnwM/+kPOnPBlCqXuEu4VUSthcP85v4CRPzUk7vgo4vDH8jh10iYZ79qNkJTw9yhLB4Hu+ObXVJaUDgo7UM9JXaYipfUBMGnsfQDjotdvO2Mzei/UwbYMU0IoaS6mIkhTYthnIqbdWe88xXjtyCbmYC6iHV8dvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+pb4FziG/+9KvH3wJEMYj7N5TikDHdqMRzvLlHd6jEc=;
 b=cKI1tMfJ1V3TQupjzVAoh9XDYrIXpG6oze+gR61YJUkwCQ2G6z4uOAaLma0umQmgFegTCDIl/bshGW1VkIFPO+pyrWGvtQP/sZHXAbvNrXbsvcDaSMj3vjzZY3CaD31cHA1n0gFOw4mlkprA3OvADyb8+o7bSPP30xGhqDJGHJ6k3dRhLuA/H1b+N5xuo/0Mu6lOHrhMDJc5f1noSU8M/e0y3kJGcf/t65FNoMYC4qxpPDrReN+f5W+WjqAdEYGeR2oE8ALw+LXJWIG4OAR7ihYh6zJePPz4uoPQEnEhGW+VQ8SBU+UVFuF4k0/GwhsMABYUwW8RLDAt+Qx31dCxcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+pb4FziG/+9KvH3wJEMYj7N5TikDHdqMRzvLlHd6jEc=;
 b=OjrB5GrUrGiNC9BDNWZFhdwCstV893yzqAknfGK+WAI8hbVTXUGUkYDO0agHWBdV4n0HPog5543iNcpU4VZ4EJkokGl3lLwc9ykQirJOPmrxz670CoKD0LJouJoCn1RzbccOqrURDORMvjyewcqwfX0/Ngvx+q5bjXrbd41lD5I=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by DM6PR10MB4347.namprd10.prod.outlook.com (2603:10b6:5:211::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.27; Wed, 20 Sep
 2023 13:28:58 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::3ec2:5bfc:fb8e:3ff4]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::3ec2:5bfc:fb8e:3ff4%4]) with mapi id 15.20.6792.026; Wed, 20 Sep 2023
 13:28:58 +0000
Message-ID: <e7e9df6b-d3c1-0fad-1cea-94dc74dbf281@oracle.com>
Date: Wed, 20 Sep 2023 18:58:45 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [PATCH 5.4 326/367] libbpf: Free btf_vmlinux when closing
 bpf_object
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Hao Luo <haoluo@google.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Vegard Nossum
 <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20230920112858.471730572@linuxfoundation.org>
 <20230920112906.975001366@linuxfoundation.org>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20230920112906.975001366@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0201.apcprd06.prod.outlook.com (2603:1096:4:1::33)
 To PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|DM6PR10MB4347:EE_
X-MS-Office365-Filtering-Correlation-Id: 64585213-c7ab-4e79-8fba-08dbb9dd8b4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Wq5dN8i9xMo6td0jf98Vlwdwcuo3UUE+TPej1w3wfJN51OAYR16cMWyKYaYYtbhP7akE16dsbtB6t7bJfZ21XwaBsc1Ck6do7F0X3KmxyxhrD49ErMPoAp070Qzslr4M7h1Rast/wBc1vELa/qpqZFw0ThietCQmkITF3zpSRq0fEpnvQ1WRjb+nsfkvmNdXRVoLnPAFzneDYsV5020Kc8/Z1eiPFj1rS2GpMzug+shxs1P+MrYacTTE7RdfsW0ePWuIGQC3+1T8knDYzGOQJGlZ6hMlxt996lBZTbFIP5KiOkdcHMw86Dhr8B8QQctyso7h1bGxN5jnQbyTCTZBGkN45raxmaWxMvfVm4ycdqoWfFHf7CbcfFm1zEKslg8myLEP2c9wSm2SU4xF6KGBL66QmzHHAARPbUTOv0DWMxQ/HwwsFtFQzcGqnLDAVU+D0lPx/w4Zw8X+w/zEdrl3iCGxjl7U78X/X8sY13XIOlxcwtQY7KcMW9wzCa0shoblqfPRsBRZMNKCSh+dwJIoIJecvPVogwzo1FWx029BkQpMyv9FJ4kcN8Y76jcgLmxMDqmdOqDTKxrXB07Yyq8doWKunBJ2pCIcXO/OWqg0DjE11IL8ZXp6duiC79674WBh69ZBvrSI0WCUyyM0KeNiOQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(376002)(396003)(366004)(346002)(186009)(451199024)(1800799009)(53546011)(36756003)(6512007)(6666004)(6506007)(6486002)(38100700002)(83380400001)(86362001)(31696002)(107886003)(2616005)(66476007)(26005)(110136005)(41300700001)(66946007)(316002)(66556008)(54906003)(478600001)(2906002)(5660300002)(8936002)(4326008)(31686004)(8676002)(966005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ZTVsYjVEU1NhQTEycGRibmdJMS9FRUNpamI1TENFVnJPK2JIcEswZjVCREdu?=
 =?utf-8?B?clpZL3V4bUtML01YZ3JUSUJ5WDA2YzQxclVFR3FBVmJiTUdqMHZ3NnZaK1JG?=
 =?utf-8?B?WEpUYWo1MGh0LzlIS2ZKWDNLNU5DY2t2T3NuMjIzS3dtYm4wSHNJemw2a3lB?=
 =?utf-8?B?elVpVVluelZIS3FicTFicTZqMFg4ME1VOTZWYWMrUHNKYnVBZmxxOWRONkRG?=
 =?utf-8?B?VDdYQ2pvaW9lamJyd0Ywb3ZIMG5yYncwdU9XeHFiWnJBOUlvcVl5alhCUTdU?=
 =?utf-8?B?WHU1c0ZiZVg2ZUMyT2xiYnk5Zy8zQVlLMXpIRG52d0RvVFhqT3hRU1hQNHU2?=
 =?utf-8?B?NEV5S09VYUhKdHJJQ1lWb2NRa1VGcVo5MXZyUlRSMWl2bVpxOUJOR081U205?=
 =?utf-8?B?bDdBRE41SWlOcDNOZDhzdVlNR2x6KzV0d29Ha0dWdTRaUysyUDlZNHVnY0Ev?=
 =?utf-8?B?WGlnWlhZWWhDSDlnRG1XQWpjNFJ6aTFFSVZqNDFjMkRlWGx2N2NUT2RPa2pj?=
 =?utf-8?B?aVR1cVE5RVZZZi9SU1NqMEk4VjlQd1daLzJibWNkOUsxOGtsdGZnQ3BnQmVI?=
 =?utf-8?B?MzNKQ09oRHg0Q3VrdHpPUnhKZ2VOOHI1SjFVOVliNmtyRU5Dc1hmdmVId05L?=
 =?utf-8?B?eWlBVVMzMFpMOWZPWWVJd0h0TWs3RFFtd0d4UENTQ2g2eWIwNTUzRHhoR1pT?=
 =?utf-8?B?OWZzQmdOR21QbzZkSGpoQWdxMXpwRlFSbUhLUHlVQkFTR2VQbHpJMFdsR0k3?=
 =?utf-8?B?L3BPenZDVTVoZW4rdHFSaVAzNGlMUVlneTIzcDh5WTRnUjljVG1pYTZiQ1Qx?=
 =?utf-8?B?cWJiSEdpQ3B3bG9OTnhkejZVYVlZNEMwNGw5b0s0NHp3YW1qRktjL3lpcDJs?=
 =?utf-8?B?SXpMNng0eFFVR3pPbSt4QzUxOEhPNlJMSitNeXZUWE1PVmpxWXBMSnRHQVBI?=
 =?utf-8?B?aDhtNlVQTStzZmZIV0E0dTJtL1ZESTg2UUtxNGxLU3RabkNCL1NINW1mT0RD?=
 =?utf-8?B?dHd0ZXc3MmR5UzdhMDQya3p5SXdXRU1EeldDRVRIdTNtSjViSi81cVVBNUUv?=
 =?utf-8?B?MDRLMzdWS3ZmSno3QlpNOVc4MFZXYVlrNmIwTWFXZlRqcFhrVTVjTlNoc21m?=
 =?utf-8?B?NjZqY1RkOVlOVE92QStBYW9aZ1VWZERKVXhNcXRXbEN5RmxpUUE0SzdkcUE0?=
 =?utf-8?B?eUlhRE5PV1IzTGs2aHpCS1VOeHI4OGF1ODFsaUF3ZGpaNmtOd001SjdSMyto?=
 =?utf-8?B?cVJOdnhIdzlPcTRQdjZwUnVleEJDMmczeUtFdGhZOTY3M0k1SXhlL1R2MndO?=
 =?utf-8?B?aTVtblVBMFovS3ZrdVh6SGE0bXhSSktXT1pHQzkyeElJTUYydnJuVndTcHJV?=
 =?utf-8?B?OWhOblRHYm1hYW5oVEVEcVlaYnFMcXVaa0ZnNko5bkdHREFXUlJheDhLeXJC?=
 =?utf-8?B?cEU5amhSSFVEbHdQTzYrclhWOEJQUVRwczNSVURodE95RXNuL0ZtQkl4eWRY?=
 =?utf-8?B?ZVZrNVdScWNQU2w0bm9TdHVTNTlnMTU1VG5TaENVTkNoQ2xsRkFuNFByb2dr?=
 =?utf-8?B?azJ2LzJEUnVHdjlCaHRwQ0tUeU9GaUNrU0xUOEMxazFPWXFyVGprOUhiUWV0?=
 =?utf-8?B?ckdhdGtCeDJLSFNlU00rWHZNSjNvOGlDL0YvOHB4c2lwcDFTYTgxWFk0NCtl?=
 =?utf-8?B?ODZGdjVHWlVCdTJGMHpFL1M5SWlobXpGc2lHMXB5K0Z4Y3pIWTJtbDM2S1RV?=
 =?utf-8?B?ZXpsVnZQRDZwOEJ1Q3ovbi9lRDRjWEgrYXJKZVh2RnlBMVRIS1gydFpBY2FC?=
 =?utf-8?B?TkV3WHFTVWY2T0JBU0ZmU01TNUc5TTNndVlxVU5Cc3pUTXBSdGZaRTVwMGFv?=
 =?utf-8?B?cGIzSzlGbThtZWIvalQrYkx4V2hlbEVPTU4zUUV5NG5xQ0xZMzdqdGd5dHRk?=
 =?utf-8?B?MDF2UDVZQTEwK0t0NDJ3d1laNENONGxJUzhLYjVtRWtGWUJZbUVHY29XTEpy?=
 =?utf-8?B?RXFUYWxobEh5WEN6YVNIa1ZjSjBpb1NUTncrSVUwZEQ1akNTSTZIYzY2djNj?=
 =?utf-8?B?VjZ5c3Z4a21xc2x3clh3ZFh3WlNqUUhwQ0ljQkFyMGthVktlTDVyTkxnbUdW?=
 =?utf-8?B?emFLdklrWlhWT0ZuR2Y3M2p1ZWNnV0VlNUF6ZjcxOWhveVlHOURXcFZMZkhi?=
 =?utf-8?Q?pIB+OiikDAKkW4wQ5WNNquY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	eiwfL24ALNqVgbpztDSabvvEhMqzaKKz+gpttu0WHm7nZgV3vkEGk0fXqK2wMK+WdFrlXBC5BNmAURiVYPu3x3XsQBuqxwU9LzYPl7hL5LR3BjDCUgkLmQHDFdH3Rp582CoQ/3i3TQ7fyF9A6d8ecgfQSBeCvcWGBhyvboDLbRl8htxqBFuTENl6jZCmKDEG4kn9I69Qbe60NDAdedHejml0sNX5wNihrGD/dO/xAdiTmXsD6t2wtGvoY0TJjL9LNFBnbaccV9/z7utSLxavH7zPpkgidD2U0NwKz2V2Q1JDXwaAIJkkC/K1rCloGTsFQqjFvyhjY4Kk3lKkvGbrpLIauzmSt7yxHdQmRstciNU34pPh8hJ5n9Wk/O2KJvQoBeF+jnQjbWjOD75FcdcAuWmDUVNJQFQXeY5Wn7LeXaDYGvD7CCBAOlkbfqqYTOKXEQvHpTHq6DnmoINjkP51jJhecc8mU/Zcn9/oqgv9WTNSK699sapEK4+SlSOgHxTZdqgno+0t/IN/wkmbVQ5saHAN5B5NvYytRreiifJq9KbTiGNVPNMyf59qvJC1p/khHnPYFdolFyaViXwxDAQgbtLNXC0pauxM50Ry36XuhT3rocFM92y4nO0hSRgHG3i/tZPY3NJvXA8Se5ZblIwE3qV8QJOUe1NuqgV5py9O3jf9Aq0x7rW8pqaShZg0PS76JEb3yHN/8Bs4s79YV1Qny79q4V/fQag9Yik25abKRr6sBPoG8c85ZhvF8Ceb2uAhheR8C3rVjsYUmdrib5H5C/3zKMQrwLdUwREaZhuFW1UtDTdbHGpl5Lz87HK2GlsVpq2rBxM89f4wv3yUvxrereine/UtY9kDlBR0DF9N4WPYfLQ0BFIMEkuehzQjNH9uCxyjMFGI8s8UpV6Cgg0WGZynTKfq1CXdwqOYhKoB4Vo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64585213-c7ab-4e79-8fba-08dbb9dd8b4c
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2023 13:28:58.1778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jcpBhXeS/IIL4G/p5kUNpqb3L+5X2EmCyao0xvq2CYU4zWQuJV7zJDfQLMmngDcRtGhlqHhYS8zHqvVRzJIa1BNcycThBuM2516YSytjAAKQnjYoT2zcarB3gU1h1fTa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4347
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-20_05,2023-09-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 malwarescore=0
 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309200110
X-Proofpoint-ORIG-GUID: Z6tyNY_ew_W8-fGd3Xfh4zeeJ9jUS_QJ
X-Proofpoint-GUID: Z6tyNY_ew_W8-fGd3Xfh4zeeJ9jUS_QJ

Hi Greg,

On 20/09/23 5:01 pm, Greg Kroah-Hartman wrote:
> 5.4-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Hao Luo <haoluo@google.com>
> 
> [ Upstream commit 29d67fdebc42af6466d1909c60fdd1ef4f3e5240 ]
> 
> I hit a memory leak when testing bpf_program__set_attach_target().
> Basically, set_attach_target() may allocate btf_vmlinux, for example,
> when setting attach target for bpf_iter programs. But btf_vmlinux
> is freed only in bpf_object_load(), which means if we only open
> bpf object but not load it, setting attach target may leak
> btf_vmlinux.
> 
> So let's free btf_vmlinux in bpf_object__close() anyway.
> 
> Signed-off-by: Hao Luo <haoluo@google.com>
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> Link: https://lore.kernel.org/bpf/20230822193840.1509809-1-haoluo@google.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   tools/lib/bpf/libbpf.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index b8849812449c3..343018632d2d1 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -4202,6 +4202,7 @@ void bpf_object__close(struct bpf_object *obj)
>   	bpf_object__elf_finish(obj);
>   	bpf_object__unload(obj);
>   	btf__free(obj->btf);
> +	btf__free(obj->btf_vmlinux);


This patch introduces a build failure.

libbpf.c: In function 'bpf_object__close':
libbpf.c:4205:22: error: 'struct bpf_object' has no member named 
'btf_vmlinux'
  4205 |         btf__free(obj->btf_vmlinux);
       |                      ^~

This struct member "btf_vmlinux" is added in commit a6ed02cac690 
("libbpf: Load btf_vmlinux only once per object.") which is not in 5.4.y

So I think we should drop this patch.

Thanks,
Harshit

>   	btf_ext__free(obj->btf_ext);
>   
>   	for (i = 0; i < obj->nr_maps; i++) {
