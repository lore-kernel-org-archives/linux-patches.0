Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8AD2582
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:24 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 94BA11F391
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 75E9C13A92
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id bL4dGmVnE2KrIAAAMHmgww
	(envelope-from <vbabka@suse.cz>)
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000
Resent-From: Vlastimil Babka <vbabka@suse.cz>
Resent-To: patches@lists.linux.dev
Resent-Date: Mon, 21 Feb 2022 11:20:20 +0100
Resent-Message-ID: <fc315ec1-7f95-6ccb-0544-b6a9d18605c8@suse.cz>
Received: from dovecot-director2.suse.de ([192.168.254.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	by imap2.suse-dmz.suse.de with LMTPS
	id cHMICiGsDGKvPQAAMHmgww
	(envelope-from <vvs@virtuozzo.com>)
	for <vbabka>; Wed, 16 Feb 2022 07:47:45 +0000
Received: from relay2.suse.de ([149.44.160.134])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
	by dovecot-director2.suse.de with LMTPS
	id oC8YCSGsDGIUZQAApTUePA
	(envelope-from <vvs@virtuozzo.com>)
	for <vbabka@imap.suse.de>; Wed, 16 Feb 2022 07:47:45 +0000
Received: from relay2.suse.de (localhost [127.0.0.1])
	by relay2.suse.de (Postfix) with ESMTP id 1C472A3B84
	for <vbabka@imap.suse.de>; Wed, 16 Feb 2022 07:47:45 +0000 (UTC)
X-Virus-Scanned: by amavisd-new at relay2.suse.de
X-Spam-Flag: NO
X-Spam-Score: -2.112
X-Spam-Level:
X-Spam-Status: No, score=-2.112 tagged_above=-9999 required=5
	tests=[BAYES_00=-1.9, DKIM_SIGNED=0.1, DKIM_VALID=-0.1,
	DKIM_VALID_AU=-0.1, DKIM_VALID_EF=-0.1, NICE_REPLY_A=-0.001,
	RCVD_IN_DNSWL_NONE=-0.0001, RCVD_IN_MSPIKE_H2=-0.001,
	T_SCC_BODY_TEXT_LINE=-0.01] autolearn=no autolearn_force=no
Received: from relay2.suse.de ([127.0.0.1])
	by relay2.suse.de (relay2.suse.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id KVcPOkfp4gkk for <vbabka@imap.suse.de>;
	Wed, 16 Feb 2022 07:47:39 +0000 (UTC)
Received: from mx2.suse.de (unknown [149.44.161.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id 85C5FA3B83
	for <vbabka@imap.suse.de>; Wed, 16 Feb 2022 07:47:39 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2139.outbound.protection.outlook.com [40.107.20.139])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTPS id 56B08ACF3
	for <vbabka@suse.cz>; Wed, 16 Feb 2022 07:47:39 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a2f6gQzJNwVKFVt2X/ZWVpbMD9OVF+qM8m14q7b1z2s2Z1qNGm6TcxdtffDq4QHS4+aJdQsN8UHTL4D3GxeZqZLHt/xk9oe+L0JPv1w/hn2+6bLg9+LGL0qxVDY83pcrryBVJWkMY0JwlgL9+lJEIpGL4Ci0jJLtvZ33+SPgub2hHYStEUQK3+VFjOSSPPR9CF8vg6ZHiTOggK1Wy1PEQR70OBl4MgyJLzk7+SA1x+cv8YpPqCtVqrb0/Frw9xIUrWQdAdMJhSQYgArF/m9+d+nI8TnBo4c0WE3VCofNTHAL8gDsoahSQfvIPeiXPxIMjgtgAeXpHrCmtbklF0T+Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d2wmAy54jNo5I7IwIh8qCWeaCNyhZ7fNCl+dhQkPETY=;
 b=Y6CCMMfx0bPafNQs2gjXeK6k00R+qsIjWA8ZOAOtKF7QfB+ZdpYTTfQlPoyKlJun72thRCXn8miN82Q35P3f7PGQO2zDvKLnfTRXXQNkuD+XxpdGj2X95QWcCTQ9Nn0Df1vwZArMA482zyyoP0qAH+w7/RNU98x1d2rprL8pjAwUsZpqFkRgJ/y0RG576w9kYgpIvGCE4fJLaZ/OhjrROA7sZvg5Nxa8rtK+vr+BkHJuIiAg/JpB1l/AknTPmOoECecX8zTAFftsIbaPoeWJhY8Vmzy9tstR+njjJH2zE6M6WW8IFPS8i9yPjI57BddTlx/0+UZMLkPFjNPaeieUUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from AM9PR08MB6241.eurprd08.prod.outlook.com (2603:10a6:20b:281::21)
 by AM9PR08MB6950.eurprd08.prod.outlook.com (2603:10a6:20b:411::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Wed, 16 Feb
 2022 07:47:37 +0000
Received: from AM9PR08MB6241.eurprd08.prod.outlook.com
 ([fe80::2994:f9d7:4f06:8c3b]) by AM9PR08MB6241.eurprd08.prod.outlook.com
 ([fe80::2994:f9d7:4f06:8c3b%5]) with mapi id 15.20.4995.016; Wed, 16 Feb 2022
 07:47:37 +0000
Content-Type: multipart/mixed; boundary="------------XY8l0FzNj0VUQ6sIn7CZNxYh"
Message-ID: <35486a00-791c-3b1b-14e0-476e6242709b@virtuozzo.com>
Date: Wed, 16 Feb 2022 10:47:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: tools/cgroup/memcg_slabinfo.py is broken
Content-Language: en-US
To: Roman Gushchin <guro@fb.com>
Cc: Linux MM <linux-mm@kvack.org>, Matthew Wilcox <willy@infradead.org>,
 Vlastimil Babka <vbabka@suse.cz>
References: <327b9e92-88bb-d66f-e07c-526161db539b@virtuozzo.com>
 <Ygw3au+tPdg2MXYT@carbon.dhcp.thefacebook.com>
From: Vasily Averin <vvs@virtuozzo.com>
In-Reply-To: <Ygw3au+tPdg2MXYT@carbon.dhcp.thefacebook.com>
X-ClientProxiedBy: AM6P193CA0086.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:88::27) To AM9PR08MB6241.eurprd08.prod.outlook.com
 (2603:10a6:20b:281::21)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a6525a50-b113-4d82-cbee-08d9f12099ad
X-MS-TrafficTypeDiagnostic: AM9PR08MB6950:EE_
X-Microsoft-Antispam-PRVS:
	<AM9PR08MB695069775DD7BB93EADAA34BAA359@AM9PR08MB6950.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	V67If50eVIk4e+qYHutvOKczgmlfeXJpf/gNoJDvucUaftEVk6RVIS0W63Jd3zxsu5zR8yNhYVd/ATdHaHMuNNxHQQciQnDpDEzVI+KmKJ9KE/M9jMXPtZEztRzWiHqB0xXggsPJtc/xRZXhFVNzw8ea13v4Gu0LTfgdR22DqQmbJ3hiaAMGlDN0RrQIx+MbN9uPkWLPh0PsGXCf47+G0aNpx7OK2Nu7tTwiNEDBRCRzfqdVWVCQCNZnXPOGZFzM3WMWGwSgsu1wG9AWoFcJRtXwTfG2JX/IQMVCE5jE4fffNdhgcS7N8EPHaSxTHZDvzlE18DGzmVdFSCTx5SuDIYcL1NfFuaGIrYk6NJESdavIxOzx9YOogjP2HJU7mgE07BrycY52qwChzt6LArNj7iXvy+maHTXN9xyTB6uNYEb3aLc/gQPrc5TAFgaR4oi4FeB5ejTGjG1/5FSYmpzMoTWb8m+ekHOjdxt6Fm5yclaw9ETHVWGTNViDwt5YM+DxJs4JjFnpNfc3uq1k6JCVF93KPp7rsGNaC2ZzQ8iPAA/XrF7DhvEzrIsd73Dd3b0G0GGBN103f7qIuo2EG4beoPslUOMIeCncpVswVNwiiVW04gW6Oo1OjSi4r3fWj0cYhLa9WRKlAVMb3pw58YPE3fmYN54ysMWU8FnG2PS4uZWhgKa5shdkXTn/jQPuEDSycx75wj1z3ipgbQBrbYtHsnULgBpvDm+pv6g7nSQNtl7jd8ESLsdZAhAuENZXctAt7dxu06x8bI/RWGV+q1WcgA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB6241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(235185007)(38350700002)(8936002)(38100700002)(31686004)(66946007)(66476007)(8676002)(66556008)(31696002)(36756003)(4326008)(316002)(83380400001)(508600001)(86362001)(6506007)(33964004)(6486002)(54906003)(6916009)(52116002)(2906002)(6512007)(53546011)(2616005)(26005)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R2wxMU1hQ25rOGVmNUxwVjRjYTUrb0lROU1Ha2hKNmZvZjV1ejBiZU5iT1Z2?=
 =?utf-8?B?a0tONDFpd3dkQjZzeWRTd3UzRTlHQ3ZNNVFiOUF4VDdMYUwyUllKS0ZJMi9x?=
 =?utf-8?B?YSs4by9BQlBmYnJmQ0tFci8zd2RRaFZzdGlwZ2V6OG9qM21DRVBkUmpKR3do?=
 =?utf-8?B?TkgvWWRWMkFlbU8zbzU0VTVUSUlvT0I3WXB5ZzVHcktBWkJ3NFJIeFdpVytl?=
 =?utf-8?B?QThORUxEeWdTT2RSYnRiYytjQnNTSE1FTmd0V0JCNURKRW8zV0xBOVRKc1RN?=
 =?utf-8?B?NTBNZ01Eck5kY1QrVklCWEYzZ2ZVaEpNY1BwekRpd2k5RmhxOHJoOGZrd1pU?=
 =?utf-8?B?a3N5b3U3d0UxbDNnanhiZENwR2xYL2FxcXdUaWxjZlJ2bHh3bUIySHBlUlRs?=
 =?utf-8?B?OHFaRmgzRGlweXVHcHNnMFdwQ08yT296QWd0WDVTdFUvUEtyR1YvOHRCOTFi?=
 =?utf-8?B?TkVvbTR4MWlNaHdDNUZ4cGdDeTQxZjB3bENLRWJ5MVBnOTh2WWRJSE9RYzU3?=
 =?utf-8?B?N0laYjM0NHN4b3JjZDQrWDc0UEFrQk1GbEE2YTZZSzdGT05iQjZqS3Z0alZQ?=
 =?utf-8?B?MUlGRUN3OXlQRlZtYldGZXRlUVFTYzBUVFVSR0tsUytpMFFhcWsySlNYWHE3?=
 =?utf-8?B?SmhmbGRvQWU2WTNBNWVFMEdkdWJoUXgwQ0UxYmh6ZWwxajhIRXg3QXEyMml0?=
 =?utf-8?B?NUx0L2R1SWRMeHc1S2dzSkpadGJWT3psbDREUFpvUjZLQ1IxWGpvMlRkZktp?=
 =?utf-8?B?NG9kQVBBY0tTSG5Ib0VKa0RvY29jL1BPRElDZWxWQXVxd3dCQ1NhQ1lhTkJW?=
 =?utf-8?B?QkdTbTRKSmRKaERnS05YejJyUEdSN2RHSzR0czFZMEdDMUgyN1JjcVA5MDJC?=
 =?utf-8?B?SWFtSWFzZjZqMVNwRUJ0SXI3WjdsN3lZa1Jodzd0bWFSOTFsNllLY3l4OW5t?=
 =?utf-8?B?aVR4OGZMaE9kMzRqeEtONS95YklYNWs0YUp5UlBpa1BYa3ZxakNMbGFnRmhQ?=
 =?utf-8?B?MzdpQit2ZHR3Vk9vempQUUZsTFMwTGs1N3NDYnc0Nml0OWJWWEtsYXZsYlY5?=
 =?utf-8?B?UTlleXVFVUFmOUFkbE5IWU5keWs5NUJzcUd4OVViZ29uaXU4RDBTdkJvMmtO?=
 =?utf-8?B?QkxPakZtQUtaK25UVGdUY2dYQ1RTdDYralZLN2dkYUo4NllBMUVVMS9JK3Np?=
 =?utf-8?B?S3k3clB5QXRySy9nb3NtS1hoUlo5TE93ZmRTdGtvRHpRN0lnajNmakVvYlZk?=
 =?utf-8?B?RHNXc0FFRTlaekc5N3RueWh2R0doNjN3WElhQ1MxQ0U1cTdEdnBMWnJJZUxn?=
 =?utf-8?B?M0QxaXRwOUlCM20xV1BoWEZrTkhsM1ZYZmtWVXRIbVZqM25oR0VsbGdMbXBK?=
 =?utf-8?B?Q0RyKzhzRFNEYXFhOHVEYUFGWS9idjRtRkVmdDQvVnlsSFRocGJWQXRTZHI0?=
 =?utf-8?B?aVcvUHlhM3Z6eHJ3aXRnU0I3WWlESlBUQmpjZnhGSnovQ05OVmt2S3dGZ2t5?=
 =?utf-8?B?VnIwS0FRRUtrRXBPV21Gb2lPZWdOZzFjNVNPS1l5TVYvUURsQ29iWkMrZGFL?=
 =?utf-8?B?a0ZPVkhBZXNBUUovczZUaHQyOHI1S25ManVuM2ltcHVEV1FteDlScXc4Sk5V?=
 =?utf-8?B?eXE0MHRreDd4cWowQytUNGJsMTYwTnkyQys5eGx6T3E0a1hMOEJNVk5TZTN2?=
 =?utf-8?B?ZDRiNW83aUlVNGtHNXBzU2J5OUJXV1Y3dXMyVDZFRGY1SXdURitpVk1lNXpK?=
 =?utf-8?B?R0QrM25helB5dStVNmtyZHNrUzZFaERHNllVOVhJY1Qzd2RIOGo3S3dJZytj?=
 =?utf-8?B?eFl3cldDNDYzODhLY3NJaG5rc1RmRmFNQ3g4S2M1UVRMbHFqU280NTV6dHkw?=
 =?utf-8?B?eWZUVWR4RW0xSjQzTW8vZFFXVU15d3dmak9YY3lvNUxZc3EwUVFwV1M4bktX?=
 =?utf-8?B?amZ6UG9Wc2UxRWxWTDViZmh5Q256RE1Gd3d3NEJaUUgwZVliWmY3bWZoQTlM?=
 =?utf-8?B?eGVzMHpCVjZJZEpQU0ZrSjBndERUOG9NRWlxbmZ2WjZ6UkNSNUppVEhVRjJ2?=
 =?utf-8?B?cFo4cko3em4vL1M0VjRNSHp1Y0FuelFEYzYwaE55bGRUUDc5MkphTE9rakpL?=
 =?utf-8?B?OWdESDN5Q0pscHFxOUl4YXo4THNSc0VPVHkra3dQbGxPQ0NqZGRseG9relhR?=
 =?utf-8?Q?fj7pUu3O+4oml2gQ5wE0YOg=3D?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6525a50-b113-4d82-cbee-08d9f12099ad
X-MS-Exchange-CrossTenant-AuthSource: AM9PR08MB6241.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 07:47:37.5738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jve7U+deWHZxbJJ9w35Aeg1w6CeC99+BQ0zTltNi/Q6LrR3XgdKDAccgdgEgbZ+ZkYHW0b6u8oHSR/+8kN6+Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6950

--------------XY8l0FzNj0VUQ6sIn7CZNxYh
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16.02.2022 02:29, Roman Gushchin wrote:
> On Tue, Feb 15, 2022 at 04:22:14PM +0300, Vasily Averin wrote:
>> Dear all,
>>
>> commit 07f910f9b729 ("mm: Remove slab from struct page")
>> broke tools/cgroup/memcg_slabinfo.py script.
>> It was used as replacement of /psys/fs/cgroup/memory/memory.kmem.slabinfo
>> and was used to monitor slab objects related to specified cgroup
>>
>> # ./memcg_slabinfo.py /sys/fs/cgroup/memory/lxc.payload.c9s/
>> # name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
>> Traceback (most recent call last):
>>    File "/usr/bin/drgn", line 33, in <module>
>>      sys.exit(load_entry_point('drgn==0.0.16', 'console_scripts', 'drgn')())
>>    File "/usr/lib64/python3.10/site-packages/drgn/internal/cli.py", line 133, in main
>>      runpy.run_path(args.script[0], init_globals=init_globals, run_name="__main__")
>>    File "/usr/lib64/python3.10/runpy.py", line 269, in run_path
>>      return _run_module_code(code, init_globals, run_name,
>>    File "/usr/lib64/python3.10/runpy.py", line 96, in _run_module_code
>>      _run_code(code, mod_globals, init_globals,
>>    File "/usr/lib64/python3.10/runpy.py", line 86, in _run_code
>>      exec(code, run_globals)
>>    File "./memcg_slabinfo.py", line 226, in <module>
>>      main()
>>    File "./memcg_slabinfo.py", line 199, in main
>>      cache = page.slab_cache
>> AttributeError: 'struct page' has no member 'slab_cache'
>>
>> Any ideas how to repair it ?
>>
>> Thank you,
>> 	Vasily Averin
> 
> Thanks for the report, Vasily!
> 
> I'll take a look, we need to update the script according to the latest
> slab/page/folio changes.

I've workarounded it temporally by the attached patch,.
--------------XY8l0FzNj0VUQ6sIn7CZNxYh
Content-Type: text/x-python; charset=UTF-8; name="diff-memcg-slabinfo.py"
Content-Disposition: attachment; filename="diff-memcg-slabinfo.py"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL3Rvb2xzL2Nncm91cC9tZW1jZ19zbGFiaW5mby5weSBiL3Rvb2xzL2Nncm91
cC9tZW1jZ19zbGFiaW5mby5weQppbmRleCAxNjAwYjE3ZGJiOGEuLmI1MjdhODQ0YjRjMiAxMDA2
NDQKLS0tIGEvdG9vbHMvY2dyb3VwL21lbWNnX3NsYWJpbmZvLnB5CisrKyBiL3Rvb2xzL2Nncm91
cC9tZW1jZ19zbGFiaW5mby5weQpAQCAtMTEsNyArMTEsNyBAQCBmcm9tIGRyZ24uaGVscGVycy5s
aW51eCBpbXBvcnQgbGlzdF9mb3JfZWFjaF9lbnRyeSwgbGlzdF9lbXB0eQogZnJvbSBkcmduLmhl
bHBlcnMubGludXggaW1wb3J0IGZvcl9lYWNoX3BhZ2UKIGZyb20gZHJnbi5oZWxwZXJzLmxpbnV4
LmNwdW1hc2sgaW1wb3J0IGZvcl9lYWNoX29ubGluZV9jcHUKIGZyb20gZHJnbi5oZWxwZXJzLmxp
bnV4LnBlcmNwdSBpbXBvcnQgcGVyX2NwdV9wdHIKLWZyb20gZHJnbiBpbXBvcnQgY29udGFpbmVy
X29mLCBGYXVsdEVycm9yLCBPYmplY3QKK2Zyb20gZHJnbiBpbXBvcnQgY29udGFpbmVyX29mLCBG
YXVsdEVycm9yLCBPYmplY3QsIGNhc3QKIAogCiBERVNDID0gIiIiCkBAIC03Nyw3ICs3Nyw4IEBA
IE9PX01BU0sgPSAoKDEgPDwgT09fU0hJRlQpIC0gMSkKIAogCiBkZWYgY291bnRfZnJlZShwYWdl
KToKLSAgICByZXR1cm4gcGFnZS5vYmplY3RzIC0gcGFnZS5pbnVzZQorICAgIHNsYWIgPSBjYXN0
KCJzdHJ1Y3Qgc2xhYiAqIiwgcGFnZSkKKyAgICByZXR1cm4gc2xhYi5vYmplY3RzIC0gc2xhYi5p
bnVzZQogCiAKIGRlZiBzbHViX2dldF9zbGFiaW5mbyhzLCBjZmcpOgpAQCAtMTk2LDcgKzE5Nyw4
IEBAIE9PX01BU0sgPSAoKDEgPDwgT09fU0hJRlQpIC0gMSkKICAgICAgICAgICAgIG9iamNnX3Zl
Y19yYXcgPSBwYWdlLm1lbWNnX2RhdGEudmFsdWVfKCkKICAgICAgICAgICAgIGlmIG9iamNnX3Zl
Y19yYXcgPT0gMDoKICAgICAgICAgICAgICAgICBjb250aW51ZQotICAgICAgICAgICAgY2FjaGUg
PSBwYWdlLnNsYWJfY2FjaGUKKyAgICAgICAgICAgIHNsYWIgPSBjYXN0KCJzdHJ1Y3Qgc2xhYiAq
IiwgcGFnZSkKKyAgICAgICAgICAgIGNhY2hlID0gc2xhYi5zbGFiX2NhY2hlCiAgICAgICAgICAg
ICBpZiBub3QgY2FjaGU6CiAgICAgICAgICAgICAgICAgY29udGludWUKICAgICAgICAgICAgIGFk
ZHIgPSBjYWNoZS52YWx1ZV8oKQo=

--------------XY8l0FzNj0VUQ6sIn7CZNxYh--
