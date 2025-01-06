Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7872B1DE2CC;
	Mon,  6 Jan 2025 15:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177524; cv=none; b=j99DG7oy8gTo9MYCSAXaJGRPifK5GFYQ+TJKwtaf7z8nJazHAxI+ZRzNR+rxBxpta+hsaRjamkw9J8kioQhF+rNl3JsNkoVv0QJtqR0i6eeHtZ6pirfG2Ed5HAmdZ5jLGzR3DcWP8HkIl+XPK9PAtgIb6rdTaBAfZZK2yCfzCDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177524; c=relaxed/simple;
	bh=swuvo0GJ+jCK4cRFgjdcc07a2vVGAEdZ8AjsRFzFUek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ic2uXDz1Ig8bDwIVpINTaCuykQslIC7BG74UnLS3mPPMAXk72Wl9d0c+1lEup9gLPQ/Szm4SsBx5ljV1+BbOOGq7PpJa+lTdU4tXU9tD3hWAanHykCkRaIxlmE/cPGsQ8x3bcOVF1nOMHi+3TOoCSiNioNJocLTXX33gbvynaiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UG/rA1sZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UG/rA1sZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825FAC4CED2;
	Mon,  6 Jan 2025 15:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177521;
	bh=swuvo0GJ+jCK4cRFgjdcc07a2vVGAEdZ8AjsRFzFUek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UG/rA1sZdkZP+g3szr05fE5QqgdG81xMNpJuFFTIzi++yUvY2cVMs1GChnwzCsUJF
	 JYG17l2FgTm3L9+FJf8adKSUdGQiWaQ3on1crTEKUDp6IgZZdPnneNmCVEPrE1Q3Ry
	 cgTq1HHdcSyf+HTDAw3mBB3R/TrAWNu1lPBI/OIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 189/222] smb: client: destroy cfid_put_wq on module exit
Date: Mon,  6 Jan 2025 16:16:33 +0100
Message-ID: <20250106151157.917980228@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Enzo Matsumiya <ematsumiya@suse.de>

[ Upstream commit 633609c48a358134d3f8ef8241dff24841577f58 ]

Fix potential problem in rmmod

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 6ed0f2548232..bbb0ef18d7b8 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -2015,6 +2015,7 @@ exit_cifs(void)
 	destroy_workqueue(decrypt_wq);
 	destroy_workqueue(fileinfo_put_wq);
 	destroy_workqueue(serverclose_wq);
+	destroy_workqueue(cfid_put_wq);
 	destroy_workqueue(cifsiod_wq);
 	cifs_proc_clean();
 }
-- 
2.39.5



