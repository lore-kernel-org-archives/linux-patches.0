Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF7D25B095;
	Sat, 30 May 2026 17:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163545; cv=none; b=JypwY0R8lFdyXoE4XzGlbL6toHHu0Hf0T1x7wesPw+U6e/zFvSbskZq02eQoik2CKg0nloxAPmt2nCpgWk2Kp0YkLZZQO7c1210Kppj++kTwHYTMB+e8Qbj7EopnPBLxb0yxL+MOING7tuiPsC7Cgo1hGXrGgseJL4hip7KrWq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163545; c=relaxed/simple;
	bh=YKFoEdrgzJUj4vE5IzTtS/PEAFOlBXV/rcu9j8bXJNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i00QZwAceBDjutcVHEBzqT5Std4S2U72TLfkrKTPE06J4JFbM2sg/igi4BcdmeCbHBgbdbbc++lfnKNOElq3Ctst6JcmBolvg+nK65Y4vsDU/4e7PSem5My0T2wFdRoyABACMvt8mWvMjYiSP9yohk2eZzaXU1ME8yFRI3Iwpfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o20OMVoe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o20OMVoe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7C41F00893;
	Sat, 30 May 2026 17:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163544;
	bh=92W+EHKiXiyhs7Z7sEqs1wf7Rc5L2Kw5VOHkdZk8WBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o20OMVoeLg67kWTyhEYA0Pnjnsrhk+jvyYPnwn+cBKsmOuAWisM+hIcP0mAN/ACbo
	 JNw1+jrJtOiGEq1SRlb1DOpJkq0e0797mWg8btLoNUWk3AxBuO0OwM+u7kTGVgZIUT
	 YnRFju7OFIuqJEqiK5yx05t5UFEMIfl0BErUiTyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Douglas Anderson <dianders@chromium.org>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 5.15 263/776] driver core: Add kernel-doc for DEV_FLAG_COUNT enum value
Date: Sat, 30 May 2026 17:59:37 +0200
Message-ID: <20260530160247.336622934@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

commit 5b484311507b5d403c1f7a45f6aa3778549e268b upstream.

Even though nobody should use this value (except when declaring the
"flags" bitmap), kernel-doc still gets upset that it's not documented.
It reports:

  WARNING: ../include/linux/device.h:519
  Enum value 'DEV_FLAG_COUNT' not described in enum 'struct_device_flags'

Add the description of DEV_FLAG_COUNT.

Fixes: a2225b6e834a ("driver core: Don't let a device probe until it's ready")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Closes: https://lore.kernel.org/f318cd43-81fd-48b9-abf7-92af85f12f91@infradead.org
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://patch.msgid.link/20260413195910.1.I23aca74fe2d3636a47df196a80920fecb2643220@changeid
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/device.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -380,6 +380,7 @@ struct dev_links_info {
  *
  * @DEV_FLAG_READY_TO_PROBE: If set then device_add() has finished enough
  *		initialization that probe could be called.
+ * @DEV_FLAG_COUNT: Number of defined struct_device_flags.
  */
 enum struct_device_flags {
 	DEV_FLAG_READY_TO_PROBE = 0,


