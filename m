Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B982641C5;
	Fri, 14 Feb 2025 13:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739538131; cv=none; b=dEJ/M651NpJZGrsNYkJcMhn/KkDPsb+Q79WuCRgVD7NrXNDlLJ6bAQDJAe0hQAPA1hR9CKYNatyjk8++Uf1LD0vIXd4zcTEkXtO4hic6Keni6XWRp9j7HKG6hh+cEPcckM1pxANZIGK3WjogD2Kuuc+rfo8y1V9qclqLp3ZqNHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739538131; c=relaxed/simple;
	bh=jPFC/CXt6GIqWxOtYvQTRbjZqJ4fVPkJLkMYclM4tvM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QY0ueHfjPH1yE54pCeG1X9j+jMTc8CTWGEmd4XPSvsO+1swmev/GlJ4wlM+onGvW5RV9bcInd2D0EpdVK6gWlA8xjZTyYDoLzFZcDOH9JhdS8yNe1zJV/B2ochQ+UGRblPvNEQryOVslng+CvrH2YDSDBRxHBMGh/tYboUC96bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Uai4bzoc; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Uai4bzoc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8wSvMtFQcZjUPSELJlJNQC55nbU8FtST3XYdWaOnecE=; b=Uai4bzocQFjVhRo9PWFm4ANw2H
	wGYoNM5vTn8Sb6CH7IzbU5JlEny7tT3EiysiP5o0QllVIR5T8bCzBfXfaEFHb5VUTuloiVdpJUlm9
	fVn6eu0QYRkclihh10qoQd6gOnGWJ5ev6pYDbmBlBjGhcXWWf+gz0P0NkJJcxMBgiDwJO8mAax4FX
	1yFZceCLc1TCmRLjeyXwmnrLrF2PX8pw6gk80dhlzISi/vA2xLRFO58HGJsT7nJmYYakjTy0hWP6X
	JyPD84eUQVLFWShuBWIdwK2qoD3SaNK2OXvftoz3dBMdKo58MRlnoxcEAps4cHShIV9+u20Dsjkav
	ZPdn9NJw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tivKY-0000000BKap-07pa;
	Fri, 14 Feb 2025 13:02:06 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 9BD79300599; Fri, 14 Feb 2025 14:02:05 +0100 (CET)
Date: Fri, 14 Feb 2025 14:02:05 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
	"Hansen, Dave" <dave.hansen@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH] x86/cpu: Add two Intel CPU model numbers
Message-ID: <20250214130205.GK14028@noisy.programming.kicks-ass.net>
References: <20240923173750.16874-1-tony.luck@intel.com>
 <c8545ed5-b822-43a0-a347-d077bccf9d6f@citrix.com>
 <SJ1PR11MB6083F36D7C68AE8DF5AAA39DFCFC2@SJ1PR11MB6083.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ1PR11MB6083F36D7C68AE8DF5AAA39DFCFC2@SJ1PR11MB6083.namprd11.prod.outlook.com>

On Wed, Feb 12, 2025 at 04:09:11PM +0000, Luck, Tony wrote:
> >> +/* Family 19 */ +#define INTEL_PANTHERCOVE_X IFM(19, 0x01) /* Diamond
> >> Rapids */
> >
> > Is it intentional that this is not INTEL_DIAMONDRAPIDS_X like
> > Sapphire/Emerald/Granite ?
> 
> Andrew,
> 
> PeterZ wants to name based on core, not SoC (at least for mono-core CPUs ... this
> doesn't work for hybrid).  Argue with him.

Argh :-)

So yeah, its a trainwreck.

We used to use uarch, and that worked until skylake.

I'm not sure what exactly we continued as, but Kaby Lake was a Skylake
uarch.

The Atoms are uarch and still are, they weren't messed up.

But if you want to do DMR as PANTERCOVE then SPR should've been
GOLDENCOVE and we didn't do that either.


Also, since DMR is the direct continuation of GRANITERAPIDS, it should
also come below it.

Therefore, I'll concur with Andy that this is all highly irregular and
would propose we do the below.

Isn't the only reason we're doing a new Family because we can out of
module number space? It's not magically different from Fam6.

---
diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index 8359113e3e58..bf431dd4e271 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -115,6 +115,8 @@
 #define INTEL_GRANITERAPIDS_X		IFM(6, 0xAD)
 #define INTEL_GRANITERAPIDS_D		IFM(6, 0xAE)
 
+#define INTEL_DIAMONDRAPIDS_X		IFM(19, 0x01) /* Panther Cove */
+
 /* "Hybrid" Processors (P-Core/E-Core) */
 
 #define INTEL_LAKEFIELD			IFM(6, 0x8A) /* Sunny Cove / Tremont */
@@ -179,9 +181,6 @@
 /* Family 5 */
 #define INTEL_QUARK_X1000		IFM(5, 0x09) /* Quark X1000 SoC */
 
-/* Family 19 */
-#define INTEL_PANTHERCOVE_X		IFM(19, 0x01) /* Diamond Rapids */
-
 /* CPU core types */
 enum intel_cpu_type {
 	INTEL_CPU_TYPE_ATOM = 0x20,
diff --git a/drivers/platform/x86/intel/speed_select_if/isst_if_common.c b/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
index dbcd3087aaa4..d4f1e222cdfc 100644
--- a/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
@@ -810,7 +810,7 @@ static const struct x86_cpu_id isst_cpu_ids[] = {
 	X86_MATCH_VFM(INTEL_GRANITERAPIDS_X,	SST_HPM_SUPPORTED),
 	X86_MATCH_VFM(INTEL_ICELAKE_D,		0),
 	X86_MATCH_VFM(INTEL_ICELAKE_X,		0),
-	X86_MATCH_VFM(INTEL_PANTHERCOVE_X,	SST_HPM_SUPPORTED),
+	X86_MATCH_VFM(INTEL_DIAMONDRAPIDS_X,	SST_HPM_SUPPORTED),
 	X86_MATCH_VFM(INTEL_SAPPHIRERAPIDS_X,	0),
 	X86_MATCH_VFM(INTEL_SKYLAKE_X,		SST_MBOX_SUPPORTED),
 	{}
diff --git a/drivers/platform/x86/intel/tpmi_power_domains.c b/drivers/platform/x86/intel/tpmi_power_domains.c
index 2f01cd22a6ee..0b3092c264f3 100644
--- a/drivers/platform/x86/intel/tpmi_power_domains.c
+++ b/drivers/platform/x86/intel/tpmi_power_domains.c
@@ -83,7 +83,7 @@ static const struct x86_cpu_id tpmi_cpu_ids[] = {
 	X86_MATCH_VFM(INTEL_ATOM_CRESTMONT,	NULL),
 	X86_MATCH_VFM(INTEL_ATOM_DARKMONT_X,	NULL),
 	X86_MATCH_VFM(INTEL_GRANITERAPIDS_D,	NULL),
-	X86_MATCH_VFM(INTEL_PANTHERCOVE_X,	NULL),
+	X86_MATCH_VFM(INTEL_DIAMONDRAPIDS_X,	NULL),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, tpmi_cpu_ids);


