Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5596229A1;
	Tue, 17 Feb 2026 20:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361487; cv=none; b=ihnuy4U26JMJnzpZ7U6IoFAI1ivifGPxFu9jNKNgSAfXwjX/EwYYmZnnE+DRayKCys5R1xNdS2mmOXJs/CU8/iYTv2m0Xz0TLk2mNmOPhLmgpkv+HRXgwrjorfnfPC+en9Qt9Ag6wLHbs4RWzN14feoQrBgsCRCZlnppDoaYjyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361487; c=relaxed/simple;
	bh=g+jfcuMClH2FAUO6pUMdFxgYLfAn+NlJGepFkKBgkSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5ZFZEYPBY6nlzSGlSldtc3mzciKrwJnGICnqj8WZxMkOnQwxdrLiYUquSBkZYqQYx7M+lvQR34aRSQfMqiKgpuOMZBpmlCtSE841v0BLOad3j0VSh8y9/3JKdGtIK1Ece4mVpEZEbeEBT5GodWrRCBYrUXZGtqWKjJ1078EVI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g4sCK2WT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g4sCK2WT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8844C4CEF7;
	Tue, 17 Feb 2026 20:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361487;
	bh=g+jfcuMClH2FAUO6pUMdFxgYLfAn+NlJGepFkKBgkSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g4sCK2WTtdFlpWDbU67z+A3fQSqGN+9BQga1fhKGPZzT+36S01YDTjNsel5+tRgg6
	 rrWTjbvJ04beGT8phCmu4hx+cJSQD99xUtBlCx3o+snkpbM+FyfRnC+KY3QWbK63J9
	 /y3NpoNvjGYHm5OtMv/uIsDJWeTEORoJRlFRXaTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Dirk Behme <dirk.behme@de.bosch.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.18 03/43] rust: dma: fix broken intra-doc links
Date: Tue, 17 Feb 2026 21:31:43 +0100
Message-ID: <20260217200006.602617696@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200006.470920131@linuxfoundation.org>
References: <20260217200006.470920131@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: FUJITA Tomonori <fujita.tomonori@gmail.com>

commit 32cb3840386fd3684fbe8294cfc0a6684417139e upstream.

The `pci` module is conditional on CONFIG_PCI. When it's disabled, the
intra-doc link to `pci::Device` causes rustdoc warnings:

warning: unresolved link to `::kernel::pci::Device`
  --> rust/kernel/dma.rs:30:70
   |
30 | /// where the underlying bus is DMA capable, such as [`pci::Device`](::kernel::pci::Device) or
   |                                                                      ^^^^^^^^^^^^^^^^^^^^^ no item named `pci` in module `kernel`

Fix this by making the documentation conditional on CONFIG_PCI.

Fixes: d06d5f66f549 ("rust: dma: implement `dma::Device` trait")
Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
Reviewed-by: Dirk Behme <dirk.behme@de.bosch.com>
Link: https://patch.msgid.link/20251231045728.1912024-1-fujita.tomonori@gmail.com
[ Keep the "such as" part indicating a list of examples; fix typos in
  commit message. - Danilo ]
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/dma.rs |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/rust/kernel/dma.rs
+++ b/rust/kernel/dma.rs
@@ -26,8 +26,9 @@ pub type DmaAddress = bindings::dma_addr
 /// Trait to be implemented by DMA capable bus devices.
 ///
 /// The [`dma::Device`](Device) trait should be implemented by bus specific device representations,
-/// where the underlying bus is DMA capable, such as [`pci::Device`](::kernel::pci::Device) or
-/// [`platform::Device`](::kernel::platform::Device).
+/// where the underlying bus is DMA capable, such as:
+#[cfg_attr(CONFIG_PCI, doc = "* [`pci::Device`](kernel::pci::Device)")]
+/// * [`platform::Device`](::kernel::platform::Device)
 pub trait Device: AsRef<device::Device<Core>> {
     /// Set up the device's DMA streaming addressing capabilities.
     ///


