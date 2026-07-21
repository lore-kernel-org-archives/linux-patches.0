Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1780146D552;
	Tue, 21 Jul 2026 15:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648697; cv=none; b=aRP8KNmVbCH7WqEhKzhl5hASXLNrZqbUWffRhi5DGnGNbvbYk60m6CP2UiCpiZQXSyG1N6pJ1TIsYKfiGYnMyhA3KQrpHI+kLY+QgE/EXIRNYsDRPXM2u61GjwWUTiBgY9HOQKDbwIf5QEEgpzRR4mxXWxAic5hY8YJkqxjKFVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648697; c=relaxed/simple;
	bh=2si6b+C94kai4NcWfwg4QU5mmzs9I8NG+YkDLWSi0uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWdU2wXto4rO/EeBIOQWvz4MZexB5oUiHj6uyODO+WP71HSCP45ZtCYDWtKVRtXIoQUED/8sQu8O0vuOyi8rViDIznnb8lV7mDLni7O9dnU4r1yuIY0Kr93rGcVlXbFi5IO3EouRemxG+MeL6S8YIEoP/bEOoXfcyryAVb2rP3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SkvwJpcS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SkvwJpcS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763061F000E9;
	Tue, 21 Jul 2026 15:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648696;
	bh=Ey+HhhoCEvK2FxEefb68De290WvB3YAgcmCJCtHXcGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SkvwJpcSLW1YEEgyErZJ1BiLPXIOKgQuxd1aFzWsns3M1VEdiGmfTq7fLsbcmN4hS
	 AehTCTMvRRMIZ0jRrjD23YfFiAp8463OHEpczcrNMDmZb6yZVbgmPtKOV/6YYNzCQ2
	 0sAGOL6/S4QPKwfyaB4HGPy/TQg6kYdBzZi9pO/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joel Fernandes <joelagnelf@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Eliot Courtney <ecourtney@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0297/2077] gpu: nova-core: vbios: stop scanning at BIOS_MAX_SCAN_LEN
Date: Tue, 21 Jul 2026 16:59:30 +0200
Message-ID: <20260721152559.681893286@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eliot Courtney <ecourtney@nvidia.com>

[ Upstream commit fc7c1054b6f983ae2f3e100a24cc87908ae9f4b7 ]

Current code lets `current_offset` go to `BIOS_MAX_SCAN_LEN` which is
one byte too far.

Fixes: 6fda04e7f0cd ("gpu: nova-core: vbios: Add base support for VBIOS construction and iteration")
Reviewed-by: Joel Fernandes <joelagnelf@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Eliot Courtney <ecourtney@nvidia.com>
Link: https://patch.msgid.link/20260525-fix-vbios-v5-1-e5e455251537@nvidia.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/nova-core/vbios.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/nova-core/vbios.rs b/drivers/gpu/nova-core/vbios.rs
index ebda28e596c5f0..871c1163f90a3d 100644
--- a/drivers/gpu/nova-core/vbios.rs
+++ b/drivers/gpu/nova-core/vbios.rs
@@ -189,7 +189,7 @@ impl<'a> Iterator for VbiosIterator<'a> {
             return None;
         }
 
-        if self.current_offset > BIOS_MAX_SCAN_LEN {
+        if self.current_offset >= BIOS_MAX_SCAN_LEN {
             dev_err!(self.dev, "Error: exceeded BIOS scan limit, stopping scan\n");
             return None;
         }
-- 
2.53.0



