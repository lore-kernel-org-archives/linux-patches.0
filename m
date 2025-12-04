Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD5A2040B6
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 16:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764867197; cv=none; b=EEjGtdl79fxArPwX5jqGN9NJXlsLVRYIr6F4M1dS2v9DXkN4BvW8AT90JJ6Qfk7rStF6eKyGIOEJ0q0G+NbEAl2iCk5ffDsFyeLb+rC/iRQVyfXsnXq49ngE26tuBDcm2iN9FdqmurRe9Won5rior8H/hgpaKs/jbDMUThEjl+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764867197; c=relaxed/simple;
	bh=mSOPh9199xYHctAs2n8xJnjFWEh+VkihRGoj9XoIA0Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MB824GV4BefRu5We8bhQ9pOB3xPNzQHQ7yEoYn+6+LHbG111DDBeMoAydh2cT7xyFlso4aEHwuVFNiaQfJTwspihLLqITMYNTR69XtB2FhxvAjWlR8ISukUUC+4HWH0i21AjEnkkXV39O3pCjPfhv9O3wLu5BNGa1KkgnAeoa60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=jbO6Madx; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=CUs0Z1rB; arc=none smtp.client-ip=103.168.172.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="jbO6Madx";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="CUs0Z1rB"
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 71DE7140022F;
	Thu,  4 Dec 2025 11:53:14 -0500 (EST)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-09.internal (MEProxy); Thu, 04 Dec 2025 11:53:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1764867194;
	 x=1764953594; bh=LMgbpofkhJ0Bjztd5WcFvOMTwOBOdBMxeJ61tLVU+qo=; b=
	jbO6MadxLr6eL/0DL/8w2+Xvp22NVwOeCgmriwQTbXdxwpkeTYUYdIlk/S6P55pM
	d4XdqzOw+sub1b7ABaot6VJQImXuYEctygKIYUiANOY1V7J5MHt0+qQV4tpRw+c1
	J3ccH9VY1Vj4hijnBluZoHP1CfUwBXzj7f2y6CW25aX/nJyaMv8SCaOwje8CwroR
	/Icnew98aNTAy9xSCXN4DtiK9kH5A63V7wKW8F0BaN5QyPOI+PGZesSPTI6rJJ4R
	a4vdU/d3GRwSn+anAKkMOwJcg/G9aJa8Uo1OkPdjBIwTwJL/Rq8BynhNR7YJ4hnK
	V66t4GqPptZ+EpKG4k+omw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1764867194; x=
	1764953594; bh=LMgbpofkhJ0Bjztd5WcFvOMTwOBOdBMxeJ61tLVU+qo=; b=C
	Us0Z1rBN04QXSs+OPsxM5BoiyB6hfxXv+N/J6TtaSlnc21Ag7U1nsneosqtK0cfn
	S4tvN84n83wGO2ASH1bD6gM//iHini7VIPQhJv04L6vRxh10rQc4p5VOVBWrxT/6
	kiXASP7Q1j3hAiMLkXc2wlW+SSZaEv/cvNJHntYmRobMgBtux6QuwykQ0+027WNC
	xa2dbJ5v55wLXQ4iY83O9SUvSQnNha82GDDsFAsWmlKfMo6a//XsV+MqKA+E+LXU
	dtscw997dqTb0pErFiPqkgwTnLGuwG7ZDxrCY8GYNkWlI9hqX/M8w+jffoeDZCec
	t3Z3WVakKuK1f0QZ+kyHA==
X-ME-Sender: <xms:erwxaesb8HtwiAwOvqZgarfj5rQ9d4YTRg3F1y4ZHZrV8g6qugSBKA>
    <xme:erwxacx04ug9xG-uTaHDpfwLcai7iDF3rLoakjU7g5GlvZM8jQx8SGZuzRwQ7iUup
    cGr4LP2ha9WQXvLxkQe7aYRzcFos1_gXGoWC7sROekMUHYH1_bIBWkS>
X-ME-Received: <xmr:erwxaRDS4JeE-tToaHzxUVqU89_sgSGYdsLIQLIQSoetCRzBFbt7ypLYTaNjBnB2-tfhyB_a3NlnP_G7cReHwVWgGJB3VQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeiudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpedfuegrrhhrhicu
    mfdrucfprghthhgrnhdfuceosggrrhhrhihnsehpohgsohigrdgtohhmqeenucggtffrrg
    htthgvrhhnpeetueehtddthfffvdeukefhudetudfgteffffehteehjefhieetffffheeh
    vefgvdenucffohhmrghinhepmhhsghhiugdrlhhinhhknecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepsggrrhhrhihnsehpohgsohigrdgtohhm
    pdhnsggprhgtphhtthhopeeipdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehgrh
    gvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehsthgr
    sghlvgesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehprghttghhvghsse
    hlihhsthhsrdhlihhnuhigrdguvghvpdhrtghpthhtoheprggurhhirghnrdhhuhhnthgv
    rhesihhnthgvlhdrtghomhdprhgtphhtthhopegsvhgrnhgrshhstghhvgesrggtmhdroh
    hrghdprhgtphhtthhopehmrghrthhinhdrphgvthgvrhhsvghnsehorhgrtghlvgdrtgho
    mh
X-ME-Proxy: <xmx:erwxaafvY72EP3jttKCRdXHoLGcPgODLVGbZ0OxKecMIRmM_fjK7pg>
    <xmx:erwxabmK2ToCmxprZw4xp9QFItchEEB_be8zKu5d01rXfi7YhX_BJw>
    <xmx:erwxaRFLnNBs7AcT1jc-U5nh0RTSpbwMlB1HfmO-9PYVu6thIOUTTA>
    <xmx:erwxaT4Y7RqE0TuBsAZ_O39992qNGqG187t81JCOSvOOMlnmXr4v5g>
    <xmx:erwxacal-rP9Tf60X9IOPHLeEn5LAtETqVwjKQHnjd2ppgiyoJBl0-r_>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 4 Dec 2025 11:53:13 -0500 (EST)
Message-ID: <2fa15075-56a3-4afe-b59a-1a78f4b7f971@pobox.com>
Date: Thu, 4 Dec 2025 08:53:12 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 414/568] scsi: ufs: core: Add a quirk to suppress
 link_startup_again
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Adrian Hunter <adrian.hunter@intel.com>,
 Bart Van Assche <bvanassche@acm.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20251203152440.645416925@linuxfoundation.org>
 <20251203152455.856124103@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20251203152455.856124103@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/3/25 07:26, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Adrian Hunter <adrian.hunter@intel.com>
> 
> ufshcd_link_startup() has a facility (link_startup_again) to issue
> DME_LINKSTARTUP a 2nd time even though the 1st time was successful.
> 
> Some older hardware benefits from that, however the behaviour is
> non-standard, and has been found to cause link startup to be unreliable
> for some Intel Alder Lake based host controllers.
> 
> Add UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE to suppress
> link_startup_again, in preparation for setting the quirk for affected
> controllers.
> 
> Fixes: 7dc9fb47bc9a ("scsi: ufs: ufs-pci: Add support for Intel ADL")
> Cc: stable@vger.kernel.org
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Link: https://patch.msgid.link/20251024085918.31825-3-adrian.hunter@intel.com
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---

This backport's commit message is missing the corresponding upstream 
commit (which is d34caa89a132cd69efc48361d4772251546fdb88).

-- 
-Barry K. Nathan  <barryn@pobox.com>
