Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.245.111.132
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792750297;
	b=BzL/m/jQF6wqKDwas4msurey/PoC5WFnIY7M/40j67RnhH+uxwAAl0j9lHSfPrCHEuA2
	 fl1jWQ8puimSuymMND0mwwoHlicukDq5eepD61v1RBqilzLwaDOwp+l9lQcn48yPSlctq
	 qZp4wqFf+azWBNssOAD8fx3NVBevMPFBYCt6L45V7RowJ9jWS1ODcy9WfTljWQ3ErEYRc
	 7I+jIA3QME0vAmQtFBLykCc6fxKPjsZ75VlGxEXniODaMXBKxdk2PoneGsdg2AbNjZ2QK
	 PrxsHICR54m3hdpidlmyoCgfyoaI8tTRvQAEuTlWAkWH1XsEXCfa+x+xdkAhQ4Nzgpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792750297;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To:X-Scanned-By:X-Scanned-By:X-Scanned-By:X-Antivirus:
	 X-Spam-Score:X-Milter-Copy-Status;
	bh=slxcVSN8R14B8aMKDMOxnEYX/uVh9WYmvjIOP2SbZ/Y=;
	b=oHJS+QPvE0lAS5gCp5z3cJeJ8r5j8KkkYPAMEr81wYg1FMm+d1cTKE12dw4OYryv+4/5
	 NAHYHWAZg2PKNAVIeTp0mokhcDYQXDKRibsUAiP8RbyXm254klQpv9aEKCCwrT3+JYzRF
	 ERB8Lf0WN88n0GRzDpTSlIZVDZQxRx0YT1eLQ/8KnvzkyFsraYB1Xn66VSzdwl/4NjOWN
	 1EOhazqW2S58FDEPRhtbmdFhXv0AsxmtoLNCc6xBQeJWEbx6EQBvYqHEn748VbMx42Km+
	 4XW1pzrWYoRno9pVdAoA00xOuJQTTchslK0wgE1MG4gTpdvow4RhH5SLNW45Hg2rbLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxbox.cz;
	spf=pass smtp.mailfrom=linuxbox.cz;
	dkim=pass header.d=linuxbox.cz header.i=@linuxbox.cz header.a=rsa-sha256 header.s=default header.b=JGX3sFAM;
	arc=none smtp.remote-ip=62.245.111.132
Received: from gwu.lbox.cz (gwu.lbox.cz [62.245.111.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A567606A31B;
	Fri, 23 Oct 2026 10:11:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A567606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxbox.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxbox.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxbox.cz header.i=@linuxbox.cz header.a=rsa-sha256 header.s=default header.b=JGX3sFAM
Received: from linuxbox.linuxbox.cz (linuxbox.linuxbox.cz [10.76.66.10])
	by gwu.lbox.cz (Sendmail) with ESMTPS id 69NAB4Dm067816
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 23 Oct 2026 12:11:05 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 gwu.lbox.cz 69NAB4Dm067816
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxbox.cz;
	s=default; t=1792750266;
	bh=slxcVSN8R14B8aMKDMOxnEYX/uVh9WYmvjIOP2SbZ/Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JGX3sFAMXlAjTdXzQn8bML9OUKeEyUHHkQS0x/z1I/8t6kfj1dYmHEW7fb5b0f09W
	 w3ZTQJ65wWJLWJtJtKvTPFFpGLFAG6C5a2l2L2t00tXGFrLc4wX+uNeKZeN6UMHG2u
	 I68ImEYovymvaMm6nnOFychZIeiu/opA64UHka0Q=
Received: from pcnci.linuxbox.cz (pcnci.linuxbox.cz [10.76.3.14])
	by linuxbox.linuxbox.cz (Sendmail) with ESMTPS id 69NAB3dI028816
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 23 Oct 2026 12:11:03 +0200
Received: from pcnci.linuxbox.cz (localhost [127.0.0.1])
	by pcnci.linuxbox.cz (8.18.1/8.15.2) with ESMTPS id 69NAB2mS3353212
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 23 Oct 2026 12:11:02 +0200
Date: Fri, 23 Oct 2026 12:11:02 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Sasha Levin <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        patches@lists.linux.dev, Jacob Keller <jacob.e.keller@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Alexander Nowlin <alexander.nowlin@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Alexander Lobakin <aleksander.lobakin@intel.com>,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: [PATCH 6.18 158/621] ice: drop page splitting and recycling
Message-ID: <atsythEG2rkGdc6Z@pcnci.linuxbox.cz>
References: <fce25d6d-8fd7-4f83-8d8d-929871aff885@intel.com>
 <2026-10-14-1-daily-reply-0015-ice-drop-page-splitting-6-18@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2026-10-14-1-daily-reply-0015-ice-drop-page-splitting-6-18@kernel.org>
X-Scanned-By: MIMEDefang 3.7.1 on 10.76.66.3
X-Scanned-By: MIMEDefang v3.7.1/SpamAssassin v4.000002 on lbxovapx9 (nik)
X-Scanned-By: MIMEDefang 2.86 on 10.76.66.10
X-Antivirus: on lbxovapx9 by Antivirus 
X-Spam-Score: N/A (trusted relay)
X-Milter-Copy-Status: O

Hi,

Just a follow-up on this one, as I just got burned by it a little.

These made it into 6.18.58-rc1, which I was still testing (I wasn't
aware that some patches had been dropped from the final 6.18.58
without notice). After deploying it to a machine using the ice
driver, I noticed a huge memory leak. It's easily reproducible:
running a flood ping eats about 1 GB of kernel memory per second,
effectively killing the machine within minutes.

So I just wanted to report that these cause more than just a
performance regression.

Anyway, I'd love to see these in 6.18, as some users have reported
that this series fixes some nasty memory corruption.

For some time I've been using the following ice commits, backported
to 6.18.44, without any issues:

e314a3c525c91c1e918546f472585cdbd44fbd1
3a4f419f750946181e3d6a339a1ef1942c5b5685
93f53db9f9dc4a16b40ecd18e6d338ad57e4b670
436fa8e7d1a119ec90f39e7c2ce0f3a146652899
a9c354e656597aededa027d63d2ff0973f6b033f

But since I was busy hunting the bug, and then found out that
corruption was most likely caused by something else (a patch has
already been posted for 6.18.59 by Yosry Ahmed), I never proposed
submitting these to -stable. Later I saw them in 6.18.58-rc1 so
I just scratched that..

BR

nik

On Wed, Oct 14, 2026 at 12:53:18PM -0400, Sasha Levin wrote:
> > This is intermediate commit, if taken without
> > 93f53db9f9dc ("ice: switch to Page Pool")
> > there'll be huge performance regression on all ice cards.
> 
> Thanks, that makes sense. This patch is dropped from the 6.18 queue, together
> with the other five ice patches queued with it:
> 
> 9e314a3c525c ("ice: remove legacy Rx and construct SKB")
> 3a4f419f7509 ("ice: drop page splitting and recycling")
> a9c354e65659 ("ice: fix crash in ethtool offline loopback test")
> 02852b47c706 ("ice: fix rxq info registering in mbuf packets")
> e142dc4ef0f4 ("ice: change XDP RxQ frag_size from DMA write length to xdp.frame_sz")
> 436fa8e7d1a1 ("ice: fix broken Rx on VFs")
> 
> That leaves 6.18 without the XDP frag_size fix (the fifth one above). Could
> someone from Intel send an adapted [PATCH 6.18.y] of it for the 6.18 Rx code,
> without Page Pool?
> 
> -- 
> Thanks,
> Sasha
> 

-- 
Ing. Nikola CIPRICH
technický ředitel

+420 591 166 214
+420 777 093 799
nikola.ciprich@linuxbox.cz

www.linuxbox.cz
