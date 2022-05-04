Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1146F2596
	for <patches@lists.linux.dev>; Wed,  4 May 2022 16:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651682949; x=1683218949;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XgnIB32z7qUvHsCrG4EC+nxq+bdr/MlnPMwSNazn4/M=;
  b=ViWl1RxcAaRxJ78xram/uSaH3cqVv/NfKVcVYTxsM927Aql5c2OvuUkb
   GpTfDPSrNsDQ76VOl2zFWG7OHanlk9cwZ+VMNm7lPvGYK2EW+1eFgCEx4
   X+kBe3Gm8TFh+gCFKME5G6T5kZTZO+Em+IaKqzH325D/ODwi4yOOpcBCJ
   R1U5BadjjtBU8v8ug298jBhcyBjnXuabKXJCjX997G+U/CYREi5Gyo4mW
   OyoTgAhw5Q/6aRASTYfAmsNf11cr7gDKpIjb59+t2hW1n4lu4TGPu+MT+
   8XMyZQkNTKasYDx0NLHIesKDgKOgYKIkI1yLUxQxkXw78n2uTbln4F84R
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10337"; a="267706391"
X-IronPort-AV: E=Sophos;i="5.91,198,1647327600"; 
   d="scan'208";a="267706391"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 09:49:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,198,1647327600"; 
   d="scan'208";a="562808144"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga007.jf.intel.com with ESMTP; 04 May 2022 09:49:08 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 4 May 2022 09:49:07 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 4 May 2022 09:49:07 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.027;
 Wed, 4 May 2022 09:49:07 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, "hdegoede@redhat.com"
	<hdegoede@redhat.com>, "markgross@kernel.org" <markgross@kernel.org>
CC: "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "corbet@lwn.net"
	<corbet@lwn.net>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>,
	"Joseph, Jithu" <jithu.joseph@intel.com>, "Raj, Ashok" <ashok.raj@intel.com>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "platform-driver-x86@vger.kernel.org"
	<platform-driver-x86@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: RE: [PATCH v5 04/10] platform/x86/intel/ifs: Read IFS firmware image
Thread-Topic: [PATCH v5 04/10] platform/x86/intel/ifs: Read IFS firmware image
Thread-Index: AQHYWxYW3hJGAbUOoU6LIs4KNS99IK0PBS8A///rt6A=
Date: Wed, 4 May 2022 16:49:07 +0000
Message-ID: <f36faedeb6144ba491d1fda27e6bfaaa@intel.com>
References: <20220422200219.2843823-1-tony.luck@intel.com>
 <20220428153849.295779-1-tony.luck@intel.com>
 <20220428153849.295779-5-tony.luck@intel.com> <87wnf1k2gv.ffs@tglx>
In-Reply-To: <87wnf1k2gv.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.401.20
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

>> +	ret =3D request_firmware_direct(&fw, scan_path, dev);
>> +	if (ret) {
>> +		dev_err(dev, "ifs file %s load failed\n", scan_path);
>> +		return;
>
> Why is this not returning an error to the caller?

There are three call sequences that lead here:

1) CONFIG_INTEL_IFS=3Dy
    At boot this is pretty much guaranteed to fail (unless some crazy perso=
n includes the
   scan file in the initramfs). In this case there isn't a useful caller to=
 return the code to.
   In this case the driver init routine must ignore any error to make sure =
the sysfs reload
   file is present to load the scan file once the file system is available.

2) CONFIG_INTEL_IFS=3Dm module load time
    Same code path as built-in ... so must ignore a failed load here too (u=
nless there is a
    way to distinguish the built-in vs. module execution environment).

3) echo 1 > reload
    Hmmm. Some older revision did return an error ... but I seem to have fa=
ctored it out
   during cleanups. Limited to standard -E???? error codes. The reload_stor=
e() function
   can just check whether the load succeeded by looking at ifsd->loaded ins=
tead of a
   return value from ifs_load_firmware()

So, I will fix case 3. But probably by checking ifsd->loaded rather than by=
 adding a return
code to this function.

-Tony
