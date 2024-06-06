Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9860C1B29A4;
	Thu,  6 Jun 2024 14:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683401; cv=none; b=FHmH9o5Yf8sL1bcT+NP30XIorVkhWZEnLMh3JCbBb3Ku8BlktNzCMqI+x2uh/glIJ3/Sv2Z63xGoT4S7NUIEi8kFrQBSBpr6esKcHrMkCSM1+GQ/CYHt5OAYWGSVYV0HZ8dTPceZx5grX7g6S5pVisuJmEfHPLASTrQfxIrtx34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683401; c=relaxed/simple;
	bh=ZbVTZh/HtjxsjZ5jFCXT2Gb2RlO8SulYs137CTtUOFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cmIsN97x4yA0MTWAwnNQ8jx3rJr5oLkqwSAYxPCgVov01ts60txKUYj0jRcSNka4bj+OVze9AYBLLhr4qWGv9nBWniDRzblnfO9MOLfqVC8tjMNT21mqAnsyE3qWWIVQAjVLIdb09RYef+fJpbKGCJ7zVDYsWV5PD+Hkm6Nx+ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eTLLSjUH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eTLLSjUH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3F3C32781;
	Thu,  6 Jun 2024 14:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683401;
	bh=ZbVTZh/HtjxsjZ5jFCXT2Gb2RlO8SulYs137CTtUOFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eTLLSjUHk13VgbKj7G9pDpQ3HOENzohbi4qF8P2UAeG3apJW/Q4mMwh+5I9wSJVx8
	 Bdxx96bMvjSeTPQn1CbbxuCglukyh8ihHNTT8pxkvW/+IcAv/7M4jYXdwHn/qZG70l
	 G+pQrn+HTjSn+UyvRVlzwbK718zXUmHbhCORlQeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	William Breathitt Gray <william.gray@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 285/473] counter: linux/counter.h: fix Excess kernel-doc description warning
Date: Thu,  6 Jun 2024 16:03:34 +0200
Message-ID: <20240606131709.314021697@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 416bdb89605d960405178b9bf04df512d1ace1a3 ]

Remove the @priv: line to prevent the kernel-doc warning:

include/linux/counter.h:400: warning: Excess struct member 'priv' description in 'counter_device'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Fixes: f2ee4759fb70 ("counter: remove old and now unused registration API")
Link: https://lore.kernel.org/r/20231223050511.13849-1-rdunlap@infradead.org
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/counter.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/counter.h b/include/linux/counter.h
index b63746637de2a..246711b76e548 100644
--- a/include/linux/counter.h
+++ b/include/linux/counter.h
@@ -359,7 +359,6 @@ struct counter_ops {
  * @num_counts:		number of Counts specified in @counts
  * @ext:		optional array of Counter device extensions
  * @num_ext:		number of Counter device extensions specified in @ext
- * @priv:		optional private data supplied by driver
  * @dev:		internal device structure
  * @chrdev:		internal character device structure
  * @events_list:	list of current watching Counter events
-- 
2.43.0



