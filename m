Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C5129BDB7;
	Tue, 12 Aug 2025 19:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026566; cv=none; b=XyW6LB3iYEvfsdzt/gYIn4smFa/S81VcoZ/U1uyUDOG/6CBY9c8sqTsR5Rgr2qlxhnxvo0UjN95LhBIlDuLzm5SvG4bANri9dQVLgSAk9J8nBL8nSrfH220mOWZODwLybH+3F8xiEKedtaa13YX2NtxY8hUfAY0c/SoWniCyz2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026566; c=relaxed/simple;
	bh=RXa7IDcOQRIc6JM8S+TXFQuv4bM+rps5/0VnewKSaAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qom3/9A84ShXE/CoAow5yASkFHkzkgSIinELUG0bUKiUk1V6E5o9kVQ9GOFcW1b7N+z3QC9BgOwFG+mwOrQdlYlD0Ob7eypNJaqFfZZtGzSW08RS4gfPmc4lgoZFXJaqUakEOsgj65WeGtfS/54wMJ74z+2MlzyOmNzLi1cFuPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vnqv1+tZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vnqv1+tZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3F8C4CEF0;
	Tue, 12 Aug 2025 19:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026566;
	bh=RXa7IDcOQRIc6JM8S+TXFQuv4bM+rps5/0VnewKSaAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vnqv1+tZuCd83378ac0VNynMNH3W28RwhdzI6/7GCKJxqodz8dsy6XRyOQNPHqeNg
	 spZ+6arsbgO+O3vGU5NNo+4j8qkXahdI2Ocwnh/rhmsq2vh1qA++YzCCPQ6Ccr5PLp
	 lhQJCF53QsHClflHh0/+sMdS4EOykzvFnFhy49zM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timothy Pearson <tpearson@raptorengineering.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 376/480] powerpc/eeh: Export eeh_unfreeze_pe()
Date: Tue, 12 Aug 2025 19:49:44 +0200
Message-ID: <20250812174412.939044342@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index ca7f7bb2b478..2b5f3323e107 100644
--- a/arch/powerpc/kernel/eeh.c
+++ b/arch/powerpc/kernel/eeh.c
@@ -1139,6 +1139,7 @@ int eeh_unfreeze_pe(struct eeh_pe *pe)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(eeh_unfreeze_pe);
 
 
 static struct pci_device_id eeh_reset_ids[] = {
-- 
2.39.5



