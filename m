Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC991EEA54;
	Wed, 19 Feb 2025 08:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954798; cv=none; b=qcXx2KCQHjr6qb6iRxXblK8gKqjQKishoYusGQldEavW4BZutD4uYdO46WqTlZyAh7S1Nlak4snfdnSjwGHj5RhDMCetP7r8dIldQv25rU9u2kH+yIp5fI7/QPtzjMFnB64Hwxp3sH/06C+UKUGkMeP80EqKZPE+wLolbJu2N6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954798; c=relaxed/simple;
	bh=Ku8sNTQu217ROkcVFR7okDcdeghudvs65SpYgWaxqOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V0vB/BypCG6HqIW5xcSgqu5MW9ojzwcnOs3hs3l2A3L3Au4hMKHnQTTM3fJw5I8aXcKKPa7rz7NJFRi2l4ICHa32RYcmX9qVGA+9OrlcZr3Squ5UbuT5IrD7/PWcqGdn3YEA1Esjpb6/ns2Ceh7Sdr6qI+8d9U8qgJllbkyTmpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sHMCHnFJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sHMCHnFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D00C4CEE6;
	Wed, 19 Feb 2025 08:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954798;
	bh=Ku8sNTQu217ROkcVFR7okDcdeghudvs65SpYgWaxqOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sHMCHnFJ2lBSu7hLZn3cfwiR34xorg0r5B1ikgMEs0lO6YVpiAfIBZ4oGYs9WVKs9
	 +ytvxSYgmPkYJ8IR3uMz10bUljEbPxV2JUgIpM7kFlqaZdfOXj6VT0PyO4k5ZtVi+i
	 X7Ff9lquK98bj0RBcJIMI9Rz1rmqbEAEK9w2o2ZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/230] drm/xe/client: bo->client does not need bos_lock
Date: Wed, 19 Feb 2025 09:25:57 +0100
Message-ID: <20250219082603.279261276@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejas Upadhyay <tejas.upadhyay@intel.com>

[ Upstream commit fc876c9524e2a9f816f51d533ed31df789cff65a ]

bos_lock is to protect list of bos used by client, it is
not required to protect bo->client so bring it outside of
bos_lock.

Fixes: b27970f3e11c ("drm/xe: Add tracking support for bos per client")
Signed-off-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250205051042.1991192-1-tejas.upadhyay@intel.com
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
(cherry picked from commit f74fd53ba34551b7626193fb70c17226f06e9bf1)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_drm_client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_drm_client.c b/drivers/gpu/drm/xe/xe_drm_client.c
index fb52a23e28f84..a89fbfbdab329 100644
--- a/drivers/gpu/drm/xe/xe_drm_client.c
+++ b/drivers/gpu/drm/xe/xe_drm_client.c
@@ -135,8 +135,8 @@ void xe_drm_client_add_bo(struct xe_drm_client *client,
 	XE_WARN_ON(bo->client);
 	XE_WARN_ON(!list_empty(&bo->client_link));
 
-	spin_lock(&client->bos_lock);
 	bo->client = xe_drm_client_get(client);
+	spin_lock(&client->bos_lock);
 	list_add_tail(&bo->client_link, &client->bos_list);
 	spin_unlock(&client->bos_lock);
 }
-- 
2.39.5



