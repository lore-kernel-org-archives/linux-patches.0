Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB889367D
	for <patches@lists.linux.dev>; Wed, 16 Feb 2022 18:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645037890; x=1676573890;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=woJ79QUOPww2RdC3yoNTSEvnC9MvtlpZsdBYk2iQ8f0=;
  b=epFAFpJJIB5Ujz6Qei9Cd7sbNbbbZ0KmuVQXPX4HY7H93hxXVSurBPjk
   Sst0EmAUMqHSQcF/Rui7JPPUWFIuzJJ+9eR9BL7zL7HB4NPcN1PZFR1mL
   iCz7r/OC/wZi7G5VOXbOcJR0Am6FTe3pWumTctgd2Lxs1TZL+4CJLDhkV
   bqFtIm0Tfsf+baiis92UDvdF3CkZIdisEz+SmNCyIuv+0q8L2GZmqZemJ
   0Iq5Yv7O/BeSI0Hfp957y2AMGe5XUsHyADpalEA6DidmMrx5eQozrnAgc
   OMdzGXDCg2qFEevnu5nYOdgMu0s04ul9i5b30/kM77Vy9uWx/No+4V4Yw
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10260"; a="230660663"
X-IronPort-AV: E=Sophos;i="5.88,374,1635231600"; 
   d="scan'208";a="230660663"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 10:58:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,374,1635231600"; 
   d="scan'208";a="681639816"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga001.fm.intel.com with ESMTP; 16 Feb 2022 10:58:10 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 16 Feb 2022 10:58:09 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 16 Feb 2022 10:58:09 -0800
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.020;
 Wed, 16 Feb 2022 10:58:09 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: Jue Wang <juew@google.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH] x86/mce: Add workaround for SKX/CLX/CPX spurious machine
 checks
Thread-Topic: [PATCH] x86/mce: Add workaround for SKX/CLX/CPX spurious machine
 checks
Thread-Index: AQHYHP3vSEwGqGB1nUuCa46AJSTbFqyVvVCA//99xQCAAVDKgIAAWhMAgAAlCgD//4KmEIAAi1IA//97AGA=
Date: Wed, 16 Feb 2022 18:58:09 +0000
Message-ID: <7931e48318d64e808a2ccb30ab6f7995@intel.com>
References: <CAPcxDJ7nriZEJHF6dMPR7tQ+dGuueyRjw1NC+4CbjxiAT_S+ZA@mail.gmail.com>
 <20220208150945.266978-1-juew@google.com> <Ygwka++3eipjQzB2@zn.tnic>
 <YgwnqTc8FGG3orcE@agluck-desk3.sc.intel.com> <YgzRsfWOmqkNiNI7@zn.tnic>
 <CAPcxDJ4=iknzYbN=b2oQxvJyODkQ_MWEj1wkKEuGwf4HQ3aPZA@mail.gmail.com>
 <Yg08Uhg0fZ9xZuP2@zn.tnic> <9f402331d25c47b69349c8171bbd49c1@intel.com>
 <Yg1ICgHfMYxwHyig@zn.tnic>
In-Reply-To: <Yg1ICgHfMYxwHyig@zn.tnic>
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

PiBZb3Ugc2hvdWxkJ3ZlIGxlYWQgd2l0aCB0aGF0IC0gdGhpcyBpcyBiYXNpY2FsbHkgb25lIG9m
IHRob3NlICJ1bmRlciBhDQo+IGNvbXBsZXggc2V0IG9mIGNvbmRpdGlvbnMiIHRoaW5ncy4NCj4N
Cj4gQW55dGhpbmcgYWdhaW5zdCBtZSBhZGRpbmcgdGhlbSB0byB0aGUgY29tbWl0IG1lc3NhZ2U/
DQoNCkFkZCB0aGUgdGhyZWUgY29uZGl0aW9ucy4gTm90IHRoZSAiR29vZ2xlIGhhcyBiaWxsaW9u
cyBhbmQgYmlsbGlvbnMiIGpva2UuDQoNCi1Ub255DQo=
