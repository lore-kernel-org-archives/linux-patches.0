Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF599471267;
	Tue, 21 Jul 2026 18:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657225; cv=none; b=JHeYEtAfCrCbqaDR3xlVtf1QM/u2kiesWxh75HgawZUrNRyvb+09qZj4mciabA0O3TeTjHqR6gGmROtA0jxKv4ij8S9ksFgwbpLJIO7UmA9lo4vuXOeO+0MbC0K0i+KqFe3rxMJ8K111ScyWxR0LhwCTxVXrdzaYmmm2SGCCUmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657225; c=relaxed/simple;
	bh=PvnhfOEL5CZRgr38eDsZ8Vuy5ytY4PM+q6yTTfo9Oy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GTNbqd8F2SykdFaUs9MG0ElHhviRNk//vh/UPWu3hkAvqrnFqepZlV4hM1QAYYZunCFybMOFxqh1af7zVPwmMNIQoR8VyScveMYc9HsPE/Rf/ejZAq1jQuva7YxzmOOepAiMM9Hsyo1yFG/ep8ItSeWKs6sZc9Cw4l1uFeUFaU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iR/fzBlV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iR/fzBlV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BE21F000E9;
	Tue, 21 Jul 2026 18:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657223;
	bh=1qyhfIlF9IRsb8Ni2PiAzPLivAQC6nUuWawQeKJulms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iR/fzBlV0YHmzHcTlJosxKefxz3y+wQEv11UD1JniJZ8Afi1jtJEYNudu2YWhTsKx
	 pVBPEng+keQ2Jh9sORrHgDL49COmWqV6P4i7WWqx3Qh91wurnEza3W43JJxcfux9Iy
	 vThWOI6n58QLnSl3+O9emrLnoIVo89DPoV2oCDk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0683/1611] platform/x86/intel/vsec: correct kernel-doc comments
Date: Tue, 21 Jul 2026 17:13:19 +0200
Message-ID: <20260721152530.744784812@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 20e20b147cf7cb6780a5b95da2a0e37c52cd1015 ]

Fix kernel-doc warnings in intel_vsec.h to eliminate all kernel-doc
warnings:

Warning: include/linux/intel_vsec.h:92 struct member 'read_telem' not
 described in 'pmt_callbacks'
Warning: include/linux/intel_vsec.h:146 expecting prototype for struct
 intel_sec_device.  Prototype was for struct intel_vsec_device instead
Warning: include/linux/intel_vsec.h:146 struct member 'priv_data_size'
 not described in 'intel_vsec_device'

In struct pmt_callbacks, correct the kernel-doc for @read_telem.
kernel-doc doesn't support documenting callback function parameters,
so drop the '@' signs on those and use "* *" to make them somewhat
readable in the produced documentation output.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://patch.msgid.link/20251216063801.2896495-1-rdunlap@infradead.org
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 375bbbbd112a ("platform/x86/intel/vsec: Restore BAR fallback for header walk")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/intel_vsec.h | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/linux/intel_vsec.h b/include/linux/intel_vsec.h
index d7f1f531660a8d..d551174b004916 100644
--- a/include/linux/intel_vsec.h
+++ b/include/linux/intel_vsec.h
@@ -80,13 +80,13 @@ enum intel_vsec_quirks {
 
 /**
  * struct pmt_callbacks - Callback infrastructure for PMT devices
- * ->read_telem() when specified, called by client driver to access PMT data (instead
- * of direct copy).
- * @pdev:  PCI device reference for the callback's use
- * @guid:  ID of data to acccss
- * @data:  buffer for the data to be copied
- * @off:   offset into the requested buffer
- * @count: size of buffer
+ * @read_telem: when specified, called by client driver to access PMT
+ * data (instead of direct copy).
+ * * pdev:  PCI device reference for the callback's use
+ * * guid:  ID of data to acccss
+ * * data:  buffer for the data to be copied
+ * * off:   offset into the requested buffer
+ * * count: size of buffer
  */
 struct pmt_callbacks {
 	int (*read_telem)(struct pci_dev *pdev, u32 guid, u64 *data, loff_t off, u32 count);
@@ -120,7 +120,7 @@ struct intel_vsec_platform_info {
 };
 
 /**
- * struct intel_sec_device - Auxbus specific device information
+ * struct intel_vsec_device - Auxbus specific device information
  * @auxdev:        auxbus device struct for auxbus access
  * @pcidev:        pci device associated with the device
  * @resource:      any resources shared by the parent
@@ -128,6 +128,7 @@ struct intel_vsec_platform_info {
  * @num_resources: number of resources
  * @id:            xarray id
  * @priv_data:     any private data needed
+ * @priv_data_size: size of private data area
  * @quirks:        specified quirks
  * @base_addr:     base address of entries (if specified)
  * @cap_id:        the enumerated id of the vsec feature
-- 
2.53.0



