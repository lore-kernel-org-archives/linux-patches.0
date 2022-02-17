Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20692257E
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:23 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 961E52113D
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 77EBB13A94
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id GRKxGmVnE2KvIAAAMHmgww
	(envelope-from <vbabka@suse.cz>)
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000
Resent-From: Vlastimil Babka <vbabka@suse.cz>
Resent-To: patches@lists.linux.dev
Resent-Date: Mon, 21 Feb 2022 11:20:20 +0100
Resent-Message-ID: <38a0b72f-6f56-2ca8-a353-cae3352953bb@suse.cz>
Received: from dovecot-director2.suse.de ([192.168.254.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	by imap2.suse-dmz.suse.de with LMTPS
	id CBp5HhyWDWJlfAAAMHmgww
	(envelope-from <prvs=30472c63f5=guro@fb.com>)
	for <vbabka>; Thu, 17 Feb 2022 00:26:04 +0000
Received: from relay2.suse.de ([149.44.160.134])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
	by dovecot-director2.suse.de with LMTPS
	id sCJ5HRyWDWIaPQAApTUePA
	(envelope-from <prvs=30472c63f5=guro@fb.com>)
	for <vbabka@imap.suse.de>; Thu, 17 Feb 2022 00:26:04 +0000
Received: from relay2.suse.de (localhost [127.0.0.1])
	by relay2.suse.de (Postfix) with ESMTP id 72697A3B8C
	for <vbabka@imap.suse.de>; Thu, 17 Feb 2022 00:26:04 +0000 (UTC)
X-Virus-Scanned: by amavisd-new at relay2.suse.de
X-Spam-Flag: NO
X-Spam-Score: -2.809
X-Spam-Level:
X-Spam-Status: No, score=-2.809 tagged_above=-9999 required=5
	tests=[BAYES_00=-1.9, DKIMWL_WL_HIGH=-0.001, DKIM_SIGNED=0.1,
	DKIM_VALID=-0.1, DKIM_VALID_AU=-0.1, DKIM_VALID_EF=-0.1,
	RCVD_IN_DNSWL_LOW=-0.7, RCVD_IN_MSPIKE_H3=0.001,
	RCVD_IN_MSPIKE_WL=0.001, T_SCC_BODY_TEXT_LINE=-0.01]
	autolearn=no autolearn_force=no
Received: from relay2.suse.de ([127.0.0.1])
	by relay2.suse.de (relay2.suse.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Qa4QQBMSdA2O for <vbabka@imap.suse.de>;
	Thu, 17 Feb 2022 00:25:59 +0000 (UTC)
Received: from mx1.suse.de (unknown [149.44.161.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id 0788CA3B84
	for <vbabka@imap.suse.de>; Thu, 17 Feb 2022 00:25:59 +0000 (UTC)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTPS id 95671ADB1
	for <vbabka@suse.cz>; Thu, 17 Feb 2022 00:25:58 +0000 (UTC)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21GMVQkL030359;
	Wed, 16 Feb 2022 16:25:40 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e8n4mrkjx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 16 Feb 2022 16:25:40 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 16 Feb 2022 16:25:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MCAbi4xTfpkGp31hnUkbhHLaVzDjzCAisWBAvsizJyzjvVGqixr7ozCZXvYK5cQ1mN96zoqGR8G0ZOIU3DhEeeZ/Gek5Xc/q7YOsz/bGSESlN6aBsaL1+Hg5Vo1JDSIPFJZpLDYaoYWV+oA7CrDegOfv6ChyokHJZJG9BnoeDRmIdJ+h9ZkvYA7+rssgAb+rgMj5S//VBXpH4rQF7n+tplLBMX5sRq9Pvp4O2PyAnqabRTK8lKAxdNoEytcOPGnufaiG7Tj2cTyqyong1hibr+DscMfhdk7Ah55MTMU79tDbOWPj+qMEKY+cAyGWnLKafVlq7RjrhUCd+ut99AB+2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+slfjqncVLlbbgGhVqXjb6s8msP4Wu6AmKOOeuDA3f0=;
 b=AepCkh4eEcoZOaPTxJjO2WMiw9hO86V0BnF7IEgmvjdTyLTRgfNmKkvO2Aqt4hJwk8S6dgr7iR1QDWSvdpqTniF6U3QXUhLXHXDlEC/C3Gm8ybjGyS47QIBcpAbKcydJ0tSWlHJQiCDhMxGNE0B0+fDj91mMx13IX1JjKLfMwoBaeUekP51vThv8bdJP5rdThllKZAINMAyMujLDIvOvxBNxd/5KlBSPJNWvtJkk+VWKOuP89QHeornF928ZJSJ7Dgty66+iP0E7qqIWgwjW1qXeIJRoNWNA/OxCyVra96YR7NYEFX717PBrUt2Gdt2YNOBNK07oN4o3OkRsZbMGxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by CO6PR15MB4178.namprd15.prod.outlook.com (2603:10b6:5:351::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Thu, 17 Feb
 2022 00:25:35 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::8038:a2f9:13d7:704c]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::8038:a2f9:13d7:704c%5]) with mapi id 15.20.4995.014; Thu, 17 Feb 2022
 00:25:35 +0000
Date: Wed, 16 Feb 2022 16:25:31 -0800
From: Roman Gushchin <guro@fb.com>
To: Matthew Wilcox <willy@infradead.org>
CC: Shakeel Butt <shakeelb@google.com>, Vasily Averin <vvs@virtuozzo.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>, Vlastimil Babka <vbabka@suse.cz>
Subject: Re: tools/cgroup/memcg_slabinfo.py is broken
Message-ID: <Yg2V+9nershzLMB6@carbon.dhcp.thefacebook.com>
References: <Ygw3au+tPdg2MXYT@carbon.dhcp.thefacebook.com>
 <35486a00-791c-3b1b-14e0-476e6242709b@virtuozzo.com>
 <Yg1kFH3umdrvOhu1@carbon.dhcp.thefacebook.com>
 <Yg1ooYmX54j8l+Fz@casper.infradead.org>
 <Yg1wKkIJxIdN43qU@carbon.dhcp.thefacebook.com>
 <Yg1y0ax5bnjGLAqz@casper.infradead.org>
 <Yg16ClVQj8SLSlqV@carbon.DHCP.thefacebook.com>
 <Yg2EwqE07d97gmms@casper.infradead.org>
 <CALvZod5nqqt_9Xn0Yq4wiue_QePY5wz6BX6Vk2dH3P9qc92yPw@mail.gmail.com>
 <Yg2TQbpWen2SUP+l@casper.infradead.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Yg2TQbpWen2SUP+l@casper.infradead.org>
X-ClientProxiedBy: MWHPR15CA0025.namprd15.prod.outlook.com
 (2603:10b6:300:ad::11) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ec75141-d6d5-4808-1e7e-08d9f1ac03a9
X-MS-TrafficTypeDiagnostic: CO6PR15MB4178:EE_
X-Microsoft-Antispam-PRVS: <CO6PR15MB41784EDBD20E796D00F6996ABE369@CO6PR15MB4178.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I2Ev4PFiaWip3XeRYrGYQ/3+6QiH46SP1gAmvf+4cWK5Jew5YaPDPgXZx2X8r3+SRNYWmm2XCynUu27Fm946iPji2Co0c0ua8VS76nT8GgF9rEB00Op+uVsbS86uOY+wNgc1rydNawRIt49rbb77Fdo1uIOy9cnxwzM+Qky6MW43+kWrhp1cRdktBclJZ6K8DQHVDPmADfGIXZcQbdueZd0wg2zgz/UxXDVwJ6yJjndmU829mZfogvAE6qZpogrBAxRpvbzDidAJnZXtkSzz8px49Au4/krN7oMEh+EEWL9/lnKZ7k7KNXzgZpSXhUiEMER/qv0rLTghbDqcwn1zEw2iNtrs0Vm843u5aHx2LpE+8THzimqA+7is+TZVQ4cbUCn2pGMUB8u5SGwobqLXePytEmpTaMsrtt3HOYqR/GRddmEwRPSM7nqZXpr2lzrgHqIfC76Tamd0ie00Tsyjr29450fyYEzQEoQjeoODi+ZfJ8y9In7+k8J5fe7igPyUjAp5E/H1iRlyK9GScCtQaNt0rD8aSYdkj6+/3GwA+5Apuh6kT4QFQZvsYm2UupdkzenXeC5zjA6FhivnAvvrK+WgcbH3Y6cp8CHE8MygSzNpWpbGOhl3e7Cnjhbb0tdkK5dJBGNtoQqX20LSGg8TZPNruDIZzjoZjbc8A5WVVMANcQqYsHcbEZ+lS9Nyfg+c
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(54906003)(6486002)(186003)(316002)(38100700002)(508600001)(6916009)(53546011)(52116002)(8676002)(6506007)(2906002)(66476007)(66556008)(66946007)(4326008)(6666004)(8936002)(6512007)(9686003)(5660300002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ofxs7ck9UinDZLHctLUhMobTxstgxXJDaNFKxJqZ785N/sGWJNTrDgl8Hcbr?=
 =?us-ascii?Q?fN5gWFXJNBmWGrZvVKaBlA5KXk4V2HAKxOhitTaFDERVXFN2R2cbfTk+349F?=
 =?us-ascii?Q?lw6pahQJvaIOIyFGuqLJwT/onPFK9JndKBU4ZTjth6Zaw8GaCrRdAjywHhny?=
 =?us-ascii?Q?nRwfFtRJCwpgS9pleq0ylWE5SazkLfXDX7+F6ksdYF9SoVFZYgvpev6iXbui?=
 =?us-ascii?Q?RYcbU9e9e/XnVRxz42fTd4YV54VSPShy2ZL9Gu7MRkaYNc8L2F67DntWNdOQ?=
 =?us-ascii?Q?EsJ4lIGkQuZBtxe192o5vN1jTSPIAjjVHURcTNdblfmiEzi5lsy2R96AufSc?=
 =?us-ascii?Q?rRRoauZlPVP+7oyEOy6PbbohC1GlraVsbbd4xLtAS6FgEHpNtzxMJYDkBUNc?=
 =?us-ascii?Q?N5tAlAHR0LYUQO38Vrxb4MFRzzGYYcVIEeD2KaUA6H/T5F3c7GLVQW4p87Gy?=
 =?us-ascii?Q?dIMxRi1zYQwPhwjzcxh49v55glXXfNTrcjN33xhqQrb6340TYcJDnc6wQjZc?=
 =?us-ascii?Q?egGv4YSen/83AE9ElvhcgjluIdP0MXaqIb9Co5/z+tlhSH4cFjw0PW/lsoSW?=
 =?us-ascii?Q?w4MKAxZJFL9poK1NXoAYvtQMjDkOYWqcRC4XCVpy8d0rSfnbmJBiaALj8zh4?=
 =?us-ascii?Q?yOGXKXUhwrTHg7O4drMnNMJ7exL97R0jW8fWRNsIq+MHBNwxuvz5H0B+Y0OZ?=
 =?us-ascii?Q?YjXWrj1jZ22FmggGXSUyj0RUIGkbedSOx7tdK2eB456Xf+ai3tP19+zZcTGd?=
 =?us-ascii?Q?lyEZJdk4u4yuAwvkHal05zyYnHJiTUEcF3I/gFMOwUq9kb79DJ7mkgrSLn0p?=
 =?us-ascii?Q?LxhGXO/HBQQjgdYH+zE5F+gtQv9ZNeiOWyPxy5z/8/Zjvv0lW0dDHuV70gVD?=
 =?us-ascii?Q?aV8Zp6dmQD+Bii1K7m7ytRQYpOKGejmoogZT2KKGNjiBAJ1ukNOgIbQtD0Ml?=
 =?us-ascii?Q?f4lwZo+WozbX7FWP4NGYNyCXAlNZnxDYf6Hw4sRHfRXlyDk4DYPe/NTB6ODf?=
 =?us-ascii?Q?Nwkjxg6rRO9AKfXbVaxLqOkEhXKQKFcmCA67zxcQKyFFN8j2+EzURwbKi3Hg?=
 =?us-ascii?Q?bazFyFNzuhE+IZdNcrXFLDVwwokH6EJCZNlsvEOaZItomXx3USwmocZ1bxIv?=
 =?us-ascii?Q?8gt7bRkOtiH49lpiXj27Vwn+d5QzyBEMVoSVE/qnSDgKAislx3ay6oxvef5b?=
 =?us-ascii?Q?TyonKMmZaVhZDK82KnntoNj+5fE/Rvxwk82GNHe1tpGUBcs9vVCh/rYz4tuI?=
 =?us-ascii?Q?urxCBL59XKpX38sohOqkjWR5VXg35eBMsjGIss9mhENXdsQXnLm5IigZs0Zt?=
 =?us-ascii?Q?uJb/jB8mMPRPI2SG86pmmQFVo/u4SRCyNEWfFIInxME2tba6esQzmn3wHRk7?=
 =?us-ascii?Q?5jwrn8l2YfnevoubEAZdtkGbK3kMbtpFCV4KEdMK8Au5EnMtlBYV0hSwiYTr?=
 =?us-ascii?Q?A/VBMcsM3Ub3/gRbRSAEgikbTP6KpMjRiaXxTvbxdfvDw2O/3vIpiEyzEqAy?=
 =?us-ascii?Q?e1p4w9wKw/VbQasDQsSzQlI9SAFZTKRh9unQ/4bqUNpNnmbv2jqG35/NywpT?=
 =?us-ascii?Q?z3xlV16f7YYmSpItFEv6AdncJNTTZy8VHIxEmEb6?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ec75141-d6d5-4808-1e7e-08d9f1ac03a9
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 00:25:34.9750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c/42CmQP0Z39AZ6eRQbEmt4aNDHYJh22sdxFwqqE/aBGGRyq5Z/wCB15K+yAZLhX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR15MB4178
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 6yAFfTq6DfaWQiNR8pHCgigOzssa6utk
X-Proofpoint-GUID: 6yAFfTq6DfaWQiNR8pHCgigOzssa6utk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-16_11,2022-02-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxscore=0
 mlxlogscore=591 lowpriorityscore=0 adultscore=0 impostorscore=0
 bulkscore=0 spamscore=0 clxscore=1015 phishscore=0 suspectscore=0
 priorityscore=1501 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202160131
X-FB-Internal: deliver

On Thu, Feb 17, 2022 at 12:13:53AM +0000, Matthew Wilcox wrote:
> On Wed, Feb 16, 2022 at 03:57:39PM -0800, Shakeel Butt wrote:
> > On Wed, Feb 16, 2022 at 3:12 PM Matthew Wilcox <willy@infradead.org> wrote:
> > >
> > [...]
> > > > Here I'd keep _page (or _folio, if you want), because
> > > > it makes it clear that the function goes over all pages
> > > > (and is expensive therefore).
> > >
> > > But there's no intrinsic reason that it should.  If that's a
> > > performance problem, you could keep slabs on a separate list
> > > from, eg, file or anon memory.
> > >
> > 
> > Is there enough space in the struct slab for that list or do you mean
> > something different?
> 
> Well, I don't know what data structure your for_each_page() uses, so
> I don't know what to suggest exactly.
> 
> If it's an iteration over the entirety of memmap, then maybe you'd
> rather iterate over each kmem_cache like /proc/slabinfo does?

For SLUB /proc/slabinfo ignores pages on percpu partial lists,
which can significantly alter results.

For slabinfo.py the accuracy is more important than performance,
at least in my understanding. It's not a tool which a generic linux
user would run often.
