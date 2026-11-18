Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019009;
	b=jBv3HAnUhlxTNcrFTgsOoxTfdNVaeUEXBEecrDIxFpqxW28l3zmoYx42K/Kd9OxYO3qv
	 AFXGu9utKhTtbA0LbUTS93va0hYsCipgQIC1KP3FR/74WG6YRkzYHYtK+m0Hs2Bnvva01
	 S6yuewZ5PZgW7jMAUS3aw1TIMHHdJDbOd6xlzzCXrggwh7u6Y+17DW66Y/AjzhEN2mb/B
	 5BboDKnxge8hu2OvrrEfyRd6v1I6xOla82hcC/neAad0Pafj08y9fM1wHNeh0+JU2Iv2T
	 lvgz3y3j2N1Sq3Z0aWerxi4BO4yzsfUX/k8Wv/Tv3MC39jXmzsBcTNY/TJ6dpQ9ISKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019009;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i+A6jSXBRJU7lG7/7i32lVWA+wlHaHggxdNHWbPBs6A=;
	b=vx13b/YB/QZ3qWC+OonKvTZM2xJCpK9CdbaGcF0tSb56ldgCy894hs8tp3bdzn0hZ2LN
	 wBD3SvQWjagIKMBcAxF36SwCqfliohhdrT8PcTIg3CmtL3iVnpCj4eZAfTSTurRiZe8RE
	 3bpzEQ6f2ei6nGceF3WrF7DBFmLKLC/h64I1Q1+khvMlXN7jasH2n1HHJ3ZyCAk7+Nf5i
	 KeQ1UWzOMlgWVXKymAPk/2QrOQlqsxDOCTk7Z9XdJ//qrXrlWh+W1mZO1GFlNvg0u38nm
	 O9CgokAIgeVs8JshfpbvnHTJO0jJm2aPdxStzht2LSKIxqe87OFPAtdaIEP75uPV/Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lzd5kAOs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D2460A2609;
	Wed, 18 Nov 2026 16:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lzd5kAOs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 214401F000CA;
	Wed, 18 Nov 2026 16:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019009;
	bh=i+A6jSXBRJU7lG7/7i32lVWA+wlHaHggxdNHWbPBs6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lzd5kAOsnQcxJgxeh3cTanseL5rlu4ZCdYdvaffsxJ+Tl1+YS0LmCZo2R8O+qDmHj
	 cmYeWvuVG+Fze3hJWMnb4JWDWgITmbRNwt3fSIveKY4e/JbNfOa5Xl1DvX/7I2vk2/
	 eOgy2xhyIA6CLN0amFlX6AmnximJw3FJRv6AqR4Y=
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
Subject: [PATCH 7.3 1392/2651] checkpatch: skip CamelCase cache for --no-tree without root
Date: Wed, 18 Nov 2026 15:43:52 +0100
Message-ID: <20261118150338.132237531@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 8a7787d228a63..f424dafce5bce 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1206,6 +1206,8 @@ sub seed_camelcase_includes {
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



