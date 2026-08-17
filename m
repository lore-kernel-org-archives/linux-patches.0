Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CAF42EEDD;
	Mon, 17 Aug 2026 14:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978388; cv=none; b=KNVn1hTpdhL8rst82IzCnaivBQCHQ1ASoROIl8KqUyxlDyaK0LByKZInk6VcEqwd1QTgZ0J2AR/BhSceCBde/ncua7fqx7qaPqioib7kJwQD1b0DZsi50zuQLZsOdd1O5kFgFFmaJIAojdCt65luLBvodTjb9tMhowyYOBNgFw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978388; c=relaxed/simple;
	bh=acoP/PCJ4Ykrki3/Z03TU5YBmAE5Ifm1jYvMa5clQGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iGJbKLnKDmiDSgDAcwz3FHPXdxIfRbYbrsRF1mSZdA1LycniH4a43qmGDsGnmHjvbyA6wTX2FZ68L2mtHUw3csGZ2d/0RpBbtN7soEAvedtS69wLxmGi9CFMZsEVQ+DSD7v9YFhyQTGcNqpYGSvnqINzOUBdXjzQ0eLaDk/zfCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kynh0ZEK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kynh0ZEK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E731F000E9;
	Mon, 17 Aug 2026 14:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978387;
	bh=YK21xZUT5T1YeyDq8GFkmSBSvAmtSub7ct/n8Pd0Hbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kynh0ZEKin0gLnjUV8rvvb3psIXyjAMDizH2KmT+iHLGwCHN7Hi1iLWsz/Jp50jDN
	 BzHRw5TcV2yS4qrXQs/2rwQReuF4eaB4uznjjhUnIKvgbbVczzEUqECw9g2a5Wdfpk
	 2wtMOVU04aobsNCycVPbNjop7Sob2LFT4ftrglrU=
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
Subject: [PATCH 6.6 002/156] selftests/bpf: Fail unbound UDP on sockmap update
Date: Mon, 17 Aug 2026 15:32:16 +0200
Message-ID: <20260817132534.760320046@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e0dd101c9f2bd..f2a27143edc34 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -752,16 +752,15 @@ static void test_sockmap(unsigned int tasks, void *data)
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



