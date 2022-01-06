Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA542C80
	for <patches@lists.linux.dev>; Thu,  6 Jan 2022 04:13:41 +0000 (UTC)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 205N7oXF007172;
	Wed, 5 Jan 2022 20:13:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=J3ASSk1QUUvIMrTUVm/0B8i2eG3v8gUTcMyiBEGrUdw=;
 b=pvCxDnvbggJaaJxKoAl9CVbqtqe4sOSztKc+BoysyhuTlFdHvG+CGY8ACy+RJFRuqxU/
 X5X+r3QucJ+/SB6IG0z5YmLAZ5cFW78mX3ReQPYTExPl8uQAQXN0SuYUkOnUYyrdoun5
 YyrsHDoUBO2a+iSb+zKVokFFdeGXTa8gx1c= 
Received: from mail.thefacebook.com ([163.114.132.120])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ddmqsh70c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 05 Jan 2022 20:13:30 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 20:13:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=esTVqvX+aV+4hzP5usdRhTqojCnC+dx6DJmkD2L+ZVdza6RbIGwTB6Yx4L3xk6JwEGv6nc8xD2QNcr5/oaHPXCYDS9Bom0nkcNwJG1poTkEvNZPGPZYdH0uPcOr6Ksw0bKQJLIg8IW9jrVRFeIWac2/7LW4BX43+g8z1KAMhmhu1leqpsy0maUv/R97ssKLS0j1P5KPdQo/1ZA+CC7/leuM4XjDP9ujPh/eb3tR3spUBgCr+HKV7lCldLoNllfh/s8WV+G2u8eykvk3R14dKvXxc6U5XaCFYA1NhBLEHtFcxYDD4Ad+ukYGqCYXgKepYQCalCBLZATCaDraJZ8LsrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J3ASSk1QUUvIMrTUVm/0B8i2eG3v8gUTcMyiBEGrUdw=;
 b=SAGUZ9akGVb+0Qmlq39TKrUl1/R6G/BWKZJ0XUiytZDt3JA308t9R90OTCMebIrConeiHqCoGD4EJ46TDppGjNYkICnxVynb5ExL25IvKtZutg/7FRhtoJOTwDDkreNw5646EvsTXHCgDNRlJ5E/Z1UjRJAtw5AmQJJXszIZJDazyu5xqTVTSsD4tDFvymQwcZx8FqfSvAEdfl7py5rSMIvwUlzpKdVqe6tXxP/VzJfaHzxqcQHKorVa6amLdck+wqyN+4Kgg2J+Sm1lcW9jYKD8r4/Lo0liZvJ+4Pwdo79ST7R94j1Ns8oTv2tS1LWD5aInv8A1dOjYKJVuM8DO9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB3143.namprd15.prod.outlook.com (2603:10b6:a03:b5::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Thu, 6 Jan
 2022 04:13:29 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::c4e9:672d:1e51:7913]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::c4e9:672d:1e51:7913%3]) with mapi id 15.20.4844.016; Thu, 6 Jan 2022
 04:13:28 +0000
Date: Wed, 5 Jan 2022 20:13:24 -0800
From: Roman Gushchin <guro@fb.com>
To: Vlastimil Babka <vbabka@suse.cz>
CC: Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>, <linux-mm@kvack.org>,
        Andrew Morton
	<akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Hyeonggon
 Yoo <42.hyeyoo@gmail.com>, <patches@lists.linux.dev>
Subject: Re: [PATCH v4 28/32] mm/slub: Simplify struct slab slabs field
 definition
Message-ID: <YdZsZJYtWKX2wZqw@carbon.dhcp.thefacebook.com>
References: <20220104001046.12263-1-vbabka@suse.cz>
 <20220104001046.12263-29-vbabka@suse.cz>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220104001046.12263-29-vbabka@suse.cz>
X-ClientProxiedBy: MWHPR18CA0064.namprd18.prod.outlook.com
 (2603:10b6:300:39::26) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa8bb38b-a881-48af-d9bb-08d9d0cae497
X-MS-TrafficTypeDiagnostic: BYAPR15MB3143:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB31434561BEEFFD7FB8EB5792BE4C9@BYAPR15MB3143.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:147;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VgmU6NwGbk1CohkxEHoyNhzG58+wIF1jNGjjx0ENI1BmEKeA58yUVR1LMxpuHG283tpFOUd4E3t0hp1hLt2SPrJnNDb1FjCG4QUb04QIlVn17NrFufKJe6jvxSctVuI/PsAoQTmBehHPBDfcnizHbYRQWAs6lFqKwiKGMM8rYRFjcAQRJSe2KlEEtMCN7m2H3YF/t5HCajxMLlCPrHOm1ndTsXomgw1Db6hvia+kSmrX7UY8kXv5Buq5+uJK+9kxGt8z+OJ1vbEHZBbGmpub29/h4JXngduGz4sI1eDQpKcc46gtxfsu6vCWUH4m/h/dv0Dyc7yzIvJYZO0xA7pOjMUvUvo59Cz0rl1aY6/Vs4KSUbd784D9nMymYwKxS2zOt9oeV5/3jFydXeBFVEPAlhVRI2C4zUngcTBWSaLGV+uCHN55gxcqTWr7Yl+RpX8SUwZ7GEolNKrHPTHFooBe07KQPlSjEAURlMMmS1KLMaWA34ng2Ak4Z0URNxAZaQgENSnMObSrbLEMWmO2uv42R0duZVbId9AV8xGlspMpOR+2rBmHezSgKcgrhmc3ctjWXUXF2LqA0bF9jTiiW3cwZe4/mBkZpLxVMjRcOjwuUtz1WdeZHSnlNOnMvGkdUG+wMKkY1oX14iYuvWEzI2fwTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(8936002)(66556008)(2906002)(52116002)(186003)(6486002)(508600001)(6666004)(66946007)(4326008)(5660300002)(38100700002)(83380400001)(6916009)(54906003)(6512007)(9686003)(8676002)(4744005)(316002)(86362001)(7416002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KEtuX1zkG3SizLN5pRDvAbWmjc6p+IdXTthTGtckhgo4feOnIbkBGJxrETGO?=
 =?us-ascii?Q?Gmc5YYrJtMums/MITIp4r5yzBbMORqnus5Wg2EScOi/tKgJNt4bakbx0bgCd?=
 =?us-ascii?Q?qJM06/2Ux2T2LxzwdEvAyvjuZX8CTFOfD182qahUdBjmpHMJ3ILdJl8gEBfx?=
 =?us-ascii?Q?1ZAZ1jbZDwIULrEEHJmyIkR4nysv6Utx2jHJnR+FUT5c+uysq2TKqTX70nQa?=
 =?us-ascii?Q?teksGiQzhsbciB+PTZWS7IAIy22T4zZ8Sozar1rFBoaat6uM4NBm1pcHJ4ej?=
 =?us-ascii?Q?KCK+P7ftSqKQ0JzFO3Osr2JdQqwsGqlLo61K51zoeucDJ9siMJp40bp3XZdO?=
 =?us-ascii?Q?K2g2MGeHgIntVZ6EMYAA0WPynG9Pb4QHa8r8wyf9aPcV0wCv2jOxG3HrDuqq?=
 =?us-ascii?Q?SFtD17JFAlUXwPY3ItQbBJwJU6xvrjDtxz6qrsc0CQj3bDXd4QfJ963aVFhD?=
 =?us-ascii?Q?j6qUzjIVsgfwXf7RIlpDOJ448AX8pq9SnSxRo5mBcY5c4OChkWA3nwnD5wpb?=
 =?us-ascii?Q?bsFjg5YklHMvcYv0qFQG10oPHEGZdlFRGWCGPHUqzUUc5qyjbosDOiDGg/5P?=
 =?us-ascii?Q?P3sl5+tL5kCHjMEVQAgMy6QKMn+5iLFI2aHowkJbuttOGKJg01XrztgsUIwQ?=
 =?us-ascii?Q?TxPVgdiZo0pV1JAfcChcd8Brmjeex862+3bsMQQVRzc0u7fqKDJOzOLW4vX/?=
 =?us-ascii?Q?HvaqT+D6KlyaAnBAdTJC0+70WobA2Q0iMneNktRKlAcNxzjWQ1YObPcAWIKi?=
 =?us-ascii?Q?nEGIPw5ZdMJR8Bm+/PbZHJ9jZKft4HsDgFFEtE8d1/7b8ibJ+wmRRllzi55w?=
 =?us-ascii?Q?4dz5qbvBiV0nljM/MgbfMjCXQe20c9AhuDL3p2ojikEd/8DvHNzqfX5QYIoO?=
 =?us-ascii?Q?0PpW+y9ykVMvGpOop3rm43uZaSAg/DJj0JN0yjZvoUdgv5n4CAEp2NdtHvLj?=
 =?us-ascii?Q?3a17r9DlAGhZri2Ave2xToTojEtAG1iveGhHH1wlfa+idBplY/PtKSCVcys2?=
 =?us-ascii?Q?2kvQr8V9vgJThWudFWuOUuhtFzelu7cMUTjdT4TEww7Tum5yytvWSCOIuRQN?=
 =?us-ascii?Q?IrZhW2T+5Tn3/Ow9ZdYjlOZIiQ73aitNXc2pMc2H72D8TRsV1vBUVG5cOxfX?=
 =?us-ascii?Q?PQMDUYC1G3wF6KSQ64TulTlX5eEyL5B95uTmj2bamIZBVg/sE1EAMvDa5nZl?=
 =?us-ascii?Q?u3hFRuL7n5faAx0Z5POMWMFrdeFCwgpyByEOf9F3dY5ncYDLlgNiyDNz1Hyp?=
 =?us-ascii?Q?VQi8exEDzKZUMxg0vZykz/SEhSl5PCMFXx8bfKSVtEBOZF5r3EvVToC4BGpj?=
 =?us-ascii?Q?24YOobgY8t1lrsdIgoVw93T76Ry2pcf6IMJHQ2+gA58GATdhnyxEO9G3jVqR?=
 =?us-ascii?Q?KCYUBUo87s3q7upddTkG558LVC66G7wlxJD74opOohTRTSEoQ6Kccb61WLWP?=
 =?us-ascii?Q?MwRGRw+X09XYbxthS/CFgTD4iESNiWmyl7gpNVOBqyDdCa1stm5tuLLFBcUz?=
 =?us-ascii?Q?ZyiKieHejgy4sDcPeURrZ+YqTVW/Odqjj/sGJLztnKtjKRvbkkWSkLpiLZO5?=
 =?us-ascii?Q?ivPlytLhJxHtzaCbzhtAlRMQLnwhNVuRP0ZsnDm7?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aa8bb38b-a881-48af-d9bb-08d9d0cae497
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 04:13:28.8482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fsYWTP5jMiTZZR2WHrGXAfHhA3KPTBPdQKvm8k3X3ikLvd4i/X4q5l+tjS791OLF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3143
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: f2WGetvVYDAtpaTNHAnTWc9bsS8t8W6l
X-Proofpoint-GUID: f2WGetvVYDAtpaTNHAnTWc9bsS8t8W6l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-06_01,2022-01-04_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 adultscore=0
 malwarescore=0 priorityscore=1501 spamscore=0 phishscore=0 suspectscore=0
 bulkscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0 clxscore=1015
 mlxlogscore=679 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2112160000 definitions=main-2201060024
X-FB-Internal: deliver

On Tue, Jan 04, 2022 at 01:10:42AM +0100, Vlastimil Babka wrote:
> Before commit b47291ef02b0 ("mm, slub: change percpu partial accounting
> from objects to pages") we had to fit two integer fields into a native
> word size, so we used short int on 32-bit and int on 64-bit via #ifdef.
> After that commit there is only one integer field, so we can simply
> define it as int everywhere.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/slab.h | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/mm/slab.h b/mm/slab.h
> index b8da249f44f9..362832f465e6 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -27,11 +27,7 @@ struct slab {
>  		struct rcu_head rcu_head;
>  		struct {
>  			struct slab *next;
> -#ifdef CONFIG_64BIT
>  			int slabs;	/* Nr of slabs left */
> -#else
> -			short int slabs;
> -#endif

Very nice!

Reviewed-by: Roman Gushchin <guro@fb.com>
