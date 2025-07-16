Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDAF2F5C24
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 17:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752685239; cv=none; b=IqVdPVEXZSjmYzU1geMaDHKpZKIPh7+g6rfkm8b4Hb4gF+EJwkX6ln8PzqZiogMQ55e5s4BOnmIFlPqh/3h3hy2GGiZ/WTv30tQiLnb7/Xt1M6XVuOqLuc1SraN2eiqQIm6bt6DFeaudtUgg/k8ssQ0eHjq9c9y99AIKm+O40ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752685239; c=relaxed/simple;
	bh=VT2e/D8TNHzCkI96xQbHOMePD40bqojitO9TYfZwJRU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i9vlC68YLW3GK9m78Q+5d08U6ertMparZ56tDeqV7qdrHDKHDAC9rsV5YtqwiK3+PAB8ArWref83Dj1nhxbvJB/K8l9mQikX54nIHMKheWrgvxqNvfSf0AgOBzGk3NCS6CwEGahTZPlt6ZwXfuCpi1UypFpzq7NqYf+yx9Dlp6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EGW2SqND; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EGW2SqND"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752685232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9bKE/0cNtoQ/CuczzprbbV3beLrr2MpjH/0TxwAvYDI=;
	b=EGW2SqNDS+bbvfZeAe7m0XkeSE/5InZp+3e8Cm9971xBLykYMr0Id2ZKD6lhZf2L14cb7E
	m/7j21puwycBSAL1z5yPa+WPPIcNV7qCtSSmndOl4e2MIfmaQBvEJL0v9ZDdhcEouARXw7
	N1R7nTs676nXIO0KAIF44/eoIk4Gb3s=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-455-rQ6lWi_GNYyhpD2hQKQ9aw-1; Wed, 16 Jul 2025 13:00:31 -0400
X-MC-Unique: rQ6lWi_GNYyhpD2hQKQ9aw-1
X-Mimecast-MFC-AGG-ID: rQ6lWi_GNYyhpD2hQKQ9aw_1752685230
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3df57df1eb3so55015ab.2
        for <patches@lists.linux.dev>; Wed, 16 Jul 2025 10:00:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752685230; x=1753290030;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9bKE/0cNtoQ/CuczzprbbV3beLrr2MpjH/0TxwAvYDI=;
        b=O0RwR/IHhrEDuB1TZ5uQpYVlJnqBelW8selntMGRJAnx5u3gTlnhs51RdkBs7y/lap
         d3JftnFi1oPDo52jVZ24PXbfzVoCV28GwVrh4naasGckpislhRtEaJVsU178h4AaynfM
         IADnnHb3ZNa2OVIOsvOorn7gXk0r/OlSOwMoX0CoVuzjpLjNT7OsaoUmbuw0F9yzxQ+l
         n3Ce7gYlVu57T73ay6A1OGvRBRXafTm4UHYe8hnsgJEIeajw3zwjo2j53H6cug6eF+Kj
         fS5xiRC3iFx4I0OHNVdxev1uA3R4IG7hDlKOK19QiSvLhxT/Dov1qyeOMhbkuO7WyCCE
         NwRA==
X-Forwarded-Encrypted: i=1; AJvYcCWVt1gt7GonXBeI3NopVfols+xFqQCxQRZA46fNREMG/WYhSzWlpBybDrnhEPzgwddL56P996So@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+mooNa6pJIJjsILzntJpcXxk8j+kk/4GTxso6jK3gcc0Sst0A
	09aJoNcjSuLST3Y/XxjlmoBvlD7jby+veygdr4cAQpPrgS14qCV/iy2ePO1Wll9EyCkpkyjsfKO
	9YDDZ4Lspd87C4J6Tnep35DWVY2iExwQQ74lDwBX5iiJ/S16570+c+BWSWuU=
X-Gm-Gg: ASbGncs62xfxNdZK56YhXeoPEjWSAexuKWooSsUF10frBt+VrIaTok6A8fbDozTR7HC
	hjOcFodfb/+A3x4vqMnwXT9EanFpWZ77eFqqZVI22bCpYDiAXh45PnCXLX30/qhdZCoCwYCmGYz
	WK8A5qQqw/Sw6FUHV1KJKirZPvWbaSLBHOriwBC9bg3e9JNdQM6GGWQ2sZz5PluCa8gRgrfa2kZ
	e8syXVSpMVGSZIJS4MWyXpCNAyyq97HH+TsNJmWENKN/QitcYsX905lTuA8+gz3KrJBaj43qj3z
	owf8qy91swmkW04/+UIdFmsCtplp5xOQLdWW6sEpjEI=
X-Received: by 2002:a05:6602:1690:b0:85e:12c1:fe90 with SMTP id ca18e2360f4ac-879c096efeamr126747139f.5.1752685229878;
        Wed, 16 Jul 2025 10:00:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE+tZmWUIYwitvuBgGnxfswO12NMpp8mD2icMHkWg5+YtIZRRU8sqVvx4qLf0KrRuHgGBPToA==
X-Received: by 2002:a05:6602:1690:b0:85e:12c1:fe90 with SMTP id ca18e2360f4ac-879c096efeamr126745539f.5.1752685229362;
        Wed, 16 Jul 2025 10:00:29 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-505569d0e42sm3119302173.101.2025.07.16.10.00.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jul 2025 10:00:28 -0700 (PDT)
Date: Wed, 16 Jul 2025 11:00:27 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>, oe-kbuild@lists.linux.dev,
 Ankit Agrawal <ankita@nvidia.com>, Brett Creeley <brett.creeley@amd.com>,
 Giovanni Cabiddu <giovanni.cabiddu@intel.com>, Kevin Tian
 <kevin.tian@intel.com>, kvm@vger.kernel.org, Longfang Liu
 <liulongfang@huawei.com>, qat-linux@intel.com, Shameer Kolothum
 <shameerali.kolothum.thodi@huawei.com>, virtualization@lists.linux.dev, Xin
 Zeng <xin.zeng@intel.com>, Yishai Hadas <yishaih@nvidia.com>,
 lkp@intel.com, oe-kbuild-all@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH v3] vfio/pci: Do vf_token checks for
 VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <20250716110027.7e94129f.alex.williamson@redhat.com>
In-Reply-To: <20250715230618.GV2067380@nvidia.com>
References: <0-v3-bdd8716e85fe+3978a-vfio_token_jgg@nvidia.com>
	<76f27eb9-7f56-45e7-813e-e3f595f3b6e9@suswa.mountain>
	<20250715230618.GV2067380@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JcpO9tYaYAxKasr25vBLjmU2mqj4gZi3266LN0Rjyd8_1752685230
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 15 Jul 2025 20:06:18 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Jul 16, 2025 at 01:55:45AM +0300, Dan Carpenter wrote:
> > 5fcc26969a164e Yi Liu          2023-07-18  117  	mutex_lock(&device->dev_set->lock);
> > 5fcc26969a164e Yi Liu          2023-07-18  118  	/* one device cannot be bound twice */
> > 5fcc26969a164e Yi Liu          2023-07-18  119  	if (df->access_granted) {
> > 5fcc26969a164e Yi Liu          2023-07-18  120  		ret = -EINVAL;
> > 5fcc26969a164e Yi Liu          2023-07-18  121  		goto out_unlock;
> > 5fcc26969a164e Yi Liu          2023-07-18  122  	}
> > 5fcc26969a164e Yi Liu          2023-07-18  123  
> > be2e70b96c3e54 Jason Gunthorpe 2025-07-14  124  	ret = vfio_df_check_token(device, &bind);
> > be2e70b96c3e54 Jason Gunthorpe 2025-07-14  125  	if (ret)
> > be2e70b96c3e54 Jason Gunthorpe 2025-07-14 @126  		return ret;
> > 
> > This needs to be a goto unlock.  
> 
> Oop yes, thank you
> 
> Alex can you fix it up when applying?

Yes, I'll apply with:

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index 53a602563f00..480cac3a0c27 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -123,7 +123,7 @@ long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
 
 	ret = vfio_df_check_token(device, &bind);
 	if (ret)
-		return ret;
+		goto out_unlock;
 
 	df->iommufd = iommufd_ctx_from_fd(bind.iommufd);
 	if (IS_ERR(df->iommufd)) {

