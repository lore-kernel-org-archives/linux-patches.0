Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021597;
	b=3kAcqtUA7jmPbrLTSszkRSAT/07fOWPSFVbXVxlau4tLWXxCRWNoTj64bGI+CkujFAek
	 QpCv4zcmCz8AUd3j3McxT/tlCU6OkJ4sa/hdUcqyhvX9hzE1jpu/9tDolnNGxYLkghniL
	 VVDYNMl/od08GNWTEr/q0A2cvjy9fjrxm3P35Sqgo27PqAH9A5jKXFdleoq52oRdplg7W
	 ux0zUuTZ32fvJ3LbZalSNAExecOafxg5SasMz525bKHAndgGhVwim1EQp/4uW/dx/7l19
	 Oe+kbBvI8KC/Bj8pPj1sISHZYDEtaQ6/XjqnabYLJgJowSbuRgXPbVy8lNI7FtB3upQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021597;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=DFKIBNTeNtUyl/PXNfPIHcvWE3T28q/chYUv9RRmO5M=;
	b=Mejq9NP1rYwo1voUnx60PGulkxOjaRCHp0ISpc+/GH5xMigudEl/UbuARorkOY/2zwfp
	 +PLHb+ofN4dxu4Rc52/FHPJFezqiCja+WsN9QHYWw7WEsQJ3NLlGDP8Iz2oLikdFZplAF
	 DCRJCRzDGof/YyYZES09KSzXhCtk98Flz9NQRYsLByxRkzQ37XVZDVMKfJBzdHFHWaiMZ
	 CgGGQ5QrGEkxZ9vsS4WPLQscGYd1Rua6vhIdD3eCQIjXB574X/tqur22VtO+F4QtfOCto
	 5KeUCBsmwh7IidVpWvJ1s9dgdzq4x6uUbTGYkrOVYg3TSiEYPFZiwXyVakF7ZBTrP+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jX6zlYte;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E62B60A263A;
	Wed, 18 Nov 2026 17:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jX6zlYte
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6DC81F000CB;
	Wed, 18 Nov 2026 17:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021597;
	bh=DFKIBNTeNtUyl/PXNfPIHcvWE3T28q/chYUv9RRmO5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jX6zlYteRnaFRL3Id8AdGcb/WsKls2ZMXpgbCmoI+oL7mUgbo++/aDxk1gRbyw73v
	 vytuVmrPGvSgDpW3O75UB41cnpROARbkW/hWZXAAHftUtGbeo4CkSqVt+pm0LHGoMM
	 f1VqLh61XC2VVmkIOrCWdVN7Hl50uSuh+LZV5+hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgios Androutsopoulos <georgeandrout13@gmail.com>,
	=?UTF-8?q?Nicol=C3=A1s=20Antinori?= <nico.antinori.7@gmail.com>,
	Igor Korotin <igor.korotin@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2323/2651] rust: i2c: remove TryFrom<&Device> implementation for &I2cClient
Date: Wed, 18 Nov 2026 15:59:23 +0100
Message-ID: <20261118150408.795021817@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolás Antinori <nico.antinori.7@gmail.com>

[ Upstream commit e7755b5f29ccbfd1222dd52dc2d6eebf39d02289 ]

Remove the `TryFrom<&device::Device<Ctx>>` implementation for
`&I2cClient<Ctx>` since it has had no users since its introduction.

Fixes: 57c5bd9aee94 ("rust: i2c: add basic I2C device and driver abstractions")
Reported-by: Georgios Androutsopoulos <georgeandrout13@gmail.com>
Closes: https://github.com/Rust-for-Linux/linux/issues/1264
Signed-off-by: Nicolás Antinori <nico.antinori.7@gmail.com>
Signed-off-by: Igor Korotin <igor.korotin@linux.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/i2c.rs | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/rust/kernel/i2c.rs b/rust/kernel/i2c.rs
index 0487bae811fba..b4ff25c830fc0 100644
--- a/rust/kernel/i2c.rs
+++ b/rust/kernel/i2c.rs
@@ -5,7 +5,6 @@
 // I2C Driver abstractions.
 use crate::{
     acpi,
-    container_of,
     device,
     device_id::{
         RawDeviceId,
@@ -517,26 +516,6 @@ fn as_ref(&self) -> &device::Device<Ctx> {
     }
 }
 
-impl<Ctx: device::DeviceContext> TryFrom<&device::Device<Ctx>> for &I2cClient<Ctx> {
-    type Error = kernel::error::Error;
-
-    fn try_from(dev: &device::Device<Ctx>) -> Result<Self, Self::Error> {
-        // SAFETY: By the type invariant of `Device`, `dev.as_raw()` is a valid pointer to a
-        // `struct device`.
-        if unsafe { bindings::i2c_verify_client(dev.as_raw()).is_null() } {
-            return Err(EINVAL);
-        }
-
-        // SAFETY: We've just verified that the type of `dev` equals to
-        // `bindings::i2c_client_type`, hence `dev` must be embedded in a valid
-        // `struct i2c_client` as guaranteed by the corresponding C code.
-        let idev = unsafe { container_of!(dev.as_raw(), bindings::i2c_client, dev) };
-
-        // SAFETY: `idev` is a valid pointer to a `struct i2c_client`.
-        Ok(unsafe { &*idev.cast() })
-    }
-}
-
 // SAFETY: A `I2cClient` is always reference-counted and can be released from any thread.
 unsafe impl Send for I2cClient {}
 
-- 
2.53.0



