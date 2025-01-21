Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4DC1F63CD;
	Tue, 21 Jan 2025 17:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482396; cv=none; b=CGxissElXXAOipEtm2M+ZChG+lE5BXADqhEqy841jo2lysAfvZt0wvQfjI5FgkKNqfqqoqTPNX3ERVqExy6ku2vqZYW/roY6GDjZ66YBoZ4aZEXeRJ9HgD3Rik+iQ+it1rFzdjymbGH3XcLftMn6gpZpWfHHEOhN+7aKTFcYKBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482396; c=relaxed/simple;
	bh=xZwENK5k0IoolO1nuZWI/Qtp2avJfFcd2ZFq5y0mTD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IgKP6aQf0+qCBe8dop4DNUqDQ+UVNQ4FmdHVwZfbd5JyOcZ/SkDxEcVvDPzTpF/ITQRoT797IH9Wpko6i+rSxY0+CwRnClYu5GOpj+J1PePZnnFHhXNZ+sqxAxzTDtFMYSY2zpB7JumMMY4h6fytjjbVI/yJERv8xi7GyGkD+64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PD0GOOvJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PD0GOOvJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A2BC4CEDF;
	Tue, 21 Jan 2025 17:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482396;
	bh=xZwENK5k0IoolO1nuZWI/Qtp2avJfFcd2ZFq5y0mTD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PD0GOOvJWJiTC5EspSf9yfXEfrv5vU0jnQool/QlwHhzkr/TlYAsdX+TFFPr5aS9W
	 KQCceEMEFu0GnQT2eZOR5DSR0GqPHit5xwD4KltQPuPuWggpLWgSgLYlDFcDRC0j6p
	 FtTp3JksZ8GiLKTZvEpP3syE0jmXIsjK2lhtOUyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/122] platform/x86: ISST: Add Clearwater Forest to support list
Date: Tue, 21 Jan 2025 18:51:49 +0100
Message-ID: <20250121174535.346451487@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit cc1ff7bc1bb378e7c46992c977b605e97d908801 ]

Add Clearwater Forest (INTEL_ATOM_DARKMONT_X) to SST support list by
adding to isst_cpu_ids.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://lore.kernel.org/r/20250103155255.1488139-2-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/speed_select_if/isst_if_common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/intel/speed_select_if/isst_if_common.c b/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
index 1e46e30dae966..dbcd3087aaa4b 100644
--- a/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
@@ -804,6 +804,7 @@ EXPORT_SYMBOL_GPL(isst_if_cdev_unregister);
 static const struct x86_cpu_id isst_cpu_ids[] = {
 	X86_MATCH_VFM(INTEL_ATOM_CRESTMONT,	SST_HPM_SUPPORTED),
 	X86_MATCH_VFM(INTEL_ATOM_CRESTMONT_X,	SST_HPM_SUPPORTED),
+	X86_MATCH_VFM(INTEL_ATOM_DARKMONT_X,	SST_HPM_SUPPORTED),
 	X86_MATCH_VFM(INTEL_EMERALDRAPIDS_X,	0),
 	X86_MATCH_VFM(INTEL_GRANITERAPIDS_D,	SST_HPM_SUPPORTED),
 	X86_MATCH_VFM(INTEL_GRANITERAPIDS_X,	SST_HPM_SUPPORTED),
-- 
2.39.5



