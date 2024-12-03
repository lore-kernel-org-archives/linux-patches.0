Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094541F75BC;
	Tue,  3 Dec 2024 15:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241496; cv=none; b=fY6brbvJ0/Fc48+flBkyrAuQNc3r31RUZYX2UMmKLYSMHwByAMjn2pKmVqKBjqAKrC0ZDEmfo7utPvjoe6fDFM7dCtK4Q/SJG54Xp7YjnYBpiamdOXZoaR/qVPruxfZO5PbmMtnGR4svPeM7W3/UFWLv78AAPNp9aMfZNvcGaEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241496; c=relaxed/simple;
	bh=hicsg4V3LFC53vfvk2nANKOiDSjrH0jBBjgWnuydvjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nBzlM8NtxPuXnwNOayNMBKrghR/M0idWQ1yqnsTUuBRoGoWhY2iv+XOu21AzTa1JSDn6laupKrjh98yCL8z7UvIlSLS9tYF0gWak4nXhJ69N2Xq7ghiIsAvUfcisPWUt7jSDmW0NNhWw26mkXA8WbShSg2W/uq9s6hW0BGpx+3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V+b2n6jg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V+b2n6jg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D1BC4CECF;
	Tue,  3 Dec 2024 15:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241495;
	bh=hicsg4V3LFC53vfvk2nANKOiDSjrH0jBBjgWnuydvjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V+b2n6jgY2RFT0N+2FjRLN1lPXyjganFA2mgHKDzY+dEWeZWDm9V44PDf64FWgh98
	 gZ/Vjzg7PV12pDz0hvzGE9ldbyPwso3y7CmP+mKelfH/g6/317Ylst3mkrnJsuI5S2
	 bWNEkjtD9Kr8b7Yq5+2sYJBclCxq91khGODR1QIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	David Gow <davidgow@google.com>,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 434/826] kunit: skb: use "gfp" variable instead of hardcoding GFP_KERNEL
Date: Tue,  3 Dec 2024 15:42:41 +0100
Message-ID: <20241203144800.692979615@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit fd0a5afb5455b4561bfc6dfb0c4b2d8226f9ccfe ]

The intent here was clearly to use the gfp variable flags instead of
hardcoding GFP_KERNEL.  All the callers pass GFP_KERNEL as the gfp
flags so this doesn't affect runtime.

Fixes: b3231d353a51 ("kunit: add a convenience allocation wrapper for SKBs")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: David Gow <davidgow@google.com>
Reviewed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/kunit/skbuff.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/kunit/skbuff.h b/include/kunit/skbuff.h
index 44d12370939a9..345e1e8f03123 100644
--- a/include/kunit/skbuff.h
+++ b/include/kunit/skbuff.h
@@ -29,7 +29,7 @@ static void kunit_action_kfree_skb(void *p)
 static inline struct sk_buff *kunit_zalloc_skb(struct kunit *test, int len,
 					       gfp_t gfp)
 {
-	struct sk_buff *res = alloc_skb(len, GFP_KERNEL);
+	struct sk_buff *res = alloc_skb(len, gfp);
 
 	if (!res || skb_pad(res, len))
 		return NULL;
-- 
2.43.0



