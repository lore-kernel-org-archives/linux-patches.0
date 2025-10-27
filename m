Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3D52BD033;
	Mon, 27 Oct 2025 19:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592617; cv=none; b=J30AExYW8X2Ub0u78tTi/XQDoMWPezBeOig2uQdxHhbme7VatRY9Vf4YZbvsLwA7vL5zSedsb73HPyFVvpWzAbX3llMvESxid+gvrqSkuaiDMUB6+n4LJjBh6IqD7cDefERN6BvHAI2EuP6wv+BZwTRE1X9x/ZoRXzb5k8H29gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592617; c=relaxed/simple;
	bh=t1lE6gkMD8EONB5uc1bkAF/fFTWY/mnSTWe9vlbM04c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gS4czzNwHObMZbl9zsm9G9bFNfEBAiHkahUKzlArVN4wkoUxJAK/n9fKrlSDPoTH13zpVQohCTI+35kNTs4GKHCj375Lmm54NjOQ8f9F9fHVrf+r3T2IdXwP9MCF2zCcrXc72W4LhjAXFLfMaVAZMjOTJJh5yf+BsLVQpz/fptU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NT9rIw0L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NT9rIw0L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C0EC4CEF1;
	Mon, 27 Oct 2025 19:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592617;
	bh=t1lE6gkMD8EONB5uc1bkAF/fFTWY/mnSTWe9vlbM04c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NT9rIw0Lv7XMs4JQ1PknOThOPKKgRS/1Z9HACcZUgijqRQBVvs9OXI9bPKr7c4Ar2
	 6oVJkFwJsU0EZa3UlhmCXnZieQpPNPoC5fH0lHuG21ft0VXfsWos2YdneMJ1iKMIu8
	 yfsLRpV1J8t0foo8w70ey+wtTvySSvVahDOyvzlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 08/84] dlm: check for defined force value in dlm_lockspace_release
Date: Mon, 27 Oct 2025 19:35:57 +0100
Message-ID: <20251027183439.037536233@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 6af515c9f3ccec3eb8a262ca86bef2c499d07951 ]

Force values over 3 are undefined, so don't treat them as 3.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lockspace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 0455dddb0797c..0b17657690d4d 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -802,7 +802,7 @@ static int release_lockspace(struct dlm_ls *ls, int force)
 
 	dlm_device_deregister(ls);
 
-	if (force < 3 && dlm_user_daemon_available())
+	if (force != 3 && dlm_user_daemon_available())
 		do_uevent(ls, 0);
 
 	dlm_recoverd_stop(ls);
-- 
2.51.0



