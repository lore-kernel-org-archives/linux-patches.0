Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BF71F76DA;
	Tue,  3 Dec 2024 15:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241002; cv=none; b=GBtTC+Errf2A1dwKKzxmTrJH7abMDMRp19KpBZ63op9RIzHi6adcscPgEPRntZzMr8SIT3cS5nQxS2G5eX7xnpDNIp+VcKnP+zQKkNNld/eNzvGMFmtlxDFufQLkuaO6zQc+VXClo03Pcqq8/tmc2MQd+3T911c0/vW8nYq9YNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241002; c=relaxed/simple;
	bh=GC71FsEjCPaNucQW8xQZT38VyUchD2e/tLUvdqhmCb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sm/8j1T5wkNS+ka8hGL0qWXVbpztw6h2sSv+qjAxxogmkdw5NPDJzTGpOl47+wDpU7Tw85LsmMjm7Bsp+5P5edyMox3AqBjhzTWpzN5wHeMZjr8Qn6lZgwCssf/sReF+tk7kyN967Ck8b1iNwJuaqj9vz22bOpj+r4Wvg0W1OwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z7AgJZ6P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z7AgJZ6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0708CC4CEDA;
	Tue,  3 Dec 2024 15:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241001;
	bh=GC71FsEjCPaNucQW8xQZT38VyUchD2e/tLUvdqhmCb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z7AgJZ6P6ojkDaWrGlNVIseJkKNKkj3VtKshAMXqeOSzOMOUIA5ZALzD5K9eSHI+5
	 goP7EhFwe+fyKxksboXhlzTkMuT+HBYnXxPBt6lOjfOeeltQhYZdPZN5ofAHZyVW2M
	 Wjk7TpaNHFm8k1by6YNsKND+NcTtHHjB6P5BroM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Gray <jsg@jsg.id.au>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 297/826] drm: use ATOMIC64_INIT() for atomic64_t
Date: Tue,  3 Dec 2024 15:40:24 +0100
Message-ID: <20241203144755.352159829@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ad1dc638c83bb..ce82c9451dfe7 100644
--- a/drivers/gpu/drm/drm_file.c
+++ b/drivers/gpu/drm/drm_file.c
@@ -129,7 +129,7 @@ bool drm_dev_needs_global_mutex(struct drm_device *dev)
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



