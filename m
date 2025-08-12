Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A86217736;
	Tue, 12 Aug 2025 18:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021793; cv=none; b=HbVzD2mFy3JPLY29KagwyS45Zbn1bZhabwdAt5KmJDjcaN80grWUM6y61YhQDj5aS9JGKPVEI/NFledM4QV1qHjvUD7PDs16kjyrKZHjF1FoHOPdZ64DDbyz1iQqt9lKyvh/8cUgIukFL1i81eYaoR+RoOZpV/VMP5raa0brRNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021793; c=relaxed/simple;
	bh=wkj4KrZx/APBMQiI/8/AORWGXjAV5tCHDCrJCkeXdPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hbb6jylWBNdKz21o8DXynrFMSAoBDCfL2uiQvJ7dgkkbnAN0uwazjbfPgElqVV4NB35knmirAyS4/b8NC+cO4VhoXe59WWwWBnJU+Lzy8h741BPqhWBG4LRcg01HLiLCaNfXUDjfhDVvxb6n96/R/UqwMIxvdqQNPDk9H8V3lM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0hYIjXrR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0hYIjXrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00BB3C4CEF7;
	Tue, 12 Aug 2025 18:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021792;
	bh=wkj4KrZx/APBMQiI/8/AORWGXjAV5tCHDCrJCkeXdPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0hYIjXrRF9rDNcwtUacRKIR+unD809XnBqGlXIlyli8NzPnQXF9q0t4u03oYZBhmM
	 f7nLvStdtG1hUcmNPjMjE7e7SiJZboFafh6NjDTLTMNQzjVwa7CPzEZCr7nNfn9WzV
	 Zuk467MbU5EyN11j/2h7Ql+MybzL+YQw/IOAz2jE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timothy Pearson <tpearson@raptorengineering.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 193/262] powerpc/eeh: Export eeh_unfreeze_pe()
Date: Tue, 12 Aug 2025 19:29:41 +0200
Message-ID: <20250812173001.349811249@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2e286bba2f64..82626363a309 100644
--- a/arch/powerpc/kernel/eeh.c
+++ b/arch/powerpc/kernel/eeh.c
@@ -1130,6 +1130,7 @@ int eeh_unfreeze_pe(struct eeh_pe *pe)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(eeh_unfreeze_pe);
 
 
 static struct pci_device_id eeh_reset_ids[] = {
-- 
2.39.5



