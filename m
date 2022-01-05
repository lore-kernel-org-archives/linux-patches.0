Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C922173
	for <patches@lists.linux.dev>; Wed,  5 Jan 2022 02:05:23 +0000 (UTC)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 204M40GI023060;
	Tue, 4 Jan 2022 18:05:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=3loyR79vvnQ+vROp+5eF1awiL+lTCs0BnqJlf+REr4I=;
 b=KRzOKxTna2P+uhxqvJ9NqQSpuzTzBGXGx6CYSJXhS9dXURi3UfMJ1B/vSeoJMJkv443x
 dAWs+RJqP+0nFpUk9FanKTHlzzD19nufKTyU2sr9hTOZ79IQHTQ9zOoqnDsU8F0Ki4JU
 gz/kq2af2m4ftR5YGWmwm1+RHoh+TB8GY1k= 
Received: from maileast.thefacebook.com ([163.114.130.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 3dcxpr14xm-7
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 04 Jan 2022 18:05:11 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 4 Jan 2022 18:05:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FsoDVc4mTX0AvxanEVi5b1MFTnj2y9IB/uPIS/TGPJVs3ZbUikK/j7rHRo1KUxsU0qW2lmY9r8fj5IB8hH/o+LdDeSGa3LunIYUpaL9aVsLwVeMJs5Ajr36imId8bXHv73wtFRU8RfqNl1CeMVjmSZBfSrjFUUYXR9MWog5MfcCRsOSwomnMsR8g5TuBm/57AoHRGjw3yiHQEcoTGrCn/ztI8FY7MpqbnDR7nQqKXPQ39fIba20c8YKq5pnbwWh8ZdRJitumiZEzhnYVm9SOR3fZkg+pyI5PnXM6PfYdR54O6x9pIneikjuehfhE7fbZcs7cUb9DwfgIZeC2nQDS/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3loyR79vvnQ+vROp+5eF1awiL+lTCs0BnqJlf+REr4I=;
 b=IhodKnjFDQ4DZxAa865g/P0bakIDHr7ghR6b+AC3lCUG70T6R4q2r++onOkVOIvWUv7/hQCtRNF3Jn0kh2jkf1PnTFsgpACqaHsxqu/A6vKA7BfHBlc0nGAOA20kdzP207/aO7qzhfEKfZo8e+egM/OK1X8JSEs/uc5/rxzOtEch4biLLGp6CO7RBZRbCQUUj+zoTTO2obj/2WLG2Ak+0gnUdZLpJizBkln98j7x84kT36fPwjwJjdd2BqagCWQ161lPmkleFXlMmpW7qsKkBeAK+PeEiMMPsy1e+fobmpagGUW/TV7lOb2nptZ3lNTnrLIgdtc8cvEZCpKkfm7w0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB2391.namprd15.prod.outlook.com (2603:10b6:a02:8c::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Wed, 5 Jan
 2022 02:05:07 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::c4e9:672d:1e51:7913]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::c4e9:672d:1e51:7913%3]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 02:05:06 +0000
Date: Tue, 4 Jan 2022 18:05:02 -0800
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
Subject: Re: [PATCH v4 21/32] mm/slab: Finish struct page to struct slab
 conversion
Message-ID: <YdT8zi1pG1ky2I3T@carbon.dhcp.thefacebook.com>
References: <20220104001046.12263-1-vbabka@suse.cz>
 <20220104001046.12263-22-vbabka@suse.cz>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220104001046.12263-22-vbabka@suse.cz>
X-ClientProxiedBy: MWHPR18CA0033.namprd18.prod.outlook.com
 (2603:10b6:320:31::19) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b5c550c-9400-4027-ba55-08d9cfefcb76
X-MS-TrafficTypeDiagnostic: BYAPR15MB2391:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB2391939321609FD3EDBFDD35BE4B9@BYAPR15MB2391.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:356;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qzJf2OxVcbIr7y4iPP3pNwno/DDYohcV4v534mkd1D6J6Oav2g8RNX3nuXeYA6w/xGy34Gu9vly+5YzQWHiB+A/RQRNS257iv1XizhZmgvKYtLZLUXbTwfSIAg+xMmkNCNnCufDs/bQx8icJ9TGuP9VlWtWMtSNnoB4IXcGKuVJZ33NezhpcuOZNzkAYncNAcgPAOhCy2F8voWmBWQFLtlTcWQObZl8VEMGSp3BD7NXaVFGau1MwmaQdShz+PtwX1beIIt1ubFPt0dTwLJa66vX1X/sWmhR2t47ODzaMG/8PVzxn3PEvObWrmqj2N0eTRLgC3GvltlMmwDWXOgwSKfMRrRhaPJd37x5ttIfKMksUxG1ez1eKl/EIb3+inH72nKUfkV9mm2Oq7eUKVH4n3W5RreYbwgKP3azaoCVAgLH2HW0N72Mepad9O0WFF7hs2zIdUDWA+N/DrCAy8Y2GxmrtIzhxi/nKbYppl8LjOsz6iLmE/Nn7NncAVn6/etUyFyo7EFrlDd0kXSRfAJ+aNZhdXK4lUlht7rJKVQvn8fDjJvDiLx5uHdyk9beaYk0d4783iFQffF4yqNXd6aDCgXC9QPgd4xwFAeAi3qVnHeJfJhVscDravK1YtvpdEmsNQH68RVeDj2nLZkyHZnp62w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(66946007)(8676002)(52116002)(186003)(6506007)(6666004)(7416002)(6486002)(8936002)(86362001)(9686003)(508600001)(83380400001)(6512007)(6916009)(54906003)(4326008)(4744005)(5660300002)(2906002)(38100700002)(66556008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NY8O8OOgRyc0a/nZBuMX3wPLXJNAa8DeszSUxk/DxHLkTY1o64/eNJ27jnFA?=
 =?us-ascii?Q?ju5dlci5LYQqfcR3eWGXREXlDkDwCphDcJsE43P6Kn2ADE8RE48UJooFy8fy?=
 =?us-ascii?Q?OPt3xo4g7HxtZGKDxG2FAq7NKC3nqCdZ/bhzobejxQwjWMbquZ3Dtx9vR/Kz?=
 =?us-ascii?Q?eaxAUjSM9DJWao/Z+MAT8KvWUZNaTZtEZx/2l86aJnBeJYo5prhBBZmuOgMD?=
 =?us-ascii?Q?lhktwa8Qw5/bgC+mZ7foe7mFWtisAEoQtDFJP5oivnmBazKeukdsJpce83g0?=
 =?us-ascii?Q?VE1OdPxJSNpitcOo3nPYBbmY5EhIqH1o3PdXn0vcanjarpU3kE9ZIfJAn+Km?=
 =?us-ascii?Q?jTNThSC9vB4tYiM6sM4jW8RIGP7olKtnGRQ6Ta5B4zqc34JW3xeCIt/QdUzz?=
 =?us-ascii?Q?zR3uYbd0VyEmoJorOebXKh0OemMy6R4MHGTWugAJtuaRRPKMjE55giwwP4IF?=
 =?us-ascii?Q?9Lf6lIDkNxTvOwLszZw70/tPUej0V6LM71XGxjq3aX/8q1N9LUoVvTip1f8X?=
 =?us-ascii?Q?A/sImtbDgbSN7LF8pDaaIrVfO35Y3tCScul8qMqo0LKwJZtId/on//OqaUtb?=
 =?us-ascii?Q?vyGGcEZ4ibgJRR192dTs+imnul/vGP1q4YDJ5+lj2VEwurVLBcJB88ix7SAK?=
 =?us-ascii?Q?WLO8dCMtl2z2+0VNhgSRl4ZeGZaC8fQK+WkanLGnlvCSBikBxqN8thFYupY6?=
 =?us-ascii?Q?CeV4HmKYKqxnW2xxB1jOKZqS+/uVw2G4ld1J3BKwdQbAZS551uHltSeKW7tp?=
 =?us-ascii?Q?5kj9pz8zSp0gcAeKmvuKWLMEpC2EfG6xf3DSalrkBV2apWQU102sQM+YI/3/?=
 =?us-ascii?Q?dpXHF7Sqqs7UPzm+PORWX8QatitdkWKdgDkYrXgu9taAQ4AdgT8/7ALZ1c+3?=
 =?us-ascii?Q?vUVdlPPOSm6MULt/sknRirQy6/gVzUKiqGrSxGoSQ3K3lQM7PIGcy1sk1chy?=
 =?us-ascii?Q?BZjD8gt2ZThqKR/2SMkXSkkUaVrDMh0cOHp8fsHz9i2lH24xCRAb/8hfnJ2M?=
 =?us-ascii?Q?9/ud2ELLM8wHBjaYwYQ74zwe0goy2lt5ErSDB6J8PcwMYvurWk3VDX1RJmOV?=
 =?us-ascii?Q?sZnvnji0yXAy/22aiWxT4hhQ5NcFh+TllnpJBM6NWfJQnefYO3MahhQPiWMg?=
 =?us-ascii?Q?vl3O7Cg6FmVdvicePTiRUbDtl4q1gmCsE0NtDR9XQfnEBePBQgiusUzz68e3?=
 =?us-ascii?Q?euAkxqfkgxtNBZpESm1wXmK+6F+bU4QqtpN5v2K0Y7E1qE7BfuPf+AZzhg6a?=
 =?us-ascii?Q?dqGaoHcMxuznYaZHIdyf/hljEq0fBQa3jfHsOp1DJywrWFWjd4AuHlJe724T?=
 =?us-ascii?Q?2Tk5wUYdmzoSsBP3yVMgaiosWI1JkFcGRW6u7wppMx/yGfW7rED9XSaVkD+k?=
 =?us-ascii?Q?2dU9wBHBhmVKdLOTWzsofMQ4SeCehNZFfJnPuqlA1TLcykBTrG1fre1tpJui?=
 =?us-ascii?Q?d9FdP/1SGd9/pesWn/dJTmdZTsDgy7eIl1ngk9Lbr1G5uhMEqAJST5zk41SS?=
 =?us-ascii?Q?f9Kp2CyilVIbUGxVKRYzLwzA0x3HV5BuMLi97p6L1eIRQSKZSgxkHwGHQMJZ?=
 =?us-ascii?Q?fGUl2HKAcLmDmNRNvu+kgKIPG4Mg/RvWpGjcsqLl?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b5c550c-9400-4027-ba55-08d9cfefcb76
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 02:05:06.9199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S8VPnr8JdbmpEVflbuFzHsGAFjt48s1MgZqA+wXhxOUESANRanbJoewO4HekVqGR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2391
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: hIIJtvgRzBtWI8osOZMOJ92uisDCGksr
X-Proofpoint-GUID: hIIJtvgRzBtWI8osOZMOJ92uisDCGksr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-04_11,2022-01-04_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 clxscore=1015
 mlxlogscore=683 spamscore=0 suspectscore=0 impostorscore=0 malwarescore=0
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 phishscore=0
 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201050012
X-FB-Internal: deliver

On Tue, Jan 04, 2022 at 01:10:35AM +0100, Vlastimil Babka wrote:
> Change cache_free_alien() to use slab_nid(virt_to_slab()). Otherwise
> just update of comments and some remaining variable names.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>

LGTM

Reviewed-by: Roman Gushchin <guro@fb.com>
