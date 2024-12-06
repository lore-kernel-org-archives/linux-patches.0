Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6069F1FF7D1;
	Fri,  6 Dec 2024 15:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497205; cv=none; b=mYvDqOnOdwSioW4AZH3aXg5M57IDRcCM8lJcOQ6rbkL+5YC0IyYi3tVWd7J0rwsUVKWod7CjHJai33KSMZA/MpflKkYS2AmzORwPVzNZ4WeYLwk6s9OvY9SDQVPquTEK7xbVQ0bcSybCWgvcI8COmYg0lK6MQ3f7dus78c4kpAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497205; c=relaxed/simple;
	bh=U0GvVVfCRUc0arF2de6g62XRyRU6g7kgS/GMVWv2zas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mkGKtE7THN9i/2Fj/fSwUTvanu1dVRx7Mfhptgq4ZraamaIBpGEeF+/jqGL/Ak1zlphF6Y49qHWvSNObEl317aCVGrU7CBwXK3v9FbVMysqZyNfpiIjnMF+eIC/T0xBfTRaBUmLJpBvVNqROX1hA4/sio/bmo4QUKvHXge/KW8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h9gMrSIT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h9gMrSIT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5BE4C4CED1;
	Fri,  6 Dec 2024 15:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497205;
	bh=U0GvVVfCRUc0arF2de6g62XRyRU6g7kgS/GMVWv2zas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h9gMrSITAGUCVlCH5WSXzFtxdFO79rJVWcGgPBMzuwCzz+nlHRC8QFb300noZZxlH
	 BeeN5jh1kZ6+npT15RL8bPwxXlunumbcu3N9Nk51PrhuWwkoHAE1srEhnMgS6l1poT
	 Ud3uGNaOBpbUp4toJ4QmRSPCU86tvDn6P8X6+hZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Gray <jsg@jsg.id.au>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 225/676] drm: use ATOMIC64_INIT() for atomic64_t
Date: Fri,  6 Dec 2024 15:30:44 +0100
Message-ID: <20241206143702.125570795@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Jonathan Gray <jsg@jsg.id.au>

[ Upstream commit 9877bb2775d020fb7000af5ca989331d09d0e372 ]

use ATOMIC64_INIT() not ATOMIC_INIT() for atomic64_t

Fixes: 3f09a0cd4ea3 ("drm: Add common fdinfo helper")
Signed-off-by: Jonathan Gray <jsg@jsg.id.au>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240111023045.50013-1-jsg@jsg.id.au
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_file.c b/drivers/gpu/drm/drm_file.c
index 48af0e2960a22..1d22dba69b275 100644
--- a/drivers/gpu/drm/drm_file.c
+++ b/drivers/gpu/drm/drm_file.c
@@ -149,7 +149,7 @@ bool drm_dev_needs_global_mutex(struct drm_device *dev)
  */
 struct drm_file *drm_file_alloc(struct drm_minor *minor)
 {
-	static atomic64_t ident = ATOMIC_INIT(0);
+	static atomic64_t ident = ATOMIC64_INIT(0);
 	struct drm_device *dev = minor->dev;
 	struct drm_file *file;
 	int ret;
-- 
2.43.0



