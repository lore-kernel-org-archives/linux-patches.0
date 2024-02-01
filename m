Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2D56ADB
	for <patches@lists.linux.dev>; Thu,  1 Feb 2024 16:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706805286; cv=fail; b=ku5qYvavyDd5dAMR0YB2dZFtQXk7qa51X4QaIv1Sg4p9hN2g9WJ2eVXfw2LuGKyK03AUttd4Wn3uJIW/g3jQszZ0tvlx0JCk43yqlS7apU5bUJoc+xA+VKBANgNjE+J03OU4teT1xsynl5g71Rkp0XPmVQRDJtJWJp6ybFmGcxQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706805286; c=relaxed/simple;
	bh=QWe97XKagHJ11Vs69JfNxOMqf/ByGSR5kCSc92gGz2s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FUM0/X9/3uBQrEboT97zCrlvAP8H8fQlSx8uDCjX2qRNaDZl3h+5eH7iugIflpcEQk1Xw9q6Y2KHDkoyZV7/cWslLnHIWTTbRPMnTU9k0zgCEbObJGCDbjTfSdbYWaaeGy+ffC25L3pGaCYjxlxcfMhTfxMx8E9o9e8X+lbZlIo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ODletsov; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ledjrc9S; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ODletsov";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ledjrc9S"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 411EFVWa015481;
	Thu, 1 Feb 2024 16:34:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=Qx9876YchNVPGoaRmySYHO4Dh9W50AXgU/2fc9m5k58=;
 b=ODletsovZBys69O9hPw7OlVCeJW8akygPecRfAlZV4ZIvaiMoSrTKlFpn+COzlMecgpv
 YgwbKb9omS7mbuwq3Zp4Z8Uq/Dxa2My2lW7yLngjGlkrcGuApX0U5UxXpueFxAwX2uAb
 msvGcXtfUEFD4eIDqcnHlkpl8fpzX5ApCr/ZVFfQzNdsovxIA39hO/l4+6Ecscip7d0T
 DfWi5WdPjbq4x/rkIPVJIeuOfnWnNwRZ3UU1kY+FfbwzwIzU8OxIRA0Mb6529sHpGU2n
 4VELUFfSVYUpWrQu2IhY5nRsQeA4UZQjtaJc495edR7r3PpfVza1BmLL0vt+KPQqLc67 iw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvtcv56c3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Feb 2024 16:34:37 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 411FVJ9g016268;
	Thu, 1 Feb 2024 16:34:35 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr9gw4ky-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Feb 2024 16:34:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oHGQhTfxyGGwyZ+joBlBH28turrhIrx0qInzdc3p7kjC3aT/sxwfsDF5S7A325hgBYTYqCoG8jrd6nqfjWb5bbQWJ2rQe3zwDMaCW2HpN04q1svnoWgTaEffjJYBy0jTjjirFssbEmGsiWd6JxMpSf+QBAl++xE/y3CJA2c4C13PUsHlJqmtMetYZa/tjKbN2qsJFr3Og2EVbfFz0n7+FlPuLiFF5GNDSHyMrd2gxMgxPD9j1sxJYsupS80kW5ReFKynHeoXjF7ZeB0xsK85zrPlbMirsbP6/9tjGa93bhZyoVd9rpoDWuBXrL0gQzr78tljpj/MQPKSYD59K/+IWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qx9876YchNVPGoaRmySYHO4Dh9W50AXgU/2fc9m5k58=;
 b=BqSwBDYu/KpNnFHy9mXzuWIKPMhEi4LaIWBWadw5y6RIvHpC5ubyBKCMNiHQnwCHgHXqnWbPJtSEmUYGgPiTlJbU1qqOQ0x+vS1FMsl35kDyaQyYN3FNMBppaDIQ/QsfguGPgBFChpDkZw8ZASLK+k42f57/dQy+v89Dt3mh9pDrnWNCVn7rk2Xu0Lm5j5GU2mHIDVPi+WBsiC4axYoXs0ZnXpkr3oBMwZj8VsSZ+C3msL51WzfT7IHMSMU8evLDE7aN3TIf4bHLh2xU5yIwT/CmyibKI65mIwfoolS0dD48243HE6PeNpqt+NjD7UwdUpOCzj0Yurwsgx50rmq6MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qx9876YchNVPGoaRmySYHO4Dh9W50AXgU/2fc9m5k58=;
 b=Ledjrc9SBHxu2eAzda+NsdIVKqYKVQPzxSgTR39J3mDtewpcnJgIj0gWeKDNnBqi9t6XgAAlY22CyeSCX3yq61S0dNi2hkD0LJ2aOkJnqPCYKUdij6iHYk2PqHZwrQ2IrZNGvhsy8GwMswxFCNy/rMpP4pbWIbRCxRPkznMcwVI=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by DM8PR10MB5397.namprd10.prod.outlook.com (2603:10b6:8:39::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.28; Thu, 1 Feb
 2024 16:34:30 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::2e34:ae4e:d7db:ab33]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::2e34:ae4e:d7db:ab33%4]) with mapi id 15.20.7249.025; Thu, 1 Feb 2024
 16:34:30 +0000
Message-ID: <1a160e5f-d5ce-4711-b683-808ab87b289b@oracle.com>
Date: Thu, 1 Feb 2024 17:34:25 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 003/331] docs: kernel_feat.py: fix potential command
 injection
Content-Language: en-US
To: Justin Forbes <jforbes@fedoraproject.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, stable@vger.kernel.org,
        patches@lists.linux.dev, Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <20240129170014.969142961@linuxfoundation.org>
 <20240129170015.067909940@linuxfoundation.org>
 <ZbkfGst991YHqJHK@fedora64.linuxtx.org> <87h6iudc7j.fsf@meer.lwn.net>
 <CAFbkSA2tft--ejgJ58o3G-OxNqnm-C6fK4-kXThsN92NYF8V0A@mail.gmail.com>
 <2024020151-purchase-swerve-a3b3@gregkh>
 <CAFbkSA25o88DjaWHc3GRk5vkvANnpi-NJ61XJudz4=ARTyrhtw@mail.gmail.com>
 <CAFbkSA3M74kvF+v_URm593xSnJTVzeKmy2K6dw0WQYw7BDdwmg@mail.gmail.com>
 <CAFbkSA3vHDn-Pk9fB6PbWeniGHH6W3bo=jQ9utE9xh88S8bzxA@mail.gmail.com>
From: Vegard Nossum <vegard.nossum@oracle.com>
Autocrypt: addr=vegard.nossum@oracle.com; keydata=
 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 8A==
In-Reply-To: <CAFbkSA3vHDn-Pk9fB6PbWeniGHH6W3bo=jQ9utE9xh88S8bzxA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PR1P264CA0029.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:19f::16) To PH0PR10MB5433.namprd10.prod.outlook.com
 (2603:10b6:510:e0::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5433:EE_|DM8PR10MB5397:EE_
X-MS-Office365-Filtering-Correlation-Id: 81d66f3f-2999-4986-d1e5-08dc2343a9d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	SxI4dKWoLuKL8fRFmO91N54dQmu+AVnUH2iBpSORJaxyEyMm2I0F1IvuGh8Kapw0XHJvJ6URjrp+gzckes4y2rgrqFCkEJuj+oSTIuaAx2gqViwb2LnkNdDog00IBX1cIlGqm4ZaiQ9VrFi+qpNFAcorTLn9vuud8eLNa+fT0NamtDs+7svsdCmo/d4danFt2Qif24TNIXt+38ONwAu33RNBa5ber4I/Oobn01DzGWU0AxkeAd2KkQ7/bvGDT3WRGlHGElJqVdfGTDJDJDBgyjSSgEgJknUuKDJ2i+YkvdTGHLGdnUdPssYC1qnpoP9rAGTUDFL14//qMv0rs1Mq5Kujxsg+WARkcUACmmE7YYySWukRhWqP3dPbpOQEBESPO+SC5TXkKCiUQwV+LwRtbsQM8GftvFcu/brG2Wz1h8aoETACdoZKy0CgMyV52hZQIM/a9rVq6a/xdt1IyrLGZ4HOfKBIcl+a+KQehHRWnGI0Kr26Ks4+MbGPbe7psmRDiCe8DSOPlev7KZj1XLoytoPqKQCj4cab/gjHozuKPwfpyHtqny5VzIYa+uUTmtn2yFsD0W3c3WjhKgOqdfVSg1baMnfcBuRGUoBu4rfN5a0quIGmLq9Xbl59aTPSO4zXWquC3PRRPXuNmF/o9XfkvL8MfkBgu12dTI9d2A6Q0W8eplPH8Z+RwHlRLkdSiD3q
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(346002)(366004)(136003)(376002)(230173577357003)(230922051799003)(230273577357003)(1800799012)(451199024)(186009)(64100799003)(31686004)(83380400001)(36756003)(86362001)(31696002)(41300700001)(2616005)(26005)(38100700002)(6512007)(6506007)(6486002)(2906002)(478600001)(53546011)(66946007)(66556008)(110136005)(316002)(66476007)(6666004)(54906003)(4326008)(44832011)(5660300002)(8676002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?NFZ2T0JKa0thZmlrNEV3bzF0Z0U1c2NINlQ3WC9GUStkWVYvcEtrbEpjSjE5?=
 =?utf-8?B?MVNxQkZsUUMzOWhXY01uWlpBV2prZk1RMTAzc1JuSksxS25rMFZFYlhweGJD?=
 =?utf-8?B?ZjVpSXJ0RjVFL1NPTlljeEQ3dXo2cjl2Zjlzem9wMk1IblUvMjAyY2hORzcz?=
 =?utf-8?B?M2xkK2VVc3Zid1ljcUxKSGhRMDhxZVg3THdSWG9CeVpYcVNzM1ltc0lUUkdV?=
 =?utf-8?B?VVFYeGh1S2d3VDBlMHBKdVJvUCtrTGxwUHhHSjJpTUJQOUtoNEQzM2FSZFd3?=
 =?utf-8?B?ci9SdGFLTGw5UEFLYWlPT3FNTTBOVVF4R1lUVnU1SWp5SVBxOW1XTUw1akhK?=
 =?utf-8?B?dGh5V1dqV2VMenhEaUcvaERVaDlyZXVzTGoxRThSSXRCVDFXdnJDbG1xeVc0?=
 =?utf-8?B?bjFoa0NZVTZiWlFZVzZONHNyVENRWlRwclh4OTE1b29YTGdrSGlkVlhPM1Fi?=
 =?utf-8?B?VE5mcmRHeVc5M3czcGtnY1VZNHNyMkhLR3hXUkdaTkhKSGcvNWRabHFUaCtI?=
 =?utf-8?B?amlzWlJIQjRGM01TLzJ3QjJLYklRbGpSdFdhU2dDZTVGWSsxSUJ0L2JLNGVY?=
 =?utf-8?B?Y1ZySDdVRmk1Rkt5YmZvdEhRU1BUMmVFYmFNRExSM1ByUmR6ZkJuOUlzYTdG?=
 =?utf-8?B?WFRoWktLWGttRUdkdnZESnRIajdReDRsSHJEcG0rNTNoQmVTenUxckJQWnNt?=
 =?utf-8?B?VnNCTnBBaWdRck13RFRLOE9UcjhWUjZIM3l1d0dZakFUbHcxbWE1UkdCYjg2?=
 =?utf-8?B?czZ3dkgrREN0SWl1K2VaNHBVcTcrMnpDSzNmYTE2dTJyR2pUVGpPeGplNTll?=
 =?utf-8?B?MW1LSGxjeHl0VjViWmg4NUgzaHdMZFlpbXhNRXBOZlY2NzA3YVFac1NRNS83?=
 =?utf-8?B?OEJUVjVVb0p0ZU1USWNHcVJnY2xlV1BBR09Tai9EekQvcWhwb1ZLRnlmbGFL?=
 =?utf-8?B?OXpGZlB6N0MxeW8yYXAxN1cyTytPdkZIcUhaQ1ZvQkRiNWJrMk9mUXIwa3Yw?=
 =?utf-8?B?eEFsTlMxK1VFY040Q3dWZ0twbWFoOXhPQ2lONWlYOXBMSG9PcW1BRTcwQldR?=
 =?utf-8?B?UGtKaWxqbjdnSGt6aVZUVDZ1VGtuQjFTMXVadWh2Zm1TNVE3U09iRlhQUThk?=
 =?utf-8?B?U08rZVBDTjV5VEQ4cVNLbFlINXc2RHlpK1VuK21sd1gvZEdOUUhLaEhxeHZw?=
 =?utf-8?B?ak9lSDFxZkhWWXpSMEVkMFZySlYwdVVDRCtKQi80R0ZaSGl6Y09GdnEvdjJE?=
 =?utf-8?B?ZUJZeTN5TlVIVkdlVEhTY1UzWThWUkJGeDdTTmtlbzhqWXEvUlpXeDc4U21t?=
 =?utf-8?B?RVEwU25TMDEvYko1WmREOFYxdXZHS1JTY1llWXFQZFd3bGRhSXR6eFRjUGNy?=
 =?utf-8?B?bmZsOVIvVWdPRjR5akZtcGdmNXpjZjY5ZExMYm0rb1BGQ1lpSmFvTnFOamx2?=
 =?utf-8?B?VmY1dWN2Tzh1aUsvWVJlRDVYYkRyM2lFNXlWVldWZ29zcE9GNFF1akZ4WlM1?=
 =?utf-8?B?M2dVUTBNN2NDUGszMmdwSUIvWkxNYUxiT01nbXM0MnJUZ1FvdGhMZjIwRkxJ?=
 =?utf-8?B?L25iTzhvMndkMWk1RFJvZE9GSG1xVFpUWUd4YTNMM3lINk5jbWZucUN6bWF3?=
 =?utf-8?B?dU0xVmtKTVZrSU03WGpNQjlhSytoWG5FaDhFYjBQNE40SDhQZ1FyeUllL1ho?=
 =?utf-8?B?V1ZCV01XeEJpd25KQ0pwQkZMdVM5WGFES2c1UjRVVkpqY0tPUFVLWUxVVVNE?=
 =?utf-8?B?bHpCSC9oNVRXb0tLVkN4MUhnMHN0S0dPcUg3UlgvclBEYUhkc0c0OUs4Njdr?=
 =?utf-8?B?SElRYzFyRnlQMXcyRkErZmRna2FjMHk0RG5oSnNTWGV0QXZTSGR6eWcvVFRH?=
 =?utf-8?B?YVdydjNVM3RKczhFbXlMWXUxczVJUFMzcnRTVXM2WDhzanpxazFQeTJGRGtH?=
 =?utf-8?B?ZWdYdlhiZm5CNVM1NU03QzdCczlUZmk0WGpRQmxyZnIwM3dCTjZqYXA2WGRw?=
 =?utf-8?B?elJWMTFOc2FUemtNYlI4VFhEUjYzelB6ZmdESm16dG5jVy9wMytrN09IeldC?=
 =?utf-8?B?eERDV1NQd1ZlMXgreGhHUUhncGZJd0hnVlRoaSs2MHR4alhHMTJQbm5yeGw1?=
 =?utf-8?B?QXdJNmNpeXA4cXNFZGxvbHF4QnpkWWVyMndyQTFBMHJRN2tUTUpTbXNnYnFZ?=
 =?utf-8?B?ZWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	ehzSfd9vwnQIjDoXgH6NaqWhDT6dIJCShxUSO2IO0oqV+VlNw0ekA2fI1B0s9wVGv70MMJQRo+lLvqKfx+zTA8wqV3eYxoao7xHcZQi0P5OwmT57fDitF5EHCXxECmrYuGMMfTFGC7m74R9Tz9kdQ8KP8B8/MhO10vKc09ZW2XH6P0d29R3KZ+k8i19J7PNwG+w3Nq+q73H/kGmvH+wVOkwsNLYWnUKJOIP0xdjIRw7JaZfgDYJtxhNibF0jY8o/axjPmvngbevn8Is/MaJW6ajfIye/eIFn78NGtsoaEKhV0Ap3vrCtr5TfmLzrHteoIoFDR7i7e7wPgkFzyVM2ku4xLkPZE/dEBGor5N0Y0BEYCHy+2cVu5HRLA31GsbUr0Qi931SZsqmZJ9WTBLij7kiu4bSvo1dMXINgaOcGPOhQYG7Z3Xz4SzXgXooT7rtsCWtQpUiCsjIgPtaZXjy1kCAprQjIAoHqNFRcYtRIsVCHz4505YEFzYjOswaT4l75HxWxK2JhdLzQ6Y29jHL1fBrEp1smLt+Nf6VseH7tse2I9xhRVG1ZCbm8rT+rfcofxQk/JArRPXTu4+VZBli2IywyTUd1CBODhB7No+aZyjg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81d66f3f-2999-4986-d1e5-08dc2343a9d3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2024 16:34:30.1585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AhkMEhl4tHnEkc6z1VrDxSBl5YKC+cHUVldtzVhcMg8VcyvHWOh9edGx9tvHq1XWRalt92AUkFZh8TDqW7YwgyxXDCa99QaA+egmr1zE6ro=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR10MB5397
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-01_04,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402010129
X-Proofpoint-ORIG-GUID: r4uAIvRb3cgokSBEMCen6Z8PwKWHmhGg
X-Proofpoint-GUID: r4uAIvRb3cgokSBEMCen6Z8PwKWHmhGg


On 01/02/2024 16:07, Justin Forbes wrote:
> On Thu, Feb 1, 2024 at 8:58 AM Justin Forbes <jforbes@fedoraproject.org> wrote:
>> On Thu, Feb 1, 2024 at 8:41 AM Justin Forbes <jforbes@fedoraproject.org> wrote:
>>> On Thu, Feb 1, 2024 at 8:25 AM Greg Kroah-Hartman
>>> <gregkh@linuxfoundation.org> wrote:
>>>> On Thu, Feb 01, 2024 at 06:43:46AM -0600, Justin Forbes wrote:
>>>>> On Tue, Jan 30, 2024 at 10:21 AM Jonathan Corbet <corbet@lwn.net> wrote:
>>>>>> Justin Forbes <jforbes@fedoraproject.org> writes:
>>>>>>> On Mon, Jan 29, 2024 at 09:01:07AM -0800, Greg Kroah-Hartman wrote:
>>>>>>>> 6.6-stable review patch.  If anyone has any objections, please let me know.
>>>>>>>>
>>>>>>>> ------------------
>>>>>>>>
>>>>>>>> From: Vegard Nossum <vegard.nossum@oracle.com>
>>>>>>>>
>>>>>>>> [ Upstream commit c48a7c44a1d02516309015b6134c9bb982e17008 ]
>>>>>>>>
>>>>>>>> The kernel-feat directive passes its argument straight to the shell.
>>>>>>>> This is unfortunate and unnecessary.

[...]

>>>>>>> This patch seems to be missing something. In 6.6.15-rc1 I get a doc
>>>>>>> build failure with:
>>>>>>>
>>>>>>> /builddir/build/BUILD/kernel-6.6.14-332-g1ff49073b88b/linux-6.6.15-0.rc1.1ff49073b88b.200.fc39.noarch/Documentation/sphinx/kerneldoc.py:133: SyntaxWarning: invalid escape sequence '\.'
>>>>>>>    line_regex = re.compile("^\.\. LINENO ([0-9]+)$")
>>>>>>
>>>>>> Ah ... you're missing 86a0adc029d3 (Documentation/sphinx: fix Python
>>>>>> string escapes).  That is not a problem with this patch, though; I would
>>>>>> expect you to get the same error (with Python 3.12) without.
>>>>>
>>>>> Well, it appears that 6.6.15 shipped anyway, with this patch included,
>>>>> but not with 86a0adc029d3.  If anyone else builds docs, this thread
>>>>> should at least show them the fix.  Perhaps we can get the missing
>>>>> patch into 6.6.16?
>>>>
>>>> Sure, but again, that should be independent of this change, right?
>>>
>>> I am not sure I would say independent. This particular change causes
>>> docs to fail the build as I mentioned during rc1.  There were no
>>> issues building 6.6.14 or previous releases, and no problem building
>>> 6.7.3.
>>
>> I can confirm that adding this patch to 6.6.15 makes docs build again.
> 
> I lied, it just fails slightly differently. Some of the noise is gone,
> but we still have:
> Sphinx parallel build error:
> UnboundLocalError: cannot access local variable 'fname' where it is
> not associated with a value
> make[2]: *** [Documentation/Makefile:102: htmldocs] Error 2
> make[1]: *** [/builddir/build/BUILD/kernel-6.6.15/linux-6.6.15-200.fc39.noarch/Makefile:1715:
> htmldocs] Error 2

The old version of the script unconditionally assigned a value to the
local variable 'fname' (not a value that makes sense to me, since it's
literally assigning the whole command, not just a filename, but that's a
separate issue), and I removed that so it's only conditionally assigned.
This is almost certainly a bug in my patch.

I'm guessing maybe a different patch between 6.6 and current mainline is
causing 'fname' to always get assigned for the newer versions and thus
make the run succeed, in spite of the bug.

Something like the patch below (completely untested) should restore the
previous behaviour, but I'm not convinced it's correct.


Vegard

diff --git a/Documentation/sphinx/kernel_feat.py 
b/Documentation/sphinx/kernel_feat.py
index b9df61eb4501..15713be8b657 100644
--- a/Documentation/sphinx/kernel_feat.py
+++ b/Documentation/sphinx/kernel_feat.py
@@ -93,6 +93,8 @@ class KernelFeat(Directive):
          if len(self.arguments) > 1:
              args.extend(['--arch', self.arguments[1]])

+        fname = ' '.join(args)
+
          lines = subprocess.check_output(args, 
cwd=os.path.dirname(doc.current_source)).decode('utf-8')

          line_regex = re.compile(r"^\.\. FILE (\S+)$")
