Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88C21BC4E;
	Mon, 27 Oct 2025 19:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593102; cv=none; b=AbKqaXhOfrtieoxOCSAOzgM+/vY2k6U2G2xjRr4f7Bu7zLG1vBbXJgMUQxoJi2cUKbJZlFEuUAKByMZOdKfk0PVf6GRvLROF471LU9DXoEzj+dcgo209YmI+sVhqR5ZoGg28X3hrlrsIyMrZtLyG46k+94IzykGpbvTJBbys8N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593102; c=relaxed/simple;
	bh=7raOm0jTMmhDoeuDICa36p8zC/7aP9LTysnvciKySsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETXbrB1J0yvk+7ddXpBeBTu8VZoaSP6snQrZYc9EcxCAQUtKsuDNHbgIbB4IBuaz4Xm89oHMNhwwe9XtOeiOiw4csB5v1dVwqSyZIF+SSFamj9q2lnzz4VmyHUHEtXGrHyJ0oBTF5OZNCfYvfS7hwL3tSQSSbdCQmaOzBPympt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kc3IK7LH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kc3IK7LH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D15BC4CEF1;
	Mon, 27 Oct 2025 19:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593102;
	bh=7raOm0jTMmhDoeuDICa36p8zC/7aP9LTysnvciKySsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kc3IK7LH7VW21bqEtcrg/4+dZ3zBpwbOuRaregb1YrQjFE3+ySNpPt1ZqvsI6sHVv
	 oKgV6YJZAV/Wuikgwx1EUoPQrgGHho9MiFDzg0iYNJuHxW/e1pglUKwk1LT4bqvcz/
	 4O6hCh1lakt6Kg4OTjj3RUDXaFuj5ASDOcIm0CZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 014/184] dlm: check for defined force value in dlm_lockspace_release
Date: Mon, 27 Oct 2025 19:34:56 +0100
Message-ID: <20251027183515.321229083@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 1929327ffbe1c..ee11a70def92d 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -730,7 +730,7 @@ static int release_lockspace(struct dlm_ls *ls, int force)
 
 	dlm_device_deregister(ls);
 
-	if (force < 3 && dlm_user_daemon_available())
+	if (force != 3 && dlm_user_daemon_available())
 		do_uevent(ls, 0);
 
 	dlm_recoverd_stop(ls);
-- 
2.51.0



