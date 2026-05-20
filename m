Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB96363C6F;
	Wed, 20 May 2026 16:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295378; cv=none; b=imW3fm5VcRkguLHwQ2MEAFtZa7/tz7MCANC9i0jTjzxrd5lk0r5u8tzwWirm8AW80udv/dK0EJHsTgdWUWVVsqPeQqB16vyOLqsby7O1hR6PJ7I/J5M4IjiAm30n8r+cCF7cNa4sIKpK73y1lwPLUGgloUBgGW1MB9R12PWNVkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295378; c=relaxed/simple;
	bh=GoWZf30J7luQ8nNQ3msENtJE9sEfC6Bv27Vf5B74fBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZeAMtJS+GvLv9cTF0E0XftMFVzeBtY1qQ1tDjXEk6E7Z4AJypODwTW24lz4RZfEhtfoYnExIIOT5lLp1fJTwD8C8iM+sDpUp2BTCM9a94nP8PIlNlaJd73iA8+WaLXDLk107uBghQZzs3GE2I9aqSmghVsGLHtXwxyqu0p0oO8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lw5JoBu8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lw5JoBu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1BA61F000E9;
	Wed, 20 May 2026 16:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295377;
	bh=R0+JjRZrhOzzmDobxqrpn/Wlm4+WJRaXsleKNPx1b/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lw5JoBu8n+QoLd3JcW5hgqhk0/0aQ4nPlqJ964H6Jl+TGcPGTfF+AUm68eAsVkjVg
	 vxjjDYyM91OMM1pU5CzRaTO++ecN19IUjZb5jdS8TwKjExWJwposGZhtVbhUDmEZpS
	 qzh6OoBj47Uhz2KjB1XoksjkmdgNJxsJo6ip+UkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eliot Courtney <ecourtney@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0397/1146] gpu: nova-core: bitfield: fix broken Default implementation
Date: Wed, 20 May 2026 18:10:47 +0200
Message-ID: <20260520162157.183912965@linuxfoundation.org>
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

From: Eliot Courtney <ecourtney@nvidia.com>

[ Upstream commit de0aca13509bf47a2d49bc7a26d56079c758c95f ]

The current implementation does not actually set the default values for
the fields in the bitfield.

Fixes: 3fa145bef533 ("gpu: nova-core: register: generate correct `Default` implementation")
Signed-off-by: Eliot Courtney <ecourtney@nvidia.com>
Link: https://patch.msgid.link/20260401-fix-bitfield-v2-1-2fa68c98114a@nvidia.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/nova-core/bitfield.rs | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/nova-core/bitfield.rs b/drivers/gpu/nova-core/bitfield.rs
index 16e143658c511..02efdcf78d894 100644
--- a/drivers/gpu/nova-core/bitfield.rs
+++ b/drivers/gpu/nova-core/bitfield.rs
@@ -314,12 +314,11 @@ macro_rules! bitfield {
         /// Returns a value for the bitfield where all fields are set to their default value.
         impl ::core::default::Default for $name {
             fn default() -> Self {
-                #[allow(unused_mut)]
-                let mut value = Self(Default::default());
+                let value = Self(Default::default());
 
                 ::kernel::macros::paste!(
                 $(
-                value.[<set_ $field>](Default::default());
+                let value = value.[<set_ $field>](Default::default());
                 )*
                 );
 
-- 
2.53.0



