Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009DD3B813A;
	Sat, 12 Sep 2026 07:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196865; cv=none; b=bgMl9DMjHLFW71Bm87ZQGox5dS/uoLfpQGyYodWcwh01hwnSc/dTTeP13wkiJICx716RERH6UWne5lr+O3MYtzRZP28XHkkZqTBfFj2MbMcQRd5hCYKT/KFn6gPgRS8DpfRqcraxVsHivn6mvEeFe7NbCv19NPU2f6Yj8QE+joQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196865; c=relaxed/simple;
	bh=VyerCRcQGjGg2gf5RMRHT053qpNN7sKeXj+rdPf+MuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mLyffJ4/fR/MRDrGiNFqhPO9FWq3FzinnFcf97Hr4nXizg7uPVW1BR3kAoUg7Ln2FLVsmmbQy56u01UeWtrNw4UpUdzcT8Q9BRdq2/98AzGD2U/eVWOz26tiP3GG5eIuMgKt5ik8A2lAqHoX2b6DzcrUUz+uXNvP/Ckaj0KblGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p72FIjOz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p72FIjOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0619A1F00893;
	Sat, 12 Sep 2026 07:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196862;
	bh=TW+0s7nRWEsSRNJ4iwvxActjbIm9GBkRMeEKkyfU0L0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p72FIjOzXUjQcESBjK8e5LOYdgQYWc/KcDCFz2CHQ8AolkY3JkaWix0thLWw4YCsU
	 9AUe8KFhQ1UjUIAs26mNlUkzZxxNJPZYjB8kPr5qA1yyONlNBHMsslIzau5oTEBG6b
	 Fss3m03xJBBBQO+avvd0/oo5awhxqLQArJ05gG5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deborah Brouwer <deborah.brouwer@collabora.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0053/1815] rust: drm: gpuvm: update DriverGpuVm for DeviceContext
Date: Sat, 12 Sep 2026 08:30:03 +0200
Message-ID: <20260912065650.262428111@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deborah Brouwer <deborah.brouwer@collabora.com>

[ Upstream commit 20003c1a1fd80ae1b1742ff54297b67f7f21b77f ]

Since the introduction of DeviceContext, there is no longer a single
driver object type to equate with the GPUVM object type.

Instead of threading DeviceContext through GPUVM, remove the strict
identity between DriverGpuVm::Object and drm::Driver::Object and
instead tighten the requirement that the DriverGpuVm::Object be an
allocatable GEM object associated with the same DRM driver.

Also, make GpuVm::new() generic over DeviceContext so it can accept a
drm::Device<T::Driver, Ctx>.

Fixes: 0023a1e8d01a ("rust/drm/gem: Use DeviceContext with GEM objects")
Signed-off-by: Deborah Brouwer <deborah.brouwer@collabora.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Link: https://patch.msgid.link/20260610-gpuvm_device_context_v1-v1-1-01a890b17448@collabora.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/drm/gpuvm/mod.rs | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/rust/kernel/drm/gpuvm/mod.rs b/rust/kernel/drm/gpuvm/mod.rs
index ae58f6f667c1f..a625fcd9b5f22 100644
--- a/rust/kernel/drm/gpuvm/mod.rs
+++ b/rust/kernel/drm/gpuvm/mod.rs
@@ -116,9 +116,9 @@ impl<T: DriverGpuVm> GpuVm<T> {
 
     /// Creates a GPUVM instance.
     #[expect(clippy::new_ret_no_self)]
-    pub fn new<E>(
+    pub fn new<E, Ctx: drm::DeviceContext>(
         name: &'static CStr,
-        dev: &drm::Device<T::Driver>,
+        dev: &drm::Device<T::Driver, Ctx>,
         r_obj: &T::Object,
         range: Range<u64>,
         reserve_range: Range<u64>,
@@ -252,10 +252,10 @@ impl<T: DriverGpuVm> GpuVm<T> {
 /// The manager for a GPUVM.
 pub trait DriverGpuVm: Sized + Send {
     /// Parent `Driver` for this object.
-    type Driver: drm::Driver<Object = Self::Object>;
+    type Driver: drm::Driver;
 
     /// The kind of GEM object stored in this GPUVM.
-    type Object: IntoGEMObject;
+    type Object: drm::driver::AllocImpl<Driver = Self::Driver>;
 
     /// Data stored with each [`struct drm_gpuva`](struct@GpuVa).
     type VaData;
-- 
2.53.0



