Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061156;
	b=W92DAVro7yGj8gAujETdgv3NW4dWS+TGosOt84auBSd/sC8fPVEwtkCsBDC1/AV1Ru6s
	 A+khpEzzZclCE/qPuu4fycXEzCSI/VszoEise5sGleViIdquCV5IX+JVVPCq0tkMMO336
	 evVoB4zbFRGueqshWPNi82f8vnfk0RWe0lGUypIpG3EVtZLt6TrsHvCPpRZjl0ccADpSx
	 0JALZRwzPJONct4ppnJysgTEE8IqO0gh1pP1iKKfg6RuSBYImj8LkWTRkQQGxAJcScvJv
	 Ol5TZYZ8eA4ZnjCvs6V5+ZaMpzGSRdfR9iJINNQRbVmRle5ATS9MxLIotZPSpyT1+9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061156;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rpmJ1IzEfOm6R5/iX8a2adnjpf3k1DXgl1IHt8arHQI=;
	b=ctjHwYil7i1CvyeLUR1Rba2lVDTkOTh0e4I0FZlfb7hJRSrQOPf0MtnBP+O22BeLHI9u
	 9pr1Xnc6ONjFNMNx2vMioQ2hEQGArSng0sKKgVPUPrENrgT0FYDkuKJdjRBiARNe2M6AR
	 OEUwjmsXiM6ISvNNViumaHM3d4nRhHXLIBHkuLUciEBzD3C4b4ihSIfdh9gP22sOJhpz7
	 umbxwFN9M8Z6iU7sBOkMUU8Nbt0uFsdSuXw2/FHhRGPthOuDY8dMqVDse3pji6RbX9UOE
	 etCapxQz2jqvz6kqyK1b2Wa4fCteT6lya0VMK6NQhMalLpY4uThh2Ksk1TL2XLJdh3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gPOX9fT8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918E7606A325;
	Thu, 19 Nov 2026 04:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gPOX9fT8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78131F000C4;
	Thu, 19 Nov 2026 04:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061156;
	bh=rpmJ1IzEfOm6R5/iX8a2adnjpf3k1DXgl1IHt8arHQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gPOX9fT8tUFfsNiXegoxcKNRGZGJWsyRSrarANTcddqHgAgmR6wUKydUa4GW8cGeA
	 T+O8LfjVWNPTsVJ//BtzXhcOBaDtuukAm6yDcIFLwz5PVrlsvuT15ApsNiTfpD/Y1z
	 l4G9E60WwuYJDWqg7QW/QlXeOnYpJQxK4nZWSaJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1451/1848] .gitignore: ignore only top-level modules.builtin
Date: Wed, 18 Nov 2026 15:58:09 +0100
Message-ID: <20261118150020.163599135@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 40cb020305f40bafc2a13c7e879a33dbbd607507 ]

modules.builtin used to be created in every directory.

Since commit 8b41fc4454e3 ("kbuild: create modules.builtin without
Makefile.modbuiltin or tristate.conf"), modules.builtin is created only
in the top directory.

Add the '/' prefix so that it matches to only the modules.builtin located
in the top directory.

It has been more than one year since that change. I hope this will not
flood 'Untracked files' of 'git status'.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: a7d32fa14bc7 (".gitignore: drop Module.markers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .gitignore | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/.gitignore b/.gitignore
index f53e8be649a24..3d95f2b268e55 100644
--- a/.gitignore
+++ b/.gitignore
@@ -46,7 +46,6 @@
 *.xz
 *.zst
 Module.symvers
-modules.builtin
 modules.order
 
 #
@@ -63,6 +62,7 @@ modules.order
 /vmlinuz
 /System.map
 /Module.markers
+/modules.builtin
 /modules.builtin.modinfo
 /modules.nsdeps
 
-- 
2.53.0



