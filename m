Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE7027A462;
	Thu, 15 Jan 2026 17:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498639; cv=none; b=F3Q3lKe53xzEjC7gMOdoFJVeHogOvd0kIYgmTTwUj9cQs6xZTT2rIZZH3ZtLfVLwaAaBxPkMJOMhtj5X5AUwquump+UUWsRLn/BzMNrp4DZo89NMPfVGngRyNVq9du6bm+KSHsoYdGIqsq8iXMZaW6xWbd63tdJza7SeX3wspW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498639; c=relaxed/simple;
	bh=6B3KGPbe2loPMSMJ9WOsXwBni7KBe/ImFNIGbgHxILE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qvSQ6hTOeKClpUIQjUuPTBVzTTCg9AgPqcspS9IxJNJGxBpgHUw46JAw3nrcpbQV+vQagDqZWKIzB3XA4JLIs9BoLYXx1K0hep2rPxPmWUEjO8hEvrx+14OddAHn32Ht/jCc9IIwZ3GzbsxSkOjaZ/nyAsJLdfQNF8So0u6Hmo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l/IF/fuu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l/IF/fuu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38077C116D0;
	Thu, 15 Jan 2026 17:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498639;
	bh=6B3KGPbe2loPMSMJ9WOsXwBni7KBe/ImFNIGbgHxILE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l/IF/fuuW94lu1d1TitC+iXa5NtycdVybtzetW+T5mShMuJDAQ7ysZSuutD6lf4QK
	 YTeu9PY5GBRllizrLTP9CAp/SyCAFtWuwkljGIG+zmpYNt7QEAFESw/QP86gCI+1DW
	 F/4nZD7LKxJ63EySPTyEjzkr4DuMQbY7o5SMfBAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tomas Winkler <tomasw@gmail.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [PATCH 5.15 503/554] mei: me: add nova lake point S DID
Date: Thu, 15 Jan 2026 17:49:29 +0100
Message-ID: <20260115164304.524377864@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 420f423defcf6d0af2263d38da870ca4a20c0990 upstream.

Add Nova Lake S device id.

Cc: stable <stable@kernel.org>
Co-developed-by: Tomas Winkler <tomasw@gmail.com>
Signed-off-by: Tomas Winkler <tomasw@gmail.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Link: https://patch.msgid.link/20251215105915.1672659-1-alexander.usyskin@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h |    2 ++
 drivers/misc/mei/pci-me.c     |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -122,6 +122,8 @@
 
 #define MEI_DEV_ID_WCL_P      0x4D70  /* Wildcat Lake P */
 
+#define MEI_DEV_ID_NVL_S      0x6E68  /* Nova Lake Point S */
+
 /*
  * MEI HW Section
  */
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -128,6 +128,8 @@ static const struct pci_device_id mei_me
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_WCL_P, MEI_ME_PCH15_CFG)},
 
+	{MEI_PCI_DEVICE(MEI_DEV_ID_NVL_S, MEI_ME_PCH15_CFG)},
+
 	/* required last entry */
 	{0, }
 };


