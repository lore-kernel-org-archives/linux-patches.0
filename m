Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061.outbound.protection.outlook.com [40.107.92.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128BDDDAD;
	Wed, 16 Jul 2025 12:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752670179; cv=fail; b=cNgg3+eBAsbFUO817wZqmxCzR2y4r28x9rurM0Rl+p9rNkM70vN/1S4Z8SN0xX4l95eywDQpuh/i/CCrytmInzDAeLAv81QayBdjrJHrcAHrhicvvpd6Ou+LytkZPFWEhSZdB+oYMpgriUOz/53w36OYrGuQMksluXTPxUKHO8A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752670179; c=relaxed/simple;
	bh=TRGyVTpn+vwQGtTcFK4lPiOrGCLw0LoH6U41UqE/qxc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HbpGCqImvTKJo6n6EF+V4+qHU0RSj3adqnoGqTZD++74FE1aDDZQMoci0iVec1AaIKy1VP1tQfiYRxiZ6GulNuR4yBvZkijfupEti20REGZEtYn50FBwWqxjwlQBa0h0s3WhivGW01RMfwd38mf0v7LsBX2KQLOgyUjKF/WjM80=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NsDPvCHP; arc=fail smtp.client-ip=40.107.92.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NsDPvCHP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WqbmhTJvNdPpYe/hGgrMR7u+fchKtMsZ6R4GdlKEii/9n+vEDfPCFuLudtEFKakd4zJyyjLjNUG14ULOoM63Ak6dI4/8B9O4oPGi9FJ5Y/GGYUb8Om0vizzFs0ftfdrbtWVtoXNX7NaV1C6aL6fH39LNE5yjV8hTRzr0r7aiRqBcByhm007aEqm29yVCnR8ZGvzf4zuXiJHo39RSnfm2HwPWA0KMpMGAsARxcOGWjbq5dqMehMEmipfHDaKIKiZlX/EwenBR/vAerAx0vhP7qudbc/Lm3nXjPksPt0g1XkJBIrlyQxKT+m5Au8scj3E7E4xSO7pZT/fMZ0SDIaH4RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lCLEi1vjPSOV7SHF4G0uZXo0hJ5ySuzdCxIGlNxDtKs=;
 b=CQFwPgJoks9YURNTBvzonBJnzKp2j3AKm8mVxHlzIFdsRYpplw1ghThl4UTO1tUHY2TphbDuDHDbx4AKUuS2prqijqRrD2l0FGk+skWXSCZivR5kZKMYQfYnzt//Dih0ZQ4t7TQXkNckk0Aqv7vugclDJ1JIboBWwWtizJEN+2aGiWZU5E43/r/ChcS084Mqb3Jgp5UUAiEJMEvOAfZfsAaHWrThn5hHE1FUjOI6k0iaAfquLbeXuCOtjzopOIJxcrYS5Q43REJ0TIJ8Bq9IXhuVX9HBtS5lc9dfZFyj4UDfo2QwKp0+6aPCczqrJt2sJ6M/ubmdADTkYccCOS9WCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lCLEi1vjPSOV7SHF4G0uZXo0hJ5ySuzdCxIGlNxDtKs=;
 b=NsDPvCHP4uK+Rwl8+DmJJD+AMISzxJnQpR44OH5UEYaVuTXCm9uCkVRw8ddQ8tsiXuTTGDdarwFRnZN6kFh1HgY8nc5g//qdo281Q24KKEnbRkXSXxFMtIjj+lWR4uZXlXw1ilERwZTakv43niG6XTtsXighhD2e1xrDATt4U2ea+1FxB8uNQVnTqUCcyFjKAMjSdBL7Yv88XHVf5e5mUMuRfnSBXIqyvx/dwZc+dLgCmLgVRQr3lO3ZcK28AwwWxU0D69xOyARc2y9R4JmWDmpX1OMq+7GtEuiur8CEvJbOGU+NZvqkscTFc0fmz75yrToFD4nvh0WkH5grFRqQyQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA0PR12MB8208.namprd12.prod.outlook.com (2603:10b6:208:409::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.25; Wed, 16 Jul
 2025 12:49:31 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.033; Wed, 16 Jul 2025
 12:49:31 +0000
Date: Wed, 16 Jul 2025 09:49:29 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Vasant Hegde <vasant.hegde@amd.com>, Will Deacon <will@kernel.org>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <jroedel@suse.de>,
	Jerry Snitselaar <jsnitsel@redhat.com>, patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH v2] iommu/amd: Fix geometry.aperture_end for V2 tables
Message-ID: <20250716124929.GA2138968@nvidia.com>
References: <0-v2-0615cc99b88a+1ce-amdv2_geo_jgg@nvidia.com>
 <16da73bf-647d-4373-bc07-343bfc44da57@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16da73bf-647d-4373-bc07-343bfc44da57@amd.com>
X-ClientProxiedBy: BLAPR05CA0002.namprd05.prod.outlook.com
 (2603:10b6:208:36e::12) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA0PR12MB8208:EE_
X-MS-Office365-Filtering-Correlation-Id: 40435631-a6c5-4bfc-b75d-08ddc467355d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?df+V+aMFovXcTbQzv3eRGswPcjAOK9npOiYgvUIcoNjPWAu9Q/YK9KXL1u2l?=
 =?us-ascii?Q?Og34kgpRlRTQxJrdH+Ka2fKyYHXxfEpAHDlJI8VXFu7Mh6lXXlH+E1iOW53g?=
 =?us-ascii?Q?+LQWgv2/spikx+4LnqyPWrNDMu+WpPLUtNqC/N3bLmk7ArppAQ2dgN8Qtc4A?=
 =?us-ascii?Q?Bh0XaNaoKOuuI784jgDVOWjUevEKX5XT343Fz10qnHLpjxZIlwWv6nq5hXS+?=
 =?us-ascii?Q?gRfR7/9fshpU4WFsz9/pGp3cX92IsM+/77UvdchCXqPX8YuqatRtCzetlBub?=
 =?us-ascii?Q?P6VahWsS9sES6Jodpq1Si/M1mnITgbnHAbMYS7CHgrI/d8CkOJLPVajYA5dm?=
 =?us-ascii?Q?BcwDtSMnZr7Z/56BZsuXmt9jZjJYcpG8ItKCIMTVYo/0ljmOlNzKIS1TdqwB?=
 =?us-ascii?Q?4czW4YlQhI6QIdbjIJYE8G9q1jqRDg3F1HAfdSKiKkcEyTD/baQCLWNYl8cb?=
 =?us-ascii?Q?pP7I9hA1Z0dNUGjtGi8WmkQmPXzNe3v1UCOXIwmdmHcWcYhhBLm9kYNNFEFw?=
 =?us-ascii?Q?CBcKT+HXgk34HLNtToqDPce9Azh8zchc9DLYabBzD2rNc293l4veG3m9tccR?=
 =?us-ascii?Q?ZnNNbSFtolNX+k0UeFHjA5JnHgyVPDMnlGBdlBG0BojieOh9uyQ3ecGqnSNR?=
 =?us-ascii?Q?AKnbEZLRwATSB7+CLmPWp04yA8GRd7UFoDXb8CsDse3xytjFovQ1U/eL+0B3?=
 =?us-ascii?Q?HU+7HiwMSD6lOpOA13Rzkc48I4+tN1YSNzoDL27Vhm41G2pY4vlnmmfXxgaI?=
 =?us-ascii?Q?2jcyeXDkusgcczgCkl4maCALoZeU//pRRnAt9bmqi7pgk8wU2Ih7OH4vYBIb?=
 =?us-ascii?Q?YcSrlWKhR1W7U1wqK1NNjDuxm415wecPvj8XpyuAVxQ7LUmyPyXH75om/2gz?=
 =?us-ascii?Q?4tUYJ5DbgnfShqvEtYKAUfmCxde+8CjRWGjI+d/2Go2haeSPJ43B3ZrmmRr+?=
 =?us-ascii?Q?yCgpOsVC4gZWsaFSO1a1V42YMWli7IXR/1uWIpq9FRHNH2s70hkX1vko4JEC?=
 =?us-ascii?Q?HuwJcQGH7k3+MwC08lgOYxMn0Tum5t5Bn93Y1KIDiDP4viLyYnPk0ZI2aNsP?=
 =?us-ascii?Q?+ewsP4oKChY9SD0IXK9PWmhAg1iPNYRxAl+cn5sVK2F9MLQ9DwHs1/UTjb06?=
 =?us-ascii?Q?laRIeeXr+ZJadSFkH9sOTOoDg6XzuZUTrSUuDv1sxkStOo/mBaXtmaUVV3Y5?=
 =?us-ascii?Q?29sgKrh0FsDpuNFoX4ltS3tQuWq1jAnyccLIPSV1mxo9fPRV74BOyBUMjGd8?=
 =?us-ascii?Q?J1NkDbvhv3bLQcFWhd503abb2JKSYpIErsnJJAqfkL3FBHvog0EXmpDo2X6M?=
 =?us-ascii?Q?B0Ly0uwpNbLE0CaUHFJ5PDhowjTyHEe5AD8lJBbYSkv8FHadLm9Fnc0CCTsY?=
 =?us-ascii?Q?YdsiOuVrNTnevvhhDys0GZNh6q3EV6m3bACaSxnPXKYdLuw7rwl3YsNBJ8Ul?=
 =?us-ascii?Q?BTURqqH/rDo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?laHHKdYs2c+Cv/GdkxWQtgQEPKoEtXZ25wBUQoy+v5RgYlj8iJG6mrersd8+?=
 =?us-ascii?Q?yI8xCGdwswVS/j57+MBWFypiKFVII1piGWoQaaXtZK2IkKRf9wwS1soAr1ht?=
 =?us-ascii?Q?l/DKekexhmWjwkb6UYl9sSi6i+E5hHKV6AkzX+wsxE8DlSyEsT1wPQY+M5aP?=
 =?us-ascii?Q?11+8MvzOFfIRpjq4MAhyqCaT/5OadDYtLHUuJYVXhQUHZXU05nznzKlMIKj4?=
 =?us-ascii?Q?prB/A1EC4rXONMdRQntVFfm8wh6/D5T3hzsUaB3syttFlT4sPiEXYyNZaqX/?=
 =?us-ascii?Q?u6uUbL7uB1CHPKgFOaxeZgiMdpPKkpqEQxRGMECLag9Qf2Mt5HOFDFbOWbEM?=
 =?us-ascii?Q?OM2T26/OxCc8LW0NSFtEaAe9PJpd7lQoY5IhwiB40Bl90mZ/n1onZ1E2nkgh?=
 =?us-ascii?Q?WnrjzSac7qJZfP1E77o0wMriVoZCz94D6OA9qT2A2Rcb2zBIuMHyNJiVFN9i?=
 =?us-ascii?Q?mUVj+KHXRxREvnNkWkzLse5dZXmdwJHKESRGWiifSCAq4KJYxHAL5+vUcoTP?=
 =?us-ascii?Q?voNuDDR8VnLRtqei8NJLy38SKO3jvpV3ILkQgV1hO+kVhWjUOXpURAIIN1jR?=
 =?us-ascii?Q?E4wOZkHH98se206p27oDEHuN81YTLZh3ZCQKCHWh86h9AHX2u7zFH+srDNSr?=
 =?us-ascii?Q?8amV7nrEnEXEsOUiH4jMjTdvjzygZ2gn6ZT5v8C3RK5DhccawgZOmxgkWosN?=
 =?us-ascii?Q?hvtC0LmNHC57U9diMmfZfzYXbY21nw6KXIyCSUxYCX9GugphSeX+0vJRWDQm?=
 =?us-ascii?Q?G7Q8ctAPdsBcA4HnzvUaex46yNUgW0Z9Qc5wPAREHZ9zzlw4KoKkyZ3LQmQP?=
 =?us-ascii?Q?wdW94N2NCFBx1zuaiUdp7uHC9qbQy0t6D5DVy3A77Q1c60vunUzjVAvPuEXE?=
 =?us-ascii?Q?GeB5L+PCO/TGxBdagEKLxCOoIHYSRsKzhCx5JqPU1z8abIP0X4Z2vIew3+kp?=
 =?us-ascii?Q?n12lF0lAdgfF48vMJmPBGiLA/0INzNjqINM9tQUDvUpeFAhsnpX68GaiAmjj?=
 =?us-ascii?Q?jCS0SYdsbj2GsO2psCh+Eoo2Vv9oNpzgF0/Rz9wDLmK774N/wNmV+qZgu3Cs?=
 =?us-ascii?Q?qGbIgtfAagpfc5cvVrjwrIqb9Ca8Y0IBy2DT7drAG/2DFlGWK5ursVXsiIwA?=
 =?us-ascii?Q?kKK3/653YSYgtxfdl4DsLEizY2ZhHdzZM2BJnOAkO6GtGjvgv0Rg2Y1yfcR1?=
 =?us-ascii?Q?ISFAO31x/KKuFeQuPluF6Np11M8Lg3r6wLU+r6SeI5ZfxHsgmmNWijMqWBkG?=
 =?us-ascii?Q?IXKdaqdPYxVelwFK3pKH6+TiM8FNPnaX/jBp4D1w0MQGvrN5xPvpPdNIEcBd?=
 =?us-ascii?Q?mAzUwcyZPfXyw2CRlNy8+0W0eFffif88veD25uLRNPj5Km/SgTedgW1YjwHq?=
 =?us-ascii?Q?0Z0Dl5Ii10IKOK7BiTFGX9M47Nb0NJSylf+Vo/v/3IeTt9Jt1OySFwaPepsK?=
 =?us-ascii?Q?91FKFWmod0wrhRLFrFspo7gwNkuYuZoMtgrtsD4XogroNfKqDGK+5oZrlOdZ?=
 =?us-ascii?Q?+HIpSwo8GTSFTmbhIxivjVPq0610JDQEkRry+EOsbSjHOL45XjgX4Nj06Q6v?=
 =?us-ascii?Q?FufLKcdGX8BTWjzCqaHvyxjG/ZpIu+uODzKrmH/3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40435631-a6c5-4bfc-b75d-08ddc467355d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 12:49:31.4818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ewGIKGE4haeqzD6Xf5aasikEWlr9U50Qydkt4bKYmL3Eih88Nlzcew+3/mTsRnl1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8208

On Thu, Jun 12, 2025 at 10:54:00AM +0530, Vasant Hegde wrote:
> > Adjust dma_max_address() to remove the top VA bit. It now returns:
> > 
> > 5 Level:
> >   Before 0x1ffffffffffffff
> >   After  0x0ffffffffffffff
> > 4 Level:
> >   Before 0xffffffffffff
> >   After  0x7fffffffffff
> > 
> > Fixes: 11c439a19466 ("iommu/amd/pgtbl_v2: Fix domain max address")
> > Link: https://lore.kernel.org/all/8858d4d6-d360-4ef0-935c-bfd13ea54f42@amd.com/
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>

Will, can you pick this up please? It seems to have been overlooked

Jason
