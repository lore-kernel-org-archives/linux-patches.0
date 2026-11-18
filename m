Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025713;
	b=IZwf5SF/jy/XGexWyglipGOO2n3TyNnNpOJ6mjUt048KJtdUrkAMnX4TMnwR22TYubDp
	 1jghEn6mBlL8jS+GaHvQCPwU+RwyztrKzgionldZIfwLgbEiSsNxYn6y3aQgfQczQNNbd
	 c7dtUZCkdoRX4lm8Bzqr6V8spYIQBMsZN7CUUDwuNd/RNHoSnVel64r1qKtIKL/o83I7J
	 ZtBCxvi5oD1N/RTtovH8y1AodVLQB6g2HgstiuEC+iHXBx6l/Qot9CLAX16j8D4DbOqCv
	 90tE9d3t1busATd/0piNos7hbZw2kwasuQ+8yzNHzuEmDG+6GZYqAZAI++pFB5SPh0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025713;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ziN96YcRrkJBgBN0wBfgV+/V0bGnfFrnrV9wpL4KSuM=;
	b=LOLmv+IxsKFMHidu+KqpGtZiHQ1LXaATR0EzBdDGDqlF2xhj2EW2rVJMxxJ41RSUNFgT
	 V1xC2T1AIC8qsDbZB3fVgN+eOlbNd181bEvQpJCya7kd0BU7vowAGqJfdwF6v1kLiZ4fm
	 97j4HoswYAVF5/hNJv2omktBVrPPoov2LRwgHu/tuD/+tJ/qmoSSOdUYgONJWPnPINzIj
	 alKsLXywTifkQZ1YGySrITC3useSRMYv94yTUUG3j0cEoLkDOJCRuJ7VVKvXinUdIBggv
	 FuUSWnKSLiBTMjksii67TSdVffguthqk4vhUO8BjDxoxTJw9MKWFn8EAS5vPVT0Q2KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MYVPN5Jj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DB0606A32C;
	Wed, 18 Nov 2026 18:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MYVPN5Jj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3601F000C4;
	Wed, 18 Nov 2026 18:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025712;
	bh=ziN96YcRrkJBgBN0wBfgV+/V0bGnfFrnrV9wpL4KSuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MYVPN5JjS3HuDmaC5QFQiMedTbLR8JjaWMGCqddtAxzKKBYGUh8qaXLjuNqgsNgY/
	 Vl4hijz1BTIOzCfNA4WT9RLe7qcUnEn3/1nvLfquDyxILtdtQwkTdU6c10fWkBD5c6
	 luwszMy17ItQ4T7IOrWbcWIMJuG01e5P/g1C1RLY=
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
Subject: [PATCH 6.18 1176/2151] checkpatch: skip CamelCase cache for --no-tree without root
Date: Wed, 18 Nov 2026 15:48:31 +0100
Message-ID: <20261118150204.968458969@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9979bf9f87bcc..e1b4de58359b7 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1186,6 +1186,8 @@ sub seed_camelcase_includes {
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



