Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106E92585
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:23 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8F48B1F38E
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 75A6813A91
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id pYwLGmVnE2KqIAAAMHmgww
	(envelope-from <vbabka@suse.cz>)
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000
Resent-From: Vlastimil Babka <vbabka@suse.cz>
Resent-To: patches@lists.linux.dev
Resent-Date: Mon, 21 Feb 2022 11:20:20 +0100
Resent-Message-ID: <c52968fe-e516-060b-6371-ecf32bd0516c@suse.cz>
Received: from dovecot-director2.suse.de ([192.168.254.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	by imap2.suse-dmz.suse.de with LMTPS
	id 8Kx7Mg+pC2I6fAAAMHmgww
	(envelope-from <vvs@virtuozzo.com>)
	for <vbabka>; Tue, 15 Feb 2022 13:22:23 +0000
Received: from relay2.suse.de ([149.44.160.134])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
	by dovecot-director2.suse.de with LMTPS
	id YOGRMQ+pC2KJDgAApTUePA
	(envelope-from <vvs@virtuozzo.com>)
	for <vbabka@imap.suse.de>; Tue, 15 Feb 2022 13:22:23 +0000
Received: from relay2.suse.de (localhost [127.0.0.1])
	by relay2.suse.de (Postfix) with ESMTP id BF40BA3B89
	for <vbabka@imap.suse.de>; Tue, 15 Feb 2022 13:22:23 +0000 (UTC)
X-Virus-Scanned: by amavisd-new at relay2.suse.de
X-Spam-Flag: NO
X-Spam-Score: -2.111
X-Spam-Level:
X-Spam-Status: No, score=-2.111 tagged_above=-9999 required=5
	tests=[BAYES_00=-1.9, DKIM_SIGNED=0.1, DKIM_VALID=-0.1,
	DKIM_VALID_AU=-0.1, DKIM_VALID_EF=-0.1, RCVD_IN_MSPIKE_H2=-0.001,
	T_SCC_BODY_TEXT_LINE=-0.01] autolearn=no autolearn_force=no
Received: from relay2.suse.de ([127.0.0.1])
	by relay2.suse.de (relay2.suse.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id CD0K1mz80t0B for <vbabka@imap.suse.de>;
	Tue, 15 Feb 2022 13:22:18 +0000 (UTC)
Received: from mx1.suse.de (unknown [149.44.161.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id 5CD53A3B81
	for <vbabka@imap.suse.de>; Tue, 15 Feb 2022 13:22:18 +0000 (UTC)
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50112.outbound.protection.outlook.com [40.107.5.112])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTPS id 3CB3CAC4D
	for <vbabka@suse.cz>; Tue, 15 Feb 2022 13:22:18 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AL0wfjLT9NvJOF3Rh8sE2ackmnYPuuyrrkxKOZQGQVHe72ELh8RjZC4+5PyeUghlun3uE53QrarC2J3C2x0D2bll0HDM75A3Mbse8MpxfqBVxpxtusNiqXDr44sZOfHbm35BbtQBhr0EsNd4VPN+LFUDhXI/fagewZsR+6Jb9ZN4CmWt9B9jNcT/f5QumWtQwb04eqoT6xS+BGPG6i0YUTdocSk/IdO0Bdw1q3gtoD4ofBkuCigjWHsntlg6WFhx2hSedU38rnJJ2FyqDjel01P98fZ1ngMHqFLWdRTRC3tYDR6YiSn3XVmpiKJ9zGYDeWB9JyE6AvJ4HBskVwpvUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cGI1NfA0J4cgKLFRQHLILdkNbaXX8I23HFOqdp4pHRI=;
 b=a2J/VchkbYhKT+DdLY4PUjfK3gcLGlwwbBrH/QZvAMNly6Ld/Uo+e8U8VXfOcPkRf43HgqOm71dyX6pBIYqrVabifUSYMa3py3q67T0ieRg46MtbaNzEKBNn6GAqGazZbI1B2/VaiLbekb0cOOpaVy8uQCoD6sXTvfS5reL88Za2Bxa/c5sL+ILvb5oSA5Y+OXW3mnM2YwVk/w0cF1oGXzIheZfEYQo+C6Na3kIjViOW2HM6jBRqBlMrcYhB7uI+NPKGeLk5PwrFiktppmp/XJC/DEzJ1XbIy254fjqfaK1i9XkFgIzxxfA8P+HwbXUnVEORzZGuHxN3PCcsgzZ1Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from AM9PR08MB6241.eurprd08.prod.outlook.com (2603:10a6:20b:281::21)
 by VI1PR08MB5390.eurprd08.prod.outlook.com (2603:10a6:803:13d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.12; Tue, 15 Feb
 2022 13:22:16 +0000
Received: from AM9PR08MB6241.eurprd08.prod.outlook.com
 ([fe80::3cd8:dbd1:5abd:3884]) by AM9PR08MB6241.eurprd08.prod.outlook.com
 ([fe80::3cd8:dbd1:5abd:3884%8]) with mapi id 15.20.4975.019; Tue, 15 Feb 2022
 13:22:16 +0000
Message-ID: <327b9e92-88bb-d66f-e07c-526161db539b@virtuozzo.com>
Date: Tue, 15 Feb 2022 16:22:14 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
From: Vasily Averin <vvs@virtuozzo.com>
To: Linux MM <linux-mm@kvack.org>
Cc: Roman Gushchin <guro@fb.com>, Matthew Wilcox <willy@infradead.org>,
 Vlastimil Babka <vbabka@suse.cz>
Subject: tools/cgroup/memcg_slabinfo.py is broken
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0164.eurprd06.prod.outlook.com
 (2603:10a6:20b:45c::15) To AM9PR08MB6241.eurprd08.prod.outlook.com
 (2603:10a6:20b:281::21)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3faf7684-72a7-4f0c-d3f6-08d9f0862f0e
X-MS-TrafficTypeDiagnostic: VI1PR08MB5390:EE_
X-Microsoft-Antispam-PRVS:
	<VI1PR08MB5390973D62FD5D1C9DCAEB4EAA349@VI1PR08MB5390.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:751;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	GBdW4DmsXRm2SrCEBVe/QW5WeBBu8hdIgai2zKAT5MFCoUoFK9eiY1XZoqX6Ic1jacDixQDYFifymrVgjdAVyiG2NIEePTg9yQ9ZwF66WnkrtgvTBiogPUin0GRZerQ6udIPip0FVW3go9NFAaVCA1v4RNWWE8V++M23hc6rkBXbsvemN+dB7uDPIa7R3/u74q7jF8nIeLFV1euGwZwgDA5AU5AefcV84urv23zhNeAltnFtwMymlyAw6cxk+Sk+X6vxNkUUAsCSwIRrQ7NGtNhs6T9Gm8maTzt3jsLp00g0tLZJZ2HTb0YYgUGpq+YTtQlocnIRf0JbWm7JuB2IuBnghmhhnRMgUAt0szzlOj7dmActnA4ov7p7wO+G+DWGCSdj3a7E7h2kLGBw7L8hX1hL6kFqocmbdeRuf80W1k1MGBtptPq/mnf45Ax9VptrfN0gIn6EM1iHkdk3fpQS1+Ei4iddqKqkiYvwh9S8YHPw2mz8nOV7Y9WX6ktI7nmtUCvC6DZx0s59vxhVKVLWQcur6/8gpgwTGzMXA3KbVdkcBvYzLXyke7Qpzg1HrQNBwCV5eGF43MMs0vDdf7QpadoIPdH7kWljZJ70SA9x+vnJ8ypSfOE+CjrifhP2PN8eDNzlp7XLegwmA8dqZqxIO7fPjdS5P/27yALVgpGGGAQ1A3Rbzgm0/SOJfbJwiKlMScrRAwelS97k56OryTPYyyx/rHX86qXavkNNV80oXQpnrA4Ex6RbjDlJYfR8B9T8umtWQxyZvKp6OGyveYtX8A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB6241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(5660300002)(316002)(38350700002)(83380400001)(8936002)(2906002)(66946007)(8676002)(66556008)(66476007)(4326008)(31696002)(36756003)(6506007)(52116002)(2616005)(508600001)(86362001)(6486002)(31686004)(6916009)(26005)(186003)(54906003)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RnYvR01WU2lNQk5GUEYxVEYremtIV2Z3N2o3MXJJdit5SktQSHZKRW9lcDRY?=
 =?utf-8?B?Q0tNSlFEZDIrZXRUVFFoRjFlU0hWWEVFcHhIdHpRcjRIdldNQituS1U2VmhR?=
 =?utf-8?B?VmZheDdwQ2tydFFYVlJrbTZHYmVJQmVOcFA3eE04N1h1VFVPc0JvQVEzL0ZZ?=
 =?utf-8?B?bkRTWkZ6R2x6WU5VSnpsZkQ5dGNlR3dFN0RFaW5lUU9ZOW52S0RwQldWS1lR?=
 =?utf-8?B?bVNNRThvV0dvcWc5Tk5pTXdyeWJ4YWl0c3oxK0RTRnpWOHVBRFMrZkMvODJK?=
 =?utf-8?B?emozRmlJWnZIVlVyR2Q3U1JldVliK1BBTHJJU0ZnUkhCUEc4RkNvTFpON1or?=
 =?utf-8?B?aGNsOUpQcnluVW9WZDV3NkcydUx5SGdYQWt1MnJYbUFRakpML1FrQ2JLRXlK?=
 =?utf-8?B?NHF0bEtCS2ljTk1lVXRFNjI3cUhkVjhZaXE0VWRHRDVpSHNRNFk5SWR5OTV5?=
 =?utf-8?B?bGRyUm1nTDFzT2dvd3pjUHk4SEpKWFEwWDI4S0REY3FueDJNL0w2dWJNQ1dZ?=
 =?utf-8?B?OXhFNkFPdVhhdlVCMndKRzZpbEdjMGxLOTZ2bXE1UmE4VXFzS0pMNzl4WVp5?=
 =?utf-8?B?cmQrM3NMQVZ6WjRQOVZtSjR2bmcvc3ZmN1VRL1dacUxoRVZGOXVzRllNVDhi?=
 =?utf-8?B?YnNtTStWMG9xYWxyWURmYVdtSzVxMmd3enUyd1FHSGVLTmhFcDhuRm04dE5y?=
 =?utf-8?B?QnlRQkxlb0ptd3cvQ2kyQTIwaVQ5bjd5dnFOTXJUaGRBSGlML09NV2cvNmZP?=
 =?utf-8?B?TFVuemhVMTNEWHR0TGl5MHVrbWtFcXNIb09JeWlvMTUxV2lwOVRUKzhUdnc4?=
 =?utf-8?B?aXBHMCtJM25KOTJuN2QycDljYmw2Y2FFY2wrMk1rODVVbTVJeHJvbHA5Z0sx?=
 =?utf-8?B?azFZSXBtaFVpeGFmVm44ZktKUzdTUEFTUEV1TnBkMGlXNXdSanIvNG1ZVXVv?=
 =?utf-8?B?QkIrUFFNU1RuQ0dFcHJlNnBsNWJ5VWxtaks1K2gySHRNL1YzejN1MXpjcGVz?=
 =?utf-8?B?aVB2bS83MkN3L1BNdUxXUFZRU1V0ZUgvekF1aWxKWk1VdUQ5SUdxU2FCMExt?=
 =?utf-8?B?dHZFUXBSV2RuZVhVNnBlZDdtSTZ6WmttVnNLSUpKSWZGQzl3YmlCUFBScElW?=
 =?utf-8?B?ZXlJOEdYdGZWVzNTa2lwZlZNM0c0emZBQnU4N0hJZGtTRUpnT1lEbEhMWFh3?=
 =?utf-8?B?UkRRbllKVEJrTUpGSDcyU1NkY0EwMm54YkZDai9TRmJGZlp0ckFYeDYwK1NL?=
 =?utf-8?B?M3E0VU5UZmlvd2JIbkNSZWthNGE5ZjhCMnlQQ1cyN3dRZXJ4ZEZOb095OVNT?=
 =?utf-8?B?eVgvWGx0RVh5TTRVZTN3N21NOGpkdkJYSHg0OFpaRTllZ2VtUEpXMTJEcFh1?=
 =?utf-8?B?eVRKU2NUMTFEdFBvRXNWWXdtM0d5RU5vT29KazBkcmJLa1BrenUvNG44UWx4?=
 =?utf-8?B?bW43RmtXUENsYkhldVZQWmNrZHF0SldGNHpTb1plNG1NNCtLRG1sNENoQ1Nj?=
 =?utf-8?B?bk0vQXBnN3dhR2VhQyt0OGJhTnRRMHprRzdrNGdBM2k3RTJQbnd2QWVZc1ph?=
 =?utf-8?B?Q2QwMUxLcTBqQmdSZnZnQzR1SDZ2RlplVjZDRUdZS2tQZWZJRERWQVAxUGNk?=
 =?utf-8?B?anIyTGF4Nkl6OGhQUHQrNE52OUJmN21BRlJMRDM4czJ0M1hDUmx2RTV3dm5J?=
 =?utf-8?B?L1E2cFp0MS9IeEVPQklUby90Y0hxSGRQbmtGUmpCRUduRm1NcFVkaWdDbXNF?=
 =?utf-8?B?bmlzODArUWdjS1QyOUp2VjFydDNPMllWSmQrNmRIUExVSElsQTlOMEZOMnVo?=
 =?utf-8?B?MmxtZlRmKzQyNFV4dis5K28vWjZaclZPSUpxb1BSdFVBbnlXcE1GQ3M5OFFL?=
 =?utf-8?B?TXM3K25yZHJHZGtMTGgyOTV0dWdlbjlERVZmMS82ZE82U1RGdi9sdno3S1RB?=
 =?utf-8?B?ZlhBbVhMemVjaUs3VVFCNGk5NDhSSWN0OUdUY0NJN3IwS1BQU2c2Q0JrSWhI?=
 =?utf-8?B?Zk9uUnRSeXBzdDUrWjJ4QkdXNVVyNW12SGxDZUYwakJxQSt4SVZPYzR5bytk?=
 =?utf-8?B?cXNlT20wQTdHMUc2LzhSUDdtcVNsS2RrbWcyWlJEMDJodEhNczhRbk50ajN3?=
 =?utf-8?B?TW5RZ2l0S3BrUjZ2ZjZxdkJkN3JjUEd2ODZvTGZOUE1vM0haRXhQQjMyRzZM?=
 =?utf-8?Q?FBIA1j0VUkGzdRcPD0/3KTc=3D?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3faf7684-72a7-4f0c-d3f6-08d9f0862f0e
X-MS-Exchange-CrossTenant-AuthSource: AM9PR08MB6241.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 13:22:15.9338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RrBLJ4AD1kLlzr1aKuDlAJU91Nm/A+9PjXcWq1Fmv7h0tdCj+qjCeCc7yBIZnoxNIYF2MKzWpxDN+mGlPztrnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5390

Dear all,

commit 07f910f9b729 ("mm: Remove slab from struct page")
broke tools/cgroup/memcg_slabinfo.py script.
It was used as replacement of /psys/fs/cgroup/memory/memory.kmem.slabinfo
and was used to monitor slab objects related to specified cgroup

# ./memcg_slabinfo.py /sys/fs/cgroup/memory/lxc.payload.c9s/
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
Traceback (most recent call last):
   File "/usr/bin/drgn", line 33, in <module>
     sys.exit(load_entry_point('drgn==0.0.16', 'console_scripts', 'drgn')())
   File "/usr/lib64/python3.10/site-packages/drgn/internal/cli.py", line 133, in main
     runpy.run_path(args.script[0], init_globals=init_globals, run_name="__main__")
   File "/usr/lib64/python3.10/runpy.py", line 269, in run_path
     return _run_module_code(code, init_globals, run_name,
   File "/usr/lib64/python3.10/runpy.py", line 96, in _run_module_code
     _run_code(code, mod_globals, init_globals,
   File "/usr/lib64/python3.10/runpy.py", line 86, in _run_code
     exec(code, run_globals)
   File "./memcg_slabinfo.py", line 226, in <module>
     main()
   File "./memcg_slabinfo.py", line 199, in main
     cache = page.slab_cache
AttributeError: 'struct page' has no member 'slab_cache'

Any ideas how to repair it ?

Thank you,
	Vasily Averin
