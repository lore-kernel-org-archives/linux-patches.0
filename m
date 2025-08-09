Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E73A933
	for <patches@lists.linux.dev>; Sat,  9 Aug 2025 15:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754751868; cv=fail; b=hP85pQM+kFJgM+8VwXBl7c6nZ1G0Q8it9bzDhe6PlfcRsCrRbfHW+OGW1zV0ppyMsftVF0dh2jyJracVQZYHWjiwPkNjKeMTYZn6Sf+dmtjrio9OjAQ02+v0BNawnNfRV4LcSBGH+26YMUpsb8r3MMZxR99Fz6Y5FBglCVPNVQQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754751868; c=relaxed/simple;
	bh=OvZsxd8HkcSyoXUewyZI7NbZvwXtf62oHOVb9klslt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GhY4OnF+uM/q+v31TJ3jSDDYLRbLTbBu++q7YVaXOEhAG+rS/J86GD+03yo0n7WmN2z3FIla/5iXurShorSVe3bOzYgcgP5U3qaRP6QKEQf+wB/KUf0NBm5hARymGm8aaM97uoLxLMDkVKUyfn0C0ExbiZrCbEfKQPxGhLP68Mo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Op9jDUZ6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=a38dl9cx; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Op9jDUZ6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="a38dl9cx"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 579Etvax005751;
	Sat, 9 Aug 2025 15:04:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=MU7mcKmNyG+610vzu0WD4jALMoH/tsjzowla/H9Q+rg=; b=
	Op9jDUZ6opDjZmSGMCVjTEVwe767FFnD9Law6QsssvMRc1zx3x77m3sWMZi4FK4h
	ZZiXn4qdWrG8575Z1442dPB92w4Dve62sk7NkLL4QL9QE8l5ELTL89PfhNaGOzRm
	PVe7MHELecGZ8TY0KP7lS8y49JLlMzC9/y+KSE8xkd2J6cMP9zxL6Jz1KOhTHmyb
	q4CIEjDKnTJLryQEzbj4VezGEYSJMA8KEAN6aLeMngwDPq4jQI1CVCfrsSuglCOA
	kHkxHG6wwa36G8QjR2fTr2iz9dNlzWPsRLQCXVl3+1SIABoJ/k+/+5AEh+uxGD2x
	ACyKHdRAWHovirnxBVDkhQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dw44rbqr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 09 Aug 2025 15:04:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 579DU97U009858;
	Sat, 9 Aug 2025 15:04:15 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2045.outbound.protection.outlook.com [40.107.237.45])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsdcrsr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 09 Aug 2025 15:04:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V+L81jBdzKUEpJ4ZlyvI6xheMoNvdiRriV1u/50wFGZlgkvr5ovxhfZAlRjvbF/y6/mxlFbZs71Y6VV4OnnBru+xfQPO6zMkTUWXy3HcQjUqvwYuwgt6bf6d/iJY+K6170KZx/8ikLHkQsmdfGQXXPorDjXAcPOPNP0Om2WABQHIV6TJ63gLZyl9CYeirbocfyjXw45m0jEI56MRBS5BAZ3ebuDfSxv2/gHxoO4AODiy5Oy1T5Gd33wO7Y3kR8mLbE+idJsvFW0maMWH54VUAsti4V18I1etEJa4+MjV98cS4e4VkjsRZ1F0tJ6Ty+TgWQjrJL5Gz7sFA/kFeeUgpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MU7mcKmNyG+610vzu0WD4jALMoH/tsjzowla/H9Q+rg=;
 b=YzPJE9zJTmtNJfV5R6njc5ODb2hQmfFTDW+jG4+soilxt/0ZrLamM2PXTgSy86UFkuIsxNMbbtqY9Jv8s5SDLOHMG5d2wx8eO2h8BfTtfsm5v+fXxbDgj+OikDRQTBOwK6VvV5fC2eNUetftH+dAXlk3iXt3pHXAXtowp4JtpJVi16Z13r9mlbo78FAOvjklOanuI8dMfRMlVC9rvXIXXE+IIp8I+fVV3ZEySL0RLA/9cIteuxi53IlV646QpIA/2pDWCfcENxfwI8k1VjF+y0xJ861SDs3Ltdo/vT9aYE3h1Hd07CShY9WQItwxqXAFSUEQvir9w7x121rQGyD+fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MU7mcKmNyG+610vzu0WD4jALMoH/tsjzowla/H9Q+rg=;
 b=a38dl9cx9nTjdfIkNZgz6RtuU4TJADfs/T6WNuYmP+vSZhAdfr2vwXmC50RIyRSjIv6WtkWWAa3005ALx4zMcg430VN0nr1KVCjyWO0wfVhfRvEmj5g8WqytFgu9XsWmsaTfWOe2s7PuWu2Vc17YI8P3nuMIlHJVjvpr4k+dQEA=
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 CO1PR10MB4724.namprd10.prod.outlook.com (2603:10b6:303:96::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.20; Sat, 9 Aug 2025 15:04:13 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::156d:21a:f8c6:ae17]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::156d:21a:f8c6:ae17%7]) with mapi id 15.20.9009.017; Sat, 9 Aug 2025
 15:04:13 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc: gerrard.tai@starlabs.sg, horms@kernel.org, jhs@mojatatu.com,
        pabeni@redhat.com, patches@lists.linux.dev, xiyou.wangcong@gmail.com
Subject: [PATCH 5.15, 5.10 0/6] Backport of missing net/sched idempotent patches v2
Date: Sat,  9 Aug 2025 20:33:55 +0530
Message-ID: <cover.1754751592.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <e9d1d65ce802b4c8190ad4e5944e5be1cab38eac.camel@oracle.com>
References: <e9d1d65ce802b4c8190ad4e5944e5be1cab38eac.camel@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA0PR01CA0092.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ae::16) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|CO1PR10MB4724:EE_
X-MS-Office365-Filtering-Correlation-Id: a881e299-eddc-4dda-46f4-08ddd7560032
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yHTSk8Vteh8V3Jpsae80LFMIPp2Xre14sPkTKX4/r1t0LbjuSFEx8LqnTMc6?=
 =?us-ascii?Q?0WbqaZbQlwi2F0/fPzWkutA6TaLcADTNFBhxh2gQWoFNf9OLoXth2ZqDH/0u?=
 =?us-ascii?Q?mY1Az0fPkTFvpeA+kNJKXF4qPumFDQpwk6adCr7YcuLJGf+10VQmCbCLco0m?=
 =?us-ascii?Q?kQgb8p7rkHYjrdg9mbhokIE4gdczeIRBnHKafFC0R58BLwM16uY4gnHDkEo8?=
 =?us-ascii?Q?7VoCfIIlvLVJ9dvj4rA5sIA9LwPJxtFV93ieA9TZFKhTC6iNG75pr9hvqd2N?=
 =?us-ascii?Q?Nn0xD22AQ80vVTioM0AYam8phy+gThuKk+6GUDU66iEIdWM47i1rclH0f/UO?=
 =?us-ascii?Q?zwozOWtA5/Bvnx2KKro43OMUsR+zMX0M1nX4SAR1jWj71t4VIxMMfTWeuI5P?=
 =?us-ascii?Q?Dk10uJkxgT61+vWLKIJTFDuSfrZLeopEAvfpkQe+H5dCNkrirCC3vFmY3JTj?=
 =?us-ascii?Q?I9Y0KpQEBx/tV5VNS8W+60bMLlV9MCR108MK9k4E2/RnmeKGEM/FrWg+zsY6?=
 =?us-ascii?Q?sLZGTypyGyVJDh3LiSAeQIsyDbNNb3K73tDU3dBD1B9BRvmFGc+ZsGjTapBq?=
 =?us-ascii?Q?ZqZK7PFKIJ5CUrnLMxG8y5PV0tcfmn2b/r25zvEQt6ckaRl2Q4J7bgyFC0Xj?=
 =?us-ascii?Q?1hOoeAnCnQ3xQ/RFNL5j0JYgxE0H8Drt1pTVJlUcOoCM7XLrBtre1CPRWmF4?=
 =?us-ascii?Q?bAUXaA/eFwKCSlKJ0CCJhy1DRtpT4R6ojEKd9aghfi6SpbihSrCieUY7FxEs?=
 =?us-ascii?Q?qZd3Ac/DdyMriI/t/91mU27F4yHlAMjTWJbboZ4MUTpBUIzNIMsLFF+MvyTA?=
 =?us-ascii?Q?NuClwpVjIQC9jKsm78Pg39YjpOJMjwNdxbujsnisabdvjpte7lRN/jGZox6g?=
 =?us-ascii?Q?WtVXDeOWIrfNfgLLplcnWgo2SwHlPBr0Znciz+185UX/JF6/w/2O8DrGu1cr?=
 =?us-ascii?Q?/7zYR+3msE9pIlVNXwJjog75YzXlZQbuQfeHPa/35yMUUU/ekXlGGYBOWhdU?=
 =?us-ascii?Q?OffJYQubgDMLhISRS2Qgh8GF/VxcFWSAGwerZb7J3LBLCB3dWm38PQNZQbsu?=
 =?us-ascii?Q?8JZEfYgx1A47CCm+JT4OKnro9eAi5Mbap7bUEJlwodMNjrLgRqk3xgUefleu?=
 =?us-ascii?Q?VzpyNFqk+O5pZL+c5z6CzTVBIlC0FN0XaKD2ClH+rLKnPE/W+N3Uqex/Q5el?=
 =?us-ascii?Q?G2yABX6BH/QV5qMJhoU8cn6u4vQvwD6b0Si7zdF5ZgqYdV/ILYHwAhuXJfFo?=
 =?us-ascii?Q?Pu8MmLOS/0CJKY9JpepIvzWixXNVknCd+GXY0Mh4rOJzNlP5daLkomAJ5D7J?=
 =?us-ascii?Q?2S9zjIS2dKfcT4jq8tXjM36CdVfbj/TrN/GJrOdmKIKD9DkBbnSslCtr+OEg?=
 =?us-ascii?Q?zXBIWpW1LqbwoHonmVX/fjOPOYQn6K2RsVEdYz7HQwU+s+DrA+1+ZPOLEsjs?=
 =?us-ascii?Q?VZsd8rK/UTk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JJzzMeqGH7SzykfXRwoOEpudKJCja/4lw5Ox5u8Uhi2xuSO7clF+jgAOI6Fy?=
 =?us-ascii?Q?oRVDcz0NhUihrvhmUBovEF4D/MtqaD1qpHh+7idaVTwihhCCBWvbMFhiTC1d?=
 =?us-ascii?Q?Ey/Jfr/q3wHCpk7rJaHu9gXHPXcP5O2/3qPIl3mOfALnhxEqUM7JWbxVL1OB?=
 =?us-ascii?Q?7KfOAFZeF/6Sk5eALUAZA15LAuyXz40yMJHGiqr5hacC/pKwkTQ0s5KmaxdL?=
 =?us-ascii?Q?axJMWafT3/TVjm/efvtUnsIuWjMpHkJv4dAg2y4ChHYccPAbKD3lgpKEMOOw?=
 =?us-ascii?Q?VAYGqbnyH27eawn4/E+0DswiKptjN4+vM7jF2DTgrMqf8JCgPBQ22Z5MlXXe?=
 =?us-ascii?Q?9Ju1YvyofNMLRrn7rhc1cPDoj1b/VCtDYdF1UNEa1uuL+JvgtdAgAwbAIQin?=
 =?us-ascii?Q?DD32O+ad0ksSSpUo8q8DYN6pDGGtbyzCVGTh9v0gd7kyq81d9q7uXCOYVHA4?=
 =?us-ascii?Q?6pdWRoXg1iNjsISBOoZxEwcpHvLwXO3ux/Suqa7Am8+jPZn3H4cA5Ct0zCgU?=
 =?us-ascii?Q?zyAszRo/D2WaXH4AQoJQQVulqbEEK1Q/GjMU7u+akhTkI0RgSh9n6b08st41?=
 =?us-ascii?Q?hMPu3bacOTSHlpRsKFlCyjOyOqY4HqktnQ/QX5CVlzbIMQLNTjTZGa9pgC4i?=
 =?us-ascii?Q?SSONvqRLwPB57Mhk3JJPmcjG/VN2K6pRu/tkMqSspSYbIZso1ClYDAR6y4+7?=
 =?us-ascii?Q?2hQVwhCljtwG7Vikja/H0raztgU9t10bzNKjJUzKwmwQBhTaM0Xh6fXpDWxV?=
 =?us-ascii?Q?ITUWog5CGIWbNOVb9KdKBonBfW9l7l9GLQ9D9XkFfIUJGLu90hXpaErm51VF?=
 =?us-ascii?Q?EHpZbw390xYNWK9pXz/Oa2teNDqq3ywyockFgmHbInCZRekwt0MFTKLTXGxr?=
 =?us-ascii?Q?g23ONl6QfgwBP5GGfEBP23qP5OtQ9lasPAMnbJBgEry2NFDlxw7OIKuNwRCv?=
 =?us-ascii?Q?BgVAfk98b7kJxpoFUEA1WXt4MsKhxds42x6cCRFV9k/M1qZ3+IMV/BeL7DE3?=
 =?us-ascii?Q?gqGVghbwebsEHGMmGeQ3xfQ0XsyLJdujkcI45RD10UBs3vcnDD5kytCkAwJV?=
 =?us-ascii?Q?R3GP21OzPai7f9KOvcuaP2piBvfdV24+kKArp8gCZOJ8QZuqLcOFGS6KTXd5?=
 =?us-ascii?Q?JQaCjQgq/mTsc2kKmp/SauTq/xsGLLv1LgW/u3Uqr2PG4m3YsRvjLTdF5V2z?=
 =?us-ascii?Q?J2O0HTFP7SrOSKi0djYRNjAM7ZQWCF9eiIRlEF8tb+k6mwt3PF2De4jI810i?=
 =?us-ascii?Q?2/BBXOs1yp6dq+3bjY2afD+J0jOowgklVT1/udk6wCZm/Apbnl3fTiTsBKFb?=
 =?us-ascii?Q?pMqlKBqNmacouiw5qVuOcaXqCmeVm0VIb70STO2/Q/ZrfQPkmgzkv9ZVNZ/Y?=
 =?us-ascii?Q?+ANczEn3ITfBSE31hTdJxH1NJBoEiFb0m4t0Itr3YonVvOL1DDm5ATE+2h36?=
 =?us-ascii?Q?H4SisBueP+JdDLDdaLVyNtdxaaJPfa7QEuAYLov0z5F5981izkGbZJajx2tc?=
 =?us-ascii?Q?80+D574k8DGe93zIvBOg09ESlvc5fCeJhNNmAFKGbSaBS+3D0A2ID6lRlXPg?=
 =?us-ascii?Q?9c43lorpAmr0vWR6TvppXW938Jhqk2JiD1Ki16Te/O6ADOB1gfE1Bk7DaS87?=
 =?us-ascii?Q?2Vg4apcF69pgfmdqmSVlwKOtDPdtdVmg1EeTJe6UytHIAoUQK8171FmC/tYG?=
 =?us-ascii?Q?FR7Nhw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ij9NNEdW5DR0wczdSmKIeKAff/tLh3dUZhMsoUq95w6U42Fv9+j2v2AO2G4pxyuNGbmhAY/n+ByN/59Sdsyp00t2LTilWZ5ifs/0oIMCxZvAuTDX9MCBhib3jGEnCrwDGohd7SzCMjBmgcI2vDew98z6n+TCs6GTEeN/BCBzF2SaJzf3FG5DLEGkT0tGPHRt8Zl+8b2apMDaglRqR/xlg5B2jigS36m0qePE/Kcs6e50Xj9sDtLwsl9qjI0N2UzJG0RKhu+hiZz//B8cR1ZwXEt4aNgWU6TuOmOllgdYlJN5jFZ9ryGTbg9pOzN020PolQweqQfVbP3nQSD8YWWpmjIxU1hpCUoHsfyIOVFNIt7lg7WJv16Ew5RTL0lMZ/QT5M0wl+XCM1c8rXboOGYqnSdCWwHv4dw6EFgnaa/65+dVLOrH7sQt0Qt+woIqIoZIzMjtLtXOTt9tTO0mi5mUsIBJ+iMaToOsJplqNsFg11gKWztfpx+x+Lam0XhjVloGgCYkrT+gENqCcc0fCKz+Npivxh+1XhQtHKg+s37G1edZnNbdu+E4yQWEhj4aobNfg6tSUY9ah2twSZLYGxfJQPeLETNxKFQKB385Bmipgs8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a881e299-eddc-4dda-46f4-08ddd7560032
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2025 15:04:12.8773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bjkJRRU2+bZo2wjPXpyLKOAs7fUBVox8K/kArQ5u2BTktL/uAHpbJMA6eKgPCHdsoI8hHvCBy+2jaRx9WYLm/+Ov8chyRbOn8HVHP76Wt+Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4724
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-09_05,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=729 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508090122
X-Proofpoint-ORIG-GUID: AMPEXaImfyns-Is-_E35Lkyq_uVVpZ1f
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA5MDEyMSBTYWx0ZWRfX2c7tIDj6r56w
 NMnu5VPpHTdb2oUmObOHeIjsMEE1fyBkAp+udyu9UTY+pmY0vIrgVGzFSDzAtA2kqLtpT8WEiA4
 qt3gSzT45iUVHCDuCbUDYzGpDje12vuWslkRT4YF7F5S3N6MOsqQjJRs71XbPbEcZUv5Dv0t5Ey
 YelG2cYduBcglZ+4schZmmME3X7RivIDn/e+h0UbT9ZlxRL5Bjb+uS9yFHNDhE8Y5rQ4O/2THaK
 ZVJsafJuyhLtDhj9D7zZTbsRXjxpM8F0UzsbDbCzISQKUSiCX+Al9QlGrGGtGy5moGaa/EB8ogq
 +WgnEhxi3QicDWYlRRN0+g+DV3OYnlge0F9SJkiHOSdVGixN4p/xGCe1ko6HTBNDkWURYrq2BON
 UOKeXW5zl1HeyF+7iRfJDsZecq6yBm7HeYKTvj7zGmNciqjuhJm03hPPrN4IYMQ9pWLzfwzX
X-Authority-Analysis: v=2.4 cv=X9FSKHTe c=1 sm=1 tr=0 ts=68976370 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=qMCDGZBdIHmcOkFfml4A:9 cc=ntf awl=host:12069
X-Proofpoint-GUID: AMPEXaImfyns-Is-_E35Lkyq_uVVpZ1f

Similar to 5.4 case, but in this case, sch_ets.c commit was backported
as a "Stable-dep-of" commit for another fix, but not the others.

So here's a cherry-pick of other requisite commits, including the fix
commit for sch_htb.

There was only one conflict with sch_drr.c, which was the same as 5.4.

Thanks,
Siddh

Cong Wang (6):
  sch_htb: make htb_qlen_notify() idempotent
  sch_drr: make drr_qlen_notify() idempotent
  sch_hfsc: make hfsc_qlen_notify() idempotent
  sch_qfq: make qfq_qlen_notify() idempotent
  codel: remove sch->q.qlen check before qdisc_tree_reduce_backlog()
  sch_htb: make htb_deactivate() idempotent

 net/sched/sch_codel.c    |  5 +----
 net/sched/sch_drr.c      |  7 ++++---
 net/sched/sch_fq_codel.c |  6 ++----
 net/sched/sch_hfsc.c     |  8 ++++++--
 net/sched/sch_htb.c      | 13 ++++++-------
 net/sched/sch_qfq.c      |  7 +++++--
 6 files changed, 24 insertions(+), 22 deletions(-)

-- 
2.47.2

