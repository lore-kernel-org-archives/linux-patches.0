Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055720;
	b=uAaqkwWc1sypmwYZkvvDmvbfoU1A8SCjih9PvV+yUWcd4yqP0ckxz+/7+UiGwJ9N2Y7p
	 XOirKlDB9KQCOYNsUVH6Qrwr2Rh+dlfNO6D2B9O3M4hHFtmvMHZyegWINqow4AyuLPdom
	 GLPIMsMNFmIzWDlscEKKnMoSsWw3/Bt2vXdFdknKY2iamtoNC5wu3fvHnJgPetkS05fje
	 5RKEe/vw/e9xx/Y91k2LJTqCDh8Oov9tJSSFGochxXRzqwvWF86crTeV718dUwUSHHWAU
	 O8rAttShKEI5/m46mks3+aOVkbKDrbvU7OLDNmb+uokvoFM6WjOPYwVeYjikuy8w5dQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055720;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AoCnPrNhPJFKpHOTFxFPTTUYhLrzKYOaYWc6PTgEdtI=;
	b=ZSoVCGtYOS6k16SioxtCr5ooQCia3SJRs2DOsaH5g2O2ScgYmhmLtRwDaJoBFe7oCxmY
	 zeaxgWGE5n4VqeFCPVihJuavgjvfEko5r25UHQwVshZ3QWLAthQNc3siqbAens+VCdT0N
	 f0hucaQi5V4ntR1NvCAId6j3Xc+Mh/sid1v4YHhNuaeBaGBVTAKyj5JDAO3PfStEDDN/I
	 vYgwnRVXPefM6DpxjP7R1Lpw8JLvuodgFUoVX7y8awhySp+kCsVwhRjYLeCLKBxgA/H0W
	 p2WOCd8Pi6q70nVzFgs1SS5qLHsNhWiAcayoG8kLP8wg/m36LCGEQJsaIWR/LOCnBag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a9SdwTiC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50183606A320;
	Thu, 19 Nov 2026 02:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a9SdwTiC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1BDC1F000C4;
	Thu, 19 Nov 2026 02:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055720;
	bh=AoCnPrNhPJFKpHOTFxFPTTUYhLrzKYOaYWc6PTgEdtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a9SdwTiC8dgKM4P+Y/j9dhM1qZbIpW51sN7FvjMhLmgfG0vCJFJ7kJql6oPtOWGsa
	 JeFo3erCh7JygoPQaV+/gCSDAJhyIEnDaKDnOe2y429fDaoJ9DTb0ZBNwAR+Q6ihF+
	 V/EC5lbUIHkrHF7sIdObjbQQZpRsYDzynlylGkus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Stancek <jstancek@redhat.com>,
	Nicolas Schier <nsc@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1725/2214] .gitignore: drop Module.markers
Date: Wed, 18 Nov 2026 15:56:41 +0100
Message-ID: <20261118150120.718206310@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Stancek <jstancek@redhat.com>

[ Upstream commit a7d32fa14bc74d1786a2f0513b6f0815bd4be311 ]

commit fc5377668c3d ("tracing: Remove markers") deleted the marker code
and the modpost output. Follow-up commit 8723eaeff59a ("Kbuild: clean up
marker") removed it from clean and mrproper targets. Both are from 2009,
so the file is hopefully no longer in anyone's tree, drop it from
.gitignore as well.

Fixes: 8723eaeff59a ("Kbuild: clean up marker")
Signed-off-by: Jan Stancek <jstancek@redhat.com>
Reviewed-by: Nicolas Schier <nsc@kernel.org>
Link: https://patch.msgid.link/8cbe913b9f80dc6fea73a9e3d51429db2b38905f.1790838401.git.jstancek@redhat.com
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .gitignore | 1 -
 1 file changed, 1 deletion(-)

diff --git a/.gitignore b/.gitignore
index 0e5f33db0216a..fe486e8f6376c 100644
--- a/.gitignore
+++ b/.gitignore
@@ -62,7 +62,6 @@ modules.order
 /vmlinux-gdb.py
 /vmlinuz
 /System.map
-/Module.markers
 /modules.builtin
 /modules.builtin.modinfo
 /modules.nsdeps
-- 
2.53.0



