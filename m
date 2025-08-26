Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2084.outbound.protection.outlook.com [40.107.223.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206E62E7BDC;
	Tue, 26 Aug 2025 17:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756229215; cv=fail; b=AnXS8mpel9NZHoa6k65tXeHAqDbi4M44tpoQybksOt7TIpU66wMkt16cGIzFRQwT/NrY+pSSHZJWbGDKZknlBh90iEzlAOO1v9/6L5RJGMha3610Gv8hS0WwuCwpfXtGRWIYmKY/fBmrv5Euk7tryc77YLyg+7GdZuGj7okm3Mo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756229215; c=relaxed/simple;
	bh=rTMQjfv3WfPahpqRAFyFIZptEbDZ7Jl6j1vwTFglzXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tctkkohDI6teq/gTbUJPqCJ0Oe40nqZN2+cfLAzmisk9WJmf/rmjXY0aRD5qe+IInjD/uOiQZn2e+P8pZ+qWR+tbp7NbIT0uw/69/vIXS4JGO4IwJqVeC9BFfhO0MFFyb2g+ptJXT8UKQiOTuOXH9fy6XCFrKLhleewJX+aUxnA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IzVkxcxC; arc=fail smtp.client-ip=40.107.223.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IzVkxcxC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PM8kdFk+kiL5hV9asi9XwOLQBUg4mOJlznHC2n/MtHqZIczFF2wku6e5iFXO6M+m5C4knB9w9G8T9hogjTm4oLBFIsDTbFFk4HWhpg6DDdAOFYZBtKEO1HZf9N/b2gfP8ug7JlIf80ak8A3P2eCxEW6zlRwTU5A1INnO+1wpe3BQCWmU1Ikx9M8kNpv5cjaKrZigymAdv+MxBcsBFbHtF+TKwkPEqAc96P8XlbUCMrF3B0TmwLAP6gLlCK1Z+9RHbRgXE+I2FmqwVpZTpIZrkHg9RK5Xw851vR+92jY2w/atP170j0d6YpqDZmCJ6wlqrJLx/XRwjzwwEuCCBWcWhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HIu6v78fo4IGyQj2RLplL+h2iiUWq7A4+IaJHUwpahw=;
 b=q4CI5Nivre3h7Ix0fn0QcBcszLn/+oSrdd8vv5ep1+R6vbDhbdK0mX/U1AP1Xanu1RnwfCq9nWnmdqksg+JVg8OBsrCWu2jPEcNJynwjKhi24GQDUcrqaoX7sHd2oCUOrq1vPo+rcqDxOPlPR+tGZaqiadxZDwzdeLaip9BHbmabKKkjXlPnoO0pwFHsqFmcnFdqSjFc2j810M3p07RX8MlkVX1S1+NM8Kuz2x/9PRIUuUceamfz49pbVw/CGB0f3IMbbO5bHZ9rLLlOmr0d1civyXhuJJMFgiRx2ctRC7NC6lCT61m5OnmCP0/38/h6AiX2GXscwGiLh4RE86Vw4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HIu6v78fo4IGyQj2RLplL+h2iiUWq7A4+IaJHUwpahw=;
 b=IzVkxcxCh4kQBUYoD7NKZnvUW/CHTr2Kd3EyAihHRiWX0iBoJe96nppnoYkbg7v2PUDJY0+uRBpv3B2jOh9a9TTNgsmxU2zdj0U9UQKrrcjexURDM0YPlS3dGn3vQcSnud6F5ALqG14fpZuOPP8Zq+TOnAfQSFIBkemohH9DsO6lxsfqCcPIhZN2+7yxyGHbxA0zcQqeMPoB8uUJDi86aQMjU1ErYK+2QiBu9mpAMuqv5nuRqB92ECQxAFpQwK3OuVfUHCGAbF013z/nHlXBRhu01nx3+p2FDsVMgxKtYtXsMzUduru7HaowRidku2542TxtSY/oqEWmrhE0WNcUPA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA1PR12MB8641.namprd12.prod.outlook.com (2603:10b6:806:388::18)
 by MN2PR12MB4222.namprd12.prod.outlook.com (2603:10b6:208:19a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Tue, 26 Aug
 2025 17:26:44 +0000
Received: from SA1PR12MB8641.namprd12.prod.outlook.com
 ([fe80::9a57:92fa:9455:5bc0]) by SA1PR12MB8641.namprd12.prod.outlook.com
 ([fe80::9a57:92fa:9455:5bc0%4]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 17:26:44 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Tina Zhang <tina.zhang@intel.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v2 02/10] iommupt: Add basic support for SW bits in the page table
Date: Tue, 26 Aug 2025 14:26:25 -0300
Message-ID: <2-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <0-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0035.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::10) To SA1PR12MB8641.namprd12.prod.outlook.com
 (2603:10b6:806:388::18)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR12MB8641:EE_|MN2PR12MB4222:EE_
X-MS-Office365-Filtering-Correlation-Id: fd54453f-9cbf-4ad1-a22f-08dde4c5b9e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HsY1laBq0ZLy8ihMOg37wZqyqkHbCdasOg8AEzALSwJ6T/1KXyoJNLSi//da?=
 =?us-ascii?Q?uulDcOtWzG79QyMnkh8oVLONO2iuPCr88CEwagmlR4EYi1eZqdLEyzGmDbm+?=
 =?us-ascii?Q?TjrEX31q7LhmwFVVsa0irvOYwYNumnVkiMhDzl8+bdH2tYUJVe8yDg/jpcD5?=
 =?us-ascii?Q?D8Ipx4QQ+O6hUU5HFgrbbTJ2pwOgVifLbmxnueFyFjDam4F6jjk6GAf7vxdI?=
 =?us-ascii?Q?Hz5xH66eP1YFrHm0VKh3gR+AgIpYoLcHV6v6CgXVcHMMsrNpW+466dfQkpvU?=
 =?us-ascii?Q?5GnnV5a4plOf5trJdQhhTyK2nGAh7H00FUVeGJZQKYVS/qC2bpNa446o6QVv?=
 =?us-ascii?Q?IkiXVSCBN6dQnW8tTvuCjbb9tOeEiaPbTRzMWqfqNHjMHBbq2MtNWk+DViMQ?=
 =?us-ascii?Q?cRQks5gw20iV2HRA9T+WkpuD3cWcbcbEzbtq7jFI0qOufQhgrI8T9sDQycfk?=
 =?us-ascii?Q?cd2URMJqezBIYqX9uHqymAKrzKwosGp/leo6ZPWTsNnU0WuiY0VqQh09SIld?=
 =?us-ascii?Q?vD6Yi5CzUyFsogzTZE482q15qojvz81vsdKffBxYcUSd1hL7D+7Qv2apWJwS?=
 =?us-ascii?Q?y4SDiGWE2bIsdC3LC7/hU2E7klF+qhtCmeOVQqO654jE12SEUlC7ThNB5BT9?=
 =?us-ascii?Q?vvAZHwTglffcwvum3aWgrzRLprl5MBmlEEEJq/xdtgNsUp5LP/E1n+uPqSH0?=
 =?us-ascii?Q?3ClA9GP704tqjYST+miwvqFzhZ3pIu+kAeBtWzL1VW8s4NSBz+5NG7KrdXUC?=
 =?us-ascii?Q?ubdRG0Z7CVn7ltaBPckSngcLC+YgCPiW87WGbf/bVdB8fDY1lRdQJamg2C8k?=
 =?us-ascii?Q?MGtAL9UoAM8GIUPc0PTk5MNhOYvn0be7Oj5ThlOiNsJyaEP2PoG3YDk6AY8v?=
 =?us-ascii?Q?6CyxgSRPjul7jElzACF5a+iMb33d3UACk9HMjyx0coC6mNgHUT/a3PUj4KQZ?=
 =?us-ascii?Q?e707lb0ZXXaBm8jRdDq8a1kCc8nt+sdaa58GuYgfYJhEE0s6QW8pd6Lf51Bb?=
 =?us-ascii?Q?owSj5A6KUkl4DkNBf/MYCLlaYDc/5PhgnWDPmAitXC2T7oQJMB9c0R75L2E0?=
 =?us-ascii?Q?yD0xqpYB77egnxUGEgwJkRZrDl8AHE/vV9Vy3nVk30RDaWSPGgZM9786ckuW?=
 =?us-ascii?Q?TZaPUooNl4OLfotbslmsJvooTwa5yxKC4umn1n2/eYz3ekcAm5OoTvn09TTX?=
 =?us-ascii?Q?U7Cg/5Dx/vsQbLNCqEG+kKeHfhu6ubX4dJhX226YL0q3sEnhdef4HJ4WuLQY?=
 =?us-ascii?Q?Ar8E4rq30OUTr3TkVPHDk2HcrDH0bLDZ3I5eI0fi657INhSOBfWyO+HUL+jt?=
 =?us-ascii?Q?TLh4nfVfke5+vPRwUNs5QIgR5T5M5/2vkhCMzHrAkoDvxOTwPGEd+aU/fSRb?=
 =?us-ascii?Q?S4tewg0Zpnp6Y4YGdFaTQ5OqDxTVMmiuBlSXRJpcMbWAYhyFLhaautR2D+vl?=
 =?us-ascii?Q?l4c1nyOYJhw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB8641.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ka/Shi0L4eBTb9Q13BUTftOV3KG+aCuihXzg+ZrTXTXc4PM9q1NBOSPiDimL?=
 =?us-ascii?Q?TyyJtxUureuUO29V5VOM9Mm4Kh8LXqgYaMY8Q0CtfqPyErsFJzvoiHT3/zbA?=
 =?us-ascii?Q?66NMyFFpIk/C5WtVLYH3hp8ZinPDmvApa2Mbgw4+HhJRIE5OM7m++EDUAaO/?=
 =?us-ascii?Q?NmEcgM8lRfWqbn97VADX0judqeFc2o3G+OEOBEiRYuPnRXZLbqCw03NX+Nc0?=
 =?us-ascii?Q?Q6A1v8z1IR8hVPFOv2GwTwheVgMwSkdQD/Cyt6OS3nhJuw+/MuZyrIp0Y/s4?=
 =?us-ascii?Q?Mu1R8zwC78SMFBD/4ll27XQm4n4iL5W5p5aGa4d1bbWEZGNrk9dBNr9se1Fi?=
 =?us-ascii?Q?tQ3LT2PwI0N4fr1LHVbCRamG5ViHs8r6i4atoOJtmQW9uhZ5b/q/fuetBEUW?=
 =?us-ascii?Q?Tpu1okY0VzFfKIlB/WtjaVn6REHUqvNAJYoPqD18Yy+XC7idQV4NO/HkZres?=
 =?us-ascii?Q?zQdG2Ny91npX9hsIQZIWU7wpY0kpPKX/vSJTF0ExYCRDUOqDWCYpXSuJLIfE?=
 =?us-ascii?Q?QA5UbNg06O+KGsrt8bD2N/NgkxXxwzb/MB0yY5nyWR5VT2+8ZJvGASfewvE6?=
 =?us-ascii?Q?Aow33ht97thILUpWI6cx42X34T8P7GkPcK7KH5YGHIUn3JXyPJhg/m3IOy9a?=
 =?us-ascii?Q?5LyPqfarV6j09kqXGIbfaF4rZeSIZzZ+cakuKxmg/OJN1dcR2tfguAVsdZKY?=
 =?us-ascii?Q?nVcfTLefsXbHr9hUFweCCmliNto/7XW2imZxcY8/rFlmGanUzPs8uT3S/386?=
 =?us-ascii?Q?gaEFeJd0f+8PJXsTqBB1TeigRzHkElOmQrgmhLy8RXf1DiwJh1VrepOo5Wmg?=
 =?us-ascii?Q?KSWGfTfWexOTpIUvP9FVG7cgtCu0iEieQAGjFvBd0n2ulGFLUN/H/gbE6lhN?=
 =?us-ascii?Q?MCxhx0FSFzvsLrE+F3HBty8LDmE7z/EarTjSaZqjdCWqWM3JKTn7pcQb6elH?=
 =?us-ascii?Q?gsFVlB8V9i5MjikRMa3iZQTSA39bAfHTfwnFL6uPSHyS9Z2pwu7yCVQUChq5?=
 =?us-ascii?Q?r68hKJaT8GmJmXlL+JU/+orAiVvc/shDNpT0UDW2l67cBJHUmrgt0/yU3I1p?=
 =?us-ascii?Q?3BskPMYBsdZU+1F2nM3RvYsTuP00uC04LCN5o8A9i/vhV7v1YhaIQxyrae8y?=
 =?us-ascii?Q?3b5Ji2lkfUFMdhpC4FGhembYo4PNB65bUT9ajCgUSC5aqAY3KKN7fIfx/Djf?=
 =?us-ascii?Q?9w3sCxccy1vnM12tlcb+WiPTyBZvEHL3JggPfIpizhIiZAPkj+Uq1DVxtJdG?=
 =?us-ascii?Q?MlSjCJtti5ymBuwXJBYfrA4AqP6yuAwJgq6fx6U4tu++qAa8cQ/aYa2V49FQ?=
 =?us-ascii?Q?34VzbeJvD9yRCqL75mzIYFP+JK2QzeEVm3jCzQdn7rALjM/mkY5V1pV31lvU?=
 =?us-ascii?Q?C3QnBhy1O2DQ+myqjXjd08YJmcNnMn0F9wv0ns8gBL0uOQdpYxfoG7OS+I7o?=
 =?us-ascii?Q?BIZgtq/n6+u8f2WovKP6ZxfeQAwVxuG8VTzt/HK2pX6khu06e4YZfLUN+tcU?=
 =?us-ascii?Q?yq4UTxcVVuHDjlfmEnZdn/pnlJLo91wlkztWHohgH1uNSZtLAuONJUk2mDlL?=
 =?us-ascii?Q?7MhI75Z5o231rwZLN1Q2ByK8dAk27GDQAWkFhTAv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd54453f-9cbf-4ad1-a22f-08dde4c5b9e0
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB8641.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 17:26:43.8923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GnZ/NP5awz83lL1hyE7J+cV/IbP6eUJ5U/g7b1V7HZ6ro++x3YRPIoZzUWc4jWSZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4222

SW bits can be placed on items, including table entries, single OA's and
individual items within a contiguous OA. They are guaranteed to be ignored
by the HW. The API is very basic since the only use case so far is a
single bit.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/pt_common.h       | 29 ++++++++++
 drivers/iommu/generic_pt/pt_fmt_defaults.h | 62 ++++++++++++++++++++++
 2 files changed, 91 insertions(+)

diff --git a/drivers/iommu/generic_pt/pt_common.h b/drivers/iommu/generic_pt/pt_common.h
index 5ed06104d38b45..ac139ae74e670a 100644
--- a/drivers/iommu/generic_pt/pt_common.h
+++ b/drivers/iommu/generic_pt/pt_common.h
@@ -338,6 +338,35 @@ static inline struct pt_table_p *pt_table_ptr(const struct pt_state *pts)
 	return __va(pt_table_pa(pts));
 }
 
+/**
+ * pt_max_sw_bit() - Return the maximum software bit usable for any level and
+ *                   entry
+ * @common: Page table
+ *
+ * The swbit can be passed as bitnr to the other sw_bit functions.
+ */
+static inline unsigned int pt_max_sw_bit(struct pt_common *common);
+
+/**
+ * pt_test_sw_bit_acquire() - Read a software bit in an item
+ * @pts: Entry to set
+ *
+ * Software bits are ignored by HW and can be used for any purpose by the
+ * software. This does a test bit and acquire operation.
+ */
+static inline bool pt_test_sw_bit_acquire(struct pt_state *pts,
+					  unsigned int bitnr);
+
+/**
+ * pt_set_sw_bit_release() - Set a software bit in an item
+ * @pts: Entry to set
+ *
+ * Software bits are ignored by HW and can be used for any purpose by the
+ * software. This does a set bit and release operation.
+ */
+static inline void pt_set_sw_bit_release(struct pt_state *pts,
+					 unsigned int bitnr);
+
 /**
  * pt_load_entry() - Read from the location pts points at into the pts
  * @pts: Table index to load
diff --git a/drivers/iommu/generic_pt/pt_fmt_defaults.h b/drivers/iommu/generic_pt/pt_fmt_defaults.h
index 8738008d024b0b..a837ee9abdb7d4 100644
--- a/drivers/iommu/generic_pt/pt_fmt_defaults.h
+++ b/drivers/iommu/generic_pt/pt_fmt_defaults.h
@@ -190,4 +190,66 @@ static inline void pt_clear_entry(struct pt_state *pts,
 #define pt_clear_entry pt_clear_entry
 #endif
 
+/* If not supplied then SW bits are not supported */
+#ifdef pt_sw_bit
+static inline bool pt_test_sw_bit_acquire(struct pt_state *pts,
+					  unsigned int bitnr)
+{
+	/* Acquire, pairs with pt_set_sw_bit_release() */
+	smp_mb();
+	/* For a contiguous entry the sw bit is only stored in the firstitem. */
+	return pts->entry & pt_sw_bit(bitnr);
+}
+#define pt_test_sw_bit_acquire pt_test_sw_bit_acquire
+
+static inline void pt_set_sw_bit_release(struct pt_state *pts,
+					 unsigned int bitnr)
+{
+#if !IS_ENABLED(CONFIG_GENERIC_ATOMIC64)
+	if (PT_ITEM_WORD_SIZE == sizeof(u64)) {
+		u64 *entryp = pt_cur_table(pts, u64) + pts->index;
+		u64 old_entry = pts->entry;
+		u64 new_entry;
+
+		do {
+			new_entry = old_entry | pt_sw_bit(bitnr);
+		} while (!try_cmpxchg64_release(entryp, &old_entry, new_entry));
+		pts->entry = new_entry;
+		return;
+	}
+#endif
+	if (PT_ITEM_WORD_SIZE == sizeof(u32)) {
+		u32 *entryp = pt_cur_table(pts, u32) + pts->index;
+		u32 old_entry = pts->entry;
+		u32 new_entry;
+
+		do {
+			new_entry = old_entry | pt_sw_bit(bitnr);
+		} while (!try_cmpxchg_release(entryp, &old_entry, new_entry));
+		pts->entry = new_entry;
+	} else
+		BUILD_BUG();
+}
+#define pt_set_sw_bit_release pt_set_sw_bit_release
+#else
+static inline unsigned int pt_max_sw_bit(struct pt_common *common)
+{
+	return 0;
+}
+
+extern void __pt_no_sw_bit(void);
+static inline bool pt_test_sw_bit_acquire(struct pt_state *pts,
+					  unsigned int bitnr)
+{
+	__pt_no_sw_bit();
+	return false;
+}
+
+static inline void pt_set_sw_bit_release(struct pt_state *pts,
+					 unsigned int bitnr)
+{
+	__pt_no_sw_bit();
+}
+#endif
+
 #endif
-- 
2.43.0

