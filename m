Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C2917C61;
	Thu,  7 Nov 2024 03:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730949656; cv=none; b=RhuF8EPAqq2ZxcTQm/fN/tbQ0GGi2YvRJNym0F1b0TS1LWZrSDwnbSKSxJX0MZqNsLqKikG9E/y0vTeJw2wPcvrd3mwV0pJW+4pci0DzhI9UOG9Dsivw538iQljkzD5iK2Evfdz//3Ac0q5Xq5fpNPNMxJIfedUfTV2SZVFD678=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730949656; c=relaxed/simple;
	bh=MfgIsmThhu9LXOQDEMR7hFNs+rsV9Z5JVos+Z0mGxsw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u2yNn2CbDrOPk8+d5SEIFVh1Q/oaM1wpLT9w9/oUsOTlx2KZQwTfeFv6MIqnApSNjeRbS3K4HdZhC06rsKd+VIsjzZhSvaIggnnyBME3aWRTt/zv+jB5B5wypY2pWj216byAHu6zwfTbbGw+5cPylhHXCjNOLYYoRZjPKq6Ln08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UF0bjJum; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UF0bjJum"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-20ca1b6a80aso5835355ad.2;
        Wed, 06 Nov 2024 19:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730949654; x=1731554454; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R8jNzrElX9RmiBjTI8h4pv70akApgYg9F+hG3zefMUQ=;
        b=UF0bjJum8dq2QCOEZSWNOabqVkt6dVt/25YIZDbYZJUI1CxSAVmvRv6YPITgwf/yu3
         /i1+1BeiDewManGe4qmiI5axq28GDE8KvUycRrthIhefyI9/uX6+l0XZ9ecVyvQPQD5S
         pWMgYFy6fvk5nTSY5jOHvXHUXB8RsTC9Hn53JOVj610N95N+z466DIGGHEeETlZ1iTwC
         dUADyWIEFkuXnPhQXH5SURj88DfxIBbNXbvsP7rgKzU4MhwqPflfJ8J0zLa62Q0qRoGr
         NvCuvzqDvfg/agBgUp425QnRcdRQF3rO9wOFesGMotseR24LM3zf1bvPW12GstAYJWgz
         N7Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730949654; x=1731554454;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R8jNzrElX9RmiBjTI8h4pv70akApgYg9F+hG3zefMUQ=;
        b=jErO2f0XshD0vueKNtQ0iZvZQjq52SgKFp4/Htvg3IT/QN49JioeOz2TQrOCbZ0WAB
         dEBLC/1wrA4CdbxoDpV5xrZhPMI9YA6D/6Y5NiyHH2USTsNMN7mNte90pgvsP57ZxcNB
         V3ojoRR08LMi384TF5mnJ+bgPrcrvjk17Hhm4HUSFHsQElUJyNF04qcFtFcliO/cftiL
         NYbq38xuzsEqyh07jpfz604xjR6sKNlUuJ/OCZwYF2DE3YMREUw7/AFQ1ZOKNIJkCLi+
         KU3y+ewd06TAyOxvmLaBVjv6RQjjhav/ZlClWwbRNlC8akBerqOjQOTh53PcS64egxKz
         A0VA==
X-Forwarded-Encrypted: i=1; AJvYcCVS7cO/S/GtBcs9XLTBxTaZdy5Dw3/dGDj5DJ4o8DfWywgh4WdKd79gzwKkfjcyrZw8CwXAp6fv/Q==@lists.linux.dev, AJvYcCXaxFxXV1KQdWtH7+4i/dMAXeBdTaIJbFhkJoMpKkqu8I8xz7ln8mkp1rXDPNl5/X2dAwYJKg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy6lMkjQrveMmwjbwdXq3xxAT24Lxm1ZBkN1suFjbJbugPtmPUO
	+V4KW8WJJpH5h3MGSEPtm2yq8oApPTgzObZngPy108V6nBnG9Oy2
X-Google-Smtp-Source: AGHT+IFP7jI8N7MZAQEh3fKVwbjpLCzLZAOp+2qk1ae0Rl9Avg2cfhgX+kUyGo3POLdRxL4zyEhtHA==
X-Received: by 2002:a17:903:985:b0:210:f07d:b3d9 with SMTP id d9443c01a7336-2111af1757amr325782555ad.6.1730949653768;
        Wed, 06 Nov 2024 19:20:53 -0800 (PST)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21177dc803dsm2208695ad.12.2024.11.06.19.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 19:20:52 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id A156F41F52FB; Thu, 07 Nov 2024 10:20:49 +0700 (WIB)
Date: Thu, 7 Nov 2024 10:20:49 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, corbet@lwn.net, joro@8bytes.org,
	suravee.suthikulpanit@amd.com, will@kernel.org,
	robin.murphy@arm.com, dwmw2@infradead.org, shuah@kernel.org,
	iommu@lists.linux.dev, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	baolu.lu@linux.intel.com, eric.auger@redhat.com,
	jean-philippe@linaro.org, mdf@kernel.org, mshavit@google.com,
	shameerali.kolothum.thodi@huawei.com, smostafa@google.com,
	yi.l.liu@intel.com, aik@amd.com, zhangfei.gao@linaro.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v7 13/13] Documentation: userspace-api: iommufd: Update
 vIOMMU
Message-ID: <ZywyEUmL4HvM8B9v@archie.me>
References: <cover.1730836219.git.nicolinc@nvidia.com>
 <7e4302064e0d02137c1b1e139342affc0485ed3f.1730836219.git.nicolinc@nvidia.com>
 <ZywQP3_TpdttuCy8@archie.me>
 <ZywZcSidYCWkJgrw@Asurada-Nvidia>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fVTjkEpn9ekAW5rv"
Content-Disposition: inline
In-Reply-To: <ZywZcSidYCWkJgrw@Asurada-Nvidia>


--fVTjkEpn9ekAW5rv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 06, 2024 at 05:35:45PM -0800, Nicolin Chen wrote:
> On Thu, Nov 07, 2024 at 07:56:31AM +0700, Bagas Sanjaya wrote:
> > On Tue, Nov 05, 2024 at 12:04:29PM -0800, Nicolin Chen wrote:
> > > With the introduction of the new object and its infrastructure, updat=
e the
> > > doc to reflect that and add a new graph.
> > >=20
> > > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > > Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> > > ---
> > >  Documentation/userspace-api/iommufd.rst | 69 +++++++++++++++++++++++=
+-
> > >  1 file changed, 68 insertions(+), 1 deletion(-)
> > >=20
> > > diff --git a/Documentation/userspace-api/iommufd.rst b/Documentation/=
userspace-api/iommufd.rst
> > > index 2deba93bf159..a8b7766c2849 100644
> > > --- a/Documentation/userspace-api/iommufd.rst
> > > +++ b/Documentation/userspace-api/iommufd.rst
> > > @@ -63,6 +63,37 @@ Following IOMMUFD objects are exposed to userspace:
> > >    space usually has mappings from guest-level I/O virtual addresses =
to guest-
> > >    level physical addresses.
> > > =20
> > > +- IOMMUFD_OBJ_VIOMMU, representing a slice of the physical IOMMU ins=
tance,
> > > +  passed to or shared with a VM. It may be some HW-accelerated virtu=
alization
> > > +  features and some SW resources used by the VM. For examples:
> > > +  * Security namespace for guest owned ID, e.g. guest-controlled cac=
he tags
> > > +  * Non-device-affiliated event reporting, e.g. invalidation queue e=
rrors
> > > +  * Access to a sharable nesting parent pagetable across physical IO=
MMUs
> > > +  * Virtualization of various platforms IDs, e.g. RIDs and others
> > > +  * Delivery of paravirtualized invalidation
> > > +  * Direct assigned invalidation queues
> > > +  * Direct assigned interrupts
> >=20
> > The bullet list above is outputted in htmldocs build as long-running pa=
ragraph
> > instead.
>=20
> Oh, I overlooked this list.
>=20
> Would the following change be okay?
>=20
> -------------------------------------------------
> diff --git a/Documentation/userspace-api/iommufd.rst b/Documentation/user=
space-api/iommufd.rst
> index 0ef22b3ca30b..011cbc71b6f5 100644
> --- a/Documentation/userspace-api/iommufd.rst
> +++ b/Documentation/userspace-api/iommufd.rst
> @@ -68,2 +68,3 @@ Following IOMMUFD objects are exposed to userspace:
>    features and some SW resources used by the VM. For examples:
> +
>    * Security namespace for guest owned ID, e.g. guest-controlled cache t=
ags
> @@ -75,2 +76,3 @@ Following IOMMUFD objects are exposed to userspace:
>    * Direct assigned interrupts
> +
>    Such a vIOMMU object generally has the access to a nesting parent page=
table
> -------------------------------------------------
>=20
> The outputted html is showing a list with this.

Yup, that's right!

--=20
An old man doll... just what I always wanted! - Clara

--fVTjkEpn9ekAW5rv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZywyBQAKCRD2uYlJVVFO
o05dAPoCkLQClFT+zDGmYdVx68XDBEfdBl1CCmp2FZ3jz4uFtAEAqVIZoqERkKzk
iTAIm9NwYZC9ESLhO1HMIWvngDLktgw=
=Xpoe
-----END PGP SIGNATURE-----

--fVTjkEpn9ekAW5rv--
