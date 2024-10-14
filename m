Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D311AB52F;
	Mon, 14 Oct 2024 14:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917003; cv=none; b=juqZmhoU00lwP+6M1urV0sD7yKsQIDqeaYx09/a3pVk3MYrijdX+3RYYiItN8WZJfvloJrDlWipmK2PDO5HIyCNcTjhw6qh2zKqdw2xxGfstY7B3BuH75B0BiBNsxt1oCGIXWCdi1oGkdyZjEtgtl7R8UqtMnFXY0HM5gBGLy0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917003; c=relaxed/simple;
	bh=9lJoN9uK1HnDJT9piNDhfjxVzzOER3nYOT7Now6BbDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IUIQFbS59f8QDZASmbShfrxzzeDEpLuXMzoSCL+IWdomNp/j5bIuIqDe3Lk6Z403xrN2D+GHaKOgXfaCNNpcvQVtswfPamTdvErBRxYKjww1gEAQpnlBDz4hAYS0NNhpcGcpyE7jcQPuem+vQbFueGCInITaiCWLpeEYK+gZQe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nMiResTc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nMiResTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28857C4CED1;
	Mon, 14 Oct 2024 14:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917003;
	bh=9lJoN9uK1HnDJT9piNDhfjxVzzOER3nYOT7Now6BbDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nMiResTcMw/B9bUdCxMSYEUaawMtCnNrxBa/yfXef/+3QOjd86yNr5SkQE1As+9OO
	 6dWx2si+9jibPqTUEU6J3PsuI9CCtcAC5AlfcV8rahjw5HVWMZMot/dkS99UgrxKEg
	 gEasX3+tvC6OeNBqYe3gYO58fSQ7RNcSngznFU7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 107/213] x86/amd_nb: Add new PCI IDs for AMD family 0x1a
Date: Mon, 14 Oct 2024 16:20:13 +0200
Message-ID: <20241014141047.145484827@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

[ Upstream commit 0e640f0a47d8426eab1fb9c03f0af898dfe810b8 ]

Add the new PCI Device IDs to the MISC IDs list to support new
generation of AMD 1Ah family 70h Models of processors.

  [ bp: Massage commit message. ]

Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20240510111829.969501-1-Shyam-sundar.S-k@amd.com
Stable-dep-of: 59c34008d3bd ("x86/amd_nb: Add new PCI IDs for AMD family 1Ah model 60h")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/amd_nb.c | 1 +
 include/linux/pci_ids.h  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index 6f1cc7f1b202a..8a1a6faf29658 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -92,6 +92,7 @@ static const struct pci_device_id amd_nb_misc_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_19H_M78H_DF_F3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_1AH_M00H_DF_F3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_1AH_M20H_DF_F3) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_1AH_M70H_DF_F3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_MI200_DF_F3) },
 	{}
 };
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index cebfd1bb9dfa1..f195ebc3ecb57 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -580,6 +580,7 @@
 #define PCI_DEVICE_ID_AMD_19H_M78H_DF_F3 0x12fb
 #define PCI_DEVICE_ID_AMD_1AH_M00H_DF_F3 0x12c3
 #define PCI_DEVICE_ID_AMD_1AH_M20H_DF_F3 0x16fb
+#define PCI_DEVICE_ID_AMD_1AH_M70H_DF_F3 0x12bb
 #define PCI_DEVICE_ID_AMD_MI200_DF_F3	0x14d3
 #define PCI_DEVICE_ID_AMD_VANGOGH_USB	0x163a
 #define PCI_DEVICE_ID_AMD_CNB17H_F3	0x1703
-- 
2.43.0



