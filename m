Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778194B44AE;
	Thu, 17 Sep 2026 17:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666525; cv=none; b=pK6Vrlvmg7W3wmAGRIXWAR4lz9GrLFjlIMd/HBdtou0poig4WY8ObJ2QjI1FhEXRvpa7E1iHxBQzdA1izfZ0TcGdl/f/MPusquOPf9gxk+9/+ypBYwkewAG5KdYJ1byOQ0PiBammnldPy3nkH+xG7nBo/dSpV1n3kvXyVZ82eVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666525; c=relaxed/simple;
	bh=VfJX1/amYjE74GUYcwNKD+tWB06LANw3LqDNXrkFbi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWw9RXHII6hwxggYosWXstX49xjXd2CpYEW6aBSUZUjd2k2giTdhqWh+YS0M+LOoyb66zH/GjA9En6pw/+VSPZR/K2RSQdPBRkxNta/P01b6gepLkLrSHn1uANcIk8zv8F+MEhw1eRDGf8ScR1BY5lt7YbUzK5YMLdSi1C7C8K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XSCisadK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XSCisadK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C131F000FF;
	Thu, 17 Sep 2026 17:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666524;
	bh=ZJcGcbrrasme79jDj0KMYfJTwqZ9y3CgbYtFfZAMsWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XSCisadK8eV21YegE3Krn9kxfVHL72QEh1AuQ3gkwNo2v+iL5dGxXS/0epsRZUKTd
	 2zsQZbn8HRnQp3HuGoTkPE8zWFZVAHJ3vssdK2uBOhV1M329WQWWtFFIhsRJFZq4Uq
	 IET3/A7ZnvZRs8Mx/n5z7XRVsV3NUKj9oiWyAhow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <n.schier@fritz.com>,
	Nicolas Schier <nsc@kernel.org>
Subject: [PATCH 6.18 1027/1250] scripts/sorttable: Mark long_size as __maybe_unused
Date: Thu, 17 Sep 2026 16:13:42 +0100
Message-ID: <20260917151619.898809089@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 4f73462856576797b8f3c55564a9be99f76dc67b upstream.

When building in a kernel tree prior to commit b055f4c431e3 ("sorttable:
Move ELF parsing into scripts/elf-parse.[ch]") with clang-23 or newer,
which implements a new warning under -Wunused-but-set-variable for
static global variable, there is a warning from sorttable because
long_size is unused when MCOUNT_SORT_ENABLED is not set:

  scripts/sorttable.c:452:12: error: variable 'long_size' set but not used [-Werror,-Wunused-but-set-global]
    452 | static int long_size;
        |            ^

Mark long_size as __maybe_unused to avoid inserting more ugly #ifdef
directives while insuring the warning does not reappear, as the
aforementioned change does not alter the uses of long_size, so it
appears to be coincidence that the warning disappears after this
refactoring.

Cc: stable@vger.kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nicolas Schier <n.schier@fritz.com>
Link: https://patch.msgid.link/20260831-sorttable-long_size-unused-but-set-global-v1-1-8a96b88697e5@kernel.org
Signed-off-by: Nicolas Schier <nsc@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/sorttable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/sorttable.c
+++ b/scripts/sorttable.c
@@ -449,7 +449,7 @@ static inline void *get_index(void *star
 }
 
 static int extable_ent_size;
-static int long_size;
+static int long_size __maybe_unused;
 
 #define ERRSTR_MAXSZ	256
 


