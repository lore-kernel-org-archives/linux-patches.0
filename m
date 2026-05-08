Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E718737D130
	for <patches@lists.linux.dev>; Fri,  8 May 2026 09:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778232381; cv=none; b=J6hYPl9pQwJ9fk77TE99y15wBkuR2myUZ43Z6HUhaoRktnG5phW30QOfy53U8YFplt+cJBQiX1U0OO98I1eTCVrimIfZKe3zH8HaquR8N2Q/Td3ei6Z18G/111NTcGLlt8wO2NbBcXkUy5WyOESqoH4a0gOJWp0TyHzeQrCEMn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778232381; c=relaxed/simple;
	bh=a69fVEIS2hcYnXuKu1po3P5vB5uzlgae97LtTNj3uDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CePB1uERtEChfMExQk+MzHkJeJZyuNmDUFgWs/M+zOjkviGAtBztxiaGTehHtDaK08/ZSSBx8ShFwT9dHecfRGm5wdHeZY5r496lg34YBgX1BLyUB7fuJ+6W7nwhD8MMUJlv+1rJm3NRkye+6Q0awheawlP5opWle9WPHFG0vpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oGZ2e9pC; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oGZ2e9pC"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2b46da8c48eso68995ad.1
        for <patches@lists.linux.dev>; Fri, 08 May 2026 02:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778232379; x=1778837179; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0Z6CQ3IeyoNCQzM4n8QUnxz+E0eb5nkL31cz1hZskRQ=;
        b=oGZ2e9pCU3bHW4DHT4e0R41vrffjiB/zGMgnpz3c0Nu2gGjXtWpQqmOLu/J1xHmu+P
         1b3nveFoYVsDstg6svUlbk8HW8B4GanWDxHZ0JZ3lcudgz6YhXPlHfv8JS0HZQnWbjKI
         OORaiF4srEMnJj9CAQ1eomTqOvsH3uE3w/thExwrR+XfQQkEGi/BvQgzTH+bNDXAMiM9
         TvGDf0BOlxHTyr5g16Zjlwti8NgCUc1aRqc2m+F4CgWoV7XgSCNVPS6chSg49gL2ch+z
         n9gmxH0b/AN85mZQcEGMJx4SFfxZDZOt/4MXiGqOVkqjRCKKTAfCrIYH+I0QNdD42udV
         nVkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778232379; x=1778837179;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Z6CQ3IeyoNCQzM4n8QUnxz+E0eb5nkL31cz1hZskRQ=;
        b=rQsbmTCLmTePcOpnXol1Flc9/s/welcEKOO7gh650rXlYmlJKljpbK0AXMe29nAR0R
         bKmUSmEHseOWNVrgjofNB/f46hA+5IpmyDDkREjT3DLuUNYzUh/7SdAOQpsLyXBIseb1
         Z+AUJiUx8Q1vQFNK+jUTxNYc98QuUxiStpzRkC/5RAi3Yee1MGzyVD/CKA7r896XYhP6
         9lJW5eiyZKYlmRiopB5XYMICkx/M+iSt4SCNXvXij+cXpQMquErquxPfqNECdzq8NhyG
         Hqvraum7qut/2AuUndOj+p5iXzumtwHxhs5Mj0/elU1rvv1W7NFwAt+aN04k0KUzK3IA
         oXQw==
X-Forwarded-Encrypted: i=1; AFNElJ+HdaHWilJasDKN0VmKLkRf9+1j802siXcR46hJr6IPuIZl6CBxqmEk4Q2O9EzrkmnJO8m67oWr@lists.linux.dev
X-Gm-Message-State: AOJu0Ywf1n/hxmleavuGQ5BNuh+MBfy4d50/NHtwaHUyvlEjBCGK47YE
	EaYCtHy0RyRPDBx6Qalu7bRrH1HS96lhZS9FsXUS17HmGTj58m/bKNgpO8X7tryTPg==
X-Gm-Gg: Acq92OHUcJUAJxg9xM9+9lxphaoP9y3qhr5JpY45SUsI4sFEQyOJfXQvdtX/uZWkW/A
	CD7eJLSPrRHjSRO4ckypa8FiV5/IUwosx13MAFlbQ4aGhN9lcCfe23YHrtyRk0g/SsQ6wIcnrox
	BPbW2y1BknrPZ9Dy0Qt4flMerUTGea+x6cFuw1pm2zvM7DW30sjLxYZVmMi8AAHS9FKWOTle/Hy
	yOQ+iZfT/tbTiUK44AeDTBF7M+GQwg9BN8WrEoXU51cuWk3qooHqEvtt5rfoGOH0q0Rxpbcxr17
	LRgh2pzsPlFAch54kNY5pA3F0imBJFDszEC2iXdjCQGtqhOWXV+sXXB55JvF+PaWQQame+XFK56
	PCIOtymkwl3p2vHpG8aON8C1xkWXQ0e/AT7yrBy8iquA7EZvfiezb5Nwj5XdgXDaF1AhPCDYjSU
	1bBDjvQ8EssazrzUIPnI/sBVnlvznijq1BSRoe/LHKx+LCESwvOHH3g8vgsF/puKndf2yC
X-Received: by 2002:a17:903:22ce:b0:2b4:641a:6b7c with SMTP id d9443c01a7336-2baee828aaemr2177755ad.13.1778232378829;
        Fri, 08 May 2026 02:26:18 -0700 (PDT)
Received: from google.com (44.234.124.34.bc.googleusercontent.com. [34.124.234.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1ead90asm14866545ad.72.2026.05.08.02.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2026 02:26:18 -0700 (PDT)
Date: Fri, 8 May 2026 09:26:11 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Krishna Reddy <vdumpa@nvidia.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 4/9] iommu/arm-smmu-v3: Convert arm_smmu_cmdq_batch cmds
 to struct arm_smmu_cmd
Message-ID: <af2sM-NtNvzCpvyg@google.com>
References: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
 <4-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>

On Fri, May 01, 2026 at 11:29:13AM -0300, Jason Gunthorpe wrote:
> Convert the batch's type to also get the remaining helper functions to
> use the new type and complete replacing naked u64s with the new struct.
> 
> The low-level queue_write()/queue_read()/queue_remove_raw() functions
> remain u64-based since they are shared by event and PRI queues which
> have different entry sizes.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Pranjal Shrivastava <praan@google.com

Thanks
