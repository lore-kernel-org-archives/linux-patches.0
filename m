Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2079.outbound.protection.outlook.com [40.107.96.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337334643D;
	Tue, 21 Nov 2023 13:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HD72Lv74"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i+9L2WZatcXNBDAe+ZIM7/Q8bQE+1bGZsl+UtlOl/yLPlSl/vPkkdYm5aQhAcopvQrdMH72gFTwCW/IMjMwRLnBaZdHxvuiAuqQfYfeEKX4xpXZwe23JXfSw6XqDfbpPL8h/tDE6g2KXmb2BBPnwrMjlUn9ZHmj9sTqBEi4GMsdlugVNEuI1Plsap6MZw0fqShf5AbzShtnL+EpId57ECOFFG06x3cNxHjFtONY9TDXK8djjI1QyZvkgcRMBYnTYgjl5rPW3MkrggBtLzCNXUA+axOkxT7zH2yABgnCNhE6Wt6Uys4uf05Rrb5paJ0hFWBzryejfCJTvU2VTdYLECA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0mDvqs0ru8wphrw81o9QgY8o8MEDHVtA7ngjKJmovmw=;
 b=id0mTuC8GTROYjRoo2jnLzIPxvNieu7gX1wmDN0HPrExz50ql87X36JPous2Iz4vFsWvID/z/m6IqZbMOzKe1Z2iFbDs5/v4Ls7jEJuc2ZCHUrSJnaIqRshWicReBMbBC+gmElUTjpb2QpMnCGw2eaRPDvSSpRzIO34jpnqiafBzyUrs10KUjhiv9L/Ky85HV9JDRT5dVoQ4ELxj+lBdtLTw/VwBTGnEh8fJP2wNyxCm4XmlM8iV8ihCy2cE92yF3pmaXar57ckmGxS9ozdf5QYChJRN1XDCElpR6Qnn5xQ00u/fHfjP2M6WcAeDUFz3ytySeuMt85D4Ar1D9+tpQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0mDvqs0ru8wphrw81o9QgY8o8MEDHVtA7ngjKJmovmw=;
 b=HD72Lv746qOu9TSPBeMopJFrav6DPd7PoVJRMTvpGTURqdi4wjgQtaKmp4kbTSMukCCd7Qf4iVdXUP/GQ9v7ypvafb0lfNYldmloAjQ2u7fkJAwJzyxyyNwSyI3/3Xr5Wjl7asgLjJYjm2YzkOnq8oIsZ6TqOAUx6jlyKfgT5ktuWpaLKzRLqm8UA2BaJJn/MoXS0UR5j8uhrGEStI9xpL+NcFwklsujEYzlZNijxePsO5c8c76w4oDAgWe1OQW8XDpAofOyTCYhSOW0yvttz6GQfFDveQssZUU3zQqXI7Q3v/e82l54U/5My4K4OiPmsevllSRJP0e45ezjAkz0Ew==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN2PR12MB4407.namprd12.prod.outlook.com (2603:10b6:208:260::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.28; Tue, 21 Nov
 2023 13:04:45 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7002.027; Tue, 21 Nov 2023
 13:04:45 +0000
Date: Tue, 21 Nov 2023 09:04:43 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Lixiao Yang <lixiao.yang@intel.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"syzbot+7574ebfe589049630608@syzkaller.appspotmail.com" <syzbot+7574ebfe589049630608@syzkaller.appspotmail.com>,
	"syzbot+d31adfb277377ef8fcba@syzkaller.appspotmail.com" <syzbot+d31adfb277377ef8fcba@syzkaller.appspotmail.com>,
	"Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH rc 2/2] iommufd: Do not UAF during iommufd_put_object()
Message-ID: <20231121130443.GF6083@nvidia.com>
References: <0-v1-4c9a7fbb5702+107a-iommufd_syz4_jgg@nvidia.com>
 <2-v1-4c9a7fbb5702+107a-iommufd_syz4_jgg@nvidia.com>
 <BN9PR11MB527644B411E7F9EEC11F49898CBBA@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527644B411E7F9EEC11F49898CBBA@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: SN4PR0501CA0128.namprd05.prod.outlook.com
 (2603:10b6:803:42::45) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN2PR12MB4407:EE_
X-MS-Office365-Filtering-Correlation-Id: 112434c8-00bc-4764-b0ec-08dbea926efe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	wre4brDu1dY0jfYiFLM4/9SaUatnnjIqhTa584JkBr89XP7FPXHXC6cm7NtfvX4jYPTV3D7Nc0LsS35DyhO8Txq0hfo/hD9limlhBfPRAA/DqoRlnA8FtyPjJFi3C26TlvQqE8b5alL4bXah25D55SH2MFLvdWqkLiJhYq2+V61Km0dnFt1x5U+J87DuyZJb5bPUrN2kVCbzJf3x/CBZbWNOfOS4nSUER0Nm+OoUf5dr/4JRGZFGtIP79WqYFEXyuOPgFkFH4QlRC4+UBzBC/KSPOdu0c/EA6j46uEoiWkcQt5i7ETCcg+3dE0Dsd2OijbNWf9Hh/h+oUTF800f4DgQOBlSxAuYHCHhEhh/tiGo0moAp244qm79jk2xuSKo92pqwzmRRPL7kaqE0i6SnueHuljIkdFQxoqPlDHFe1563SRNZPg6J3DbifScO2cJWBV2rk7tBO2JXIq4pCZqd4S7JEMaVbcpvRo5+l8YdXLsJ2GK93rQxDNzOf5ePBYKKZEpnj+XHuEGXyky6rKhZGlP//H92biYFywhwjMelYDU1NBjU3eM5f1tyw0KhQety
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(396003)(346002)(376002)(366004)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(2616005)(86362001)(6486002)(6506007)(66476007)(66556008)(66946007)(6916009)(316002)(54906003)(33656002)(36756003)(6512007)(1076003)(26005)(83380400001)(7416002)(2906002)(478600001)(41300700001)(5660300002)(8936002)(38100700002)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MSYKP1HrYPkwnjQlzGZGShi9YRk9oW3sDhQSBL9mrMRZ2cbvLoY7cs9NixD4?=
 =?us-ascii?Q?/En3IHPm5Q80WT9urRrI5cWfZWCNpLeGV2GqPLC1orfjnf5NFAQ2zXnxZlBJ?=
 =?us-ascii?Q?1ciOM5nqEg1FdDN2/Th3udRA5Q0uB2Fv0zt/wTNvCx0OHMuwkfhqsMk8kvKe?=
 =?us-ascii?Q?+NfmaIYVYYYvT7a2jgKVQVu6iw+W/DznSLrLDEVfBC0xM/rXI55n9HQ+uTxA?=
 =?us-ascii?Q?XqrGKPyXkpu3H2dK6Mag8zIcwVQ6etv1cVlPr803j0I9tPWd7bNpGOcEhYZq?=
 =?us-ascii?Q?wZZzIBWyY0LnoDg/EWya7Tb7M0u1fCn7cY3UaEBD6yJTb0/rxytsLYl+4/oQ?=
 =?us-ascii?Q?1yyAch7tKRG5/NRR/UGqMkPDVC5zIwZPKrgMahHWeS0j3c4ThyF9ATaD2KB4?=
 =?us-ascii?Q?pfIoF1+vrXuYTkJVB7CVTB2GBLl3W/1iP1OI3jVy+H/t8TVNucqC2PFnBhno?=
 =?us-ascii?Q?4MNUU/aSk5vF96u4MfLejz2vQXH8VI6QdQrhkBggATC2pmkZBSfyqv41dIC4?=
 =?us-ascii?Q?7nm0fUa5mUeog+B0Ne3TZ6fw7B2bHzuQpqmkuRqIrMyWuOTFmtlZidtfXmeE?=
 =?us-ascii?Q?VjCvRZMIkBdMVBXf/qzZrK7XUK96Mv/kUeueOxh7Cev86SHUM1/JSD7ry0fI?=
 =?us-ascii?Q?qsJ8uQkNj+EAklrr4xXTr13hpaY7UdyCG5RX82RlPh5VIyeLsTTvdElg7Wir?=
 =?us-ascii?Q?oCr/zjUUUPHVrmp3Gk10hSefsyb40uNItx3QBG0HSKtLVZFLtiGNQWCK2c8c?=
 =?us-ascii?Q?/tZSjUzO7bbif5RZTk/KaV89+CBoFOLkTGFkxi6Z+g0lnkFNGumSFIxsQJpX?=
 =?us-ascii?Q?+sMCFLadOgs9/BSIC+sWdqFhe/177dvD4fWsjyDF89OO0KOdyjxq7dCLcakA?=
 =?us-ascii?Q?/y038Ax+Q5Cauyq+T/q62UAg0ybaikLrOMlCtgGsS3AzNSGZP8vcxH9B1/Ck?=
 =?us-ascii?Q?NbDFO85s8aK/IbKAL+O78AKN5UuRhkF/AP+jcoURoikqgViZowqtgJbUHKuQ?=
 =?us-ascii?Q?D3BVbiSJHYjFI3em6jQxNtjHajJM2NtX8LRxpZ3vN+xLZSV+sU6/m1A8/fHn?=
 =?us-ascii?Q?OvxKmK4i8iq+c289vl5b/h3j2yv0wsYdjESeohrMx6LCYWkwYJxv2+mENjGn?=
 =?us-ascii?Q?tbaPotvVECLCCr4fFoajxE+ZINVVMAx1SSLl4K3l6Rgnp+xiW1DmHnq7W3My?=
 =?us-ascii?Q?4c1WFhs4XE8/15+Vz4wWlilJYZNmBk53bU0YusX2PhZQ0KJU0HxD77g0YpBr?=
 =?us-ascii?Q?l0f8Bou8ZR+RtO8KB6YcucwL+kCnzTxKB06E9TWof0K52EwjCRwNE1u+oEfm?=
 =?us-ascii?Q?HIWGQt/7NKYB7lkv6YYNqSOp0xIh0NyoUX3om/BQz4zhvuc7pAwIB4TTZmsZ?=
 =?us-ascii?Q?vcY6ZMKxf8Ep77m29zYRW7ZZandRsrrSkMwGzByB3K8bbJmtb3cOOsU4DL45?=
 =?us-ascii?Q?tu9/KjdGHPv3xVMCgLddchPcgMs9TpNcArPLJbCVpFvj9YMpy1PfIAAD1raA?=
 =?us-ascii?Q?+R2b+CmCKG4p5a2nvLGczoHpuMGef1Mo5c/tcXrnRBu5h2HmWTvALMAaYox+?=
 =?us-ascii?Q?SJeWtZX+D7dTyh9x/TgGa1zkYpXGanL1H5n4bx8E?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 112434c8-00bc-4764-b0ec-08dbea926efe
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2023 13:04:45.2658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Va+fQBPK06Yg9qVuRMrbEsTm9Oilg0tBWJxLs122ryijsygL5gtoOENayC/ZOnXC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4407

On Tue, Nov 21, 2023 at 03:49:55AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, November 21, 2023 9:28 AM
> > +
> > +/*
> > + * The caller holds a users refcount and wants to destroy the object. In all
> > + * cases the caller no longer has a reference on obj.
> 
> It's unclear which refcnt is being talked here given we have two now.

It says: "users refcount"

At this point the shortterm_users refcount is held by the
xarray. Let's add a note about that

> Actually none of them matches this description e.g. if wait shortterm timeouts
> then both users and shortterm_users are left intact.

shortterm_users was decremented and the object is leaked in that
case. It is a should-never-happen flow.
 
> >  static inline void iommufd_object_destroy_user(struct iommufd_ctx *ictx,
> >  					       struct iommufd_object *obj)
> >  {
> > -	__iommufd_object_destroy_user(ictx, obj, false);
> > +	int ret;
> > +
> > +	ret = iommufd_object_remove(ictx, obj, obj->id,
> > REMOVE_WAIT_SHORTTERM);
> > +
> > +	/*
> > +	 * If there is a bug and we couldn't destroy the object then we did put
> > +	 * back the caller's refcount and will eventually try to free it again
> > +	 * during close.
> 
> This also needs more clarification. obj->users is not recovered upon error.
> only obj->shortterm_users is put back.

And it doesn't always happen anyhow.

I'll work on this some more, it is really tricky.

> > +	 */
> > +	WARN_ON(ret);
> >  }
> > +
> > +/*
> > + * Used by autodomains to clean up the hwpt object if it was not used
> > manually.
> > + */
> >  static inline void iommufd_object_deref_user(struct iommufd_ctx *ictx,
> >  					     struct iommufd_object *obj)
> >  {
> > -	__iommufd_object_destroy_user(ictx, obj, true);
> > +	iommufd_object_remove(ictx, obj, obj->id, 0);
> 
> since there is a flag parameter now can we introduce a new flag bit
> to represent extra_put? having both obj and obj->id in one invocation
> as the hint for extra_put is a bit vague.

If the user has a pointer to the object then the user must also have a
ref to the object, basic ref counting rules.

Jason
