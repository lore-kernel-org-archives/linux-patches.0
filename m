Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A23E306B0D
	for <patches@lists.linux.dev>; Fri, 14 Nov 2025 11:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=65.109.113.108
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763121119; cv=fail; b=TbXXd0rW0Ojstb9Zvaf+pajU12DDNlDkRtocIlRrpn7pRPdM3wbpKreTkNjGLxbRfil/F6y3F6NoTG4A1Q6ubS8S583e/njqhIyFnJ3jPx3qoka0uQEwnelr9pOsnpuWcdhvRZFrRx6dQPY1aXQer37R8Z4e7RVvWwA7aruuHkE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763121119; c=relaxed/simple;
	bh=haL1AlXxtO1t57vOuBotcSt4ogE/3IeAcoy3mCp1AcM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=u6DTogirGEUZDM8oaLgLXizDoalMebHn7UNtSVw0BmEyuPyXSk8e0/ebHC1CDD5GdYcgBoLHheX9Lo++DgUGjdgb8sUY4RAizuCCA9mWJYjHPIw8BOG5jFbWkMT9IkPypXeaxJZxfHOPvh5tNtQrkTHpo6tpN32D1el2W96qLyE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=pass smtp.mailfrom=alien8.de; dkim=fail (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QfPWTVQn reason="signature verification failed"; arc=fail smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QfPWTVQn"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id B088E40E024F
	for <patches@lists.linux.dev>; Fri, 14 Nov 2025 11:51:53 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 6nWMfcrx4gh2 for <patches@lists.linux.dev>;
	Fri, 14 Nov 2025 11:51:47 +0000 (UTC)
Received: from zn.tnic (pd9530da1.dip0.t-ipconnect.de [217.83.13.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 066DD40E016E
	for <patches@lists.linux.dev>; Fri, 14 Nov 2025 11:51:44 +0000 (UTC)
Resent-From: Borislav Petkov <bp@alien8.de>
Resent-Date: Fri, 14 Nov 2025 12:51:37 +0100
Resent-Message-ID: <20251114115137.GAaRcXyen_SUfoT1Jz@fat_crate.local>
Resent-To: patches <patches@lists.linux.dev>
Received: from mail.alien8.de
	by mad with LMTP
	id 2EK/B41dFmmfkxcAc81XFw
	(envelope-from <Mario.Limonciello@amd.com>)
	for <bp@alien8.de>; Thu, 13 Nov 2025 22:37:01 +0000
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id EC35840E022E
	for <bp@alien8.de>; Thu, 13 Nov 2025 22:37:00 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iSBozRn9p30X for <bp@alien8.de>;
	Thu, 13 Nov 2025 22:36:54 +0000 (UTC)
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazlp170130001.outbound.protection.outlook.com [IPv6:2a01:111:f403:c10c::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-384) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPS id EB90B40E0216
	for <bp@alien8.de>; Thu, 13 Nov 2025 22:36:45 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jH/MWFkTKwPtPfl/XD2jaXXQwaEty2QQ9+Zvr/Z7W1QWW1T3cXnmcz0B927FFfuT5JcBtK7J+DYDMmS1zKtJPOCW38OaQo9O0UYSuh/Vz15+pcupR/GjwY7Na+t8RHBgnI3zkQIkrH6DpW3r5yBb712wl0enWqyvon5ZKRIzN/DRkOIUPZHVvv2oqaUHkfohllgMCekbUjC7AA7WGMRrlu5jKUsfWgvEvx4nh//XTwQIjOUjJJRRpJpDFa776N0mZsvwZVyObBxW8T4ijL0SZua/xn77Qw4LjRqK6zqdVd7gnvahsZ1SUGbKC6SFVrhUS9nFe2hQ50dFCZI0C3V8rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lkt/yfe0BPOJW5D2GE/L1EXdYpxuJb0gzamMnxYSiPM=;
 b=C737wlON7/5fMRWBXbq/70ez4uSl4R22dlRE+tc8ay3pF+3GhpyMTlfKz4Avirn0O7hoC0x+gD7KW0xagKTTFnSZvetJleiKHzbJhbsqCLCfjQtkeVy9cl6DCgyNVu70N7uINMGFOcIDRxwc6PEBWqXalmyinQu8hKjgmKYrKh6pdjTf89BLbso14efpbroia4jJuAjVKmi5lFDJNvhShq+ZwxYQ5fZp5GedR+v11SnWrQAQvpDJB9Wo2Yhyxo4xQ9crQgmtj2hSv1pNB1+Gq8tkpeXQ2xEVwgAn8+6EFMMstC4AP4T4WLD1aJLGDtEfDiPshjY3g1AuX1Q1tXP9Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lkt/yfe0BPOJW5D2GE/L1EXdYpxuJb0gzamMnxYSiPM=;
 b=QfPWTVQny9zfo7xh3M9YlvUNNK+VLWdhTzu8VnieESyKGBu1hWMEnMK6/MCrs68zLl0BOOmGP/zbWXaX4QUEGJfcmYlmF3lZ0Yh2HkFWuoNl13Inv/mDc0kcZCoDpVFm4eTDE1TjQahla+VSxcIdHTwScYKXBP5tQlFIdb7LmsE=
Received: from BL1P223CA0035.NAMP223.PROD.OUTLOOK.COM (2603:10b6:208:5b6::19)
 by PH0PR12MB7905.namprd12.prod.outlook.com (2603:10b6:510:28b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 22:36:37 +0000
Received: from BL02EPF00021F6B.namprd02.prod.outlook.com
 (2603:10b6:208:5b6:cafe::d4) by BL1P223CA0035.outlook.office365.com
 (2603:10b6:208:5b6::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.17 via Frontend Transport; Thu,
 13 Nov 2025 22:36:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF00021F6B.mail.protection.outlook.com (10.167.249.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Thu, 13 Nov 2025 22:36:37 +0000
Received: from dogwood-dvt-marlim.amd.com (10.180.168.240) by
 satlexmb07.amd.com (10.181.42.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 13 Nov 2025 14:36:36 -0800
From: Mario Limonciello <mario.limonciello@amd.com>
To: <mario.limonciello@amd.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>
Subject: [PATCH] x86/CPU/AMD: Add additional fixed microcode for SB-7055
Date: Thu, 13 Nov 2025 16:35:50 -0600
Message-ID: <20251113223608.1495655-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6B:EE_|PH0PR12MB7905:EE_
X-MS-Office365-Filtering-Correlation-Id: 2eabb4fd-2b90-4365-191f-08de23051b9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sddRKbiBSyu8XBPUTLbgKBEfvF7rFqsSd/6k2YKlwykTPSCzeIkIT7UNSNna?=
 =?us-ascii?Q?uhsZbPLujES8AbhXTQ/JTeXL62p0qwc0gUIAM1NbVg++fU2kdiq3br639ZnZ?=
 =?us-ascii?Q?hLrAzl0I7t2SKbiDr9nxalTXvkR2Pj6Q53r/Wt3joO0fXAaIfBYXGNYQzHPQ?=
 =?us-ascii?Q?38WpGtn+D1tdqLvoySbrXTGRa211X1UCFr4d4N2e0nYnzdYgL9D4OSFeH/Aa?=
 =?us-ascii?Q?YAnSQJDY9cd2Wy5gXzmBl9pZUtaiT3D8/Rh0x70rl6xttdxOyQz8rr0W5CpV?=
 =?us-ascii?Q?h59YLKthv3OnsouWp65x9tIe6CGHoUT5O4zIpxrPFkvsSHCTqhpk12mlcqVM?=
 =?us-ascii?Q?lDbRqBDqdXBtKcMKb1Esu0FNwc9fBjeucu/+IRX9YXNup2u4cS0oahrXjLKr?=
 =?us-ascii?Q?lYHUml6Ns+7uoSlU/AdihZ984lUn3MOgPSmk6Z2r7COB0lqcbvZ3+SazGeOq?=
 =?us-ascii?Q?jeUSZsdpq5Ojynk7694SAKqGT5kx31X3yxheuNka2XSsg+F3+VNFPFQcOC9V?=
 =?us-ascii?Q?zkZ3UHiUKRMi865GYqGn+ml8yQTid6L2I6q7Kv5kvV92vGskfMMX3xji+E71?=
 =?us-ascii?Q?emVxz79+ZP1nd4GfT/Pu4TicdG1vFpWuLKGFd+wktJr3M9NSivIwgKYQIEk6?=
 =?us-ascii?Q?qKWCpV9UVWyxnVc0kvQ7Rwpfoe4vYK379Zd6XSs57gO5wDccLZYaJ4N32qod?=
 =?us-ascii?Q?g0YhCB+zW0GEZRXb3r+DK45GFqZI/ZKB8ReyNn5jhKUjOZtHIKKiDCU1dqgo?=
 =?us-ascii?Q?5UtitXmY/xLa4iQ8EWD6HwenMpiqBp176YslWIoEVOJgDNXf9v+L7Gta3LYw?=
 =?us-ascii?Q?z76rwjRdo6G2l5pqeCQlgO6+K7SYS98II6kOHBzXwKAa3Fl5itBvYJ1ZSoOZ?=
 =?us-ascii?Q?Q31BsqjqaniogP22pIX8F0mXvAj7zcvFusW38GQVBUzCun81IpaPN1KAsroy?=
 =?us-ascii?Q?i8CP55pkfL29qL3pOn8H0ecIYPGgsmSwhJ90STHbkjbjM6P7zUcsnxU7knRq?=
 =?us-ascii?Q?tQczpM4z2ZA6M0EuQsLdI30WYK1RWzFqzNsqyOzfrqYGFFNbHcri7T1KCuEi?=
 =?us-ascii?Q?dVlKcyGKLVQWJokwt1PKbFOn1pT3icvVtuTsM6KTTmH/mSCs+Xzqa6h7EFX2?=
 =?us-ascii?Q?ub73Y2UAB/QSlewwQ4NoWEyizQ4MDTAZvHlNt2M868XvXndwnbNaK5aLQ3Gp?=
 =?us-ascii?Q?NQrSRzJM0TRbpVIEQBo1nogtt59+EB86EkO/48hGUZL0CBsyjrCB5f+tbHRJ?=
 =?us-ascii?Q?TeZ25MMOIGK3qAsQtwS052QqZVx3cYTm9+37EfrnF9q5Sqhzq92iEp9IbMWM?=
 =?us-ascii?Q?Ev8zbJQP5k6LXX84u6JANR5eorEzRPtX7WNyTS9YyKtlIln6Rzj8G8MJA9fl?=
 =?us-ascii?Q?67O6IjrVLCwDF0DkMyRFguGiDPjobF+GPqwpXkJ0AUwkQ/UOdZPCI2T0CTdl?=
 =?us-ascii?Q?Z6XW5tE072utoooBqG0iyDndgFQhzyqio0Ynu57Mm0wwd0Tk9pqOPqyUyiY7?=
 =?us-ascii?Q?ad/lkddjiiBW4oRC9IWbbUf+W3Z2L8h7N8Hb?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 22:36:37.7628
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eabb4fd-2b90-4365-191f-08de23051b9a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7905
X-Rspamd-Queue-Id: EB90B40E0216
X-Spamd-Result: default: False [-1.27 / 20.00];
	 HAS_XOIP(0.00)[];
	 RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[165.204.84.17:received,2603:10b6:208:5b6::19:received,2603:10b6:208:5b6:cafe::d4:received];
	 DWL_DNSWL_BLOCKED(0.00)[amd.com:dkim];
	 R_MISSING_CHARSET(2.50)[];
	 TO_DN_NONE(0.00)[];
	 R_SPF_SOFTFAIL(0.00)[~all];
	 RCPT_COUNT_FIVE(0.00)[6];
	 RBL_SENDERSCORE_FAIL(0.00)[2a01:111:f403:c10c::1:query timed out];
	 MAILSPIKE_FAIL(0.00)[2a01:111:f403:c10c::1:query timed out];
	 RBL_VIRUSFREE_UNKNOWN_FAIL(0.00)[2a01:111:f403:c10c::1:query timed out];
	 DKIM_TRACE(0.00)[amd.com:+];
	 DMARC_POLICY_ALLOW(0.00)[amd.com,quarantine];
	 DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_LAST(0.00)[];
	 ASN(0.00)[asn:8075, ipnet:2a01:111:f000::/36, country:US];
	 ARC_ALLOW(-1.00)[microsoft.com:s=arcselector10001:i=1];
	 BAYES_HAM(-2.97)[99.86%];
	 RCVD_COUNT_FIVE(0.00)[5];
	 R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	 FROM_HAS_DN(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 TO_MATCH_ENVRCPT_SOME(0.00)[];
	 RBL_SEM_IPV6_FAIL(0.00)[2a01:111:f403:c10c::1:query timed out];
	 BLOCKLISTDE_FAIL(0.00)[2603:10b6:208:5b6:cafe::d4:query timed out,165.204.84.17:query timed out,2a01:111:f403:c10c::1:query timed out,2603:10b6:208:5b6::19:query timed out];
	 MID_CONTAINS_FROM(1.00)[];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[gitlab.com:url,amd.com:dkim,amd.com:email,amd.com:url];
	 NEURAL_HAM(-0.00)[-1.000];
	 RBL_NIXSPAM_FAIL(0.00)[2a01:111:f403:c10c::1:query timed out];
	 MSBL_EBL_FAIL(0.00)[mario.limonciello@amd.com:server fail];
	 RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a01:111:f403:c10c::1:from]
X-Rspamd-Server: mad
Content-Transfer-Encoding: quoted-printable

Microcode that resolves SB-7055 [1] has been released for additional Zen =
5
models to linux-firmware [2]. Update the zen5_rdseed_microcode array to
cover these new models.

Link: https://www.amd.com/en/resources/product-security/bulletin/amd-sb-7=
055.html [1]
Link: https://gitlab.com/kernel-firmware/linux-firmware/-/commit/6167e556=
6900cf236f7a69704e8f4c441bc7212a [2]
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 arch/x86/kernel/cpu/amd.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 2ba9f2d42d8c..5d46709c58d0 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1037,7 +1037,14 @@ static void init_amd_zen4(struct cpuinfo_x86 *c)
=20
 static const struct x86_cpu_id zen5_rdseed_microcode[] =3D {
 	ZEN_MODEL_STEP_UCODE(0x1a, 0x02, 0x1, 0x0b00215a),
+	ZEN_MODEL_STEP_UCODE(0x1a, 0x08, 0x1, 0x0b008121),
 	ZEN_MODEL_STEP_UCODE(0x1a, 0x11, 0x0, 0x0b101054),
+	ZEN_MODEL_STEP_UCODE(0x1a, 0x24, 0x0, 0x0b204037),
+	ZEN_MODEL_STEP_UCODE(0x1a, 0x44, 0x0, 0x0b404035),
+	ZEN_MODEL_STEP_UCODE(0x1a, 0x44, 0x1, 0x0b404108),
+	ZEN_MODEL_STEP_UCODE(0x1a, 0x60, 0x0, 0x0b600037),
+	ZEN_MODEL_STEP_UCODE(0x1a, 0x68, 0x0, 0x0b608038),
+	ZEN_MODEL_STEP_UCODE(0x1a, 0x70, 0x0, 0x0b700037),
 	{},
 };
=20
--=20
2.51.2

