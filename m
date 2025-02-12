Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2077.outbound.protection.outlook.com [40.107.223.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0114F20B7F4;
	Wed, 12 Feb 2025 12:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739364614; cv=fail; b=msNAiJPz7FO0gAxNqgG2+y+a1JvQC2m9SR61BlyJjur6mOsMCVsfbFjI00P2u1OMyxf6IK98t8V2bYJOQEh5SJt4MCj/76ZZ8A2CD9EkxxIEtoZrIUN0tjAJHHqVqJBraMr8g6N1E/Xvyr7vM45xrwWeVJVz7aZuS0XejvZ0qlk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739364614; c=relaxed/simple;
	bh=5Pr/7ZMXm7SX6SJT929R3KiXCQXvSMBfEcsZ2O6QDX8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Prn0Y6+NQsHhMfHnhD4Gfc9RPpXShpyf9dENQ0YoLYKF22XlsVe5mNImC61iJ8dfUu3n0VX3Vrb2ll1HFsMm8Zk9GlOJNFXE4LTJApzO4XIpyIvzYHcuLMlmgJm7Qqsg/h5uyXdkxgaC+FInw39dBw5wvNp+xRnId1GPslxkRVc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jTIXUp/1; arc=fail smtp.client-ip=40.107.223.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jTIXUp/1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oa0OV1F1Go3Z62/vUvu55TPFKyxLRWIJad+SsLb3jBXzY+Mt5S1RRWWncoCFh/d4QDJI7kjJ51dlBmXGcHTo8flA8cO8jYqx3fDI59G2zOiVJaEhKbZzxeDVJX+fP9zU8hRTMH5d27lew0To8NA7TaEdlrizj5FsW5XvY2nXBCvNe26dni9CAfouD2ZbsPbKzYby2zgSBAFvF6kSzXvCswgizTHQzDqSwyO8DwZd5RkyCcw+rZH600r/jiH+00cfD0jAxYgAz85gAr29gRtgdVEu9jtH3UROC9OVQCLis9LLm7ZixilW05KG8MLZOXGYFvpLJ4G41C6fr6/eZ/qU7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Pr/7ZMXm7SX6SJT929R3KiXCQXvSMBfEcsZ2O6QDX8=;
 b=sRjR+SiqD9CQzOGWTyV4bl+JpmHDv1mnvbs+AkiR8W0XKn9RAyqLTMZPtHXVDBVwgeH0S4n8CQromZ9dYPvq51r/ZCzQFurRLvObkvlz5B7ZlZTu4FcJc8sg/wYPd4AwY/12DDMsc4jwLs2SnbKTuPW1PXc7VDixXeXIFtcUQtqC1o8KYFVSsuHAB9Ap9Yd/LjneMGorpgAzoLLbaGxLUNfDtQtmUvWpriZEconWT/W8qgrBUisUWNXW3U+9S+QPo4t6nC+9AjmU6H05ztOSABBb7fPJajWStUDBJ8eQhdwic9dbi3kDeORXotM/u52JFDlSrFM9xSmTQukim5ODSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Pr/7ZMXm7SX6SJT929R3KiXCQXvSMBfEcsZ2O6QDX8=;
 b=jTIXUp/1tHjwnKG+wTlZjIJ42OzWED3G1BkTjF6EqbGOYPDEbBIvmKQTmft1JhNm6bfTRxPVvy050EG5GbkMs94Vg1qST+ICs6vuPtDN0FtRmImwzsNxtEpbdsy8bC6NJK7uQ1kSbl+F9pA+82M4kaKGn48adL1xQ8AvpSZ/9oeDanhaDoTOyIsOvtb4XxhHbD4pfZNPakxQ23shH7wf6V7b1pBEk/cAgtyPWXeWjF6AqDPQSpx34JwHdi/Huz4WbGvScmXEiSQjojjV2+rTfF+o8ckWpSsYcKkG7ynZkhRsOHuIrsWANiJkHdj/u4j1pqBj+pCO+A8FQZ0vU5WF4A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW6PR12MB8663.namprd12.prod.outlook.com (2603:10b6:303:240::9)
 by IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.13; Wed, 12 Feb
 2025 12:50:09 +0000
Received: from MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f]) by MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f%2]) with mapi id 15.20.8422.015; Wed, 12 Feb 2025
 12:50:09 +0000
Date: Wed, 12 Feb 2025 08:50:07 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jacob Pan <jacob.pan@linux.microsoft.com>
Cc: iommu@lists.linux.dev, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>, patches@lists.linux.dev
Subject: Re: [PATCH 0/5] Convert virtio-iommu to domain_alloc_paging()
Message-ID: <20250212125007.GP3754072@nvidia.com>
References: <0-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
 <20250211164151.723cfce0@DESKTOP-0403QTC.>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250211164151.723cfce0@DESKTOP-0403QTC.>
X-ClientProxiedBy: BN9PR03CA0371.namprd03.prod.outlook.com
 (2603:10b6:408:f7::16) To MW6PR12MB8663.namprd12.prod.outlook.com
 (2603:10b6:303:240::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB8663:EE_|IA1PR12MB6353:EE_
X-MS-Office365-Filtering-Correlation-Id: 00c597c0-1af8-46ee-8398-08dd4b63c847
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?C9Y7pkJKBdEPrrJXybCKGHMhH8savHLoaUZBbj8Mw2oUi9sevoFeQQ2Df8lE?=
 =?us-ascii?Q?0yxnCmNgjD7jJpxn/ej7XCz/BIVQQ2brRglOWa+EpNhohUV0o/u7r60gfYvd?=
 =?us-ascii?Q?PD3N46mawIrqtqA34BJzXc08QN8kC6mn4xeQysHCqrR1AV5gqq/dTKrExova?=
 =?us-ascii?Q?E+Gj6Kz5ZciCqFG0iPZ86TmjBmTkZxV7ukxRgZrlYbRN+CAeJS4SnX1egmVr?=
 =?us-ascii?Q?JVGDeGTLWl3EbP/hQOlVOr9FZ25yh2kIet8j+vXkezUTWABoiEtgJ9hW3FFW?=
 =?us-ascii?Q?c6lknwF2EXYIzoV3oMY/TRvE4qbFcl8kFH9RmXiPS6bQAJCaH9ukw+RPtIIS?=
 =?us-ascii?Q?9k3lDvcljcLQ5KXW/Mk0bV2433aJuG73K9HqJcvzh3jyuuNnDtKeMbukG271?=
 =?us-ascii?Q?xbmCyUUxVPw/S9JT4tbdxkgfXAY6eHMkQt+hoBg7GM/uQA342l4rRtMGGSOz?=
 =?us-ascii?Q?oxIBRW7BhT3EB6OBUFvu5ZnPXIxS31AmOjL5xRmHdwaf9BhAfzxHi4RIhuCh?=
 =?us-ascii?Q?sKRo8bN0HCk3a9YGlnMI2KUTatdycXPVjo779AsRGg0mlnPDDh85YqcJ/bNH?=
 =?us-ascii?Q?4JrKNv6BNzTZeUfLncfo4Qt1jI6Yy9xUWy1Bw9/ZgqHJuUf2/5IPuOwSpuFi?=
 =?us-ascii?Q?w6Qd1iCmhSypQSvJLkQvKvnROmUbVBzIbmVMZrjtpGdRXAukAVBqHX+IhnWz?=
 =?us-ascii?Q?uxd2tUdpeOjdFJTTBIeKv/BKD8BrcPMFLDgBYYtWHI8BfOCDOdNNJgY+LfMV?=
 =?us-ascii?Q?dfCF5yvoHNcgZR5SuONm1hmp8gsddNjfRDiCFbDbXukBDZ+/m0Lu/k13ev7U?=
 =?us-ascii?Q?CIlOwSEkURxf8a8cOiExNR6dHE5zckUJ8xanCtHn79FatO9OE2U3cMIFXmw3?=
 =?us-ascii?Q?j2b69Weuvu1HO3poWMrBMVix7Z7OpFKFbkZD9mbdM5CeAOF6tXHn17LdQAaT?=
 =?us-ascii?Q?vXwRgSTZ2Wax7Rni9YNEkb1rCxwq/WbnmwLQC7W/avO/l3em46oDgyU26HO0?=
 =?us-ascii?Q?659w0okR1cjVavJUf918Zo92+cvzEZDOqDmbVWY0NVE+lpdaggCH1tSHCLs+?=
 =?us-ascii?Q?FKXdSNi+i/ab/ngvpEv2op8qkK+gbZp5v4w1mwkwQC0Yxo55PshQZx1ZqQ12?=
 =?us-ascii?Q?muxSORbl5oGJxJsX+LjBM9ARRsnuCEF64qWNuWLs+mdoz3B7v+fyZAIEi4Jt?=
 =?us-ascii?Q?pXbEwXUOLpNTSfImhyPsRnfwjSjHPJZ8W5SHJGNWcAjC5igIseWgOw/cbLgA?=
 =?us-ascii?Q?EhlHnyJTj6yCBVBV35YriX/20J+LnvtCGD30XAb1Zdl0iwJ7sTz8f4IBH79L?=
 =?us-ascii?Q?LNEEnEO6fq5ghuXWgN9LItT3/nu1hNr+mT19/5IvHJY2HjuLXUq5CvktYd0k?=
 =?us-ascii?Q?Pd4sNBs5Ew8KaXIO9I1idiA0LcDc?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB8663.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?V8dY+lDCLwVLzKL5wj9Jr/65wYIfvjG6aYPbIsk9gzmEVO8LYtNMSHx4be2p?=
 =?us-ascii?Q?2cj5GrI7ANgmY1NByWF/RmBC5QhX0EZu+pWDhi2SQZly+K05EH5hlTz0CQOk?=
 =?us-ascii?Q?ejTqSFjR5Tcxu09VLrPM453UrlnlX4AzbnalKz7vHaWcnZ3oHXOxM7KB4uLw?=
 =?us-ascii?Q?QiDIOUdAU93JRIB1chSKMR3NJyfssKpFga1nvMpXH5wwzrDuLG9vBdThSAv4?=
 =?us-ascii?Q?TtyaPI47RyCdaGzF5lQnq2I/XAOFPbXknRwk37OJi22yrRlubYlRc77JLlV2?=
 =?us-ascii?Q?hoB+JYouc8g+nvGa5kJ0dk4DunIZ8E7Uuo48kSq84a8cm/8737lUwUvKdtwy?=
 =?us-ascii?Q?Tt8feTz5AR6x0W9txDR660MFfdDyOmX9FYyR1vAHQng/DEBLQ6blCJKL7VvH?=
 =?us-ascii?Q?ILetCWSZbBLFzOsZsD78aBLIpBa08Yzo6sq/XWltefL1nhk19EOVKQ779BWF?=
 =?us-ascii?Q?ByhSVkQxMvy8RdNH6oPKMBn+6kmm8JFcH/CUAOHoO+nuXP8INJ6PW0B93Jks?=
 =?us-ascii?Q?YCvQINlh2emit2zsYvwDxt83meSXwXAwtTrqSVuUnOGMWNoj5m6lKbLPB0kM?=
 =?us-ascii?Q?d3rtdOvB3i/mZBCfn7M+Y0aisBavGNpx+M7j3jruZQd7vYTKmTn3wrBrL8J+?=
 =?us-ascii?Q?pWeRgNzcTM0iOoGwop2g85oav7Ez6S2/YBv6C6JaEiM4JjG4uK5G/81eCTB5?=
 =?us-ascii?Q?tIkQT0ETll1TC1KcXFVN0bzH+Vc2YmJYYS6UFkv+zBGYAA893SfcQvyQ7FXi?=
 =?us-ascii?Q?ecUMSiccy1Ivy6KfXMYfAPGhM2N6ayNha7IQtPWA4Cc/wEJY9v+1n/Xlg7KD?=
 =?us-ascii?Q?UcAB/37MP0npPR4qLM94MMnLpecLBwT5CP79vrsV3OAhiEOxd6D5g+zvTbAH?=
 =?us-ascii?Q?APEUANfa5tteTm6EOj1mljsMjFMlgwOzgiJ+6gdxY9/OwRKXtp52JCK20HBs?=
 =?us-ascii?Q?Fug62SH6rK8bsew0WDg6iNv6qbR8K+SiNiypkqMWFZ+acI0HTId1rKprE9E2?=
 =?us-ascii?Q?We1SPOzjZqj4GgD/jvUVVHxQeXbRa0oRsU1/F1FJpkL+LlqDbsQLTbu0449s?=
 =?us-ascii?Q?k5dgTyaRfmIuWXvJnX9eAdHZUNi/YOhQOtaV5ehVsHF5gs16CYLY1Rdwef0p?=
 =?us-ascii?Q?9iYgQEFoV5opaaXOaS6zKJeJLSSK2uzZPGvWZNxHHnMwGIEDzo1I49bm7dAY?=
 =?us-ascii?Q?uoLapfnV/chG3sJ52bFsFziRpRLB7Pjj49L24zAuhB3CnhmRUw1bHU1YMBTk?=
 =?us-ascii?Q?zz2L+KmqmW1SUT624YhDyF0j7WfwcENc9zk8PP5CZ7bfHcEipM23kCIKmVba?=
 =?us-ascii?Q?eLVB5vNX2N+GsR/HDorrSWy9nb3TowMRP+JPHQzdIdKgWYsdR3UGvN0Uxqlu?=
 =?us-ascii?Q?bRyEsdORlrqmj4ds7Qzaj0U9V9wa8pUIbfK5kBIX8tLw+zQs2/ItXTXP6WKz?=
 =?us-ascii?Q?PaKdk4oTM89jhN7bVnD6fAH9BXiTKvAZVDSEc+uuuJrf+3HMIp1BOe60SLFA?=
 =?us-ascii?Q?adFemwKnOgX+H0ufouZpP8tGw033NUOZor2Vl3Bo7Q53GrOIk6aHYDAvZFIK?=
 =?us-ascii?Q?atbEidIiMsMJ9zk5rfg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00c597c0-1af8-46ee-8398-08dd4b63c847
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB8663.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2025 12:50:09.2357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ziNJpQJqDT29HVEd8pWclDYbMeFMz5dric+IuEtBJFi9v9IgX7Vz3qfWypGXd5S9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6353

On Tue, Feb 11, 2025 at 04:41:51PM -0800, Jacob Pan wrote:

> I see the same on arm64 with v9.0, assigned an ixgbe nic via VFIO.

Huh, I figured it worked on ARM..

There is no requirement that an iommu driver implement identity, this
is all an optimization. If it doesn't work in alot of cases can we
just remove it? It would simplfy a lot..

Jason
