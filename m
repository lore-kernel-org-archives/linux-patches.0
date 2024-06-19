Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9421482495;
	Wed, 19 Jun 2024 13:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803409; cv=none; b=ENjvC8Q0Yj/Ckql6Mii6gy3i5Dx04YrBcyC5KYtfGp1LAXfCDcmJ2UjeS8pMbPuVZkAlm/xthm3355VCFsptfjWtEocqvrsUdMHO35CjzrrF+mBbCLSlZQcJj0rb6E+2s4sn2Umu2oSxidqFRlxrG9vg1cixTGB74+GiRS7qy2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803409; c=relaxed/simple;
	bh=C2l9Umyl0SZEFem8jFHmXDhIHtMnTOpn9HB3r3xXoos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GPiRRBMvzVlOb0tMwcpckrRLAEusEkwW+L8uSN8ed1PPqiWdIw592Zl/Pd7EsNJSLpwHsxYtX1It/YnQNVnvGXCCPVZzOwEGAOgkAYWX8TAErSwc8XwwhFsb6LnOeKQTGCXcPAxtbVF6W+wsXo5qKDFO4wj+M0Q/B0AWf/YK3yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WvCSrS0/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WvCSrS0/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B4BDC2BBFC;
	Wed, 19 Jun 2024 13:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803409;
	bh=C2l9Umyl0SZEFem8jFHmXDhIHtMnTOpn9HB3r3xXoos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WvCSrS0/VOY1bApsSrRwv+BjzmeK6jhLrTnvbxYmEZRLnpXuon3wHLO9CS9tZkR+G
	 va5H9+Mo9fEtwNaNFVXWFiAysQlQ0lSRDXzS/+N9HQvC5I06zck6C0fEYijjyNUIR4
	 ZFXv+Pr+JZBV+f/9ggWU03Jg+dbqHUQ6U02JLGTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.9 258/281] drm/xe: Properly handle alloc_guc_id() failure
Date: Wed, 19 Jun 2024 14:56:57 +0200
Message-ID: <20240619125619.908461775@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>

commit 6c5cd0807c79eb4c0cda70b48f6be668a241d584 upstream.

Release the submission_state lock if alloc_guc_id() fails.

v2: Add Fixes tag and CC stable kernel

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Cc: <stable@vger.kernel.org> # v6.8+
Signed-off-by: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240521201711.4934-1-niranjana.vishwanathapura@intel.com
(cherry picked from commit 40672b792a36894aff3a337b695f6136ee6ac5d4)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_guc_submit.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -1257,6 +1257,7 @@ static int guc_exec_queue_init(struct xe
 	return 0;
 
 err_entity:
+	mutex_unlock(&guc->submission_state.lock);
 	xe_sched_entity_fini(&ge->entity);
 err_sched:
 	xe_sched_fini(&ge->sched);


