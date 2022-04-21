Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020CB4699
	for <patches@lists.linux.dev>; Thu, 21 Apr 2022 04:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650515202; x=1682051202;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Z7jdM6pq07KjbTcwuki1ZSctHuXY7XcN+eSmZWx0l0M=;
  b=OVoxiNyhu1bl6kke2UVKc//21WEaeiNT3enWu0xLD4T/qo4tjUXZ3HJs
   cUboHTQYLv5MJ1ndTZk1oBswGjM7JnD6uo/AZfZ8Vpd6ERfagCs8g/JO3
   U6ogEigWi8brbbfReFTofj6NUS9TYbGYIX60pbliY2vpCaWrIhpB9j1AH
   2OfYFlm46oYuAokO3U+c5eCwkuCJ2S6bj2Q0zUixtiPRcjWgjblepHqfs
   amTx6anpjofiXnJtQSDhO+uJzb6g85GL1em/oNFZEdYVL/CBSTSxkT3dl
   K+f+/c3aBIVHgQbZHDZk5lN1GACIsslvPBHqasy+2nDkvVO9fomHMpbke
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="263698017"
X-IronPort-AV: E=Sophos;i="5.90,277,1643702400"; 
   d="scan'208";a="263698017"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 21:26:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,277,1643702400"; 
   d="scan'208";a="727803522"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 20 Apr 2022 21:26:40 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 20 Apr 2022 21:26:40 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 20 Apr 2022 21:26:39 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.027;
 Wed, 20 Apr 2022 21:26:39 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: "hdegoede@redhat.com" <hdegoede@redhat.com>, "markgross@kernel.org"
	<markgross@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "corbet@lwn.net"
	<corbet@lwn.net>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>,
	"Joseph, Jithu" <jithu.joseph@intel.com>, "Raj, Ashok" <ashok.raj@intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "platform-driver-x86@vger.kernel.org"
	<platform-driver-x86@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: RE: [PATCH v3 10/11] trace: platform/x86/intel/ifs: Add trace point
 to track Intel IFS operations
Thread-Topic: [PATCH v3 10/11] trace: platform/x86/intel/ifs: Add trace point
 to track Intel IFS operations
Thread-Index: AQHYVAv/GMu0aAF5oU2sc2NlODgUPKz57MaA///Yp0A=
Date: Thu, 21 Apr 2022 04:26:39 +0000
Message-ID: <adc49af263e2464f86b20ccc2d8f184d@intel.com>
References: <20220407191347.9681-1-jithu.joseph@intel.com>
	<20220419163859.2228874-1-tony.luck@intel.com>
	<20220419163859.2228874-11-tony.luck@intel.com>
 <20220420193839.6e9d810b@gandalf.local.home>
In-Reply-To: <20220420193839.6e9d810b@gandalf.local.home>
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

>> +TRACE_EVENT(ifs_status,
>> +
>> +	TP_PROTO(union ifs_scan activate, union ifs_status status),
>
> Really, you want to pass the structure in by value, so that we have two
> copies? One to get to this function and then one to write to the ring
> buffer?

These "structures" are just bitfield helpers for a u64 that is passed into
WRMSR (in the case of activate) and received back from RDMSR in
the case of status.

So this is really just a pair of u64 arguments, with the compiler handling
the bit field extractions into the ring buffer.

Here are the definitions:

union ifs_scan {
        u64     data;
        struct {
                u32     start   :8;
                u32     stop    :8;
                u32     rsvd    :16;
                u32     delay   :31;
                u32     sigmce  :1;
        };
};

union ifs_status {
        u64     data;
        struct {
                u32     chunk_num               :8;
                u32     chunk_stop_index        :8;
                u32     rsvd1                   :16;
                u32     error_code              :8;
                u32     rsvd2                   :22;
                u32     control_error           :1;
                u32     signature_error         :1;
        };
};

Would it be better to do the bit extractions of the start/stop fields first=
?

-Tony


