Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040956;
	b=uXk27osORgQh5uyhgk3SOUYyQ4zbHfUev1MKTlcVVO91M4pFXD2bTXkovsE+fCk6cTOt
	 tizGI7rqUqAlKsHomM+1/0I5i1qIwIEEJneEeNgL/X9KiK+qJhaiRW/TvhsguktLdOjq4
	 E9Y2iXuyWMjJO3MyptoI43v2IaTMOVvGRrdVPeBry/BqRcEt66iiTNAhAKyWsnrozRNbv
	 4YKBCShVuM9ZKhB6z7KM9s1kluqEdhUT3qXTWKQPJsLPLEgOlG1EQDZV/P2zEcYQwZiD0
	 tAbCnJCF5Ajcz3/KtMnXzg+3180I5b+Ulu9cgD7yZx5fU8BRFg9mn+kSKh5+DXnlhmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040956;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+MXmwf5Wfcl6jQRrN7exl58QtqYH1f/6a1a3O2K111Y=;
	b=Wb4TWR1cefaH/qLIRDPzTTSb2rCEHmJnmE9Jd9NhSSDOtjWoil7Kk3iOOVHBYOnBFeMT
	 DPWG2wfvl6jfl90wvuuSiN5MRqt12CXQJNP94GaPp4hyf9uLzQZVny/5RRyNSeQm4G3me
	 DQK6Ec0BdinqW2XJ85nnlUn1xyFpFYTlRVQzZA6HAGdae13KWNbgijusiZb8e+qhN7h6A
	 yFxMttuGbIb1mwqew2z1nigYbkWIbdqIyjGVgLuZPq8UpFYeA/g7vRkufdN/zHWDMz1As
	 Gq/LcrXL4oaZArQG6SCSPocH1/u1He81fCucg/6W22541SAGvsaaIObqMFv9sK3MQeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="n/XNwiZc";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70996606A320;
	Wed, 18 Nov 2026 22:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n/XNwiZc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4151F000C4;
	Wed, 18 Nov 2026 22:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040956;
	bh=+MXmwf5Wfcl6jQRrN7exl58QtqYH1f/6a1a3O2K111Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n/XNwiZcx+VX/LRSrxsv38kWpvL3gxF4URV189vyz6PnVnTLm08SZquwzo1Nv6iye
	 OqBfyldw926Zy0Jb2EIrCjQnfFUzlnOuH90WTaeWR0Mkp0CtlPgLsmc6w8q4uAgl/j
	 pdIppjqw8pukAA8obq+mK9OiexTBwMbuoS9MCcFc=
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
Subject: [PATCH 6.6 2642/3318] checkpatch: skip CamelCase cache for --no-tree without root
Date: Wed, 18 Nov 2026 15:54:24 +0100
Message-ID: <20261118150440.329282421@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a3b2d668af318..9fae855a480d2 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1173,6 +1173,8 @@ sub seed_camelcase_includes {
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



