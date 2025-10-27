Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CA6320A1D;
	Mon, 27 Oct 2025 18:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590794; cv=none; b=jf9Oy/ANPOA0vwzwmH06baeTygo+OZoXQBRZx1WqGuvwoENaeJ6bg61iE+LDYvU7M+TXwjpBXNkA5yCsQI2joqzM9F77x6JjJiby62N6ogXpXE3/O/0lkDMFILOG88Di18l0fX4AJzXyMCjreDtfXGFoUSN7TPHDJeA7NTRFpXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590794; c=relaxed/simple;
	bh=FyxuwHKKEiWpqXl7K4dodKwV7ICeukt1YHn0Lcff46s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfvTe5jR/s5QdckiW8uSx/qF44kp+xxq+1SKY6NCxX0P5M8pSYrSkL0fZAUXMoUkYQHHiPuTKt/YlPEPJKIC2O1chwZG852i3TlNuyNHtoCDNoi3w7J5p8bv1OWv0pRB1vtoetCuxRZTTVPIdfY+CB4bSl6a6B4X7yZLdhc/cP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KtYIc4fl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KtYIc4fl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534D2C4CEF1;
	Mon, 27 Oct 2025 18:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590794;
	bh=FyxuwHKKEiWpqXl7K4dodKwV7ICeukt1YHn0Lcff46s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KtYIc4flVhEcUL1ZTme8u9Pf3MEUoOcFU01jXfHJy9PFYBxb3cKtpU4NlYqY5C8qp
	 pJx6xo5Df9+wOKme5/h9YNS50wAR2RRDiyP5cs0rNVThDLR3uuKXfSiGliW7bxV4rK
	 IfZ989bMXFUo+o8egmYTatAAX/O3oGzXmBJHijZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 178/224] dlm: check for defined force value in dlm_lockspace_release
Date: Mon, 27 Oct 2025 19:35:24 +0100
Message-ID: <20251027183513.637002415@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index c689359ca532b..9030e0e5927cb 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -793,7 +793,7 @@ static int release_lockspace(struct dlm_ls *ls, int force)
 
 	dlm_device_deregister(ls);
 
-	if (force < 3 && dlm_user_daemon_available())
+	if (force != 3 && dlm_user_daemon_available())
 		do_uevent(ls, 0);
 
 	dlm_recoverd_stop(ls);
-- 
2.51.0



