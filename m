Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4583F20C497;
	Tue, 17 Jun 2025 16:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178751; cv=none; b=sSnDaJi9PsFZ+U59LR9ldZMxd22nlbIAPSndVzcT/fU+Qb/SuAvuQURNvs6CioZZr5k9dXakVoUqxkPXkBLWmaPLu9WsRrhDl+W0e2ssOtU5ls4bkODBIizGGwsJ/A3zkTx8nptaYH14RJkA4zTuM4LZbY0yBlM2jnNhUSSnKso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178751; c=relaxed/simple;
	bh=XYqlDrs3MTM2nDQM9UNm3gA1OBww1PjCEwymFgOl38w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uv57jQTErTfqK2dMGetgdUY7VWnvpgWSvd010BsQCcHgTvoRuX2g4777K9RvOHJo/LP6MVdPYnWRwpX2bXFknFwdmTpXwcXtAw5vfL91w3sWKRgIZskmEpmLrlEBKI2RoF/GC1vfKFmtG6pSPF43g1xuVDw4EQIbIr2cs2zS4ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lHJ76Fnh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lHJ76Fnh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0409C4CEE3;
	Tue, 17 Jun 2025 16:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178751;
	bh=XYqlDrs3MTM2nDQM9UNm3gA1OBww1PjCEwymFgOl38w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lHJ76Fnh6wAOsVF/1azMEQsxTUjxzKEVbV+oqYHyZ3YxUcF4iBgHB+FuWFj8+VThj
	 GZQWBsxvNcEArIvp+Rb0wFhkp5T8zAiDdxwQj6lgQZxzowd7EMTV4F9M7ZcAXbz/24
	 BqN2519I12IgDR80mtt8Q2qP0nWiq/axEE7R/gQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benno Lossin <benno.lossin@proton.me>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 512/780] rust: pci: fix docs related to missing Markdown code spans
Date: Tue, 17 Jun 2025 17:23:40 +0200
Message-ID: <20250617152512.364614672@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

From: Miguel Ojeda <ojeda@kernel.org>

[ Upstream commit 1dbaf8b1bafb8557904eb54b98bb323a3061dd2c ]

In particular:

  - Add missing Markdown code spans.

  - Improve title for `DeviceId`, adding a link to the struct in the
    C side, rather than referring to `bindings::`.

  - Convert `TODO` from documentation to a normal comment, and put code
    in block.

This was found using the Clippy `doc_markdown` lint, which we may want
to enable.

Fixes: 1bd8b6b2c5d3 ("rust: pci: add basic PCI device / driver abstractions")
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Acked-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20250324210359.1199574-8-ojeda@kernel.org
[ Prefixed link text with `struct`. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/pci.rs | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/rust/kernel/pci.rs b/rust/kernel/pci.rs
index c97d6d470b282..bbc453c6d9ea8 100644
--- a/rust/kernel/pci.rs
+++ b/rust/kernel/pci.rs
@@ -118,7 +118,9 @@ macro_rules! module_pci_driver {
 };
 }
 
-/// Abstraction for bindings::pci_device_id.
+/// Abstraction for the PCI device ID structure ([`struct pci_device_id`]).
+///
+/// [`struct pci_device_id`]: https://docs.kernel.org/PCI/pci.html#c.pci_device_id
 #[repr(transparent)]
 #[derive(Clone, Copy)]
 pub struct DeviceId(bindings::pci_device_id);
@@ -173,7 +175,7 @@ unsafe impl RawDeviceId for DeviceId {
     }
 }
 
-/// IdTable type for PCI
+/// `IdTable` type for PCI.
 pub type IdTable<T> = &'static dyn kernel::device_id::IdTable<DeviceId, T>;
 
 /// Create a PCI `IdTable` with its alias for modpost.
@@ -224,10 +226,11 @@ macro_rules! pci_device_table {
 /// `Adapter` documentation for an example.
 pub trait Driver: Send {
     /// The type holding information about each device id supported by the driver.
-    ///
-    /// TODO: Use associated_type_defaults once stabilized:
-    ///
-    /// type IdInfo: 'static = ();
+    // TODO: Use `associated_type_defaults` once stabilized:
+    //
+    // ```
+    // type IdInfo: 'static = ();
+    // ```
     type IdInfo: 'static;
 
     /// The table of device ids supported by the driver.
-- 
2.39.5



