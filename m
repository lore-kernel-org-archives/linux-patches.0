Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252C22581
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:23 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7A48121136
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6A0C613A8D
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id Km2vFGVnE2KfIAAAMHmgww
	(envelope-from <vbabka@suse.cz>)
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000
Resent-From: Vlastimil Babka <vbabka@suse.cz>
Resent-To: patches@lists.linux.dev
Resent-Date: Mon, 21 Feb 2022 11:20:20 +0100
Resent-Message-ID: <3d7b2833-e692-0f8b-d29a-5dbb40c5bb7c@suse.cz>
Received: from dovecot-director2.suse.de ([192.168.254.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	by imap2.suse-dmz.suse.de with LMTPS
	id QA0wN4Y3DGKfDgAAMHmgww
	(envelope-from <prvs=3045f32795=guro@fb.com>)
	for <vbabka>; Tue, 15 Feb 2022 23:30:14 +0000
Received: from relay2.suse.de ([149.44.160.134])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
	by dovecot-director2.suse.de with LMTPS
	id IMRJNoY3DGIjFQAApTUePA
	(envelope-from <prvs=3045f32795=guro@fb.com>)
	for <vbabka@imap.suse.de>; Tue, 15 Feb 2022 23:30:14 +0000
Received: from relay2.suse.de (localhost [127.0.0.1])
	by relay2.suse.de (Postfix) with ESMTP id D2D27A3B84
	for <vbabka@imap.suse.de>; Tue, 15 Feb 2022 23:30:14 +0000 (UTC)
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
	with ESMTP id O0KpZ0xwJGhI for <vbabka@imap.suse.de>;
	Tue, 15 Feb 2022 23:30:09 +0000 (UTC)
Received: from mx2.suse.de (unknown [149.44.161.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id 64144A3B85
	for <vbabka@imap.suse.de>; Tue, 15 Feb 2022 23:30:09 +0000 (UTC)
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTPS id 1B46EACFD
	for <vbabka@suse.cz>; Tue, 15 Feb 2022 23:30:08 +0000 (UTC)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21FMZ55u013917;
	Tue, 15 Feb 2022 15:29:52 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e8n3d0aqr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 15 Feb 2022 15:29:52 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Feb 2022 15:29:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AccwffuCbGoXoR4hgG1tXclD50zhDHGEbg8tLMIOLKF4/LzF+mEjhWjvc4QKZZtb8pPxbgx4QvF1CSxLaecKBZ5g5TI2gHN/P5/tgVUe+QgjkE9UrovMbFjaVYnbj9gjMgDHgKbqGq00egKN2WtiNPkpTvIa/2VNz/awLJHZ1M/dzK8+ahFidaBBUnVMqC2TN7+IDwG+9JWZgvaHPKAjWjIfyOO0vvIT9nspdgix0QOyD3YB3lDVF66u4RYvu23LhMBC0b2RYK1jQugzDl6UKBsiSVLGiEQMQsa04qB8W/7Bumeii0ZrQcv7wMmreoplBK6nrhPIeNlNhuOcv/7DJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SWxIr+OoT27y+ZdVOrZe31nH/IGvN6i9C3qc0beTPtg=;
 b=XZa6ChdYDS3FUnZ57sPwy88aVHoqFBzuPWXW2B1pQ+OVbSRyK7iHtlwh7bHQ+rS4RrVg/OkR9P1HYWp0ooqUaLeiBenp9XHitjyn0mkrWEkusRXzx7MMUN6eIAmBGCf4+Q8Uig7CaDN6/o1FK90jlr1Scgqj+9IwesfpSvOhdWClUyRHbE1Bl4NK6EmxaunilIjk55T/61W/yTy3+3UuzjBIuulkUm++t4CkRq1QtpU0diwod7BbrA7E9Zi9Pys9LnAGh9W3txTJp76AMGxu/f5PsXkw9hUEHBYZ570ACahfaHVCovLN8y8wVBHUdsdEbMI+dqoYR02EUW338TCfnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by DM6PR15MB3675.namprd15.prod.outlook.com (2603:10b6:5:1d3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.17; Tue, 15 Feb
 2022 23:29:50 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::8038:a2f9:13d7:704c]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::8038:a2f9:13d7:704c%5]) with mapi id 15.20.4995.014; Tue, 15 Feb 2022
 23:29:50 +0000
Date: Tue, 15 Feb 2022 15:29:46 -0800
From: Roman Gushchin <guro@fb.com>
To: Vasily Averin <vvs@virtuozzo.com>
CC: Linux MM <linux-mm@kvack.org>, Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: tools/cgroup/memcg_slabinfo.py is broken
Message-ID: <Ygw3au+tPdg2MXYT@carbon.dhcp.thefacebook.com>
References: <327b9e92-88bb-d66f-e07c-526161db539b@virtuozzo.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <327b9e92-88bb-d66f-e07c-526161db539b@virtuozzo.com>
X-ClientProxiedBy: MWHPR14CA0053.namprd14.prod.outlook.com
 (2603:10b6:300:81::15) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e653b0ad-2c3f-4588-785f-08d9f0db0f97
X-MS-TrafficTypeDiagnostic: DM6PR15MB3675:EE_
X-Microsoft-Antispam-PRVS: <DM6PR15MB36752AAAD1AE5B82140F62C5BE349@DM6PR15MB3675.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RubDyNZLNi+O8JSIiTJqZO5RYtQr6IRXOC9WQG+RNT2U8BkH7C5nYHTmx9ghqiLD1h2AQ99C98b5uRBnB5ZRSZeyIc6y3qsNE1jHdEHL9VO+da9kgZHghcRd4ruQzT5hTfDctW9yY4w11c+syP+HcFayi7F3IwKCmm0Uaf4y9HZtFanwItGC47jIzQoaO/xL94fiz/Yc3LTZRZ4UwvoCAXK2uFcAE/lwWeGCyOd5cK7QXj82gxKgEOICM0p3LpnYBlOmuZrBoIlEU0zkC7u4Dc4/46hFTyXkaThmbbkXGeDfRirxiXjqNw8p79AnGCL180tVUNWghpHCVtJFM4V326hkZmzUz2xYzI58UUL5OUabVFQ9KnPF5VibEatSJxiEi+uAT2quOY6iI4/dH0xuP8jdd4TZAFKKhvuQXlYY/VvtWDxu38zxI6PR+D0iSI3AywIYff8WJrhs/LUm/IHMNTuvPTd5mm+1lBL8EumiTlzaJcxPlkKGTL9bm5gl286crcPFUYfKId6n7fg7XthRfILIxHgLyoUO2PVstkKhMsQLdznKIdHrpUxvOAKruEfj/gtZX66AilfhYreOQGEzbfwY0hyKIxpeZcsWafY2xIEWk30NfywDfbzqr8HwEgF6vYcd4lZcOm8WjZZoqtO7q0vJIheqJhhG/6WJI4VV+OMVIkmZE5J1614wXcc3xMY5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(66476007)(9686003)(6916009)(66556008)(186003)(86362001)(8676002)(4326008)(316002)(6512007)(6506007)(8936002)(54906003)(6666004)(83380400001)(6486002)(38100700002)(508600001)(52116002)(2906002)(5660300002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6vVZm95W2+AKaj272tNjsxzaZWf/430RwEwIVu/lGODQwV9JVPo2pTLU3iUM?=
 =?us-ascii?Q?qR7ei1m+2k+kaim+P79lVjuOGKqsgRDcpk/VJ1mAqLOkxgw3oiifR8L4IcVC?=
 =?us-ascii?Q?5MW0wpu7YWsoke7KcBr1Eau/uj0FKvVZiEZC5H4dqwkmZeHDBZmRdHAMdYsZ?=
 =?us-ascii?Q?vPecRcPuRzjvsD1D1JqKD2pYSbC5aCxMWQkd0k1uaz55JI6Z3nhfK6OvTkMS?=
 =?us-ascii?Q?BrNp/lHd4BpG78RwidQ73ZIj4ouZ5lsVKfjn1W1TzXnW+0M4jMtYEPHCecNT?=
 =?us-ascii?Q?QWS0m7AcOsze6gPCBTQjCAS6PGQFIPwpggzxfPphiH1QzKKkwAoEBso/D9dC?=
 =?us-ascii?Q?ns9BXEyqLUfgzeosUXhu2+p8/4Y4RRGMv47Ke2VZy8Rqa5Ckg2cLvWVzQkAi?=
 =?us-ascii?Q?PcUtLsIZ8X7KmhnH602RJ8DQH2bf3C0mJV2Bir2eLiuNtU4lipg8x2apoUAA?=
 =?us-ascii?Q?+sIVcmY10sPynBcRLnGo2I2M6Z6H1+qPDq25kmd5BMhEANLqLva4fklYAM6C?=
 =?us-ascii?Q?Y7Db/UgR0+XLfdCIlqbVuOuxDlu0yScjPGE0Zb9zsTa0DwvXIFt792n88rCm?=
 =?us-ascii?Q?d4XSxjSLNVwGlrRkpKOgApRxiIAigMyAklqUx+tv1ai/4pJRUh2athL5MT8F?=
 =?us-ascii?Q?DMK+m/SzjJgJ3glB3gI8VEYyFzIFQYfvqNmaV+p45NHw7aUugrFGbtFZOvjD?=
 =?us-ascii?Q?8hT9X1dAfD2EDTMXQOb8gNbGLjB8Qcdw7KgRQRreEKLIp4ZlnwzEQSt7G6hS?=
 =?us-ascii?Q?8ts41l0MAb5rMn+zmrm9N58B+oJaNeHKRPp2svAoYpYVdQgOKXTf6u9xzGBp?=
 =?us-ascii?Q?pb0P2o6id2zn0EQ8axRa1FJL197KkFTCCKUOoHtqa92zArSWsZYqpRxL1GrZ?=
 =?us-ascii?Q?Q5sqCcY5XD6IlfXwYINgaPOtZ1JcmomHM38tSMsNJtiN4GYAUSW0h8pBOIIL?=
 =?us-ascii?Q?Iy0yhTJDqDIvqM3bRviW3Bjw9cl4zJ+n96WZfLpXg89CX6xoLq+vKjzerkvW?=
 =?us-ascii?Q?iQFlraI1JT+vrZdtMBc7qdOd1+mdr/wN3kCRimyYhwckmVB4ecuQwBADneAf?=
 =?us-ascii?Q?x3dHhEIFT+u2m3c9oZrL7YIrVFj6/pcw0m/UjKQTy/GbQmynl8YzAh0NIB0k?=
 =?us-ascii?Q?pG23xykW+No7xJWRaWdcrlhocN23xThuhRyCcDVAWOQp9r0p/y28dXbOaj6z?=
 =?us-ascii?Q?Xj/Npd3waLznSxiU/7dUixuVkMRvmRwCP/61horf7JtsldDxO6P+N+K82vc/?=
 =?us-ascii?Q?0dmk0yBMHURiWVou6BPf4Yi/QxYtcIC/gAlyxAOshHSHuhxSTMZvWPzbE5wH?=
 =?us-ascii?Q?CKIjrrWXwRxAfzy3wsWtAyQDuMa3gTEsGTD2Ow5G/2um7duOfWkxrjepnoCP?=
 =?us-ascii?Q?EgP8AZflYVW5EALiMOR3u2RIXZoKtUPOI6YhlSCY4hQyz+ljLwy3GoGrZevn?=
 =?us-ascii?Q?XqeVNWGtP4Y6nRDi8W0hRwgZWGFt+DzW46FBL9L6fbYVVu6Fw/dHF5ej/Yzg?=
 =?us-ascii?Q?MmJRmNk9ck4kivRJTj8Fy8OAD4I5P+z2id4BKZqO4cPoZcwursz3xhv6DZq7?=
 =?us-ascii?Q?BpIgHKdcx6RCsJm7qrjtR7iyVPOfMJXZHhE7A6gd?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e653b0ad-2c3f-4588-785f-08d9f0db0f97
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 23:29:50.1131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p8KhuKzi8Y1oJQ1vzk9tkdKDAYxceoEORUZeuUC8tM/GDGYajpvLIFUpYMD5HScs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3675
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: HVzRAhIMIyUkW7VYUclhJ40xXs6IN6jC
X-Proofpoint-GUID: HVzRAhIMIyUkW7VYUclhJ40xXs6IN6jC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-15_07,2022-02-14_04,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 lowpriorityscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 clxscore=1011 adultscore=0
 impostorscore=0 phishscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 mlxlogscore=859 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202150134
X-FB-Internal: deliver

On Tue, Feb 15, 2022 at 04:22:14PM +0300, Vasily Averin wrote:
> Dear all,
> 
> commit 07f910f9b729 ("mm: Remove slab from struct page")
> broke tools/cgroup/memcg_slabinfo.py script.
> It was used as replacement of /psys/fs/cgroup/memory/memory.kmem.slabinfo
> and was used to monitor slab objects related to specified cgroup
> 
> # ./memcg_slabinfo.py /sys/fs/cgroup/memory/lxc.payload.c9s/
> # name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
> Traceback (most recent call last):
>   File "/usr/bin/drgn", line 33, in <module>
>     sys.exit(load_entry_point('drgn==0.0.16', 'console_scripts', 'drgn')())
>   File "/usr/lib64/python3.10/site-packages/drgn/internal/cli.py", line 133, in main
>     runpy.run_path(args.script[0], init_globals=init_globals, run_name="__main__")
>   File "/usr/lib64/python3.10/runpy.py", line 269, in run_path
>     return _run_module_code(code, init_globals, run_name,
>   File "/usr/lib64/python3.10/runpy.py", line 96, in _run_module_code
>     _run_code(code, mod_globals, init_globals,
>   File "/usr/lib64/python3.10/runpy.py", line 86, in _run_code
>     exec(code, run_globals)
>   File "./memcg_slabinfo.py", line 226, in <module>
>     main()
>   File "./memcg_slabinfo.py", line 199, in main
>     cache = page.slab_cache
> AttributeError: 'struct page' has no member 'slab_cache'
> 
> Any ideas how to repair it ?
> 
> Thank you,
> 	Vasily Averin

Thanks for the report, Vasily!

I'll take a look, we need to update the script according to the latest
slab/page/folio changes.
