Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD7F218EB1;
	Mon, 27 Oct 2025 19:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591708; cv=none; b=WagCzp3d8duW17PvNjSIw2wnzlsRQay0JOHy8aFYu3Grv3Vx188hMLNuZpF8OwauQ2DNx+NNRcTE0BOBW5XS1mKfyFqu+yJzNjFenNG4afNAgh/QjGgbnX/qLes7VAs5ygvWiolfcH5aEIjKdGejzLBOeGjU9al/boEbU6qAcSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591708; c=relaxed/simple;
	bh=TE3jv08jtfHGcOtosIVS73UL958EC0h0gnWva5joFNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=henktSQyXs+lM/Xc9A9JDXf90AKlQOrln7qVoQIFz05Nz8pR4WCEx3ySPSjhbOARe8SY8a/9tuqRCOUiZ4QWkFoMXdyjq2zXdPZThO5o1b3AcxRvq2rmLj1g7DWyl3XQ+Emr3HlsmuYlimb6J7YxSqu4/3ciLGJPecXKlde1nOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vpw5cocd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vpw5cocd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EDA9C4CEF1;
	Mon, 27 Oct 2025 19:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591707;
	bh=TE3jv08jtfHGcOtosIVS73UL958EC0h0gnWva5joFNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vpw5cocdBeHXCCXravli1zCzXkwXu1elYngX09Q/G7gqMT8pScKRSjVjsmuF1GVZb
	 0G+/TRYMgSYJzuFegMYa56dLlUJ5Z1DG0bCBksJIo96Ubf6nf4jHb22xZIWekR+pF1
	 1Dsti/U+FImqkuQlWXXswhyX0L5DLWqanL4kqXYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Winkler <tomasw@gmail.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [PATCH 5.10 299/332] mei: me: add wildcat lake P DID
Date: Mon, 27 Oct 2025 19:35:52 +0100
Message-ID: <20251027183532.745912421@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 410d6c2ad4d1a88efa0acbb9966693725b564933 upstream.

Add Wildcat Lake P device id.

Cc: stable@vger.kernel.org
Co-developed-by: Tomas Winkler <tomasw@gmail.com>
Signed-off-by: Tomas Winkler <tomasw@gmail.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Link: https://patch.msgid.link/20251016125912.2146136-1-alexander.usyskin@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h |    2 ++
 drivers/misc/mei/pci-me.c     |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -120,6 +120,8 @@
 #define MEI_DEV_ID_PTL_H      0xE370  /* Panther Lake H */
 #define MEI_DEV_ID_PTL_P      0xE470  /* Panther Lake P */
 
+#define MEI_DEV_ID_WCL_P      0x4D70  /* Wildcat Lake P */
+
 /*
  * MEI HW Section
  */
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -126,6 +126,8 @@ static const struct pci_device_id mei_me
 	{MEI_PCI_DEVICE(MEI_DEV_ID_PTL_H, MEI_ME_PCH15_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_PTL_P, MEI_ME_PCH15_CFG)},
 
+	{MEI_PCI_DEVICE(MEI_DEV_ID_WCL_P, MEI_ME_PCH15_CFG)},
+
 	/* required last entry */
 	{0, }
 };


