Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A5A2BE058;
	Tue, 26 Aug 2025 14:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217495; cv=none; b=G28Sk9w1kp61c+7ZERQmCyF7xwWbVjad1cCA2k77TaBOG4yHH3PeMo+Q0BWye+QW/xzxXn5Tuekypf4bMovZ4CXXft+EiGRmCubZv4AVD3bOpbw6/O71IAn3HOFl9Dkb5glDmmeMfvA79+8mhqjCG15eB9E8YQi9twv7IwVlCBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217495; c=relaxed/simple;
	bh=FmQWdyAS3ag1kQVLHPi9qtG0Bva/K+Vk2vjITuQeSkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=md6+yOsU7YP/UN9/HMD/qrELp1YlzDq7mtONHO1+QdQI9zdqmLFIt2/zXL7nTb/GBR+61U1n2hms3OKCpbmLPL2ro5wqqg8hFXoJCrONIPl2KE1LDmiCDjdUNrsBdtaLTjiXgUgKNP7Eh0Kt/RPvqST2GzLGbbInXm0PMPozE+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V6Xg9gJN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V6Xg9gJN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4312C4CEF1;
	Tue, 26 Aug 2025 14:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217495;
	bh=FmQWdyAS3ag1kQVLHPi9qtG0Bva/K+Vk2vjITuQeSkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V6Xg9gJNf+vMWB7s4rGFbUEZp1Zh8jXomM1lvdw2OVsbf2/NhQyglHsvkwpxRjOUc
	 HeYSUAAkvAEOom5psNcDxcDR61q3w/b5ZA0vaBLDov6KQAttwIbFs2HE/qeD0DvCcm
	 jrYk1g2rMXOd2TkF0qaljmvvkCPKzmmrblpnxgbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timothy Pearson <tpearson@raptorengineering.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 163/523] powerpc/eeh: Export eeh_unfreeze_pe()
Date: Tue, 26 Aug 2025 13:06:13 +0200
Message-ID: <20250826110928.493282286@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timothy Pearson <tpearson@raptorengineering.com>

[ Upstream commit e82b34eed04b0ddcff4548b62633467235672fd3 ]

The PowerNV hotplug driver needs to be able to clear any frozen PE(s)
on the PHB after suprise removal of a downstream device.

Export the eeh_unfreeze_pe() symbol to allow implementation of this
functionality in the php_nv module.

Signed-off-by: Timothy Pearson <tpearson@raptorengineering.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/1778535414.1359858.1752615454618.JavaMail.zimbra@raptorengineeringinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/eeh.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kernel/eeh.c b/arch/powerpc/kernel/eeh.c
index fbc6eaaf10e1..cd5364e8fe3d 100644
--- a/arch/powerpc/kernel/eeh.c
+++ b/arch/powerpc/kernel/eeh.c
@@ -1140,6 +1140,7 @@ int eeh_unfreeze_pe(struct eeh_pe *pe)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(eeh_unfreeze_pe);
 
 
 static struct pci_device_id eeh_reset_ids[] = {
-- 
2.39.5



