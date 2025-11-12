Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C15030BB86
	for <patches@lists.linux.dev>; Wed, 12 Nov 2025 12:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762950378; cv=none; b=XR1ztNNbo/VH7gE3/sXoMehQ+cZTuHI4abtyOWf+adALwJupiDn3asIva8cgtJ62BMtKGAprIWkDXhIraHqQLDnCR/zICzT+WQma/RXdiJJ/Eho4erIpaXNQbpI8uR6mY27SicP0hikwzrmjWHtvTL9hMuQPJHP7iOI5qcaH3dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762950378; c=relaxed/simple;
	bh=CqNDDDxa3uN4xlxw7lBpImiMSDLKKefKhEv5FAtJBl0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M8hdFLfcrqnh7RKEYzIF2zid9wBnarhQ2DBrg5VGRB0c0FbzRt4ZF5JlM+EmS7uI8keDEPp8stLNOa8yAHk4O+tOA7gQ/VEWJxsTjfCLlx82XERWc7GC9CF58aH6HixTMXMjuWaiIUhHxk6OO1/lj/VaXmwsCWgpzF+pLOd0bJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B+U+9B8V; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B+U+9B8V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762950375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CqNDDDxa3uN4xlxw7lBpImiMSDLKKefKhEv5FAtJBl0=;
	b=B+U+9B8VhPXTg/LlYymIgcQsmtVy9mRIdclifCp+HQOBN4+xsKTWpBb/dYkJ5iSQVZI3QB
	54fHK7jjaWxmAB1GnIyv9wI5r2geM8FsTL/vBoWoWed0d2EvgphLI/xw9S/3Jz3oC/I7jk
	EuiE59ZsuWvw7gXfO2hm3QHsC3Ro/JQ=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-uUMfMPHxO4OaKzTgqdVmlQ-1; Wed, 12 Nov 2025 07:26:13 -0500
X-MC-Unique: uUMfMPHxO4OaKzTgqdVmlQ-1
X-Mimecast-MFC-AGG-ID: uUMfMPHxO4OaKzTgqdVmlQ_1762950372
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-297f3710070so22470245ad.2
        for <patches@lists.linux.dev>; Wed, 12 Nov 2025 04:26:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762950372; x=1763555172;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CqNDDDxa3uN4xlxw7lBpImiMSDLKKefKhEv5FAtJBl0=;
        b=IlEdl74onroB+X9m3IefQv++ayBVESAA83lOM8gVq2HmrBD/b78fERg3bVNnLIqko3
         hHCC70mIVoVYqsCKTgQcUrXjSaaV7t6vcu94EKCo+o5zwCBeyloc1ZKz/jyStRajoEgd
         O/cLVAe/jmpDGX2UIe4jXI9OfLvx84xLySF7VAKy8br30UkFRwg1HvqFBuQz43UTelYT
         FUi97hnHJym3Bbv9RNQj/5CLBYkStEuyCKzl+SdyU7EICKvmDMJMjrnk7t36YJxnOAC7
         9NfUybv/ndEVT9ZA7VjQzUXRfsWlKmGBQSReSWbzFj27uruYidmOwdoVI2zjMvgSqqfe
         mz8g==
X-Forwarded-Encrypted: i=1; AJvYcCVHUMiwq3BCIT2T8B/UweCGuNwR+3lS40Dbjub2CiViBQhSc+kCv+GeVEUhAQlepFIEqS7m/7H8@lists.linux.dev
X-Gm-Message-State: AOJu0Yz2/MsV2nSlFFVChk2iRoy4NEcX4m3DWGpPVb9usfcxavlgGKsD
	zH326UqCBuq7lHz4nS8n4BoMxNj3e1cYKyFzktg4T3iBFIZXt740FYYMQBCLEl+t6Zd1aG7/s2O
	oAoS9rvzbhQ6AGn9CTNeNbUQ5n+dM3sblFgAbpr1pM5rG7rGcoCebpdcL/kE=
X-Gm-Gg: ASbGncuNOzE0lp6+iMb6/5bx5V6yEDfK07CdO84jrukW0CCz9wc3yARylBiklQJpLA6
	9X3nH/hfBTAlzzXZiAgjFt62pYNr9jvzWRpnVdNL+2WJMyGfutcL/URnaSG8jsAY0EogvlTCsNW
	gWWhc0Ju5P7EFr+L93mfRwy960BtBlLrS3sLpaaCpDJSYfOMYzGPnocGk8QAP9aiK0tQR6vo0+p
	tS8MR6aS9TNap/IFKv3HNrf78Gave5X01Plb0AZKv1bUAyUeA1zda48iYU9p0Z9totvlSFwPr+a
	KbcfX6DrsAcF4+PlMBd27d6sHi048MxZyO01NgMLgut7QXdEHQi2KwQ09VVIlY+9qX3kGPmFoOX
	WN2DH6YpnM5bhycKsTi3akspEfg==
X-Received: by 2002:a17:902:ea09:b0:24e:3cf2:2453 with SMTP id d9443c01a7336-2984ee04f44mr35020325ad.61.1762950372264;
        Wed, 12 Nov 2025 04:26:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGotUeN2bXs86xhnkFf71Twk4l7K85JeCXAv2Ic+UsZ9JWvOMbc7w1rl78D10uve93JRS66cw==
X-Received: by 2002:a17:902:ea09:b0:24e:3cf2:2453 with SMTP id d9443c01a7336-2984ee04f44mr35019995ad.61.1762950371815;
        Wed, 12 Nov 2025 04:26:11 -0800 (PST)
Received: from [10.200.68.138] (nat-pool-muc-u.redhat.com. [149.14.88.27])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2984dce80f3sm29309275ad.106.2025.11.12.04.26.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 04:26:11 -0800 (PST)
Message-ID: <3b1b371eed29291182e2e90451d262ed24d1e3ed.camel@redhat.com>
Subject: Re: [PATCH 6.12 084/565] drm/sched: Re-group and rename the entity
 run-queue lock
From: Philipp Stanner <pstanner@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Tvrtko Ursulin
 <tvrtko.ursulin@igalia.com>, Christian =?ISO-8859-1?Q?K=F6nig?=
 <christian.koenig@amd.com>, Alex Deucher <alexander.deucher@amd.com>, Luben
 Tuikov <ltuikov89@gmail.com>, Matthew Brost <matthew.brost@intel.com>,
 Sasha Levin <sashal@kernel.org>
Date: Wed, 12 Nov 2025 13:26:01 +0100
In-Reply-To: <2025111200-handoff-boxing-aa92@gregkh>
References: <20251111004526.816196597@linuxfoundation.org>
	 <20251111004528.857251276@linuxfoundation.org>
	 <b239f2abb28d4e5dfc36c67bb6b88975a63c11e6.camel@redhat.com>
	 <2025111200-handoff-boxing-aa92@gregkh>
User-Agent: Evolution 3.52.4 (3.52.4-2.fc40)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rjY1-XutKM-D8qrIlNYJVeRuoHarwtYZ4HqnnNiDxfM_1762950372
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2025-11-12 at 09:59 +0900, Greg Kroah-Hartman wrote:
> On Tue, Nov 11, 2025 at 03:30:45PM +0100, Philipp Stanner wrote:
> > On Tue, 2025-11-11 at 09:39 +0900, Greg Kroah-Hartman wrote:
> > > 6.12-stable review patch.=C2=A0 If anyone has any objections, please
> > > let me know.
> >=20
> > This and patch 83 are mere code improvements, not bug fixes.
>=20
> But as the patch says:
>=20
> > > Stable-dep-of: d25e3a610bae ("drm/sched: Fix race in
> > > drm_sched_entity_select_rq()")
>=20
> That is a bugfix, right?=C2=A0 So this is needed here too.

I had a tag-overflow in my mind.

That one is a bug fix. OK then.

P.

