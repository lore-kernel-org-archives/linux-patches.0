Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCF61D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CXylN54x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FBF8C433CC;
	Wed,  4 Oct 2023 18:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443837;
	bh=CxO1MQH/F0AL/ksyccRvd4u6OjccmWJtxgJMyplXb4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CXylN54xUL1bdwVhR1a8NaN2NBg19s3A73xtTdJEFniJaFkgcmFQUo1DxrHs7X3Lr
	 stJtiTj3oy+HAVZo02+IUbtW7jAX4XR1uO8gzv0RdW7KZBxQJOE1LVlMa8y3DRB5Pr
	 g7KrX1z/Oosav4kjD5x5aAK2h6dXdOmUJ6mHu5yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Savkov <asavkov@redhat.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 038/321] selftests/bpf: fix unpriv_disabled check in test_verifier
Date: Wed,  4 Oct 2023 19:53:03 +0200
Message-ID: <20231004175230.926948469@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Savkov <asavkov@redhat.com>

[ Upstream commit d128860dbb29cafc3c65ca2d22082745a32829dd ]

Commit 1d56ade032a49 changed the function get_unpriv_disabled() to
return its results as a bool instead of updating a global variable, but
test_verifier was not updated to keep in line with these changes. Thus
unpriv_disabled is always false in test_verifier and unprivileged tests
are not properly skipped on systems with unprivileged bpf disabled.

Fixes: 1d56ade032a49 ("selftests/bpf: Unprivileged tests for test_loader.c")
Signed-off-by: Artem Savkov <asavkov@redhat.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20230912120631.213139-1-asavkov@redhat.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_verifier.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 31f1c935cd07d..98107e0452d33 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -1880,7 +1880,7 @@ int main(int argc, char **argv)
 		}
 	}
 
-	get_unpriv_disabled();
+	unpriv_disabled = get_unpriv_disabled();
 	if (unpriv && unpriv_disabled) {
 		printf("Cannot run as unprivileged user with sysctl %s.\n",
 		       UNPRIV_SYSCTL);
-- 
2.40.1



