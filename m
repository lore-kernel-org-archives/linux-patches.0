Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621826;
	b=s9haAAbkPw/hoQhzymqhtSvvXufIbU3mYO/D8lOhcLkhcsnDYreHzJqFDafMWcrDyDwV
	 CnUAEZuj+7RkzKrnMTa5hg4DSyQlV2Q9WJFgwqjlxTbCy5ZdrJGWHuaypbAMWqJb9lyrM
	 jMu4Rk8jIUKtbyz/NuWxSm+Z052iwsdoBKjS6wPnGHsigCbDTLqYWw9pqVbQ5q5ybWXqk
	 bRTKCbVxskZH7yan4XU+awWW0AXSKvfU/mCgrJe2HKv6becYT+khSYp7bU+rzlkWNjdTD
	 o0qbIaxHrJG8WukBiYhrjeGvXvh5HZQtJ8u1/vlBq1D8YwQEdXYwxd+uIxLP/EnZF8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621826;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lzGJwn1nKUUZdPHQzPwJhc5gbjL0H1NXQzm7BfvL0so=;
	b=MRvK3hL2kD9k+3gXufEBgdgLgLgfPRYkR7B+7zXxwyLeaixdf+4Ry1zGG6f7TZht/30H
	 3SkG4i4IJnvIXqtnj7s1chl7iYQ3Jg0kDEkISAfUxfM3VKDV5SshBaGzDUK0APEp80pD6
	 HnK5uSscxRIR8ESN1fQOuJirWl8pOZjyN9r9dp8LaZzgbkDT8yI9OFuw5bkaeq6+JPqEp
	 aT8wYulqmWjSU/lTkab2eawAGt+o6LcgWiqyt9+9hEbDqfuTTpnTji7g6bi6n6WCY0yL6
	 7iTKgwDDU93yxiF01wiyw67pIytZlf4YnLZH337opfdodZcRH6VUKAR9//G1CHr0fdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ihANfsxl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC557606A32E;
	Wed, 25 Nov 2026 15:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ihANfsxl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B721F000E1;
	Wed, 25 Nov 2026 15:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621826;
	bh=lzGJwn1nKUUZdPHQzPwJhc5gbjL0H1NXQzm7BfvL0so=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ihANfsxlvK7Sy7Jt5zTbI0s2Q+XnJVZO1WsfRgjH3Lm6UMZk2Y/lYzfN7PjQnvHTY
	 Z47SFdoxb+CrYk5UHBYAqEcfIHEYtwzm1utFKellpTmFf/IFYWymMLodV8x9hlX86J
	 32nVa3KQjQxUJao4REhUQ+aA3W34MtOC9z5ppoO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 345/990] drm/xe: Fix build with DRM_XE=y and CONFIGFS_FS=m
Date: Wed, 25 Nov 2026 15:28:32 +0100
Message-ID: <20261125143830.174260312@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Vivi <rodrigo.vivi@intel.com>

[ Upstream commit da475c094342b6d5c8bc020b19d6900130bed047 ]

When xe is built-in but configfs is a module, xe_configfs.o is not
linked into xe, while IS_ENABLED(CONFIG_CONFIGFS_FS) in xe_configfs.h
still exposes the real declarations, leading to undefined references.

Use IS_REACHABLE() so this case falls back to the stubs, the same as
CONFIGFS_FS=n.

Fixes: 16280ded45fb ("drm/xe: Add configfs to enable survivability mode")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202610160935.Qk4ZxBxY-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202610162335.FEwMdGY9-lkp@intel.com/
Suggested-by: Matt Roper <matthew.d.roper@intel.com>
Assisted-by: LLM
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patch.msgid.link/20261021194555.2171344-2-rodrigo.vivi@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 30499cbd796117b63be3b59a1781c25ea3f4b27f)
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_configfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_configfs.h b/drivers/gpu/drm/xe/xe_configfs.h
index 08cce375ae0f3..ba24c1839d378 100644
--- a/drivers/gpu/drm/xe/xe_configfs.h
+++ b/drivers/gpu/drm/xe/xe_configfs.h
@@ -12,7 +12,7 @@
 
 struct pci_dev;
 
-#if IS_ENABLED(CONFIG_CONFIGFS_FS)
+#if IS_REACHABLE(CONFIG_CONFIGFS_FS)
 int xe_configfs_init(void);
 void xe_configfs_exit(void);
 void xe_configfs_check_device(struct pci_dev *pdev);
-- 
2.53.0



