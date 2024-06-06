Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29593197544;
	Thu,  6 Jun 2024 14:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682918; cv=none; b=DOVVAUc8hjgEVKMVwC+Rc1cQDI1l1d3Of7I+FWn0kAIM4lfl16o+yNgRqEriAPf1OuimZ28Wm8I0LzWF6yU72sDxDDcaWHoOTYrN2vzp8emNl2Ge+Dv0KnYZMxQkMCERjCmL4cjyk2rKziyVtrbF2wr7owITZiOgDHkPQZrfJV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682918; c=relaxed/simple;
	bh=X/uEqX8d5ctnkJv/FABNLg5apQ6oMu+U9mqb8NW6oaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i4bJx9giC6w4yhzSE6+uSe20kcxG4hFgVfyYIV2Ip9fy0SQMwqMg1CfZQWrlNifw4NrOuqMKjxKPI+QfSThSmJge+/YYxBNB2n8sYQWwH2OTDT0lQ7OssZv3hym8WB6WsDvj+4zoLGMD/a2cxCDafbljGjq4pPc/T99tohKnHzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gOD3ruB8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gOD3ruB8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F7AC32781;
	Thu,  6 Jun 2024 14:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682918;
	bh=X/uEqX8d5ctnkJv/FABNLg5apQ6oMu+U9mqb8NW6oaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gOD3ruB8vjJV8kGkm7eS2GVBlzbmyQytgfuFGUnFxBFHQIlVJUa2AixsO6lnYpZls
	 MLfd6JUETlyNstfq53bPKkRpRozeJcbwyjjHDLljzkc6b0lE9WzQF2DkxLtlhYAO/y
	 v6YRPnxDyhbeHblCFAdsO/OxITsAxbryo4JAv6s0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	William Breathitt Gray <william.gray@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 012/374] counter: linux/counter.h: fix Excess kernel-doc description warning
Date: Thu,  6 Jun 2024 15:59:51 +0200
Message-ID: <20240606131652.174698138@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 702e9108bbb44..b767b5c821f58 100644
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



