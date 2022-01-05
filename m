Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A9E173
	for <patches@lists.linux.dev>; Wed,  5 Jan 2022 00:58:57 +0000 (UTC)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 204KdZCb020518;
	Tue, 4 Jan 2022 16:58:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=EaIDb61kSviODrYpkh2kWmyU0CnyQLvt0jmlhy/DEJI=;
 b=KAVZVNVRrmVSYyX9mkY7xn6uJJDYpwQ/+i+bIou/bE9ffCLKNuoiG3FGqzyRE6/ojNMd
 F5EhxavV+KGljc+LXH6RUjADgyAvibj5fPv/Q1EDsZkuoriCfLQOjFkH+QEpOTwN9Ezl
 VFoqo1qZ7kVJJ3ercYwqOB9T5TNIUPwG8A0= 
Received: from mail.thefacebook.com ([163.114.132.120])
	by m0089730.ppops.net (PPS) with ESMTPS id 3dcwfd19tp-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 04 Jan 2022 16:58:37 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 4 Jan 2022 16:58:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=guSLxotqFNNevZfvQJcW3QXj0O8ReejUZer/Qpm0l/9AEuDVFKiSL9Qkms+3y41UpbiEEzJL+59WYXLo1i6hFO3AgkqLCszXKShcFdXgIrIZLfPk53SZKnGMf7vUOuMHF2yrNiz/nFy5qOh2vZjuPGOGWxB0QU3jEUa/gh44Obnr4POLqfKBuFFaO0OXXYdKShixzzrFCtuNrINz41zjO3BCLFLCZOAnHHfbCO6Gm8/tM3d0TlR4Xy/S4IHJ9R0NS73r9KkWTNfx01JEjPm+YCg9aqnX1cYpeA2bpEiKnSulw8vGsuaA6LU4IYaFS1bVV+gcXLgZVedKL7imrdBO3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EaIDb61kSviODrYpkh2kWmyU0CnyQLvt0jmlhy/DEJI=;
 b=QKgSQQRzPWdbwjOyXzTey0s0Z4xqOzO27X7rErfH5GlG7WT3fMWrDSvgazSbZ8Whve7PAbxtyvLvQ/gyPnD398V5EGmxyKj6Q3dgoTIJE+tPWllg/x9rd1f0+HJS/zeuFoNtbXJXxi3f4eH7f08DCi4FxYQqW0s/G3P9t/BfKY2hlokf75c+Dhp2PdEWNE3JxU4U5rRSJMn4DroSgT8C9JM0vyv6zLV5afJQ5mlqWsm54FLA9j0nqA+eH9nw0OC/BrMMbrSDVqykrZ0X+j9dsntuyryRG5fWqt1v/l+4j29q/H3H6WX9YQkfCMXSbZmsCoH6QWxm8cy+ax1XeMrw1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB2517.namprd15.prod.outlook.com (2603:10b6:a03:151::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Wed, 5 Jan
 2022 00:58:36 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::c4e9:672d:1e51:7913]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::c4e9:672d:1e51:7913%3]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 00:58:36 +0000
Date: Tue, 4 Jan 2022 16:58:31 -0800
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
Subject: Re: [PATCH v4 10/32] mm/slub: Convert detached_freelist to use a
 struct slab
Message-ID: <YdTtN5hjMkftGfRq@carbon.dhcp.thefacebook.com>
References: <20220104001046.12263-1-vbabka@suse.cz>
 <20220104001046.12263-11-vbabka@suse.cz>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220104001046.12263-11-vbabka@suse.cz>
X-ClientProxiedBy: MWHPR21CA0057.namprd21.prod.outlook.com
 (2603:10b6:300:db::19) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b704aa9-e42c-4985-b6ec-08d9cfe680b8
X-MS-TrafficTypeDiagnostic: BYAPR15MB2517:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB2517956A0F3D439FA8F5FF28BE4B9@BYAPR15MB2517.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:274;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K0XWJtQasCX4F8BpPUlRukzcBgHzHBPjzPKtwsYEMUG0loG7k7R9iyIXVYaJaTxCXvCHFwXTQiZFMlShd/Cw7ZUv+L2g5rz0c89Voy6nJEi5cfrxTzKs3DWl/YGWkISSLl5y3oL59Zmw8zN7TitkHGYYIlavUu5hoIsW2B7+a/5feZSO8uOfb6uEFPG1D8SPGufXatYGUibM6kKmEmTX/tsIKnFIPfyK33ojsDw3bjMTajElrj2QlShUtYM9mDJA6oPdp+8MzyKvZGmgYHdlFqtJvmEQn9nkPmnQnXbyYaD4lGHcLJm4jHwZ0gLyWDLnpRvs7THAr5szTtBGHdvY5GBurUn3s7NumciLrWrFNwWLAVHGG3qI0WKLSZVwaSDwwVg8NrOowWfl6Bs+KiB8AZy77ccRmN9MpULpLEymiRFFoA2lqWbDwX9oWg3+4HAGTU9usZRdPwHfXLTjg2nl6owTxt1pdJEgcmwtWHX+0hmk+LmBoDo9fg3onaPSkt27oxQvMGzmITrVvJOH7gtckma5go7w68kQUT9Aa/XxMqxyikBcbtzoHAShFY0IlVbXTM4eDrXZYc4zLp2DHBdtw6DiGDndMRtFrO/sRvQ+LekUF1N2TB2hweoULiA8EIUl4dtDW8bMI3A2+o4l3BGciA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(2906002)(8936002)(6506007)(54906003)(66476007)(6512007)(52116002)(508600001)(6666004)(8676002)(66946007)(86362001)(5660300002)(7416002)(4744005)(66556008)(316002)(6916009)(9686003)(4326008)(186003)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rEdJ9/+dHi0tosOmTvA+Ch8gDnMrmGUoQqmsOtbpqjYmlB4e8svtB1GKTpEC?=
 =?us-ascii?Q?cOLZazULfZ1+mH/r3DmZaa3rBVAORpv15Y07A2Fd/MC6fUBGKEvGqPPeP0gT?=
 =?us-ascii?Q?nfPeSViZH7jdn48zF+omoqyFWelm0wAfaRU9TpPjgAvK8VNsORgiLbr18Shx?=
 =?us-ascii?Q?e9OIiQrHE7pCbV/ocbYruQxpfThC151PJnXeVLt172jvybjDWhmqGxwDW8X3?=
 =?us-ascii?Q?mwmPE/ApDsfb+Q9qpiheF5xOJcjvA0v8N4pK3r6Ro/TKoN7xaKZIFMj3s2tj?=
 =?us-ascii?Q?Ya0OUfvB6rHrezDyfbo8HjrDkeAqDuqln0XGkQMN3fVJb5rLT5nIy3t9VB30?=
 =?us-ascii?Q?fTyIBvFANVp3kYxb7plVV8cVf+wrPB+Bm1jwXWmtjnYP9zm8oYv3nMXvfFML?=
 =?us-ascii?Q?Dsn5PqYI8/bp1t6Nh06oGLiXVCVhZ6Uy0bMPEEQS//5H8QEtvjymClGzm+8g?=
 =?us-ascii?Q?2SktTh3qZFZABXkqMOyt5otiLVuOr1bq1nuWCfXpZfQUgyDWS0ei5SaWfozQ?=
 =?us-ascii?Q?uX3ajdRMO7cBMQd2hKWNxJk2hCM2B9bXLrFJO9/7E7CffhiBKaAQh0mUp4it?=
 =?us-ascii?Q?BryGmtHVBoSmkF0VAzeQd9FvDKNKtt7usOmOI0DluYM13dwwKA0tjOsjJB41?=
 =?us-ascii?Q?cSJ9Tq61vQ/4x3q4fwWc7cTZo8mZy7dd2SrAo4TDj6I6BekkPCAZ/FwOfurx?=
 =?us-ascii?Q?3kQTZ5VMaWqyftF8nh9EHw1ub3YjMZjJGs4nMvORLKO80xONIZsJ8b5OXGzU?=
 =?us-ascii?Q?fFOuH0jpTE2NZiahvnWoDfL+ZWRN2NyEN8d/BNyf/GlonDEheQtflBHhSe8d?=
 =?us-ascii?Q?ZGm8aNCvfGI5Gwes+84j3EXGs9NBHr2TBjZcAiD9bYM6uzXwJjWChtNGVdWP?=
 =?us-ascii?Q?FcLx1DuZgiHLEX/V4eg69fGwD09r/gdS3VvTXcjMjJq0syUHe79qZKHGlFOJ?=
 =?us-ascii?Q?TL+j82yJStBq5t8F8jHpQxDfdxH7EfZAlfEqc00op7aoF0qsUw64PO95UTK0?=
 =?us-ascii?Q?hUL9UfKIUI72smTL5/3UOAargp9b/Ven54OwUCRbuBZqXHb0ai/s9ffHza8M?=
 =?us-ascii?Q?ehtuBHKXewfZl60m14WoYWC2iNx8z8CxaBEs4wlFiCKATvXUqGQu26RTAq5b?=
 =?us-ascii?Q?/Ckn2jGKBqOSRcS2fwdn0r6HR//4V1GKLobS3eHvuYDJvgE3WOK5Yh08qceo?=
 =?us-ascii?Q?6fMZ1VBatqbBov7xf6lVnpC7NSmBMvSmYb4bIdJiJIlgnnEa/OtSoIllpOLn?=
 =?us-ascii?Q?iXDk22CIVyo/DVOiHE7H/WfilaSVfodKfaoKwgYDilDH6iWEwsC9hicBEGXY?=
 =?us-ascii?Q?itxSGLXZvXUwjm8734yPpxp2U4JI8796Jb8TaH8i0AKi8C/mQmzi11zPllFn?=
 =?us-ascii?Q?5rea0COBzP8Trpncoq5AOg0mHJW/lhAXVu3Ql5/R4ytpbu6M1uExwzVH/SyQ?=
 =?us-ascii?Q?kMVoE+Kyx8tBO7Rc1PfEmJIijwrD3vDhE96V8Z4PW2bm3Wkql7/DNz+LGZPF?=
 =?us-ascii?Q?wSqCCy4sOuL+34eAoNJDqhLkvSLEI4pE0mD2wZ5tEZvi8Y1I0wdNOQDY7+VL?=
 =?us-ascii?Q?ZIWQs0GJwnUnmjoPoleuFULLTOurrya6Lq/AGLgb?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b704aa9-e42c-4985-b6ec-08d9cfe680b8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 00:58:36.0215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dxvrKIRbby7WoI0YEilwwGH9FlE08RO6TwDUSkQVG6j1s8Lg25RzKj/k9fJGqvgp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2517
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: Ga-T5C0VO9y9sviySqWcPtEwkj4yR0V8
X-Proofpoint-GUID: Ga-T5C0VO9y9sviySqWcPtEwkj4yR0V8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-04_11,2022-01-04_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 suspectscore=0
 phishscore=0 adultscore=0 mlxscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 priorityscore=1501
 mlxlogscore=735 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201050005
X-FB-Internal: deliver

On Tue, Jan 04, 2022 at 01:10:24AM +0100, Vlastimil Babka wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> This gives us a little bit of extra typesafety as we know that nobody
> called virt_to_page() instead of virt_to_head_page().
> 
> [ vbabka@suse.cz: Use folio as intermediate step when filtering out
>   large kmalloc pages ]
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Roman Gushchin <guro@fb.com>

Thanks!
