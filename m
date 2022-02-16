Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA5E367A
	for <patches@lists.linux.dev>; Wed, 16 Feb 2022 18:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645036920; x=1676572920;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xDWjGvsFBrq0ZdxBzAcydsP/AMMl02rxok1sZdO6bbI=;
  b=eCHADF1nbV2Oi+Bg6dvDXLyUWkOQizz63Ahp0BMSeD2wViFwcjWcuKtt
   8aceZ8DiMlZNjStj6eVnMqGBylc22Y4bo/mjkVIEHRP8euz0KHNZeS1i5
   oYHH/pf9PE3Mp891IKEsk/oHQfF654QVSY38Ca119Rs0/p0S6sL2u+RRY
   QFVXUCpgQo9gqc0qsRONtRkGyvZGZLLTicH/q1eMneOe7YJwRXAYIJn3M
   jiN1ShS38NpgSSc8AYBBWEqGQ59w/bjvR7GhwD1FW1iMz4bnEgod/Euje
   wHxt2bR2/CKRV03OyBU/kgukRYHdY1HlQCMCU7qi2MscrcQbOp9iNsDRE
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10260"; a="311439425"
X-IronPort-AV: E=Sophos;i="5.88,374,1635231600"; 
   d="scan'208";a="311439425"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 10:42:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,374,1635231600"; 
   d="scan'208";a="774185960"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga006.fm.intel.com with ESMTP; 16 Feb 2022 10:41:59 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 16 Feb 2022 10:41:59 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 16 Feb 2022 10:41:58 -0800
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.020;
 Wed, 16 Feb 2022 10:41:58 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>, Jue Wang <juew@google.com>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH] x86/mce: Add workaround for SKX/CLX/CPX spurious machine
 checks
Thread-Topic: [PATCH] x86/mce: Add workaround for SKX/CLX/CPX spurious machine
 checks
Thread-Index: AQHYHP3vSEwGqGB1nUuCa46AJSTbFqyVvVCA//99xQCAAVDKgIAAWhMAgAAlCgD//4KmEA==
Date: Wed, 16 Feb 2022 18:41:58 +0000
Message-ID: <9f402331d25c47b69349c8171bbd49c1@intel.com>
References: <CAPcxDJ7nriZEJHF6dMPR7tQ+dGuueyRjw1NC+4CbjxiAT_S+ZA@mail.gmail.com>
 <20220208150945.266978-1-juew@google.com> <Ygwka++3eipjQzB2@zn.tnic>
 <YgwnqTc8FGG3orcE@agluck-desk3.sc.intel.com> <YgzRsfWOmqkNiNI7@zn.tnic>
 <CAPcxDJ4=iknzYbN=b2oQxvJyODkQ_MWEj1wkKEuGwf4HQ3aPZA@mail.gmail.com>
 <Yg08Uhg0fZ9xZuP2@zn.tnic>
In-Reply-To: <Yg08Uhg0fZ9xZuP2@zn.tnic>
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

PiBXZWxsLCB3ZSBjb3VsZCB0cnkgdG8gZGVjb2RlIHRoZSBpbnN0cnVjdGlvbnMgYXJvdW5kIHJJ
UCB3aGVuIHRoZSAjTUMNCj4gaXMgcmFpc2VkIGFuZCBzZWUgd2hhdCBjYXVzZWQgdGhlIE1DRSBh
bmQgcGVyaGFwcyBwaWNrIGFwYXJ0IHdoaWNoIGluc24NCj4gY2F1c2VkIGl0LCBpcyBpdCBhY2Nl
c3NpbmcgYmVoaW5kIHRoZSBidWZmZXIgYm91bmRhcmllcywgZXRjLg0KDQpJcyB0aGlzIGEgY2Fz
ZSBvZiAicGVyZmVjdCBpcyB0aGUgZW5lbXkgb2YgZ29vZCBlbm91Z2giPw0KDQpJdCBpcyBhIHJh
cmUgc2NlbmFyaW8gKG9ubHkgYSBwYWluIHBvaW50IGZvciBKdWUgYmVjYXVzZSBHb29nbGUgaGFz
IGJpbGxpb25zIGFuZCBiaWxsaW9ucw0Kb2YgY29yZXMgcnVubmluZyB0aGlzIGNvZGUpLiAgWW91
IG5lZWQ6DQoNCjEpIEFuIHVuY29ycmVjdGVkIGVycm9yDQoyKSBUaGF0IGVycm9yIG11c3QgYmUg
aW4gZmlyc3QgY2FjaGUgbGluZSBvZiBhIHBhZ2UNCjMpIEtlcm5lbCBtdXN0IGV4ZWN1dGUgcGFn
ZV9jb3B5IGZyb20gdGhlIHBhZ2UgaW1tZWRpYXRlbHkgYmVmb3JlIHRoYXQgcGFnZQ0KDQoJV2hl
biBhbGwgdGhyZWUgaGFwcGVuLCBrZXJuZWwgY3Jhc2hlcyBiZWNhdXNlIHdlIGRvbid0DQoJaGF2
ZSBhIHJlY292ZXIgcGF0aCBmcm9tIGtlcm5lbCBwYWdlX2NvcHkNCg0KLVRvbnkNCg==
