Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2B525228D;
	Thu, 15 Jan 2026 17:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496512; cv=none; b=ChGM/fnYWbwwVc6I5rR1RWb1zCzfqNhygkJc+gwLeJHDIP1jdQMo+ziG0/HEXWga4A90A2QNiS9qip/60Oc87A4kSKtyaFXsUBCG8C+FNjQ7wSMc0RwH2nKZsawrZxqrgrPyrAYnaIaqEzIuH4wFffmTSiD+s4phh420Kb+nzfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496512; c=relaxed/simple;
	bh=yAGJechHoIJmlW4nVGFGsT39Ofp+yv2CNuV+Asl2Fu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q9Ke4UdgV/JWgXtTxHBUi6LdYBAJibt4TA2qCwl0lSx8sawqUfyf5nr39rIx8VSbBQejxOV5amz/xyMsI9aTG7+LTRPvNQcQqbC7bVEFrj7WtbLrBmKv2Ew35l7Ru0ARzB2cOcEjDI5M6XaW2MOosgegcWfe58RCFtJZ5YrGBWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V2ATbDvK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V2ATbDvK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E3C0C19422;
	Thu, 15 Jan 2026 17:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496512;
	bh=yAGJechHoIJmlW4nVGFGsT39Ofp+yv2CNuV+Asl2Fu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V2ATbDvKivM6hCY8hVxSWFMTpuzJVUwe8Y0g+FZs/tuFWABaRY3LE3ARsi9bInUNF
	 ijx1l1fYnqb9wBPvyOuOLzCg+vfaSJrE6tauTBhZiRpMKMhkmqExoJh3CAzYMfe/Uw
	 c2evcv6nDZKzn2yhbqSe5sQATvN0BXajiPXFFlK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 039/119] smb/client: fix NT_STATUS_UNABLE_TO_FREE_VM value
Date: Thu, 15 Jan 2026 17:47:34 +0100
Message-ID: <20260115164153.371274226@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit 9f99caa8950a76f560a90074e3a4b93cfa8b3d84 ]

This was reported by the KUnit tests in the later patches.

See MS-ERREF 2.3.1 STATUS_UNABLE_TO_FREE_VM. Keep it consistent with the
value in the documentation.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/nterr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/nterr.h b/fs/smb/client/nterr.h
index edd4741cab0a1..7ce063a1dc3f6 100644
--- a/fs/smb/client/nterr.h
+++ b/fs/smb/client/nterr.h
@@ -70,7 +70,7 @@ extern const struct nt_err_code_struct nt_errs[];
 #define NT_STATUS_NO_MEMORY 0xC0000000 | 0x0017
 #define NT_STATUS_CONFLICTING_ADDRESSES 0xC0000000 | 0x0018
 #define NT_STATUS_NOT_MAPPED_VIEW 0xC0000000 | 0x0019
-#define NT_STATUS_UNABLE_TO_FREE_VM 0x80000000 | 0x001a
+#define NT_STATUS_UNABLE_TO_FREE_VM 0xC0000000 | 0x001a
 #define NT_STATUS_UNABLE_TO_DELETE_SECTION 0xC0000000 | 0x001b
 #define NT_STATUS_INVALID_SYSTEM_SERVICE 0xC0000000 | 0x001c
 #define NT_STATUS_ILLEGAL_INSTRUCTION 0xC0000000 | 0x001d
-- 
2.51.0



