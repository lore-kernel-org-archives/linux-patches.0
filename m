Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827124;
	b=ERCPKCVeUMoaSJ3kaXninopm52w4vqcPuToaDzyHOqQg/lRbrybWqBhYkV1G0p5ANwOB
	 ux789Xtj0R5T2Hkyco8zshCXWBlaGHMl9FKUU+UJ9vIRfLuPqQybhQeVAsbpVhXvGKflo
	 ck4pVXWFyYddpMCRIv4V72qjg3yOp78hci+a/Bdo8UIdqS5zP1TS6erPjIefVxC25hsLh
	 Z0s/STgjUiq8K8ueoyrMst6Cl4rYM6p3A/le5jJTypFijfne3cucgoVa8bB14seYMUQrF
	 8olOczpsibCPU8t53h7CNam/hFFJFB4J8zpdSnBN54LGypkUcvrj/SqMZKZKy3+Pnxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827124;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZTMQBMhROTnUjfFSiJ7H4oxSOANYclgkz23A7UImSec=;
	b=Z46RaOYoC3qMbl57CWPebPP6dIUelzX7xGkBFHOtXJgV78vPmKxQcYvKWW1aYCA6c2Lt
	 POeDlQbEYeKNuXatyzN8/LZQBuGqsbu3edVwOsBANp/7FvTt5JHq6e8Jqq9mKrA4c249J
	 LEMOiYWkqZYvru2tOseqjbB68u6IyXUCb29XJTaR19AN/sGJVh14f4URn325ToYdKZni5
	 6SudHTFuMSodnYEcDrOk/EsdogImc3XMq3KVInduowX6G5UESsy3RHl5e+TdyANVklvOq
	 RCqz9rcalOLPyLMl8pSETygvFUL62s6vUADN22u5pdRLMzqHxUx48imcvAkyCocWDAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oEzD8Xgl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A35B606AE33;
	Wed,  4 Nov 2026 21:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oEzD8Xgl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C091F00A15;
	Wed,  4 Nov 2026 21:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827124;
	bh=ZTMQBMhROTnUjfFSiJ7H4oxSOANYclgkz23A7UImSec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oEzD8XglGAR2Gllrp4vhXZkDZ4BCZv1HETiDL7wMdQN7w1t01+zHRzKZivLZjEU48
	 jl+NeoMD7Vu2Jm0paIv/gZ30ocyGm1po+BgsQQfHGvRDftO3SKTawovw6SXKz2er5B
	 grBHd7m5JM1Dvb4nRPqx4M1tLnW+50osfWKl6Ik8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Zhi Wang <zhiw@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 7.3 201/547] rust: fwctl: declare cfi_encoding for fwctl_rpc_scope
Date: Wed,  4 Nov 2026 16:06:25 -0500
Message-ID: <20261104211043.854624266@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Ryhl <aliceryhl@google.com>

commit bc6f2a284c63313e789d8cd294531e1cc2dc8c99 upstream.

Currently, VTable::fw_rpc_callback() takes scope as a u32, whereas C
calls fwctl_ops::fw_rpc with enum fwctl_rpc_scope. With kCFI enabled,
enum types are encoded distinctly from integers, causing every fw_rpc
indirect call into a Rust fwctl driver to trip a CFI failure. Thus,
generate fwctl_rpc_scope as a newtype with a cfi_encoding attribute and
use it in fw_rpc_callback().

Link: https://patch.msgid.link/r/20261020-fwctl-cfi-encoding-v1-1-ebb30d1500df@google.com
Cc: stable@vger.kernel.org
Fixes: e052daab94ee ("rust: introduce abstractions for fwctl")
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Zhi Wang <zhiw@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/bindgen_parameters |    2 ++
 rust/kernel/fwctl.rs    |   12 ++++++------
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/rust/bindgen_parameters
+++ b/rust/bindgen_parameters
@@ -27,6 +27,8 @@
 --opaque-type spinlock
 
 # enums that appear in indirect function calls should specify a cfi type
+--newtype-enum fwctl_rpc_scope
+--with-attribute-custom-enum=fwctl_rpc_scope='#[cfi_encoding="15fwctl_rpc_scope"]'
 --newtype-enum lru_status
 --with-attribute-custom-enum=lru_status='#[cfi_encoding="10lru_status"]'
 
--- a/rust/kernel/fwctl.rs
+++ b/rust/kernel/fwctl.rs
@@ -53,13 +53,13 @@ pub enum DeviceType {
 #[derive(Copy, Clone, Debug, Eq, PartialEq)]
 pub enum RpcScope {
     /// Read/write access to device configuration.
-    Configuration = bindings::fwctl_rpc_scope_FWCTL_RPC_CONFIGURATION,
+    Configuration = bindings::fwctl_rpc_scope::FWCTL_RPC_CONFIGURATION.0,
     /// Read-only access to debug information.
-    DebugReadOnly = bindings::fwctl_rpc_scope_FWCTL_RPC_DEBUG_READ_ONLY,
+    DebugReadOnly = bindings::fwctl_rpc_scope::FWCTL_RPC_DEBUG_READ_ONLY.0,
     /// Write access to lockdown-compatible debug information.
-    DebugWrite = bindings::fwctl_rpc_scope_FWCTL_RPC_DEBUG_WRITE,
+    DebugWrite = bindings::fwctl_rpc_scope::FWCTL_RPC_DEBUG_WRITE.0,
     /// Full read/write access to all debug information (requires `CAP_SYS_RAWIO`).
-    DebugWriteFull = bindings::fwctl_rpc_scope_FWCTL_RPC_DEBUG_WRITE_FULL,
+    DebugWriteFull = bindings::fwctl_rpc_scope::FWCTL_RPC_DEBUG_WRITE_FULL.0,
 }
 
 impl TryFrom<u32> for RpcScope {
@@ -539,12 +539,12 @@ impl<T: Operations> VTable<T> {
     /// - `out_len` must be valid for reading and writing an initialised `usize`.
     unsafe extern "C" fn fw_rpc_callback(
         uctx: *mut bindings::fwctl_uctx,
-        scope: u32,
+        scope: bindings::fwctl_rpc_scope,
         rpc_in: *mut ffi::c_void,
         in_len: usize,
         out_len: *mut usize,
     ) -> *mut ffi::c_void {
-        let scope = match RpcScope::try_from(scope) {
+        let scope = match RpcScope::try_from(scope.0) {
             Ok(s) => s,
             Err(e) => return Error::to_ptr(e),
         };


