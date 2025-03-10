Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13274230BF3;
	Mon, 10 Mar 2025 17:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626608; cv=none; b=n4Jr+PRBz1d4mTzWS1bE7by8Mua2ANq+GHn+t31KT/lT2oFFJdckIaSANnN4Ayvz956A2/kKWAEvy/HmuJcZOpwOBb84+rh56lXJDeFTvSWP6EAX/vmk/LyOS7iu2Nf4TlaEluX0X7jNXB0iU99a6Yi8ic/EtTBjkdE7MKGQW6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626608; c=relaxed/simple;
	bh=HAj3n3wZdS1Sg5EbevpnzuNqii0WNxp7Z98Rh01rUqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lr8Nuiuv5ubJG7f2mL6zRbFLOL7rpDscRFlI1prb+M19qkspRGJX2YWpvCHHGsn6QZSQvK151de4MTtfagtPWvAYyMJh4jyfpwcKRv55ak/8Doq7gLBaAceZXvtcr06WRXdK+JuAGV/+FmHcRG3uuhpWON5VBK2rQJx4U/jDe+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MrMpo49w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MrMpo49w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F12EC4CEE5;
	Mon, 10 Mar 2025 17:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626607;
	bh=HAj3n3wZdS1Sg5EbevpnzuNqii0WNxp7Z98Rh01rUqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MrMpo49wDJpZKZ/b93tYoYDAqmTEwx3DV+teLJv9B9S0+h0xZbKWy68PsP/qCJxF2
	 63IBwzTEjyODMCZA1TLFiYHXHfidZQn4fkApVIBrBS5IJiDxg6nO2Ag5t278ltg7Ma
	 Np4bFGmL6AjaRoQbynUiaRLfpOKYznxuOv6OyhmE=
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
Subject: [PATCH 6.13 051/207] drm/xe/vm: Fix a misplaced #endif
Date: Mon, 10 Mar 2025 18:04:04 +0100
Message-ID: <20250310170449.797902911@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


