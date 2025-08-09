Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95251E515
	for <patches@lists.linux.dev>; Sat,  9 Aug 2025 15:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754751868; cv=fail; b=mBJeBfyXqUH7tUMveF7RduuEW55GlrlZUNACpa9VX6MzcoVSLn+obvEL9moiQs+UawhciO4UBGDLxr5tmfwHID9v0f/G/oNLB8akNCeE8qHQOhbE8moikoMdD706C9URFGoC1wkaL8OxKSEALqq1t1uQir8kudLwLaX1J5x7/ns=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754751868; c=relaxed/simple;
	bh=lrV74si3tDiIU+yeJhKYE5rMI95xonuPCvCIAyQpnU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=R7ug1TG5qZTXHTCxdhklpSU8egiH81q5ZlrWplVs/ihr+YaI1nZFM8E3YelYvl5aPkWJNtCPJz/3WGqQmTBsO3U/aKtXOAPRo0L6hFMZGpqpsXt5Z9C1kCihaEHfOCPOi35OG9vIbDpqHFNaN6DPKF75WO3kM75dWNdlHWv0BQs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dqe35mQo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GJhfLcah; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dqe35mQo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GJhfLcah"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 579EstlL020115;
	Sat, 9 Aug 2025 15:04:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=VqNkyFX9a4N2nOiveVY0kSuDq/MhqBdviFS42Rm0IOk=; b=
	dqe35mQozYsjWOOg/ADPJkdAWEjfY1bLM1wryAQoGunfEmcx2QVUZTt2ePnBxuFz
	/3jwE8ggJZpjlg8G5oKNBDtB8+hz9jRccZWgdhIWRqUjbGxYaP3kEPdsGFk0eqRx
	idT+AmAw51zxaQ/3rCRjgNQOIBbqdPg+1R7XOFq3dEYReTs2ygFbN39tzDoJlrDW
	8P8rUzs6vWFWAzfxK1epPRMReEC+RaGdwKbjVOPVErGkcehe+Te0TzXQdxuf8lHr
	4I5W/r4osQEJ7H9SiYJoDcT09wG2MAoLEkv8PgTRBe03r18Yw8/iqDQKIGo+EVrI
	acY8a12rnHlbI0X/SayHDg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dwxv0ak3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 09 Aug 2025 15:04:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 579CSfDb030164;
	Sat, 9 Aug 2025 15:04:21 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvs74kbr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 09 Aug 2025 15:04:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WRicyWhHBya2+AI9obDSSIyawEaP1nXCX2goR74fNw1xgzxERewjqjcwFvAwVWtBFaYPbp5wpEZbV7h+AutpSHYqzTt/QjpzL2aHhYq2P1eyFC428GeHFImqps04V8n3na3v12J42hWi2Yo5EHWGpgAqi1kDQbYEYCV+9cVcvPKaXcjSZrBy/Lmk3rocIl5p6z5IeYnklu9YogUXTmYYn6XBN3h0BYEHhnOj9xs6WDGM0ZpJEo74zAKhAI1aTK495U0IYO1Ll4kbsRUKbXwa/YrpPo1p6yyKvzGkwAOn4/5XjkNmWGM0cBvxrWb8/3nSyVTltCB6emEPfiBhieTs8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VqNkyFX9a4N2nOiveVY0kSuDq/MhqBdviFS42Rm0IOk=;
 b=I0BUTlFrSOHEBpVJmhvBb85XlB8eNOrzEpIy1cHzHVYD8lSloYHv2elExJsbFMXsxb/V5i7c2xGffnezYjni9lJOhhRmh7orTn8RDgC+y2p5VHZ3YIZtP62dDGwHjhYSQHTeXDRx44Zp68779/yDYN7yDUWcXOQTdr66Ih+LOyI/qjKDu/36tKcrc38E2WdxeDPRfAyWeJ6kkTPAu8lT9XSu1l/o7dpnGx/W29L+TvhYXvmqwKadNau0HP6a/qs3IOOl2UPhPzZAtrafH2QB4eWj208GyDtX34mGEbqMwCCbyIha1iaGMvJtsfch9muQYKw5iOyFNHsLp4+uSLayKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VqNkyFX9a4N2nOiveVY0kSuDq/MhqBdviFS42Rm0IOk=;
 b=GJhfLcahnZttmme05rno2NuP+tii+23zPSjjpXcQTej4RctUxI8glylCvBpqcs5+avhrLYgOx2W001TolnpiWORnjDF9rywdg2zSqYikZCHymQLSpzryinn1xBxuoSn/M4492TJ4qcYfm3jIeIP8tUzb7hQ3PVyNikDHRft4twY=
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 CO1PR10MB4724.namprd10.prod.outlook.com (2603:10b6:303:96::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.20; Sat, 9 Aug 2025 15:04:18 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::156d:21a:f8c6:ae17]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::156d:21a:f8c6:ae17%7]) with mapi id 15.20.9009.017; Sat, 9 Aug 2025
 15:04:18 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc: gerrard.tai@starlabs.sg, horms@kernel.org, jhs@mojatatu.com,
        pabeni@redhat.com, patches@lists.linux.dev, xiyou.wangcong@gmail.com
Subject: [PATCH 5.15, 5.10 1/6] sch_htb: make htb_qlen_notify() idempotent
Date: Sat,  9 Aug 2025 20:33:56 +0530
Message-ID: <d8d3e034c967229486ef198ca4660f0d8bf9cdbe.1754751592.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1754751592.git.siddh.raman.pant@oracle.com>
References: <cover.1754751592.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA0PR01CA0101.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:af::11) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|CO1PR10MB4724:EE_
X-MS-Office365-Filtering-Correlation-Id: 2731256e-6a5f-4245-c6ff-08ddd7560389
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pbpF9gQKIGVe4H61CdyxxmxiXqZCiuRCaF9oeQilezPcHYL/ut/5eDlvG4w/?=
 =?us-ascii?Q?7r++Hc/VWe6fYlOPZfWndXzcqnpB8ARAiZpoguZUdW/kp/jTGxMQ35IvRORQ?=
 =?us-ascii?Q?zp9YXHbeow6LZrshRc9gTXoLdoc1hh/kzz8aowNzpx5XBehqp5d+v//S3E5/?=
 =?us-ascii?Q?yDSTAWy8aV28AqaywmE8Db67VqmQ/UNGPtuVfaSdgZZQPkfTbMDkW5TT5hhH?=
 =?us-ascii?Q?+ZHyRSD4rAyXhkvGm45sv9NfHKYFFc+R+QRDjCB1BHNLi53W8uSH4667eYTF?=
 =?us-ascii?Q?nzkaqejKI9EVPd9E9CrUPc9tP9G03gcykFW30xXRd5E1Y85jxY5bpbAg+4o5?=
 =?us-ascii?Q?GYyR+UBhXKjBAWjZdNunIPfiRFbEPZrKrQMfMqFN+vbpRJEVeqWY01V+AZha?=
 =?us-ascii?Q?Z32g+gGD69TuFMt67vq2fbkMAWYpsLcK5bOEPL2ZDZvkB/+Bcn9HcIpPGh/i?=
 =?us-ascii?Q?8UshIceSD5I4+g3M4eqw9oCF8bMzX83vO3k3tTgZMSvFx8G+h3b6V+2ejTPc?=
 =?us-ascii?Q?XGaZ+X0uNE41JUAsaFXqmUlDBw2taiWXgdf3DKjiExuuwC/aybrnH5a0N9/n?=
 =?us-ascii?Q?Ji5V7C93EiD8EvZECrYnnlHK2oAXWJVw49CPTPIZazl3eBhYSB0EXpy1pRap?=
 =?us-ascii?Q?MqC/7S7XZbFDMjsRQHy4VdMG3GnZd65tilmOBENkJI+zS3nXbnmebhEh6vkc?=
 =?us-ascii?Q?9j2FtjqqtqyRws5TYbHu+y7R3DKwKDxYr6r4oE38EghF+/EKFiBDx0BOuIpC?=
 =?us-ascii?Q?yp6QYn9kfCzGm+jHi5Vm9Nzm+She6NGf3VvVSjucy3ixpTuA6oAAu3WhXPYP?=
 =?us-ascii?Q?0qFsy6EKh6A7JAlbyVPrPM+sx1ivost+JVDgUPGPjom1uYljj7dRXDwe57Au?=
 =?us-ascii?Q?1uw9Nf3YTrUFJQOpyHirgQRVxsY98JAIVUF4YXPba/ND7FJBPUxzL3GlGKmF?=
 =?us-ascii?Q?8TU7IpBj0/Dal+mfRXjSINgnweBwthDWFgzYzNTd1vhWeaDxhpIGif4gsOjY?=
 =?us-ascii?Q?cs3KItikB7Soaxqrdc8sdkdixoza9v3IhyoyRYYQ/9iDZtTvLmetBKgV77Dl?=
 =?us-ascii?Q?qx3ZPAZLWrYV3QEuGCL+gmoifh6eLXB1Ldhp3fCG4+6OEpim2WaD4JW6tqnH?=
 =?us-ascii?Q?fNkkJsfyh7dtl3ll+LhJlJ00gGW/PMitVFSMYlGdMRcIfTwwWw/OX1XT+gEU?=
 =?us-ascii?Q?J9GFvTGKOLs3w/mk6a651tm3sjGvGwjr0lBibZ8YYTqbdsGhoXP+Xe7xxKdj?=
 =?us-ascii?Q?4B1ONk6cTMBmeOEc3z90y/xgCnViAQ+9HgSRJIcu0P4TuXg/NhobeOEzEwBN?=
 =?us-ascii?Q?NmdAhxvvzURf/8Uj8LtWaiLloSCsx85RTf5J5k7yRGZEP5Ct9T3EJLF9eHXH?=
 =?us-ascii?Q?xauB8eY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Eqg0vLr+WJC3UxkKvUjvv7/CyRsab7MX6BwFmbuTR2Q3R27xwI0GVMC6n0J6?=
 =?us-ascii?Q?grqWoQkH8+Vpl9td9tUrvNb6DHH0eyPLOjy5KDlIF5XXAHs7SUyWPLFXmEXz?=
 =?us-ascii?Q?YPuoKnxIdOWAC63OF76p5xYpwmgmbGon1RgdmXbBIbNx7+afkWvpS4YJ86Pt?=
 =?us-ascii?Q?UhuD+FBjdBGL9xAIHSpT2sIKLyZ5sREStkOLDatv7hjUZivazyZLkmMGlKTp?=
 =?us-ascii?Q?+0dIVptIwSHdotkDDBxJHhIHV3DfVSHEsny8S3ST43tM/p7yQXENgzvdAZ/a?=
 =?us-ascii?Q?ZeL5H5u+UDis45ZgRKxYI3UHiS445YcqVMslKSRoiuZ7tWd//hSWsQG4IIP1?=
 =?us-ascii?Q?JSW4iBue1iYp/viH87LX+K5by1P83Zjn0/h8YQiTVXDnGPAclYyG2vyItsE4?=
 =?us-ascii?Q?w+3jiwNIAZInMkkb7cpRyPERjziOeHWwyX/WHPlnxQ4J7m2kNIpm+FQuNAY8?=
 =?us-ascii?Q?40OMaNPswlpsJpwrlSILcPcGYB7h1femlFSbvRVPCcWEJ0qy0FePXweFkBE8?=
 =?us-ascii?Q?e0LfFU2sbbswoXc4BJOtCstoPu3SNvCxqn407aeD8QVscf+jB7MakoSBbDUW?=
 =?us-ascii?Q?aBAvOZV6qhDXieA6OLpMGOpWDinl3sLeVzfTfdx+rP+NVK6FwLuvtPYEWJQ5?=
 =?us-ascii?Q?OrK/C8vbLP60DDepbpg0s6ajcyR8B7EkSM6sx8GN7NtfOH7FSks46LxeO/U9?=
 =?us-ascii?Q?7CUv71fDbUE3PDwywWVm2JAYi/PAoxvkf5O/jIR6Tfeyykf0PaEjfbSjcXeH?=
 =?us-ascii?Q?CVzFA1Jmdi2O6T+C90+7oo/oh7WE5XhHl3XDYerqmW0FG0UtyB1PHr7iFcJP?=
 =?us-ascii?Q?AqTOvon1GjByW4ZrYv0h5vSTE6IHJe6F7AtkKNWs67ybhS1kdCM8ecINvCVn?=
 =?us-ascii?Q?Rjxo0G4unasPNGlndZ1OqG/yAmxpfFUx41DS4Gh1dsPw2sD08WsrlZ9aGtdt?=
 =?us-ascii?Q?/ezyTUzCA4sx9AZAWs+wbaQ8dtdC5weK7xIL8cxVYPjlXMAJ1RvbDXeK2l/e?=
 =?us-ascii?Q?Wb3gPMBU7yuBTf9E40+eskBsnz/7z771WSNxlzrZzEbla0DUf4lS7RsaLygc?=
 =?us-ascii?Q?yj5+j7y9JNg9AhBu6eRul8uVcPt7uHWKyFUlx/TQ6xGQslCru0KN0PIJIdeg?=
 =?us-ascii?Q?PgVsP7mo1WmA5Gl1jXv6lWy7MiGFWi2gO6blC12kp2BL3ubwMBX7rQkXRogT?=
 =?us-ascii?Q?J0nu6zkZIaj8xqYKYQ+ptPW8FZGaDX9sGaDEQpai6ZLYpyueBp4u/XYFIOFG?=
 =?us-ascii?Q?mn8VcwUh2/Do5hdIpLTnXCc0UmayQ6SPPgGCZLo/3WNheyvkHK9C1ULghlah?=
 =?us-ascii?Q?NTXyZn15AeDmYQ58e1LUxb73ADpA6p6nv+t+LjJFJvLxtd6YnBUi5jHwudYy?=
 =?us-ascii?Q?uAnOIrP3ektvfuSAvkJ2u8bX1+mYvXc+BY5tj3lQrU+rLnU6PobCXlbGACUt?=
 =?us-ascii?Q?cqbVl9EiqeewK8cyTGN3NhEcWkzrUzysceazmXBO707smpV6Rp7p74EZSJvG?=
 =?us-ascii?Q?oJ+3se/0MykeFog/g7dCDCdYxKs6IW+mIFrfqinD2KGWoRAl0O5OsBPty/6x?=
 =?us-ascii?Q?teXlet538Ceq505miEhGxWFPC5hiHTgg6ePoiwH3WgMwn/QOBDdQfGkxSGPe?=
 =?us-ascii?Q?UbSygwUUnUwFWomGeNxQ26Pvf4zVS09bRo61bfXsJtlvB+8qszSkyKkqaRtH?=
 =?us-ascii?Q?J4qpbg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TYh8HftFMiKnaz239c4xfbl+BD6pDso0eXtB9wZRL1hiWttYUepIss8HbFI/kLJsOLdLBewlN4dwlx1IdMEkweVYaP1nGjosX0QaRQwI+o98vF8LKOr7lZk/NJC1vGXktRWWjVXi7JokfRyZ1X4xTvsmlxR+yhiFJ88m1v++gUsKgr2Zq04yULh+R6PHili5X21vXTlcxxJi9ek1GmBgvhoXDBKPnhL3DJ5tYErOQD+Bs6IoP+G+oMzAhQZTAabUNgxw5Z/ETOTDdS1qdXyvioyDHYUwdskaZfgpuyXU6kbF2GLoDsyexbOwYv1ZqtTdupUHgSFoO6zVWqmOsIe6+SFEubiFs6GUhOLs/l//4O4lbCPRzSXn4UvUH+d0BQR7fok0BXEoZu5KgqudwTe8hlFTZ5g3q6zoO9/k4E56eTeFi2o3uD8pEtnHvbze6e8DIjSf/hmInbZuqyeP/cGpvCM0sNp8Wi0Udo0YAfMs8nMs8FERXuud2nrLVkLewNjiwIvUIjtZ6PRot6TeYtA2lx8901Pdb4qTQNaq+ZTh/W84LDwimgPviy/+tNX3F4LPRpdlWtUsSHX72IsEHdvyIEdibEk6H6nInzC/ham+318=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2731256e-6a5f-4245-c6ff-08ddd7560389
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2025 15:04:18.4464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H1a06bzj45pkuc1/9q64wn2CRTgAFcrB9FYc3V3S/E9QLyJGh+Zkhq8oyBwFt1PLr5mke2Qv1ZiDeMwbdl/TbuSqJ+9k3+NAAPqXZpKX4mY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4724
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-09_05,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508090122
X-Proofpoint-GUID: Mkn00sMa-msQwOgXpCxue-W9AXmE3iFR
X-Proofpoint-ORIG-GUID: Mkn00sMa-msQwOgXpCxue-W9AXmE3iFR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA5MDEyMSBTYWx0ZWRfX7q/INkEAAnLh
 zVPGou1kWw4jcGPpZXsrkeL9AWtcaL1EK7dNNtu1IxGj/bV+SXHR/v54da5Uo2nbG4p/WaElIDM
 /wjNE3wO03s/LOfVMowa9CHYNqkpgdfanZVBHjOK4S/Q7tkLKK7oHDcWKQvm+yDq7Ri+xSBWDca
 2YznY0ZTx7eRdYVkpF4vULMQMsKAPumJLwGIAKVlRfEDowZO/tDbz1YhYW/+deW7o/aDS9VhQVe
 kT6OfsiN6BuJqLHingGT8onIPpq1AUIMhmTkNKtT8yfRHm9sVHznneglbdWbAfKT81S1yVanCFa
 4br2Fd68MYL+woG76LeSaj498NiH51lK9It55y14ED60XuU4qp4stx/h1qeftnxBecIxQP5UWHE
 4HZ8K5tpe7mkGyMFS2JzGb1QuA3O4MYNZirSxJqRery7+GOLawD1F7+zgGOivQczECyCAAc3
X-Authority-Analysis: v=2.4 cv=KJZaDEFo c=1 sm=1 tr=0 ts=68976376 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=bC-a23v3AAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8
 a=A7XncKjpAAAA:8 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=0-FMaas_rSHBduI52eIA:9
 a=FO4_E8m0qiDe52t0p3_H:22 a=R9rPLQDAdC6-Ub70kJmZ:22

From: Cong Wang <xiyou.wangcong@gmail.com>

htb_qlen_notify() always deactivates the HTB class and in fact could
trigger a warning if it is already deactivated. Therefore, it is not
idempotent and not friendly to its callers, like fq_codel_dequeue().

Let's make it idempotent to ease qdisc_tree_reduce_backlog() callers'
life.

Reported-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250403211033.166059-2-xiyou.wangcong@gmail.com
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
(cherry picked from commit 5ba8b837b522d7051ef81bacf3d95383ff8edce5)
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 net/sched/sch_htb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 8ce999e4ca32..f3a20a5ee306 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1504,6 +1504,8 @@ static void htb_qlen_notify(struct Qdisc *sch, unsigned long arg)
 {
 	struct htb_class *cl = (struct htb_class *)arg;
 
+	if (!cl->prio_activity)
+		return;
 	htb_deactivate(qdisc_priv(sch), cl);
 }
 
-- 
2.47.2

