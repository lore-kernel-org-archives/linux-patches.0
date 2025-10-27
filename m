Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEED31D753;
	Mon, 27 Oct 2025 19:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592844; cv=none; b=mNvTXT1S5ckYyYB3OvedlWzuOFZehgtv20i/Lx7FDnjbPg1+wHFM7WQis1C+YDqau/CQRKtI8k7rx6/L/jEeoD3f5ggn54Al3V2slp+4p2Ia4TBVz6ps4KBC14pDd9Yf6YFBwF4eObT974eqbIvBPeCV0KjzMMn5P+1AjTVhyLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592844; c=relaxed/simple;
	bh=TgnYSmINwvw5cBzMyi7Y1FJ4xK7yS1Dz3ApNiGOhJlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b73wDNc77TyrSUj58ho3odNR6RJtgRbQ2AWMfM2aPeLNpvemQuRpgqxLenCcJ6CYCCzduUkbGw9cZCZ5PaL0RQTo9pik7MJOnKIXDGilYJbjbgMAIaMHD9fxI3zJV6YnIZ4DHAbU3LP+ngJoOiWv8b6w7gu6AjG2VqYx0qaLKWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bp7WLCel; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bp7WLCel"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50949C4CEF1;
	Mon, 27 Oct 2025 19:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592844;
	bh=TgnYSmINwvw5cBzMyi7Y1FJ4xK7yS1Dz3ApNiGOhJlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bp7WLCelVpOg29vU3j5thZDj3b3KjeybuSWJdZAEApiIVNPLaDTW7JfQKSbuzlm8C
	 4MTPblq3r1jl+hJMEUhMf3g3kOtQSsdl8FgnBZFjfqhAxObPtzQgO2ihch4Y9LlutZ
	 VEKdKDQu0MaJcVxQRR9JWsU1SmTJ0ZfrTO9DY0Ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 008/117] dlm: check for defined force value in dlm_lockspace_release
Date: Mon, 27 Oct 2025 19:35:34 +0100
Message-ID: <20251027183454.161250142@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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
index 8afac6e2dff00..7b4b6977dcd66 100644
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



