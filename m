Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031093;
	b=kj1Yim6CIk8ysX5uPvQN+4uHF9yV0NrTW9jilkjK6TfmPiEJla55DMhupnRdollvD6W1
	 ClV+jZqFmfRO8Qe3lrSdMXde6jkj0lwdkm6fB309MpjM8ABFX4LjOKGbOMXOkJY4/XfER
	 y+GDKRdh6KJ4pAd6+750IFLGliBzrKgUFjR+3lMDgNHdt9sIEz6fYO4uKuzROvlskB5mS
	 33Fmi1c90t7yPLUxU7bZsYHjL1+QDwfSzNOJUKaQrrJntHY7aQlySFDdiMlPVJdR21KEA
	 iQCX8MYd2v0yAwNnsFwcQEkqOM7joSHFl31PPXyvIInNsJZ1dBTdG4GTZ1SGvZKT8YQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031093;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DwV3HD6rzOYKPnDCLMBBMxJUoDCTT1iCLF/onpG/KqM=;
	b=YLbH8+Dfe9DauPIU1Sq30eJWZribdLQoS+d3GahmtuKy+kGkRITyjSBEkhLpyu2WI5f1
	 UsqDW4iV7aTnQ5qWECDhj30+PhTaLRIG6VSgIsfTXu0wC+JUndj7qihrSr4klB706mRgw
	 A5S8a/ahtWQKCuZIDFnuWRJVrNmGTJLrxyZO5SxmYIsw0D6pg6bsOosJbD0jTpEF8LOAN
	 shxws4OpD6bU/6RQAbYv8Gm5rynBdC3qbI/C1L5gVOVwc9DY8tGnWVrBLjSuYq9oytLQn
	 T6bmitEBk6vnDnqS03Phs2PffiqdothWfYpxm+YaLqL/AMNp4C+DjyLhzGN5G5IzEvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zUxLByf5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78D6606A325;
	Wed, 18 Nov 2026 19:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zUxLByf5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24FB71F000C4;
	Wed, 18 Nov 2026 19:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031093;
	bh=DwV3HD6rzOYKPnDCLMBBMxJUoDCTT1iCLF/onpG/KqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zUxLByf5pAHXBPf/pMANarrKkMqurekvYAR2FkQEfe0RoTWqq8MBhv4NPhWNGE/Yx
	 1AjjcvfwpQVqk5BgVOwNte4svMiPa3XE5n1NafDkR5ZWNsbEo/wRyPdOy2e5RCOR+Y
	 fXRplI4kNXVwHYxZK6OtBSgnLB79nLl/1yWw8zK0=
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
Subject: [PATCH 6.12 0937/1756] checkpatch: skip CamelCase cache for --no-tree without root
Date: Wed, 18 Nov 2026 15:51:04 +0100
Message-ID: <20261118150047.293547315@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 726576e8fdd65..089426e3cfb56 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1174,6 +1174,8 @@ sub seed_camelcase_includes {
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



