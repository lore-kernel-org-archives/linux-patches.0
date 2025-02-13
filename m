Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B7A1DDA1B;
	Thu, 13 Feb 2025 15:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459149; cv=none; b=udsYTKvWMFd88IyJn4mNOB2KnLKygEw2dlQveQILy/WfEhORo7au/Cm4ZW27S9x7EiX7CemrgJlbGguu6xL7AbFw9VZbxPwjT3As5jt5ierWGzVx1o+qC6L///PeGd7lrOMOLXN3JBJAUxyiIgBKCKaKJZFgF0YCHgU1pvCRnqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459149; c=relaxed/simple;
	bh=QLAmDpvnhav+0WlDR+wsf3FbUCKh8Q12OFzc5PSYSIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gT+BMC/I1EhuDox3Pt5DlvIbClZaZpnzjtY2BRq9Qicj7sKzvCPmFdMT+bVFsThcH5hnvRNmrHvjowJmBcJ/jeIdmU7mmmlh/mVfweCIgQqLIgukbYw1J5oKR7qCjHImNUa+ugxI9NAZgyIb3KQYuQ+I108EIc2HJyAziZaoJSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vwDwu+zf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vwDwu+zf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B2FAC4CED1;
	Thu, 13 Feb 2025 15:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459148;
	bh=QLAmDpvnhav+0WlDR+wsf3FbUCKh8Q12OFzc5PSYSIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vwDwu+zfjvHE0jkjkOCr3l9/Kx6BXh5lWOFqCvAERJiKq0rERwWgwk5z+Rybh31fH
	 VuRY0P4EjSW0Jl7p1rQab8zNRmV+KjFac+FGh7LzzM4EEXtZSdWz9pZEYi7rd5n5CR
	 blMQ//blnZcrct83yGiZwUoyCLvy8hD6ANwUXDGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Harrison <John.C.Harrison@Intel.com>,
	Julia Filipchuk <julia.filipchuk@intel.com>,
	=?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.13 183/443] drm/xe/devcoredump: Move exec queue snapshot to Contexts section
Date: Thu, 13 Feb 2025 15:25:48 +0100
Message-ID: <20250213142447.677056087@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

From: Lucas De Marchi <lucas.demarchi@intel.com>

commit 042c48b73699c47d84b6ace73036e5a31a0d4cfc upstream.

Having the exec queue snapshot inside a "GuC CT" section was always
wrong.  Commit c28fd6c358db ("drm/xe/devcoredump: Improve section
headings and add tile info") tried to fix that bug, but with that also
broke the mesa tool that parses the devcoredump, hence it was reverted
in commit a53da2fb25a3 ("drm/xe: Revert some changes that break a mesa
debug tool").

With the mesa tool also fixed, this can propagate as a fix on both
kernel and userspace side to avoid unnecessary headache for a debug
feature.

Cc: John Harrison <John.C.Harrison@Intel.com>
Cc: Julia Filipchuk <julia.filipchuk@intel.com>
Cc: José Roberto de Souza <jose.souza@intel.com>
Cc: stable@vger.kernel.org
Fixes: a53da2fb25a3 ("drm/xe: Revert some changes that break a mesa debug tool")
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250123051112.1938193-2-lucas.demarchi@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit a37934ea75d331fafa7fe80b6180642ba5193422)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_devcoredump.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/gpu/drm/xe/xe_devcoredump.c
+++ b/drivers/gpu/drm/xe/xe_devcoredump.c
@@ -109,11 +109,7 @@ static ssize_t __xe_devcoredump_read(cha
 	drm_puts(&p, "\n**** GuC CT ****\n");
 	xe_guc_ct_snapshot_print(ss->guc.ct, &p);
 
-	/*
-	 * Don't add a new section header here because the mesa debug decoder
-	 * tool expects the context information to be in the 'GuC CT' section.
-	 */
-	/* drm_puts(&p, "\n**** Contexts ****\n"); */
+	drm_puts(&p, "\n**** Contexts ****\n");
 	xe_guc_exec_queue_snapshot_print(ss->ge, &p);
 
 	drm_puts(&p, "\n**** Job ****\n");


