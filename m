Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7CF6BB5B;
	Tue, 12 Aug 2025 18:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024868; cv=none; b=BCb5cwrxcvdgGB3R+s3aEZnom0FaNcNg04iLTl/TlxTjMN8v8lHKLudY7JaFy6P1ShWKcIljgfr3Hg5M4FzMhHFOApzGSwxiXN7gfaJfqT3kKAWMmbIZa57qNo5Hch72qxGxKFzn/g3OARpu3PU8dQwd85hMpaGsKCSwRkAvnLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024868; c=relaxed/simple;
	bh=8ByT26Rk5bUm/WvQJXSc436AYhkqCIJiijpWkknlH0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GnXFZQ2QZMkwkXpYDp8Q8VOKSNed9ipAdJFMuAb2f1XnDZ22BTDu3L6r/ClbQ4M9H4MenaoF0T6TwkqTWfx5L0Ph4HtqbwJY4qJgNPIB3oWorgHJOEb5AL/X4fn9KJt13QBoTLOJL8w5BRZT48IJ/dqZn+SCkNNlH0W216PkQO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V7Ru6Y+6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V7Ru6Y+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3118C4CEF0;
	Tue, 12 Aug 2025 18:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024868;
	bh=8ByT26Rk5bUm/WvQJXSc436AYhkqCIJiijpWkknlH0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V7Ru6Y+6gedfNA4kZ6bOiKP2DjNc93Sptp5diEGtPY3s/0jP4NOC3il5zkP992EWP
	 sYI+yD3/r7+/jbhcvlg83Cz1fOvfnS/T9gu6U+t78xI75zvIOxtg+klbtztzPsyswP
	 DRA99MfEWz+Beg6ikBEeoa7+YXzssxFmYy6EKfSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 501/627] padata: Remove comment for reorder_work
Date: Tue, 12 Aug 2025 19:33:16 +0200
Message-ID: <20250812173447.344306341@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 82a0302e7167d0b7c6cde56613db3748f8dd806d ]

Remove comment for reorder_work which no longer exists.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: 71203f68c774 ("padata: Fix pd UAF once and for all")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/padata.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index b486c7359de2..765f2778e264 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -90,7 +90,6 @@ struct padata_cpumask {
  * @processed: Number of already processed objects.
  * @cpu: Next CPU to be processed.
  * @cpumask: The cpumasks in use for parallel and serial workers.
- * @reorder_work: work struct for reordering.
  */
 struct parallel_data {
 	struct padata_shell		*ps;
-- 
2.39.5



