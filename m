Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E93A36C5BF;
	Wed, 20 May 2026 16:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295399; cv=none; b=LE/DuIfCcaT4FCxLDsiUF+9TRBy3APvpbO0RBsD+9bd5aLaHwDQFEK2ID2nugERPz595pfZWL5gwg93IBM65PYzqhZIiMoHo9b0yecLEJBO1SuSOVmUzIgdeVVQ6sRuddh9HUbni+yQKHWrf5QgRliZPvnUJw7k+oY0d8A3T+V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295399; c=relaxed/simple;
	bh=/VeCHI55qXqwnO/lGw/IabUKOQIeG5HK9gwBWvnmLoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ES7H9ZSuirXVB1yzwBKsQ53/BNSypONHGOItaqTC4B2TN/NolahTzCur5gNSq8f72u5EK9BAOubpIESpGBXKlWY7qF/vqwl6bsotOY4FrP6x4Y5m8jZUw8O1oO48bHbAJWl5jCmB/RsILmeMzpNESuk8MxsLzlCnR6ORAFW8JXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dH9ugU9U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dH9ugU9U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9449E1F000E9;
	Wed, 20 May 2026 16:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295398;
	bh=m80YamsfEuzJbbe5IOX3iS8O7RZWRpc7nUl84f7RxGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dH9ugU9U/q43ZlbL+9t/ELpkO9OUzcJKdbTwosP2AbtZWW2cCXSZmADEzdhArOqQZ
	 K575A+Pi4suF6070qlzK/dK/OvTyiYZXyH8zU8ag5rAHXHzeWCf/xim8haL7ZVqX9G
	 iI1ZOKmwXzine0+qZZYJKpw9L6rj0ypNn4mzP9eQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0404/1146] gpu: nova-core: remove redundant `.as_ref()` for `dev_*` print
Date: Wed, 20 May 2026 18:10:54 +0200
Message-ID: <20260520162157.342458035@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gary Guo <gary@garyguo.net>

[ Upstream commit 8d1a65c2defdc4213a49008d0531bd35d26fdf35 ]

This is now handled by the macro itself.

Signed-off-by: Gary Guo <gary@garyguo.net>
Link: https://patch.msgid.link/20260123175854.176735-7-gary@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Stable-dep-of: a7a080bb4236 ("gpu: nova-core: fix missing colon in SEC2 boot debug message")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/nova-core/driver.rs   |  2 +-
 drivers/gpu/nova-core/gpu.rs      |  4 ++--
 drivers/gpu/nova-core/gsp/boot.rs | 32 +++++++------------------------
 3 files changed, 10 insertions(+), 28 deletions(-)

diff --git a/drivers/gpu/nova-core/driver.rs b/drivers/gpu/nova-core/driver.rs
index 5a4cc047bcfc9..e39885c0d5ca5 100644
--- a/drivers/gpu/nova-core/driver.rs
+++ b/drivers/gpu/nova-core/driver.rs
@@ -70,7 +70,7 @@ impl pci::Driver for NovaCore {
 
     fn probe(pdev: &pci::Device<Core>, _info: &Self::IdInfo) -> impl PinInit<Self, Error> {
         pin_init::pin_init_scope(move || {
-            dev_dbg!(pdev.as_ref(), "Probe Nova Core GPU driver.\n");
+            dev_dbg!(pdev, "Probe Nova Core GPU driver.\n");
 
             pdev.enable_device_mem()?;
             pdev.set_master();
diff --git a/drivers/gpu/nova-core/gpu.rs b/drivers/gpu/nova-core/gpu.rs
index 9b042ef1a3086..60c85fffaeafd 100644
--- a/drivers/gpu/nova-core/gpu.rs
+++ b/drivers/gpu/nova-core/gpu.rs
@@ -262,13 +262,13 @@ impl Gpu {
     ) -> impl PinInit<Self, Error> + 'a {
         try_pin_init!(Self {
             spec: Spec::new(pdev.as_ref(), bar).inspect(|spec| {
-                dev_info!(pdev.as_ref(),"NVIDIA ({})\n", spec);
+                dev_info!(pdev,"NVIDIA ({})\n", spec);
             })?,
 
             // We must wait for GFW_BOOT completion before doing any significant setup on the GPU.
             _: {
                 gfw::wait_gfw_boot_completion(bar)
-                    .inspect_err(|_| dev_err!(pdev.as_ref(), "GFW boot did not complete\n"))?;
+                    .inspect_err(|_| dev_err!(pdev, "GFW boot did not complete\n"))?;
             },
 
             sysmem_flush: SysmemFlush::register(pdev.as_ref(), bar, spec.chipset)?,
diff --git a/drivers/gpu/nova-core/gsp/boot.rs b/drivers/gpu/nova-core/gsp/boot.rs
index 62ffed5f25a15..a13255c464bc3 100644
--- a/drivers/gpu/nova-core/gsp/boot.rs
+++ b/drivers/gpu/nova-core/gsp/boot.rs
@@ -170,15 +170,10 @@ impl super::Gsp {
             Some(libos_handle as u32),
             Some((libos_handle >> 32) as u32),
         )?;
-        dev_dbg!(
-            pdev.as_ref(),
-            "GSP MBOX0: {:#x}, MBOX1: {:#x}\n",
-            mbox0,
-            mbox1
-        );
+        dev_dbg!(pdev, "GSP MBOX0: {:#x}, MBOX1: {:#x}\n", mbox0, mbox1);
 
         dev_dbg!(
-            pdev.as_ref(),
+            pdev,
             "Using SEC2 to load and run the booter_load firmware...\n"
         );
 
@@ -190,19 +185,10 @@ impl super::Gsp {
             Some(wpr_handle as u32),
             Some((wpr_handle >> 32) as u32),
         )?;
-        dev_dbg!(
-            pdev.as_ref(),
-            "SEC2 MBOX0: {:#x}, MBOX1{:#x}\n",
-            mbox0,
-            mbox1
-        );
+        dev_dbg!(pdev, "SEC2 MBOX0: {:#x}, MBOX1{:#x}\n", mbox0, mbox1);
 
         if mbox0 != 0 {
-            dev_err!(
-                pdev.as_ref(),
-                "Booter-load failed with error {:#x}\n",
-                mbox0
-            );
+            dev_err!(pdev, "Booter-load failed with error {:#x}\n", mbox0);
             return Err(ENODEV);
         }
 
@@ -216,11 +202,7 @@ impl super::Gsp {
             Delta::from_secs(5),
         )?;
 
-        dev_dbg!(
-            pdev.as_ref(),
-            "RISC-V active? {}\n",
-            gsp_falcon.is_riscv_active(bar),
-        );
+        dev_dbg!(pdev, "RISC-V active? {}\n", gsp_falcon.is_riscv_active(bar),);
 
         // Create and run the GSP sequencer.
         let seq_params = GspSequencerParams {
@@ -239,8 +221,8 @@ impl super::Gsp {
         // Obtain and display basic GPU information.
         let info = commands::get_gsp_info(&mut self.cmdq, bar)?;
         match info.gpu_name() {
-            Ok(name) => dev_info!(pdev.as_ref(), "GPU name: {}\n", name),
-            Err(e) => dev_warn!(pdev.as_ref(), "GPU name unavailable: {:?}\n", e),
+            Ok(name) => dev_info!(pdev, "GPU name: {}\n", name),
+            Err(e) => dev_warn!(pdev, "GPU name unavailable: {:?}\n", e),
         }
 
         Ok(())
-- 
2.53.0



