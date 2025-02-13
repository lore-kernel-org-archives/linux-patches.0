Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56BD26B0B4;
	Thu, 13 Feb 2025 15:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460417; cv=none; b=neZoyGjdJ1KZP6ZN6dKyYpsnasihKZeX2EvBmW3y8bYCB8NpLQeBHnllPjPAgcOmwp1it0dVzZ88V4b8uMyo2F1nw5SmB/Si3WrinaAqPnPzgPHtHhGmqi7UmyKZllc6Js+qOC8NnzHMHdR2o88/B7nz/u1u/sKC9gYKD+d/SgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460417; c=relaxed/simple;
	bh=KIJAZW/XHmYAMgfC0yTlxW+RzlJLP+38jb8dC6N/4CQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hk02sADDye2Dh9SJBWc4Bdg4+UFwLW2Ox4qmGZ7vMvs0H2d9jbJ0FR2aBjxUp96bDzqtTddf7FGlW4+vGDr6jqo71+0ZBy4jJ72sGMAENrCKS6Mcvc6h+NSPpKVAIGTJfZqew5N8VTuRhgvFX1peS+icRdzMQFkusymfw0wwt24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ghOMr0nC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ghOMr0nC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145D4C4CED1;
	Thu, 13 Feb 2025 15:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460417;
	bh=KIJAZW/XHmYAMgfC0yTlxW+RzlJLP+38jb8dC6N/4CQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ghOMr0nCbIX080M/b3nBUJ9u912I34ZFi695irSjNwWA2yTHZLloWv3gi81Rx2yVJ
	 Me4eTThvxGOCNbBDAJs5MKc/jqGv4e0znxTxI7Yk8Lb4Z39sq0Lo+iNQZVUue7Y3hm
	 3NG6VqBxbKhTOPCnoyl5ru9ZzaEExZqZ4VvWTK+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <wayne.lin@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 099/273] Revert "drm/amd/display: Use HW lock mgr for PSR1"
Date: Thu, 13 Feb 2025 15:27:51 +0100
Message-ID: <20250213142411.256390501@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Chung <chiahsuan.chung@amd.com>

commit f245b400a223a71d6d5f4c72a2cb9b573a7fc2b6 upstream.

This reverts commit
a2b5a9956269 ("drm/amd/display: Use HW lock mgr for PSR1")

Because it may cause system hang while connect with two edp panel.

Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c
@@ -63,8 +63,7 @@ void dmub_hw_lock_mgr_inbox0_cmd(struct
 
 bool should_use_dmub_lock(struct dc_link *link)
 {
-	if (link->psr_settings.psr_version == DC_PSR_VERSION_SU_1 ||
-	    link->psr_settings.psr_version == DC_PSR_VERSION_1)
+	if (link->psr_settings.psr_version == DC_PSR_VERSION_SU_1)
 		return true;
 	return false;
 }


