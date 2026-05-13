Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010022.outbound.protection.outlook.com [52.101.61.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2AB3D301D
	for <patches@lists.linux.dev>; Wed, 13 May 2026 06:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778652362; cv=fail; b=CgLThqXYufoqgnl3yZqNTfYb+YAZ9HFo4lS1VLd3n0PxkKPm51u/8kvpbhyeFoZwTQwhVm9/s9jPNC+CXvgY87iW9asw6Q3rWoIk5FhruGfN3m+J4pCHC2RmdPk84eWTgZgLRoc7LsVo7twgtRLuwV5m+efYHgy4erwijDO9FDk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778652362; c=relaxed/simple;
	bh=tZCg59DUlIxV/CPcRmWPIAmILpXX4Jgg5JlzcNxxsM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DN7cueDDhMLKcqFuxBSP/DVwRPLdh26kur30xp/pObMepZ1ib7GSGFWvsZHtmu0/d5Xu8RbwF3Ie+KL5y8YW0LTHMd00LTqzOMmAdHKdwYrjxoJBeFHgKO9P5UHEDNamyik65Sf8rLFYEy0CuNdXm4cpl0aoVq3v165XQqqgpBk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IXjwnqKy; arc=fail smtp.client-ip=52.101.61.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IXjwnqKy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=njRi0kh3bkjrYcQlXM/0s24k4NDbPK3P/FJ7KIS4C54/0MzWUDW8KYtLIxqf1W/LuYD+PbcWAaVpCkeAdofKYmzw/+zENj3Xa+BinjI4NyI6etn7dXsqc+mk6D1zpDTch7HGojJrcVKpMPy5A3IYTDaXDS85coN9m00OFkjBANJCFPS2dJKdC7tt9/kHh2XAfqe79KWPtg9/XnZDLw0v+AKAFkt4M14v9DER6107MeYzfEWB0MYku+t4/WsCuOrRGAibglDt4dKuacAzaoLtm4s8LcTCfDh6VNItYHMQ6LflZedBUu6dPg91HgBszhDAOdAAh3sRALtFSpZIw2hr8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8UZq1Nr9WvlPyxu/jXS9/ItZlm2gKQ0wHw8GqT9xpOQ=;
 b=diG1d5jit8zkY7P8QSlRFNMobV5Aj7vF0HCw6nmkX9cPvzsZmPNQekReGrox1AtCd2b83tH634Qhw67kVQVpPJLcsNMyBGTeGf4ud3szi5eL31mIEvSmQVCjvQ4NVSCwHYuSMzAFDDktpQd3JwhhFHwHedU3BiuOMqwETnOp4Wg0gt14aWaQVvh8Jaezu2RVMAc26Z81GZHMwtuPViHY+ePfEHNR8+uhh43P0953NpidtWQOew8qQkZviJM3P2Gbuc+zFk/xRCxhPhdYcob8OlrpxxnZ6mthxZ9OL9sH4htLp+WxZnK4eThOtG8uDQGaozbQHCHU/ofU8FYt8jtr0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8UZq1Nr9WvlPyxu/jXS9/ItZlm2gKQ0wHw8GqT9xpOQ=;
 b=IXjwnqKyjQfx+mPcIWWBNEeXJ003ptwhIsWfdNf7stC3RTU8sBaKH3JGzj3xF0YcBv6pCYeyU/pivoE9u7/Y2gehKrYELex1596TYnpBAY85PFbznU8s52ew6y9sASpPpQD7IOMV9s30gjugjx7vMiJFEr7V/hm2NCF7TDZy/+Ep0Qo1Tek6Z0HxIIQYQhi6Bv4WLoRFyRNRuVCgqADdOPzjkSyah2AmzqBAJ45ZGCLQsC09Y+P0mlt0eX7wNta5m2ncEmrQfCdn2v3LRgk9ZCOfMxT/3FIaIl9JGUsLYt7PS1C3zrg3fc3TrDb/aPVzkIHYMbMG8Qbf+lLj6GNTcQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DM6PR12MB4314.namprd12.prod.outlook.com (2603:10b6:5:211::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 06:05:54 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9913.009; Wed, 13 May 2026
 06:05:54 +0000
Date: Wed, 13 May 2026 08:05:45 +0200
From: Andrea Righi <arighi@nvidia.com>
To: Peter Schneider <pschneider1968@googlemail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 7.0 000/307] 7.0.7-rc1 review
Message-ID: <agQUuUpJ2fu1JfVG@gpd4>
References: <20260512173940.117428952@linuxfoundation.org>
 <90116a48-a75d-48c9-b09f-97f541c0031c@googlemail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <90116a48-a75d-48c9-b09f-97f541c0031c@googlemail.com>
X-ClientProxiedBy: MI2P293CA0014.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:45::13) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DM6PR12MB4314:EE_
X-MS-Office365-Filtering-Correlation-Id: afa1ad2a-c22f-490b-00b9-08deb0b5b16e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|56012099003|22082099003|18002099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	JTdKOJdgGNtsEYcpcpcNl1gA9RY3UgOdXUJE4kke+4wus/AaGd3dkrN4QB7NzbwR0arZn7xdrvn2o0PlpY9flv0cskGWGS8KWXWMosS7M/H1beEGuVHM16P0EbUvp1QQ0HsvmbP0u0fkhFyHHVAJfYB4+uLnW7+CB0VARUxVLOIIRqwJ5yrin2T5KqpEZwo+pMIeeVQ3I3OyHtKxeUqgT+UDIGLlp3ddbCNACBjeI2NFFWc+thjKahEHL0oMQqM7mzLnxrjcirnUuGhHPJAL3WBOOAUfcGZN+kQkO2q+4XDWNPEkX7rnST5IK0YlhTBT4PjLeDWqVdPTjd7++Cj8nEwZhCgathUQILen9x/1MrK6XHyCiNEn05a2lVNjh4ciBLhbhlGVnzdawuE7A8/hTkHSPPiHkM7fjX0MbZ88TPwb+xhSqkKJxpNvT4AS8uIcb10Sr9cnuop8ooefmRmUPNR9irEk9GWc/mYiKGBYTvXYdxf0jmE+pTBC78ctA/YRPcY6Lpq+qoQJHavCPhcJ6QH0ajCjjl3nqIhBnnBLZfWwo7vRVn73Hd2fjJsO8ZiCe0PaaddIJmKvTJwlhWPTlndnjBg7thDt3H34Ko4kWA9BP3QDnoHv045H2NpSGtYV4+/ZhKG1mBmiVqpAW0MVWgalJOgtCnZsAVShlXgUDbblTijJi0j/wKaR8qn9lEOK
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(56012099003)(22082099003)(18002099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dVVVaHBpdWM3Ky9NRW9JbWQ3N3p6V1BLVzlJN2ZveCtqWHBnZWhqOVRIQytq?=
 =?utf-8?B?cngrV1dtVE81bTdYOUJOYVN0aU1teHduVWhuZ21LT0kvcm0wbXhKc1FqVUp6?=
 =?utf-8?B?YWRLdVZpMGZ6emRyWXRiWVZLTUt6RDI0QnRTY050cFQzT29yTWEzbUUzUXA3?=
 =?utf-8?B?a3hFRVo2eGU0bnlJclg0WXpVUEFDWEVyd0l3elRTQmhTQXFFTW45d21pVFdY?=
 =?utf-8?B?QUl3ZkhsbGZ1Z1lMNzhBbDY0MWFEU0hhRWo3SUY1QzF2cDJkNm9XRWo5cklS?=
 =?utf-8?B?aVlJbnl4WlJWd2dMc1ZuZHRpODhaZ01rRndKMGs2NGx0ZlJjNHU4Z2JiUlU5?=
 =?utf-8?B?Z1VBYllNU05Ja1V6S2Ezc1l2dGZka0RvRC9xVFNLYUlwTVIxdTRnemNUVEtw?=
 =?utf-8?B?aFh3Sm9CakQ2OHVhUHN0Qm05SE4wMlQzdHZiSmUwaGZKNFRmc09GUDR1WEx4?=
 =?utf-8?B?OHpTbXJjRHR3R3FoQzBUa2hBRVdLNUpmOFdOS2RPK3ZseVNNb3NYbnNPOE1Q?=
 =?utf-8?B?aEEyMVA2bENDYUNRK2x2WFREajZxZ1ZiSXBPSVpGYUxHNW5zcVBsc1BNNXNE?=
 =?utf-8?B?a2VjdnEwUSt4YittNENyTUlnQ2FmT2hpWmIvQ2VjLzU4enNzejFGTC9KNWhk?=
 =?utf-8?B?ajNTaUlwUjRpdlAyY2ZMdFRCVFQxd05TRFhYV3Yrc1VqY21KZXQrTkFVZUha?=
 =?utf-8?B?SjJ1TjZnT1pLbHk4UHRlako5QmZVenhoNHVOSTVPNkpIcWRFSk5yUW1ab0Ur?=
 =?utf-8?B?M21ZcmpHU0ZjY3ZnWGRra0xtNWphWERuOG5iOEtaRDZiNDdTM05TcldNemo5?=
 =?utf-8?B?clhOOEJkWFdiV3FzY05ocUtydUo2QkoweFREVlpzK0xsTnp2VUNZdlhCb3lD?=
 =?utf-8?B?YVgxcWltWElXWi92YTVVRDRxQ0ZBeUs4V0VidmVSL0JpZy8yVW0zaXhIMmhE?=
 =?utf-8?B?NDl1Y2RCenNXREdPa2Z1NUkxL1V5SG9GN21TL0hZaTUyaERZNGtZZHRXK2c5?=
 =?utf-8?B?ME1xVWlVZEd5d1N5L1ZhSlFxWWZoZHZiQkt5Z0h5TUJYSzV3ajdnUm1lUkw3?=
 =?utf-8?B?R0dMejE3QVdXeWxBOUM3T2x5VGRaQWF3c3lQMmlFNEZ3ODVVWmJabEFlTWp6?=
 =?utf-8?B?VWRvQTdlV2NSa1I1eEpNalBrS1Z1aEcwT2xoc2NzUEErMTMxMnd5TVE4UU9T?=
 =?utf-8?B?aC82UXFheThvTUhod0RZd1FDYTZXTGhOZ1VTaTNtM2RMUTRDcDJ4cXZRaSs5?=
 =?utf-8?B?UnBDT1hNeEdGK0YvUm1wWmk5MUFPVTlOZUdlbGc4SVBydUJKZDUwNnR3NGo3?=
 =?utf-8?B?SXRCMnh3dkFxNjN1MWtOdlRqQUZ1Mmh1YkpjRTJNWEhLRHdzaUZIQWt1THZo?=
 =?utf-8?B?dUNNanVTNGdLTmxCdkxreFo3UjhwUmwybG9TeHc0QXQwLytGZWc1a2R0MjFG?=
 =?utf-8?B?ZnR1L2R5aXNpenhuaWIwM1JvdENINXZkcDg4Vy91L0poZlJjWE5VbWExaHJD?=
 =?utf-8?B?QmxwdmlrVS9zNG1kQzkvbloycEQwWmdyTmI3d3VhM0Z5MGVuVTVqYkR3ZzNi?=
 =?utf-8?B?MEg5MU5vMmxPOXhKRlZFSTliYkFQYk9OcHBXTEgxb3ZKdDdzWUFpRitjOEZT?=
 =?utf-8?B?cHpYRGZSVFp2TFF6NXZRMWFoRXBKOUNVdzdOYldPYmFNOHI3ZmJ4VHFlMlZh?=
 =?utf-8?B?VVQ4WWhzNm51Qk4rcE52V05ZanpiRlRKYTdlYXJkcjJFSmtHNFBxQ1h5Z0tv?=
 =?utf-8?B?K2ExVjNwYWxld1IxdTU3N0k4OVNQYmpzWHFPZUJkQVAwZVJCYlFybjlxWFhv?=
 =?utf-8?B?MDNNR3JpMWhnK3VQNzFmd3NVbFhjYTJKOWhzV0NQeHBGV3FhU1hUVzhmU1NO?=
 =?utf-8?B?bTNTSWRIdWh3Vnh5S3FYZ0VEQ3RGejg3TVZOTHhFcjcxRkc5b1BOT0dZZDBz?=
 =?utf-8?B?R3k5a1VyUGw0WnJheUQxVkNSL29ocUN0Um82SnIvQ25hei93blAyemdDa204?=
 =?utf-8?B?Qnp0SU9tUFdEMjF3WlBweDVSWm1JMkJ5Z2hkMFRNcHNTN0dsZHNPZnZ3OU8z?=
 =?utf-8?B?UVd0VXV3Q0xzdERUd1phUEJCb3dNTWFqbEtTSUtpTXVQTjM1MFNwSE1qWGdl?=
 =?utf-8?B?cEgxeWJKZDRVNy8yV3lqTDIwSGdlNVluQ211MWhBVnQ3RU1BaDdHUDZVNmIv?=
 =?utf-8?B?NWhQVXJVY1paYUlTN3NmcGw0eExUdzFRVXcvZ3cvV0dlNHJKNzNyNnNhdHpr?=
 =?utf-8?B?UVgwVEczTGFxZkw1VG5WRFJ3SHp0MDg2Z1ZNNW9YWTRnVC93TCswTGxIRnR2?=
 =?utf-8?Q?qEkhfmksbg9uRvCRDA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afa1ad2a-c22f-490b-00b9-08deb0b5b16e
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 06:05:54.7641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EXOyYUVq+n5hECCyZaBhVrOvW/QUeym5uXpz/Zx8TSI7oVO2W4C97KsO9FZ7AMMAqgkN70BRKuvrFBL6EZTv+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4314

Hello,

On Wed, May 13, 2026 at 01:31:00AM +0200, Peter Schneider wrote:
> Hi Greg,
> 
> Am 12.05.2026 um 19:36 schrieb Greg Kroah-Hartman:
> > This is the start of the stable review cycle for the 7.0.7 release.
> > There are 307 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> Trying to build 7.0.7-rc1, I get this build error.
> 
> In file included from kernel/sched/build_policy.c:62:
> kernel/sched/ext.c: In function ‘bypass_lb_cpu’:
> kernel/sched/ext.c:4019:35: error: ‘donor_rq’ undeclared (first use in this function); did you mean ‘donee_rq’?
>  4019 |                 if (task_rq(p) != donor_rq)
>       |                                   ^~~~~~~~
>       |                                   donee_rq
> kernel/sched/ext.c:4019:35: note: each undeclared identifier is reported only once for each function it appears in
> make[4]: *** [scripts/Makefile.build:289: kernel/sched/build_policy.o] Fehler 1
> make[3]: *** [scripts/Makefile.build:548: kernel/sched] Fehler 2
> make[2]: *** [scripts/Makefile.build:548: kernel] Fehler 2
> make[1]: *** [/usr/src/linux-stable-rc/Makefile:2108: .] Fehler 2
> make: *** [Makefile:248: __sub-make] Fehler 2
> root@linus:/usr/src/linux-stable-rc#
> 
> The offending line seems to be part of eb5b997dadc517 (sched_ext: Skip tasks with stale task_rq in bypass_lb_cpu())
> Adding Tejun and Andrea to CC.

The upstream commit (da2d81b4118a) was written on top of ff06f727a941
("sched_ext: Move bypass_dsq into scx_sched_pcpu"), which renamed @rq to
@donor_rq (among other things). That refactor is not in 7.0.y and it's not
stable material.

I think The minimal fix is to rename donor_rq -> rq in the backported hunk, in
7.0.y the function still takes struct rq *rq directly, and that is the donor rq.

Greg, can you fold the following into the queued patch? Do you prefer a
separate/updated patch?

Thanks,
-Andrea

 kernel/sched/ext.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index 3cb8025b433e0..2bb7c7a902679 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -4013,10 +4013,10 @@ static u32 bypass_lb_cpu(struct scx_sched *sch, struct rq *rq,
 		/*
 		 * If an earlier pass placed @p on @donor_dsq from a different
 		 * CPU and the donee hasn't consumed it yet, @p is still on the
-		 * previous CPU and task_rq(@p) != @donor_rq. @p can't be moved
+		 * previous CPU and task_rq(@p) != @rq. @p can't be moved
 		 * without its rq locked. Skip.
 		 */
-		if (task_rq(p) != donor_rq)
+		if (task_rq(p) != rq)
 			continue;
 
 		donee = cpumask_any_and_distribute(donee_mask, p->cpus_ptr);

