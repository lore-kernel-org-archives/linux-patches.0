Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2085.outbound.protection.outlook.com [40.107.93.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EEA149E1D
	for <patches@lists.linux.dev>; Sat, 17 Feb 2024 00:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708130904; cv=fail; b=ud40rRLpiwhhD6n9DG0OqkZxQio6xtLEtHwdM/BWU/dx08t/isCsuBUzEGoCsQJp+KezHy77II0e+Ju8Rep2jxykcFg0Is5eoi8wLb5YDv2V5yeafsMTkSNyP2YwQWIBJpOzTjYofCHtKKCnwCE3C350meJ2dpJjmDEid++i1qQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708130904; c=relaxed/simple;
	bh=Fw0uXCFyRulnS3iA7uyQBJatlhjMChqFxYb9RfFrAOk=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Doi8QAXWVh6ITdBglDbXsPK9fiUiZiXQ7sXpYSMHJoH/6uzKmOrRR9O3SdfYnV+mwLCQV5Xepxo+PWr/TtfoZJC+eAsJu/F7qWqGrK4bCgcSkq8mieY6ihG3J3kJH/yR1HErJV9y1T7Ph7YlRhbMZuQQJiy7YA4B0e1OtsVWN7k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Qm7isw7M; arc=fail smtp.client-ip=40.107.93.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Qm7isw7M"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UciXUNzgJLWWljB6mhocwGCvr4zNdOtmjqg1SXia46LQu/0G2jHCmt/36pfolkWTZ+Pe6FEjg58qoQOu7LCeljbgrBnDIp1b9Lcb/RSYbxdaaNEcXGmWYHCP1TgVu2lD2aYODqUMwZDJ7SYrHbIpxyVXvD4qcIZUbY+ZWhpWAIP+ezgyY9nxVIY07uBRX6asnSsuS6rThX+S/EhXfBCyfM47c9mAYkflM+aRTid/OvsS+DajGmywo3NNtkGZJ3Kc0Z7pDRaXSOecutVBIP5YbujAm7cYL5SkHK93xNl0cUt2MzzCp59bC9QaCOzDoaIAgSWvNgqm06+bkdSClYLLqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uysvSpLqVHFdpjGfgoFq6AQn6wUuXkqWBLbbvDyu4fc=;
 b=Ea6BUDzYv9zLY/uL5byeszIijg3ZNPPTAbdz4aQYqAZTfTzbkxk5nNATX8m9fwJFU2+OBI0fiiO61moePEP3jnx0Isgu7PXml8I1PwRqUARuE3aToQc6vZubg6Gv3zJeo81wPwlRbQNPt0qsnwBTVPFbznxQmxS1vh2ORwFZWBLy2dbnjsCnlggPwzrecrNNyQ/HNEuDFXxWc98/Bbtjp4AVtHMbhQKHSfa5zHqkLdIww7UW94uKgJfoU8EhjZ6sydGmYf/gDYggtjaOTiWBlebTmxjwlp5iIN/WZCQoqfqGSmxFLvYs/W3JS6GaRMqLfLwN+y16vKNTSrit0abHRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uysvSpLqVHFdpjGfgoFq6AQn6wUuXkqWBLbbvDyu4fc=;
 b=Qm7isw7MhPwBqHBoUY6Rpas33CuFINeI1Kpg4P+MJomPaZkpbHsndq1mgfF8qo3aflAbmHY5JPw05m3/zemIriGhzaN91ocWCpxkTgVOf3eQWt6jpfh0ani92Nnv8O6wPw//8dZPn58nREZXMqHh3uiffsHhHND3nVgdY5vu+hUa6XyeMUn/WVWO6QR4XHlgAAH5Cqxgtd99LBtrBD/p6O48XvIW7Lmk64daclafTmmtHr8moxIuZMgniNM2gUgRaunZGdeVuvxvDzp5TfD/VWgBbtDnmanhSdIPq84klJSbAuEmr3izUWfdq4pBhMvp0dQXLhJt5Cj9NlzQfMseSw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH3PR12MB9077.namprd12.prod.outlook.com (2603:10b6:610:1a2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.14; Sat, 17 Feb
 2024 00:48:20 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7316.012; Sat, 17 Feb 2024
 00:48:20 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	linux-s390@vger.kernel.org,
	Sven Schnelle <svens@linux.ibm.com>
Cc: Jan Glauber <jang@linux.vnet.ibm.com>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH rc] s390: Use the correct count for __iowrite64_copy()
Date: Fri, 16 Feb 2024 20:48:14 -0400
Message-ID: <0-v1-9223d11a7662+1d7785-s390_iowrite64_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR22CA0029.namprd22.prod.outlook.com
 (2603:10b6:208:238::34) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH3PR12MB9077:EE_
X-MS-Office365-Filtering-Correlation-Id: fe3e8275-3b51-42bb-038e-08dc2f52230a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	gpz3yi4jMMMVycFJVA9jqmto6oZ5QoNPw1tf/KiNgRl28LWP8QAlrEUmpWLisDz22TO7YsictgUrStS5Ren4ZgmeaTWjQyZ7u7AfF8ZeZ63pU0xR9C9PrEA05VdbG4FfbkQiPvKTtJ87WvGi8OOk07zO2tXddnTcaY+/yOJOEJt+Mi+At6GSjy6PfS2TFJikVUURbjfFzXf+k1lUZwIzrcugofpmVkH00K+/giCNvqfUOCxUKWp0te2503jXpKT8qSpDTA84fp5/A44YRrFsT6kIm3TKt5qnsaTzf66WuUqxg4hmlVYdsqr68vcHrqBPXtMTmvla1uVfmv0yU5xb6VjSKKoL3lt0lzPUa5su9iXwfnPSofiEJrBkAv/DImjmsw4OSZkv9wpUZ3Dyub2g7eQaS3TtHVgbZuRk53WKMO9L7Wie3rpQEvXAjpcJSlg6y9W1DuTFUAxrA7e3xtPn51Mi56ULlD70JcLQPdsgPIrk8z1lI1S4DJrodSHw22QHGcxumt9ENz0btSVhvW9FGB6kqscEspBNRX+vE1PbG+OFYOrh9g/SIJNlTg1PBCwc
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(376002)(346002)(39860400002)(366004)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(7416002)(2906002)(5660300002)(2616005)(26005)(83380400001)(36756003)(38100700002)(54906003)(110136005)(478600001)(6486002)(6512007)(316002)(6666004)(6506007)(66556008)(66476007)(66946007)(8676002)(41300700001)(86362001)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jvKKozp6fMpSFalwG8YONBSv5ab+xXr4jRjk85IV+JTV8pin3rdi2h7Hja1z?=
 =?us-ascii?Q?vlO2qr6QBkZyv1EluqS89KUDIwyVWv0E4teEWPFdbf51VqeBfog1gVIc1DvV?=
 =?us-ascii?Q?y/AMuRvgeokIKDgIlDFgUl4UunfhrhHfMqEkqFt2xxT3uGV3HoomCa/U8DgW?=
 =?us-ascii?Q?GielX9L7gB2ZS4xKRLQOD54kkutbJtDy6fdVRGyap9o9tA0hUZbBxRTIyB1z?=
 =?us-ascii?Q?vuSCAZ3T7+L8aByI/2+4IquHvoSkaTtVuwdLUfCVQfo3mInkmIK1cToxKFMg?=
 =?us-ascii?Q?wMnfODL02bybXuGYCOaZKdFPtYg5fpGwCaqH5QRNE51sW+fkYh6Uy+McwL/4?=
 =?us-ascii?Q?Yfi6pG+EbJSrAySP8zn7sTvM38rZhzj+aFjZTUsnCxH9OOjOV1vgjAm/wgVZ?=
 =?us-ascii?Q?h7sFwztwNIuiqXNYVrmxFE8Dbx/Gri0kV/FEX3UCBvEZfK/HK86AG2vPAKAa?=
 =?us-ascii?Q?PC49ql/d8cPG6FhKoi7x1lZfCWZjE7I7rBKu35IqPbqp6V+vQ3Pn0wqac4mo?=
 =?us-ascii?Q?JYHZDvNhlC1yVR0sGV7GqvnXQC0IykZVCbLkJrzqaPguB3b67HKevVHApFPv?=
 =?us-ascii?Q?3hJfpmaZ2KU7bhYZIucq22+1aFXkQMvqohtW5hoctmkNmf9KQmv7MiabwODR?=
 =?us-ascii?Q?jPJzJp5mppvwfILMZcTGKQrz0WhZhYfVAmxfqxrwW1G9LyRhksFlTdKw9CEI?=
 =?us-ascii?Q?MrPV0qMR+hySyLUo8cJenoCevqAiTDJSFcv+S//B5flh//wSZG3O8K6IZmTo?=
 =?us-ascii?Q?wiwOxbRrqhUwJHidnAUyKZ11y8qJXNhpW06IEyR6chWF+2WcFQ2WnicaNbxE?=
 =?us-ascii?Q?7JFLL7/Gh6PtB1hguD4v1B9HowGpjCgbLPHPvGOgLxeyVQT+hh9rUb4cGyJx?=
 =?us-ascii?Q?9wKgsF7bF6wzFkuApqIXgPywicazfFnYComW9nK2K01attm3WtjkbAZ+zqs5?=
 =?us-ascii?Q?nLKTPIIpZDccWtm+JP1DF4F5F2ty4026TOgUSQBztykoQwPjQbuUZEkttTJv?=
 =?us-ascii?Q?uLPNVx3j8jeK506TjGcyy9KGQ+h52YZSI9vUInMMjw/WAg+EJBkqZ8/1Airb?=
 =?us-ascii?Q?48FbxMeF+mQVNN5Yyda44n10uctxQfXPfAQcNVdfQNFb57+SJqACekuDb7H6?=
 =?us-ascii?Q?a80GSvr1Caol4XdVlHhjwyc5dsc7FFnHzznCnSO7wK88u79cGpHF2t+UwjuI?=
 =?us-ascii?Q?msqFX4NiBLOu/jjN9FZI4yEn+uZh4MwlbBoPmeils8w9YV2k0T553e8ryGox?=
 =?us-ascii?Q?DoT9lREH+SbSWoiXq1h6pBlrI1/QhH1NMQ4HkYcIwUwX8iL17YZ25lYLQp0b?=
 =?us-ascii?Q?52+6fr9DjZlQcVrPr200nmCT7xMkmcTkdibWtUxgeweXmGJS0XicxkJSlx71?=
 =?us-ascii?Q?eWvWSqIiBDwnSSfbbHd7tbwDxaznLa0JvvhLS49ZUn3X+0JNROckjs2Kuh49?=
 =?us-ascii?Q?UE74+NzFcDwHl112djReQ1b1iddRAxbFvJriRFbg12GDdUv2sb1pY0Z8WOBw?=
 =?us-ascii?Q?AdGokpj/mLnSLmj2qBTf6NNzXYBS3Fx3CcJnKDvbzVrbsqHN9cebf3EV/MaH?=
 =?us-ascii?Q?8oa1v5nvu7UBOaZRewmHy++4YW8yXXidqjYIyq9d?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe3e8275-3b51-42bb-038e-08dc2f52230a
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2024 00:48:20.2626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7KF8bZkDJgf2oWmm5Pex+jesKJclSaV3MAyZ2xDp5VXjcyraPwZCSRjxAR9Ywv7V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9077

The signature for __iowrite64_copy() requires the number of 64 bit
quantities, not bytes. Multiple by 8 to get to a byte length before
invoking zpci_memcpy_toio()

Fixes: 87bc359b9822 ("s390/pci: speed up __iowrite64_copy by using pci store block insn")
Acked-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 arch/s390/pci/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index 676ac74026a82b..52a44e353796c0 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -252,7 +252,7 @@ resource_size_t pcibios_align_resource(void *data, const struct resource *res,
 /* combine single writes by using store-block insn */
 void __iowrite64_copy(void __iomem *to, const void *from, size_t count)
 {
-       zpci_memcpy_toio(to, from, count);
+	zpci_memcpy_toio(to, from, count * 8);
 }
 
 void __iomem *ioremap_prot(phys_addr_t phys_addr, size_t size,

base-commit: cf4f722d8b48e66de348f2fe8d0e19c01d3e6b72
-- 
2.43.2

