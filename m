Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BC3317144;
	Mon, 17 Aug 2026 13:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975132; cv=none; b=bvzntsMOM4dJyRaXs4TvegHgi4bXjI2EKLNONj34oWrqqzk5aNCiHq2/jECTzzNDeUb+T05Z1oC+bRC/dUNU1QMS4xzGtfTSgeAR9A4MnOuv0eizd9qaZikJN9I8L4deyWV/cizOBsv3vtEgDcHI6cSV3PTIyPv0CIDKurGm28c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975132; c=relaxed/simple;
	bh=YSLh7I2/HjMEXFOGsEM9XLZeEPwf4hysO/YKLpt/xrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QsJGIP4pwoqZd4mN3B4FLqIbUD8kRH4oWUTAQP6xD3+NFF8112Tf7Tp61SgxiEfL3EWYFVHl7zGwLrdA5iZBpPfi+AANnDB9JqDKZDt1in3x36xjQgc05sqxtFnKZA9i1Tf7J0/+3JGJ9798bO+C+hMgD4nU9yx3m8MFfxOnb7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ycrogk+t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ycrogk+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607841F000E9;
	Mon, 17 Aug 2026 13:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975130;
	bh=FWBjN3pULYShgefo6uzzxmVlnTK0aR6gIlbGXyLrZvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ycrogk+tjlzhh3igM1+cmODAFZVI1KgwneTBOHf4LsU3yvubMo24stZM8tIii+YDh
	 /x5b/h5225YsP/XwMpEGnakdN53/45/PsV08ycrqXcPwk4NxgYLXK7S4H6QzXljeRM
	 7olaQtZ1HtYBszVoSX4QMBoFcwTORRCyjbfov1YQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 156/250] selftests/bpf: Ensure UDP sockets are bound
Date: Mon, 17 Aug 2026 15:31:57 +0200
Message-ID: <20260817132542.930308880@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit fe3ff273767ef22fe8a7cb3816f264927c190e50 ]

Update sockmap_basic tests to bind sockets before they are used. This
accommodates the recent change in sockmap that rejects unbound UDP sockets.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/20260707-sockmap-lookup-udp-leak-v4-1-f878346f27ab@rbox.co
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/sockmap_basic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
index 1e3e4392dcca0..54fd84203dc2b 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
@@ -786,7 +786,7 @@ static void test_sockmap_many_socket(void)
 		return;
 	}
 
-	udp = xsocket(AF_INET, SOCK_DGRAM | SOCK_NONBLOCK, 0);
+	udp = socket_loopback(AF_INET, SOCK_DGRAM | SOCK_NONBLOCK);
 	if (udp < 0) {
 		close(dgram);
 		close(tcp);
@@ -855,7 +855,7 @@ static void test_sockmap_many_maps(void)
 		return;
 	}
 
-	udp = xsocket(AF_INET, SOCK_DGRAM | SOCK_NONBLOCK, 0);
+	udp = socket_loopback(AF_INET, SOCK_DGRAM | SOCK_NONBLOCK);
 	if (udp < 0) {
 		close(dgram);
 		close(tcp);
@@ -926,7 +926,7 @@ static void test_sockmap_same_sock(void)
 		return;
 	}
 
-	udp = xsocket(AF_INET, SOCK_DGRAM | SOCK_NONBLOCK, 0);
+	udp = socket_loopback(AF_INET, SOCK_DGRAM | SOCK_NONBLOCK);
 	if (udp < 0) {
 		close(dgram);
 		close(tcp);
-- 
2.53.0



