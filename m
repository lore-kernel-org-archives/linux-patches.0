Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782D734A338;
	Tue, 26 Aug 2025 13:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215940; cv=none; b=lLsu7DJH6BnvmZ213c/c1G4W7K+EEjtFNMPPUI29Pi36CFB6RsXxbR7+dPpR24YxQP2yVAyRI6o9IkZ7Qc8Zr3zIcObp8zPB7TsZ/G0ns2jfYEcuDrQWFCqFgRrPI2S3Hc6NA6ZZA9j2q5R1dFyxA2uHSPjw/2YFuRTfNvcBGX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215940; c=relaxed/simple;
	bh=hc5uPw2glHOoXk2D8/95+t8zbPgGP7x3mKrQ77QZGKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IgTH4QUAgKTtAg2wHR4GPBqHKaz6RbzdE6M8zAmHYtUE5eS0ZDd0IyirK7Ksske2JrjTs5hOCcqMH5Lm7V31QWFe4nPZ9VmcU7HKkNqZVMR3+BcMpDpYLuUSwlWSbrwaYnKVgdXMw2HvpsSniNMitP06CjVmjHQhhalElWI3Kzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xvB7pbGa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xvB7pbGa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06707C4CEF1;
	Tue, 26 Aug 2025 13:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215940;
	bh=hc5uPw2glHOoXk2D8/95+t8zbPgGP7x3mKrQ77QZGKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xvB7pbGaNpAXtZroTEU9H1pWRfxoN6XO+TcEZRGMuvoxp9QVgeawmPtEHP3dwDSUT
	 0wwRxknua8fx1CetPf6O2FyOQBmC8XmC3+FrJUt6qhKTQSOimtbfnTdIUxKQF4twmY
	 4iPDcqiKa8CNQIT1I5/CL3SHNHsK03OehVYQrhdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timothy Pearson <tpearson@raptorengineering.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 222/644] powerpc/eeh: Export eeh_unfreeze_pe()
Date: Tue, 26 Aug 2025 13:05:13 +0200
Message-ID: <20250826110951.926055262@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 209d1a61eb94..3f68da6c75a2 100644
--- a/arch/powerpc/kernel/eeh.c
+++ b/arch/powerpc/kernel/eeh.c
@@ -1119,6 +1119,7 @@ int eeh_unfreeze_pe(struct eeh_pe *pe)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(eeh_unfreeze_pe);
 
 
 static struct pci_device_id eeh_reset_ids[] = {
-- 
2.39.5



