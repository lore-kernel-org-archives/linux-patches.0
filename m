Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCE2226D0B;
	Mon, 10 Mar 2025 17:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627439; cv=none; b=LQpqwKaKtINMiyRwdwECrnLPe3vCXAwVE9daMsjhPDI0AeUox0ZKPNUmWEXmtvFH2Z0l7tPrbUeL6fHwcUehxPRwtuHtpZolYSC4iu6rtJ9drRYN0QZk7OqpiTgYa7W5VHA3xUwDhx1H465LT9d9FjX52BfeGuPzEVYqFpFy5NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627439; c=relaxed/simple;
	bh=v6sKzMiMeGVSGMu2DRwHEbQzFcBqyUUfimKcbT9VSMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OJdoHi29xjKEaOrZ+S4Qwu5UE36pO+NcapURTihedNKzxy8tZuhsrrtDBlTL+L16uqWXO77VD5exBJXtJrd9U+ixHxgXOjyeUrBBNFDsb3RncreA6ZPOhLhxzcTb2hRvWpT5/h+1PDtfAVgH/iF/qeW8YvnJHHAoTpmLpVbNu2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SbrqMXcD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SbrqMXcD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C417C4CEE5;
	Mon, 10 Mar 2025 17:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627438;
	bh=v6sKzMiMeGVSGMu2DRwHEbQzFcBqyUUfimKcbT9VSMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SbrqMXcDXqkll1DlzwOF7r6gkyXbOchOWFpijIl+ezqV6QN11tAlUrpZxS9XztP1i
	 bH7LDUbDt0amLqSZhkhtKG1UviRW16SOnIzWkbj1H7CngQc83kir7CgAE7Oc1uDaQF
	 6RqMr0JtlluHkASb3pSaHCq63lgfyLmNgyeOFCc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	=?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.12 112/269] drm/xe/vm: Fix a misplaced #endif
Date: Mon, 10 Mar 2025 18:04:25 +0100
Message-ID: <20250310170502.183470495@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellström <thomas.hellstrom@linux.intel.com>

commit 1414d95d5805b1dc221d22db9b8dc5287ef083bc upstream.

Fix a (harmless) misplaced #endif leading to declarations
appearing multiple times.

Fixes: 0eb2a18a8fad ("drm/xe: Implement VM snapshot support for BO's and userptr")
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: José Roberto de Souza <jose.souza@intel.com>
Cc: <stable@vger.kernel.org> # v6.12+
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Reviewed-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250228073058.59510-3-thomas.hellstrom@linux.intel.com
(cherry picked from commit fcc20a4c752214b3e25632021c57d7d1d71ee1dd)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_vm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_vm.h
+++ b/drivers/gpu/drm/xe/xe_vm.h
@@ -275,9 +275,9 @@ static inline void vm_dbg(const struct d
 			  const char *format, ...)
 { /* noop */ }
 #endif
-#endif
 
 struct xe_vm_snapshot *xe_vm_snapshot_capture(struct xe_vm *vm);
 void xe_vm_snapshot_capture_delayed(struct xe_vm_snapshot *snap);
 void xe_vm_snapshot_print(struct xe_vm_snapshot *snap, struct drm_printer *p);
 void xe_vm_snapshot_free(struct xe_vm_snapshot *snap);
+#endif


