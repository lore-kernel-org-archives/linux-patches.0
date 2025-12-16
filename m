Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7292035E526;
	Tue, 16 Dec 2025 12:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886801; cv=none; b=SEx1XJLp4NMGe8lDGnpVNZgas92XPTRwFiW2mkNgSxotKmyibzfnccICY9FlorQEUJIfPJwIUHR131PtU8Q6/djOM7jre+T0ZyvuCLmXVhfzt6S8RIL7x0DFxLq7iabyJ1lVsP9ZKy/UYCKpXl422dXhcTc2cwDsPmX5M0ghBGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886801; c=relaxed/simple;
	bh=xx0paCrj6+rTo0Uka7cxyMcs3cqFLkf/1OiqMLSazSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=APqcQ0Vm+Qo+YfJhSzaqAeAHyh+VCzc5/qWkT2HOdQSDDlLUzRXwTRUq2AvweZ3AStubCe42FnH9TaNZgdyhkaorl/fU3hnI/zc5vK9kfhT/anSiTjuyviYcCC+6Xio4QPxPo7zk4coxQwjf3zvf4Q2GrKSBVM3U/xUwtnDIAg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k/WG09qX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k/WG09qX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6697C4CEF1;
	Tue, 16 Dec 2025 12:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886801;
	bh=xx0paCrj6+rTo0Uka7cxyMcs3cqFLkf/1OiqMLSazSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k/WG09qXoctvzRlDWKZmIaErnXinNsa1ubcMra3AoHoPTzBdqcauqU9t8XM24Fq3a
	 +FapySq9tk2wS3NnJVu8CCCaA+afy6udoy5NNSYFB5pswlgjG+DMj2Ny1udKoOtGPM
	 zfet6rVFL15lrNT6no2Z3Hw+8PnWN/4ZwwM/+vz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@kernel.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 037/614] gpu: nova-core: gsp: remove useless conversion
Date: Tue, 16 Dec 2025 12:06:44 +0100
Message-ID: <20251216111402.652468339@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit 87990025b87283f1b8c50d4d75379ca6d86d2211 ]

Because nova-core depends on CONFIG_64BIT and a raw DmaAddress is
always a u64, we can remove the now actually useless conversion.

Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
[acourbot@nvidia.com: reword commit as suggested by John.]
Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Message-ID: <20250926130623.61316-1-dakr@kernel.org>
Stable-dep-of: f7a33a67c50c ("gpu: nova-core: gsp: do not unwrap() SGEntry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/nova-core/firmware/gsp.rs | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/nova-core/firmware/gsp.rs b/drivers/gpu/nova-core/firmware/gsp.rs
index 9b70095434c61..ca785860e1c82 100644
--- a/drivers/gpu/nova-core/firmware/gsp.rs
+++ b/drivers/gpu/nova-core/firmware/gsp.rs
@@ -202,8 +202,7 @@ pub(crate) fn new<'a, 'b>(
                 let mut level0_data = kvec![0u8; GSP_PAGE_SIZE]?;
 
                 // Fill level 1 page entry.
-                #[allow(clippy::useless_conversion)]
-                let level1_entry = u64::from(level1.iter().next().unwrap().dma_address());
+                let level1_entry = level1.iter().next().unwrap().dma_address();
                 let dst = &mut level0_data[..size_of_val(&level1_entry)];
                 dst.copy_from_slice(&level1_entry.to_le_bytes());
 
-- 
2.51.0



