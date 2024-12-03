Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542B71F8EEE;
	Tue,  3 Dec 2024 15:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240742; cv=none; b=LjWVrCioQ+tSh4KvuXtHZfwGk9TyZ7TUFsmd/g0YpLx0+eth36Cbby6mSZDYThk9oA/O1vx5SiZuaGbLyXB1IPMLuJByjFJioiv5zxtw6n1XmI5UHXcaOgYrwgcO1LlLmC2o63nAnDwnwKeaHkG6PofHUa/wLvuHyIppLNC5MdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240742; c=relaxed/simple;
	bh=ZrrFoKDBJ5VTYdgbs//uHIqfsrqxJpPwzKOsvzxJ69U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fBY3u4Uk2wMYvxAcPcnb3L+qIjVvBvP6t6/Gkrv43q9zb89ciaRvwdPtr8W0HSw9fkpeLEMQ9rUEAdiSJH5BJ5vkQq8F4lfNunoGr9UiXnM9lSLX7vepGqbHHIdfRK5FrrgoTRUyzSgCCF4s2iZxaYZ8omQqI7sNRuB/gvw/0pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XisHcUkp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XisHcUkp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7470C4CECF;
	Tue,  3 Dec 2024 15:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240742;
	bh=ZrrFoKDBJ5VTYdgbs//uHIqfsrqxJpPwzKOsvzxJ69U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XisHcUkpx2p3cWm48m6AVfUMn3nzp9ArwSkL8WdsGGNEF11FJjogjxqwJC3KW53YA
	 Z2ThZ459uZ3PCfcY/vveqIxJ/g0OmiJiaOmRGn4JxJfqR0F4OrKQiRZDtqkGljBNYO
	 O7zrRTpUXAVYQnpEr348ZmBJVS3t7ZVg9NycHYu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 222/826] dlm: fix swapped args sb_flags vs sb_status
Date: Tue,  3 Dec 2024 15:39:09 +0100
Message-ID: <20241203144752.400106144@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 6d59f2fbfb18965f76ebcff40ab38da717cde798 ]

The arguments got swapped by commit 986ae3c2a8df ("dlm: fix race between
final callback and remove") fixing this now.

Fixes: 986ae3c2a8df ("dlm: fix race between final callback and remove")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/ast.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dlm/ast.c b/fs/dlm/ast.c
index 742b30b61c196..0fe8d80ce5e8d 100644
--- a/fs/dlm/ast.c
+++ b/fs/dlm/ast.c
@@ -30,7 +30,7 @@ static void dlm_run_callback(uint32_t ls_id, uint32_t lkb_id, int8_t mode,
 		trace_dlm_bast(ls_id, lkb_id, mode, res_name, res_length);
 		bastfn(astparam, mode);
 	} else if (flags & DLM_CB_CAST) {
-		trace_dlm_ast(ls_id, lkb_id, sb_status, sb_flags, res_name,
+		trace_dlm_ast(ls_id, lkb_id, sb_flags, sb_status, res_name,
 			      res_length);
 		lksb->sb_status = sb_status;
 		lksb->sb_flags = sb_flags;
-- 
2.43.0



