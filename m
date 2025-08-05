Received: from sender4-pp-o95.zoho.com (sender4-pp-o95.zoho.com [136.143.188.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504ECA927;
	Tue,  5 Aug 2025 04:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754368809; cv=pass; b=S96GfBh/WQFV1FIYBa7gl8D2tdoXi2OlyxE4ZXkZOoQ4av97pP3nyGohACGoDOQzWkRl3+AZ08fU8JXIutaol5IJKf+MoxumL6KdbtNWH/6VkqJNgZFxXX0uj7jxpeIzl46fiLNkf23MzG1IVQwsbg8TdnQETrz55hkO5u87ix8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754368809; c=relaxed/simple;
	bh=vx4DftUwwXSdyzbwHUzTA5ckOdfuuDc8ELVLhPGqGxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gM5Vrt1Tvtj/RUHrbeGvLDgBEa/IKTU8IeH88mRQcBoc2r7NxYMt+hMJt69xnV4Bi3zvsum7eRqoGmvZBflLmhFlbFL/IOJuALwTXovtX/sLX3krj0DDdMKWo7Nv29dL5n+pym+9iU49VHeg92XnDG9Ou2uNdGQglb5YpUZiVdI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com; spf=pass smtp.mailfrom=zohomail.com; dkim=pass (1024-bit key) header.d=zohomail.com header.i=safinaskar@zohomail.com header.b=aaKWUQIS; arc=pass smtp.client-ip=136.143.188.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zohomail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zohomail.com header.i=safinaskar@zohomail.com header.b="aaKWUQIS"
ARC-Seal: i=1; a=rsa-sha256; t=1754368802; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=hLL0XtTgNsR8WSE4fXNd1z2CdzJur7opUEr/SkPBUDDjlSulSvT94VODsNgGwIr2vUkgbfytas4n4P6BWlxZrKIN1TyYe/FZ5I/nfO1wvhXOL7bI4nTFQpOFY2GNwjQW+YMx2aaOqT8GweRrYdb3qVtBN4zJfYvb4SFz1C4IPC8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1754368802; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=vx4DftUwwXSdyzbwHUzTA5ckOdfuuDc8ELVLhPGqGxg=; 
	b=UpvdkMFGqv+nhsXyiFujsJoqZCSbBgiheBx8kZTsfhLF6atD18y9Ml+LhjjwFk0VoiQl2y6Qes0sSVRnK1eRKp1GqQ13soGeDnzyQ22HjQ8u+A/Q5hth/ly4LAExzwQAfoLKokpt/x921EnVP24nyK9iRkKTNtxahDoHyemy6DQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=zohomail.com;
	spf=pass  smtp.mailfrom=safinaskar@zohomail.com;
	dmarc=pass header.from=<safinaskar@zohomail.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1754368802;
	s=zm2022; d=zohomail.com; i=safinaskar@zohomail.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Feedback-ID:Message-Id:Reply-To;
	bh=vx4DftUwwXSdyzbwHUzTA5ckOdfuuDc8ELVLhPGqGxg=;
	b=aaKWUQISpExcEcVMiW+kAhc7F6a1dWnwPT9BUxCJLsNRimeGL2AE1BNh2uO+Zgra
	alSRc7jHjW1rAWNOoiQMSg9J7i0rhAgkY9V1YwCAX26KkNCFRNZhhX70QORFZ8OeSzM
	j3dDY7xpi/35SQxegkFNWmmQskXGJcMYlr+FoAfc=
Received: by mx.zohomail.com with SMTPS id 1754368798702522.0385252595497;
	Mon, 4 Aug 2025 21:39:58 -0700 (PDT)
From: Askar Safin <safinaskar@zohomail.com>
To: jgg@nvidia.com
Cc: alex.williamson@redhat.com,
	baolu.lu@linux.intel.com,
	bhelgaas@google.com,
	galshalom@nvidia.com,
	iommu@lists.linux.dev,
	joro@8bytes.org,
	jroedel@suse.de,
	kevin.tian@intel.com,
	kvm@vger.kernel.org,
	linux-pci@vger.kernel.org,
	maorg@nvidia.com,
	patches@lists.linux.dev,
	robin.murphy@arm.com,
	tdave@nvidia.com,
	tony.zhu@intel.com,
	will@kernel.org
Subject: Re: [PATCH v2 15/16] PCI: Check ACS DSP/USP redirect bits in pci_enable_pasid()
Date: Tue,  5 Aug 2025 07:39:48 +0300
Message-ID: <20250805043948.97938-1-safinaskar@zohomail.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <15-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
References: <15-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Feedback-ID: rr08011227836b5a84cbec9309bce67830000009930723b1a51d76665429b8f21e634aea6d8b917e42cdb7ee:zu080112276350d1e42093adc1218a592a000051016fedef33d9f8d9d25fa5d589293ff61c022154552f52f8:rf0801122cabce9c8de7e03eff3770245c0000d597922cdc6364a109d4e084b3f192b48cf8a9a71bfb944dc2bee1c2cc69:ZohoMail
X-ZohoMailClient: External

"interpretation" should be, not "interpritation"
