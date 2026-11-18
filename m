Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055857;
	b=zLxTlHfpgC++K363kCVrYpQZeDyt7+Rq7fdJ7mBfh8c6CC51QBpm9sETZrJg95ngJQ6K
	 POEDoPd5NxW4BbEoV480wd+YRFVXtP1GJ2rBNq+3RuHh3OoygB9N7e7QOGBs4gaANnVIH
	 XdbNcUxlBSpTC7DXnEw86gMr5D0x3ct7iHseUB3RFN5iXMETQ6f4fkNXjdk6nlqKREUb/
	 DQwdl2UjGoESW3QOjKuLAdDOsnKV55bYodN6/tzv/mHjmBW86Rialrdh3ZO/PVEsGKb0R
	 WATv433VU0occkAs3VS8SLQ2qunLNZKsANCymx8BoI1CasqeaBCxB5kDHDHScHvrcnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055857;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oVJcPRILNFAA6NDRtKrryp3+djmM0zRJfRhRM9UwOLU=;
	b=VRpMUTNHE0ZfrQUWTjQSpsXELzWizLtYxXO2BqbBw2Ut2dwLMU+ezvoPiVAzJR88fNZj
	 UM9HhnnJPJAcl2eiISCPeXY8778eUFbJArH2tMLcyocYDE74QDPrzfvkLSpqxqLkOZ+8i
	 54Wt2Y3immzJHnfdnt6hjWyKLeoAlxgW8Sr/ekCOawB1YASZBAI07Gc/fCuROb+4g+4dy
	 NdrKjqu0A+ycdw5O5CAy3ew3+mbuMQouoFpLVoXgNRWBkPdCdSu/nktun5o/hcZ2n4UPT
	 HSLwp5tpn1SgO5QGNJa/hgCo02U5cOkkRK9kN8IllPtlYGRULAfPL5MyhgA5Wb2aEbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lNONtnOj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D470606A320;
	Thu, 19 Nov 2026 02:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lNONtnOj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3BC41F000C4;
	Thu, 19 Nov 2026 02:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055857;
	bh=oVJcPRILNFAA6NDRtKrryp3+djmM0zRJfRhRM9UwOLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lNONtnOjguTq4FRQZ49BmgpbzKLgDRkqFkE323wOJ6cB8Zx0qxd3vIcft3tDZH3fZ
	 GqubKJvGv0WAolc2aFotFsTMQmCc6Xi3euf2lXKZdqGkmDrfSEz/rEm8rPTQ/RzMT4
	 a7vdCRoiJ49grXL6o0yJv65qrzlDjsnB4OP5QuL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Vorel <pvorel@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Whitcroft <apw@canonical.com>,
	Dwaipayan Ray <dwaipayanray1@gmail.com>,
	Joe Perches <joe@perches.com>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1782/2214] checkpatch: skip CamelCase cache for --no-tree without root
Date: Wed, 18 Nov 2026 15:57:38 +0100
Message-ID: <20261118150122.771962947@linuxfoundation.org>
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

From: Petr Vorel <pvorel@suse.cz>

[ Upstream commit d41ebc7f9e2cc80cb57139c05e71415a79582ab0 ]

Running outside tree (--no-tree) without git root (--root DIR) is not
doable because we have no include/ directory which could be cached.  But
3445686af721 expected that we are always in Linux tree (w/a git).  But
--no-tree does not require --root.  Therefore skip whole caching in that
case.

This fixes perl and find errors when running checkpatch.pl *with*
--no-tree --strict and *without* --root:

    No structs that should be const will be found - file 'scripts/const_structs.checkpatch': No such file or directory
    Use of uninitialized value $root in concatenation (.) or string at scripts/checkpatch.pl line 1213.
    find: `/include': No such file or directory

Link: https://lore.kernel.org/20260810161159.1044160-1-pvorel@suse.cz
Fixes: 3445686af721 ("checkpatch: ignore existing CamelCase uses from include/...")
Signed-off-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/checkpatch.pl | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 94ce1a48a7856..c8032823008da 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1108,6 +1108,8 @@ sub seed_camelcase_includes {
 		my $git_last_include_commit = `${git_command} log --no-merges --pretty=format:"%h%n" -1 -- include`;
 		chomp $git_last_include_commit;
 		$camelcase_cache = ".checkpatch-camelcase.git.$git_last_include_commit";
+	} elsif (not defined $root) {
+		return;
 	} else {
 		my $last_mod_date = 0;
 		$files = `find $root/include -name "*.h"`;
-- 
2.53.0



