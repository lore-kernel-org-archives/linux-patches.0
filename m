Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793368311;
	b=BM2rdYQm/vb8cVhVk7bZutO8phmgVOgG15r9c6VnXWsWX8EIlCEY5ad2pgwRgivRH0Xx
	 GM5YfpuAIyBDciMOfwb3L7vva1R0cFCn04LOEMfxs5G1xi+bRjDcrVQUKpEwVvHSnnRLs
	 lLz5LRKROihrxzq+pg9j/YeBRb75kaLzV4mmNUs/Z+7zC1ILHPxxgMAXKoow0JVA3SAvc
	 J80qOGD/ROUTxD0fsUvcgK4XqD0ARU8v200yKl8OgNamRhMXbQadzJi+6oNRb0pIOgbDA
	 CTZSjZ8y4Nk+Rn3xyKWc8vst01fQMksEzO5Cl2/lVge+6NQ2mMVcQn/gZxrgEcwgBrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793368311;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=dYlx28FnHXYVTNT5d5cFUC7pVscgu04N4TsPgFJfIQI=;
	b=Nm1fdawS9VDES9CC647Jfdmm6YXoMTARJFAJzNeMbCFB04WzHTiQtkAr49cTh4uV7ySV
	 JhQXfIO2jkv0RxPD7JttLymwxQoL76UXkN3F8K01eRjskgKjUo9G4nu2i+NnU4fn/TVAq
	 wtXYmbVEIX6wSKZR3nP7QlxAx3wx63HrUy8BAYzPA7/NIBKehCW82BgPsvJfE69KGoZtV
	 e04J4oDSFnIEXm1oEnpmcckR+yTPx021lkBsAG5kAG3Y2DEOiIFgTuFg/M4VznbelfckW
	 tlEf7tN3ZU9Hj7eN+55/vAZooXuDPWquX3tsglqhicoIomCPzSpcjs3fC0DNhGErvkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	arc=none smtp.remote-ip=209.85.167.45
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F62C60A260F
	for <patches@lists.linux.dev>; Fri, 30 Oct 2026 13:51:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6F62C60A260F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5bcb4f23ddeso731454e87.3
        for <patches@lists.linux.dev>; Fri, 30 Oct 2026 06:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793368303; x=1793973103; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dYlx28FnHXYVTNT5d5cFUC7pVscgu04N4TsPgFJfIQI=;
        b=n84PV2b6i0cD8tLWkOHi7BgaMKTGzO1pjYSKl9IKWqtSIEjvEQCmROtdDScunnEhPg
         UXHn/af9TUnoOtKdKCg8/AbcEHGpmFXgoaLG0NKKCIMNJMu0PMG4EPIzOEu4KD5wo54j
         AG02Zrzi2Nzdx6L/3ictyt/Yw91xPwbiW/zfbUhmUP3kj73h8N2NeopmSwwhygyDdthd
         ZGzo9ic/nSVzgzd32T9byfoaBwlIyNUOM/Y0iGVDz69MqLDmZRTfMAjRbOWv86mxu8Na
         hx4ddrHRPM0IC9pMzdfXWw7vHAWj5KD5FGew2XRbMS92+qEMUyKgjDOBBfAeV1navnvn
         Hirw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793368303; x=1793973103;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dYlx28FnHXYVTNT5d5cFUC7pVscgu04N4TsPgFJfIQI=;
        b=Vi00vIbExN7Ki8wahyiKAV5tz5JYuTWvpqA8eIAgR7GnF7e0ptJRYq9cUVp0egop45
         tE92GMVT+zJUQPEjc01rdVXw3/smw3LhT7EoI80kXO3aeoO+aaSfvf4J6eZORHDE6+Dj
         xftIvhCYerV7ioy8Q9RHKSIk6sRel3jrsdlJvz4MWqBYVBxB6Ilre7ESKshMyBzcooWA
         CpIwsUoYdeE7gX5YdRO/JHZmhzjealcbnWkYgbzm7BsyLOVVeobIhfTNKzrFqXZN/ZVb
         FFqdsQqFZjybbltyt1ueTCA0ABLvom43NlZkdGbD+UlC8tstW+GZ7AQ5O5c9Zhrb5wQg
         2yZQ==
X-Forwarded-Encrypted: i=1; AKwUvBwL1ZVi0y1DeXIodR8MHv+awTUZNv1UgjinGREV04iMcYXtM2GF9eV/eTJXhDeOpU6nVtvCG6Ga@lists.linux.dev
X-Gm-Message-State: AFq9FYKSF7oAlbsQ59yVBqQWRt67DE7MkSfDBTv2iH+e1pK2Re0nCf3I
	19y9jA2CsB5U9bh5e2cP0swgg+ArMUClJAkFI8RqVmago5As536Zkrap8VbZsaOq50w=
X-Gm-Gg: AYBFou0cNwGvpyiASUsa4+1XBVZ6r2m/DZTr0e1rkPiN3rwcimlEgxAugAksjOfjOnV
	shH8WTWIaANP1drwHIz1XXqWPaara31VbJ+BvYr8LXsHs2dZYNUMw2EKQyyrZth8VHcUuBIw08v
	gopQ+enpAW6YuAlZaZONiYOPTgwRr8SanAGHMXXKkJ14xE4xCp3LMTkxwgcv6tzHmpydXXK93kH
	lDmon+EHrNZXIgjhEHhEkIsMfzMEFmN7et+i53s6FTRGXv/FWWkvXl69JJC20URMeOhUxC5E/k+
	CnWWA4BquAzV2du7SrQjUWzonJxAw25LAmBvz3oGz+RqJ7trJoO+lOdKmPYeKucnK1e8kAweOyu
	r659dQ6dj76NcsZB7YAwDetr6fxQG0zPhfUb+mbHj5ufiL1G0BlhUPLuYkeLeFGam/G96q/eak7
	pan8Ddr8lV8Getj0W2ES9jmdmOy/TbR4Ek9rhR0fV4QtiWLimHsTkC+ds1PYNe97mYvFA4PGZ5m
	uLr1ybMko+/2l3qcgf2U0KetKTJulDvO7proCaLgpg866emjYIT8kDTEoQHiYz7llqOvAXOdgba
	OdcgNO7SFcF5cQ0AaO5ZmzLGEnfqUTFuIvNRig==
X-Received: by 2002:a05:6512:3989:b0:5be:494a:8803 with SMTP id 2adb3069b0e04-5bfd9575993mr960212e87.40.1793368303378;
        Fri, 30 Oct 2026 06:51:43 -0700 (PDT)
Received: from localhost ([208.127.45.21])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfe04ee1f6sm167e87.11.2026.10.30.06.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 06:51:42 -0700 (PDT)
Date: Fri, 30 Oct 2026 14:51:37 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>, 
	Alexey Kardashevskiy <aik@amd.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Steven Price <steven.price@arm.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Jonathan Cameron <jic23@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, patches@lists.linux.dev
Subject: Re: [RFC PATCH v1 03/11] attestation: Enter secure operation when
 evidence is accepted
Message-ID: <auSfroz-gNb62nMG@FV6GYCPJ69>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-4-aneesh.kumar@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028152618.1356860-4-aneesh.kumar@kernel.org>

Wed, Oct 28, 2026 at 04:26:10PM +0100, aneesh.kumar@kernel.org wrote:
>Use EVIDENCE_ACCEPT to enter secure operation after userspace has
>checked the evidence. Check the referenced device and evidence
>generations before calling the driver, and record acceptance on success.
>
>Remove the separate DEVSEC_RUN command and callback.
>
>Keep DEVSEC_STATE_GET so userspace can read both evidence acceptance and
>device state. Clearing acceptance does not undo the device state change.
>For example, with the following PCI/TSM patches:

Note that the published wip_attestation_all_1 baseline still
has DEVSEC_RUN. I am planning this merge into EVIDENCE_ACCEPT for
my next revision, which is not pushed yet.


>
>  Operation              Evidence acceptance  TDISP state
>  ---------------------  -------------------  -----------
>  EVIDENCE_ACCEPT        Recorded             RUN
>  EVIDENCE_ACCEPT_CLEAR  Cleared              RUN
>
>After EVIDENCE_ACCEPT_CLEAR, DEVSEC_STATE_GET omits the accepted
>evidence generation but still reports TDISP RUN.

What exactly is the clear good for now?



[..]


>-int ctlv_attestation_devsec_run_action(void *priv, struct ctlv_op_ctx *ctx,
>-				       const struct ctlv_cursor *request, struct ctlv_cursor *reply)
>-{
>-	struct attestation_event_batch events = {};
>-	struct attestation *att = priv;
>-	u64 device, evidence;
>-	int ret;
>-
>-	device = ctlv_attestation_devsec_run_device_generation_get(request);
>-	evidence = ctlv_attestation_devsec_run_evidence_generation_get(request);
>-	if (device > UINT_MAX || evidence > UINT_MAX)
>-		return -ESTALE;
>-	if (!att->verdict_recorded || att->accepted_device_generation != device ||
>-	    att->accepted_evidence_generation != evidence)
>-		return -ESTALE;
>-	ret = attestation_evidence_validate(att, device, evidence);
>-	if (ret)
>-		return ret;
>-	ret = attestation_preflight(att, true, false, false);
>-	if (ret)
>-		return ret;
>-	ret = attestation_events_prepare(att, &events, true, true, false);
>-	if (ret)
>-		return ret;
>-	ret = att->provider->devsec_run(att);
>-	if (ret)
>-		goto out;
>-	attestation_device_changed(att);
>-	attestation_device_event_emit(&events, att->device_generation);
>-	attestation_evidence_event_emit(&events, att);
>-	if (!ctlv_attestation_device_generation_put(reply, att->device_generation))
>-		ret = -EMSGSIZE;
>-out:
>-	attestation_events_abort(&events);

As this function performed generation preflight, advancing
device-generation, emitting the device and evidence events, and
returning the new generation, I think that this bookkeeping needs to
move to evidence_accept function.

[..]
