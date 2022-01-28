Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E91F168
	for <patches@lists.linux.dev>; Fri, 28 Jan 2022 10:15:27 +0000 (UTC)
Received: from fraeml737-chm.china.huawei.com (unknown [172.18.147.206])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JlYBN5XyJz6892w;
	Fri, 28 Jan 2022 18:10:52 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml737-chm.china.huawei.com (10.206.15.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 28 Jan 2022 11:15:17 +0100
Received: from localhost (10.47.76.156) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Fri, 28 Jan
 2022 10:15:17 +0000
Date: Fri, 28 Jan 2022 10:15:08 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Ben Widawsky <ben.widawsky@intel.com>
CC: <linux-cxl@vger.kernel.org>, <patches@lists.linux.dev>, Alison Schofield
	<alison.schofield@intel.com>, Dan Williams <dan.j.williams@intel.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [PATCH 0/4] Unify meaning of interleave attributes
Message-ID: <20220128101508.00007da0@Huawei.com>
In-Reply-To: <20220127212911.127741-1-ben.widawsky@intel.com>
References: <20220127212911.127741-1-ben.widawsky@intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.76.156]
X-ClientProxiedBy: lhreml731-chm.china.huawei.com (10.201.108.82) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Thu, 27 Jan 2022 13:29:07 -0800
Ben Widawsky <ben.widawsky@intel.com> wrote:

> Interleave granularity and interleave ways can be represented either as
> absolute numbers, or as their encoded values from the CXL 2.0 specification.
> When region configuration and programming is created, it becomes important to
> differentiate these two things concretely.

Other than Dan's point about sysfs docs, this looks good to me so
with the assumption that those will be fine:

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

Great to tidy this up so we have one 'obvious' answer for how
these are stored.

Thanks,

Jonathan

> 
> Ben Widawsky (4):
>   cxl/acpi: Store interleave granularity absolutely
>   cxl/core: Add more decoder attributes to sysfs
>   cxl/core: Extract IW/IG decoding
>   cxl/acpi: Use common IW/IG decoding
> 
>  drivers/cxl/acpi.c      |  4 ++--
>  drivers/cxl/core/hdm.c  | 11 ++---------
>  drivers/cxl/core/port.c | 21 +++++++++++++++++++++
>  drivers/cxl/cxl.h       | 17 +++++++++++++++++
>  4 files changed, 42 insertions(+), 11 deletions(-)
> 
> 
> base-commit: e783362eb54cd99b2cac8b3a9aeac942e6f6ac07
> prerequisite-patch-id: 90de8aefc2999f55c7534fefa971d95653c4220c
> prerequisite-patch-id: 32a5b56d83bf3372b6ed4b40f621eafb33a7201b
> prerequisite-patch-id: f827831bb7a23e0789d16d7b8979b165253c6301
> prerequisite-patch-id: 08b8febd42d3ab508b618937473807e553589e36
> prerequisite-patch-id: 18049f47c948582c1dc26348d9765c934eb82a75
> prerequisite-patch-id: 8f66d52af297449fa007a0ba963c5239b153ef5b
> prerequisite-patch-id: 3e2e86cbc2631b99c1b5c0179f35799d3df31f91
> prerequisite-patch-id: b88becd4997320a34e918cdef1b620e6dea14917
> prerequisite-patch-id: c61df81018f2a93b87d10965b418afa659d9d6d6
> prerequisite-patch-id: 73b31df62e00bb7af7082e2ca4d40023a7962abd
> prerequisite-patch-id: 207abfcd5028c41df8875ee795a8ab697cd7c688
> prerequisite-patch-id: 26978f021b3b0f4a6734ef8c0100c724dc88742e
> prerequisite-patch-id: bf229ca5aab5c5dffe69ba5b9380749a66cf20ba
> prerequisite-patch-id: 20ebefe1acfdecf184d048cb605368e1863646c1
> prerequisite-patch-id: f34c26e902dd868dc1c3ef8ba8246cc063cf991a
> prerequisite-patch-id: bcc59db1c6528244b649ced35eab015699c410fa
> prerequisite-patch-id: 2f9f6cfbd6b73a563498c6b6d721bbc169a0a414
> prerequisite-patch-id: dc8fb216dc8ff4f813bfc689273d9c5f5124e789
> prerequisite-patch-id: da83e8074d339426c886c481070366afb189b561
> prerequisite-patch-id: 501fe71f19065ba9f31cabd86756fedda853c414
> prerequisite-patch-id: ceeef31c2ca85a426d507563b886347d28acc322
> prerequisite-patch-id: f876c09942ae5a3223a36329c23262a05b2669f4
> prerequisite-patch-id: 44fa61c5569614c8d9df854cde6fedfc2bc78c12
> prerequisite-patch-id: 04ad90e1bbb5646125c4633fbe5341f572bc9548
> prerequisite-patch-id: f4dbf89d99917f50c30e1ee56bfeff8d8dd6b0f3
> prerequisite-patch-id: 2d7c3aacefcb8133897e3256ed6f76952555c2f1
> prerequisite-patch-id: 7454df4bdb07381f02717845eb3b17011a89ab18
> prerequisite-patch-id: 52ec0dfd506bb6a3f8d11a914cfc7320193a6445
> prerequisite-patch-id: 9de14fa54cfba412e09d7b41f392c0f6d55d6a01
> prerequisite-patch-id: ae39a482c2067a1f04baee5ce9131901e6d359ec
> prerequisite-patch-id: 446240d2ed24d9e55ac9edfc65b511495659464a
> prerequisite-patch-id: ba6bf6450e47df5e95e2fb1780d9edd126bc0eb2
> prerequisite-patch-id: 3c0865b6dd062e677ef8e160e14f823622eafb9f
> prerequisite-patch-id: 4503f5507cbdeb0770b420b4c26d87be2b173813
> prerequisite-patch-id: c5a8cbda77c95b052040770eca0dc5b99876dc66
> prerequisite-patch-id: e064003a6c48131fac401d9a48d4d6204fea6123
> prerequisite-patch-id: b4c7213971c981dd5ca0fda992643a7c61548fef
> prerequisite-patch-id: 2bd09e27f8a8df144a8ad386822390c87ef46ec5
> prerequisite-patch-id: 60b3fafbd3bfa225405a6762bdb6b89c044b0b86
> prerequisite-patch-id: 620068ae417bf0784809107e0dae3ec9793632df
> prerequisite-patch-id: c3415fe92e29cd4afc508f8caf31cb914be09261
> prerequisite-patch-id: 4c01f305244036afa9aaa918c8215659327dd0f3

