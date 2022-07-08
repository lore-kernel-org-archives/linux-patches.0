Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969787A
	for <patches@lists.linux.dev>; Fri,  8 Jul 2022 18:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657305289; x=1688841289;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SE5Bg0Jro2Cvof++20x91wH1WQxU/lxKwGLnVfTqkPg=;
  b=E8Rx5GmJmTDCGuJ9SZmKPb0e+TxrLcvgWxLZhOcnuOQl9fzgLBx17RXh
   cOLQ/dQ/Jp2Ct9R8VZk87W0ctBUlN4TkqMuwL4RlDTDf0XMU49aaE0pkU
   ppmjndyfZEfUU/N4i8BWON2eExO9GyDAeOAkFSa62Whx5eTXYFdeq3IaK
   r7OU25inbA5LqJPyAW76o/h0gI7YzV79AVikyWRk3MvUw+Ht6jSe+0XcT
   5aBp2uT1vFIiv8mLihaUw/xTSGDvF+XQifm+PeYXCSXtWUkrXpI2tw8gu
   X/qBgEhfwL4Nbso+boY12kG+tTuUQHg4bjXioLiKMC4dFsnaxcZmTftrS
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10402"; a="264754528"
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="264754528"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 11:34:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="696969803"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 08 Jul 2022 11:34:45 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 8 Jul 2022 11:34:45 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 8 Jul 2022 11:34:45 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 8 Jul 2022 11:34:45 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 8 Jul 2022 11:34:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XnZv9wcGiUkbTx7ozm+9lc9mPE+fMjUq2gCw3lqgZLgQKRGfuZt1+hycmTrvDo8wiMho3KXvFgRiDM6T/X4Ymbqvz7JKx7+YLecrVHPwdZcruOivrsoWurdjrCIWZOqG+7uMoB6PfFNfNyD02MJ7wY4hs7O+6B26agufZYgmPaWoswGwCYNjXGalNic9Og9NTIA56MGMI6pZon7EfAtSz3/nM44tFcWx5pggfj7LLs6NW0stdnjXNHGMVCXLIm2RUZA1LZ6ff3j99mMcrwogAr7vlz0rHrMnkh6N5F+EERjyUADxZId7dZ0bHCATfTyyUJgVmlCjxkayVlEMGU+2QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ndolebY8fwKEmnQZvOLGt0qbRlQ5KxARazCWZnkg/MQ=;
 b=XwFOU23jcWV5+eGCgvedavxqsdPLH1CMfFvm6NrLGXCk3Eg0U8GzSND9qJ7HNdMIXUyEB16QxekpHwfZY2Gu1bljls9swCN4F77MBZpoRt1y0ADszcB9wXMLGGKO2c5i2DYL+Pt22Hn1SMz5DPhbY33+kop89tpSnOTLIA27EWPIvaxm7h9WFpOb9QM0esSkCKDuv+cTeKx56OiBqh3+5+5hYPUYdUBK2jKLzIQnllEVn6d7tRe3tes0hiPY3vo8AtVHFSdQsXUwt1//EjImG5z3R3TJYsIqgoWEHvMWFTTOQVCZlmebGDfr3+ua5baO/BtCHtHPeumEkjtZNuwc1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3768.namprd11.prod.outlook.com (2603:10b6:a03:fa::20)
 by BN8PR11MB3780.namprd11.prod.outlook.com (2603:10b6:408:90::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Fri, 8 Jul
 2022 18:34:43 +0000
Received: from BYAPR11MB3768.namprd11.prod.outlook.com
 ([fe80::f43b:140f:a945:c4a8]) by BYAPR11MB3768.namprd11.prod.outlook.com
 ([fe80::f43b:140f:a945:c4a8%3]) with mapi id 15.20.5417.017; Fri, 8 Jul 2022
 18:34:43 +0000
Message-ID: <33a6193e-1084-ae5f-1f80-232274f71bd0@intel.com>
Date: Fri, 8 Jul 2022 11:34:40 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] platform/x86/intel/ifs: Allow non-default names for IFS
 image
Content-Language: en-US
To: Greg KH <gregkh@linuxfoundation.org>
CC: <hdegoede@redhat.com>, <markgross@kernel.org>, <ashok.raj@intel.com>,
	<tony.luck@intel.com>, <ravi.v.shankar@intel.com>,
	<linux-kernel@vger.kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20220708151938.986530-1-jithu.joseph@intel.com>
 <YshNAh6awfPFmxzU@kroah.com>
From: "Joseph, Jithu" <jithu.joseph@intel.com>
In-Reply-To: <YshNAh6awfPFmxzU@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0068.namprd07.prod.outlook.com
 (2603:10b6:a03:60::45) To BYAPR11MB3768.namprd11.prod.outlook.com
 (2603:10b6:a03:fa::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 640dddbd-af53-4bb1-ee19-08da61108665
X-MS-TrafficTypeDiagnostic: BN8PR11MB3780:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E/wTFsJw0w0l3r6KFUTTsHD2sa2K353U06F/aUr4kDx8H0fe+ej05I4va9779q2geU8MR0Ur3m9md2tYxRz92Zz5RB1BsSlqcCsvnyGV1/zc+2f4yg4NgXeR6EO8VH6aJ5/GLPS6/Q8WkpC/qDveWb6XN53zPrx0+Gc4RFdQ0sdMYciE7wYjThi+wpgSBloUo6ouSnbsNNPeY8N8MU+Bbm4DZXCvOajbQe114IGbfZmDGDy1XTp9XGPNVGNCjI3/ZYq0Qe+CfQoj6D/yqUGYkgVJPCA9tpKinj8pZppPgMD83+uZvd78ixzBd/NNhm5vCiaXr0aSHzPbZWYCOu1kVP3XEXmOo9ItExUfp4TArkITiY2srXdYzTtJIUoDdfVGomH01zNfrtV7I6TAp//XMjnN42ciZSqTcdxyy7iThCxeglFmWhmUUEah0q8Ovs6I9kfXhjdm7Gnvt8q+to4tHo2zBN1gm2Bz0e6CZavaI+DPjXa2vC64AmELlYpPLb17X42HU5Oi54h+TFW1dcmn3Zbd2gToeYx2pc6+9J4Dlae/jznN7VBPy2biImm1JMnc/to6WUv6Kgoi1RTZ12Z/krpM+PH/IsGi/BI3Qo7tHkfASXR9NG8mLtypmMhuyBDTyCmX5HKnIcRSO0k0LQJdOEVqZXpSgJAI/EHd48j75jT88FoQlOnzV708JibCxklw1B1joA9iSFV8xsvOqD01FhfFzskBSND+OXWDoRGfkLSgfAtWE2iOAbJmrFBzG2pX/nCX9yiNbXrC04bQxQDyxifpMjZ9YEFxj2ig7eQzw2TFtpd18DgIv1HIUkRPX31vAtmy6i43Cs3RUTG0JOmK6Zr/u0ty6j911dpX0znjI0k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3768.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(346002)(366004)(39860400002)(376002)(83380400001)(5660300002)(53546011)(8936002)(478600001)(26005)(31686004)(6506007)(6512007)(66946007)(6486002)(41300700001)(6916009)(31696002)(86362001)(186003)(38100700002)(36756003)(66556008)(8676002)(4326008)(82960400001)(66476007)(316002)(2906002)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M0pOQThDZDZVUnhDOCt5dWovT0crWmpiTTBsVGtncXAwbThHVnNwS3dCVGR2?=
 =?utf-8?B?VTd6bzhEM0JjdmJyaTRxRjZjaDZSR1VFcHMwWDdnVDVSY0hCdm9PS09TVU10?=
 =?utf-8?B?Qlo2SUtNdlR6SHQ1bzE4Y2Uwdlp6S0tnNWlkR040aHpmbTNYRlpBYkdUcFJ2?=
 =?utf-8?B?ZG96VEQ4VHl1NGVaTnRXVjExQUhHNnNibUlaRHlYZWFnN1JIUlBzanM3RXp0?=
 =?utf-8?B?aC9LTUdQRUVRZHBDWWh1VTVRVW5GTGlBSVByeFZoYVR2WlpUeGt2NHRDYmdB?=
 =?utf-8?B?UUpVMFRmN3A5ZGVHc2ZWeG1ORnVMVk5hVDVGMFBJYzVaaWFPQ3VHSVQ0VlRw?=
 =?utf-8?B?cm1MSXdyMndnSG9MblhTOEMzNHVyblZ0TXdpWFNObktiQTN6TXUxNytsRjQx?=
 =?utf-8?B?ZHNPYnZ5cWRMT0xDWElNckxMOHBROGNGc1U4T1UrVXZRaXdlaUZFMTBIV3FE?=
 =?utf-8?B?VmZ4cW9IOFNHYmx3Z0JxV2JhcXc2cGlDM2xybkw1empuZzlnbmZUM2pETDlN?=
 =?utf-8?B?bnVhZ1NuOU85b0N2TmNka3lCb1BveTEzZjBhdkw1aEFPaEZYOGZkeVlPcFNw?=
 =?utf-8?B?bElpUnMxYWRvZVZQQkFYK0c0TklHc2NCdmR4UnphQnhSRm01ZTBqaWtyZHJU?=
 =?utf-8?B?VDh2b01NcGNBaVVIek14RHJMQkhPNjhUaHc3L0NmL3hrMUs2NWdaLzIwbTRU?=
 =?utf-8?B?RjQzODBZSFQyM1RXeXNvRDM0dlEzL29lUlg3R0o4S09WRmREQ3oyMUlXNm1l?=
 =?utf-8?B?d1ZtYmZHZ1ZtRitGOEhycVlpcHF1WThXOElJbXA3TmpiN0U1SEsvQjUvRlR3?=
 =?utf-8?B?TWVQZDFLU2ppaDhINXpXN2hUb3RSTFR2NDBGNERxNmdkR1g2eWNYR2NxQmgx?=
 =?utf-8?B?K2NBNklqS0M3d0xCd1lHb1B6Y1BJU2RhaThpbTJxYnh3d3VYcEU5ZTdoUXps?=
 =?utf-8?B?dnJhdGFzQzhZamZHQmlPanRtcXl5Ymc4cHhsd2sxZ2k0cFVNMXNadVJWNWcz?=
 =?utf-8?B?VUgyeE1HRkQ3Z1llbDNYYmYwa0pnTUFuUWk1bytBd3krRzZIM0tpOUpZQTFS?=
 =?utf-8?B?TFkzYXV0alpmK3U5RUZ3d3dVVnRZU2t3ZzZQM2YyYXZhNzA3K3Y0S3p1V2lD?=
 =?utf-8?B?eDhMV0xBdXNZWG1PNFdJSVJHRTN4RzM0UHpyRDd5VC84Qkh0eGdQSWpId2c1?=
 =?utf-8?B?QXg2c1VXZEo0MmNoUG9lTFRpajhISE9acDJCMFRMdnJraUNQTW1DeVpyOXg1?=
 =?utf-8?B?UVNzL0Rka3lMdzJPb3d4NXV4MFJ6Z3l4N1MxUFhXWXVoS0xkOXRZd2N3TGJK?=
 =?utf-8?B?d2hLTUxBNUtwSjIzbUZ2RmtJeEgwcjVnc0FUaWF3c0tFTDM5bnVqN3E1dmlI?=
 =?utf-8?B?aWNiVWNpZ3EvZFk1b0hIdWptQnFJanRVazhQTG1aNjIyYjhMQVZUSWxSamp2?=
 =?utf-8?B?YTR2dE9ZNmpGWkY1Y09XUzZlM0FIU2pQVEZPdVkvM0tvUGRaQmc2R3J3NjV4?=
 =?utf-8?B?MHJSRlhHL2NjRTk0YlNTOHBYUHZtRjAxczBVRmI1QnhFRnV0Nlp5bUU3TjVB?=
 =?utf-8?B?bjdyNFU2VlZVYWtVQUEwWk5GT3lCc0lKVXVGekJVZHpGaGZPOHpCQUpLNzV5?=
 =?utf-8?B?TlRhYjVKZ3o0RE9KckR0b0FtU2tqalA5NU1FYUY4bGVvMVFHS1Y2ZzZvdjVM?=
 =?utf-8?B?cUdaTmNud3A5N0ZSV0h6V1pzUjlkODd4bTFrU3pCNjVlS2xVenE2dERPNTds?=
 =?utf-8?B?S2N4SkZXbFVYSEwwNnV3dU5veFp2a0FiU1psZm9zZUVncC9yS015bXltWXZh?=
 =?utf-8?B?aTRsU0hwKzBwZlVhQkxMWEpjb1hYV2tybzQ3L2svTWs5bGcrSUFNUGlDRTVa?=
 =?utf-8?B?T3VDZ0VwUThqYjNUUytYSVRsWWtlSGxUZXNjTndHc2NPeEpEWjJRU3p0V3lZ?=
 =?utf-8?B?RlRvN1JzaUl6M2tOU2JncnExSlFUckJraU1jSnhYSXBTbDBtVEVyZ3dIczR4?=
 =?utf-8?B?UXhPZlF1MlM2aVp4a2RFUHBKdzlBNllRT1c0WnduYy9lQmZ5NnhNaVBpTmtL?=
 =?utf-8?B?aHBPVVd3TnQ0UjdlMDcybzZTdklJaVdyMlJBNzIyTnE2TVRUTkE4TnB2VHBH?=
 =?utf-8?Q?vUB/FGgHjQ2C0BhkHHmutxBi1?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 640dddbd-af53-4bb1-ee19-08da61108665
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3768.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2022 18:34:42.9638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ze5PFTQ+Tvi7Pvmgm7F5Ma0lAcvrWzeloUw8DlbZiRZnxbZvI2jodJmcReF7JmiSqzpgo00vNTfBjf08/Sg1Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3780
X-OriginatorOrg: intel.com



On 7/8/2022 8:28 AM, Greg KH wrote:
> On Fri, Jul 08, 2022 at 08:19:38AM -0700, Jithu Joseph wrote:
>> Existing implementation limits IFS image to be loaded only from
>> a default file-name (ff-mm-ss.scan).
>>

> 
> Ick, but now what namespace are you saying that path is in?  If you need
> debugging stuff, then put the api/interface in debugfs and use it there,
> don't overload the existing sysfs api to do something different here.

The namespace related confusion could be because, the original commit message
was not using full path-names. The below write-up tries to be more clear on this

Existing implementation limits IFS images to be loaded only from
a default file-name /lib/firmware/intel/ifs/ff-mm-ss.scan.

But there are situations where there may be multiple scan files
that can be run on a particular system stored in /lib/firmware/intel/ifs

E.g.
1. Because test contents are larger than the memory reserved for IFS by BIOS
2. To provide increased test coverage
3. Custom test files to debug certain specific issues in the field

Renaming each of these to ff-mm-ss.scan and then loading might be
possible in some environments. But on systems where /lib is read-only
this is not a practical solution.

Extend the semantics of the driver /sys/devices/virtual/misc/intel_ifs_0/reload
file:

  Writing "1" remains the legacy behavior to load from the default
  ff-mm-ss.scan file.

  Writing some other string is interpreted as a filename in
  /lib/firmware/intel/ifs to be loaded instead of the default file.



> 
>> Fix the below items in adjacent code
>> - Return error when ifs_image_sanity_check() fails in ifs_load_firmware()
>> - Correct documentation "ifs.0"->"ifs"
> 
> That should all be a separate patch, you and Tony know better than this.
> 

Noted ... will send this separately


Jithu
