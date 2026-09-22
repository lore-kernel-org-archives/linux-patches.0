Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B25381EAF;
	Tue, 22 Sep 2026 02:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790043838; cv=none; b=ZEMVMEtg20XyHP51kNmXVmJ3qT/JpQgF+d+LAtvZ3GKt50AKx+SGeILvl6BH38TWGLLYNbwVqB20Ikf9w6+Eb0IxDiKs30lDdRd0flQLxWhD02lvY7JPpngf8DF4slNb0gocpEiwNqp2YgxI/jSkAK0sgG0fFwPoxR3CCAXP2R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790043838; c=relaxed/simple;
	bh=hVPaxAMEVdim6+ivDyrGXzQaYDCwYhhJnxFIMyHFADE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tiJh4O543nIzLpdTQMkEccLJkiL3BN1DDR94yQ/2uCjhl/efIyU9RDs0E7m1uxn4Cckj7fd8kETq3Q1jextWksQ2v+JhgSXY2u888QTpguVjvI+5sNp0o6l2+scGQevrH2b4LqfI34CpKw31fUXgsDyFZ3LlP4OLPWckUXHv3V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AIls1kMe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AIls1kMe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9841F00898;
	Tue, 22 Sep 2026 02:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790043836;
	bh=acBaOP6ye9nHL2ncE2Z17ex4G+4Gfyfbw3VKyRM1wqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AIls1kMeBde+IOj4AC7vNOPoMJQ2x2nSp4CZPYszgVSUBxbVz/LuDN+iSfgTmlhl7
	 /EHxYPzoVoJfI4Nu702uC3fjCZb+L5PKqX5TyIhOhmTsbXsVgvngNzFzTfnqqkWsmG
	 lGC+Dvm4kchgVIfMEbgXrgATVsmoahWC6z6XcK3e8qjWTJUPJcReOTqNdVmTB74qXk
	 ZKkMFoJ6iKTTnbWUqxDckZERet6tr6XWw4MFJkytqqaG5RCqZb4d62wefDaeyMJeQ6
	 PWbl+DnXYhS/k4PzTbBD067gL/pxW19maKra37i1qOMHYOos2OVZfZ84psDwoKpOP6
	 hSt4i/oFYoqOg==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH 6.12 0766/1376] arm64: dts: qcom: sc8180x: Fix the PCIe iommu-map entries
Date: Mon, 21 Sep 2026 22:23:45 -0400
Message-ID: <2026-09-21-daily-reply-0009-re-qcom-pcie-msi-map@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <c32f67e6-c4d6-450d-8a7d-3057ce3a94d8@oss.qualcomm.com>
References: <c32f67e6-c4d6-450d-8a7d-3057ce3a94d8@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> For clarity "the updated msi-maps parsing" - "the parsing of the
> updated msi-map which contains the amount of cells that the iommu
> node provides, rather than an always-assumed 1"

Which commits do you have in mind? Going through the trees I could not find an
msi-map record that was widened the way the iommu-map ones were, either
upstream or in stable, and gic_its is #msi-cells = <1> everywhere I looked, so
the fixed four cell parse in of_map_id() still reads them correctly without
ccb2fd725d41 ("of: Respect #{iommu,msi}-cells in maps").

If you have specific SHAs in mind, name them and I will take them out of the
same trees the iommu-map family came out of.

-- 
Thanks,
Sasha
