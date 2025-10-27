Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B7031DDBC;
	Mon, 27 Oct 2025 19:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592315; cv=none; b=GrlMu8Vc3Hb5xKB62lXNCo4wlz1XjhvR7enLNZZhGzWcfT8468PCeKQXCsVTyzWWa3o1xBvNamdY4TBvHhS9qAT0+HeY2f61xp2LsOtAXAY2RA6eqCjbN3QwHMgsbdGQPc5b7Yv1BAVr13gKlBg5q5Z7BkkN0wGda5PE2BWTcUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592315; c=relaxed/simple;
	bh=RLEyKiUDOaBsjvcI8A3HOqkB444meU7paxq/3jl4wHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hHyUybE/mlK1cU08K2FCHazuAaJh3EA4N/NYZqBhvHiC1i0XNBR4Pdk/uJauUTHSv+Ga+lvDZ4uVdBayrT99wvIzQIz48uXOJ3NPCXc/SfUUBtVh7SKrGHhDF2olcXpwhpgHvsfkqcqa39LKi17txlsHpI9i6jhpNHM1gKzXMJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=diozo+s0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="diozo+s0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF61C4CEF1;
	Mon, 27 Oct 2025 19:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592315;
	bh=RLEyKiUDOaBsjvcI8A3HOqkB444meU7paxq/3jl4wHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=diozo+s0i+XUuH/AI/yxNyh4JYMS1/c5AkROLgrcmpm9WV8gw8ZKPAXhDY2abarz9
	 WeOJbGqzjEowCjfdm6fS7TY7HoRPXhJ7K0TqigMBc5LfdEc/EOXmsBrgvbmC7j/Gt3
	 d1fShYXuZ+nF3pxaZYIWQZuMf374w1GQgc5YoIdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 074/157] dlm: check for defined force value in dlm_lockspace_release
Date: Mon, 27 Oct 2025 19:35:35 +0100
Message-ID: <20251027183503.267280230@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 6af515c9f3ccec3eb8a262ca86bef2c499d07951 ]

Force values over 3 are undefined, so don't treat them as 3.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lockspace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 23cf9b8f31b74..e7372d56c13f4 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -825,7 +825,7 @@ static int release_lockspace(struct dlm_ls *ls, int force)
 
 	dlm_device_deregister(ls);
 
-	if (force < 3 && dlm_user_daemon_available())
+	if (force != 3 && dlm_user_daemon_available())
 		do_uevent(ls, 0);
 
 	dlm_recoverd_stop(ls);
-- 
2.51.0



