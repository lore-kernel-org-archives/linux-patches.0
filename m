Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793731333;
	b=OpvL5dQf80i3+CccOVMGV64qDIQTFLgvc2M8EeMArk8hj9VrE1SmUdKRKY9LSlEUeYyq
	 /8V7/QVu2GQR0gRvniSLn3D48XzD4rk0eYCuqAAdSJiw5dBbqJSkZP3mG+21VrITQGaER
	 t9ImyqhCXJLSc1cNhLwou1zF8nfCrOMCCnpWNMzW7QPhgRjLYoqfUbSnNPyD+JwmyfXVc
	 bDX5UdnyguPTBy1oUtaGWuv4wLLNliAWRgUNUI8lLcg6rfSwx3p4FeV56BjaCseYHeLWT
	 seeN16Y5WpGLvMegpwUISbJN1m+3l9OjyhGv+ahMI+MdCkNDT+IEnjgVEvpuz8bs9eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793731333;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=m6JbAA6AIoatTx3W2iR+oEUPKCoQ/RbwBBVTyBm0yuw=;
	b=ES7jjMI0MwdzGqsE1O4WlH/dA38/nauoItoA9OE/CLWMzmDT9UTa33Vb6U1HFP5JyfHk
	 rb3lEdceI6ApOa+ZtiYtItkCYV7HfT+DPXNDYpmkK6hiustJuiaoOlDOH33/yC3cM5SaX
	 sZY3o0RRD/CW4aQDRSvspXUDMkTAp729OQS4s4DIYx73MTLatb+d8LWFHKtDAfizJYDRW
	 wmdxpqrH7Rjd76f9a9Kx8huDVfRCTS+i3Llx7FKXFk4M21rrPE3m6IayH1a5Zw9LHJiuc
	 +xSHYLfBXlyj1X916A0dFeSR5io8Ae0hEj6FpTXkqRiPJVrreXEApkY6XSUAOm01sSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=cSmaCZUJ;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855E0606A324
	for <patches@lists.linux.dev>; Tue,  3 Nov 2026 18:42:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 855E0606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=cSmaCZUJ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=m6JbAA6AIoatTx3W2iR+oEUPKCoQ/RbwBBVTyBm0yuw=; b=cSmaCZUJTwdZ8a/fXUuh8MiQ72
	SzuFjS73W79d6BBS6sifALhVglPqETWlxMI/8gJDUM/yPWV0jxmEyorSaoEBJVu/EzAkkNQC15V1O
	oiZYGkbrH+yG7xWYie2tx1M51BLwaC+EeE8S1xJOZfwP9C2MJyQWX+TsA2EsjY9W52YU+oXVu0scc
	jkKV/ys4KGs5Tnup2xTSTO+3Me0S6kl75zlJQ4VMWZUrP9qnoDtCK1QNkpVpJnksWVXJWpEzbVfIe
	WtognEhyLI1go03/4DEBTiH6S6TGifoJiYJeeyt8Hi6wTOHUJXRLyjQ2MbeEmuJMEHXLGg36F5wNR
	VNQzyGgA==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOJSV-00000003Sko-2Imn;
	Tue, 03 Nov 2026 18:42:11 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	dri-devel@lists.freedesktop.org
Subject: [PATCH v4] drm/exec: drm_exec.h: eliminate kernel-doc warnings
Date: Tue,  3 Nov 2026 10:42:02 -0800
Message-ID: <20261103184205.2867179-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Repair kernel-doc comments to avoid kernel-doc warnings:

Warning: include/drm/drm_exec.h:149 No description found for return value of 'drm_exec_is_contended'
Warning: include/drm/drm_exec.h:162 function parameter '_exec' not described in 'drm_exec_retry'
Warning: include/drm/drm_exec.h:162 Excess function parameter 'exec' description in 'drm_exec_retry' (did you mean one of: '_exec')

Fixes: bba175a2d4be ("drm/exec, drm/xe: Avoid abusing the drm_exec retry pointer")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
v2: rebase & resend
v3: rebase & resend
v4: rebase & resend

Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: dri-devel@lists.freedesktop.org

 include/drm/drm_exec.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20261102.orig/include/drm/drm_exec.h
+++ linux-next-20261102/include/drm/drm_exec.h
@@ -143,7 +143,7 @@ drm_exec_retry: __maybe_unused;						\
  * drm_exec_is_contended - check for contention
  * @exec: drm_exec object
  *
- * Returns true if the drm_exec object has run into some contention while
+ * Returns: true if the drm_exec object has run into some contention while
  * locking a GEM object and needs to clean up.
  */
 static inline bool drm_exec_is_contended(struct drm_exec *exec)
@@ -153,7 +153,7 @@ static inline bool drm_exec_is_contended
 
 /**
  * drm_exec_retry() - Unconditionally restart the loop to grab all locks.
- * @exec: drm_exec object
+ * @_exec: drm_exec object
  *
  * Unconditionally retry the loop to lock all objects. For consistency,
  * the exec object needs to be newly initialized.
