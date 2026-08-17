Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84AB1271456;
	Mon, 17 Aug 2026 13:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974719; cv=none; b=oUyaP8G68MlIhruK+0rtlCo0RVdqmnebitxRnbktc+e/nX+hqQbGSKPgc0znkPaUv2tohzBZ4W2TaRvqwymir7H2RTP8jmMLyPcBgFjCkfRuMXCEqcSj4tr4r/qnltn1VDzqrgrHe09AK0tNRbjl1SJxtisMTCCgPrlWAukBCow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974719; c=relaxed/simple;
	bh=wkalbk9ISe/H7H+Cun7BAFvggag80eecYq7bMHpfh8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qNM3xpwApW4BInxt/dCMGbxkly+KNLMlv+6zKCSBePVSNxjng4bymHorCaqKFFfavW5i8O6T4HSkWFe4J9hQ4w807E5AHx3FHyTUcAvYWaemr1kkj21XhPQs8e+2YX2TUApRH+0qH0DB2QK1s1krcH7i2oFwjfYUF6oFTnAt47k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lAhYFY4X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lAhYFY4X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0873D1F00ACA;
	Mon, 17 Aug 2026 13:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974712;
	bh=2gzNqbow2+XPgHd9npQlXZHAG7M7Xp+P0dL7M22rzy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lAhYFY4XGw4geIiNxPOOND1+oHH2G6Y53RaOJagXPso04mJElvx7ahtzEQPrOChNh
	 b1hY3iRwtOMDKOVRDV9NXGzqW18AFAFk7T4rKMrha3WimjxI7E8wVWuJ0tOgB2+lR/
	 qRxWiztRG4iAg+DrU7smbMCl6rziU1D0zWFg4LNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	"=?UTF-8?q?Ricardo=20B . =20Marli=C3=A8re=20 ?=" <ricardo@marliere.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 005/250] selftests/bpf: Fail unbound UDP on sockmap update
Date: Mon, 17 Aug 2026 15:29:26 +0200
Message-ID: <20260817132536.684756034@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit 203b06932777b9ad5085319389dea566f5c2ca63 ]

sockmap now rejects unbound UDP sockets. Adjust test_maps. While at it,
check socket()'s return value.

This effectively reverts commit c39aa2159974 ("bpf, selftests: Fix
test_maps now that sockmap supports UDP").

Signed-off-by: Michal Luczaj <mhal@rbox.co>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/20260707-sockmap-lookup-udp-leak-v4-4-f878346f27ab@rbox.co
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Ricardo B. Marlière (SUSE) <ricardo@marliere.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_maps.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index 3fae9ce46ca9b..cea33b94d06f8 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -748,16 +748,15 @@ static void test_sockmap(unsigned int tasks, void *data)
 		goto out_sockmap;
 	}
 
-	/* Test update with unsupported UDP socket */
+	/* Test update with unsupported unbound UDP socket */
 	udp = socket(AF_INET, SOCK_DGRAM, 0);
-	i = 0;
-	err = bpf_map_update_elem(fd, &i, &udp, BPF_ANY);
-	if (err) {
-		printf("Failed socket update SOCK_DGRAM '%i:%i'\n",
-		       i, udp);
+	CHECK(udp < 0, "socket(AF_INET, SOCK_DGRAM)", "errno:%d\n", errno);
+	err = bpf_map_update_elem(fd, &(int){0}, &udp, BPF_ANY);
+	close(udp);
+	if (!err) {
+		printf("Unexpectedly succeeded unbound UDP update '0:%i'\n", udp);
 		goto out_sockmap;
 	}
-	close(udp);
 
 	/* Test update without programs */
 	for (i = 0; i < 6; i++) {
-- 
2.53.0



