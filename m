Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061448;
	b=5OoAABdJmr4xfVQ3Ydd3xpuzfGtqBKUeFqVLSGL57mnx/NtI2uLPn84QgWzw2NviWjX0
	 ExnK+jvgj0jewiGCo44dQlcjtm1UDylp8Nz/eTRnZ7d3UyiJeSFygyW24RWbNdUz5l/Rd
	 wNisDmUO63HJD7hpAjabzQOJueXPm9yehsR7xC3BO8U2BvsLBjQn/YDaKRO2k3DmoxKyW
	 g7o0Dizzcbv3pSLk5gA+e46CJ90MuvjqorV/WqQ+xu0f264++aMHNVCDzOZmVIZ4OpP8N
	 3am/hJpyxEBM20rbzCSEDjzGWK3R+V2cM4KT+vXJge+Tzpwds024+nxVzEP8FLqhN/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061448;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5a65ChJBy/80/zkM6B3RCNMrbGlJAcN1SBUPfzY9LKU=;
	b=l9rUfwbF5g7saEwcW6V8Q7tIl6uy+w/xOFCmdHbehH7WZeV2NhP0NUsGgEerjGeS3ZaB
	 Cz4XTUeLH5INSvEORDTDFV1kGfoAREV4Qswqtdu+ytxEsm5J6s8odUcow9mPIyCjI1HWh
	 NR+3U6/rud8x0enJ2rRxmXGN8PHDDoI6tTJMo30pvQF7utHRbxy53/LFpDnx6MgXkThMh
	 spE7+k3qHdljDoGUnb9Q+TATI0iULzz4LC/ajHqvfhPQmiqpLAId1+JliGAEOa8/BOIgC
	 gSAGtmjKflZwTzL0oiF/uY3dOJKTmD54Jvfjgdb9fTihOwveH6011DU96esSb6TudIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zf8X0v57;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33A3606A330;
	Thu, 19 Nov 2026 04:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zf8X0v57
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95061F000C4;
	Thu, 19 Nov 2026 04:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061448;
	bh=5a65ChJBy/80/zkM6B3RCNMrbGlJAcN1SBUPfzY9LKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zf8X0v577ST3Lqp410DuXJ4Ya7Lo+XnAnsErquZkhQR/eK+rI+gEFxmrcTUA/nFIl
	 TjEgrI5bIzIIdz572XwtNTt9O3AQACkcOu4v7X9bdhtalR2y1yGD7TeqkAiPm6u93v
	 dRtOCD4pv1kj3gjtIiCWdozjQKid0pBG043sSOAY=
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
Subject: [PATCH 5.10 1515/1848] checkpatch: skip CamelCase cache for --no-tree without root
Date: Wed, 18 Nov 2026 15:59:13 +0100
Message-ID: <20261118150022.713288399@linuxfoundation.org>
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
index 2dd453c3ecd25..b82e992e59c72 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -933,6 +933,8 @@ sub seed_camelcase_includes {
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



