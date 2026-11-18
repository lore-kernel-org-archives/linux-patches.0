Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049255;
	b=ZQeyBabzswdO4StZ+Wr2fH9m8v1AZkyHhJgKsQBcgdexwOdzanS0/7kDtxW4LXYAtOtS
	 p1VJfSNz7mCmGWKIDOwWHhMARqfMYsjrOcjqnQ+ZpqSqvjGCR3EGMczue6rOjItvcRXGv
	 8nSOfy1LrUz9gIkkQ+GpMugVrGDCBeDe580vi806568J2sg72yNKscQULF/5rJz0cDTL1
	 eiyx3aFhmNH2OHngZZlct0GTvy8iFvFRJd43zlNHl4MvuMj61ms8TcjedRkHEBbNS4iLV
	 /dzL0cKoRYb07uOmT70uGL2bSDlQfJgXuCVtTFz+l2haWdCpM0abxkD8YWAmdUUT/DA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049255;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NQmi3W9BvyzBtodcOcw20f3JBmGs/yABEVdY6+0IaFg=;
	b=0YKJTb4aRzX8fBdRg1sDC0/TBeEpwwIjxVdH4f+L+ShwCxCqRVtW/JPV/goZojk0rv1d
	 pPopufXERHpAifzKMZcGqM1vRjg4GX81mCVwOAUZfCYBgn8uYo+dkmSNJc2JEbJzX5wUD
	 U706zAEGSGZmCLbx7ldWx80k/OsiHjzxnbhG5oWC1J+/7bbtRgafyOpLca52kyDaveWD0
	 oi9rVfl0CxMGz7KXwqtuyOuc5oVvyzTSG4g4bpV9Pe5P7dWJ0ypHAyLV6rooYCtZm9Gdy
	 NOjZHI0bO4Tr+MMXGyFv7iyqLt2kVgHpCr0zGalPcqI+4b1fmzBH6Y70Cg1n6doHuig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HkB+g+b7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473D6606A31C;
	Thu, 19 Nov 2026 00:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HkB+g+b7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C7E1F000C4;
	Thu, 19 Nov 2026 00:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049255;
	bh=NQmi3W9BvyzBtodcOcw20f3JBmGs/yABEVdY6+0IaFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HkB+g+b7QLTVp1rzJkmPMKWyaLqksh580QCT3Nfxta+Hz2sDHkVznG8eJz7UYoA8p
	 3yEHBKsUXCAuoB7OkzlgTpkWwEc/C/YXsRsCneYTA8eXOIjSeQKFMRiVkuoYAICGZ5
	 /YxMt4kD5DhxpGQNJAtdr2owdKjiMYFdCZTsUyJE=
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
Subject: [PATCH 6.1 2287/2857] checkpatch: skip CamelCase cache for --no-tree without root
Date: Wed, 18 Nov 2026 15:55:21 +0100
Message-ID: <20261118150323.819192095@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 418e2a31bdc6a..2cc6a905683d6 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1139,6 +1139,8 @@ sub seed_camelcase_includes {
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



