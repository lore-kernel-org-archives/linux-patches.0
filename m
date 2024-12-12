Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239AE748A;
	Thu, 12 Dec 2024 15:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017282; cv=none; b=ukCBCGx62xCLVvjn6VIRgcLQImcjkPTpOy6y0d2jvSuQPflNVuYvn0kqie5M1xKzEjrZU5SItCNe6G93nN43dEHatJkn5M9e7RIe7w0D64wdh6HtBj0jDD1gbspWhzKHRqtSZG2mnmwUsRd+9CFbWq6B/Nx+eJvAvbfLi27FEH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017282; c=relaxed/simple;
	bh=5w69gvBC6i5ITaLcJlY38Wz7rCsffOpqsfNqYoxoMjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tvg6uVq4pd32N6e4KbVFQEt//LQj8bV9mlzGSo9+ZAPtYVnwv9VclvXg0k424i+YqfjHQWiX1iHm6xLY52YrtKZcZV6eZ3IGiQCTl/3sG13GNJZClH+n5Ahi+f1zfPqVTqhO0qUE33tTLVWpfBns7bUY0QF9RjFKUznzeVCczpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nV5bjKaN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nV5bjKaN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8A5C4CECE;
	Thu, 12 Dec 2024 15:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017282;
	bh=5w69gvBC6i5ITaLcJlY38Wz7rCsffOpqsfNqYoxoMjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nV5bjKaNBdXUaA9esbpnahNHgo5c3SxNf9376TIESciqQDzDG/dUIwY1qMyDHm42+
	 K858iqOAkgxQQM1NdudHMYH5vN/RluCbqACJF2OesgzJVWZb4Igy7+nsFDQSrlD98D
	 dap6s5i0wf+2vO1PCDIZdDrPTKL36sxTWv4d8kwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Badal Nilawar <badal.nilawar@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 435/466] drm/xe/forcewake: Add a helper xe_force_wake_ref_has_domain()
Date: Thu, 12 Dec 2024 16:00:04 +0100
Message-ID: <20241212144324.053867621@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

From: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>

[ Upstream commit 9d62b07027f0710b7af03d78780d0a6c2425bc1e ]

The helper xe_force_wake_ref_has_domain() checks if the input domain
has been successfully reference-counted and awakened in the reference.

v2
- Fix commit message and kernel-doc (Michal)
- Remove unnecessary paranthesis (Michal)

Cc: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Badal Nilawar <badal.nilawar@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Reviewed-by: Badal Nilawar <badal.nilawar@intel.com>
Reviewed-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241014075601.2324382-4-himal.prasad.ghimiray@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Stable-dep-of: 5dce85fecb87 ("drm/xe: Move the coredump registration to the worker thread")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_force_wake.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_force_wake.h b/drivers/gpu/drm/xe/xe_force_wake.h
index a2577672f4e3e..1608a55edc846 100644
--- a/drivers/gpu/drm/xe/xe_force_wake.h
+++ b/drivers/gpu/drm/xe/xe_force_wake.h
@@ -46,4 +46,20 @@ xe_force_wake_assert_held(struct xe_force_wake *fw,
 	xe_gt_assert(fw->gt, fw->awake_domains & domain);
 }
 
+/**
+ * xe_force_wake_ref_has_domain - verifies if the domains are in fw_ref
+ * @fw_ref : the force_wake reference
+ * @domain : forcewake domain to verify
+ *
+ * This function confirms whether the @fw_ref includes a reference to the
+ * specified @domain.
+ *
+ * Return: true if domain is refcounted.
+ */
+static inline bool
+xe_force_wake_ref_has_domain(unsigned int fw_ref, enum xe_force_wake_domains domain)
+{
+	return fw_ref & domain;
+}
+
 #endif
-- 
2.43.0



