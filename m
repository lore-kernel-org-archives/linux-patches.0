Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2088.outbound.protection.outlook.com [40.107.237.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9714115B113
	for <patches@lists.linux.dev>; Mon, 29 Jul 2024 17:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722272669; cv=fail; b=bc3Kpc7B8Oa7rpDQ6GweN6/rtI7jW7kGU5xpWH3cWo58fxLV46GIhtcbCR6bzOhpWenWeBMpGcdsrZ61HcaWJbtkhHezbCVvbzD0uOtmmauRs6xslBc6nIZQiNM455kjd8ml0SYkY4+Svu9ZBmozwakU59VtoeZ6pqcjWVF/oKQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722272669; c=relaxed/simple;
	bh=zjQxJfw9WPgud9dKRh91xUuDjfg1IRwo3hQpoW5orl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=L5IDY7lYYUfn6KeiBM374ozoPS1NvBDSwjwphdmTMX01Ze5mlHqrMAtp6SK/updRrBGWOqtpFuwjStOKo9A7gji0hfQUnhSzA708ZyJmLFeC3NSy8q3mqi6TCs3vQBg4hm2BSn7LgAqKLd+x42ZZDqIkqZ78M1uZacVuhA4V06U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MTFF9UQ5; arc=fail smtp.client-ip=40.107.237.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MTFF9UQ5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XipY4io08GAualJUfuHmdtgCwBMNKpLlyuLMigVsQ16bmN9Mfhe/rtCJkf4KjRHCBPHEJX84ridUyCq0p+taEKdStQRsYIZ7f/DlsSccsfb65md0LuMF+HCvhBXpb7esJBuOBLcGiSMfo/3YE4QmwgB/KuYdONDe1wshvrBKyI5ZRnBUHrvOlpS9WvX/8VV8oEhMB89whZ8OINgUzTIjYrR1DJ/Dt8lXOJBXSijep1CGh5SBR2O0xvJmqH+QR9P5yF0x9VjbspVeSwT6cbvuY0G6p2bCd6tlV75Oo9ivG5WfC48ZvEZrYqGdOm3VWDfajh7a2AWXKKEtuZdW9DgUdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0pTsgAj+zWY5iMvxpUR5DVQhxpI0R3WGx3UaC0ALLZ8=;
 b=XDMrYGW3uLONGQIvLp1TTuP9CYmYpvp3kVhC5SNx0l3Bb8FJBDIc1TgzTuesVl6/omXOuxqLdEYZ6ZyQbyN5b2iJiYC9z3QIWj/vRQOEPxUuOOHBvGPfAQ1TvLoFRXHACVQdpZ519oLYdBaSIdhEPKxQhl47DHiIi5ZTQOpl+NMbNkesIeuVn0FbU/EcOaW68G+4hu670Kz2o7Bynneg83u80JyTx+f0ENgXHoTGMYq5tw48g2w6sPp1dnwWCeRjI/BnizjCaGSWN3eCsTw+5dWjImsrW1m9/A5sVUNB1zAldlCcebDkfz8oQJpnS7zeoT1VL+2XiRfnSFnzlwQJDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0pTsgAj+zWY5iMvxpUR5DVQhxpI0R3WGx3UaC0ALLZ8=;
 b=MTFF9UQ5MhUNiUdQoMsBhaB6es1wn3N7WEbKVm4f6YHX8rnMiAGM70Xu4vrEoWzvKHU9J5burAp0qylvw0F0iOHX/uK18gIEALdH6IfsdlFbnftzdEWSfZHI2Yxvijs1ea4hqnMe0McsBEoi4oHKgsFcEuKiIfur9wgMV6sAWisk7qZzo4/tviVmQxS9yVo8R1/f9P8oDIgogX4n6+7RwYir0gqGbfJUiHyvU6y3q5UbRLRs+3aQ3KE/h2hDp9qrbJrPFutGySmDQcV4Afqn0SzvEwTTRTAg+/LiuAIvUEWiRHAUsAWfNiPtnOs2AAE+CMHVHBA0gvRM2EoyneiqvA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CH2PR12MB4326.namprd12.prod.outlook.com (2603:10b6:610:af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.28; Mon, 29 Jul
 2024 17:04:23 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7807.026; Mon, 29 Jul 2024
 17:04:23 +0000
Date: Mon, 29 Jul 2024 13:35:13 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Itay Avraham <itayavr@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>, Leon Romanovsky <leon@kernel.org>,
	linux-doc@vger.kernel.org, linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Aron Silverton <aron.silverton@oracle.com>,
	Dan Williams <dan.j.williams@intel.com>,
	David Ahern <dsahern@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, Jiri Pirko <jiri@nvidia.com>,
	Leonid Bloch <lbloch@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>, linux-cxl@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v2 3/8] fwctl: FWCTL_INFO to return basic information
 about the device
Message-ID: <20240729163513.GD3625856@nvidia.com>
References: <0-v2-940e479ceba9+3821-fwctl_jgg@nvidia.com>
 <3-v2-940e479ceba9+3821-fwctl_jgg@nvidia.com>
 <20240726161503.00001c85@Huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240726161503.00001c85@Huawei.com>
X-ClientProxiedBy: MN2PR11CA0029.namprd11.prod.outlook.com
 (2603:10b6:208:23b::34) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CH2PR12MB4326:EE_
X-MS-Office365-Filtering-Correlation-Id: a84f3fba-9d36-4619-7a35-08dcaff07ed3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tGMS9Oz7U1kc2fIrkP7Lfzk9bI1wNm+TxJH+4u1GT0kd9GGcpuH9EeWhoGGr?=
 =?us-ascii?Q?xe4S0uZFgdFrqhpz9NYojask5FXkkh/DJe//TEJmIOF5Q3bUDc4/8JlK6HoO?=
 =?us-ascii?Q?vAx7gW79PLojsL6K/q0J/smNdqYssXL08Ovpb+qHbATFWjumoX3rhgMbbaC4?=
 =?us-ascii?Q?9lYw5vitmDF5pRUxLnaTPXWJNvBFP2SczZZv42+U+PvDS4luRN6itilcQrNO?=
 =?us-ascii?Q?JK7bikvne5+oLRa+7utWzZx8vR3YJW4vXXsvND9mNWg1b8qJAJR3h4jl5Yoa?=
 =?us-ascii?Q?SFndjm5qDH0eumSUgfw75NogSeYHSJInDhvFkyywRF+waIecrp/UgaXT285q?=
 =?us-ascii?Q?/5gTqUxbd0b8Kmsc20Ir5kG8v9xyBqygUFjDa8XgFVZCWM2QchpvTXILHQXg?=
 =?us-ascii?Q?uFaJ8tepjg9X+QwYKwnlsXu8fYtB0eKZRfmhmbBh0fEfEKiIy9MZpEFYn+tu?=
 =?us-ascii?Q?5tyEKirJlgsG1MU+tiZwuuqn6TwU43Sf9biwA5laR7oYTBt3QukI+oEM17R8?=
 =?us-ascii?Q?iFVWx7y/0rTD3kFAmEfn9oXa1SaujHfQjMjVE123gBrIlrZqrSyxCtZ7m/Ni?=
 =?us-ascii?Q?Ua9YEhK/Xy3rk+vRwoecQnqC5CINa2ExkJMdsBjseH1y7bMRQrjpq5XN4xr8?=
 =?us-ascii?Q?4LuhMQOdj/qWVjY8Qs78X/uaYXnFHV+IXusUzf7zB3us00bkPvw46JZ2vAmE?=
 =?us-ascii?Q?uMTy98CpStMJ8y5TGNpDGcyxi+o8D2tJyYJn9Qbs4ipI6PCQtrDJTQvqYf7H?=
 =?us-ascii?Q?yRHj48QJoHe4MRFx3uYiSF0UqRIAUJTRrDxBOQysEHcPdKXM/lIjQagEJzj/?=
 =?us-ascii?Q?pRw47Or28yOwi0+oXPbVBSE2Xe5tpHizMNr15By3zk0Ir+BB9aJfohv1Nveb?=
 =?us-ascii?Q?+YplAc+/iZbnohkoHHXNIRPJD7L5VB9Nmb4FhQ7tLCe3QOxnHXQ1hX00WDwM?=
 =?us-ascii?Q?c0NmnCAB6Uuf12V9cqwZz+hznwTadxbINpaeKnIySXMqJaz+tW5k79SipZTw?=
 =?us-ascii?Q?keJ1Oz75zrzJKugCjVLZ+K8h8QGlEbhETi7AWYqZ8hpRlO9R4wZLCsuCEyjM?=
 =?us-ascii?Q?jq9w4l7cJuahSpo3iesmQJzVtwUTW1PxGcZ0sUwRh77LVMFTbwXu2VYKecPM?=
 =?us-ascii?Q?udXmiM23zl9tqBQDxEDRh4kd24M7x79ZmsngNIRHbdx3v2n/c9NIhnSQryOT?=
 =?us-ascii?Q?HGWvgWXGW84ubMGjtDlMsFK8WWTMzwvHFyV5raKqPCm+U95RtX7lCeLPO85c?=
 =?us-ascii?Q?1ZJYx6Q3TeB276SeAK3x2/BLGhEPt4BVdiarFq8IsO3VD/zYim0o5oGVEazn?=
 =?us-ascii?Q?AqrtyCCQUUlPpk9xDxTCM6qomhvSy+iRIPSfwuPMMENj3g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?c3RZUxG1+OSWFxEe9wa9NPMIubfhuZr+1zHTgV5l2b04+m47XD8vJnsvbCp4?=
 =?us-ascii?Q?PIw9WOw8xinhsYJRKhACTRX/jEBcTjdcB/sFaWNRvHX/ByQgWBStsbHsF4eV?=
 =?us-ascii?Q?36wAiyP++DFhUR6lsVOQkZgYbJP7j0klaG7nZMF+giikh6kl4+d5GYmqnw9R?=
 =?us-ascii?Q?VPVv5DkRfUeZ3XMSw3ciz0LqWVoqzuAePcKpb4yEGVSJkVvg6uef8wQMcX6g?=
 =?us-ascii?Q?xHDrWCP+nu2UP+HsKokdZS3r+IGneSYnWhBw6TbRZZJhIQsXXUrprWGm5jkr?=
 =?us-ascii?Q?DL9426oHvHU+Gk1iinV+k41TFBw1dhF/+AgCMAnrLwx1ITh01VHqhJ9ZgD8L?=
 =?us-ascii?Q?vVJ7o46s2BnXvKHvoA6CupLzX9JTePtoN3SsL0V1RivqbBtosKPp9WLpL7qC?=
 =?us-ascii?Q?8ebLnA2mJgB6LfoQOFpfOhfMW1gv4e0bJXac0EzR9kEv9slGL2mLjUq9nzjM?=
 =?us-ascii?Q?mTsD4Q3MDPg3dm+hUxNpDmap2n8zOoC+5OHx8O9YRqxPmozwLgwfXZZDstKP?=
 =?us-ascii?Q?K1HSMGbrb8dMHIDcYS/RkXekhjbF4yr03OSFSU/KvTAa/6I1gc5Ln3SUp8yM?=
 =?us-ascii?Q?xiDkfjPqibl1M+fMBoMJGQxg00yUPq2vnQI51pFIpmtaiqYGXPURFZfPujPn?=
 =?us-ascii?Q?dCWZ0fu7xENYo/fqzuBWjEfCc6Mr6NrDIzjdKa+UXgfwJGRRt2CBLDE9GewV?=
 =?us-ascii?Q?s8r1LrK+zuVZI0/IzbzCC5/6/bAZY0L3KJ2D9n0nFjusMXkyMcpwJcq3zDaN?=
 =?us-ascii?Q?p4x7neVYPepFi3qYp+dzLSXGwYFuRPWx+eikNCUnHWFjaZg+GoLGXmSsYXZx?=
 =?us-ascii?Q?IvvOANhq6QdpScCOrJRhLdRSLQ5o44qjkqLuMufDqOQ2IokAarh6Bc/js1fA?=
 =?us-ascii?Q?pTdvQm2TXfyiY0tJrSF3AR3CqJB5nmfFEKNnHjdnHQfrJIm/pQme6xXTxHVn?=
 =?us-ascii?Q?MteTTAo+5ssieJxp9OFkKIkMfhNr4Xk1Erm3dpeOcoJDryFq/RBQ0Nq52ZAt?=
 =?us-ascii?Q?Ed1X0TB2rb0oDnsE5ElR6Ll1DS0BBLuQeIe+6x5NoC/fBS6ZOMWBSyg1DQ0b?=
 =?us-ascii?Q?vdFttgZgyT/rWBUbW/+ZGt6u02fnHWF31V1RTTKx3BZLI3EoX8c8f6VSnH2k?=
 =?us-ascii?Q?syhjNM0RfFSuR3MzZUJHT5325swF95tBECy7YgU0qdKLR2LzbqF78AFgdlpW?=
 =?us-ascii?Q?mf9+3OTp7EIxdINanw2s+aeDIJ95Z/c1x52T47wt83koCPC5wboRoNTEutln?=
 =?us-ascii?Q?3+d+guOlL6DITsLOQy1NZAb6dD1k4yw1+iyJ9zS9UNzV/FZeUtvPVAf/i2u1?=
 =?us-ascii?Q?Adwk252Eq9v9J6r1LfKmO24MG4CC+cWrYVSks0/yp17ZT++eIn9XptqDEMhy?=
 =?us-ascii?Q?ghSmWpVDTaWcBxRgl81Pa2O3bDCWW0iORAjIb5NsKHDO3pdgRTmkSI6E21so?=
 =?us-ascii?Q?6213g3NLymlTp4VkElOiI28YZ8IhDF9FAs5OhYh1ikd2YnxvpGa54TWN0COr?=
 =?us-ascii?Q?5m1IEoCvmg6ZLLKO5lrQgZHF4/+0looPO46D2nQljLDfjRceJzOjZJXbW82u?=
 =?us-ascii?Q?8wWA9f14FIcQJwZB0tb0pnT8tjM0so8n7oM0fXmf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a84f3fba-9d36-4619-7a35-08dcaff07ed3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2024 17:04:23.6073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OsnYeMtsi8LSoO7NLKyu5Hevbbak4ddYVeBli/Ssfz8a2PNdBfsou8lNNxYrRAEF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4326

On Fri, Jul 26, 2024 at 04:15:03PM +0100, Jonathan Cameron wrote:
> On Mon, 24 Jun 2024 19:47:27 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > Userspace will need to know some details about the fwctl interface being
> > used to locate the correct userspace code to communicate with the
> > kernel. Provide a simple device_type enum indicating what the kernel
> > driver is.
> 
> As below - maybe consider a UUID?
> Would let you decouple allocating those with upstreaming drivers.
> We'll just get annoying races on the enum otherwise as multiple
> drivers get upstreamed that use this.

I view the coupling as a feature - controlling uABI number assignment
is one of the subtle motivations the kernel community has typically
used to encourage upstream participation.

> >  static dev_t fwctl_dev;
> >  static DEFINE_IDA(fwctl_ida);
> >  
> > +DEFINE_FREE(kfree_errptr, void *, if (!IS_ERR_OR_NULL(_T)) kfree(_T));
> 
> Why need for a new one?  That's the same as the one in slab.h from
> 6.9 onwards. Before that it was
> if (_T)
> 
> I was going to suggest promoting this to slab.h and then found
> the normal implementation had been improved since I last checked.

Same, now it is improved it can go away.

> > +/**
> > + * struct fwctl_info - ioctl(FWCTL_INFO)
> > + * @size: sizeof(struct fwctl_info)
> > + * @flags: Must be 0
> > + * @out_device_type: Returns the type of the device from enum fwctl_device_type
> 
> Maybe a UUID?  Avoid need to synchronize that list for ever.
> 
> > + * @device_data_len: On input the length of the out_device_data memory. On
> > + *	output the size of the kernel's device_data which may be larger or
> > + *	smaller than the input. Maybe 0 on input.
> > + * @out_device_data: Pointer to a memory of device_data_len bytes. Kernel will
> > + *	fill the entire memory, zeroing as required.
> 
> Why do we need device in names of these two?

I'm not sure I understand this question?

out_device_type returns the "name"

out_device_data returns a struct of data, the layout of the struct is
defined by out_device_type

Jason
