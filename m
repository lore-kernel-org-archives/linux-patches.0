Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B65E215060;
	Tue, 29 Apr 2025 17:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949394; cv=none; b=HWf7dx8RHvYWeeEN6lUvxfVhvUIET/kfu4XscGoi7TE8N2JN/GODlpMDggTvDcgG0I3FrIYpkX+t+2kj5qA5LZTwAtGmuP1M+SqiPS1+IF/ZEWyqq/lQnuXVnjmkqniDWNkHQYx2Eb+35fvsZCf78tfjLkRfV9e9zsboRi1uVgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949394; c=relaxed/simple;
	bh=G2tvZk8XCieE66x6CLFlqt/LV7+ZwWwUf35iiuaGS28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RpsylmR8VOTqFnzhNEKMOqe3BhWvAX1xz3R50hDgzA4+826V+qn96cOEa2Tc8rZxdzBwtl/XeVZvzSa0lLo7wEjBxO9c8YqXowtmAMHu914gvkblKYu/nPe3KOkcgZvCP94AgMu9Ya1+/SUMU9V1sabh4WCcUoyb9XfcscbnA/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yBksoTqr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yBksoTqr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6451AC4CEE3;
	Tue, 29 Apr 2025 17:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949393;
	bh=G2tvZk8XCieE66x6CLFlqt/LV7+ZwWwUf35iiuaGS28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yBksoTqraA+cyrolS3i5QB2I+90tWNtmyYxR90q0BFIxnChAhev2xDAQlBfz4bzkm
	 Qzocu3PoF7qJL3fBSA0uPO3Hb/42IQyO1MDh4g6pUcji5rK+01prZygdarqWE19UuT
	 +Q74RPS7uP4x2PN7pvnzkPDgSzg6a+IUH+JDbCDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tomas Winkler <tomasw@gmail.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [PATCH 5.15 304/373] mei: me: add panther lake H DID
Date: Tue, 29 Apr 2025 18:43:01 +0200
Message-ID: <20250429161135.620196483@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 86ce5c0a1dec02e21b4c864b2bc0cc5880a2c13c upstream.

Add Panther Lake H device id.

Cc: stable <stable@kernel.org>
Co-developed-by: Tomas Winkler <tomasw@gmail.com>
Signed-off-by: Tomas Winkler <tomasw@gmail.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Link: https://lore.kernel.org/r/20250408130005.1358140-1-alexander.usyskin@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h |    1 +
 drivers/misc/mei/pci-me.c     |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -117,6 +117,7 @@
 
 #define MEI_DEV_ID_LNL_M      0xA870  /* Lunar Lake Point M */
 
+#define MEI_DEV_ID_PTL_H      0xE370  /* Panther Lake H */
 #define MEI_DEV_ID_PTL_P      0xE470  /* Panther Lake P */
 
 /*
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -123,6 +123,7 @@ static const struct pci_device_id mei_me
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_LNL_M, MEI_ME_PCH15_CFG)},
 
+	{MEI_PCI_DEVICE(MEI_DEV_ID_PTL_H, MEI_ME_PCH15_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_PTL_P, MEI_ME_PCH15_CFG)},
 
 	/* required last entry */


