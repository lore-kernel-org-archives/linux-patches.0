Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C6412FB08
	for <patches@lists.linux.dev>; Fri, 17 May 2024 17:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715968016; cv=none; b=hfqecMfkEDCv5+KddtWsPYPmzqpFCY8v/uqZpQBSoZ6Q2WTFh0mPoikUQK7ebDqmnOshCd7EjaFKD8T9tn0Xeg6PtJIv7+qsK3ZTzsgT3QZTTEiK8bdGak/a2vRibhSK3P0Sti5j7Do2qCB71/LNL1lpkNlp+02AqYkECL271og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715968016; c=relaxed/simple;
	bh=XjAWJ2eqX/XHZTMD+zOyCsPctyAoSmWyVzHoUM4DzkM=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=HvCApo0rLETFFDCwOPhr9dqL9lamHuUtgaYhH8szMmoIJS9hH9EIA2R6V28QvL3bsXQbN+pQ3WZrea6IEF360QVIdOSwwqCnrBiUJ0OhFpSltzoGlBUnPlYa9QGWseVcu+8hzuGfpouc9v2gkIXRe+qoTR70t8PEloce1GA9cFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=AUU1gPvX; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="AUU1gPvX"
Received: from [127.0.0.1] ([76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.17.2/8.17.1) with ESMTPSA id 44HHZXiO2560155
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Fri, 17 May 2024 10:35:34 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 44HHZXiO2560155
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024051501; t=1715967335;
	bh=3toScG2epOvz4S6GlSaLW07fm+7T68oT6n8TgjNdwTc=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=AUU1gPvXKMtDVJygcCQcgezfmNVTmjtzgmb1YoFNkKhpgzpf9HQMjm+bb+PbYPcrv
	 4tmA2dww/zGyOsGPZP2GsDOitxS3ejFZ0zfa+79ErbIy3eYg8qDz1bAfCJ6nckm6qc
	 SQ8C1u5Wk4gW2tJJL6Zjd92w7dDO9gm0MuHOai1rKwirG1jCCKywdVdMKvIMugTfW2
	 aNMqLHmCWWdQBrtl6357Cf6hwaKpMskRsVw0DmQCguSm/quTtnQMyJRGnbYCvfA7G3
	 ThDGb/GHyK1KE84BRSidn2BFTpzUtJ4dE3SZ2qhSDfOIGvGODyXxUoss2bQabbVjMN
	 168WjfggeI3/g==
Date: Fri, 17 May 2024 10:35:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Uros Bizjak <ubizjak@gmail.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Mateusz Guzik <mjguzik@gmail.com>,
        Thomas Renninger <trenn@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        patches@lists.linux.dev
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2=5D_x86/cpu=3A_Fix_x86=5Fmatch?=
 =?US-ASCII?Q?=5Fcpu=28=29_to_match_just_X86=5FVENDOR=5FINTEL?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20240517144312.GBZkdtAOuJZCvxhFbJ@fat_crate.local>
References: <20240516162925.79245-1-tony.luck@intel.com> <20240517144312.GBZkdtAOuJZCvxhFbJ@fat_crate.local>
Message-ID: <863D0F06-1217-4C94-B2CA-816FC4ABB103@zytor.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On May 17, 2024 7:43:12 AM PDT, Borislav Petkov <bp@alien8=2Ede> wrote:
>On Thu, May 16, 2024 at 09:29:25AM -0700, Tony Luck wrote:
>> -#define X86_VENDOR_INTEL	0
>>  #define X86_VENDOR_CYRIX	1
>>  #define X86_VENDOR_AMD		2
>>  #define X86_VENDOR_UMC		3
>> +#define X86_VENDOR_INTEL	4
>>  #define X86_VENDOR_CENTAUR	5
>>  #define X86_VENDOR_TRANSMETA	7
>>  #define X86_VENDOR_NSC		8
>> --=20
>
>From my last review:
>
>> But the Intel vendor has been 0 for what, 30 years?
>
>> Are you sure no other code in the tree relies on that? Audited?
>
>But nope, apparently that's too much to ask=2E :-(
>
>modinfo =2E/arch/x86/events/intel/intel-uncore=2Eko
>filename:       =2E/arch/x86/events/intel/intel-uncore=2Eko
>license:        GPL
>srcversion:     ECE38449B18DD83223B93FD
>alias:          cpu:type:x86,ven0000fam0006mod00B6:feature:*
>alias:          cpu:type:x86,ven0000fam0006mod00AF:feature:*
>alias:          cpu:type:x86,ven0000fam0006mod00BE:feature:*
>			     ^^^^^^^^^
>
>Would everything still work if it said "ven0004" now?
>
>So tglx and I just did some poking and we think the best solution would
>be to add a __u16 flags field to struct x86_cpu_id right=2E=2E=2E
>
>struct x86_cpu_id {
>        __u16                      vendor;               /*     0     2 *=
/
>        __u16                      family;               /*     2     2 *=
/
>        __u16                      model;                /*     4     2 *=
/
>        __u16                      steppings;            /*     6     2 *=
/
>        __u16                      feature;              /*     8     2 *=
/
>
>        /* XXX 6 bytes hole, try to pack */
>
><--- HERE
>
>        kernel_ulong_t             driver_data;          /*    16     8 *=
/
>
>        /* size: 24, cachelines: 1, members: 6 */
>        /* sum members: 18, holes: 1, sum holes: 6 */
>        /* last cacheline: 24 bytes */
>};
>
>and the 32-bit version has the same hole:
>
>struct x86_cpu_id {
>        __u16                      vendor;               /*     0     2 *=
/
>        __u16                      family;               /*     2     2 *=
/
>        __u16                      model;                /*     4     2 *=
/
>        __u16                      steppings;            /*     6     2 *=
/
>        __u16                      feature;              /*     8     2 *=
/
>
>        /* XXX 2 bytes hole, try to pack */
>
><--- HERE
>
>        kernel_ulong_t             driver_data;          /*    12     4 *=
/
>
>        /* size: 16, cachelines: 1, members: 6 */
>        /* sum members: 14, holes: 1, sum holes: 2 */
>        /* last cacheline: 16 bytes */
>};
>
>And then do:
>
>struct x86_cpu_id {
>        __u16 vendor;
>        __u16 family;
>        __u16 model;
>        __u16 steppings;
>        __u16 feature;  /* bit index */
>	__u16 flags;
>        kernel_ulong_t driver_data;
>};
>
>#define X86_CPU_ID_FLAG_VENDOR_VALID		BIT(0)
>
>and then have the macros in arch/x86/include/asm/cpu_device_id=2Eh set
>that valid flag and then have x86_match_cpu() check it=2E
>
>Then you don't risk a userspace breakage and that x86_match_cpu() crap
>thing is fixed=2E
>
>Thx=2E
>

I'm confused=2E Why not simply use say -1 for wildcard vendor match, -2 fo=
r no vendor ID (no CPUID or other known probing mechanism) and -3 for unrec=
ognized vendor (vendor detectable but not known=2E)

If we have a match/valid mask, I would suggest that we have *separate* mat=
ch and valid masks, so that we can explicitly encode the condition of "no v=
alid vendor", but in the specific case of vendor, there are two conditions =
(see above=2E)

I *hate* these strings with the passion of a thousand suns: they are a cla=
ssic case of how just blindly converting binary information to hex adds abs=
olutely no value, and often makes the result worse than what one started wi=
th=2E And yes, I complained about that when they first went in as a classic=
 case of exposing what was always simply intended as a kernel internal inte=
rface to user space=2E

This is particularly pathetic as there already is a canonical string repre=
sentation of the vendor ID!

Similarly, kernel internal CPUID feature numbers shouldn't be an API, we o=
nce again have canonical strings for the API level=2E=20

But of course, now the module utilities depend on them, and although they =
are relatively tightly coupled to the kernel, it still would require a stag=
ed transition where the legacy strings are included for some time=2E=20
