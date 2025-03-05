Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06311A5BB7;
	Wed,  5 Mar 2025 18:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198303; cv=none; b=u2v0Xhl/qgV3IM9KLHGtVkmx5qV7shP69YSZRdNy7Dwl4ucwykOPWtbg8YHWxk+vzYpyRD6wsSUU+fGrZUvipqi/9rNtjRT/iKx3gRIKWYfI3pWkw21rc5hIVlghcNFrPmcRww095a5JewO4I1uxRyPE/s6fAFLhOzbbaxpabtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198303; c=relaxed/simple;
	bh=lggqwUla3fCMhSxXXBty40w6qsXOIDWjMz27nA6qHi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QL/1ZahrYu/hBYqXtzakKway00ts52zsG5o8XggeVjbiJfutYSy4dGbu5lJnJoUExGmj+cCWNlnz/t7UgR2xrZdWgmIB9Z8+Wo3HrAZ14e/I8QfzqIa2elkdg7UN8u+mt/iuaUVd0WNQ+yOSyd7aLEVYfil+mCzeLZt0BV1DBhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x25DuUQk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x25DuUQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76EF8C4CED1;
	Wed,  5 Mar 2025 18:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198302;
	bh=lggqwUla3fCMhSxXXBty40w6qsXOIDWjMz27nA6qHi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x25DuUQkg/p/wlI0lNawbkQ8wtkDSHIDFedEEmb/YOrQcGoMSTqRlHhqKOtXWT6tm
	 ZjBz6T+M07e1/03KwtByciSV034et7AZwCNqAvC9kJkBb2fQL6M9Znfj2Pb83nf4iB
	 y2MXamz09LsWETRJHZcO+QK5NMBvUOY8ybyksVAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ken Raeburn <raeburn@redhat.com>,
	Matthew Sakai <msakai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 132/150] dm vdo: add missing spin_lock_init
Date: Wed,  5 Mar 2025 18:49:21 +0100
Message-ID: <20250305174509.120430093@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ken Raeburn <raeburn@redhat.com>

commit 36e1b81f599a093ec7477e4593e110104adcfb96 upstream.

Signed-off-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-vdo/dedupe.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -2178,6 +2178,7 @@ static int initialize_index(struct vdo *
 
 	vdo_set_dedupe_index_timeout_interval(vdo_dedupe_index_timeout_interval);
 	vdo_set_dedupe_index_min_timer_interval(vdo_dedupe_index_min_timer_interval);
+	spin_lock_init(&zones->lock);
 
 	/*
 	 * Since we will save up the timeouts that would have been reported but were ratelimited,


