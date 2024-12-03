Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FBD01F76C3;
	Tue,  3 Dec 2024 15:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238952; cv=none; b=s95JCL2tXUo5YiZOB/Q0wSuV3+AFkcsHJTugAX5U1I4eazNrEwE+atkyoVpn6RheLQWyRRAe1HLdA0JCkv8OyZ8PdTTCns+vqcqUKd8m9VcBb09TNobig3oZLPGVle2ZJaMNuAyJBoZyw9J5Lt0zAb6Pj2/DFJRLUZ+EGeTs094=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238952; c=relaxed/simple;
	bh=7uuhnjFi97tgybBbtyJNrqtIJPguL8hkHFeBui4lw1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AP4c/76ng3TKs7r/6htxynkCn26KTdtFETpY57SrwgdwkfQSrdenUL4ZTDdiFZnemq4gtEqLwwjnw/8s7FsQLlgO0TpfCZKNOKX3c6G4kM25sHkm2bL1LqFr2znpclYaesqQnEu4kd/tZ44JKA+AyLAyVb407V6ZUltmzr4Y95I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sst8mQ4N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sst8mQ4N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A985EC4CED8;
	Tue,  3 Dec 2024 15:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238952;
	bh=7uuhnjFi97tgybBbtyJNrqtIJPguL8hkHFeBui4lw1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sst8mQ4NbkP7zVuExCXMieu6IQs0+zimMN9VznPbjkSwuZu+pMabBuVJcNjUM8YvM
	 zmMALxXAsfB3d+KvEWliOOrDG5He7AZthdGpNP4+D7T5/YtxMSU4DObRTY5OvJhLKL
	 4cloVEoBl4QVZ7cydvEWzP8lykAYK1q94lmUCA0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	David Gow <davidgow@google.com>,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 454/817] kunit: skb: use "gfp" variable instead of hardcoding GFP_KERNEL
Date: Tue,  3 Dec 2024 15:40:26 +0100
Message-ID: <20241203144013.597294189@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



