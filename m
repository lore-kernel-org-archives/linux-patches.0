Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBAA927D786;
	Tue, 11 Nov 2025 01:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823479; cv=none; b=ZDcdjRQzL9ZeoovqnanyBirOlvcMw7tDM0aaaJEjB59BPAgzyQzwqnubPLigqgLL+uuugE5a1P2JTLaTxsnZEC6muB39tehEalHuxsttYaYnfFQl+e747zeDbssxAis2CI8j5nKWQuTBShlXtOCljdR5fEowkUlp+GxeBDO2UVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823479; c=relaxed/simple;
	bh=cWTzerl7qRnW9+nA9aXxZ6CuFSejZe5ejCCwPrIUqf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iu2YbiJeCwS7bEiAIzizOcWMEelmpSNS6i2dfaPlrJer/yykUTWEijHMySlYAXx+SHybV0skdeokyHhqzjO0TFTZ67sn3BC3uXIPxZslny5cSy989OCm0CqhTYeCKnd0zxEn4jW1u8mnHr8ZazwsQo0WEOPiANxrejYErCP3h70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1S1cHm6s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1S1cHm6s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD4BC16AAE;
	Tue, 11 Nov 2025 01:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823479;
	bh=cWTzerl7qRnW9+nA9aXxZ6CuFSejZe5ejCCwPrIUqf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1S1cHm6sSHoG4b0/5Vh4cTbaZROn2ldh99ZVhvxodF07lo+Wzyrun+yDgVAPLHxoV
	 /7JAwpk/OIVAN5QMFw/vTnHbGYC/k3Xjt07CwqSrh9Khc/EU0FuIBNTcZunKRpvoxP
	 G42EYk3PxZml/1+NMMSAspubLzl29ttsiRsna1jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timur Tabi <ttabi@nvidia.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Lyude Paul <lyude@redhat.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 308/849] gpu: nova-core: register: allow fields named `offset`
Date: Tue, 11 Nov 2025 09:37:58 +0900
Message-ID: <20251111004543.859589995@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Courbot <acourbot@nvidia.com>

[ Upstream commit c5aeb264b6b27c52fc6c9ef3b50eaaebff5d9b60 ]

`offset` is a common field name, yet using it triggers a build error due
to the conflict between the uppercased field constant (which becomes
`OFFSET` in this case) containing the bitrange of the field, and the
`OFFSET` constant constaining the offset of the register.

Fix this by adding `_RANGE` the field's range constant to avoid the
name collision.

[acourbot@nvidia.com: fix merge conflict due to switch from `as u32` to
`u32::from`.]

Reported-by: Timur Tabi <ttabi@nvidia.com>
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Link: https://lore.kernel.org/r/20250718-nova-regs-v2-3-7b6a762aa1cd@nvidia.com
Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/nova-core/regs.rs        | 5 +++--
 drivers/gpu/nova-core/regs/macros.rs | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/nova-core/regs.rs b/drivers/gpu/nova-core/regs.rs
index d49fddf6a3c6e..c8f8adb24f6e4 100644
--- a/drivers/gpu/nova-core/regs.rs
+++ b/drivers/gpu/nova-core/regs.rs
@@ -28,7 +28,7 @@ impl NV_PMC_BOOT_0 {
     /// Combines `architecture_0` and `architecture_1` to obtain the architecture of the chip.
     pub(crate) fn architecture(self) -> Result<Architecture> {
         Architecture::try_from(
-            self.architecture_0() | (self.architecture_1() << Self::ARCHITECTURE_0.len()),
+            self.architecture_0() | (self.architecture_1() << Self::ARCHITECTURE_0_RANGE.len()),
         )
     }
 
@@ -36,7 +36,8 @@ impl NV_PMC_BOOT_0 {
     pub(crate) fn chipset(self) -> Result<Chipset> {
         self.architecture()
             .map(|arch| {
-                ((arch as u32) << Self::IMPLEMENTATION.len()) | u32::from(self.implementation())
+                ((arch as u32) << Self::IMPLEMENTATION_RANGE.len())
+                    | u32::from(self.implementation())
             })
             .and_then(Chipset::try_from)
     }
diff --git a/drivers/gpu/nova-core/regs/macros.rs b/drivers/gpu/nova-core/regs/macros.rs
index a3e6de1779d41..00b398522ea18 100644
--- a/drivers/gpu/nova-core/regs/macros.rs
+++ b/drivers/gpu/nova-core/regs/macros.rs
@@ -278,7 +278,7 @@ macro_rules! register {
             { $process:expr } $to_type:ty => $res_type:ty $(, $comment:literal)?;
     ) => {
         ::kernel::macros::paste!(
-        const [<$field:upper>]: ::core::ops::RangeInclusive<u8> = $lo..=$hi;
+        const [<$field:upper _RANGE>]: ::core::ops::RangeInclusive<u8> = $lo..=$hi;
         const [<$field:upper _MASK>]: u32 = ((((1 << $hi) - 1) << 1) + 1) - ((1 << $lo) - 1);
         const [<$field:upper _SHIFT>]: u32 = Self::[<$field:upper _MASK>].trailing_zeros();
         );
-- 
2.51.0



