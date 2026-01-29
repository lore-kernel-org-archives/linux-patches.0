Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010018.outbound.protection.outlook.com [52.101.56.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B386732E724;
	Thu, 29 Jan 2026 01:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649447; cv=fail; b=YIyss62c4uH/xRSHY1s1q2JqMpXdyi+Arkr7tw/gRzi7xnhv82NsDUNvIwmZyqeyMY8+6ccazXx0Cf4zAzt10DUnGeE/b0vLpXCmIddkw5BuSyomSkkUIrWCRdI3q2Colg9f8vSIVaAQNyvwOX0u1BUhjDaFtXzZk8H1WQcJ27A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649447; c=relaxed/simple;
	bh=L+oeksKCZpBuHcri8h54Ap00h3QDIgHmNrCNfT4Aa6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=J44QoLpjW0z5Pq38D8JEjnCyPu0jcj2Rpbnev0fB0pD4lN8ryhCQwOPGt5qlj0x55kZAhVLUhm5E6r/zBFAv0PXITR64B2JRBzdtF61LzUniFS2mKmz98sxBDc0uU0jmsnKyctcdo9oLxIJHe8jP0f93E3oa5te2Upo7WUWQPPY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=o85pskAF; arc=fail smtp.client-ip=52.101.56.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="o85pskAF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AjI68Rc8mqG9HII1clp71p4JiXofB9sncnnTAYskGR0n3e7Lj/8ImGB2GzFVYUHwfatAzRNMLd7j1HTxLiOaRMuHCaww6dY75m3KUXUH5JArDdWo1jwC+1qGp4vJlXNhUJ7zJc7EispunEjk2ncGc5uunb4GEOCdl8b57B6p0ZxU188tldiTEhnWRYmtd/w+H4OjH7NEvYohHezAOwcFNYpqCGX5bJ5jHuQi0bIsdbF7oKZ5ZIuJOJDKHnMjJyjtqDcT8Nqs3UYW4TbLRPhfR4v8/poZJ2serbpApK1WAtgbVNeqKe+F/CFlIIn84pIWOlD8HDegAbAaFdauZlMLcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BSJn8uAfSFiBH4QSxTJNAJaxnMpDupFS/5G4+DzzV3w=;
 b=UT77dT1QRO7cT3iu6HirQ3Hkj/7fhbjeZjWR1cUM+w0g6Dr7wgGro2YxopHtVMiCrOp9OHUnz9p2ZLlZRJ4QOuPRIRWldiur0BpMxTQT/KkPNWFc22hcGzDczJuC0MbVu31rPsfRujnmCJ1779IPb4dMmbi6beKr4XwFtfefFr06+kKREVVGjeheWnzMlK1VNucdu53xKDlEoJ+p0uARPO/Yy8E1i0t5Hbd4RaU9sDUi5l50ql53n4UdEXyY5s1s6JXIJAL4iUz0a718iYTGZNYBkpHMvMpemdEoZPDzdAvJvs0x8DCSGhKu0SOwf82gk+LzGzkhI4GdPpdVIvSowA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BSJn8uAfSFiBH4QSxTJNAJaxnMpDupFS/5G4+DzzV3w=;
 b=o85pskAFN4m1i//edqiM2EkH631xUsQP47sU7iKbxkKCVt2740suSuCylPQKg3rq+5tmci5KBjUP39p1KsS0KQgXn4QI06hzgMhUg+1l3wKEo67XKe/syrI5dKVFflVTKBICqqoSu/7l61D92Qv9dUnbYtGI9UzgyuuxwkLhl5lEhojic5j2gMKhRZO9ea1rGCmnV+/hbL/B1AxnzgG89zk5DWZvZYqRjsmD4y/cdts7WsLTDwJSdf+JgoYUcGWtpdX7MTQSzEQ1nBcEoZdUnwyc6lypHoV6lOm7m0JRSPE60WMFNayTXa21QsY7tDs4Wi8GWCiJWkAlRggVflsAug==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH8PR12MB6745.namprd12.prod.outlook.com (2603:10b6:510:1c0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Thu, 29 Jan
 2026 01:17:17 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9542.015; Thu, 29 Jan 2026
 01:17:17 +0000
Date: Wed, 28 Jan 2026 21:17:16 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Anup Patel <anup@brainfault.org>,
	Albert Ou <aou@eecs.berkeley.edu>, Jonathan Corbet <corbet@lwn.net>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Justin Stitt <justinstitt@google.com>, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org,
	llvm@lists.linux.dev, Bill Wendling <morbo@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, Shuah Khan <shuah@kernel.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	James Gowans <jgowans@amazon.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Michael Roth <michael.roth@amd.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: Re: [PATCH v8 07/15] iommupt: Add map_pages op
Message-ID: <20260129011716.GB2223369@nvidia.com>
References: <20260121170931.GG1134360@nvidia.com>
 <5a3dfc0a-eca4-4de1-96cd-b4034f0b8e06@amd.com>
 <20260122141240.GM1134360@nvidia.com>
 <0295a5bb-2567-48f8-9806-0467907143d5@amd.com>
 <20260123141413.GY1134360@nvidia.com>
 <ddeb2bc8-5088-4d16-bea3-91d58a4403e8@amd.com>
 <20260127142512.GD1134360@nvidia.com>
 <cd7a2d11-bf65-4445-8eec-df9ba7950128@amd.com>
 <20260128133258.GY1134360@nvidia.com>
 <45f4f091-e1b4-4a04-941a-69ae522ffcd5@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45f4f091-e1b4-4a04-941a-69ae522ffcd5@amd.com>
X-ClientProxiedBy: BL0PR02CA0135.namprd02.prod.outlook.com
 (2603:10b6:208:35::40) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH8PR12MB6745:EE_
X-MS-Office365-Filtering-Correlation-Id: 84e81d48-a354-4b21-f6fd-08de5ed42486
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jbDtPWfgVY5pfYhBTJYrcCk5oCtVHZ5v9hS1Ly3Exr/9ORsjUlCa//80MIPX?=
 =?us-ascii?Q?N0bzu73WI20rVsjyRcK4VpYFn6lJYr3zJE1NQ96l2KSddgW5CjtkSBScPCEg?=
 =?us-ascii?Q?uWDXYVKWUK6gK7CWsEXTCqh/Cgl3M7YEachYlcCZRx0t9D3q0WBLL0s/Gv00?=
 =?us-ascii?Q?DF12liHO0MPUlgD92wFgFA1rXtjr6MN6gZl/A+LtwlSYCB/iPyKvswE3o2ym?=
 =?us-ascii?Q?EgTuYdEQ8c7N/+IizC4SUhzCKTaOIfstahj4oZnWdqoEeTEmcAL9JAhrPhzH?=
 =?us-ascii?Q?NFoOxGg1xe9iSWgl8hO9Qapn3WQAIo0XBQFQrKU6AlsqwTGQmO9GjIdAiH6O?=
 =?us-ascii?Q?dQXxLXk/EPrQE9mSyi5ZYebIUsdJ/iBFrRDubEptju+HeOE3OrHPY1M9ElUS?=
 =?us-ascii?Q?NVGwD4ITeLX+9yUi6xgLe9/c7crM6DLAmKagAtHS26WvVyPqsinsFkm5nOw+?=
 =?us-ascii?Q?E8YZQYyGce9V2IlK5U5VRdDz5xNA21oL6VsxUTUvnm97a/UksPx+UickuqAX?=
 =?us-ascii?Q?64znkF63f268ogrdkuXvibyiDmKlc+OWccq7GubyLJ+ane29gmch6tLdSGQj?=
 =?us-ascii?Q?okwzqDGeAjxOnyR0cAbepnh+yq8LJEZMzLbEdVSMsL+0qj81qw/diBPNP/bs?=
 =?us-ascii?Q?l3Rbb6f4bp5fjoOj3XbEUgqv0MYjKPKf+PgRYpe+4lD6EBm6TQgcsH3eMrGM?=
 =?us-ascii?Q?6zv/hJKiZ84ja6PeZ3t+u9FEx3n6re0XzABsV745ig2qgeEuPPORIu4u+E1z?=
 =?us-ascii?Q?7M+3tRm08vj9ZXvV/IH+dIfyLW6wBBPCSyFDDW+d3Pzbu6E4g+cerol4UemJ?=
 =?us-ascii?Q?tXtjwP58pZW53qKR9m2kFdj96W0XPp7Avo/PllPnAUkZD2F8PaezvDMA6hvP?=
 =?us-ascii?Q?qzjn1duCgZNW/8RWw5StaMI+H2DwZHpXuT6aE46CrwFwwZs8Lfr1/H6QNQKh?=
 =?us-ascii?Q?cMYwguQQZYJJ87NOdA+fBjeuJ/E6a5Mjp8SHFGNOWSC+BKCo0U2QZZ5faAes?=
 =?us-ascii?Q?w+TEg9rNj8A4lsXmfjjtXOS5p2szbT2j9gcWuXhA+XTdgdcQdyNeZz5jIy/3?=
 =?us-ascii?Q?sYY8oZmIsKt7Q8AXEU6g0zyjA3lWELP1H+KEWfSuZsHOhRToDUmkM9OGFe06?=
 =?us-ascii?Q?4KbCVc1wBtdW6u7bxLuYmamFmRt7JIi39AMn96wcG1a72YShbxFMEWDCtj3k?=
 =?us-ascii?Q?QcC5TtP8yR2uE2s4k6nqXCAs3/phm9bHHf1NAB2X2Nu5uDs7c9Wxd0/EhuV4?=
 =?us-ascii?Q?jDK3NYkvOLWZUbuHKjCsbi8y8uTUy7bEfO5P3af2t6SP3cB8Yq/8U1wrgNhm?=
 =?us-ascii?Q?8LyiY5/gxR894ZxX6hbiMSbm1YlvYai0iD12l1BHeni7SgYxrI+TPreESOdV?=
 =?us-ascii?Q?q7sr/uvReHgS0ghqbZ2ArBfxlTkIkYaFOLROfp+jzWlOfXc5b2Y4FSJ9yBgY?=
 =?us-ascii?Q?f/sU47Ix/Wh1uaMrD4ClWrHiEGr9zJU0+Z6PLJLi/MsbyeeS0iZh/OkTIlRM?=
 =?us-ascii?Q?M2GrOOAK38UnhjlaNrwqEHeMbwN739WmE1Y7Rzn+Xrkry+Xi9THufvS1liRZ?=
 =?us-ascii?Q?FtY8yPKjh/5MV9mxyEs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KMZFMtoj4OtmwcTjxNg5K/JzDdMYXEMzb/p5nhVKgeCSxVDw3h1xSOcb801a?=
 =?us-ascii?Q?sPfi1f3k03ib1URDw8lCdDQXqEfZmuMXABKNdgiWv280THdAjyVTrPwFtIex?=
 =?us-ascii?Q?fmlVER+/LbXG4XE2HdfYmxcDuqceWgdV+heX8EQAonU2xh+j9XZYN55zBaCD?=
 =?us-ascii?Q?ENZqJBodrVV2JarnUWpXxpXuhA3HLu9T67ECz+8nrkK/QoYcIk4kKI4sH6Io?=
 =?us-ascii?Q?EvaJpZCQoy/8MNt2HH378aPasoRxcVs6UsW4bArHSNkn5z4ZrbNBtY/65Mqj?=
 =?us-ascii?Q?jx64Zpc9YsPgNyGbkdiSgJl0zO+OxhxPyBLj6BTNEHC61UAWGCfrVuHPhuod?=
 =?us-ascii?Q?q3GQ5KRDW8yidOVJPbCA+YjaIL2eYcRz4NbrV9FdieezXYUWhv7wpD9XW0Zb?=
 =?us-ascii?Q?MKWdyuRBsUmoIz+na5qtxemMP8D4UEdlzR7BnJPk9W1KnqRJzyV1DW+mGJSn?=
 =?us-ascii?Q?14XwmYU3tddqbqAV/qJ3Q5z7wkNRGr9J4jF2x61FQLu9jhLLkjWkDHMQmDhB?=
 =?us-ascii?Q?fO1MMVsxOzwIyyFBC79D4LNV+D+miT4xdflenFz3fznfMdw0yrd0Szmm53KJ?=
 =?us-ascii?Q?gc5jaRSgYdQbPZSITXSmSXzxUacCTGLzNgOsFDI9OP9oVLt3gZBwtN2THbVq?=
 =?us-ascii?Q?uzjGcFzQKswlLFaJX+vpVIDjM7vtCTfNZklfAXPJC3yj9iSAggO2Cs1p3Zwd?=
 =?us-ascii?Q?DYh/Tfqx48jTSFoRVTcddFWZMCMiFXFyVnf3VczXRqbnGQfIsTeY6CIsZilX?=
 =?us-ascii?Q?mYCN26xqqQCD+u5cmkMUuwcpZSItqoA7wR/JYoLjwYhnFAGrqmTuMWPW+bnS?=
 =?us-ascii?Q?HTD6WT3FTTnnrT4zJiSDUJVPRZnM17c8sat1+caW8rmVrbR6QyAVSc/IP/Pe?=
 =?us-ascii?Q?3RbGqAL6SZ7yJpcpHP+Rlgl8tIVBaDLBhEZjh1M+i5h/XHk0zh49YQwcyy9I?=
 =?us-ascii?Q?Ql4aD5k7TyRK7oUDCY0HcDxH+7BzgigE2PgpaAoL+C+U8SZhGW5tT4B0gxH1?=
 =?us-ascii?Q?LPv5wAZ7/wJiLojfUQ+go8dZBj3XdlJfh5dlCbCec2A2xiPC69z3SpX6n/L8?=
 =?us-ascii?Q?O98umPsVyZ8df6uM7Kg/8ElxoDLtRA/L3jBXqoqLkxKd05Ia+pbquzVJ2Q1T?=
 =?us-ascii?Q?+eZz9wUM5QXPtOhs5LNoYdJj+DlavJ2xOobV1z0WBK0GdWmfg8kFqwy4ECLR?=
 =?us-ascii?Q?vEkxGr/G+sitnbQzAMx3QPekZnyWRtw6w6Cuh2tlKq3QSdygo+mu2DiqbsAb?=
 =?us-ascii?Q?nVJZMpFgmZIQqdaP3V3ut4KTuN7gN8qhTbtvKxYigbSabc7R3QklIIkXqZhE?=
 =?us-ascii?Q?wqxSb69oLFME5o0g/B67qiRzCpBa/GXLoLohxbSndzZtzlYPAXZ8B0F4Q7qS?=
 =?us-ascii?Q?lLmV+A/u7wONKVBFIO6LrHM+s+gzlvZxMkjpQMJfLF1YJgaCegy7bkpPnINW?=
 =?us-ascii?Q?ie6ThaIj8Cdpv07w/v9cnKfjpHsQNV9ePy4GGCPjtgNbGYvOWXK73EJ0UMYS?=
 =?us-ascii?Q?lktz74ADc+k0RQC2vSkfqsZtVRDcyZr1nscz7tlqCPeWKPFrh4C0EVC5iI5i?=
 =?us-ascii?Q?PVS8iTMKUimzkif7ScAfQ8RpweO5dArgCzMPYziVa52m9AeILfoORmFswY2k?=
 =?us-ascii?Q?yeG2ahU7hJjj7gY9wseuLEFi5Lqlnnrx35teRrV911bEbsK0cLfz3Ij9KrXp?=
 =?us-ascii?Q?SvFWgqxUxnpCo3owkhAqiCRV1erJJmI2HCSY0E5/auQetqG7RfYRAmnG8GLF?=
 =?us-ascii?Q?kpCn56I7zw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84e81d48-a354-4b21-f6fd-08de5ed42486
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 01:17:17.3082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 07eX6bTVU96JYIH+FLrKcDj/OP6XTFzfDAHvFGNsOpMKitie13xHPcFv7UN1HhYg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6745

On Thu, Jan 29, 2026 at 11:33:06AM +1100, Alexey Kardashevskiy wrote:
> > > > What happens if you don't have a VIOMMU, have a single translation
> > > > stage and only use the S1 (AMDv2) page table in the hypervisor? Then
> > > > does the HW fix it? Or does it only fix it with two stages enabled?
> > > 
> > > The HW translates a DMA handle to a host pfn, and then RMP checks if
> > > that [pfn..pfn+size] is assigned to the correct ASID and the page
> > > size matches and the gfn matches.
> > > 
> > > RMP does not check S1 translations inside the guest, only S2. RMP is
> > > not fixing page sizes or anything, it says yes/no to the access.
> > 
> > Your explanation doesn't make alot of sense.
> > 
> > If we have a vIOMMU and the guest has a 4K IOPTE in S1 then it goes
> > 
> >   S1[4k] -> S2[2M] -- [4k] --> RMP[2M] ==> OK 4k IOTLB entry
> 
> Should be 2MB IOTLB.

That would be a catastrophic HW bug to take the VM's 4k IOPTE and
expand it to a 2M IOTLB entry.

> > While if we have no vIOMMU, the same effective scenario:
> > 
> >   S2[4k] ------- [4k] -------> RMP[2M] ==> FAIL
> 
> The host should have made sure S2 and RMP use the same page size.

The HW could have installed a 4K IOTLB like it does above.

It is obviously possible because the CPU TLB is doing this, the S1
case is doing it...

> > Maybe your answer is the entity that is building the RMP also has to
> > build a matching S2 IOTLB as one unit and
> 
> Yes, the host OS updates both RMP and S2, and the host uses the same
> page size. Because when the guest accepts memory/MMIO ("validates"
> in AMD words, it prevents the host from changing it quietly), it
> accepts a page of a specific size so then the guest can be sure that
> that S2 mapping won't be remapped by the (untrusted) host.

I don't mean in such broad terms a "the host", I mean a specific
kernel unit, probably KVM.

> > we somehow just plumb the
> > page table pointer and invalidations into the IOMMU driver.
> > 
> > Such a messy design.
> 
> Not sure about that, I dislike other designs more. At least with
> this one S2 tables (IOMMU, NPT) stay the same vs having firmwares
> dealing with them with KVM having to manage some of it. I also
> suspect I am explaining RMP rather poorly (which is a control
> mechanism, not for translation). May be Vasant could help :) Thanks,

Maybe, but if the HW is really so dumb that it has to be perfectly in
sync with special engines to change them, I don't see you have much
option other than make KVM maintain both tables (where the CPU and IO
S2 have identical content and exactly match the RMP) and somehow pick
up the IO S2 from KVM into the iommu DTE.

But I bet the KVM guys will tell you this is not possible because they
have always said it is not possible for the IOMMU to share the KVM S2.

Maybe they are relenting on that because ARM CCA works that way, IDK.

Or give up on 2M RMP support and Linux only supports 4K until the HW
is improved.

Or maybe the IOMMU can own the RMP, but that sounds pretty much
nonsensical to me.

It is just a horrible HW design for the software stack we have today.

Jason
