Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE0E4C9C
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 18:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668449627; x=1699985627;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hxEkQbuK0QMuKu1CziKwj4cVOaJutws2LHKgFPOQBT8=;
  b=KXzqJyDjfRk5K8JlVdQeBH5yc9van4V6su0NCOZoigb2/NT/9ofLxZ4r
   MHlrqP5uq6Zs9WS88+OfF0eVHd6Qrd3Ir9vSVXKrIzF2vpUPhOHRLDspf
   qP8mFHhw/NwyDu/TDSYmzxmnESoLTkvDl9/4nc7/2kiSm9EfMcJJWUGcv
   XGGMnQAJt+LzItUs+e1vu0n8My+Obqc6oaEanFOdNTCojqgSsbSuIZxTg
   KlPfDbMqBzGgy1f3CLnpx+9eq2AVZe/dHmCdwBv+PL2rbqGGrGt5SedAZ
   9UAe4pLfwOIvpIJqmGHCF3opDzh3hqzThRBca6iFmoESoAYUuG5O/20tF
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="295405462"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="295405462"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 10:13:46 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="781028079"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="781028079"
Received: from satyanay-mobl1.amr.corp.intel.com (HELO [10.209.114.162]) ([10.209.114.162])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 10:13:45 -0800
Message-ID: <45aa0f69-2523-3cba-8f41-b1351f16b78f@intel.com>
Date: Mon, 14 Nov 2022 10:13:44 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2 12/14] platform/x86/intel/ifs: Add current_batch sysfs
 entry
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>, Ashok Raj <ashok.raj@intel.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
 Thiago Macieira <thiago.macieira@intel.com>, "Luck, Tony"
 <tony.luck@intel.com>, "Joseph, Jithu" <jithu.joseph@intel.com>,
 "hdegoede@redhat.com" <hdegoede@redhat.com>,
 "markgross@kernel.org" <markgross@kernel.org>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "mingo@redhat.com" <mingo@redhat.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>,
 "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
 "Jimenez Gonzalez, Athenas" <athenas.jimenez.gonzalez@intel.com>,
 "Mehta, Sohil" <sohil.mehta@intel.com>
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
 <20221107225323.2733518-1-jithu.joseph@intel.com>
 <20221107225323.2733518-13-jithu.joseph@intel.com> <Y2/JNAmSoYlLKq3A@zn.tnic>
 <CC3629D6-B205-4150-80E5-FC7A7A76DD25@intel.com> <Y3CevK2zhAmiUyG9@kroah.com>
 <Y3DZmKYV+8HBtZ+Q@zn.tnic> <Y3EJ93xzgC/1v0WV@a4bf019067fa.jf.intel.com>
 <Y3EUPKWDefnkeObR@zn.tnic>
From: Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <Y3EUPKWDefnkeObR@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/13/22 07:58, Borislav Petkov wrote:
> On Sun, Nov 13, 2022 at 07:15:03AM -0800, Ashok Raj wrote:
>> Do you expect the /lib/firmware/intel/ifs_0/ to contain *ONLY* files for
>> this platform? For microcode we have everything in the public release
>> included here.
> Same as microcode, as I said further down in my mail:
> 
> "And, ofcourse it would check the format of that string against family,
> model, stepping and sequence number (btw this way you drop your
> limitation of 256 for the sequence number which you don't really need
> either)."

Maybe dumb question, but what's the point of even checking the
filenames?  They're meaningless.

Let's say we're on model=1,family=2,stepping=3.  We try to load test #99:

	01-02-03-99.scan

The kernel goes and does the sscanf() and checks "01", "02", etc...
Everything is fine.  The header checks on the .scan file are OK.  Life
is good.  No harm no foul.

Then, some dastardly user does this:

	mv 04-05-06-99.scan  01-02-03-99.scan

Taking an evil model=4,family=5,stepping=6 .scan file and trying to load
it.  It will *pass* the sscanf() checks.  But, will fail the metadata
checks.  The kernel wasted the effort of requesting the file, but
there's no harm to anything.

So, what's the point of the sscanf() to check the *filename* other than
saving some potentially expensive request_firmware() calls?
