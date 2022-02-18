Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F041F28E5
	for <patches@lists.linux.dev>; Fri, 18 Feb 2022 17:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645207125; x=1676743125;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/ZZ8b31Er7R5CNT7Q792VI7QvRSKMZXQ4IsgRjHYIS0=;
  b=gv7YI9TItgUtNAwFWjirV8TFN9Px9GcRXYK2uItLDCgZa85bVrkCKo2k
   uqFVV02xbhEje3KAWRDrZchrXZiSHcd/RLdgxsTJOEYvEzH3D1MyFa7sn
   OGZ9vQCb93wbtlHxUFPDn/bTpq5/veTD/ynCskoMHjyBEMAoweqBiHL0Z
   2nBo8zmkOK1nkqtbf6YLe42R0zFR4vSAO40xG7Bz7dnsegi7BegJh6tKr
   yH9becP8jnnaUfAT6SgK3zfARVFyWsiMjcI7My9Z/idD4tZTACd8eS2I0
   xEZpfVUNWcDtq4C9frzKUJwX/rxWcoqAzm/Bct35bFR9OOUFaiES5R0Qb
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10262"; a="234712615"
X-IronPort-AV: E=Sophos;i="5.88,379,1635231600"; 
   d="scan'208";a="234712615"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2022 09:58:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,379,1635231600"; 
   d="scan'208";a="682576532"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga001.fm.intel.com with ESMTP; 18 Feb 2022 09:58:43 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 18 Feb 2022 09:58:43 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 18 Feb 2022 09:58:42 -0800
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.020;
 Fri, 18 Feb 2022 09:58:42 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>, Jue Wang <juew@google.com>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v2] x86/mce: work around an erratum on fast string copy
 instructions.
Thread-Topic: [PATCH v2] x86/mce: work around an erratum on fast string copy
 instructions.
Thread-Index: AQHYJGdbPe82lm9eb0O/d1VFli+im6yZ77OA//+pYdA=
Date: Fri, 18 Feb 2022 17:58:42 +0000
Message-ID: <dca14efd34294fe1b58d21a230fe6f11@intel.com>
References: <Yg54nse5qNQO3sbW@zn.tnic>
 <20220218013209.2436006-1-juew@google.com> <Yg+2Hc78nfSRmh/j@zn.tnic>
In-Reply-To: <Yg+2Hc78nfSRmh/j@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

PiBBbHNvLCBUb255LCBJIHRoaW5rIHRoZSBjbGVhcmluZyBvZiBNQ0dfU1RBVFVTIHNob3VsZCBo
YXBwZW4gbGFzdC4NCg0KWWVzLiBUaGVyZSdzIGEgcmFjZSBpZiBhbm90aGVyICNNQyBjb21lcyBp
biBhZnRlciBNQ0lQIGlzIGNsZWFyZWQsIGJ1dCBiZWZvcmUgd2UgZ2V0DQpvZmYgdGhlIG1hY2hp
bmUgY2hlY2sgc3RhY2suIFNob3VsZCBtYWtlIHRoYXQgd2luZG93IGFzIHNtYWxsIGFzIHBvc3Np
YmxlLg0KDQotVG9ueQ0K
