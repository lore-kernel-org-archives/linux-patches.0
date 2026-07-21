Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5BCF46EC8D;
	Tue, 21 Jul 2026 19:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660630; cv=none; b=bb+YQErO0y2LzGdegUNUA4PTACJ9MSjNM8cqzmRes+pt9vxB5Vyp8WBE0+teQO+nfs/b42QGBxcUn5n/Wwwb+1emWRXnFns6K/7lcdUL2Wxyb42p0XpFQ74IuM4/4tqFP8q6OTM9D2+amqWcAUScVII9Ni6tXWAOzLhcZzVksf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660630; c=relaxed/simple;
	bh=KX8gGK5+JmIlrgQHs8aGvo8WI3hSlGvtpOpfpp1cPbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTaGYeTdgiJqSl3gmqyFnhXiY4N/a9MhEIZ1Xmk3DgtSPm+jN/qWSgD/eHj/M4pWbBYPdqfHeXu9Aik/J98rpae50fNwun6GN0Tlh471FKezOrPArIK9d1yknpDPnO86sYa8CHaJqLDNjZosWdhhlEPrHuV051betttA1sltF3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2KcgUkMQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2KcgUkMQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87D71F000E9;
	Tue, 21 Jul 2026 19:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660629;
	bh=qdEHT9pC/TKhsQSJsY8eSh+4y0G46zmX/3klqfaa2Ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2KcgUkMQtr/Q1milMCfxhJgI23RXZfCMlTHAaME9cf/NnBR4ewXRr4UAekyDEoTLP
	 LoU6OdJvy6GaSx5uNEigEOHaK0p5rcJw2BnQ0f3AaxSdMs00SKN+NPbL7ZNBgx5MET
	 J9k050pks+rR9cr0kMGnOPlMkuLEaJ3N6KMNKfXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1050/2077] apparmor: remove unnecessary goto and associated label
Date: Tue, 21 Jul 2026 17:12:03 +0200
Message-ID: <20260721152617.579837025@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit e27bfb2ae9ad8522aea82d435fd6d73cccee7e17 ]

There is no need for a goto a label immediately following the
conditional block when the jump is the last statement in the block.

Fixes: 7306c41672487 ("apparmor: release exe file resources on path failure")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/task.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/security/apparmor/task.c b/security/apparmor/task.c
index 6445cb5f852668..b9fb3738124e05 100644
--- a/security/apparmor/task.c
+++ b/security/apparmor/task.c
@@ -313,12 +313,9 @@ static const char *get_current_exe_path(char *buffer, int buffer_size)
 	p = exe_file->f_path;
 	path_get(&p);
 
-	if (aa_path_name(&p, FLAG_VIEW_SUBNS, buffer, &path_str, NULL, NULL)) {
+	if (aa_path_name(&p, FLAG_VIEW_SUBNS, buffer, &path_str, NULL, NULL))
 		path_str = ERR_PTR(-ENOMEM);
-		goto out;
-	}
 
-out:
 	fput(exe_file);
 	path_put(&p);
 
-- 
2.53.0



