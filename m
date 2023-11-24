Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F1C7F0;
	Fri, 24 Nov 2023 12:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="C1cAKs5h"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G7jCm7dPTBDs6xrFCSu4UfDCdEHNB8NtdethVBDvxVq1jYWadqnJBVwJVJkp20A5knfFlc4J1oYNHfEg2IZHnc+bXqvPzoONIfBh90BVXUxdb/7iMIvV+Y7bu+mXMjQkukLSns8g26Jm0Pu8eImN3fV/olSWzzGPXtTkcfL9PiMoU31tn/iCMtREXc3g7QJkTs92YlHrwqz3fAtHgah2UvtZXX349mE0+FyEcxC+KjxvUc92sOMicRpDRTYYTRpvmAjpnaD44ZxbUJmlBxS5VlsCUV7umH06C2Z8m8P5TINCThjwGnoVY2HZ7QQcpSF3b92UAnw+0bhjYX1lE9TlIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lSfu1bMjyw1+Dr9uuzF763mT8XtFdFOR7/UivFpYbl4=;
 b=NtjlHX0JejzJktNhWcD9rPm8ucHGGfB/j1milz6/58DzIjvM1+Hf7mxjmq6MihaM6TcfQLYGMoBlGUxo6ZKOXVofLPkVfslaEI7mhWhHQS3na0CEB6A9E7m+9vyyDULUTG/5tLlPSqqYjUO4yNY05rfrkXmQOrPx5PsauiHilDBdIkzipondnTSB+wwJRg53gssg+iwML3Yly6ozVonuVlw37Eji4Ved73x2f2YIQLJoKxr5cGGuDPeR+1wtaUl90q2A3oYSj/9ndUMxThbdXmpTR6yx9icag4tWnwr1gHJfvx/9d2KBem1nd2Pv6JSkdYbPi3GSDLSURQYCTspi/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lSfu1bMjyw1+Dr9uuzF763mT8XtFdFOR7/UivFpYbl4=;
 b=C1cAKs5haoCo9y3Tg0ay4NtFGILJn8IMSZnNFtgl9gsUiNz+j3nN38+HAyEtVmgd7KHQo1B+vBIKkeqqm45KzLtREbgh3ioD0Ez/lhTAVr6Db0kqUB0uBOILlyqjTy9nm25TyoGj3PK05BBKb0J8t8Zlu8FhbtI17rvhslQNaL7lsdrPnZCtYQUjVga1104dH8uoshrQfuM4NBirRvI0kG0ArGjg/ANTrqINAfx+Dg0mjdjl37CN5ySt0Pif+POq1bLoYa45DvIc358FpW03Bc02jrVpF0A024OcJSYdYKUjpBJ4Aa41f1vqTK70af4+xxuibgq3OMt3I6bWul6nOQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB6018.namprd12.prod.outlook.com (2603:10b6:208:3d6::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.21; Fri, 24 Nov
 2023 12:50:09 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7025.020; Fri, 24 Nov 2023
 12:50:08 +0000
Date: Fri, 24 Nov 2023 08:50:06 -0400
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
Subject: Re: [PATCH rc v2 2/2] iommufd: Do not UAF during iommufd_put_object()
Message-ID: <20231124125006.GC436702@nvidia.com>
References: <0-v2-ca9e00171c5b+123-iommufd_syz4_jgg@nvidia.com>
 <2-v2-ca9e00171c5b+123-iommufd_syz4_jgg@nvidia.com>
 <BN9PR11MB5276FE18B63A22DB64EBD8098CB8A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276FE18B63A22DB64EBD8098CB8A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: SA1PR02CA0020.namprd02.prod.outlook.com
 (2603:10b6:806:2cf::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB6018:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fa24a95-f112-4ace-3b22-08dbecebe384
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	40Td6UzwbzMTkx3bTgBRf8o1UpGjtImXZ6ZxZTEfnBraE/GOphsov48tOf/X7+DNg+WkPTbebILsi5rgOGzCK4l9xsK/1fRP6O+Ru/3yMA6RbKSjTiVja3EtVo/yyJM6in/mDFbwTpW2kcQ0W0xe+VJgpyl0JaEQq2vOdW47PhkekA9qDgSlvn3Mv7EZIl8+zj6yYPhXYGnyPYo69L+Ro9R0BkFuUFVYeHjFp/k+lut/0jZtwAU8/6UKFnoMlZLI3MLgtuKsvTDl+dNsQL7G7AnynSnBfivwDcbOfGBtYP688jYJOe0WtcDBeok9OLclmawKySFgc3b9N9gMdD2H5P5Lr73JGS6RJPqazXYsz8y1+v8qoIOgTMf/KMHF2kHCWfeII4IzIsV+oZh7i95h+Te1FLQke0vK6X0Hzj6yKc1O73eOHyTpOYKoLMul1EF13Rfi2hJP2yt/yZ8zVPe9/cP9DIm6nmfj/ez13gFHrJUlQXBad9t3D6F3r2cC+3frXnHU6qsZA/5gxX+5OozrQwMKlfxsVvHjcRJjf3QS10RGW7sQqRUODXPb/51S08U5+TmxyCU8WagmNtjoFiQDv59RbS6YD6l+JdDUFNIZcXOwmNydMVEanIxCR9WGPjdDGr+iPZzxIvKA97HFgEcgBw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(376002)(136003)(39860400002)(366004)(230173577357003)(230922051799003)(230273577357003)(1800799012)(451199024)(186009)(64100799003)(83380400001)(6506007)(26005)(1076003)(41300700001)(6512007)(2616005)(38100700002)(36756003)(6486002)(478600001)(33656002)(6916009)(316002)(66946007)(66556008)(66476007)(54906003)(2906002)(8936002)(8676002)(4326008)(7416002)(5660300002)(86362001)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oE7oqJ6tuPi4ygyAQXZ/hNOfK8+iTQiH644CU8ow4nxNQ2/zcRqt+Q+AUE1g?=
 =?us-ascii?Q?mXikC8g078KLnqVIJkEBp2jCjv06XUPNcolXRg8J3a4Et/B89wLyYeIP8sBH?=
 =?us-ascii?Q?2tM3ohHHrsxt2oMTjk3YRMTsPN+VuWvjcIpaM4KXfKHbiFkQ7/NWydU3vQqM?=
 =?us-ascii?Q?HgYN1/xK8zRxqcxb0tKxBNeylLyzGCH+1ARxYZe7ahnA7uyAVa8Xrw5dqTXY?=
 =?us-ascii?Q?/louxLn563q/rmpSK74Ev8X607xU7BbHIko1QZt0P+6CtVEZjP5OJ6eia9eO?=
 =?us-ascii?Q?yHYKapF2blGE0wFy/KWZ6Kc29jmhi9ggiPdnzjHsoVbPW4p20D0r00tnTD/y?=
 =?us-ascii?Q?h5Zh/3TYtWsV9UYzdRTtbUWS2eJhZhDL1d5+0DxEBCYNSK/o54wVtD4bYQtM?=
 =?us-ascii?Q?XMdR4ye9MT/WnIwTpvIpEoEm14aH9RouhwwvPp2VeT/eCU69Goncwzs2s7WO?=
 =?us-ascii?Q?d582FX+ebRdZ8ninGH2GtxqRFwdqFwYHokArb+8p19fVo3G+xCQa4zGbuZJp?=
 =?us-ascii?Q?nkSX/N5SlQHlSWZlSidJ3xJAzwXm9S/LTEMfG/tQeyymml8YndB6itrR2IO0?=
 =?us-ascii?Q?GW40m3MqHjVbYi/WzxgUUiK3YVAuz+ouQ27wBX2F6cY+OxAcVsV/WZ+owJ1v?=
 =?us-ascii?Q?FGBJKSoaI5K8wROuwUTAV6aLBq1YNuRZFiS1VrbXFj+b/4z0+aBcNCwM757W?=
 =?us-ascii?Q?7XBlq6m+wwH9Dg1a+PTup4hxHFlXSlxth0E4ABrw7wVAeSO1iuYf4ORfQecx?=
 =?us-ascii?Q?ecBnHbEVaxEg19pME2qKJKBlOU1FGts58L0SMfHy0qTy23XPzXz5vQnn4gTT?=
 =?us-ascii?Q?8X2ADe5I25H7CSnx8EEedIUPEZMLyEH5hMK6tasVRmllVQbB5mTeVk1PiSMr?=
 =?us-ascii?Q?Y6dp5aVmViyNO+OfEDUxrY5WqgiDocSw0GtUI7EK5EQAkiEqEsiNyOf/BSzm?=
 =?us-ascii?Q?MKkZ1q6EJnB9clxRfW5uc/MYFWeJAyjmF+5g3AKQH9Q5kc/5XUhmRYA7qTTB?=
 =?us-ascii?Q?/Ey0ss81dp6ze8JBwA06cbCpLIrJnR3ALuHUFhJX1BFYVi+GMM40eczDq4L9?=
 =?us-ascii?Q?s+xtF4PQ9MHFtpV64cKgjhj9A1BuRyxDX3Z6pT75/KiUhzum9oJ/0moXOlwU?=
 =?us-ascii?Q?hwoUyBXlL6KJmuRO4syitopjVqR83/vgzoSSTUsJFBtPkWrCUDXl52wO2nNg?=
 =?us-ascii?Q?TTw3WsviAjEoJiA77UWt9rOXmfcxhz64XlTLOni5BkMrGl9EgGtPp/Oe42HY?=
 =?us-ascii?Q?V8znTWn46VpgZk+5Nigtfa38RNSmFDgsRdAEDIirtc3/Xpf9N1qdEecYFziI?=
 =?us-ascii?Q?uF2PQFW1sR7HdbroPVPdVvNTda9AOl50Dle5zcgPH39vCAV2N4Y/HsF/OLXp?=
 =?us-ascii?Q?QVnasAsQMwCAqtNEd1U9NPCVjIGdVGA7xaKHXC8/u8ZY750/TGg2aRkwHMQI?=
 =?us-ascii?Q?H0epGB2u3t/1tjciAYoEx8UQon0ybaUMQFQ6NlBGGm7YSM6QVg79hUQShfMT?=
 =?us-ascii?Q?jW033C/svNkxxlsU8dmu7hpBdu8DscGENgBDeq0cqKgvT3bh1SaKx/BP9dqq?=
 =?us-ascii?Q?9+yke9ue0nlqgEE5/SbT8ZKp4r1vYPcnu7Z0mgJo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fa24a95-f112-4ace-3b22-08dbecebe384
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2023 12:50:08.3122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0AheJIdlBvKqB4cZJ/7wmxsC7uEHZEHCth42kSfy5o2hAnQFS+P00fFaZpTmb/P+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6018

On Fri, Nov 24, 2023 at 06:48:59AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, November 22, 2023 9:13 PM
> > 
> >  static inline bool iommufd_lock_obj(struct iommufd_object *obj)
> >  {
> > -	if (!down_read_trylock(&obj->destroy_rwsem))
> > +	if (!refcount_inc_not_zero(&obj->users))
> >  		return false;
> > -	if (!refcount_inc_not_zero(&obj->users)) {
> > -		up_read(&obj->destroy_rwsem);
> > +	if (!refcount_inc_not_zero(&obj->shortterm_users)) {
> > +		/*
> > +		 * If the caller doesn't already have a ref on obj this must be
> > +		 * called under the xa_lock. Otherwise the caller is holding a
> > +		 * ref on users so this cannot make it zero.
> > +		 */
> > +		refcount_dec(&obj->users);
> >  		return false;
> 
> I'm not sure what the comment is explaining. This path can be reached
> only if the earlier refcount_inc_not_zero(&obj->users) succeeds and
> in that case certainly refcount_dec(&obj->users) cannot make it
> zero.

It is a refcount so a parallel thread could have decremented it
leaving us with 1 and then refcount_dec(1) will WARN_ON.

That can't happen because of the reasoning in the comment.

		/*
		 * If the caller doesn't already have a ref on obj this must be
		 * called under the xa_lock. Otherwise the caller is holding a
		 * ref on users. Thus it cannot be one before this decrement.
		 */

> > +/*
> > + * The caller holds a users refcount and wants to destroy the object. In all
> > + * cases the caller no longer has a users reference on obj. At this point
> > + * the xarray will be holding a shortterm_users reference.
> 
> iiuc shortterm_users will be held only if the destroy operation fails
> otherwise it's meaningless given the object is already freed. It's clearer
> to replace "at this point" with "if any error"

"At this point" was not intended to describe the error case but the
entry condition..

/*
 * The caller holds a users refcount and wants to destroy the object. At this
 * point the caller has no shortterm_users reference and at least the xarray
 * will be holding one.
 */

> > + */
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
> > +	 */
> 
> this is still inconsistent with last comment which says "the caller no longer
> has a users reference" but here "we did put back the caller's refcount"

"put back" means to have effectively done iommufd_put_object()

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
> I forgot why autodomains can tolerate failure to not wait here. Can you
> take this chance to add some comment to clarify?

/*
 * The HWPT allocated by autodomains is used in possibly many devices and
 * is automatically destroyed when its refcount reaches zero.
 *
 * If userspace uses the HWPT manually, even for a short term, then it will
 * disrupt this refcounting and the auto-free in the kernel will not work.
 * Userspace that tries to use the automatically allocated HWPT must be careful
 * to ensure that it is consistently destroyed, eg by not racing accesses
 * and by not attaching an automatic HWPT to a device manually.
 */
static inline void
iommufd_object_put_and_try_destroy(struct iommufd_ctx *ictx,
				   struct iommufd_object *obj)

> > +int iommufd_object_remove(struct iommufd_ctx *ictx,
> > +			  struct iommufd_object *to_destroy, u32 id,
> > +			  unsigned int flags)
> >  {
> >  	struct iommufd_object *obj;
> >  	XA_STATE(xas, &ictx->objects, id);
> > +	bool zerod_shortterm = false;
> > +	int ret;
> > +
> > +	/*
> > +	 * The purpose of the shortterm_users is to ensure deterministic
> > +	 * destruction of objects used by external drivers and destroyed by
> > this
> > +	 * function. Any temporary increment of the refcount must
> > increment
> > +	 * shortterm_users, such as during ioctl execution.
> > +	 */
> > +	if (flags & REMOVE_WAIT_SHORTTERM) {
> > +		ret = iommufd_object_dec_wait_shortterm(ictx, to_destroy);
> 
> missed a check that to_destroy must be valid when this flag bit is set

It is an internal function I don't think we need to check the
parameters for consistency..

> > +		if (ret) {
> > +			/*
> > +			 * We have a bug. Put back the callers reference and
> > +			 * defer cleaning this object until close.
> > +			 */
> > +			refcount_dec(&to_destroy->users);
> 
> explain why refcount_dec means 'put back'? also 'put back' is
> inconsistent with the earlier comment "In all cases the caller no
> longer has a users reference "

As above, "put back" means to have effectively done iommufd_put_object()

Jason
