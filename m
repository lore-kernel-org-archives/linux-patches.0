Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A13149C57;
	Mon, 16 Sep 2024 12:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488556; cv=none; b=gl9Sce2pecPKuvECVcZitJ5eMsm5b+PZZvNF7Pnsuo96U+brG/cUVRoSexFrwWacc4PiL6hsBvbly7wjHnw2kG9UHYhKvrB+6CkGHg1Y3UAdV7tjtLqsnsjuh3eFoELtylQXKEYAbtQeFct3991yEX3aFqBCId0WPsEcmoHl3go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488556; c=relaxed/simple;
	bh=aRvMxas/DkbdkhKXgPg6dFiKBQkhmAk/PW1C0UeXsN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sc08hEmLIxjM18cEAu+JEtXwlw8UHTA6OroNvdRJuhQDYghxOxJ/lW42xLBlCxMFk8I5pw4wov5LDM3xw01cUb0XiY3+GUMvBX9xc36OkCzDucK6QughFGk/g2m1bKpv1qIgTLMNdrQYPX6KlAT/ZVWLQGsx+OUvNf9WuxKxVXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A6RLdgcB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A6RLdgcB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2179C4CEC4;
	Mon, 16 Sep 2024 12:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488556;
	bh=aRvMxas/DkbdkhKXgPg6dFiKBQkhmAk/PW1C0UeXsN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A6RLdgcBerM0BQ5qWgQuCiO7GofPRBlq4k7VEG0x1zrSGe08m4VUKna2R7Ke0n6KA
	 2QY70dd0sknD1+E9kWU+gISTwsY+3ejCP5Ale6UzyBhWBTxjanjthm3wTWTnDvPdMM
	 Skzjn6wJzWJGQsMpqJpQM3nU20K96D1FDMll2wj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 33/91] smb/server: fix return value of smb2_open()
Date: Mon, 16 Sep 2024 13:44:09 +0200
Message-ID: <20240916114225.601799203@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit 2186a116538a715b20e15f84fdd3545e5fe0a39b ]

In most error cases, error code is not returned in smb2_open(),
__process_request() will not print error message.

Fix this by returning the correct value at the end of smb2_open().

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index c527050bc981..c6473b08b1f3 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3714,7 +3714,7 @@ int smb2_open(struct ksmbd_work *work)
 	kfree(name);
 	kfree(lc);
 
-	return 0;
+	return rc;
 }
 
 static int readdir_info_level_struct_sz(int info_level)
-- 
2.43.0



