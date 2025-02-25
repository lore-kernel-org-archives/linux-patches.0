Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA81198E65
	for <patches@lists.linux.dev>; Tue, 25 Feb 2025 16:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740502253; cv=none; b=e9fjuQH+/9Jbo1w87rpn8vCllfKDdDuImWwdISXzA0FG7qg38s8FygRO4StvXKSEFndnvVOuSM/va0Pygga62g3R2FlTCKAUix1TAAFBDenrieqSsatbkobh7IVat4SLerIrMq+6cy0CFVn/K+0wW/1eA6T7t3Tb+xgs8Q9OAuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740502253; c=relaxed/simple;
	bh=UG8eZltknvJ/8A9quAvUC0yykW+VaqkKlyJxmauyfV0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k0mwSG4emGFIUDAsh32AeJ4greHJl9wXQ8KG8H1zicfJZmwWNhZUlIObqa5oW2BkFO+li35m0+JD6/b4rlv9Ch8KUelz5cDWoxEmHveJytllNJULze5tRfNoocW1PwY6ktd82pPf5MaQG1FuIGvXKxpXe2i7WDry2Si1BTFRR/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=llyvn5bL; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="llyvn5bL"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2212222d4cdso173635ad.0
        for <patches@lists.linux.dev>; Tue, 25 Feb 2025 08:50:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740502251; x=1741107051; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lk6iw51fgW1qWU/03VHRsVVbj/sa5vR8EbwmDP3cjSY=;
        b=llyvn5bL5cAqCD+EOv4Y5+oJvWFycVB5/XVG9AQLY/Yh51aj5g9VR6u78So46RvALo
         geQ3yJ6UqJCvZSwZLPykQ2L18muMw2kaN1RQLejDk9FqOheFyRVAp50wrZmjKCt3HYjF
         Ac93W53z1EMy5f+LhaZdR5k2+ingzUhEe7Dpuv/NJWAeGeZ3CVjmMCn7RWQUNJiSwvBE
         BYKDvxfFkOjwv64/qA1KqwSTfC3lD80fea1/GetJVMWacfhMzKi2d754pp61eAMLXaKv
         stle3a96FwwmHz1DjgPi/zCVUPxP4uPQvWu6tvXGVTa6N2xQ1UYujdjZC+hGZ8cVMPhV
         CasQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740502251; x=1741107051;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lk6iw51fgW1qWU/03VHRsVVbj/sa5vR8EbwmDP3cjSY=;
        b=e/rEkGacvfodtJnzC5oRddbbQ/dJnOyHNBKyBJV8F3ydIe2MXePQPPHqBANzLdhlsj
         7JjwupGWaXuLaL3ih+0se3/9To6G3+kqCy3QbcCnY6RCqm+lOkdOvrjPCAZDEeYkuw4J
         7T/Qq5DkEexZNDxIVbs4K2PjLsk9eyVJmXPRL7WfdnwqvDWqoeLTqCgQPtThEbMsTI6Q
         wc+UwxOwFvu2sJrbGpvCEpaxhZv4OclvXEE5qrNq6ZMyVhjH3e4ROOzNzpAW11iwFFZo
         Q6fA8+AvDi3I+GKRwFZ5ioryM7pOOcVSgUpwxk9cWdfWi9Ah5teEDvOep8WOu1jW9cac
         mK+w==
X-Forwarded-Encrypted: i=1; AJvYcCUuY0ldUEuevzjtOAAtHZG7h3YM1jQDm4PeJJ0I6XQbcoBHf25R05YaFqrSQLWhPOX41V1gAWAJ@lists.linux.dev
X-Gm-Message-State: AOJu0YzoeHpeg3z8GgINXlz/fG9fCIQkenfDuczMo7ufF6/vz/IZNHFm
	fcWHBEHUe6GjMWtOTWxIrwChv/bJN++DOhyeivgITEoVK3HBizggKjLwrg5avQ==
X-Gm-Gg: ASbGnctpM5Q+/N6vUY4DTOgqR4Sn0oDO9zabJc6W6zsFsPyzqdVE7YKC2rZw6qEHC8o
	bHKUP/vZA9/bLWWyQhGV0pkNczPLuPHmXWF4EcL9CYaDTl8QWLX4MQjfY/Hhpup6emnjqmvifX9
	+uWq5dUbyV7uLEVfnUNspzxJQ3RXTZqg58sfMJCm1Sz1OG/hMf+d7hMs2Nn88cmLofoBXIkOqpT
	gGOISolUwfx/R1+XEJC0lnONjAIEgMVHwW4NFlYDECcniT5/JB6R46KXZnVXYHJwnIzJ7I+umpX
	acRATrZu7Hn+O+qSk3E6/8yiXDgC1EdBBW3Z8XVgn+9mauQwHXzSTMNJmC0p0qc=
X-Google-Smtp-Source: AGHT+IERMuVCVd7U6MTOmNpPqxv55xXM3OvnM1bfuQpjOxFQC3PAJTJoQU8Phr6vdg5p0sFS6cHxBQ==
X-Received: by 2002:a17:902:fc8f:b0:215:42a3:e844 with SMTP id d9443c01a7336-22307a60a10mr3635965ad.17.1740502251142;
        Tue, 25 Feb 2025 08:50:51 -0800 (PST)
Received: from google.com (169.224.198.35.bc.googleusercontent.com. [35.198.224.169])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7347a81eb0dsm1772166b3a.141.2025.02.25.08.50.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 08:50:50 -0800 (PST)
Date: Tue, 25 Feb 2025 16:50:40 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Nicolin Chen <nicolinc@nvidia.com>, kevin.tian@intel.com,
	corbet@lwn.net, will@kernel.org, joro@8bytes.org,
	suravee.suthikulpanit@amd.com, robin.murphy@arm.com,
	dwmw2@infradead.org, baolu.lu@linux.intel.com, shuah@kernel.org,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
	eric.auger@redhat.com, jean-philippe@linaro.org, mdf@kernel.org,
	mshavit@google.com, shameerali.kolothum.thodi@huawei.com,
	smostafa@google.com, ddutile@redhat.com, yi.l.liu@intel.com,
	patches@lists.linux.dev
Subject: Re: [PATCH v7 13/14] iommu/arm-smmu-v3: Report events that belong to
 devices attached to vIOMMU
Message-ID: <Z7304KKv2c1pOhj2@google.com>
References: <cover.1740238876.git.nicolinc@nvidia.com>
 <b1930038cf828dc13c080e2b46b3003a8c98ef24.1740238876.git.nicolinc@nvidia.com>
 <Z7zmErar4YvQSSxw@google.com>
 <Z7zrHn3tPBD5chv1@Asurada-Nvidia>
 <20250224233505.GF520155@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250224233505.GF520155@nvidia.com>

On Mon, Feb 24, 2025 at 07:35:05PM -0400, Jason Gunthorpe wrote:
> On Mon, Feb 24, 2025 at 01:56:46PM -0800, Nicolin Chen wrote:
> 
> > > Just thinking out loud here:
> > > I understand the goal here is to "emulate" an IOMMU. But I'm just
> > > wondering if we could report struct events instead of the raw event?
> > > 
> > > For example, can't we have something like arm_smmu_event here with the
> > > sid changed to vsid? 
> > > 
> > > Are we taking the raw event since we want to keep the `u64 event_data[]`
> > > field within `struct iommufd_vevent` generic to all architectures?
> > 
> > The ABIs for vSMMU are defined in the HW languange, e.g. cmd, ste.
> > Thus, here evt in raw too.
> 
> Right, the point is that it gives as a safe uABI that is effectively
> being managed by ARM.
> 
> If we make our own thing then we have to take the responsiblity to
> make it safe and extensible. I don't see a justification to do that..
> 
> It is the same discussion we had around the vSTE as input, the raw
> invalidation command and the IDRs. Since we've already done 'follow
> the SMMU spec' so many times already now we should keep doing it.

Ack. Undertsood. Thanks for the explanation :)

-Praan
