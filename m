Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A2E1E32D7;
	Mon, 21 Oct 2024 10:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506614; cv=none; b=DGqHpUQu0xWmuBKzZ9TL1KyhTiXROUOG1hjOUGgI8AXRRDHasPdhUYpQyaKWSe7jX+k5OK8qqe13qjowNVJ9x0kf7z4HzFozOlR3Sd4qHVpWOTAnNwuM0FVembgcaP69TRapDRTpsZFVBx+yfmT8UvJSu3CA48co9z8BPk0FSEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506614; c=relaxed/simple;
	bh=uORyptvjRf+siv0NNKFmtJ2Teb2sY3PxRS42kmdBtVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MAls6YQNYXds/ceseKwSKmZ5PsgCqMjTItVmfGLX0obwlySLtTJQoq22o5FRgi+aLmnIDaXUs5SUa7KF4gqbrFe0DnvLhR7VTnzhGgGLzYyoX3W82yZmxda1JBB0XpwvGZHNyKnJUDmdcdYWbih2zwVi6N9YxCmBiAJTH/Krzp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=stgRhb2D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="stgRhb2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D7CC4CEC3;
	Mon, 21 Oct 2024 10:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506614;
	bh=uORyptvjRf+siv0NNKFmtJ2Teb2sY3PxRS42kmdBtVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=stgRhb2DkD1z8obu4A5KbNe2hJfpiSX8Yy8BtxuangaDxN32s2QhzUNTTazfzVr5v
	 nLKu+w4L3K/leL1i1jztOvuAkd7L302IsSSyV4jOOAbhD63Q0TcioG+1TwcyLvHR+B
	 DQYshiCS2qR3DBfg/rf+vY70KHLgdAno6Ei3+mvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bommu Krishnaiah <krishnaiah.bommu@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.11 063/135] drm/xe/ufence: ufence can be signaled right after wait_woken
Date: Mon, 21 Oct 2024 12:23:39 +0200
Message-ID: <20241021102301.793751743@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nirmoy Das <nirmoy.das@intel.com>

commit 4e8b5a165160e2f521cc10bae58ce0b72b2e22b5 upstream.

do_comapre() can return success after a timedout wait_woken() which was
treated as -ETIME. The loop calling wait_woken() sets correct err so
there is no need to re-evaluate err.

v2: Remove entire check that reevaluate err at the end(Matt)

Fixes: e670f0b4ef24 ("drm/xe/uapi: Return correct error code for xe_wait_user_fence_ioctl")
Link: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/1630
Cc: stable@vger.kernel.org # v6.8+
Cc: Bommu Krishnaiah <krishnaiah.bommu@intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241011151029.4160630-1-nirmoy.das@intel.com
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
(cherry picked from commit ec7e6a1d527755fc3c7a3303eaa5577aac5cf6be)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_wait_user_fence.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_wait_user_fence.c b/drivers/gpu/drm/xe/xe_wait_user_fence.c
index d46fa8374980..f5deb81eba01 100644
--- a/drivers/gpu/drm/xe/xe_wait_user_fence.c
+++ b/drivers/gpu/drm/xe/xe_wait_user_fence.c
@@ -169,9 +169,6 @@ int xe_wait_user_fence_ioctl(struct drm_device *dev, void *data,
 			args->timeout = 0;
 	}
 
-	if (!timeout && !(err < 0))
-		err = -ETIME;
-
 	if (q)
 		xe_exec_queue_put(q);
 
-- 
2.47.0



