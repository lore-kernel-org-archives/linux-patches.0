Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB26C2C2346;
	Wed, 28 Jan 2026 15:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615286; cv=none; b=HnGRnhp0g3Zh/NnlnvQ1a1s71fubnXuuR6tzW7Vw6YCIcmD3x1ncRUZGVGJSFmx6auGJmuWOWJ+6o0tMzC29fiuCONfgWAtgD8nawmtmCYwdxAGLj7w1k+ZR5RsEA6HQ7lfZeN0R8hB2uT7HmiPS8EJ0DgVtyixDGUrRlNKgjnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615286; c=relaxed/simple;
	bh=s90pOchqSJ75z64CfJexxr/kb0bbk+O+Knw3QZa7yLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CD9Qep8EsSmwUPzJH8s7+y9a6lLtOF8zG+osbY5F8aPX0ChElUefjvdrMQqPFBsZAFFotqFXr97EBmtoW5KYULU1VqnD82xrDuk82Ncpcu4DM3bMok+FYIfwJSlU9s6+4Fi6IY3cAK1q1GhWjgKUzU/315xgZxlE6XW4KR0q43E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kmEp+EPD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kmEp+EPD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B19FC4CEF1;
	Wed, 28 Jan 2026 15:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615285;
	bh=s90pOchqSJ75z64CfJexxr/kb0bbk+O+Knw3QZa7yLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kmEp+EPDmWba5A5vKGWktcKijZXK4YaxS6nm6gyBYG14XaDff//wPUKIYtaIA6XzJ
	 grL2Erqk5MQ1rlqD7ldBRweYLHQAlFnfi0Ve71Rz23o7nnA2YacfsqEo6yhvy9zWo1
	 W8K/IoVTdTE+yQYARxsBNioZkOG544NFI8iEttWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Dave Airlie <airlied@redhat.com>
Subject: [PATCH 6.12 116/169] drm/nouveau/disp: Set drm_mode_config_funcs.atomic_(check|commit)
Date: Wed, 28 Jan 2026 16:23:19 +0100
Message-ID: <20260128145338.178266045@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

From: Lyude Paul <lyude@redhat.com>

commit 604826acb3f53c6648a7ee99a3914ead680ab7fb upstream.

Apparently we never actually filled these in, despite the fact that we do
in fact technically support atomic modesetting.

Since not having these filled in causes us to potentially forget to disable
fbdev and friends during suspend/resume, let's fix it.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Dave Airlie <airlied@redhat.com>
Link: https://patch.msgid.link/20260121191320.210342-1-lyude@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_display.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/nouveau/nouveau_display.c
+++ b/drivers/gpu/drm/nouveau/nouveau_display.c
@@ -391,6 +391,8 @@ nouveau_user_framebuffer_create(struct d
 
 static const struct drm_mode_config_funcs nouveau_mode_config_funcs = {
 	.fb_create = nouveau_user_framebuffer_create,
+	.atomic_commit = drm_atomic_helper_commit,
+	.atomic_check = drm_atomic_helper_check,
 };
 
 


