Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B852D879E;
	Wed, 20 May 2026 17:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298269; cv=none; b=d4LMDGh0yivTz2FM87zq4+/BvDcuvs2kust5qVkQzIyFi1lW9KU1FydtTc5fNavktKO4QEaPDSseYYfVhRxbe6Z+xUTEwRRm9pUvwjk6RTq9vGvtKS3hh9DeAvX5xQ1wYEaswWsVSnb/vOiJ7Cc0HMfpI/g4VDPSxNB4azJeduM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298269; c=relaxed/simple;
	bh=mmCRvKE1ddt1q0ki4FffoNjKO+3iBqBxujo59ulGyMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nkwqs0pT5tAwMV98r2FIKNsYjV6Gk5lC+UJwvJXozpdn8PIuthtm+EKLhrX4024d4EnE69nnCf86nbIOes2yHHH0I38cMsfnX46+LlE+CZFj3GzBrXGDqaAAvkxd2tNy4DAUEx0LIdYDvDTFKI7/tRPWaot2EFX2QSUf5H8slv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qnkOQ7NH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qnkOQ7NH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4DC1F000E9;
	Wed, 20 May 2026 17:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298267;
	bh=nFYHvrQOc2dhIgkrp5We8TG7dq3YK39spesc98m4aoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qnkOQ7NHxy0o3cQdGun9WXuzow/sKTvTE6oalzZZm60IABgiyXTlSjv1HmP2SnKju
	 s83GKAmSKf1Ko1b594sMi+qQy0+cCRZnPL2dpc0Hs48lBgvri0T6dPyxkDOpcgx12s
	 9PYXCTWl8T7SeywFXKrBRfOyU7AI7YevQ8jDexQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eliot Courtney <ecourtney@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 309/957] gpu: nova-core: bitfield: fix broken Default implementation
Date: Wed, 20 May 2026 18:13:12 +0200
Message-ID: <20260520162141.233400478@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index fb60800898c55..1d4931c251bf4 100644
--- a/drivers/gpu/nova-core/bitfield.rs
+++ b/drivers/gpu/nova-core/bitfield.rs
@@ -303,12 +303,11 @@ macro_rules! bitfield {
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



