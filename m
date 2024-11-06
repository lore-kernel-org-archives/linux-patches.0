Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C505C1DF73C;
	Wed,  6 Nov 2024 12:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895181; cv=none; b=HhoXYiboS7AxDyi8EqTOcaadh8Fm+mm9z/K/+OasYIM0NDfcxLkErKiT7Tef6G6K8bchekBJEvARXQLtIMkIQndvABWTJu3HSzWDwA+yXep9wP1JVNITj9gQ2AqQjf8Iy8TiTLiT4jr4Gmlf4l8Q+ZifhJvE5j+73GJZtE2TkoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895181; c=relaxed/simple;
	bh=/Seg63oOUApysdkKzrrcgfU8kCTfS6KtWuD9OaEl840=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nOBtKl3inP94HDkZ79f03zUuyHSyQFHLBOooASLwQEFvqUwfIim/1Jnlgf8tJzNapDRdzxYLMpn66O7yyPBvJPpqb2s/js0NSnvqpXTOuUZyZhPfZmgshbIFWkUseMsrHzMcThhYtCXP6CxfitYp10zjDXuAj6fONP0BpVH7uaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iecJ14Qf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iecJ14Qf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C60CC4CED2;
	Wed,  6 Nov 2024 12:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895181;
	bh=/Seg63oOUApysdkKzrrcgfU8kCTfS6KtWuD9OaEl840=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iecJ14QfGsrdGEPUEJiFXWBhpb5/Igc8MKvSxPtQcTYF0aW8RZt3HgsSaB4c8JihN
	 H3nmZ2SjJ0XBFcYEibKMi4tawPsuSQnJQzR4+hRX1yHCE+bddFQea3pq86gD0SvRpa
	 JEkbTSF5tKSQrdgKDySYs9SQ2hhfBDAPglypUG9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonggil Song <yonggil.song@samsung.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 095/350] f2fs: fix typo
Date: Wed,  6 Nov 2024 13:00:23 +0100
Message-ID: <20241106120323.247316400@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonggil Song <yonggil.song@samsung.com>

[ Upstream commit d382e36970ecf8242921400db2afde15fb6ed49e ]

Fix typo in f2fs.h
Detected by Jaeyoon Choi

Signed-off-by: Yonggil Song <yonggil.song@samsung.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: aaf8c0b9ae04 ("f2fs: reduce expensive checkpoint trigger frequency")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index aacd8e11758ca..8126a82b4d26f 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -213,7 +213,7 @@ enum {
 	ORPHAN_INO,		/* for orphan ino list */
 	APPEND_INO,		/* for append ino list */
 	UPDATE_INO,		/* for update ino list */
-	TRANS_DIR_INO,		/* for trasactions dir ino list */
+	TRANS_DIR_INO,		/* for transactions dir ino list */
 	FLUSH_INO,		/* for multiple device flushing */
 	MAX_INO_ENTRY,		/* max. list */
 };
-- 
2.43.0



